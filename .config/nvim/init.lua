local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.local/share/nvim/plugged')

-- utils plugins
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && yarn install' })
Plug 'lervag/vimtex'
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
Plug 'bkad/CamelCaseMotion'
Plug 'chrisbra/Colorizer'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'ctrlpvim/ctrlp.vim'

-- git plugins
Plug 'zivyangll/git-blame.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sindrets/diffview.nvim'

-- lang plugins
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'TovarishFin/vim-solidity'
Plug 'modocache/move.vim'
Plug 'ollykel/v-vim'
Plug 'elkowar/yuck.vim'
Plug 'tikhomirov/vim-glsl'

vim.call('plug#end')

local ibl_ok, ibl = pcall(require, 'ibl')
if ibl_ok then
    ibl.setup()
end

local cmt_ok, cmt = pcall(require, 'Comment')
if cmt_ok then
    cmt.setup()
end

package.loaded['settings'] = nil
require 'settings'
