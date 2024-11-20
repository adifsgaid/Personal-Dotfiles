" Basic Settings
set nocompatible              " Use Vim settings, rather than Vi settings
filetype plugin indent on     " Enable file type detection and do language-dependent indenting
syntax enable                 " Enable syntax highlighting
set encoding=utf-8           " Set default encoding to UTF-8

" Interface
set number                    " Show line numbers
set relativenumber           " Show relative line numbers
set ruler                    " Show cursor position
set wildmenu                " Visual autocomplete for command menu
set showmatch               " Highlight matching brackets
set laststatus=2           " Always show status line
set noshowmode             " Don't show mode (shown in status line)
set mouse=a                " Enable mouse support
set title                  " Show file title in terminal window
set cursorline             " Highlight current line

" Search
set incsearch              " Search as characters are entered
set hlsearch               " Highlight matches
set ignorecase            " Ignore case when searching
set smartcase             " When searching try to be smart about cases

" Indentation
set expandtab             " Use spaces instead of tabs
set smarttab              " Be smart when using tabs
set shiftwidth=4          " One tab == four spaces
set tabstop=4             " One tab == four spaces
set autoindent            " Auto indent
set smartindent           " Smart indent

" Text Rendering
set linebreak             " Break lines at word boundary
set scrolloff=3           " Keep 3 lines below and above cursor
set sidescrolloff=5       " Keep 5 columns to the left and right of cursor
set wrap                  " Wrap lines
set display+=lastline     " Always try to show a paragraph's last line

" Editor Behavior
set backspace=indent,eol,start  " Make backspace work as expected
set hidden                      " Allow switching buffers without saving
set history=1000               " Store lots of command history
set undolevels=1000           " Store lots of undo history
set visualbell                " Use visual bell instead of beeping
set noerrorbells             " No error bells
set confirm                  " Prompt to save changes instead of failing command
set autoread                 " Reload files changed outside vim

" Performance
set lazyredraw              " Don't redraw while executing macros
set ttyfast                 " Faster redrawing
set updatetime=300          " Faster completion
set timeout timeoutlen=500  " Faster key sequence completion

" File Management
set noswapfile             " Don't use swap files
set nobackup               " Don't create backup files
set autowrite              " Automatically save before commands like :next and :make

" Key Mappings
let mapleader = ","       " Set leader key to comma

" Easy window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Buffer navigation
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>

" Move lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Indent/unindent with tab/shift-tab
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Keep selection after indent/unindent
vnoremap > >gv
vnoremap < <gv

" Copy to system clipboard
vnoremap <C-c> "+y
nnoremap <C-p> "+p

" Quick editing of vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Auto Commands
augroup vimrc
    autocmd!
    " Return to last edit position when opening files
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

    " Automatically remove trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e

    " Set specific file types
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd BufNewFile,BufRead *.json set filetype=json
augroup END

" File Type Specific Settings
augroup filetype_specific
    autocmd!
    " Python
    autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4
    " JavaScript/TypeScript
    autocmd FileType javascript,typescript setlocal expandtab shiftwidth=2 tabstop=2
    " HTML/CSS
    autocmd FileType html,css setlocal expandtab shiftwidth=2 tabstop=2
    " Markdown
    autocmd FileType markdown setlocal wrap linebreak nolist
augroup END

" Status Line Configuration
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{getcwd()}  " Current working directory
set statusline+=/  " Separator
set statusline+=%f  " File name
set statusline+=%m  " Modified flag
set statusline+=%=  " Switch to right side
set statusline+=%#CursorColumn#
set statusline+=\ %y  " File type
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}  " File encoding
set statusline+=\[%{&fileformat}\]  " File format
set statusline+=\ %p%%  " Percentage through file
set statusline+=\ %l:%c  " Line and column number