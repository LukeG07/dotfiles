local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.keymap.set("n", "R", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.keymap.set("v", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.keymap.set("n", "gl", "<cmd>lua vim.lsp.codelens.run()<CR>", opts)
	vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.keymap.set("n", "E", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.keymap.set("n", "<C-s><C-s>", "<cmd>lua vim.lsp.buf.document_highlight()<CR>", opts)
	vim.keymap.set("n", "<C-s><C-h>", "<cmd>lua vim.lsp.buf.clear_references()<CR>", opts)
	vim.keymap.set("n", "<leader>ws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
	vim.keymap.set("n", "<leader>ds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
	vim.keymap.set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	vim.keymap.set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	vim.keymap.set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	vim.keymap.set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.keymap.set("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	vim.keymap.set("n", "Q", "<cmd>lua vim.diagnostic.setloclist({open_loclist = true, workspace = true})<CR>", opts)
	vim.keymap.set(
		"n",
		"<leader>h",
		"<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
		opts
	)

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	if client.supports_method("textDocument/codeLens") then
		vim.api.nvim_command(
			"autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })"
		)
	end
end

-- do not include test or mocks files in Go
local original_on_references = vim.lsp.handlers["textDocument/references"]
local original_on_implementation = vim.lsp.handlers["textDocument/implementation"]
local original_register_capability = vim.lsp.handlers["client/registerCapability"]

local filter_quickfix_with_callback = function(callback)
	return function(err, result, ctx, config)
		if result == nil then
			return callback(err, result, ctx, config)
		end

		local out = {}
		for _, v in pairs(result) do
			local filename = v["uri"]
			if not string.find(filename, "_test.go") and not string.match(filename, "../mocks/") then
				table.insert(out, v)
			end
		end
		callback(err, out, ctx, config)
	end
end

vim.lsp.handlers["textDocument/references"] = vim.lsp.with(filter_quickfix_with_callback(original_on_references), {})
vim.lsp.handlers["textDocument/implementation"] =
	vim.lsp.with(filter_quickfix_with_callback(original_on_implementation), {})
vim.lsp.handlers["client/registerCapability"] = vim.lsp.with(original_register_capability, {})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.offsetEncoding = { "utf-8" }

-- used for organising go imports. Tells gopls which packages are considered local
local get_current_gomod = function()
	local file = io.open("go.mod", "r")
	if file == nil then
		return nil
	end

	local first_line = file:read()
	local mod_name = first_line:gsub("module ", "")
	file:close()
	return mod_name
end

vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork" },
	on_attach = on_attach,
	settings = {
		["local"] = get_current_gomod(),
		gofumpt = true,
		staticcheck = true,
		usePlaceholders = true,
		hints = {
			assignVariableTypes = false,
			compositeLiteralFields = true,
			compositeLiteralTypes = true,
			constantValues = true,
			functionTypeParameters = true,
			parameterNames = true,
			rangeVariableTypes = true,
		},
		analyses = {
			modernize = true,
		},
		codelenses = {
			generate = true,
			gc_details = true,
			references = true,
			regenerate_cgo = true,
			tidy = true,
			test = false,
			upgrade_dependency = true,
			vendor = true,
			run_govulncheck = true,
		},
	},
}
vim.lsp.enable("gopls")

vim.lsp.config.luals = {
	cmd = { "lua-language-server" },
	on_attach = on_attach,
	filetypes = { "lua" },
	settings = {
		Lua = {
			telemetry = { enable = false },
			diagnostics = { globals = { "vim" } },
		},
	},
}
vim.lsp.enable("luals")

vim.lsp.config.clangd = {
	cmd = { "clangd" },
	on_attach = on_attach,
	filetypes = { "cpp", "c", "hpp", "h" },
}
vim.lsp.enable("clangd")

vim.lsp.config.typescript = {
	cmd = { "typescript-language-server", "--stdio" },
	on_attach = on_attach,
	filetypes = { "typescriptreact", "tsx", "ts", "typescript" },
}
vim.lsp.enable("typescript")
