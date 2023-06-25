vim.cmd([[ syntax enable ]])

local config_dir = vim.env.XDG_CONFIG_HOME or "~/.config"
local bin_dir = config_dir .. "/bin"
local cache_dir = vim.env.XDG_CACHE_HOME or "~/.cache"
local backup_dir = cache_dir .. "/nvim/backup"
local undo_dir = cache_dir .. "/nvim/undo"
os.execute("mkdir -p " .. backup_dir)
os.execute("mkdir -p " .. undo_dir)

vim.g.did_load_filetypes = 1
vim.g.do_filetype_lua = 1
vim.g.signify_sign_change = "~"

-- https://neovim.io/doc/user/options.html#options
vim.o.background = "dark"
vim.o.backupdir = backup_dir
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.confirm = true
vim.o.fsync = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.incsearch = true
vim.o.mouse = "a"
vim.o.mousefocus = true
vim.o.scrolloff = 4
vim.o.shortmess = "aoOtTIc"
vim.o.sidescrolloff = 4
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.termguicolors = true
vim.o.undodir = undo_dir
vim.o.updatetime = 300
vim.o.wildignorecase = true
vim.o.wildmode = "longest,list:longest,full"

vim.wo.breakindent = true
vim.wo.foldenable = false
vim.wo.number = true
vim.wo.statusline = "%-F %-r %-m %= %{&fileencoding} | %y | %3.l/%3.L:%3.c"

vim.bo.autoindent = true
vim.bo.autoread = true
vim.bo.commentstring = "#\\ %s"
vim.bo.copyindent = true
vim.bo.expandtab = true
vim.bo.grepprg = "rg"
vim.bo.modeline = false
vim.bo.shiftwidth = 0
vim.bo.smartindent = true
vim.bo.swapfile = false
vim.bo.tabstop = 4
vim.bo.undofile = true

if vim.env.SSH_CONNECTION ~= nil then
    vim.g.clipboard = {
        name = "osc52clip",
        copy = {
            ["+"] = "osc52clip copy",
        },
        paste = {
            ["+"] = "osc52clip paste",
        },
    }

    local osc52clip = io.open(bin_dir .. "/osc52clip", "w")
    if osc52clip ~= nil then
        osc52clip:write([[#!/bin/bash
: ${TTY:=$((tty || tty </proc/$PPID/fd/0) 2>/dev/null | grep /dev/)}

case $1 in
copy)
buffer=$(base64)
[ -n "$TTY" ] && printf $'\e]52;c;%s\a' "$buffer" > "$TTY"
;;
paste)
exit 1
;;
esac
]])
        osc52clip:close()
        os.execute("chmod +x " .. bin_dir .. "/osc52clip")
    end
end

local ensure_packer = function()
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
end
return false
end

