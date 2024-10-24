vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = ' '

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig'
    }

    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' }
        }
    }

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {
                "L3MON4D3/LuaSnip",
                -- install jsregexp (optional!:).
                run = "make install_jsregexp"
            },
            { "saadparwaiz1/cmp_luasnip" },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
        }
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end

    local ts = require('telescope.builtin')
    vim.keymap.set('n', '<leader>sf', ts.find_files)
    vim.keymap.set('n', '<leader>sg', ts.live_grep)
    vim.keymap.set('n', '<leader>sb', ts.buffers)

    local luasnip = require('luasnip')
    local cmp = require('cmp')
    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }, { name = 'buffer' })
    }

    -- Set up lspconfig.
    require("mason").setup()
    require("mason-lspconfig").setup()

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local lspconfig = require('lspconfig')
    lspconfig.clangd.setup {
        capabilities = capabilities,
        settings = {
            ['clangd'] = {

            }
        }
    }

end)


