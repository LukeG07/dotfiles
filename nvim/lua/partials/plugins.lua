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
		ft = { "go", "rust", "zig", "cpp", "typescript" },
		config = function()
			vim.keymap.set("i", "<C-f>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
			vim.g.copilot_no_tab_map = true
		end,
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
}
