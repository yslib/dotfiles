local function github(repository)
    return "https://github.com/" .. repository
end

local plugins = {
    -- Utils
    github("nvim-lua/plenary.nvim"),
    github("kyazdani42/nvim-web-devicons"),
    github("catgoose/nvim-colorizer.lua"),

    -- Themes
    { src = github("catppuccin/nvim"), name = "catppuccin" },
    github("xiyaowong/transparent.nvim"),

    -- UI enhancements
    { src = github("akinsho/bufferline.nvim"), version = vim.version.range("*") },
    github("nvim-lualine/lualine.nvim"),
    github("MunifTanjim/nui.nvim"),
    github("hood/popui.nvim"),
    github("stevearc/dressing.nvim"),
    github("rcarriga/nvim-notify"),
    github("kevinhwang91/nvim-bqf"),

    -- Treesitter and completion
    github("nvim-treesitter/nvim-treesitter"),
    { src = github("saghen/blink.cmp"), version = vim.version.range("1.*") },
    github("rafamadriz/friendly-snippets"),

    -- DAP
    github("mfussenegger/nvim-dap"),
    github("rcarriga/nvim-dap-ui"),
    github("theHamsta/nvim-dap-virtual-text"),

    -- LSP
    github("mrcjkb/rustaceanvim"),
    github("stevearc/aerial.nvim"),

    -- Mason
    github("williamboman/mason.nvim"),
    github("williamboman/mason-lspconfig.nvim"),

    -- Picker
    github("nvim-telescope/telescope.nvim"),
    github("nvim-telescope/telescope-ui-select.nvim"),
    github("nvim-telescope/telescope-live-grep-args.nvim"),
    github("nvim-telescope/telescope-fzf-native.nvim"),

    -- Terminals
    github("akinsho/toggleterm.nvim"),

    -- File explorer
    github("kyazdani42/nvim-tree.lua"),

    -- Tool integrations
    github("MeanderingProgrammer/render-markdown.nvim"),
    github("kdheepak/lazygit.nvim"),
    github("sindrets/diffview.nvim"),
    github("nvim-pack/nvim-spectre"),
    github("numToStr/Comment.nvim"),
    github("windwp/nvim-autopairs"),
    github("mhartington/formatter.nvim"),
    github("nvim-neotest/nvim-nio"),

    -- AI tools
    github("zbirenbaum/copilot.lua"),

    -- Lisp
    github("eraserhd/parinfer-rust"),

    -- Vim plugins
    github("tpope/vim-surround"),
    github("tpope/vim-fugitive"),
    github("mbbill/undotree"),
    github("junegunn/gv.vim"),
    github("junegunn/vim-easy-align"),
    github("easymotion/vim-easymotion"),
}

local function run(command, cwd)
    local result = vim.system(command, { cwd = cwd, text = true }):wait()
    if result.code == 0 then
        return
    end

    local output = vim.trim(result.stderr or "")
    if output == "" then
        output = vim.trim(result.stdout or "")
    end

    error(("command failed (%s): %s%s"):format(
        result.code,
        table.concat(command, " "),
        output == "" and "" or "\n" .. output
    ))
end

local function load_plugin(event)
    if not event.active then
        vim.cmd.packadd(event.spec.name)
    end
end

local build_hooks = {
    ["nvim-treesitter"] = function(event)
        load_plugin(event)
        vim.cmd.TSUpdate()
    end,
    ["mason.nvim"] = function(event)
        load_plugin(event)
        vim.cmd.MasonUpdate()
    end,
    ["telescope-fzf-native.nvim"] = function(event)
        run({ "cmake", "-S.", "-Bbuild", "-DCMAKE_BUILD_TYPE=Release" }, event.path)
        run({ "cmake", "--build", "build", "--config", "Release" }, event.path)
        run({ "cmake", "--install", "build", "--prefix", "build" }, event.path)
    end,
    ["parinfer-rust"] = function(event)
        run({ "cargo", "build", "--release" }, event.path)
    end,
}

vim.api.nvim_create_autocmd("PackChanged", {
    desc = "Run plugin build hooks after installation or update",
    callback = function(event)
        if event.data.kind ~= "install" and event.data.kind ~= "update" then
            return
        end

        local hook = build_hooks[event.data.spec.name]
        if hook then
            hook(event.data)
        end
    end,
})

vim.pack.add(plugins, {
    confirm = false,
    load = true,
})
