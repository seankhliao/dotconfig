scriptencoding utf-8

if has('nvim-0.5.0')
    luafile ~/.config/nvim/init.lua
else
    filetype plugin indent on
    syntax enable

    let cache_dir = $XDG_CACHE_HOME
    let backup_dir = cache_dir . "/nvim/backup"
    let undo_dir = cache_dir . "/nvim/undo"
    call system('mkdir -p ' . backup_dir)
    call system('mkdir -p ' . undo_dir)

    set background=dark
    let &backupdir=backup_dir
    set clipboard=unnamedplus
    set completeopt=menuone,noinsert,noselect,preview
    set confirm
    set fsync
    set ignorecase
    " set inccommand=split
    set incsearch
    set scrolloff=4
    set shortmess=aoOtTIc
    set sidescrolloff=4
    set smartcase
    set smarttab
    set termguicolors
    let &undodir=undo_dir
    set updatetime=300
    set wildignorecase
    set wildmode=longest,list:longest,full

    set breakindent
    set nofoldenable
    set number

    set autoindent
    set autoread
    set commentstring="#\\ %s"
    set copyindent
    set expandtab
    set grepprg=rg
    set nomodeline
    set shiftwidth=0
    set smartindent
    set noswapfile
    set tabstop=4
    set undofile

    let g:lightline = {'colorscheme': 'fahrenheit'}
    let g:signify_sign_change = '~'

    " create ~/.config/nvim/pack/minpac/opt
    " clone https://github.com/k-takata/minpac

    function! PackInit()
        packadd minpac
        call minpac#init()
        call minpac#add('k-takata/minpac', {'type': 'opt'})
        call minpac#add('fcpg/vim-fahrenheit')
        call minpac#add('mhinz/vim-signify')
        call minpac#add('itchyny/lightline.vim')
        call minpac#add('tyru/caw.vim')
        call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
        call minpac#add('sheerun/vim-polyglot')
    endfunction

    function! PackUpdate()
        call PackInit()
        call minpac#update()
    endfunction

    function! PackClean()
        call PackInit()
        call minpac#clean()
    endfunction

    colorscheme fahrenheit
    hi DiffAdd    ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse
    hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse
    hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse
    hi DiffText   ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ff8700 gui=reverse

    inoremap <silent><expr> <TAB>       pumvisible() ? "\<C-n>" :  <SID>check_back_space() ? "\<TAB>" : coc#refresh()
    inoremap <expr>         <S-TAB>     pumvisible() ? "\<C-p>" : "\<C-h>"
    nnoremap                ;           :
    cnoreabbrev WQ          wq

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    augroup Clean
        autocmd!
        autocmd BufWritePre *.go    silent :call CocAction('organizeImport')
        autocmd BufWritePre *       silent :%s/\s\+$//e
        autocmd BufWritePre *       silent :v/\_s*\S/d
        autocmd BufWritePre *       silent :nohlsearch
    augroup END
endif
