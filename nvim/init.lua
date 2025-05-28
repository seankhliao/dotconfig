-- https://neovim.io/doc/user/options.html#options
vim.o.autowrite = true
vim.o.clipboard = "unnamedplus"
vim.o.colorcolumn = "100"
vim.o.completeopt = "fuzzy,menuone,noinsert,noselect,popup"
vim.o.confirm = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.incsearch = true
vim.o.mousefocus = true
vim.o.scrolloff = 4
vim.o.shortmess = "aoOstTWAIcC"
vim.o.sidescrolloff = 4
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.termguicolors = true
vim.o.updatetime = 300
vim.o.wildignorecase = true
vim.o.wildmode = "longest,list:longest,full"

vim.wo.breakindent = true
vim.wo.foldlevel = 99
vim.wo.number = true
-- vim.wo.spell = true
vim.wo.statusline = "%-F %-r %-m %= %{&fileencoding} | %y | %3.l/%3.L:%3.c"

vim.bo.copyindent = true
vim.bo.expandtab = true
vim.bo.modeline = false
vim.bo.shiftwidth = 0
vim.bo.smartindent = true -- tbd: messes with yaml?
vim.bo.swapfile = false
vim.bo.tabstop = 4
vim.bo.undofile = true
--
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

--
-- common typo
vim.keymap.set("c", "WQ", "wq", { desc = "write and quit" })
vim.keymap.set("c", "Wq", "wq", { desc = "write and quit" })
-- easier to remember delete without yank
vim.keymap.set("v", "s", '"_d', { desc = "delete selection without yank" })
vim.keymap.set("n", "ss", '"_dd', { desc = "delete line without yank" })
-- less shifting
vim.keymap.set("n", ";", ":", { silent = true })

-- :W write with sudo
vim.api.nvim_create_user_command("W", function()
	local tmpfilename = os.tmpname()
	local tmpfile = io.open(tmpfilename, "w")
	if not tmpfile then
		vim.api.nvim_echo({ { "failed to open tmp file" }, { tmpfilename } }, false, {
			err = true
		})
		return
	end
	for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
		tmpfile:write(line .. "\n")
	end
	tmpfile:close()
	local curfilename = vim.api.nvim_buf_get_name(0)
	os.execute(string.format("sudo tee %s < %s > /dev/null", curfilename, tmpfilename))
	vim.cmd([[ edit! ]])
	os.remove(tmpfilename)
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
			local trimmed = string.gsub(line, "%s+$", "")
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { trimmed })
		end
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.md" },
	command = "%!prettier --parser markdown",
})

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

	local config_dir = vim.env.XDG_CONFIG_HOME or "~/.config"
	local bin_dir = config_dir .. "/bin"
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

--
-- lsp configs
local cap = vim.lsp.protocol.make_client_capabilities()
local cap_ws = cap.workspace
local cap_ws_did = cap_ws.didChangeWatchedFiles
cap_ws_did.dynamicRegistration = true
vim.lsp.config("*", {
	root_markers = { ".git" },
	capabilities = cap
})

vim.lsp.config("bash", {
	-- https://github.com/bash-lsp/bash-language-server
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
	root_markers = nil,
})
vim.lsp.enable("bash")

vim.lsp.config("buf", {
	-- https://buf.build/docs/reference/cli/buf/beta/lsp/
	-- TODO: compare with https://github.com/coder3101/protols
	cmd = { "buf", "beta", "lsp", "--timeout=0", "--log-format=text" },
	filetypes = { "proto" },
	root_markers = { "buf.yaml", ".git" },
})
vim.lsp.enable("buf")

vim.lsp.config("css", {
	-- https://github.com/hrsh7th/vscode-langservers-extracted
	cmd = { 'vscode-css-language-server', '--stdio' },
	filetypes = { "css" },
	root_markers = nil,
})
vim.lsp.enable("css")

vim.lsp.config("cue", {
	-- https://github.com/cue-lang/cue/wiki/cue-lsp
	cmd = { "cue", "lsp" },
	filetypes = { "cue" },
	root_markers = { "cue.mod", ".git" },
})
vim.lsp.enable("cue")

vim.lsp.config("docker", {
	-- https://github.com/rcjsuen/dockerfile-language-server-nodejs
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = nil,
})
vim.lsp.enable("docker")

-- vim.lsp.config("gh-actions", {
-- 	-- https://github.com/lttb/gh-actions-language-server
-- 	cmd = { "gh-actions-language-server", "--stdio" },
-- 	filetypes = { "yaml" },
-- 	root_dir = ".github/workflows",
-- 	root_markers = { ".github", ".git" },
-- })

vim.lsp.config("gopls", {
	-- https://github.com/golang/tools/tree/master/gopls
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", "go.sum", "go.work", ".git" },
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
		if path:find("/sdk/") then
			-- disable gofumpt when working on Go project repos
			client.config.settings.gopls.gofumpt = false
		end
	end,
})
vim.lsp.enable("gopls")

