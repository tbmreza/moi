-- ~/.config/nvim/lua/plugins/completion.lua

return {
  -- Mason for managing LSP servers, linters, and formatters
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "clangd", "ts_ls", "bashls" },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Configuration & Completion capabilities integration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason").setup()

      require("mason-lspconfig").setup({
        automatic_enable = true,
      })

      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,

    -- config = function()
    --   local lspconfig = require("lspconfig")
    --   local capabilities = require("cmp_nvim_lsp").default_capabilities()
    --
    --   Default handler for Mason-installed servers
    --   require("mason-lspconfig").setup_handlers({
    --     function(server_name)
    --       lspconfig[server_name].setup({
    --         capabilities = capabilities,
    --       })
    --     end,
    --     -- Custom server overrides can be added here
    --     ["lua_ls"] = function()
    --       lspconfig.lua_ls.setup({
    --         capabilities = capabilities,
    --         settings = {
    --           Lua = {
    --             diagnostics = { globals = { "vim" } },
    --           },
    --         },
    --       })
    --     end,
    --   })
    -- end,
  },

  -- Autocompletion Engine (nvim-cmp) + Snippets
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP source
      "hrsh7th/cmp-buffer",      -- Buffer words source
      "hrsh7th/cmp-path",        -- Filesystem paths source
      "L3MON4D3/LuaSnip",        -- Snippet engine
      "saadparwaiz1/cmp_luasnip",-- Snippet source
      "rafamadriz/friendly-snippets", -- Community snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
