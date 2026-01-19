-- These names can be anything. Use lspconfig names to use their config.

-- C / C++
vim.lsp.enable("clangd-c")
vim.lsp.enable("clangd")

-- Python
-- vim.lsp.enable("basedpyright")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")

-- Lua
vim.lsp.enable("lua_ls")

-- C Sharp
vim.lsp.enable("csharp_ls")

-- Rust
vim.lsp.enable("rust_analyzer")


-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/
-- search ServerCapabilites 2nd match
-- I didn't read, just tried out random stuff + common sense
-- Also, no idea why it is server capabilities and not client
