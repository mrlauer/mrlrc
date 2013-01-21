set rtp+=$GOROOT/misc/vim
set rtp+=$HOME/vimplugins/vim-coffee-script
set rtp+=$HOME/vimplugins/vim-scala
filetype off
filetype on
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

se softtabstop=4
se expandtab
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
