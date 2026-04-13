vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local python3 = vim.fn.exepath("python3")
if python3 ~= "" then
  vim.g.python3_host_prog = python3
end

vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.mouse = "n"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = false
vim.opt.termguicolors = true
vim.opt.updatetime = 100
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<C-h>", "<cmd>nohlsearch<cr>", { silent = true })

vim.api.nvim_create_augroup("terminal_ui", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal_ui",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

require("lazy").setup({
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.o.background = "dark"
      vim.cmd.colorscheme("everforest")
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
        },
      })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        view = {
          width = 34,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })

      vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { silent = true })
      vim.keymap.set("n", "<F3>", "<cmd>NvimTreeFindFile<cr>", { silent = true })
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<cr>", { silent = true })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "  ",
          layout_strategy = "flex",
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      })
      pcall(telescope.load_extension, "fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { silent = true })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { silent = true })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { silent = true })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { silent = true })
      vim.keymap.set("n", "<C-p>f", builtin.find_files, { silent = true })
      vim.keymap.set("n", "<C-p>b", builtin.buffers, { silent = true })

      vim.api.nvim_create_user_command("Rg", function(opts)
        builtin.live_grep({ default_text = opts.args })
      end, { nargs = "*" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup()

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup()
      vim.keymap.set("n", "<F8>", "<cmd>AerialToggle!<cr>", { silent = true })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "clangd",
          "html",
          "cssls",
          "jsonls",
          "ts_ls",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(event)
          local map = function(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, { buffer = event.buf, silent = true })
          end

          map("gd", vim.lsp.buf.definition)
          map("gr", vim.lsp.buf.references)
          map("K", vim.lsp.buf.hover)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
          map("<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end)
        end,
      })

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
            },
          },
        },
        pyright = {},
        clangd = {},
        html = {},
        cssls = {},
        jsonls = {},
        ts_ls = {},
      }

      for server, server_opts in pairs(servers) do
        server_opts.capabilities = capabilities
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end
    end,
  },

  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascriptreact", "typescriptreact", "jsx", "tsx" },
  },

  {
    "jparise/vim-graphql",
    ft = { "graphql", "javascript", "typescript", "typescriptreact" },
  },

  {
    "MattesGroeger/vim-bookmarks",
    keys = { "mm", "mi", "mn", "mp" },
  },
}, {
  checker = { enabled = true },
  change_detection = { notify = false },
})
