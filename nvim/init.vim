scriptencoding utf-8
filetype plugin indent on
syntax enable

set autoindent
set autoread
set background=dark
set backupdir=$XDG_DATA_HOME/nvim/backup
set breakindent
set clipboard=unnamedplus
set commentstring=#\ %s
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
set updatetime=300
set wildignorecase
set wildmode=longest,list:longest,full



let g:closetag_filetypes = 'html,javascript,markdown'

let g:indent_guides_enable_on_vim_startup = 1

let g:signify_sign_change = '~'

let g:lightline = {'colorscheme': 'fahrenheit'}



call plug#begin('$XDG_DATA_HOME/nvim/plugin')
    " Visual
    Plug 'fcpg/vim-fahrenheit'
    Plug 'mhinz/vim-signify'     " git gutter
    Plug 'itchyny/lightline.vim' " status line
    Plug 'nathanaelkane/vim-indent-guides'

    " Interactive
    " Plug 'lambdalisue/suda.vim' " sudo write
    Plug 'tyru/caw.vim'         " comments

    " completion
    Plug 'sheerun/vim-polyglot'
    Plug 'alvan/vim-closetag' " xml tags
    Plug 'jiangmiao/auto-pairs'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

function! MyHighlights() abort
    hi DiffAdd ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse
    hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse
    hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse
    hi DiffText ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ff8700 gui=reverse
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

colorscheme fahrenheit



augroup Coc
    autocmd!
    autocmd BufWritePre *.go    silent call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd BufWritePre *       silent call CocAction('format')
    autocmd BufWritePre *       silent :%s/\s\+$//e
    autocmd BufWritePre *       silent :v/\_s*\S/d
    autocmd BufWritePre *       silent :nohlsearch
augroup END

cnoreabbrev WQ          wq
" cnoreabbrev W           w suda://%
cnoreabbrev W           execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
nmap   <silent>         gd          <Plug>(coc-definition)
nmap   <silent>         gt          <Plug>(coc-type-definition)
nmap                    rn          <Plug>(coc-rename)
nmap   <silent>         <TAB>       <Plug>(coc-diagnostic-next)

command! -nargs=0 Format    :call CocAction('format')
command! -nargs=0 Import    :call CocAction('runCommand', 'editor.action.organizeImport')
" uncomment for osc 52 (ssh clipboard)
" also add bash script to somewhere in $PATH
"
" let g:clipboard = {
"      \ 'name': 'myClipboard',
"      \     'copy': {
"      \         '+': 'clipboard-provider copy',
"      \     },
"      \     'paste': {
"      \         '+': 'clipboard-provider paste',
"      \     },
"      \ }
"
"
" #!/bin/bash
" #
" # clipboard provider for neovim
" #
" # :help provider-clipboard
"
" #exec 2>> ~/clipboard-provider.out
" #set -x
"
" : ${COPY_PROVIDERS:=tmux osc52}
" : ${PASTE_PROVIDERS:=tmux}
" : ${TTY:=`(tty || tty </proc/$PPID/fd/0) 2>/dev/null | grep /dev/`}
"
" main() {
"     declare p status=99
"
"     case $1 in
"         copy)
"             slurp
"             for p in $COPY_PROVIDERS; do
"                 $p-provider copy && status=0
"             done ;;
"
"         paste)
"             for p in $PASTE_PROVIDERS; do
"                 $p-provider paste && status=0 && break
"             done ;;
"     esac
"
"     exit $status
" }
"
" # N.B. buffer is global for simplicity
" slurp() { buffer=$(base64); }
" spit() { base64 --decode <<<"$buffer"; }
"
" tmux-provider() {
"     [[ -n $TMUX ]] || return
"     case $1 in
"         copy) spit | tmux load-buffer - ;;
"         paste) tmux save-buffer - ;;
"     esac
" }
"
" osc52-provider() {
"     case $1 in
"         copy) [[ -n "$TTY" ]] && printf $'\e]52;c;%s\a' "$buffer" > "$TTY" ;;
"         paste) return 1 ;;
"     esac
" }
"
" main "$@"
let g:clipboard = {
      \ 'name': 'myClipboard',
      \     'copy': {
      \         '+': 'clipboard-provider copy',
      \     },
      \     'paste': {
      \         '+': 'clipboard-provider paste',
      \     },
      \ }
