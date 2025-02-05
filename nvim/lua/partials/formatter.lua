local module = {}

function module.init()
	local group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		command = "FormatWrite",
	})
end

function module.config()
	require("formatter").setup({
		filetype = {
			lua = { require("formatter.filetypes.lua").stylua },
			go = { require("formatter.filetypes.go").goimports },
			graphql = { require("formatter.filetypes.graphql").prettier },
			proto = { require("formatter.filetypes.proto").buf_format },
			terraform = { require("formatter.filetypes.terraform").terraformfmt },
			rust = {
				function()
					return {
						exe = "rustfmt",
						args = { "--emit=stdout", "--edition=2021" },
						stdin = true,
					}
				end,
			},
			javascript = { require("formatter.filetypes.javascript").prettier },
			typescript = { require("formatter.filetypes.typescript").prettier },
			javascriptreact = { require("formatter.filetypes.javascript").prettier },
			typescriptreact = { require("formatter.filetypes.typescript").prettier },
		},
	})
end

return module
