"
" =================  Lucida's Neovim configuration  ================
" Minimum Neovim Version: 0.12
"
" Plugin installation is managed by Neovim's built-in vim.pack.
lua require('plugin')

lua vim.o.exrc=true

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
noremap <silent><F3> :<C-U>NvimTreeFindFileToggle<CR>

" ------------------------------  neovide
let g:neovide_refresh_rate=144
let g:neovide_transparency=0.9
set guifont=Hack\ Nerd\ Font:h16

" LOADING CONFIGURATION WRITTEN IN LUA "
lua require('config')       -- global configuration
lua require("utils")
lua require('lspconfigcfg')
" lua require('nvimcmpcfg')
lua require('blinkcmpcfg')
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
lua require('spectrecfg')
lua require('nvimbqfcfg')
lua require'colorizer'.setup()
lua require('rustaceanvimcfg')
lua require('aerialcfg')
lua require('replcfg')
lua require('plugins.repl')
lua require('plugins.memo').setup()
