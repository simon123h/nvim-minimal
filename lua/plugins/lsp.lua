return {
    -- LSP progress indicator
    { "j-hui/fidget.nvim", opts = {} },

    -- Mason for managing LSPs, formatters, and linters
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>li", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = { ui = { border = "rounded" } },
    },

    -- nvim-lspconfig
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "onsails/lspkind.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            vim.diagnostic.config({
                virtual_text = { prefix = "" },
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
                jump = {
                    on_jump = function(diagnostic)
                        if diagnostic then
                            vim.diagnostic.open_float()
                        end
                    end,
                },
            })

            local mason_lspconfig = require("mason-lspconfig")

            local utils = require("utils")
            local ensure_installed = {}
            if utils.is_T14 then
                table.insert(ensure_installed, "lua_ls")
            end

            mason_lspconfig.setup({
                ensure_installed = ensure_installed,
            })

            -- Disable formatting if handled by other plugins (like conform.nvim)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client then
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end
                end,
            })

            -- Setup LSPs using Neovim 0.11 native configuration
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Lua
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })
            vim.lsp.enable("lua_ls")

            -- Python
            vim.lsp.config("pyright", {
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = { typeCheckingMode = "basic" },
                    },
                },
            })
            vim.lsp.enable("pyright")
        end,
    },

    -- Diagnostics panel
    {
        "folke/trouble.nvim",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "Symbols (Trouble)" },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / ... (Trouble)",
            },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",  desc = "Quickfix List (Trouble)" },
        },
        opts = {},
    },
}
