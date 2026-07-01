local M = {}

function M.external_connected()
    local command = [[
        for status in /sys/class/drm/card*-*/status; do
            [ -e "$status" ] || continue

            connector=${status%/status}
            connector=${connector##*/}

            case "$connector" in
                *-eDP-*|*-LVDS-*|*-DSI-*) continue ;;
            esac

            if grep -qx connected "$status"; then
                echo connected
                exit 0
            fi
        done
    ]]

    local handle = io.popen(command)
    if handle == nil then
        return false
    end

    local result = handle:read("*l") or ""
    handle:close()

    return result == "connected"
end

return M
