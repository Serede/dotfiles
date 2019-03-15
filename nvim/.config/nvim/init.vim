" Convenient settings
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Custom directories
set directory=/var/tmp//,/tmp//
set backupdir=/var/tmp//,/tmp//
set undodir=/var/tmp//,/tmp//

" Custom line numbers and scrolloff
set number
set relativenumber
set scrolloff=2

" Custom indentation
set tabstop=4
set shiftwidth=4
set expandtab

" Custom tags file
set tags+=.git/tags

" Rainbow Parentheses for Lisp
let g:lisp_rainbow = 1

" Custom mappings
nmap <A-H> <C-w>H
nmap <A-J> <C-w>J
nmap <A-K> <C-w>K
nmap <A-L> <C-w>L
nmap <Leader>hs :nohlsearch<CR>
nmap <Leader>ft :%s/\s\+$//gc<CR>

" netrw explorer
fun! VexToggle(dir)
    if exists("t:vex_buf_nr")
        3
        4
        5
        6
        7
        call VexClose()
    else
        call VexOpen(a:dir)
    endif
endf
fun! VexOpen(dir)
    let g:netrw_browse_split=4 " open files in previous window
    let vex_width = 25
    execute "Vexplore " . a:dir
    let t:vex_buf_nr = bufnr("%")
    wincmd H
    call VexSize(vex_width)
endf
fun! VexClose()
    let cur_win_nr = winnr()
    let target_nr = ( cur_win_nr == 1 ? winnr("#") : cur_win_nr )
    1wincmd w
    close
    unlet t:vex_buf_nr
    execute (target_nr - 1) . "wincmd w"
    call NormalizeWidths()
endf
fun! VexSize(vex_width)
    execute "vertical resize" . a:vex_width
    set winfixwidth
    call NormalizeWidths()
endf
fun! NormalizeWidths()
    let eadir_pref = &eadirection
    set eadirection=hor
    set equalalways! equalalways!
    let &eadirection = eadir_pref
endf
let g:netrw_banner=0            " no banner
let g:netrw_altv=1              " open files on right
let g:netrw_preview=1           " open previews vertically
nmap <Leader>n :call VexToggle("")<CR>

" PLUGINS
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'arcticicestudio/nord-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'majutsushi/tagbar'
Plug 'neomake/neomake'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-jedi'
call plug#end()

" Fancy colorscheme
colorscheme nord
set background=dark

" Deoplete settings
let g:deoplete#enable_at_startup = 1
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'

" Vimtex settings
let g:vimtex_view_method = 'zathura'

" Tagbar settings
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_sort = 0

" Neomake settings
autocmd! BufReadPost,BufWritePost * Neomake

" Airline settings
let g:airline_powerline_fonts = 1
call airline#parts#define_accent('linenr', 'none')
call airline#parts#define_accent('maxlinenr', 'none')

" tmux-navigator settings
"let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
