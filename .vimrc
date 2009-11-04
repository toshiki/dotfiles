set nocompatible
colorscheme desert
highlight Comment ctermfg=Green

" imap <C-j> <esc>
nmap j gj
nmap k gk
vmap j gj
vmap k gk

" display
set title
"set cursorline
set term=builtin_linux
set ttytype=builtin_linux
set ruler
set ignorecase
set wildmode=list:longest,list:full
set visualbell t_vb=
if &t_Co > 2
    syntax on
    set hlsearch
endif
" set list
set display=uhex
set showcmd
set laststatus=2
set cmdheight=2
set statusline=[%L]\ %t\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l/%L
set number
set hidden

" backup
set backup
set backupdir=$HOME/.vim-backup

" search
set incsearch
set ignorecase
set smartcase
nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>
nnoremap / :<C-u>set hlsearch<Return>/
nnoremap ? :<C-u>set hlsearch<Return>?
nnoremap * :<C-u>set hlsearch<Return>*
nnoremap # :<C-u>set hlsearch<Return>#

" edit
set autoindent
set smartindent
set backspace=indent,eol,start
set showmatch
set autoread
set formatoptions+=mM
nmap ye :let @"=expand("<cword>")<CR>
cmap <C-a> <Home>
cmap <C-e> <End>
cmap <C-f> <Right>
cmap <C-b> <Left>
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>

" completion
set complete+=k
imap <C-Space> <C-x><C-o><C-p>
hi Pmenu ctermbg=4
hi Pmenu ctermbg=4
hi PmenuSel ctermbg=1

if has('multi_byte_ime') || has('xim')
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    set imactivatekey=C-space
  endif
  " 挿入モードでのIME状態を記憶させない
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

" buffer
set hidden
nmap <Space> :bn<CR>
map <Left> :bp<CR>
map <Right> :bn<CR>
map <Down> :ls<CR>

" tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

" encoding
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp-2,euc-jisx0213,euc-jp,cp932
set fileformats=unix,dos,mac
set fileformat=unix

" filetype
filetype on
filetype indent on
filetype plugin on

" ruby
" vim: nowrap sw=2 sts=2 ts=8 noet ff=unix:
autocmd FileType ruby,eruby set tabstop=2 shiftwidth=2

" minibufexpl.vim
:let g:miniBufExplMapWindowNavVim=1
:let g:miniBufExplMapWindowNavAllows=1
:let g:miniBufExplMapCTabSwitchBuffs=1

" buftabs.vim
let g:buftabs_only_basename=1
let g:buftabs_in_statusline=1

" rails.vim
imap <C-Space> <C-x><C-o>
let g:rails_level=4
let g:rails_default_file="app/controllers/application.rb"
let g:rails_default_database="mysql"

" rubycomplete.vim
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" windows mount
autocmd BufNewFile,BufRead /mnt/* set nofsync
autocmd BufNewFile,BufRead /opt/* set nofsync

if has('gui_macvim')
    set showtabline=2
    set transparency=5
    map <silent> gw :macaction selectNextWindow:
    map <silent> gW :macaction selectPreviousWindow:
endif

highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white

highlight WideSpace ctermbg=blue guibg=blue
highlight EOLSpace ctermbg=red guibg=red
function! s:highlight_spaces()
    match WideSpace "　"
    match EOLSpace /\s\+$/
endf

call s:highlight_spaces()
map <C-s> :up<CR>
