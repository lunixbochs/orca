set shell=/bin/bash
set ai
set history=100
set ruler
syntax on
set hlsearch
filetype plugin on

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif

filetype plugin indent on
