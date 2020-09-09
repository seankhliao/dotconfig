vim.api.nvim_command('filetype plugin indent on')
vim.api.nvim_command('syntax enable')




local data_dir = os.getenv('XDG_DATA_HOME') or '.local/share'

vim.o.background        = 'dark'
vim.o.backupdir         = data_dir .. '/nvim/backup'
vim.o.clipboard         = 'unnamedplus'
vim.o.completeopt       = 'menuone,noinsert,noselect,preview'
vim.o.confirm           = true
vim.o.fsync             = true
vim.o.ignorecase        = true
vim.o.inccommand        = 'split'
vim.o.incsearch         = true
vim.o.mouse             = 'a'
vim.o.mousefocus        = true
vim.o.scrolloff         = 4
vim.o.shortmess         = 'aoOtTIc'
vim.o.sidescrolloff     = 4
vim.o.smartcase         = true
vim.o.smarttab          = true
vim.o.termguicolors     = true
vim.o.undodir           = data_dir .. '/nvim/undo'
vim.o.updatetime        = 300
vim.o.wildignorecase    = true
vim.o.wildmode          = 'longest,list:longest,full'

vim.wo.breakindent      = true
vim.wo.foldenable       = false
vim.wo.number           = true

vim.bo.autoindent       = true
vim.bo.autoread         = true
vim.bo.commentstring    = '#\\ %s'
vim.bo.copyindent       = true
vim.bo.expandtab        = true
vim.bo.grepprg          = 'rg'
vim.bo.modeline         = false
vim.bo.shiftwidth       = 0
vim.bo.smartindent      = true
vim.bo.swapfile         = false
vim.bo.tabstop          = 4
vim.bo.undofile         = true

vim.g.lightline             = {colorscheme = 'fahrenheit'}
vim.g.python3_host_prog     = '/usr/bin/python3'
vim.g.signify_sign_change   = '~'




vim.cmd('packadd minpac')
vim.fn['minpac#add']('k-takata/minpac', {type = 'opt'})
vim.fn['minpac#add']('fcpg/vim-fahrenheit')
vim.fn['minpac#add']('mhinz/vim-signify')
vim.fn['minpac#add']('itchyny/lightline.vim')
vim.fn['minpac#add']('tyru/caw.vim')
vim.fn['minpac#add']('sheerun/vim-polyglot')
vim.fn['minpac#add']('neoclide/coc.nvim', {branch= 'release'})

-- 'neovim/nvim-lspconfig'
-- 'nvim-lua/completion-nvim'




vim.api.nvim_exec([[
augroup Coc
    autocmd!
    autocmd BufWritePre *.go    silent call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd BufWritePre *       silent call CocAction('format')
    autocmd BufWritePre *       silent :%s/\s\+$//e
    autocmd BufWritePre *       silent :v/\_s*\S/d
    autocmd BufWritePre *       silent :nohlsearch
augroup END
]], false)

vim.api.nvim_command([[
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]])




vim.api.nvim_command('colorscheme fahrenheit')
vim.api.nvim_command('hi DiffAdd    ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse')
vim.api.nvim_command('hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse')
vim.api.nvim_command('hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse')
vim.api.nvim_command('hi DiffText   ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ff8700 gui=reverse')




vim.api.nvim_set_keymap('c', 'cr',      'google-chrome-stable % 2>/dev/null',                               {noremap = true})
vim.api.nvim_set_keymap('c', 'WQ',      'wq',                                                               {noremap = true})
vim.api.nvim_set_keymap('c', 'W',       [[ execute 'silent! write !sudo tee % >/dev/null' <bar> edit!]],    {noremap = true})

vim.api.nvim_set_keymap('i', '<TAB>',   [[ pumvisible() ? "\<C-n>" :  <SID>check_back_space() ? "\<TAB>" : coc#refresh() ]],    {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<S-TAB>', [[ pumvisible() ? "\<C-p>" : "\<C-h>" ]],                                               {noremap = true, silent = true, expr = true})

vim.api.nvim_set_keymap('n', ';',       ':',                            {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gd',      '<Plug>(coc-definition)',       {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gt',      '<Plug>(coc-type-definition)',  {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<TAB>',   '<Plug>(coc-diagnostic-next)',  {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-TAB>', '<Plug>(coc-diagnostic-prev)',  {noremap = true, silent = true})
