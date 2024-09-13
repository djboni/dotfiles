" - [How to Do 90% of What Plugins Do (With Just Vim)](https://www.youtube.com/watch?v=XA2WjJbmmoM)
" - [Highlight line 80](https://gist.github.com/jphenow/4437248)

" Basic setup
set mouse=a
set nocompatible
syntax enable
filetype plugin indent on

" Indentation
set tabstop=4    " Show existing tab with 4 spaces width
set shiftwidth=4 " When indenting with '>', use 4 spaces width
set expandtab    " On pressing tab, insert 4 spaces

" Line numbers
set number
set relativenumber

" Improve highlight
"highlight Visual term=reverse cterm=reverse ctermbg=NONE ctermfg=NONE
highlight Visual term=reverse cterm=reverse ctermbg=NONE ctermfg=Blue
highlight Search term=reverse cterm=reverse ctermbg=NONE ctermfg=Yellow
highlight ColorColumn ctermbg=DarkGray ctermfg=NONE

" Highlight columns
set colorcolumn=80

" Search
" Incremental search
set incsearch
" Search with highlight
set hlsearch
" Double ESC clears search highlights
nnoremap <ESC><ESC> :silent! nohls<cr>

" Open on the last edited line
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Fuzzy file search
"set path+=**
set path=**
set wildmenu

" File browsing
let g:netrw_banner=0       " Disable banner
let g:netrw_browse_split=4 " Open in prior window
let g:netrw_altv=1         " Open splits to the right
let g:netrw_liststyle=3    " Tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S\+'

" Remap Ctrl+S -> Save
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" Remap kj -> ESC
inoremap kj <ESC>
