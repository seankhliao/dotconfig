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
set updatetime=300
set wildignorecase
set wildmode=longest,list:longest,full



let g:closetag_filetypes = 'html,javascript,markdown'

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

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
    Plug 'lambdalisue/suda.vim' " sudo write
    Plug 'tyru/caw.vim'         " comments

    " completion
    Plug 'sheerun/vim-polyglot'
    Plug 'alvan/vim-closetag' " xml tags
    " Plug 'raimondi/delimitMate'
    Plug 'jiangmiao/auto-pairs'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Plug 'neovim/nvim-lsp'
call plug#end()



colorscheme fahrenheit



augroup Coc
    autocmd!
    " autocmd CursorHold  *       silent call CocActionAsync('highlight')
    autocmd BufWritePre *.go    :call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd BufWritePre *       :call CocAction('format')
    autocmd BufWritePre *       silent :%s/\s\+$//e
    autocmd BufWritePre *       silent :v/\_s*\S/d
augroup END

" if argc() == 0
"     augroup StartScreen
"         autocmd!
"         autocmd VimEnter * call Splash()
"     augroup END
" endif



" keymaps, abbrevs: (*nore*: no recursive)
cnoreabbrev cr          !google-chrome-unstable % 2>/dev/null
cnoreabbrev WQ          wq
cnoreabbrev W           w suda://%

inoreabbrev retrun      return

inoremap <silent><expr> <TAB>       pumvisible() ? "\<C-n>" :  <SID>check_back_space() ? "\<TAB>" : coc#refresh()
inoremap <expr>         <S-TAB>     pumvisible() ? "\<C-p>" : "\<C-h>"

nnoremap                ;           :
" nnoremap <silent>       sd          :call <SID>show_documentation()<CR>
nmap     <silent>       gd          <Plug>(coc-definition)
nmap     <silent>       gt          <Plug>(coc-type-definition)
nmap                    rn          <Plug>(coc-rename)



command! -nargs=0 Format    :call CocAction('format')
command! -nargs=0 Import    :call CocAction('runCommand', 'editor.action.organizeImport')



" coc
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" function! s:show_documentation()
"     if (index(['vim','help'], &filetype) >= 0)
"         execute 'h '.expand('<cword>')
"     else
"         call CocAction('doHover')
"     endif
" endfunction

" function! Splash()
"     enew
"     setlocal
"        \ bufhidden=wipe
"        \ buftype=nofile
"        \ nobuflisted
"        \ nocursorcolumn
"        \ nocursorline
"        \ nolist
"        \ nonumber
"        \ noswapfile
"        \ norelativenumber
"        \ filetype=help
"
"     exec ":r ~/.config/nvim/splash.txt"
"     setlocal
"       \ nomodifiable
"       \ nomodified
"     nnoremap <buffer><silent> e :enew<CR>
"     nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
"     nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
" endfunction
