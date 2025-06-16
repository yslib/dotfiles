"
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

Plug 'nvim-lua/plenary.nvim'                                   " lua utils
Plug 'stevearc/dressing.nvim'                                  " ui enhencement
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'kyazdani42/nvim-web-devicons'                            " for file icons
Plug 'kyazdani42/nvim-tree.lua'                                " file explorer
Plug 'nvim-telescope/telescope.nvim'                           " picker framework
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-neotest/nvim-nio'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'nvim-lualine/lualine.nvim'                               " status line
Plug 'numToStr/Comment.nvim'                                   " code comment/uncomment
Plug 'windwp/nvim-autopairs'                                   " auto pairs
Plug 'mhartington/formatter.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}    " syntax based hightlighting
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'hood/popui.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'kdheepak/lazygit.nvim'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}                   " color theme 
Plug 'xiyaowong/transparent.nvim'                              " transparent background
Plug 'sindrets/diffview.nvim'                                  " diff view
Plug 'hrsh7th/cmp-nvim-lsp'                                    " the following plugins  related to completion
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th//cmp-nvim-lsp-document-symbol'


Plug 'norcalli/nvim-colorizer.lua' " copilot
Plug 'zbirenbaum/copilot.lua'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main' }

Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-pack/nvim-spectre'
Plug 'kevinhwang91/nvim-bqf'

" vim plug
Plug 'tpope/vim-surround'                                      " vim-surround
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
" Initialize plugin system
call plug#end()

"tab as 4 spaces
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces

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

" Example config in Vim-Script

" -------------------- vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" -------------------- lazygit.nvim
nnoremap <silent> <leader>g :LazyGit<CR>

" ------------------------------  nvim-tree
noremap <silent><F3> :<C-U>NvimTreeToggle<CR>

" ------------------------------  neovide
let g:neovide_refresh_rate=144
let g:neovide_transparency=0.9
set guifont=Hack\ Nerd\ Font:h16

" LOADING CONFIGURATION WRITTEN IN LUA "
lua require('config')       -- global configuration
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
lua require('toggletermcfg')
lua require('formattercfg')
lua require('dresscfg')
lua require('bufferlinecfg')
lua require("catppuccincfg")
lua require('nvimdapcfg')
lua require('masonlspcfg')
lua require('transparentcfg')
lua require('copilotcfg')
lua require('copilotchatcfg')
lua require('spectrecfg')

lua require'colorizer'.setup()
