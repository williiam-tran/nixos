require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "cssls", "eslint", },
})

require("lazydev").setup({
    opts = {
        library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
    },
})

-- local capabilities = require("cmp_nvim_lsp").default_capabilities()

local capabilities = require("user.lsp.handlers").capabilities

require("lspconfig").lua_ls.setup({
    capabilities = capabilities,
    on_init = function(client)
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                runtime = {
                    version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    -- ignoreDir = { "Downloads", "AppData" },
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
            },
        })
    end,
    --
    -- 	client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    -- 	return true
    -- end,
})

-- require("lspconfig").tailwindcss.setup({
--     capabilities = capabilities,
-- })

capabilities = require("user.lsp.handlers").capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lspconfig").cssls.setup({
    capabilities = capabilities,
})
