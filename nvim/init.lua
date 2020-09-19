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


vim.api.nvim_command('colorscheme fahrenheit')
vim.api.nvim_command('hi DiffAdd    ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse')
vim.api.nvim_command('hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse')
vim.api.nvim_command('hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse')
vim.api.nvim_command('hi DiffText   ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ff8700 gui=reverse')


vim.api.nvim_command([[ cnoreabbrev cr google-chrome-stable % 2>/dev/null ]])
vim.api.nvim_command([[ cnoreabbrev WQ wq ]])
vim.api.nvim_command([[ cnoreabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit! ]])
vim.api.nvim_set_keymap('i', '<TAB>',   'pumvisible() ? "\\<C-n>" : "\\<Tab>"',                             {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<S-TAB>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"',                           {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('n', ';',       ':',                                                                {noremap = true, silent = true})


-- https://github.com/neovim/nvim-lspconfig
-- vim.cmd('packadd nvim-lspconfig')
-- vim.cmd('packadd completion-nvim')
-- require'nvim_lsp'.bashls.setup{}
-- require'nvim_lsp'.clangd.setup{}
-- require'nvim_lsp'.cssls.setup{}
-- require'nvim_lsp'.dockerls.setup{}
-- require'nvim_lsp'.gopls.setup{}
-- require'nvim_lsp'.html.setup{}
-- require'nvim_lsp'.jsonls.setup{}
-- require'nvim_lsp'.pyls.setup{}
-- require'nvim_lsp'.terraformls.setup{}
-- require'nvim_lsp'.texlab.setup{}
-- require'nvim_lsp'.yamlls.setup{}


function packinit()
    vim.cmd('packadd minpac')
    vim.fn['minpac#init']()
    vim.fn['minpac#add']('k-takata/minpac', {type = 'opt'})
    vim.fn['minpac#add']('fcpg/vim-fahrenheit')
    vim.fn['minpac#add']('mhinz/vim-signify')
    vim.fn['minpac#add']('itchyny/lightline.vim')
    vim.fn['minpac#add']('tyru/caw.vim')
    vim.fn['minpac#add']('sheerun/vim-polyglot')
    vim.fn['minpac#add']('neoclide/coc.nvim', {branch = 'release'})
    -- vim.fn['minpac#add']('neovim/nvim-lspconfig')
    -- vim.fn['minpac#add']('nvim-lua/completion-nvim')
end
function packupdate()
    packinit()
    vim.fn['minpac#update']()
end
function packclean()
    packinit()
    vim.fn['minpac#clean']()
end
-- function go_organize_imports_sync(timeout_ms)
--   local context = { source = { organizeImports = true } }
--   vim.validate { context = { context, 't', true } }
--   local params = vim.lsp.util.make_range_params()
--   params.context = context
--
--   local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
--   if not result then return end
--   result = result[1].result
--   if not result then return end
--   edit = result[1].edit
--   vim.lsp.util.apply_workspace_edit(edit)
-- end
--
--     " autocmd BufWritePre *.go    silent :lua go_organize_imports_sync(10000)
--     " autocmd BufWritePre *       silent :lua vim.lsp.buf.formatting_sync()

vim.api.nvim_command([[ command! PackUpdate call v:lua.packupdate() ]])
vim.api.nvim_command([[ command! PackClean  call v:lua.packclean() ]])


vim.api.nvim_exec([[
augroup Clean
    autocmd!
    autocmd BufWritePre *.go    silent :call CocAction('organizeImport')
    autocmd BufWritePre *.go    silent :call CocAction('format')
    autocmd BufWritePre *       silent :%s/\s\+$//e
    autocmd BufWritePre *       silent :v/\_s*\S/d
    autocmd BufWritePre *       silent :nohlsearch
augroup END
]], false)

-- vim.api.nvim_command([[ autocmd BufEnter * lua require'completion'.on_attach() ]])
-- vim.api.nvim_command([[ autocmd BufEnter go.mod set filetype=gomod  ]])
