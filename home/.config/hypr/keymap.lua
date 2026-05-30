local M = {}

function M.setup(opts)
    local mainMod = opts.main_mod or "SUPER"
    local terminal = opts.terminal or "alacritty"
    local fileManager = opts.file_manager or "alacritty -e yazi"
    local browser = opts.browser or "google-chrome-stable"
    local hyprshell = opts.hyprshell or "/usr/bin/hyprshell"
    local backlightStep = opts.backlight_step
    local volumeStep = opts.volume_step
    local ensureHyprshell = opts.ensure_hyprshell
    local restartWaybar = opts.restart_waybar
    local toggleWaybar = opts.toggle_waybar

    -- Awesome-style app bindings
    hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
    hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd(hyprshell .. [[ socat '"OpenOverview"']]), { non_consuming = true })
    hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManager))
    hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(browser))

    hl.bind(mainMod .. " + tab", hl.dsp.exec_cmd(hyprshell .. [[ socat '{"OpenSwitch":{"reverse":false}}']]), { non_consuming = true })
    hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd(hyprshell .. [[ socat '{"OpenSwitch":{"reverse":true}}']]), { non_consuming = true })
    hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.exec_cmd(hyprshell .. [[ socat '{"OpenSwitch":{"reverse":true}}']]), { non_consuming = true })
    hl.bind(mainMod .. " + super_l", hl.dsp.exec_cmd(hyprshell .. [[ socat '{"CloseSwitch":{"switch":true}}']]), { release = true, transparent = true, non_consuming = true })
    hl.bind(mainMod .. " + super_r", hl.dsp.exec_cmd(hyprshell .. [[ socat '{"CloseSwitch":{"switch":true}}']]), { release = true, transparent = true, non_consuming = true })
    hl.bind("SHIFT + SHIFT_l", hl.dsp.exec_cmd(hyprshell .. [[ socat '{"CloseSwitch":{"switch":true}}']]), { release = true, transparent = true, non_consuming = true })
    hl.bind("SHIFT + SHIFT_r", hl.dsp.exec_cmd(hyprshell .. [[ socat '{"CloseSwitch":{"switch":true}}']]), { release = true, transparent = true, non_consuming = true })

    -- WM/session bindings
    hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(toggleWaybar))
    hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("sh -c 'hyprctl reload; " .. restartWaybar .. " " .. ensureHyprshell .. "'"))
    hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
    hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

    -- Client bindings
    hl.bind(mainMod .. " + Q", hl.dsp.window.close())
    hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
    hl.bind(mainMod .. " + space", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
    hl.bind(mainMod .. " + N", hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    hl.bind(mainMod .. " + CTRL + N", hl.dsp.workspace.toggle_special("minimized"))
    hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client --toggle-panel --skip-wait"))
    hl.bind(mainMod .. " + P", hl.dsp.window.pin())
    hl.bind(mainMod .. " + C", hl.dsp.window.center())

    local directions = {
        H = "left",
        J = "down",
        K = "up",
        L = "right",
        Left = "left",
        Down = "down",
        Up = "up",
        Right = "right",
    }

    for key, direction in pairs(directions) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
    end

    local resizeSteps = {
        H = { -50, 0 },
        J = { 0, 50 },
        K = { 0, -50 },
        L = { 50, 0 },
        Left = { -50, 0 },
        Down = { 0, 50 },
        Up = { 0, -50 },
        Right = { 50, 0 },
    }

    for key, delta in pairs(resizeSteps) do
        hl.bind(
            mainMod .. " + CTRL + " .. key,
            hl.dsp.window.resize({ x = delta[1], y = delta[2], relative = true }),
            { repeating = true }
        )
    end

    -- Workspaces mirror Awesome tags 1-8
    hl.bind(mainMod .. " + ALT + Left", hl.dsp.focus({ workspace = "e-1" }))
    hl.bind(mainMod .. " + ALT + Right", hl.dsp.focus({ workspace = "e+1" }))

    for i = 1, 8 do
        hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
    end

    -- Mouse bindings match Awesome's Mod+left/right drag behavior.
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Media keys
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(backlightStep .. " up"), { repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(backlightStep .. " down"), { repeating = true })
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volumeStep .. " up"), { repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volumeStep .. " down"), { repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volumeStep .. " toggle"))
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
end

return M
