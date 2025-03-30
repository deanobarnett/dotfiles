local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "habamax" } },

    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.go" },

    -- change default plugins
    { "catppuccin", enabled = false },
    { "tokyonight.nvim", enabled = false },
    { "bufferline.nvim", enabled = false },
    { "nvim-notify", enabled = false },
    { "mini.pairs", enabled = false },
    { "headlines.nvim", enabled = false },
    { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
    { "neovim/nvim-lspconfig", opts = { inlay_hints = { enabled = false } } },
    { "nvim-lualine/lualine.nvim", opts = { options = { theme = "codedark" } } },
    { "folke/snacks.nvim", opts = { scroll = { enabled = false } } },
    { "nvim-neo-tree/neo-tree.nvim", opts = { window = { width = 25 } } },

    -- additional plugins
    {
      "zk-org/zk-nvim",
      event = "VeryLazy",
      config = function()
        require("zk").setup({})
      end,
    },
  },

  defaults = {
    lazy = false,
    version = false,
  },

  -- Disable noisy notifications
  checker = { enabled = false, notify = false },
  change_detection = { enabled = false, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.g.snacks_animate = false

local opt = vim.opt
opt.wrap = true
opt.wrapmargin = 0
opt.textwidth = 0
opt.columns = 80

local keymap = vim.keymap
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })
keymap.set("n", "<C-q>", ":q!<CR>", { desc = "Quit" })
keymap.set("n", "<leader>v", "<C-w>v", { desc = "Split window vertically" })

local kmopts = { noremap = true, silent = false }
keymap.set("n", "<leader>Zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", kmopts)
keymap.set("v", "<leader>Zn", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", kmopts)
keymap.set("n", "<leader>Zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", kmopts)
keymap.set("n", "<leader>Zt", "<Cmd>ZkTags<CR>", kmopts)
keymap.set("v", "<leader>Zf", ":'<,'>ZkMatch<CR>", kmopts)
