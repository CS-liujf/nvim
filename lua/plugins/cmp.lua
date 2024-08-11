return { -- override nvim-cmp plugin
  "hrsh7th/nvim-cmp",
  -- override the options table that is used in the `require("cmp").setup()` call
  opts = function(_, opts)
    local function get_icon_provider()
      -- ref: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
      local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      }
      return function(kind) return kind_icons[kind] end
    end

    local icon_provider = get_icon_provider()

    local function format(entry, item)
      local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
      local color_item = highlight_colors_avail and highlight_colors.format(entry, { kind = item.kind })

      if icon_provider then
        local icon = icon_provider(item.kind)
        if icon then
          item.kind = string.format(" %s %s", icon, item.kind)
        end
      end

      if color_item and color_item.abbr and color_item.abbr_hl_group then
        item.kind, item.kind_hl_group = color_item.abbr, color_item.abbr_hl_group
      end

      return item
    end

    local formatting_style = {
      -- default fields order i.e completion word + item.kind + item.kind icons
      fields = { "abbr", "kind", "menu" },
      format = format,
    }
    opts.formatting = formatting_style
    
    local window_style = {
      completion = {
        border = "single",
        col_offset = 2,
        side_padding = 0,
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      },
      documentation = {
        border = "single",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      },
    }
    opts.window = window_style
  end,
}
