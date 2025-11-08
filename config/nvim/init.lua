-- ~/.config/nvim/init.lua
-- Basic settings ---------------------------------------------------------
vim.opt.compatible = false
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.clipboard = "unnamed"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·" }
vim.opt.background = "dark"

-- Disable python provider for clarity
vim.g.loaded_python3_provider = 0

-- colorscheme
vim.cmd.colorscheme("iceberg")

-- Visualize full-width spaces and trailing whitespace
vim.cmd([[
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
  match ZenkakuSpace /　/
  highlight WhiteSpaceEOL guibg=#ffffff
  2match WhiteSpaceEOL /\S\@<=\s\+$/
]])

-- spell check
vim.opt.spell = true
vim.opt.spelllang = { "en", "cjk" }

-- jj to ESC
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- Tab operation shortcuts (,1 to ,9)
for i = 1, 9 do
  vim.keymap.set("n", "," .. i, function() vim.cmd("tabn " .. i) end)
end
vim.keymap.set("n", ",c", ":tablast | tabnew<CR>", { silent = true })
vim.keymap.set("n", ",x", ":tabclose<CR>", { silent = true })
vim.keymap.set("n", ",n", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", ",p", ":tabprevious<CR>", { silent = true })

-- Toggle cursor line highlight
vim.api.nvim_create_autocmd("InsertEnter", { command = "set cursorline" })
vim.api.nvim_create_autocmd("InsertLeave", { command = "set nocursorline" })

-- ------------------------------------------------------------------------
-- Plugin manager: lazy.nvim
-- https://github.com/folke/lazy.nvim
-- ------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Theme
  { "cocopon/iceberg.vim" },

  -- Telescope: Denite replacement
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<Space>f", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<Space>g", builtin.live_grep, { desc = "Grep" })
      vim.keymap.set("n", "<Space>b", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<Space>r", builtin.command_history, { desc = "Command history" })
    end,
  },

  -- LSP + completion
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- LSP configuration (Neovim 0.11+)
      vim.lsp.config["ruby_lsp"] = {
        cmd = { "ruby-lsp" },
      }
      
      vim.lsp.config["gopls"] = {
        cmd = { "gopls" },
      }
      
      -- Auto-enable (no manual attach needed)
      vim.lsp.enable("ruby_lsp")
      vim.lsp.enable("gopls")
    end,
  },

  -- Linting/formatting (ALE replacement)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop" },
        go = { "goimports", "gofmt" },
      },
      format_on_save = { timeout_ms = 500 },
    },
  },

  -- Status line
  { "nvim-lualine/lualine.nvim", config = true },

  -- GitHub integration (vim-to-github replacement)
  { "tpope/vim-fugitive" },

  -- File tree
  { "nvim-tree/nvim-tree.lua", config = true },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "markdown", "markdown_inline", "typescript", "tsx", "javascript" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
})

-- ------------------------------------------------------------------------
-- FileType-specific settings
-- ------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "rake", "eruby" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "cjk" }
  end,
})
