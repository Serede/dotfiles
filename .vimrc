" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Jul 28
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set backupdir=/var/tmp//,/tmp//
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
    set undodir=/var/tmp//,/tmp//
  endif
  set directory=/var/tmp//,/tmp//
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval')
  packadd matchit
endif

" Highlight current line
set cursorline

" Custom mappings
nmap <Leader>hs :nohlsearch<CR>
nmap <Leader>ft :%s/\s\+$//gc<CR>

" Background Color Erase for 256-color fix
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

" Custom indentation
set tabstop=4
set shiftwidth=4
set expandtab

" Use custom tags file
set tags+=.git/tags

" Rainbow Parentheses for Lisp
let g:lisp_rainbow = 1

" Plugins
function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --system-libclang --system-boost
  endif
endfunction
call plug#begin()
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'kovisoft/slimv', { 'for': 'lisp' }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] }
Plug 'vim-airline/vim-airline-themes' | Plug 'vim-airline/vim-airline'
Plug 'edkolev/promptline.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
call plug#end()

" Fancy colorscheme
colorscheme molokai

" YCM settings
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_python_binary_path = 'python'
let g:ycm_key_list_previous_completion = ['Up']
let g:ycm_key_list_select_completion = ['Down']

" Slimv settings
let g:slimv_leader = '_'

" Vimtex settings
let g:vimtex_view_method = 'zathura'

" Gutentags settings
let g:gutentags_tagfile = '.git/tags'
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
