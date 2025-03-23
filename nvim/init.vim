call plug#begin('~/.local/share/nvim/plugged')

" Core Plugins
Plug 'preservim/nerdtree'               " File explorer
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }  " Fuzzy finder
Plug 'nvim-lua/plenary.nvim'            " Dependency for Telescope and other plugins

" Code Editing and Navigation
Plug 'neovim/nvim-lspconfig'            " LSP support
Plug 'hrsh7th/nvim-cmp'                 " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'             " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'               " Buffer completions
Plug 'hrsh7th/cmp-path'                 " Path completions
Plug 'L3MON4D3/LuaSnip'                 " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'         " Snippet completions
Plug 'rafamadriz/friendly-snippets'     " Predefined snippets
Plug 'pangloss/vim-javascript'          " JavaScript syntax highlighting
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }  " Prettier for formatting
Plug 'yuezk/vim-js'                     " Enhanced JS syntax
Plug 'luochen1990/rainbow'              " Rainbow parentheses
Plug 'rafi/awesome-vim-colorschemes'    " Retro Scheme
Plug 'tc50cal/vim-terminal'             " Vim Terminal

call plug#end()

" Enable rainbow parentheses
let g:rainbow_active = 1

" Key mappings
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-p> :Telescope find_files<CR>
nnoremap <C-f> :NERDTreeFocus<CR>

" General Neovim Settings
set number                             " Show line numbers
set autoindent                         " Enable autoindent
set tabstop=2                          " Tabs are 2 spaces
set shiftwidth=2                       " Indent by 2 spaces
set expandtab                          " Convert tabs to spaces
set mouse=a                            " Enable mouse support
set encoding=UTF-8                     " Use UTF-8 encoding
set clipboard=unnamedplus              " Use system clipboard
set completeopt=menu,menuone,noselect  " Completion options
set updatetime=300                     " Faster completion response
set signcolumn=yes                     " Always show sign column

" Colorscheme
colorscheme jellybeans

" LSP Configuration for JavaScript/TypeScript
lua << EOF
require('lspconfig').ts_ls.setup {
  on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  end,
}
EOF

lua << EOF
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body) -- Use LuaSnip for snippet expansion
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection with Enter
    ['<C-Space>'] = cmp.mapping.complete(),            -- Trigger completion menu
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require'luasnip'.expand_or_jumpable() then
        require'luasnip'.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require'luasnip'.jumpable(-1) then
        require'luasnip'.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP completion
    { name = 'luasnip' },  -- Snippet completion
    { name = 'buffer' },   -- Buffer completion
    { name = 'path' },     -- File path completion
  }),
})
EOF
