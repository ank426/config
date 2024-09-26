return {
    "neovim/nvim-lspconfig",
    config = function()
        require('lspconfig').basedpyright.setup({
            on_init = function(client)
                -- Disable all diagnostics
                client.handlers["textDocument/publishDiagnostics"] = function() end
            end,
        })
    end,
}
