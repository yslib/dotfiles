return {
    setup = function(state, opts)
        ya.dbg("hello sftp")
    end,
    entry = function(self, job)
        local value, event = ya.input {
            pos = { "top-center", y = 3, w = 40 },
            title = "SFTP Name:",
            value = "",
            obscure = false,
            realtime = false,
            debounce = 0.3,
        }
        if event == 1 and value and value ~= "" then
            -- open sftp tab
            ya.emit("tab_create", {
                "sftp://" .. value,
            })
        end
    end
}
