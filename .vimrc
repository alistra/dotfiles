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

let mapleader='\'

" quickfix maps
nmap <leader>n :cnext<CR>
nmap <leader>p :cprev<CR>
nmap <leader>l :cc<CR>
vmap <leader>n :cnext<CR>
vmap <leader>p :cprev<CR>
vmap <leader>l :cc<CR>

" 2 compilers for haskell

vmap <leader>h :compiler hlint<CR>:make<CR>
nmap <leader>h :compiler hlint<CR>:make<CR>
vmap <leader>g :compiler ghc<CR>:make<CR>
nmap <leader>g :compiler ghc<CR>:make<CR>

" detect indent


" command-t ignores
set wildignore+=*.o,*.obj,*.jpg,*.png,*.pdf,*.JPG,*.gz,*.dat,*.ps,*.djvu,*.bz2,*.tar,*.ppt,*.dvi,*.doc,*.tif,*.eps,*.gif,*.jpeg

colorscheme darkblue 

autocmd FileType python   set tabstop=4|set shiftwidth=4|set expandtab|set sts=4|compiler pylint
autocmd FileType ruby     set tabstop=2|set shiftwidth=2|set expandtab|set sts=2|compiler ruby
autocmd FileType haskell  set tabstop=4|set shiftwidth=4|set expandtab|set sts=4|compiler ghc

filetype plugin on
filetype indent on
" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