local packer_bootstrap = ensure_packer()
require('packer').startup(function(use)
    use({"wbthomason/packer.nvim"})

    use {'dasupradyumna/midnight.nvim'}
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                buftype_exclude = {
                    "terminal",
                    "nofile",
                },
                char_highlight_list = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                    "IndentBlanklineIndent3",
                    "IndentBlanklineIndent4",
                    "IndentBlanklineIndent5",
                    "IndentBlanklineIndent6",
                },
                show_first_indent_level = false,
                show_end_of_line = true,
                space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = true,
            })

            local set_hl = {
                IndentBlanklineIndent1 = { fg = "#E06C75" },
                IndentBlanklineIndent2 = { fg = "#E5C07B" },
                IndentBlanklineIndent3 = { fg = "#98C379" },
                IndentBlanklineIndent4 = { fg = "#56B6C2" },
                IndentBlanklineIndent5 = { fg = "#61AFEF" },
                IndentBlanklineIndent6 = { fg = "#C678DD" },
                DiffAdd = { ctermbg = 235, ctermfg = 108, bg = "#A3BE8C", fg = "#262626" },
                DiffChange = { ctermbg = 235, ctermfg = 103, bg = "#B48EAD", fg = "#262626" },
                DiffDelete = { ctermbg = 235, ctermfg = 131, bg = "#BF616A", fg = "#262626" },
                DiffText = { ctermbg = 235, ctermfg = 208, bg = "#5E81AC", fg = "#262626" },
            }
            for k, v in pairs(set_hl) do
                vim.api.nvim_set_hl(0, k, v)
            end
        end,
    })
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = {
                    "awk", "bash", "c", "capnp", "comment", "cpp", "css", "cue", "dart", "diff", "dockerfile", "dot",
                    "ebnf", "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
                    "go", "gomod", "gosum", "gowork", "graphql", "hcl", "html",
                    "java", "javascript", "jq", "json", "jsonnet", "latex", "lua", "luadoc",
                    "make", "markdown", "markdown_inline", "nix", "passwd", "proto", "python",
                    "regex", "rego", "rust", "sql", "starlark", "terraform", "toml", "typescript",
                    "vim", "vimdoc", "yaml" },
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            }
        end,
    })
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim"},
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { hl = "DiffAdd", text = "+" },
                    change = { hl = "DiffChange", text = "~" },
                    delete = { hl = "DiffDelete" },
                    topdelete = { hl = "DiffDelete" },
                    changedelete = { hl = "DiffChange" },
                },
            })
        end
    })
    use({"sheerun/vim-polyglot"})
    use({"jjo/vim-cue"})
    use({
        "norcalli/nvim-colorizer.lua",
        config = function() require'colorizer'.setup() end,
    })
    use({"f-person/git-blame.nvim"})
    use({
        'rcarriga/nvim-notify',
        config = function() vim.notify = require("notify") end,
    })

    use({
        "numToStr/Comment.nvim",
        config = function() require "Comment".setup() end,
    })
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    })
    use({
        "mhartington/formatter.nvim",
        config = function()
            require("formatter").setup({
                filetype = {
                    css = {
                         require("formatter.filetypes.css").prettier,
                         require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                    html = {
                         require("formatter.filetypes.html").prettier,
                         require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                    json = {
                         require("formatter.filetypes.json").jq,
                         require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                    lua = {
                         require("formatter.filetypes.lua").stylua,
                         require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                    markdown = {
                         require("formatter.util").withl(require("formatter.defaults").prettier, "markdown"),
                         require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                    terraform = {
                        function()
                            return {
                                exe = "terraform",
                                args = { "fmt", "-" },
                                stdin = true,
                            }
                        end,
                        require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                    yaml = {
                        require("formatter.filetypes.yaml").prettier,
                        require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                    ["*"] = {
                        require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                },
            })

        end,
    })
    use({
        'kevinhwang91/nvim-hlslens',
        config = function()
            require('hlslens').setup()

            local kopts = {noremap = true, silent = true}
            vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)
        end,
    })

    use({
        'nvim-telescope/telescope.nvim', tag = '0.1.x',
        requires = {{'nvim-lua/plenary.nvim'}}
    })
    use({
        'ruifm/gitlinker.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function() require"gitlinker".setup() end,
    })
    use({
        'nmac427/guess-indent.nvim',
        config = function() require('guess-indent').setup()  end,
    })

    use({
        'nvim-treesitter/nvim-treesitter-context',
        requires = {{"nvim-treesitter/nvim-treesitter"}},
        config = function()
            require'treesitter-context'.setup({
                enable = true,
                separator = '-',
            })
        end,
    })

    use({
        "L3MON4D3/LuaSnip",
        config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    })
    use({"saadparwaiz1/cmp_luasnip"})
    use({
        "hrsh7th/nvim-cmp",
        requires = {{"L3MON4D3/LuaSnip"}},
        config = function()
            local luasnip = require("luasnip")
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            local cmp = require("cmp")
            cmp.setup({
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
                    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "buffer" },
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = 'nvim_lua' },
                },
            })
        end,
    })
    use({"hrsh7th/cmp-buffer"})
    use({"hrsh7th/cmp-nvim-lsp-signature-help"})
    use({
        "ray-x/lsp_signature.nvim",
        config = function() require "lsp_signature".setup() end,
    })
    use({"hrsh7th/cmp-nvim-lua"})

    use({
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = { noremap = true, silent = true, buffer = bufnr }
                -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                vim.keymap.set("n", "<space>d", vim.lsp.buf.definition, bufopts)
                vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "<space>i", vim.lsp.buf.implementation, bufopts)
                vim.keymap.set("n", "<space>s", vim.lsp.buf.signature_help, bufopts)
                -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                -- vim.keymap.set('n', '<space>wl', function()
                --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                -- end, bufopts)
                -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("n", "<space>r", vim.lsp.buf.references, bufopts)
                vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
            end
            local lspconfig = require("lspconfig")
            lspconfig.bashls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.dockerls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    gopls = {
                         gofumpt = true,
                         staticcheck = true,
                         templateExtensions = {"gotmpl"}
                    },
                },
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if path:find("sdk/go") then
                        client.config.settings.gopls.gofumpt = false
                    end
                end,
            })
            lspconfig.jsonls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.terraformls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.yamlls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    yaml = {
                         disableDefaultProperties = true,
                         schemaStore = {
                            url = "https://www.schemastore.org/api/json/catalog.json",
                            enable = true,
                         },
                         schemas = {
                            ["file:///home/arccy/third_party/kubernetes-json-schema/default/v1.26.5-standalone/all.json"] = {"*.k8s.yaml"},
                            kubernetes = "",
                         },
                         yamlEditor = {
                            ["editor.insertSpaces"] = false,
                            ["editor.formatOnType"] = false,
                         },
                    },
                },
            })
        end,
    })
    use({"hrsh7th/cmp-nvim-lsp"})


    if packer_bootstrap then
        require('packer').sync()
    end
end)

if packer_install then
    require("packer").install()
end

vim.cmd.colorscheme 'midnight'

function sudowrite()
    local tmpfilename = os.tmpname()
    local tmpfile = io.open(tmpfilename, "w")
    for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        tmpfile:write(line .. "\n")
    end
    tmpfile:close()
    local curfilename = vim.api.nvim_buf_get_name(0)
    os.execute(string.format("sudo tee %s < %s > /dev/null", curfilename, tmpfilename))
    vim.cmd([[ edit! ]])
    os.remove(tmpfilename)
end
vim.cmd([[ command W :lua sudowrite() ]])

vim.api.nvim_set_keymap("c", "WQ", "wq", { noremap = true })
vim.api.nvim_set_keymap("v", "s", '"_d', { noremap = true })
vim.api.nvim_set_keymap("n", "ss", '"_dd', { noremap = true })
vim.api.nvim_set_keymap("n", ";", ":", { noremap = true, silent = true })

function goimports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

vim.api.nvim_exec([[
augroup Clean
autocmd!
autocmd BufWritePre *.go        silent :lua goimports(1000)
autocmd BufWritePre *.go        silent :lua vim.lsp.buf.format()
autocmd BufWritePre *           silent :FormatWrite
augroup END
]],false)

local ft_tab_width = {
    [2] = { "html", "javascript", "markdown", "toml", "yaml" },
    [8] = { "go" },
}
for k, v in pairs(ft_tab_width) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = v,
        callback = function()
            vim.opt_local.shiftwidth = k
            vim.opt_local.softtabstop = k
            vim.opt_local.tabstop = k
        end,
    })
end
