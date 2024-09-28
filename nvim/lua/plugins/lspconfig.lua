return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "williamboman/mason.nvim",
            opts = {},
        },
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = {
                    -- Python
                    "basedpyright",
                    "ruff",
                    -- Lua
                    "lua_ls"
                },
            },
        },
    },
    config = function()
        local lspconfig = require("lspconfig")

        -- Python
        lspconfig.basedpyright.setup({
            on_init = function(client)
                client.handlers["textDocument/publishDiagnostics"] = function() end
            end,
        })
        lspconfig.ruff.setup({
            init_options = {
                settings = {
                    lineLength = 150,
                    configurationPreference = "filesystemFirst",
                    lint = {
                        select = {
                            "F",      -- Pyflakes
                            "W6",
                            "E71",
                            "E72",
                            "E112",   -- no-indented-block
                            "E113",   -- unexpected-indentation
                            "E203",   -- whitespace-before-punctuation
                            "E272",   -- multiple-spaces-before-keyword
                            "E275",   -- missing-whitespace-after-keyword
                            "E303",   -- too-many-blank-lines
                            "E304",   -- blank-line-after-decorator
                            "E501",   -- line-too-long
                            "E702",   -- multiple-statements-on-one-line-semicolon
                            "E703",   -- useless-semicolon
                            "E731",   -- lambda-assignment
                            "W191",   -- tab-indentation
                            "W291",   -- trailing-whitespace
                            "W293",   -- blank-line-with-whitespace
                            "UP039",  -- unnecessary-class-parentheses
                            "C416",   -- unnecessary-comprehension
                            "RET506", -- superfluous-else-raise
                            "RET507", -- superfluous-else-continue
                            "A",      -- builtin-variable-shadowing, builtin-argument-shadowing, builtin-attribute-shadowing
                            "SIM105", -- suppressible-exception
                            "FURB110",-- if-exp-instead-of-or-operator
                            "RUF018", -- assignment-in-assert
                        }
                    }
                }
            }
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "python",
            callback = function()
                vim.opt.tabstop = 2
                vim.opt.softtabstop = 2
                vim.opt.shiftwidth = 2
            end,
        })

        -- Lua
        lspconfig.lua_ls.setup({})

    end,
}
