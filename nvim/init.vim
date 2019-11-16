scriptencoding utf-8
filetype plugin indent on

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%][%severity%] %s'
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✗✗'
let g:ale_sign_warning = '⚠⚠'
let g:ale_set_signs = 1
let g:ale_fixers = {
    \ '*'              :['remove_trailing_lines', 'trim_whitespace'],
    \ 'css'            :['prettier'],
    \ 'html'           :['prettier'],
    \ 'javascript'     :['prettier'],
    \ 'markdown'       :['prettier'],
    \ 'typescript'     :['prettier'],
    \ 'yaml'           :['prettier'],
    \}
" 'json'           :['prettier'],

let g:ale_html_prettier_options = '--print-width 120'
let g:ale_javascript_prettier_options = '--print-width 120'

let g:deoplete#enable_at_startup = 1
let g:LanguageClient_loggingFile = expand('$XDG_DATA_HOME/nvim/languageclient.log')
let g:LanguageClient_settingsPath = expand('$XDG_CONFIG_HOME/nvim/languageclient_settings.json')
let g:LanguageClient_serverCommands = {
    \ 'c'               :['clangd'],
    \ 'cpp'             :['clangd'],
    \ 'css'             :['css-languageserver', '--stdio'],
    \ 'Dockerfile'      :['docker-langserver', '--stdio'],
    \ 'go'              :['gopls'],
    \ 'html'            :['html-languageserver', '--stdio'],
    \ 'javascript'      :['javascript-typescript-stdio'],
    \ 'json'            :['json-languageserver', '--stdio'],
    \ 'latex'           :['texlab'],
    \ 'python'          :['mspyls'],
    \ 'typescript'      :['javascript-typescript-stdio'],
    \ 'yaml'            :['yaml-language-server', '--stdio'],
    \ }
let g:LanguageClient_rootMarkers = {
    \ 'go'              :['go.mod'],
    \ }

let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.ejs,*.js'

let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1

let g:signify_vcs_list = [ 'git' ]
let g:signify_sign_change = '~'

let g:lightline = {'colorscheme': 'fahrenheit'}

syntax enable

set autoindent
set autoread
set background=dark
set backupdir=$XDG_DATA_HOME/nvim/backup
set breakindent
set clipboard+=unnamedplus
set completeopt=noinsert,menuone,noselect " ncm2
set confirm
set copyindent
set expandtab
set foldlevelstart=10
set foldmethod=syntax
set fsync
set grepprg=rg
set ignorecase
set inccommand=split
set incsearch
set mouse=a
set mousefocus
set nomodeline
set noswapfile
set number
set scrolloff=4
set shiftwidth=4
set shortmess=aoOtTIc
set sidescrolloff=4
set smartcase
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
set termguicolors
set undofile
set undodir=$XDG_DATA_HOME/nvim/undo

" ncm2
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

cnoreabbrev cr !google-chrome-unstable % 2>/dev/null
cnoreabbrev WQ wq
cnoreabbrev W w suda://%
nnoremap ; :

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
    " Visual
    " Plug 'cocopon/iceberg.vim'
    Plug 'fcpg/vim-fahrenheit'

    Plug 'ap/vim-css-color'
    Plug 'mhinz/vim-signify'     " git gutter
    Plug 'itchyny/lightline.vim' " status line
    Plug 'nathanaelkane/vim-indent-guides'

    " Interactive
    Plug 'lambdalisue/suda.vim' " sudo write
    Plug 'tyru/caw.vim'         " comments

    " lint / fix ?
    Plug 'dense-analysis/ale'

    " completion
    Plug 'sheerun/vim-polyglot'
    Plug 'alvan/vim-closetag' " xml tags
    Plug 'jiangmiao/auto-pairs'

    " deoplete
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/neco-syntax'
    Plug 'deoplete-plugins/deoplete-zsh'
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }

call plug#end()

colorscheme fahrenheit

autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

autocmd FileType json :set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
autocmd BufWritePre *.json :normal ggVGgq

autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#000000   ctermbg=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   guibg=#262626   ctermbg=235
