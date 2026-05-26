local mainMod = "SUPER"
local terminal = "alacritty"
local fileManager = "alacritty -e yazi"
local browser = "google-chrome-stable"
local hyprshell = "/usr/bin/hyprshell"
local backlightStep = (os.getenv("HOME") or "~") .. "/.config/hypr/scripts/backlight-step"
local volumeStep = (os.getenv("HOME") or "~") .. "/.config/hypr/scripts/volume-step"
local ensureHyprshell = [[systemctl --user is-active --quiet hyprshell.service || { rm -f "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprshell.sock"; systemctl --user start hyprshell.service; }]]
local restartWaybar = [[pkill -x waybar 2>/dev/null || true; waybar >/tmp/waybar.log 2>&1 &]]

hl.on("hyprland.start", function()
    hl.exec_cmd("sh -c 'systemctl --user stop dunst.service 2>/dev/null || true; pgrep -x swaync >/dev/null || swaync'")
    hl.exec_cmd("waybar")
    hl.exec_cmd("sh -c '" .. ensureHyprshell .. "'")
end)

hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx;ibus")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("GTK_IM_MODULE", "fcitx")
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

-- Workspaces are assigned on reload only. One active monitor gets 1-8; two
-- active monitors split 1-4 / 5-8 by current screen position, without
-- hardcoded external output names. When the laptop lid is closed, the built-in
-- panel is ignored if any external monitor is present.
local function ordered_monitors()
    local monitors = hl.get_monitors()

    table.sort(monitors, function(left, right)
        if left.x == right.x then
            return left.y < right.y
        end

        return left.x < right.x
    end)

    return monitors
end

local function is_laptop_panel(monitor)
    local name = monitor.name or ""

    return name:match("^eDP%-") ~= nil
        or name:match("^LVDS%-") ~= nil
        or name:match("^DSI%-") ~= nil
end

local function lid_is_closed()
    local handle = io.popen("cat /proc/acpi/button/lid/*/state 2>/dev/null | head -n 1")
    if handle == nil then
        return false
    end

    local state = handle:read("*l") or ""
    handle:close()

    return state:find("closed", 1, true) ~= nil
end

local function active_monitors()
    local monitors = ordered_monitors()

    if not lid_is_closed() then
        return monitors
    end

    local externalMonitors = {}
    for _, monitor in ipairs(monitors) do
        if not is_laptop_panel(monitor) then
            table.insert(externalMonitors, monitor)
        end
    end

    if #externalMonitors > 0 then
        return externalMonitors
    end

    return monitors
end

local monitors = active_monitors()
if monitors[1] ~= nil then
    local firstMonitor = monitors[1].name
    local secondMonitor = monitors[2] and monitors[2].name or nil

    for workspace = 1, 8 do
        local monitor = firstMonitor
        if secondMonitor ~= nil and workspace > 4 then
            monitor = secondMonitor
        end

        local isDefaultWorkspace = workspace == 1
        if secondMonitor ~= nil then
            isDefaultWorkspace = workspace == 1 or workspace == 5
        end

        hl.workspace_rule({
            workspace = tostring(workspace),
            monitor = monitor,
            persistent = true,
            default = isDefaultWorkspace,
        })
    end
end

for _, namespace in ipairs({
    "waybar",
    "hyprshell_launcher",
    "hyprshell_overview",
    "hyprshell_switch",
    "swaync-control-center",
    "swaync-notification-window",
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
