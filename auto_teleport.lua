-- auto_teleport.lua
-- Script: Auto Teleport to saved position on startup
-- Author : yourname
-- For    : SAMP Mobile (MoonLoader)

script_name('AutoTeleport')
script_author('yourname')

local savedFile = getWorkingDirectory() .. '/savedpos.txt'

require 'lib.moonloader'
require 'lib.samp.events'

function main()
    repeat wait(0) until isSampAvailable()

    -- 1. Teleport ngay khi script nạp nếu có toạ độ
    teleportIfSaved()

    -- 2. Đăng ký lệnh /savepos để lưu toạ độ hiện tại
    sampRegisterChatCommand('savepos', saveCurrentPos)

    -- Vòng lặp chính
    while true do wait(500) end
end

--==================================================
-- LƯU TOẠ ĐỘ
--==================================================
function saveCurrentPos()
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local f = io.open(savedFile, 'w')
    if f then
        f:write(('%f %f %f'):format(x, y, z))
        f:close()
        sampAddChatMessage(
            ('[AutoTP] Saved: %.2f %.2f %.2f'):format(x, y, z), -1)
    else
        sampAddChatMessage('[AutoTP] Error saving position!', 0xFF0000)
    end
end

--==================================================
-- TẢI & TELEPORT
--==================================================
function teleportIfSaved()
    if doesFileExist(savedFile) then
        local f = io.open(savedFile, 'r')
        local x, y, z = f:read('*n', '*n', '*n')
        f:close()
        if x and y and z then
            -- Teleport an toàn: freeze để tránh rơi map
            freezeCharPosition(PLAYER_PED, true)
            setCharCoordinates(PLAYER_PED, x, y, z + 1.0) -- +1m tránh kẹt
            wait(500)
            freezeCharPosition(PLAYER_PED, false)

            sampAddChatMessage(
                ('[AutoTP] Teleported to saved: %.2f %.2f %.2f')
                :format(x, y, z), 0x00FF00)
        end
    end
end