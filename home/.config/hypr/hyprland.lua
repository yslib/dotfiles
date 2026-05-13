local mainMod = "SUPER"
local terminal = "alacritty"
local fileManager = "alacritty -e yazi"
local browser = "google-chrome-stable"
local hyprshell = "/usr/bin/hyprshell"
local backlightStep = (os.getenv("HOME") or "~") .. "/.config/hypr/scripts/backlight-step"
local volumeStep = (os.getenv("HOME") or "~") .. "/.config/hypr/scripts/volume-step"

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("/usr/bin/hyprshell run")
end)

hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx;ibus")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")

hl.config({
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 0.98,
        inactive_opacity = 0.94,
        fullscreen_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 12,
            render_power = 3,
            color = "rgba(111827aa)",
        },

        blur = {
            enabled = true,
            size = 8,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
            xray = true,
            noise = 0.05,
            contrast = 0.95,
            brightness = 0.85,
            vibrancy = 0.18,
            popups = true,
            popups_ignorealpha = 0.35,
            input_methods = true,
            input_methods_ignorealpha = 0.35,
        },
    },
})

for _, namespace in ipairs({
    "waybar",
    "hyprshell_launcher",
    "hyprshell_overview",
    "hyprshell_switch",
}) do
    hl.layer_rule({
        match = { namespace = namespace },
        blur = true,
        blur_popups = true,
        ignore_alpha = 0.25,
    })
end

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
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))

-- Client bindings
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + space", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + N", hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.workspace.toggle_special("minimized"))
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
