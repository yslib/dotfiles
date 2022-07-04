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
Plug 'kyazdani42/nvim-web-devicons'                            " for file icons
Plug 'kyazdani42/nvim-tree.lua'                                " file explorer
Plug 'romgrk/barbar.nvim'                                      " tabline
Plug 'nvim-lualine/lualine.nvim'                               " status line
Plug 'numToStr/Comment.nvim'                                   " code comment/uncomment
Plug 'windwp/nvim-autopairs'                                   " auto pairs
Plug 'tpope/vim-surround'                                      " vim-surround
Plug 'mhartington/formatter.nvim'
Plug 'jacobsimpson/nvim-example-python-plugin'
Plug 'akinsho/toggleterm.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}    " syntax based hightlighting
Plug 'neovim/nvim-lspconfig'                                   " builtin lsp for neovim
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neorg/neorg'
Plug 'RishabhRD/popfix'
Plug 'hood/popui.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'                           " picker framework
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'simrat39/rust-tools.nvim'                                " an easy-to-use rust tools based on rust-analyzer, if you use debuggin features, codelldb is required
Plug 'sainnhe/sonokai'                                         " color themes
Plug 'sainnhe/edge'                                            " color themes
Plug 'whatsthatsmell/codesmell_dark.vim'                       " color theme
Plug 'sindrets/diffview.nvim'                                  " diff view
Plug 'puremourning/vimspector'                                 " a powerful debug tui
Plug 'mbbill/undotree'
Plug 'glepnir/dashboard-nvim'
Plug 'stevearc/aerial.nvim'                                    " outline
Plug 'hrsh7th/cmp-nvim-lsp'                                    " the following plugins are related to completion
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/nvim-cmp'
" Initialize plugin system
call plug#end()

"sonokai theme
" Important!!
if has('termguicolors')
 set termguicolors
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"line number settings
set nu
augroup relative_numbser
 autocmd!
 autocmd InsertEnter * :set norelativenumber
 autocmd InsertLeave * :set relativenumber
augroup END

syntax enable
set updatetime=300

set nowrap

" display white space, \\u0387 for center dot
" h listchars for format specification
set list listchars=tab:\|\ ,trail:\\u0387

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
" let g:edge_transparent_background = 1
" let g:edge_spell_foreground = 1
" let g:edge_diagnostic_text_highlight = 1
" let g:edge_current_word = 'bold'
" colorscheme edge
"
colorscheme codesmell_dark
"
" --------------------------   barbar.nvim
" Move to previous/next
" nnoremap <silent>    <A-,> :BufferPrevious<CR>
" nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
" nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
" nnoremap <silent>    <A->> :BufferMoveNext<CR>
" Goto buffer in position...
"
nnoremap <silent>    <leader>1 :BufferGoto 1<CR>
nnoremap <silent>    <leader>2 :BufferGoto 2<CR>
nnoremap <silent>    <leader>3 :BufferGoto 3<CR>
nnoremap <silent>    <leader>4 :BufferGoto 4<CR>
nnoremap <silent>    <leader>5 :BufferGoto 5<CR>
nnoremap <silent>    <leader>6 :BufferGoto 6<CR>
nnoremap <silent>    <leader>7 :BufferGoto 7<CR>
nnoremap <silent>    <leader>8 :BufferGoto 8<CR>
nnoremap <silent>    <leader>9 :BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    <C-w><C-p> :BufferPin<CR>
" Close buffer
nnoremap <silent>    <C-w><C-b> :BufferClose<CR>
" Wipeout buffer
"                          :BufferWipeout<CR>
" Close commands
"                          :BufferCloseAllButCurrent<CR>
"                          :BufferCloseAllButPinned<CR>
"                          :BufferCloseBuffersLeft<CR>
"                          :BufferCloseBuffersRight<CR>
" Magic buffer-picking mode
nnoremap <silent> <C-s>    :BufferPick<CR>
" Sort automatically by...
nnoremap <silent> <Space>bb :BufferOrderByBufferNumber<CR>
nnoremap <silent> <Space>bd :BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl :BufferOrderByLanguage<CR>
nnoremap <silent> <Space>bw :BufferOrderByWindowNumber<CR>


" ------------------------------  nvim.telescope:  telescope.nvim must be installed and for the advanced features, ripgrep is needed.
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>


" ------------------------------  nvim-tree
noremap <silent><F3> :<C-U>NvimTreeToggle<CR>

" ------------------------------  floaterm
" let g:floaterm_keymap_toggle = '<F7>'

" ------------------------------ toggleterm
noremap <F7> <cmd>ToggleTerm direction=float<cr>

" ------------------------------  vimspector
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

" ------------------------------  neovide
let g:neovide_refresh_rate=144
let g:neovide_transparency=0.8
set guifont=Hack\ Nerd\ Font

" LOADING CONFIGURATION WRITTEN IN LUA "
lua require("utils")
lua require('aerialcfg')
lua require('config')
lua require('nvimtreecfg')
lua require('lualspcfg')
lua require('diffviewcfg')
lua require('autopairs')
lua require('lualinecfg')
lua require('neorgcfg')
lua require('treesittercfg')
lua require('telescopecfg')
lua require('dashboardcfg')
lua require('toggletermcfg')
lua require('formattercfg')
