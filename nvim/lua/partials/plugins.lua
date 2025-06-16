vim.g.mapleader = "," -- setting leader before lazy so mappings are correct

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("partials/lsp")
		end,
		event = { "FileType" },
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.gruvbox_material_enable_italic = true
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = require("partials/completion").config,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/cmp-buffer",
		},
		event = { "BufEnter" },
	},
	{ "hrsh7th/vim-vsnip", event = { "VeryLazy" } },
	{ "hrsh7th/vim-vsnip-integ", event = { "VeryLazy" } },
	{
		"ibhagwan/fzf-lua",
		init = require("partials/fzf").init,
		config = require("partials/fzf").config,
		cmd = { "FzfLua" },
	},
	{
		"stevearc/oil.nvim",
		event = { "VeryLazy" },
		config = function()
			require("oil").setup({
				delete_to_trash = true,
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
		"mhartington/formatter.nvim",
		cmd = { "FormatWrite" },
		init = require("partials/formatter").init,
		config = require("partials/formatter").config,
	},
	{
		"github/copilot.vim",
		ft = { "go", "rust", "zig", "cpp", "typescript", "proto", "python" },
		config = function()
			vim.keymap.set("i", "<C-f>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
			vim.g.copilot_no_tab_map = true
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		event = { "VeryLazy" },
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
	{
		"vim-test/vim-test",
		ft = { "go", "rust", "zig", "cpp" },
		init = function()
			vim.api.nvim_set_keymap("n", "<leader>tt", ":TestNearest<cr>", {})
			vim.api.nvim_set_keymap("n", "<leader>tp", ":TestFile<cr>", {})
			vim.api.nvim_set_keymap("n", "<leader>ta", ":TestSuite<cr>", {})
			vim.api.nvim_exec(
				[[
                    let test#strategy = "neovim"
                    let test#neovim#start_normal = 1
                 ]],
				false
			)
		end,
	},
	{
		"jbyuki/instant.nvim",
		init = function()
			vim.g.instant_username = "LukusPlucus"
		end,
		event = { "VeryLazy" },
	},
	--{
	--	"mfussenegger/nvim-dap",
	--    config = function()
	--        local dap, dapui = require('dap'), require('dapui')
	--        dap.listeners.before.attach.dapui_config = function()
	--			dapui.open()
	--		end
	--    end,
	--},
	--{
	--	"leoluz/nvim-dap-go",
	--	config = function()
	--		local dap, dapui = require("dap"), require("dapui")
	--		local dapgo = require("dap-go")
	--		dapui.setup()
	--		dapgo.setup()
	--		dap.listeners.before.attach.dapui_config = function()
	--			dapui.open()
	--		end
	--		dap.listeners.before.launch.dapui_config = function()
	--			dapui.open()
	--		end
	--		vim.keymap.set("n", "<F5>", function()
	--			require("dap").continue()
	--		end)
	--		vim.keymap.set("n", "<F10>", function()
	--			require("dap").step_over()
	--		end)
	--		vim.keymap.set("n", "<F11>", function()
	--			require("dap").step_into()
	--		end)
	--		vim.keymap.set("n", "<F12>", function()
	--			require("dap").step_out()
	--		end)
	--		vim.keymap.set("n", "<Leader>q", function()
	--			require("dap").toggle_breakpoint()
	--		end)
	--		vim.keymap.set("n", "<Leader>Q", function()
	--			require("dap").set_breakpoint()
	--		end)
	--		vim.keymap.set("n", "<Leader>lp", function()
	--			require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	--		end)
	--		vim.keymap.set("n", "<Leader>dr", function()
	--			require("dap").repl.open()
	--		end)
	--		vim.keymap.set("n", "<Leader>dl", function()
	--			require("dap").run_last()
	--		end)

	--		vim.keymap.set("n", "<Leader>w", function()
	--			dapui.open()
	--		end)
	--		vim.keymap.set("n", "<Leader>W", function()
	--			dapui.close()
	--		end)
	--	end,
	--	event = { "VeryLazy" },
	--},
	--{
	--	"pmizio/typescript-tools.nvim",
	--	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	--	opts = {},
	--	config = function()
	--		require("typescript-tools").setup({
	--			on_attach = function(client, bufnr)
	--				client.server_capabilities.documentFormattingProvider = false
	--				client.server_capabilities.documentRangeFormattingProvider = false
	--			end,
	--			settings = {
	--				jsx_close_tag = {
	--					enable = true,
	--					filetypes = { "javascriptreact", "typescriptreact" },
	--				},
	--			},
	--		})
	--	end,
	--},
}
