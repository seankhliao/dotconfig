" neovim
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" background
set autoread                    
set clipboard=unnamedplus       
set confirm                 
set encoding=utf-8          
scriptencoding utf-8
set fileencoding=utf-8
set hidden                  
set mouse=a                     
set noerrorbells                
set nobackup                
set noswapfile              
set updatetime=750              
" set wildmode=list:longest,full

nnoremap ; :
" typos
cnoreabbrev WQ wq
" Sudo write
" comm! W exec 'w !sudo tee % > /dev/null' | e!
cnoreabbrev W w suda://%

call plug#begin('$XDG_DATA_HOME/nvim/plugged')

    Plug 'arcticicestudio/nord-vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'ap/vim-css-color'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'itchyny/lightline.vim'
    Plug 'romainl/vim-cool' " hlsearch tolerable
    Plug 'Raimondi/delimitMate'
    Plug 'alvan/vim-closetag'
    Plug 'tyru/caw.vim' " commenrs
    Plug 'sheerun/vim-polyglot'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'Shougo/context_filetype.vim'
    Plug 'lambdalisue/suda.vim'

    Plug 'w0rp/ale'

    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/neosnippet'
    Plug 'Shougo/neosnippet-snippets'
    Plug 'Shougo/neco-syntax' " from syntax files

    " Other
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh'}

    " go
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'zchee/deoplete-go', { 'do': 'make'}
    " js
    Plug 'Quramy/vim-js-pretty-template'
    Plug 'wokalski/autocomplete-flow'
    Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
    " python
    Plug 'zchee/deoplete-jedi'

call plug#end()

set background=dark             
set tgc                         
colorscheme nord

set number                      ""
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#3B4252   ctermbg=2
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#2E3340   ctermbg=0

" Folding
set foldmethod=syntax       
set foldlevelstart=10           

" Line wrapping
set breakindent                 
set scrolloff=3                 

set noshowmode                  
let g:lightline = {'colorscheme': 'nord'}

set ignorecase                  
set smartcase               


set showmatch                   ""
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 2
let g:delimitMate_smart_quotes = 1
let g:delimitMate_matchpairs = '(:),[:],{:}'

let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.ejs,*.js'


set completeopt+=longest,menuone,noselect,noinsert
set shortmess+=c                ""


" Autolint
" Plug'w0rp/ale'
let g:ale_sign_error = '✗✗'
let g:ale_sign_warning = '⚠⚠'
let g:ale_lint_on_insert_leave = 1
let g:ale_set_signs = 1
" let g:ale_linters = {
"             \   'go': ['gofmt', 'goimports', 'golint'],
"             \}
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\ 'bash'    : ['shfmt'],
\ 'c'       : ['clang-format'],
\ 'cpp'     : ['clang-format'],
\ 'go'      : ['goimports'],
\ 'javascript': ['prettier'],
\ 'javascript.jsx': ['prettier'],
\ 'json'    : ['prettier'],
\ 'less'    : ['prettier'],
\ 'python'  : ['yapf'],
\ 'scss'    : ['prettier'],
\ 'sql'     : ['sqlint'],
\ 'xml'     : ['xmllint'],
\ 'yaml'    : ['yamllint'],
\}

" Autocomplete
" Plug 'Shougo/deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

let g:deoplete#sources#go#pointer = 1

" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
"     \ 'javascript': ['javascript-typescript-stdio'],
"     \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"     \ }

let g:necosyntax#min_keyword_length = 2
