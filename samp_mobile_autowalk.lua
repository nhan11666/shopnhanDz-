--[[
    SA-MP Mobile Auto Walk Script
    Tự động di chuyển đến tọa độ đã lưu
    Tác giả: AI Assistant
    Phiên bản: 1.0
]]

-- Khởi tạo biến toàn cục
local savedLocations = {}
local currentLocation = 1
local isAutoWalking = false
local targetX, targetY, targetZ = 0, 0, 0
local walkSpeed = 1.0
local menuVisible = false
local selectedOption = 1

-- Màu sắc cho giao diện
local colors = {
    background = {0, 0, 0, 180},
    text = {255, 255, 255, 255},
    selected = {255, 255, 0, 255},
    button = {50, 50, 50, 200},
    buttonHover = {80, 80, 80, 200}
}

-- Hàm lưu tọa độ hiện tại
function saveCurrentLocation()
    local player = getCharCoordinates(PLAYER_PED)
    if player then
        local x, y, z = getCharCoordinates(player)
        local locationName = "Vị trí " .. #savedLocations + 1
        
        table.insert(savedLocations, {
            name = locationName,
            x = x,
            y = y,
            z = z
        })
        
        sampAddChatMessage("{00FF00}[AutoWalk] {FFFFFF}Đã lưu vị trí: " .. locationName, -1)
    end
end

-- Hàm xóa tọa độ đã lưu
function deleteLocation(index)
    if savedLocations[index] then
        local name = savedLocations[index].name
        table.remove(savedLocations, index)
        sampAddChatMessage("{FF0000}[AutoWalk] {FFFFFF}Đã xóa vị trí: " .. name, -1)
    end
end

-- Hàm bắt đầu tự động di chuyển
function startAutoWalk(x, y, z)
    targetX, targetY, targetZ = x, y, z
    isAutoWalking = true
    sampAddChatMessage("{00FF00}[AutoWalk] {FFFFFF}Bắt đầu di chuyển đến tọa độ...", -1)
end

-- Hàm dừng tự động di chuyển
function stopAutoWalk()
    isAutoWalking = false
    sampAddChatMessage("{FF0000}[AutoWalk] {FFFFFF}Đã dừng tự động di chuyển", -1)
end

-- Hàm tính khoảng cách giữa hai điểm
function getDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

-- Hàm di chuyển đến tọa độ
function walkToCoordinates()
    if not isAutoWalking then return end
    
    local player = getCharCoordinates(PLAYER_PED)
    if not player then return end
    
    local px, py, pz = getCharCoordinates(player)
    local distance = getDistance(px, py, pz, targetX, targetY, targetZ)
    
    -- Nếu đã đến gần đích (trong vòng 2 mét)
    if distance < 2.0 then
        stopAutoWalk()
        sampAddChatMessage("{00FF00}[AutoWalk] {FFFFFF}Đã đến đích!", -1)
        return
    end
    
    -- Tính hướng di chuyển
    local dx = targetX - px
    local dy = targetY - py
    local dz = targetZ - pz
    
    -- Chuẩn hóa vector
    local length = math.sqrt(dx^2 + dy^2 + dz^2)
    if length > 0 then
        dx = dx / length * walkSpeed
        dy = dy / length * walkSpeed
        dz = dz / length * walkSpeed
    end
    
    -- Di chuyển nhân vật
    setCharCoordinates(player, px + dx, py + dy, pz + dz)
end

