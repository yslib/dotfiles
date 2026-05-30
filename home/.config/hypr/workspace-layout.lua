-- Workspaces are assigned on reload only. One active monitor gets 1-8. With
-- multiple active monitors, the laptop panel gets 1-4 while the lid is open,
-- and the next monitor gets 5-8. When the laptop lid is closed, the built-in
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

local function split_laptop_panel(monitors)
    local laptopPanels = {}
    local externalMonitors = {}

    for _, monitor in ipairs(monitors) do
        if is_laptop_panel(monitor) then
            table.insert(laptopPanels, monitor)
        else
            table.insert(externalMonitors, monitor)
        end
    end

    return laptopPanels, externalMonitors
end

local function active_monitors()
    local monitors = ordered_monitors()
    local laptopPanels, externalMonitors = split_laptop_panel(monitors)

    if not lid_is_closed() and #laptopPanels > 0 then
        local active = {}

        for _, monitor in ipairs(laptopPanels) do
            table.insert(active, monitor)
        end

        for _, monitor in ipairs(externalMonitors) do
            table.insert(active, monitor)
        end

        return active
    end

    if not lid_is_closed() then
        return monitors
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
