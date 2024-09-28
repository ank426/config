return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
        {
            "williamboman/mason.nvim",
            config = true,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = {
                    "basedpyright",
                    "ruff",
                },
            },
        },
    },
    config = function()
        require("lspconfig").basedpyright.setup({
            on_init = function(client)
                client.handlers["textDocument/publishDiagnostics"] = function() end
            end,
        })
        require("lspconfig").ruff.setup({})
    end,
}
