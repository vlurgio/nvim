-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    rooter = {
      -- list of detectors in order of prevalence, elements can be:
      --   "lsp" : lsp detection
      --   string[] : a list of directory patterns to look for
      --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
      detector = {
        "lsp", -- highest priority is getting workspace from running language servers
        { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
        { "lua", "MakeFile", "package.json" }, -- lastly check for known project root files
      },
      -- ignore things from root detection
      ignore = {
        servers = {}, -- list of language server names to ignore (Ex. { "efm" })
        dirs = {}, -- list of directory patterns (Ex. { "~/.cargo/*" })
      },
      -- automatically update working directory (update manually with `:AstroRoot`)
      autochdir = true,
      -- scope of working directory to change ("global"|"tab"|"win")
      scope = "global",
      -- show notification on every working directory change
      notify = false,
    },
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Leader>bb"] = {
          function() require("snacks").picker.buffers { filter = { cwd = true } } end,
          desc = "Search Buffers",
        },
        ["<Leader>bd"] = {
          "<CMD>bd<CR>",
          desc = "Delete buffer",
        },
        ["<Leader>pp"] = {
          function()
            require("snacks").picker.projects {
              dev = { "~/projects/go", "~/projects/nodesjs" },
              confirm = function(picker, item)
                picker:close()
                if item and item.file then
                  -- Check if the project is already open by checking the cwd of each tab
                  local tabpages = vim.api.nvim_list_tabpages()
                  for _, tabpage in ipairs(tabpages) do
                    local tab_cwd = vim.fn.getcwd(-1, tabpage)
                    if tab_cwd == item.file then
                      -- Change to the tab
                      vim.api.nvim_set_current_tabpage(tabpage)
                      return
                    end
                  end

                  -- If there are already opened buffers, open a new tab
                  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= "" then
                      vim.cmd "tabnew"
                      break
                    end
                  end

                  -- Change cwd to the selected project, only for this tab
                  vim.cmd("tcd " .. vim.fn.fnameescape(item.file))
                  require("snacks").picker.smart()
                end
              end,
            }
          end,
          desc = "Find projects",
        },
        ["<Leader>."] = {
          function() require("snacks").scratch() end,
          desc = "Open scratch buffer",
        },
        -- windows
        ["<Leader>wd"] = {
          "<CMD>wincmd q<CR>",
          desc = "Window delete",
        },
        ["<Leader>ls"] = {
          function() require("snacks").picker.lsp_symbols { layout = { preset = "vscode", preview = "main" } } end,
          desc = "LSP symbols",
        },
        ["<Leader>lS"] = {
          function() require("snacks").picker.lsp_workspace_symbols() end,
          desc = "LSP symbols",
        },
        ["<Leader>lR"] = {
          function() require("snacks").picker.lsp_references() end,
          desc = "LSP references",
        },
        ["gr"] = {
          function() require("snacks").picker.lsp_references() end,
          desc = "LSP references",
        },
        ["gi"] = {
          function() require("snacks").picker.lsp_implementations() end,
          desc = "LSP references",
        },
      },
    },
  },
}
