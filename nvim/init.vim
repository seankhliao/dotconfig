scriptencoding utf-8

let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✗✗'
let g:ale_sign_warning = '⚠⚠'
let g:ale_set_signs = 1

let g:ale_fixers = {
    \ '*'              :['remove_trailing_lines', 'trim_whitespace'],
    \ 'bash'           :['shfmt'],
    \ 'c'              :['clang-format'],
    \ 'cpp'            :['clang-format'],
    \ 'css'            :['prettier'],
    \ 'go'             :['goimports'],
    \ 'html'           :['prettier'],
    \ 'javascript'     :['prettier'],
    \ 'javascript.jsx' :['prettier'],
    \ 'json'           :['prettier'],
    \ 'less'           :['prettier'],
    \ 'markdown'       :['prettier'],
    \ 'python'         :['yapf'],
    \ 'scss'           :['prettier'],
    \ 'sql'            :['sqlint'],
    \ 'typescript'     :['prettier'],
    \ 'xml'            :['xmllint'],
    \ 'yaml'           :['prettier'],
    \}

let g:ale_html_prettier_options = '--print-width 120'
let g:ale_javascript_prettier_options = '--print-width 120'

let g:LanguageClient_serverCommands = {
    \ 'go'             :['gopls'],
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
    Plug 'w0rp/ale'

    " completion
    Plug 'sheerun/vim-polyglot'
    Plug 'alvan/vim-closetag' " xml tags
    Plug 'jiangmiao/auto-pairs'

    " ncm2
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }

call plug#end()

colorscheme fahrenheit

autocmd BufEnter * call ncm2#enable_for_buffer()

autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#000000   ctermbg=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   guibg=#262626   ctermbg=235
