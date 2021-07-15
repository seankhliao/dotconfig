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
vim.o.completeopt       = 'menuone,noselect'
-- vim.o.completeopt       = 'menuone,noinsert,noselect,preview'
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




local nvim_lsp = require('lspconfig')
nvim_lsp.gopls.setup{
    root_dir = nvim_lsp.util.root_pattern('go.mod');
    settings = {
        gopls = {
            gofumpt = true,
            linksInHover = false,
            staticcheck = true,
            analyses = {
                ST1000 = false,
            },
        },
    },
    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach()
    end,
    on_init = function(client)
        if string.match(vim.loop.cwd(), vim.env.HOME .. '/go/.*') then
            client.config.settings.gopls.gofumpt = false
            client.notify("workspace/didChangeConfiguration")
        end
        return true
    end
}
nvim_lsp.terraformls.setup{}
nvim_lsp.yamlls.setup{
    settings = {
        yaml = {
            schemaStore = {
                enable = true,
                url = "https://json.schemastore.org/"
            },
            schemas = {
                kubernetes = {'*.k8s.yaml'}
            },
        },
    },
}




require'nvim-treesitter.configs'.setup {
  ensure_installed  = "maintained",
  highlight         = { enable = true },
  indent            = { enable = true },
}




require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = "none",
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    treesitter = true;
  };
}




require'formatter'.setup {
    logging = false,
    filetype = {
        markdown = {
            function()
                return {
                    exe = "prettier",
                    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--parser', 'markdown'},
                    stdin = true,
                }
            end
        }
    }
}




require'nvim-autopairs'.setup {
    map_cr = true,
    map_complete = true
}




vim.cmd [[ colorscheme   fahrenheit ]]
vim.cmd [[ hi DiffAdd    ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse ]]
vim.cmd [[ hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse ]]
vim.cmd [[ hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse ]]
vim.cmd [[ hi DiffText   ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ff8700 gui=reverse ]]

vim.cmd [[ cnoreabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit! ]]


vim.api.nvim_set_keymap('c', 'WQ', 'wq', {noremap = true})
vim.api.nvim_set_keymap('v', 's', '"_d', {noremap = true})
vim.api.nvim_set_keymap('n', 'ss', '"_dd', {noremap = true})
vim.api.nvim_set_keymap('n', ';', ':', {noremap = true, silent = true})




local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})


local kmopt = {expr = true, noremap = true, silent = true}
vim.api.nvim_set_keymap("i", "<C-Space>", [[ compe#complete() ]], kmopt)
-- vim.api.nvim_set_keymap("i", "<CR>",      [[ compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' }) ]], kmopt)
-- vim.api.nvim_set_keymap("i", "<CR>",      [[ compe#confirm('<CR>') ]], kmopt)
vim.api.nvim_set_keymap("i", "<CR>",      [[ compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()")) ]], kmopt)
vim.api.nvim_set_keymap("i", "<C-e>",     [[ compe#close('<C-e>') ]], kmopt)
vim.api.nvim_set_keymap("i", "<C-f>",     [[ compe#scroll({ 'delta': +4 }) ]], kmopt)
vim.api.nvim_set_keymap("i", "<C-d>",     [[ compe#scroll({ 'delta': -4 }) ]], kmopt)


local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    os.execute('git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require'packer'.startup(function()
    use {'wbthomason/packer.nvim'}
    use {'fcpg/vim-fahrenheit'}
    use {'mhinz/vim-signify'}
    use {'tyru/caw.vim'}
    use {'windwp/nvim-autopairs'}
    use {'sheerun/vim-polyglot'}
    use {'neovim/nvim-lspconfig'}
    use {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
    use {'hrsh7th/vim-vsnip'}
    use {'hrsh7th/nvim-compe'}
    use {'mhartington/formatter.nvim'}
    use {'ray-x/lsp_signature.nvim'}
end)



-- Synchronously organise (Go) imports.
function goimports(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
        if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit)
        end
        if type(action.command) == "table" then
            vim.lsp.buf.execute_command(action.command)
        end
    else
        vim.lsp.buf.execute_command(action)
    end
end


vim.api.nvim_exec([[
augroup Clean
    autocmd!
    " autocmd BufWritePre *.go    lua vim.lsp.buf.code_action({source={organizeImports=true}})
    autocmd BufWritePre *.go    lua goimports(1000)
    autocmd BufWritePost *.md    FormatWrite
    autocmd BufWritePre *       lua vim.lsp.buf.formatting_sync()
    autocmd BufWritePre *       silent :%s/\s\+$//e
    autocmd BufWritePre *       silent :v/\_s*\S/d
    autocmd BufWritePre *       silent :nohlsearch
augroup END
]], false)
