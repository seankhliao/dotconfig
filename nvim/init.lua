vim.cmd([[ syntax enable ]])

local config_dir = vim.env.XDG_CONFIG_HOME or "~/.config"
local bin_dir = config_dir .. "/bin"
local cache_dir = vim.env.XDG_CACHE_HOME or "~/.cache"
local backup_dir = cache_dir .. "/nvim/backup"
local undo_dir = cache_dir .. "/nvim/undo"
os.execute("mkdir -p " .. backup_dir)
os.execute("mkdir -p " .. undo_dir)

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
vim.bo.commentstring = "# %s"
vim.bo.copyindent = true
vim.bo.expandtab = true
vim.bo.grepprg = "rg"
vim.bo.modeline = false
vim.bo.shiftwidth = 0
vim.bo.smartindent = true
vim.bo.swapfile = false
vim.bo.tabstop = 4
vim.bo.undofile = true

-- indenting
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

-- setup remote copy/paste through ssh osc52
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

-- load plugins
local function bootstrap_pckr()
    local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

    if not vim.loop.fs_stat(pckr_path) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/lewis6991/pckr.nvim",
            pckr_path,
        })
    end

    vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require("pckr").add({
    -- colorscheme
    {
        "dasupradyumna/midnight.nvim",
        config = function()
            vim.cmd.colorscheme("midnight")
            -- vim.api.nvim_set_hl(0, "goFormatSpecifier", {fg = "#ffffff" }) -- doesn't work
            vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
        end,
    },

    -- shared deps
    {
        -- generic shared library of lua utils
        "nvim-lua/plenary.nvim",
    },

    -- system
    {
        -- floating notification windows
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
        end,
    },

    -- language support
    {
        -- a lot of filetypes, primarily syntax highlighting
        "sheerun/vim-polyglot",
        config_pre = function()
            vim.g.polyglot_disabled = { "cue" }
        end,
    },
    {
        -- cuelang
        "jjo/vim-cue",
    },
    {
        -- treesitter text objects
        "nvim-treesitter/nvim-treesitter",
        requires = { "neovim/nvim-lspconfig" },
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",
                highlight = {
                    enable = true,
                    disable = { "dockerfile" },
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },

    -- utils
    {
        -- link to git host with <space>gl
        "ruifm/gitlinker.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitlinker").setup({
                mappings = "<space>gl",
                callbacks = {
                    ["go.googlesource.com"] = function(url_data)
                        local url = require("gitlinker.hosts").get_base_https_url(url_data)
                        url = url .. "/+/" .. url_data.rev .. "/" .. url_data.file
                        if url_data.lstart then
                            url = url .. "#" .. url_data.lstart
                        end
                        return url
                    end,
                    ["lucid-git"] = function(url_data)
                        url_data.host = "github.com"
                        url_data.repo = "seankhliao/" .. url_data.repo
                        return require("gitlinker.hosts").get_github_type_url(url_data)
                    end,
                },
            })
        end,
    },
    {
        -- comment out blocks with gcc
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({})
        end,
    },
    {
        -- debug highlights with :Telescope highlights
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    },

    -- automagic
    {
        -- pair close insertion
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    },

    -- git integration
    {
        -- end of line blame
        "f-person/git-blame.nvim",
    },
    {
        -- :DiffviewOpen [ref]
        "sindrets/diffview.nvim",
    },
    {
        -- gutter signs
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                },
            })
        end,
    },

    -- kitty integration
    {
        "mikesmithgh/kitty-scrollback.nvim",
        config = function()
            require("kitty-scrollback").setup({
                {
                    restore_options = true,
                    keymaps_enabled = false,
                },
            })
        end,
    },

    -- extra info
    {
        -- colorize #hex
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({})
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            local highlight = {
                "RainbowRed",
                "RainbowOrange",
                "RainbowYellow",
                "RainbowGreen",
                "RainbowCyan",
                "RainbowBlue",
                "RainbowViolet",
            }

            local hooks = require("ibl.hooks")
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            end)

            require("ibl").setup({
                indent = {
                    highlight = {
                        "RainbowRed",
                        "RainbowOrange",
                        "RainbowYellow",
                        "RainbowGreen",
                        "RainbowCyan",
                        "RainbowBlue",
                        "RainbowViolet",
                    },
                },
                exclude = {
                    buftypes = { "terminal", "nofile" },
                },
                scope = {
                    highlight = highlight,
                },
            })
        end,
    },
    {
        -- search hover info
        "kevinhwang91/nvim-hlslens", -- better search
        config = function()
            require("hlslens").setup()

            local kopts = { noremap = true, silent = true }
            vim.api.nvim_set_keymap(
                "n",
                "n",
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap(
                "n",
                "N",
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)
        end,
    },

    -- formatting
    {
        -- format on write
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
    },

    -- lsp
    {
        "neovim/nvim-lspconfig",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "sheerun/vim-polyglot",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.workspace = { didChangeWatchedFiles = { dynamicRegistration = true } }

            vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
            vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

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
                -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("n", "<space>r", vim.lsp.buf.references, bufopts)
                -- vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
            end
            local lspconfig = require("lspconfig")
            lspconfig.bashls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.dartls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.dockerls.setup({
                capabilities = capabilities,
                -- on_attach = on_attach,
            })
            lspconfig.gopls.setup({
                -- cmd = { 'gopls', '-logfile=/tmp/gopls.log' }, -- save file and :PackerCompile to take effect
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                        templateExtensions = { "gotmpl" },
                        vulncheck = "Imports",
                        analyses = {
                            shadow = true,
                        },
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

            -- lspconfig.pylsp.setup({
            --   capabilities = capabilities,
            --   on_attach = on_attach,
            --   settings = {
            --     pylsp = {
            --       plugins = {
            --         black = { enabled = true },
            --         autopep8 = { enabled = false },
            --         yapf = { enabled = false },
            --         pylint = { enabled = true, executable = "pylint" },
            --         pyflakes = { enabled = false },
            --         pycodestyle = { enabled = false },
            --         pylsp_mypy = { enabled = false }, -- TODO: virtal envs
            --         jedi_completion = { fuzzy = true },
            --         pyls_isort = { enabled = true },
            --       },
            --     },
            --   },
            -- })
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
                        yamlEditor = {
                            ["editor.insertSpaces"] = false,
                            ["editor.formatOnType"] = false,
                        },
                    },
                },
            })
        end,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    },

    -- completions
    {
        "hrsh7th/nvim-cmp",
        requires = { "windwp/nvim-autopairs" },
        config = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end

            local cmp = require("cmp")
            cmp.setup({
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    -- ["<CR>"] = cmp.mapping({
                    --     i = function(fallback)
                    --         if cmp.get_active_entry() and cmp.visible() then
                    --             cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                    --         else
                    --             fallback()
                    --          end
                    --     end,
                    --     s = cmp.mapping.confirm({ select = true }),
                    --     c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    -- }),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn["vsnip#available"](1) == 1 then
                            feedkey("<Plug>(vsnip-expand-or-jump)", "")
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                            feedkey("<Plug>(vsnip-jump-prev)", "")
                        end
                    end, { "i", "s" }),

                    ['<C-e>'] = cmp.mapping.abort(),

                    ["<Down>"] = cmp.mapping(
                        cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                        { "i" }
                    ),
                    ["<Up>"] = cmp.mapping(
                        cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                        { "i" }
                    ),
                },
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                sources = {
                    { name = "buffer" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "vsnip" },
                    { name = "path" },
                },
            })
        end,
    },
    { "hrsh7th/cmp-nvim-lsp" }, -- lsp integration
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" }, --filesystem path completion
    { "hrsh7th/cmp-vsnip" }, -- snippet completion
    { "hrsh7th/vim-vsnip" }, -- snippet engine
    { "hrsh7th/cmp-nvim-lua" }, -- nvim lua runtime api completion
    { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- display function signatures
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup({})
        end,
    },
})

-- :W write with sudo
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

-- common typo
vim.api.nvim_set_keymap("c", "WQ", "wq", { noremap = true })
vim.api.nvim_set_keymap("c", "Wq", "wq", { noremap = true })
-- easier to remember delete without yank
vim.api.nvim_set_keymap("v", "s", '"_d', { noremap = true })
vim.api.nvim_set_keymap("n", "ss", '"_dd', { noremap = true })
-- less shifting
vim.api.nvim_set_keymap("n", ";", ":", { noremap = true, silent = true })

-- more format on writes
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

vim.api.nvim_exec(
    [[
augroup Clean
autocmd!
autocmd BufWritePre *.go    silent :lua vim.lsp.buf.format()
autocmd BufWritePre *       silent :FormatWrite
augroup END
]],
    false
)
