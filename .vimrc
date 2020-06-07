let g:powerline_pycmd="py3"

" enable syntax highlighting
syntax enable

" clipboard
set clipboard=unnamed

" encoding
set encoding=UTF-8

" show line numbers
set number

" set tabs to have 4 spaces
set ts=4

" indent when moving to the next line while writing code
set autoindent

" expand tabs into spaces
set expandtab

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4

" show a visual line under the cursor's current line
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" wildmenu
set wildmenu

" search better
set incsearch

" enable all Python syntax highlighting features
let python_highlight_all = 1
syntax on

" mapleader
let mapleader = ","

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" tab and indentation for .py files
au BufNewFile,BufRead *.py
    \ set tabstop=4
"    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" tab for frontend
autocmd BufRead,BufNewFile *.htm,*.html,*.jinja setlocal tabstop=2 shiftwidth=2 softtabstop=2

" nasm for *asm
autocmd BufNewFile,BufRead *.asm set filetype=nasm

"" marks whitespaces
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" tab moves
map <C-T>h :tabp<cr>
map <C-T>l :tabn<cr>
map <C-T>c :tabc<cr>
map <C-T>n :tabnew<cr>

" change splits by c-[hjkl]
nnoremap <C-J> <C-W><C-J>
nnoremap <C-L> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>




" ---------VUNDLE-----------

set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/vundle_plugins')

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Bundle 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'jiangmiao/auto-pairs'
Bundle 'lepture/vim-jinja'
Plugin 'jvanja/vim-bootstrap4-snippets'
Plugin 'mattn/emmet-vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'dense-analysis/ale'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required



" ---------VUNDLE PREFERENCES--------

" allow to preview docstrings when folded
let g:SimpylFold_docstring_preview=1

" YouCompliteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" nerdtree execute
map <leader>t :NERDTree<CR>

" powerline
"python3 from powerline.vim import setup as powerline_setup
"python3 powerline_setup()
"python3 del powerline_setup
set laststatus=2
set showtabline=2
set noshowmode
set t_Co=256
