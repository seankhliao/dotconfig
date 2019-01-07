scriptencoding utf-8

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
    Plug 'alvan/vim-closetag' " xml tags
    Plug 'airblade/vim-gitgutter' " git gutter
    Plug 'ap/vim-css-color'
    Plug 'brooth/far.vim'       " advanced find and replace
	Plug 'cyansprite/extract'   " list of yanks
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }} " live preview in browser
    Plug 'itchyny/lightline.vim' " status line
    Plug 'lambdalisue/suda.vim' " sudo write
	Plug 'mhartington/oceanic-next' " colorscheme
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'raimondi/delimitmate' " parens
    Plug 'tyru/caw.vim'         " comments
    Plug 'Shougo/context_filetype.vim'

    Plug 'cespare/vim-toml'

    Plug 'roxma/nvim-yarp'
    Plug 'ncm2/ncm2'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-cssomni'
    Plug 'ncm2/ncm2-go' | Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'ncm2/ncm2-html-subscope'
    Plug 'ncm2/ncm2-jedi' | Plug 'davidhalter/jedi-vim'
    Plug 'ncm2/ncm2-markdown-subscope'
    Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'
    Plug 'ncm2/ncm2-path'
    " Plug 'ncm2/ncm2-pyclang'
    Plug 'ncm2/ncm2-racer' | Plug 'racer-rust/vim-racer'
    Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
    Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
    Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'
    " Plug 'filipekiss/ncm2-look.vim' " english word completion
    
    Plug 'w0rp/ale'

call plug#end()

let g:ale_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✗✗'
let g:ale_sign_warning = '⚠⚠'
let g:ale_lint_on_insert_leave = 1
let g:ale_set_signs = 1

let g:ale_fixers = {
\ 'bash'    : ['shfmt'],
\ 'c'       : ['clang-format'],
\ 'cpp'     : ['clang-format'],
\ 'css'     : ['prettier'],
\ 'go'      : ['goimports'],
\ 'html'    : ['prettier'],
\ 'javascript': ['prettier'],
\ 'javascript.jsx': ['prettier'],
\ 'json'    : ['prettier'],
\ 'less'    : ['prettier'],
\ 'markdown': ['prettier'],
\ 'python'  : ['yapf'],
\ 'scss'    : ['prettier'],
\ 'sql'     : ['sqlint'],
\ 'typescript': ['prettier'],
\ 'xml'     : ['xmllint'],
\ 'yaml'    : ['prettier'],
\}
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.ejs,*.js'
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 2
let g:delimitMate_smart_quotes = 1
let g:delimitMate_matchpairs = '(:),[:],{:}'
let g:indent_guides_enable_on_vim_startup = 1
let g:jedi#auto_initialization = 0
let g:lightline = {'colorscheme': 'oceanicnext'}
let g:ncm2_look_enabled = 1

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#1b2b34   ctermbg=2
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#4f5b66   ctermbg=0

autocmd BufEnter * call ncm2#enable_for_buffer()

syntax enable
colorscheme OceanicNext

set autoindent
set autoread
set background=dark
set breakindent
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set confirm
set copyindent
set expandtab
set foldlevelstart=10           
set foldmethod=syntax
set fsync
set grepprg=rg
set ignorecase
set incsearch
set mouse=a
set mousefocus
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
set spell
set tabstop=4
set termguicolors

cnoreabbrev cr !google-chrome-unstable % 2>/dev/null
cnoreabbrev gi GoImport
cnoreabbrev gd GoDoc
cnoreabbrev WQ wq
cnoreabbrev W w suda://%
inoremap <c-c> <ESC>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nnoremap ; :

autocmd BufNewFile *.sh 0r $XDG_CONFIG_HOME/nvim/skeleton/skeleton.sh
autocmd BufNewFile main.go 0r $XDG_CONFIG_HOME/nvim/skeleton/skeleton.go
autocmd BufNewFile *.html 0r $XDG_CONFIG_HOME/nvim/skeleton/skeleton.html
autocmd BufNewFile .travis.yml 0r $XDG_CONFIG_HOME/nvim/skeleton/travis.yml

autocmd BufNewFile README.md 0r $XDG_CONFIG_HOME/nvim/skeleton/README.md
autocmd BufNewFile README.md ks|call RepoName()|'s
fun RepoName()
    let l = 1
    for line in getline(1,"$")
        call setline(l, substitute(line, 'REPONAME', substitute(getcwd(), '^.*/', '', ''), "g"))
        let l = l + 1
    endfor
endfun

autocmd BufNewFile LICENSE 0r $XDG_CONFIG_HOME/nvim/skeleton/LICENSE-MIT
autocmd BufNewFile LICENSE ks|call LicenseYear()|'s
fun LicenseYear()
    call setline(3, substitute(getline(3), "INSERT_YEAR", strftime("%Y"), ""))
endfun
