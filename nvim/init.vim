" neovim
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" background
set autoread                    
set clipboard=unnamedplus       
set confirm                 
set encoding=utf-8          
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
comm! W exec 'w !sudo tee % > /dev/null' | e!

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
    Plug 'arcticicestudio/nord-vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'ap/vim-css-color'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'itchyny/lightline.vim'
    Plug 'romainl/vim-cool'
    Plug 'Raimondi/delimitMate'
    Plug 'alvan/vim-closetag'
    Plug 'tpope/vim-commentary'
    Plug 'roxma/nvim-completion-manager'
    Plug 'w0rp/ale'
    Plug 'sheerun/vim-polyglot'
    Plug 'fatih/vim-go'
    Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '$XDG_DATA_HOME/nvim/plugged/gocode/nvim/symlink.sh' }
    Plug 'davidhalter/jedi-vim'
call plug#end()

" Theme
" Plug 'arcticicestudio/nord-vim'
set background=dark             
set tgc                         
colorscheme nord

" Gutter
" Plug 'airblade/vim-gitgutter'
set number                      ""
" set relativenumber

" Highlight colors
" Plug 'ap/vim-css-color'

" Indent guides
" Plug 'nathanaelkane/vim-indent-guides'
set expandtab
" see language specific overrides
set shiftwidth=4
set softtabstop=4
set tabstop=4
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#2E3340   ctermbg=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3B4252   ctermbg=2

" Folding
set foldmethod=indent           
set foldlevelstart=99           

" Line wrapping
set breakindent                 
set scrolloff=3                 

" Status Line
" Plug'itchyny/lightline.vim'
set noshowmode                  
let g:lightline = {'colorscheme': 'nord'}

" Search
" Plug'romainl/vim-cool'
set ignorecase                  
set smartcase               


" brace closing
" Plug'Raimondi/delimitMate'
set showmatch                   ""
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 2
let g:delimitMate_smart_quotes = 1
let g:delimitMate_matchpairs = "(:),[:],{:}"

" tag closing
" Plug'alvan/vim-closetag'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.ejs"

" Block commenting
" Plug'tpope/vim-commentary'
autocmd FileType matlab setlocal commentstring=\%\ %s


" Autocomplete
" Plug'roxma/nvim-completion-manager'
set completeopt+=longest,menuone,noselect,noinsert
set shortmess+=c                ""
" cycle completion with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" Autolint
" Plug'w0rp/ale'
let g:ale_lint_on_insert_leave = 1
let g:ale_set_signs = 1
let g:ale_linters = {
\   'go': ['gofmt', 'goimports', 'golint'],
\}

" ===============================================================
" ===================== Language Specific =======================
" ===============================================================

" General
" Plug'sheerun/vim-polyglot'

" CSS
" Plug 'hail2u/vim-css3-syntax'
" Plug 'othree/csscomplete.vim'
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS

" Go
" Plug'fatih/vim-go'
" Plug'nsf/gocode', { 'rtp': 'nvim', 'do': '$XDG_DATA_HOME/nvim/plugged/gocode/nvim/symlink.sh' }
let g:go_template_autocreate = 0
let g:go_fmt_command = "goimports"
let g:go_snippet_case_type = "camelcase"
let g:go_fmt_fail_silently = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
autocmd FileType go setlocal expandtab " force overrride ftplugin"
autocmd FileType go setlocal shiftwidth=8
autocmd FileType go setlocal softtabstop=8
autocmd FileType go setlocal tabstop=8

" html
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags

" javascript
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript setlocal shiftwidth=8
autocmd FileType javascript setlocal softtabstop=8
autocmd FileType javascript setlocal tabstop=8

" Make
autocmd FileType make setlocal noexpandtab

" Markdow
autocmd BufNewFile,BufReadPost *.md setlocal filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
let g:markdown_syntax_conceal = 0

" Proto
autocmd FileType proto setlocal shiftwidth=2
autocmd FileType proto setlocal softtabstop=2
autocmd FileType proto setlocal tabstop=2

" Python
" Plug'davidhalter/jedi-vim'
" autocmd FileType python setlocallocal omnifunc=pythoncomplete#Complete

" XML
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

