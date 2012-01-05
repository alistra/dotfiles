call pathogen#infect()
syntax on

set autoread
set backspace=indent,eol,start
set backup
set backupdir=~/.vim/backup
set dictionary+=/usr/share/dict/*
set diffopt=filler
set diffopt+=icase
set diffopt+=iwhite
set encoding=utf-8
set foldmethod=marker
set guioptions-=T
set ignorecase
set incsearch
set modeline
set nohls
set number
set scrolloff=10
set showcmd
set showmatch
set showmode
set smartcase
set smartindent
set ttyfast
set undodir=~/.vim/undo
set undofile
let mapleader='\'

nmap <leader>n :cnext<CR>
vmap <leader>n :cnext<CR>
nmap <leader>p :cprev<CR>
vmap <leader>p :cprev<CR>
nmap <leader>g :cc<CR>
vmap <leader>g :cc<CR>

nmap <leader>t :NERDTree<CR>
vmap <leader>t :NERDTree<CR>

nmap <leader>f :CommandT<CR>
vmap <leader>f :CommandT<CR>

nmap <Leader>p :set paste!<CR>
vmap <Leader>p :set paste!<CR>
"let g:clang_complete_copen = 1
"let g:clang_periodic_quickfix = 1

let g:haddock_browser = "xxxterm"

set wildmode=list:longest
set wildmenu
set wildignore+=*.o,*.obj,*.jpg,*.png,*.pdf,*.JPG,*.gz,*.dat,*.ps,*.djvu,*.bz2,*.tar,*.ppt,*.dvi,*.doc,*.tif,*.eps,*.gif,*.jpeg,*.hi,*.a,*.mp[34]

autocmd Filetype c        set tabstop=8|set shiftwidth=8|compiler clang|set makeprg=clang\ -Wall\ %<.c
autocmd Filetype cpp      set tabstop=8|set shiftwidth=8|compiler clang|set makeprg=clang++\ -Wall\ %<.cpp
autocmd FileType python   set tabstop=4|set shiftwidth=4|set expandtab|set sts=4
autocmd FileType ruby     set tabstop=2|set shiftwidth=2|set expandtab|set sts=2|compiler ruby
autocmd FileType ocaml    set tabstop=4|set shiftwidth=4|set expandtab|set sts=4
autocmd FileType haskell  set tabstop=4|set shiftwidth=4|set expandtab|set sts=4|compiler ghc
autocmd Bufenter *.cabal  set tabstop=4|set shiftwidth=4|set expandtab|set sts=4

filetype plugin on
filetype indent on

if has("autocmd")
  if v:version > 701
    highlight Todo ctermbg=green guibg=green
    autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|HMMM\|FIXME\|BUG\|HACK\|STUB\|undefined\)')
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd Syntax * call matchadd('ExtraWhitespace', '\s\+$')
  endif
endif

colorscheme understated

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
