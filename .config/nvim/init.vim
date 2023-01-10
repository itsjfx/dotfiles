set ttyfast
" don't try to be vi compatible
set nocompatible
set number
set expandtab
set tabstop=4
set shiftwidth=4
" dodgy?
set mouse=c

" Mappings
map <F2> :tabp <CR>
map <F3> :tabn <CR>
map <F1> :Files <CR>
map <A-f> :Files <CR>

" cmap w!! w !sudo tee > /dev/null %

call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'preservim/nerdcommenter'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
set termguicolors
colorscheme tokyonight
colorscheme tokyonight-storm

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "javascript", "typescript", "yaml", "bash", "html", "vim", "graphql", "dockerfile", "markdown" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
--     disable = function(lang, buf)
--         local max_filesize = 100 * 1024 -- 100 KB
--         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--         if ok and stats and stats.size > max_filesize then
--             return true
--         end
--     end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
