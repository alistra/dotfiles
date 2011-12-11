call pathogen#infect()
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
set scrolloff=10
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

nmap <leader>n :cnext<CR>
vmap <leader>n :cnext<CR>
nmap <leader>p :cprev<CR>
vmap <leader>p :cprev<CR>
nmap <leader>g :cc<CR>
vmap <leader>g :cc<CR>

nmap <leader>t :NERDTree<CR>
vmap <leader>t :NERDTree<CR>

nmap <leader>f :FufCoverageFile<CR>
vmap <leader>f :FufCoverageFile<CR>

let g:clang_complete_copen = 1
let g:clang_periodic_quickfix = 1

let g:haddock_browser = "xxxterm"

set wildignore+=*.o,*.obj,*.jpg,*.png,*.pdf,*.JPG,*.gz,*.dat,*.ps,*.djvu,*.bz2,*.tar,*.ppt,*.dvi,*.doc,*.tif,*.eps,*.gif,*.jpeg

autocmd Filetype c        set tabstop=8|set shiftwidth=8|compiler clang|set makeprg=clang\ -Wall\ %<.c
autocmd Filetype cpp      set tabstop=8|set shiftwidth=8|compiler clang|set makeprg=clang++\ -Wall\ %<.cpp
autocmd FileType python   set tabstop=4|set shiftwidth=4|set expandtab|set sts=4
autocmd FileType ruby     set tabstop=2|set shiftwidth=2|set expandtab|set sts=2|compiler ruby
autocmd FileType ocaml    set tabstop=4|set shiftwidth=4|set expandtab|set sts=4
autocmd FileType haskell  set tabstop=4|set shiftwidth=4|set expandtab|set sts=4|compiler ghc
autocmd Bufenter *.cabal  set tabstop=4|set shiftwidth=4|set expandtab|set sts=4

filetype plugin on
filetype indent on

" au ColorScheme *

if has("autocmd")
  if v:version > 701
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|HMMM\|FIXME\|BUG\|HACK\|STUB\)')
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd Syntax * call matchadd('ExtraWhitespace', '\s\+$')
  endif
endif


" colorscheme understated
" set background=dark
" colorscheme solarized

set laststatus=2
set statusline=%f
set statusline+=%m
set statusline+=%r
set statusline+=%w
set statusline+=%=
set statusline+=[%{strlen(&fenc)?&fenc:&enc}
set statusline+=/
set statusline+=%{&ft}
set statusline+=]
set statusline+=\ [line\ %l\/%L,\ col\ %03c]

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
