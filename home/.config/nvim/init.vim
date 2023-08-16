" =================  Lucida's Neovim configuration  ================
" Minimum Neovim Version: 0.8
" You need to download vim-plug from https://github.com/junegunn/vim-plug to
" boostrap for the first time, and then you need to run :PlugInstall in Neovim 
" to install the following plugins. Some plugins has their own dependencies 
" which could be install by provided commands, or binarys that should be 
" install manually.
"
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data').'/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
"

Plug 'nvim-lua/plenary.nvim'                                   " lua utils
Plug 'folke/neodev.nvim'                                       " type check
Plug 'stevearc/dressing.nvim'                                  " ui enhencement
Plug 'neovim/nvim-lspconfig'                                   " builtin lsp for neovim
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'kyazdani42/nvim-web-devicons'                            " for file icons
Plug 'kyazdani42/nvim-tree.lua'                                " file explorer
Plug 'nvim-telescope/telescope.nvim'                           " picker framework
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'nvim-lualine/lualine.nvim'                               " status line
Plug 'numToStr/Comment.nvim'                                   " code comment/uncomment
Plug 'windwp/nvim-autopairs'                                   " auto pairs
Plug 'mhartington/formatter.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'                         " linter 
Plug 'akinsho/toggleterm.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}    " syntax based hightlighting
Plug 'RishabhRD/popfix'
Plug 'hood/popui.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'simrat39/symbols-outline.nvim'                           " symbols-outline
Plug 'simrat39/rust-tools.nvim'                                " an easy-to-use rust tools based on rust-analyzer, if you use debuggin features, codelldb is required

Plug 'Shatur/neovim-session-manager'
Plug 'sainnhe/sonokai'                                         " color theme
Plug 'sainnhe/edge'                                            " color theme
Plug 'whatsthatsmell/codesmell_dark.vim'                       " color theme
Plug 'catppuccin/nvim', {'as': 'catppuccin'}                   " color theme 
Plug 'xiyaowong/transparent.nvim'                              " transparent background
Plug 'stevearc/overseer.nvim'                                  " task runners
Plug 'sindrets/diffview.nvim'                                  " diff view
Plug 'mbbill/undotree'
Plug 'glepnir/dashboard-nvim'
Plug 'hrsh7th/cmp-nvim-lsp'                                    " the following plugins are related to completion
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/nvim-cmp'

" vim plug
Plug 'tpope/vim-surround'                                      " vim-surround
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
" Initialize plugin system
call plug#end()

"sonokai theme

"line number settings
set ts=4
set nu
augroup relative_numbser
 autocmd!
 autocmd InsertEnter * :set norelativenumber
 autocmd InsertLeave * :set relativenumber
augroup END

syntax enable
set updatetime=300

" set shellcmdflag=--noprofile\ --norc\ -c   " to avoid severe performace issue on some platform when using vim command

" display white space, \\u0387 for center dot
" h listchars for format specification
set list listchars=tab:\|\ ,trail:\\u0387

" ---------------- default colorscheme ----------------
" Important!!
" if exists('+termguicolors')
"   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"   set termguicolors
" endif

set termguicolors
" The configuration options should be placed before `colorscheme xxx`.

" let g:sonokar_style = 'andromeda'
" let g:sonokai_enable_italic = 1
" let g:sonokai_disable_italic_comment = 1
" colorscheme sonokai

" let g:edge_style = 'aura'
" let g:edge_better_performance = 1
" let g:edge_enable_italic = 1
" let g:edge_disable_italic_comment = 1
" let g:edge_dim_foreground = 0
" let g:edge_transparent_background = 0
" let g:edge_spell_foreground = 1
" let g:edge_diagnostic_text_highlight = 1
" let g:edge_current_word = 'bold'
" colorscheme edge
"
" colorscheme codesmell_dark

" -------------------------- neovim-session-manager
nnoremap <silent><leader>sl <Cmd>SessionManager load_session<CR>
nnoremap <silent><leader>sc <Cmd>SessionManager load_current_dir_session<CR>


" --------------------------   bufferline.nvim

nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
nnoremap <silent><leader>8 <Cmd>BufferLineGoToBuffer 8<CR>
nnoremap <silent><leader>9 <Cmd>BufferLineGoToBuffer 9<CR>


" ------------------------------  nvim.telescope:  telescope.nvim must be installed and for the advanced features, ripgrep is needed.
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>r <cmd>lua require('telescope.builtin').reloader()<cr>

nnoremap <leader>dh <cmd>lua require('dap.ui.variables').hover()<cr>
nnoremap <leader>dr <cmd>lua require('nvimdapcfg').reload_dap_config()<cr>
" nnoremap <leader>dv <cmd>lua require('dap.ui.variables').visual_hover()<cr>


" ------------------------------  nvim-tree
noremap <silent><F3> :<C-U>NvimTreeToggle<CR>

" ------------------------------  neovide
let g:neovide_refresh_rate=144
let g:neovide_transparency=0.9
set guifont=Hack\ Nerd\ Font:h16

" LOADING CONFIGURATION WRITTEN IN LUA "
lua require("utils")
lua require('lspconfigcfg')
lua require('nvimcmpcfg')
lua require('masoncfg')
lua require('nvimtreecfg')
lua require('commentcfg')
lua require('notifycfg')
lua require('diffviewcfg')
lua require('autopairs')
lua require('lualinecfg')
lua require('treesittercfg')
lua require('telescopecfg')
lua require('dashboardcfg')
lua require('toggletermcfg')
lua require('formattercfg')
lua require('dresscfg')
lua require('sessioncfg')
lua require('bufferlinecfg')
lua require("catppuccincfg")
lua require('nvimdapcfg')
lua require('masonlspcfg')
lua require('overseercfg')
lua require('symboloutlinecfg')
lua require('transparentcfg')