-- Hàm vẽ menu
function drawMenu()
    if not menuVisible then return end
    
    local screenW, screenH = getScreenResolution()
    local menuW = 300
    local menuH = 400
    local menuX = (screenW - menuW) / 2
    local menuY = (screenH - menuH) / 2
    
    -- Vẽ background
    drawBoxWithBorder(menuX, menuY, menuW, menuH, colors.background, 2, colors.text)
    
    -- Tiêu đề
    drawText("Auto Walk Menu", menuX + 10, menuY + 10, colors.text, 1.2)
    
    local yOffset = 50
    local lineHeight = 25
    
    -- Nút lưu vị trí hiện tại
    local saveBtnY = menuY + yOffset
    local saveBtnColor = selectedOption == 1 and colors.selected or colors.button
    drawBoxWithBorder(menuX + 10, saveBtnY, menuW - 20, 30, saveBtnColor, 1, colors.text)
    drawText("Lưu vị trí hiện tại", menuX + 15, saveBtnY + 5, colors.text, 1.0)
    
    yOffset = yOffset + 40
    
    -- Danh sách vị trí đã lưu
    drawText("Vị trí đã lưu:", menuX + 10, menuY + yOffset, colors.text, 1.0)
    yOffset = yOffset + 25
    
    for i, location in ipairs(savedLocations) do
        local itemY = menuY + yOffset + (i - 1) * lineHeight
        local itemColor = selectedOption == i + 1 and colors.selected or colors.button
        
        drawBoxWithBorder(menuX + 10, itemY, menuW - 20, lineHeight - 2, itemColor, 1, colors.text)
        drawText(location.name, menuX + 15, itemY + 2, colors.text, 0.9)
        
        -- Nút xóa
        local deleteBtnX = menuX + menuW - 60
        local deleteBtnColor = selectedOption == i + 1 + #savedLocations and colors.selected or colors.button
        drawBoxWithBorder(deleteBtnX, itemY, 50, lineHeight - 2, deleteBtnColor, 1, colors.text)
        drawText("Xóa", deleteBtnX + 5, itemY + 2, colors.text, 0.8)
    end
    
    -- Hướng dẫn
    yOffset = yOffset + #savedLocations * lineHeight + 20
    drawText("F1: Mở/Đóng menu", menuX + 10, menuY + yOffset, colors.text, 0.8)
    drawText("F2: Bắt đầu/Dừng auto walk", menuX + 10, menuY + yOffset + 15, colors.text, 0.8)
    drawText("Enter: Chọn", menuX + 10, menuY + yOffset + 30, colors.text, 0.8)
end

-- Hàm xử lý input
function handleInput()
    if not menuVisible then return end
    
    if isKeyDown(0x70) then -- F1
        menuVisible = false
        return
    end
    
    if isKeyDown(0x71) then -- F2
        if isAutoWalking then
            stopAutoWalk()
        else
            if savedLocations[currentLocation] then
                startAutoWalk(savedLocations[currentLocation].x, savedLocations[currentLocation].y, savedLocations[currentLocation].z)
            end
        end
        return
    end
    
    if isKeyDown(0x28) then -- Down arrow
        selectedOption = selectedOption + 1
        if selectedOption > 1 + #savedLocations * 2 then
            selectedOption = 1
        end
        return
    end
    
    if isKeyDown(0x26) then -- Up arrow
        selectedOption = selectedOption - 1
        if selectedOption < 1 then
            selectedOption = 1 + #savedLocations * 2
        end
        return
    end
    
    if isKeyDown(0x0D) then -- Enter
        if selectedOption == 1 then
            saveCurrentLocation()
        elseif selectedOption > 1 and selectedOption <= 1 + #savedLocations then
            -- Chọn vị trí để di chuyển
            local locationIndex = selectedOption - 1
            if savedLocations[locationIndex] then
                startAutoWalk(savedLocations[locationIndex].x, savedLocations[locationIndex].y, savedLocations[locationIndex].z)
                menuVisible = false
            end
        elseif selectedOption > 1 + #savedLocations then
            -- Xóa vị trí
            local deleteIndex = selectedOption - 1 - #savedLocations
            deleteLocation(deleteIndex)
        end
        return
    end
end

-- Hàm chính
function main()
    while true do
        wait(0)
        
        -- Xử lý input
        handleInput()
        
        -- Vẽ menu
        drawMenu()
        
        -- Xử lý auto walk
        if isAutoWalking then
            walkToCoordinates()
        end
        
        -- Hiển thị thông tin auto walk
        if isAutoWalking then
            local player = getCharCoordinates(PLAYER_PED)
            if player then
                local px, py, pz = getCharCoordinates(player)
                local distance = getDistance(px, py, pz, targetX, targetY, targetZ)
                drawText(string.format("Auto Walk: %.1fm", distance), 10, 10, colors.text, 1.0)
            end
        end
    end
end

-- Khởi tạo script
function onScriptLoad()
    sampAddChatMessage("{00FF00}[AutoWalk] {FFFFFF}Script đã được tải thành công!", -1)
    sampAddChatMessage("{FFFF00}[AutoWalk] {FFFFFF}Nhấn F1 để mở menu", -1)
    
    -- Tạo một số vị trí mẫu
    table.insert(savedLocations, {
        name = "Los Santos",
        x = 2000.0,
        y = -1500.0,
        z = 13.0
    })
    
    table.insert(savedLocations, {
        name = "San Fierro",
        x = -2000.0,
        y = 1000.0,
        z = 30.0
    })
    
    table.insert(savedLocations, {
        name = "Las Venturas",
        x = 2500.0,
        y = 2000.0,
        z = 10.0
    })
end

-- Xử lý sự kiện
function onScriptUnload()
    sampAddChatMessage("{FF0000}[AutoWalk] {FFFFFF}Script đã được tắt!", -1)
end

-- Bắt đầu script
onScriptLoad()
main()