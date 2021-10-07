vim.cmd [[ filetype plugin indent on ]]
vim.cmd [[ syntax enable' ]]




local cache_dir = vim.env.XDG_CACHE_HOME
local backup_dir = cache_dir .. '/nvim/backup'
local undo_dir = cache_dir .. '/nvim/undo'
vim.fn.system({'mkdir', '-p', backup_dir})
vim.fn.system({'mkdir', '-p', undo_dir})

vim.o.background     = 'dark'
vim.o.backupdir      = backup_dir
vim.o.clipboard      = 'unnamedplus'
vim.o.completeopt    = 'menuone,noinsert,noselect'
vim.o.confirm        = true
vim.o.fsync          = true
vim.o.ignorecase     = true
vim.o.inccommand     = 'split'
vim.o.incsearch      = true
vim.o.mouse          = 'a'
vim.o.mousefocus     = true
vim.o.scrolloff      = 4
vim.o.shortmess      = 'aoOtTIc'
vim.o.sidescrolloff  = 4
vim.o.signcolumn     = 'yes'
vim.o.smartcase      = true
vim.o.smarttab       = true
vim.o.termguicolors  = true
vim.o.undodir        = undo_dir
vim.o.updatetime     = 300
vim.o.wildignorecase = true
vim.o.wildmode       = 'longest,list:longest,full'

vim.wo.breakindent   = true
vim.wo.foldenable    = false
vim.wo.number        = true
vim.wo.statusline    = '%-F %-r %-m %= %{&fileencoding} | %y | %3.l/%3.L:%3.c'

vim.bo.autoindent    = true
vim.bo.autoread      = true
vim.bo.commentstring = '#\\ %s'
vim.bo.copyindent    = true
vim.bo.expandtab     = true
vim.bo.grepprg       = 'rg'
vim.bo.modeline      = false
vim.bo.shiftwidth    = 0
vim.bo.smartindent   = true
vim.bo.swapfile      = false
vim.bo.tabstop       = 4
vim.bo.undofile      = true




vim.g.signify_sign_change   = '~'


if vim.env.SSH_CONNECTION != nil then
    vim.g.clipboard = {
        name = 'osc52clip',
        copy = {
            ['+'] = 'osc52clip copy',
        },
        paste = {
            ['+'] = 'osc52clip paste',
        },
    }

    -- -- put in PATH as osc52clip
    -- #!/bin/bash
    --
    -- : ${TTY:=`(tty || tty </proc/$PPID/fd/0) 2>/dev/null | grep /dev/`}
    --
    -- case $1 in
    --     copy)
    --         buffer=$(base64)
    --         [[ -n "$TTY" ]] && printf $'\e]52;c;%s\a' "$buffer" > "$TTY"
    --
    --     paste)
    --         exit 1
    -- esac
end




local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_install_path})
    vim.cmd [[ packadd packer.nvim ]]
end

require'packer'.startup(function()
    use {'fcpg/vim-fahrenheit'}
    use {'mhinz/vim-signify'}
    use {'sheerun/vim-polyglot'}
    use {'tyru/caw.vim'}
    use {'wbthomason/packer.nvim'}
    use {
        'neoclide/coc.nvim',
        branch = 'release',
        run = ':CocInstall coc-dictionary coc-graphql coc-prettier coc-json coc-pairs coc-swagger coc-syntax coc-word coc-yaml',
    }
end)




vim.cmd [[ colorscheme   fahrenheit ]]
vim.cmd [[ hi DiffAdd    ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse ]]
vim.cmd [[ hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse ]]
vim.cmd [[ hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse ]]
vim.cmd [[ hi DiffText   ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ff8700 gui=reverse ]]
vim.cmd [[ cnoreabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit! ]]


vim.api.nvim_set_keymap('c', 'WQ',  'wq',   {noremap = true})
vim.api.nvim_set_keymap('v', 's',   '"_d',  {noremap = true})
vim.api.nvim_set_keymap('n', 'ss',  '"_dd', {noremap = true})
vim.api.nvim_set_keymap('n', ';',   ':',    {noremap = true, silent = true})




vim.api.nvim_exec([[
augroup Clean
    autocmd!
    autocmd BufWritePre *.go    silent :call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd BufWritePre *       silent :%s/\s\+$//e
    autocmd BufWritePre *       silent :v/\_s*\S/d
    autocmd BufWritePre *       silent :nohlsearch
augroup END
]], false)


vim.api.nvim_exec([[
autocmd FileType go         setlocal shiftwidth=8 softtabstop=8 tabstop=8 expandtab
autocmd FileType html       setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType make       setlocal noexpandtab
autocmd FileType markdown   setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType toml       setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType yaml       setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
]], false)