vim.lsp.config('json', {
	-- https://github.com/hrsh7th/vscode-langservers-extracted
	cmd = { 'vscode-json-language-server', '--stdio' },
	filetypes = { "json" },
	root_markers = nil,
})
vim.lsp.enable("json")

-- vim.lsp.config("helm", {
-- 	-- https://github.com/mrjosh/helm-ls
-- 	cmd = { "helm-ls", "serve" },
-- 	filetypes = { "helm" },
-- 	root_markers = { "Chart.yaml" },
-- })

vim.lsp.config("html", {
	-- https://github.com/hrsh7th/vscode-langservers-extracted
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = nil,
})
vim.lsp.enable("html")

vim.lsp.config("lua", {
	-- https://github.com/luals/lua-language-server
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
			convert = function(item)
				return { abbr = item.label:gsub("%b()", "") }
			end,
		})
	end,
})
vim.lsp.enable("lua")

vim.lsp.config("markdown", {
	-- https://github.com/artempyanykh/marksman
	-- cmd = { "marksman", "server" },
	-- https://github.com/hrsh7th/vscode-langservers-extracted
	cmd = { "vscode-markdown-language-server", "--stdio" },
	filetypes = { "markdown" },
	root_markers = nil,
})
vim.lsp.enable("markdown")

-- vim.lsp.config("sqls", {
-- 	-- https://github.com/sqls-server/sqls
-- 	-- TODO: compare with https://github.com/joe-re/sql-language-server
-- 	cmd = { "sqls" },
-- 	filetypes = { "sql", "mysql" },
-- 	root_markers = nil,
-- })

-- get directory name from file path
function Dirname(str)
	return str:match("(.*[/\\])")
end

vim.lsp.config("terraform", {
	-- https://github.com/hashicorp/terraform-ls
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform" },
	root_dir = function(bufnr, cb)
		local bufpath = vim.api.nvim_buf_get_name(bufnr)
		local bufdir = Dirname(bufpath)
		cb(bufdir)
	end
})
vim.lsp.enable("terraform")

vim.lsp.config("typos", {
	-- https://github.com/tekumara/typos-lsp
	cmd = { "typos-lsp" },
	root_markers = nil,
})
vim.lsp.enable("typos")

vim.lsp.config("yaml", {
	-- https://github.com/redhat-developer/yaml-language-server
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_markers = nil,
	settings = {
		['yaml.format.enable'] = true,
		['yaml.validate'] = true,
		['yaml.hover'] = true,
		['yaml.completion'] = true,
		['yaml.schemaStore.enable'] = true,
	},
})
vim.lsp.enable("yaml")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "open diagnostic window" })
		vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "set diagnostic loclist" })
		vim.keymap.set("n", "<space>d", vim.lsp.buf.definition, { silent = true, desc = "go to definition" })
		vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, { silent = true, desc = "show hover info" })
		vim.keymap.set("n", "<space>i", vim.lsp.buf.implementation, { silent = true, desc = "go to implementation" })
		vim.keymap.set("n", "<space>s", vim.lsp.buf.signature_help, { silent = true, desc = "show signature help" })
		-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, { silent = true, desc = "go to type definition" })
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { silent = true, desc = "rename symbol" })
		vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, { silent = true, desc = "show code actions" })
		vim.keymap.set("n", "<space>r", vim.lsp.buf.references, { silent = true, desc = "show references" })

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method("textDocument/completion") then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

			vim.keymap.set("i", "<cr>", function() return vim.fn.pumvisible() == 1 and '<c-y>' or '<cr>' end,
				{ silent = true, expr = true })
		end

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
				buffer = args.buf,
				callback = function()
					if client.name == "gopls" then
						vim.lsp.buf.code_action({
							bufnr = args.buf,
							id = client.id,
							context = {
								diagnostics = {},
								only = { 'source.organizeImports' },
							},
							apply = true,
						})
						-- vim.lsp.buf.code_action({ bufnr = args.buf, id = client.id, context = { only = { 'source.fixAll' } }, apply = true })
					end

					local path = client.workspace_folders[1].name
					if not path:find("/sdk/") then
						vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
					end
				end,
			})
		end
	end,
})

--
-- load plugins
local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
if not (vim.uv or vim.loop).fs_stat(pckr_path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/lewis6991/pckr.nvim",
		pckr_path,
	})
end
vim.opt.rtp:prepend(pckr_path)

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
	{
		-- debug highlights with :Telescope highlights
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
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
		-- requires = { "neovim/nvim-lspconfig" },
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

			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end,
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

	-- keybind reminder
	{
		"folke/which-key.nvim",
	},

	-- git integration
	{
		-- end of line blame
		"f-person/git-blame.nvim",
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
			vim.keymap.set("n", "n", function()
				vim.cmd.normal({ "n", bang = true })
				require("hlslens").start()
			end, { silent = true })
			vim.keymap.set("n", "N", function()
				vim.cmd.normal({ "N", bang = true })
				require("hlslens").start()
			end, { silent = true })
		end,
	},

	-- show diagnostics as virtual text
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = true,
				-- virtual_lines = { only_current_line = true },
			})
		end,
	},
})
