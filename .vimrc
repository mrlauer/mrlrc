set rtp+=$GOROOT/misc/vim
set rtp+=$HOME/vimplugins/vim-coffee-script
set rtp+=$HOME/vimplugins/vim-scala
set rtp+=$LILYROOT/share/lilypond/current/vim
filetype on
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

se softtabstop=4
se expandtab

if has("autocmd")
    " If the filetype is Makefile then we need to use tabs
    " So do not expand tabs into space.
    autocmd FileType make   set noexpandtab
    autocmd FileType make   set softtabstop=8
endif

se shiftwidth=4
se autoindent
se smartindent
if has("gui_macvim")
    se guifont=DejaVu\ Sans\ Mono:h12
else
    se guifont=DejaVu\ Sans\ Mono\ 10
endif
syntax on
se encoding=utf-8
se ruler

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

se ignorecase
se smartcase
:nmap <Esc><Esc> :nohlsearch<CR>
