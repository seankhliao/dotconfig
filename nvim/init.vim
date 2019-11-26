scriptencoding utf-8
filetype plugin indent on
syntax enable

set autoindent
set autoread
set background=dark
set backupdir=$XDG_DATA_HOME/nvim/backup
set breakindent
set clipboard=unnamedplus
set completeopt=menuone,noinsert,noselect
set confirm
set copyindent
set expandtab
set nofoldenable
set fsync
set grepprg=rg
set ignorecase
set inccommand=split
set incsearch
set nomodeline
set mouse=a
set mousefocus
set number
set scrolloff=4
set shiftwidth=0
set shortmess=aoOtTIc
set sidescrolloff=4
set smartcase
set smartindent
set smarttab
" set softtabstop=0
set noswapfile
set tabstop=4
set termguicolors
set undofile
set undodir=$XDG_DATA_HOME/nvim/undo
set wildignorecase
set wildmode=longest,list:longest,full



let g:ale_html_prettier_options = '--print-width 120'
let g:ale_javascript_prettier_options = '--print-width 120'
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
    \ 'json'           :['prettier'],
    \ 'markdown'       :['prettier'],
    \ 'typescript'     :['prettier'],
    \ 'yaml'           :['prettier'],
    \}

let g:LanguageClient_settingsPath = expand('$XDG_CONFIG_HOME/nvim/langclient.json')
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
  \ 'python'          :['pyls'],
  \ 'typescript'      :['javascript-typescript-stdio'],
  \ }

let g:closetag_filetypes = 'html,javascript,markdown'
let g:delimitMate_expand_cr = 2


let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1

let g:signify_vcs_list = [ 'git' ]
let g:signify_sign_change = '~'

let g:lightline = {'colorscheme': 'fahrenheit'}



" ncm2
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

cnoreabbrev cr !google-chrome-unstable % 2>/dev/null
cnoreabbrev WQ wq
cnoreabbrev W w suda://%
nnoremap ; :



call plug#begin('$XDG_DATA_HOME/nvim/plugin')
    " Visual
    Plug 'fcpg/vim-fahrenheit'
    Plug 'mhinz/vim-signify'     " git gutter
    Plug 'itchyny/lightline.vim' " status line
    Plug 'nathanaelkane/vim-indent-guides'

    " Interactive
    Plug 'lambdalisue/suda.vim' " sudo write
    Plug 'tyru/caw.vim'         " comments

    " completion
    Plug 'dense-analysis/ale'
    Plug 'sheerun/vim-polyglot'
    Plug 'alvan/vim-closetag' " xml tags
    Plug 'raimondi/delimitMate'

    " Plug 'neovim/nvim-lsp'

    " ncm2
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }
call plug#end()



colorscheme fahrenheit

" call nvim_lsp#setup("clangd", {})
" call nvim_lsp#setup("gopls", {})
" call nvim_lsp#setup("pyls", {})
" call nvim_lsp#setup("texlab", {})

autocmd BufEnter * call ncm2#enable_for_buffer()

autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#000000   ctermbg=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   guibg=#262626   ctermbg=235
