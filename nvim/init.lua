vim.cmd [[ filetype plugin indent on ]]
vim.cmd [[ syntax enable' ]]




local cache_dir = vim.env.XDG_CACHE_HOME
local backup_dir = cache_dir .. '/nvim/backup'
local undo_dir = cache_dir .. '/nvim/undo'
os.execute('mkdir -p ' .. backup_dir)
os.execute('mkdir -p ' .. undo_dir)

vim.o.background        = 'dark'
vim.o.backupdir         = backup_dir
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
vim.o.undodir           = undo_dir
vim.o.updatetime        = 300
vim.o.wildignorecase    = true
vim.o.wildmode          = 'longest,list:longest,full'

vim.wo.breakindent      = true
vim.wo.foldenable       = false
vim.wo.number           = true
vim.wo.statusline       = '%-F %-r %-m %= %{&fileencoding} | %y | %3.l/%3.L:%3.c'

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




vim.g.signify_sign_change   = '~'

-- polygot conflict with tree-sitter?
-- vim.g.g:polyglot_disabled = []

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

require'nvim-treesitter.configs'.setup {
  ensure_installed  = "maintained",
  highlight         = { enable = true },
  indent            = { enable = true },
}




vim.cmd [[ colorscheme   fahrenheit ]]
vim.cmd [[ hi DiffAdd    ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse ]]
vim.cmd [[ hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse ]]
vim.cmd [[ hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse ]]
vim.cmd [[ hi DiffText   ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ff8700 gui=reverse ]]

vim.cmd [[ cnoreabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit! ]]

_G.tab1 = function() return vim.api.nvim_replace_termcodes(vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>',   true, true, true) end
_G.tab2 = function() return vim.api.nvim_replace_termcodes(vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>', true, true, true) end

vim.api.nvim_set_keymap('c', 'WQ',      'wq',           {noremap = true})
vim.api.nvim_set_keymap('i', '<TAB>',   'v:lua.tab1()', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<S-TAB>', 'v:lua.tab2()', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('v', 's',       '"_d',          {noremap = true})
vim.api.nvim_set_keymap('n', 'ss',      '"_dd',         {noremap = true})
vim.api.nvim_set_keymap('n', ';',       ':',            {noremap = true, silent = true})




local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    os.execute('git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require'packer'.startup(function()
    use {'wbthomason/packer.nvim'}
    use {'fcpg/vim-fahrenheit'}
    use {'mhinz/vim-signify'}
    use {'tyru/caw.vim'}
    use {'sheerun/vim-polyglot'}
    use {'neoclide/coc.nvim', branch='release'}
    use {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
end)




vim.api.nvim_exec([[
augroup Clean
    autocmd!
    autocmd BufWritePre *.go    silent :call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd BufWritePre *       silent :%s/\s\+$//e
    autocmd BufWritePre *       silent :v/\_s*\S/d
    autocmd BufWritePre *       silent :nohlsearch
augroup END
]], false)
