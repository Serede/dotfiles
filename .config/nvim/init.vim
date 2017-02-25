" An example for a vimrc file.
"
" To use it, copy it to
"     for Unix:     $HOME/.config/nvim/init.vim
"     for Windows:  %LOCALAPPDATA%\nvim\init.vim

set backup             " keep a backup file (restore to previous version)
set undofile           " keep an undo file (undo changes after closing)
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands

" Don't use Ex mode, use Q for formatting
noremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on
syntax on

" Also switch on highlighting the last used search pattern.
set hlsearch

" I like highlighting strings inside C comments.
let c_comment_strings=1

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'textwidth' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" Custom mappings
nmap <Leader>hs :nohlsearch<CR>
nmap <Leader>ft :%s/\s\+$//gc<CR>

" Custom indentation
set tabstop=4
set shiftwidth=4
set expandtab

" Use custom tags file
set tags+=.git/tags

" Rainbow Parentheses for Lisp
let g:lisp_rainbow = 1

" Plugins
call plug#begin()
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'edkolev/promptline.vim'
Plug 'kovisoft/slimv', { 'for': 'lisp' }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline-themes' | Plug 'vim-airline/vim-airline'
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-jedi'
call plug#end()

" Fancy colorscheme
colorscheme molokai

" Deoplete settings
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'

" Slimv settings
let g:slimv_leader = '_'

" Vimtex settings
let g:vimtex_view_method = 'zathura'

" Gutentags settings
let g:gutentags_ctags_tagfile = '.git/tags'
let g:gutentags_project_root = ['.git']
let g:gutentags_add_default_project_roots = 0

" Tagbar settings
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_sort = 0

" NERDTree settings
nmap <Leader>n :NERDTreeToggle<CR>
let g:NERDTreeMinimalUI = 1

" Airline settings
set laststatus=2
set ttimeoutlen=50
let g:airline_theme = 'base16_bright'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ycm#enabled = 1
call airline#parts#define_accent('linenr', 'none')

"Promptline settings
let g:promptline_preset = {
            \'a': [ '%m', '%n' ],
            \'b': [ '%1~', promptline#slices#vcs_branch() ],
            \'c': [ promptline#slices#python_virtualenv(), '%#' ],
            \'x': [ '$_promptline_vim_mode' ],
            \'y': [ '$_promptline_exit_code' ]}
let g:promptline_theme = 'airline_insert'
