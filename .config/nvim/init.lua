-- vi: sw=2 ts=2

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.local/share/nvim/plugged')

-- utils plugins
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && yarn install' })
Plug 'numToStr/Comment.nvim'
Plug 'Asheq/close-buffers.vim'
Plug 'mg979/vim-visual-multi'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

-- LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

-- LSP completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-omni'
Plug 'hrsh7th/nvim-cmp'

-- LSP snippet
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'mattn/emmet-vim'

Plug('xianghongai/vscode-react-snippet', {
  ['do'] = 'yarn install || yarn build || true ',
})

-- base plugins
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug 'bkad/CamelCaseMotion'
Plug 'chrisbra/Colorizer'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug('junegunn/fzf', { ['do'] = ':call fzf#install()' })
Plug 'junegunn/fzf.vim'

-- git plugins
Plug 'zivyangll/git-blame.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sindrets/diffview.nvim'

-- lang plugins

vim.call('plug#end')

local npairs_ok, npairs = pcall(require, 'nvim-autopairs')
if npairs_ok then
  npairs.setup {
    map_c_w = true,
  }
end

local ntags_ok, ntags = pcall(require, 'nvim-ts-autotag')
if ntags_ok then
  ntags.setup()
end

local ibl_ok, ibl = pcall(require, 'ibl')
if ibl_ok then
  ibl.setup()
end

local cmt_ok, cmt = pcall(require, 'Comment')
if cmt_ok then
  cmt.setup()
end

local tst_ok, tst = pcall(require, 'nvim-treesitter.configs')
if tst_ok then
  tst.setup {
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  }
end

package.loaded['settings'] = nil
require 'settings'
