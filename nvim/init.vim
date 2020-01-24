scriptencoding utf-8
filetype plugin indent on
syntax enable

set autoindent
set autoread
set background=dark
set backupdir=$XDG_DATA_HOME/nvim/backup
set breakindent
set clipboard=unnamedplus
set completeopt=menuone,noinsert,noselect,preview
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
set noswapfile
set tabstop=4
set termguicolors
set undofile
set undodir=$XDG_DATA_HOME/nvim/undo
set wildignorecase
set wildmode=longest,list:longest,full



let g:ale_completion_enabled = 1
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
   \ 'go'             :['gopls'],
   \ 'html'           :['prettier'],
   \ 'javascript'     :['prettier'],
   \ 'json'           :['prettier'],
   \ 'markdown'       :['prettier'],
   \ 'typescript'     :['prettier'],
   \ 'yaml'           :['prettier'],
   \}

let g:closetag_filetypes = 'html,javascript,markdown'
let g:delimitMate_expand_cr = 2

let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1

let g:signify_vcs_list = [ 'git' ]
let g:signify_sign_change = '~'

let g:lightline = {'colorscheme': 'fahrenheit'}



cnoreabbrev cr !google-chrome-unstable % 2>/dev/null
cnoreabbrev WQ wq
cnoreabbrev W w suda://%
nnoremap ; :


"
" coc
set updatetime=300
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>rn <Plug>(coc-rename)
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}



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
    Plug 'sheerun/vim-polyglot'
    Plug 'dense-analysis/ale'
    Plug 'alvan/vim-closetag' " xml tags
    Plug 'raimondi/delimitMate'

    " Plug 'neovim/nvim-lsp'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()



colorscheme fahrenheit

autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#000000  ctermbg=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   guibg=#262626  ctermbg=235
autocmd VimEnter,Colorscheme * :hi lspReference      guibg=green    ctermbg=green
