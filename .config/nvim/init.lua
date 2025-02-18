-- vi: sw=2 ts=2

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.local/share/nvim/plugged')

-- utils plugins
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && yarn install' })
Plug 'numToStr/Comment.nvim'
Plug 'Asheq/close-buffers.vim'
Plug 'mg979/vim-visual-multi'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'

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
Plug 'tpope/vim-fugitive'
Plug 'zivyangll/git-blame.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sindrets/diffview.nvim'

-- lang plugins

vim.call('plug#end')

package.loaded['settings'] = nil
require 'settings'
