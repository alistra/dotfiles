syntax on

set number     
set smartindent
set showmatch
set guioptions-=T
set nohls
set incsearch
set dictionary+=/usr/share/dict/*
set encoding=utf-8 
set ignorecase
set smartcase
set scrolloff=6
set modeline
set diffopt=filler
set diffopt+=iwhite
set diffopt+=icase
set backup
set backupdir=~/.vim/backup
set showcmd
set undofile
set undodir=~/.vim/undo
set foldmethod=marker
set backspace=indent,eol,start

colorscheme darkblue 

autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab|set sts=4 
autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab|set sts=2 
autocmd FileType haskell set tabstop=4|set shiftwidth=4|set expandtab|set sts=4

filetype plugin on
filetype indent on
" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
