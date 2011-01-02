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
set foldmethod=marker
set commentstring="%s"
set undofile
set undodir=~/.vim/undo
colorscheme darkblue 
autocmd FileType python set tabstop=2|set shiftwidth=2|set expandtab|set sts=2 
autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab|set sts=2 
autocmd FileType c set tabstop=4|set shiftwidth=4|set expandtab|set sts=4 
filetype plugin on
filetype indent on
"Zdalne sesje - kolor
if &term == "xterm-color"
	set t_kb
	fixdel
endif
" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
