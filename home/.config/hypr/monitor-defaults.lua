-- Fallback monitor layout used when nwg-displays has not generated monitors.lua.

local monitorDetect = require("monitor-detect")

local laptopPosition = "0x0"
if monitorDetect.external_connected() then
    laptopPosition = "3224x1440"
end

hl.monitor({
    output = "eDP-1",
    mode = "2880x1800@120.0",
    position = laptopPosition,
    scale = 2.0,
})

hl.monitor({
    output = "DP-1",
    mode = "5120x1440@120.0",
    position = "1440x0",
    scale = 1.0,
})
