return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    
    notify.setup({
      background_colour = "#000000",
      fps = 30,
      icons = {
        DEBUG = "🐛",
        ERROR = "🚨",
        INFO = "ℹ️",
        TRACE = "🔍",
        WARN = "⚠️",
      },
      level = 2,
      minimum_width = 50,
      render = "compact",
      stages = "fade_in_slide_out",
      timeout = 3000,
      top_down = true,
    })

    -- Set as default notification handler
    vim.notify = notify

    -- Custom notification functions
    _G.notify_info = function(msg, title)
      notify(msg, "info", { title = title or "Info" })
    end

    _G.notify_warn = function(msg, title)
      notify(msg, "warn", { title = title or "Warning" })
    end

    _G.notify_error = function(msg, title)
      notify(msg, "error", { title = title or "Error" })
    end

    _G.notify_success = function(msg, title)
      notify(msg, "info", { title = title or "Success", icon = "✅" })
    end
  end,
}
