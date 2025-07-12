-- SAMP Mobile Auto Move Script
-- Tự động di chuyển đến tọa độ đã lưu

-- Cấu hình
local CONFIG = {
    MOVE_SPEED = 1.0,           -- Tốc độ di chuyển (0.1 - 2.0)
    STOP_DISTANCE = 5.0,        -- Khoảng cách dừng lại (units)
    UPDATE_INTERVAL = 100,      -- Thời gian cập nhật (ms)
    SAVE_FILE = "coordinates.txt", -- File lưu tọa độ
    MAX_SAVED_COORDS = 50,      -- Số lượng tọa độ tối đa
    AUTO_SAVE = true,           -- Tự động lưu
}

-- Biến toàn cục
local isMoving = false
local targetX, targetY, targetZ = 0, 0, 0
local savedCoords = {}
local currentCoordIndex = 1

-- Hàm tiện ích
local function log(message)
    print("[AutoMove] " .. message)
end

local function getPlayerPosition()
    local x, y, z = getCharCoordinates(PLAYER_PED)
    return x, y, z
end

local function getDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

-- Hàm lưu tọa độ
local function saveCoordinates()
    local x, y, z = getPlayerPosition()
    local name = string.format("Coord_%d", #savedCoords + 1)
    
    -- Thêm tọa độ mới
    table.insert(savedCoords, {
        name = name,
        x = x,
        y = y,
        z = z,
        timestamp = os.time()
    })
    
    log(string.format("Đã lưu tọa độ: %s (%.2f, %.2f, %.2f)", name, x, y, z))
    
    -- Giới hạn số lượng tọa độ
    if #savedCoords > CONFIG.MAX_SAVED_COORDS then
        table.remove(savedCoords, 1)
    end
    
    -- Tự động lưu file
    if CONFIG.AUTO_SAVE then
        saveToFile()
    end
end

-- Hàm lưu vào file
local function saveToFile()
    local file = io.open(CONFIG.SAVE_FILE, "w")
    if file then
        for i, coord in ipairs(savedCoords) do
            file:write(string.format("%s|%.2f|%.2f|%.2f|%d\n", 
                coord.name, coord.x, coord.y, coord.z, coord.timestamp))
        end
        file:close()
        log("Đã lưu tọa độ vào file: " .. CONFIG.SAVE_FILE)
    else
        log("Lỗi: Không thể lưu file!")
    end
end

-- Hàm đọc từ file
local function loadFromFile()
    local file = io.open(CONFIG.SAVE_FILE, "r")
    if file then
        savedCoords = {}
        for line in file:lines() do
            local name, x, y, z, timestamp = line:match("([^|]+)|([^|]+)|([^|]+)|([^|]+)|([^|]+)")
            if name and x and y and z then
                table.insert(savedCoords, {
                    name = name,
                    x = tonumber(x),
                    y = tonumber(y),
                    z = tonumber(z),
                    timestamp = tonumber(timestamp) or os.time()
                })
            end
        end
        file:close()
        log(string.format("Đã tải %d tọa độ từ file", #savedCoords))
    else
        log("Không tìm thấy file tọa độ, tạo mới...")
        savedCoords = {}
    end
end

-- Hàm di chuyển đến tọa độ
local function moveToCoordinate(x, y, z)
    if not x or not y or not z then
        log("Lỗi: Tọa độ không hợp lệ!")
        return false
    end
    
    targetX, targetY, targetZ = x, y, z
    isMoving = true
    log(string.format("Bắt đầu di chuyển đến: (%.2f, %.2f, %.2f)", x, y, z))
    return true
end

-- Hàm di chuyển đến tọa độ đã lưu
local function moveToSavedCoordinate(index)
    if index < 1 or index > #savedCoords then
        log("Lỗi: Chỉ số tọa độ không hợp lệ!")
        return false
    end
    
    local coord = savedCoords[index]
    currentCoordIndex = index
    log(string.format("Di chuyển đến: %s", coord.name))
    return moveToCoordinate(coord.x, coord.y, coord.z)
end

-- Hàm di chuyển theo chu kỳ
local function moveToNextCoordinate()
    if #savedCoords == 0 then
        log("Không có tọa độ nào được lưu!")
        return false
    end
    
    currentCoordIndex = currentCoordIndex + 1
    if currentCoordIndex > #savedCoords then
        currentCoordIndex = 1
    end
    
    return moveToSavedCoordinate(currentCoordIndex)
end

-- Hàm dừng di chuyển
local function stopMoving()
    isMoving = false
    log("Đã dừng di chuyển")
end

-- Hàm cập nhật di chuyển
local function updateMovement()
    if not isMoving then return end
    
    local playerX, playerY, playerZ = getPlayerPosition()
    local distance = getDistance(playerX, playerY, playerZ, targetX, targetY, targetZ)
    
    -- Kiểm tra xem đã đến đích chưa
    if distance <= CONFIG.STOP_DISTANCE then
        stopMoving()
        log("Đã đến đích!")
        return
    end
    
    -- Tính toán hướng di chuyển
    local dirX = targetX - playerX
    local dirY = targetY - playerY
    local dirZ = targetZ - playerZ
    
    -- Chuẩn hóa vector
    local length = math.sqrt(dirX^2 + dirY^2 + dirZ^2)
    if length > 0 then
        dirX = dirX / length
        dirY = dirY / length
        dirZ = dirZ / length
    end
    
    -- Di chuyển nhân vật
    local newX = playerX + dirX * CONFIG.MOVE_SPEED
    local newY = playerY + dirY * CONFIG.MOVE_SPEED
    local newZ = playerZ + dirZ * CONFIG.MOVE_SPEED
    
    setCharCoordinates(PLAYER_PED, newX, newY, newZ)
end

-- Hàm hiển thị danh sách tọa độ
local function listCoordinates()
    if #savedCoords == 0 then
        log("Không có tọa độ nào được lưu!")
        return
    end
    
    log("=== DANH SÁCH TỌA ĐỘ ===")
    for i, coord in ipairs(savedCoords) do
        local status = (i == currentCoordIndex) and " [HIỆN TẠI]" or ""
        log(string.format("%d. %s (%.2f, %.2f, %.2f)%s", 
            i, coord.name, coord.x, coord.y, coord.z, status))
    end
end

-- Hàm xóa tọa độ
local function deleteCoordinate(index)
    if index < 1 or index > #savedCoords then
        log("Lỗi: Chỉ số tọa độ không hợp lệ!")
        return false
    end
    
    local coord = savedCoords[index]
    table.remove(savedCoords, index)
    log(string.format("Đã xóa tọa độ: %s", coord.name))
    
    -- Cập nhật chỉ số hiện tại
    if currentCoordIndex > #savedCoords then
        currentCoordIndex = #savedCoords
    end
    
    if CONFIG.AUTO_SAVE then
        saveToFile()
    end
    
    return true
end

-- Hàm xóa tất cả tọa độ
local function clearAllCoordinates()
    savedCoords = {}
    currentCoordIndex = 1
    log("Đã xóa tất cả tọa độ!")
    
    if CONFIG.AUTO_SAVE then
        saveToFile()
    end
end

-- Hàm đổi tên tọa độ
local function renameCoordinate(index, newName)
    if index < 1 or index > #savedCoords then
        log("Lỗi: Chỉ số tọa độ không hợp lệ!")
        return false
    end
    
    local oldName = savedCoords[index].name
    savedCoords[index].name = newName
    log(string.format("Đã đổi tên từ '%s' thành '%s'", oldName, newName))
    
    if CONFIG.AUTO_SAVE then
        saveToFile()
    end
    
    return true
end

-- Hàm hiển thị trạng thái
local function showStatus()
    local playerX, playerY, playerZ = getPlayerPosition()
    log("=== TRẠNG THÁI ===")
    log(string.format("Vị trí hiện tại: (%.2f, %.2f, %.2f)", playerX, playerY, playerZ))
    log(string.format("Đang di chuyển: %s", isMoving and "Có" or "Không"))
    if isMoving then
        log(string.format("Đích đến: (%.2f, %.2f, %.2f)", targetX, targetY, targetZ))
        local distance = getDistance(playerX, playerY, playerZ, targetX, targetY, targetZ)
        log(string.format("Khoảng cách: %.2f units", distance))
    end
    log(string.format("Tổng số tọa độ: %d", #savedCoords))
end

-- Hàm cài đặt
local function setConfig(key, value)
    if CONFIG[key] ~= nil then
        CONFIG[key] = value
        log(string.format("Đã cập nhật %s = %s", key, tostring(value)))
    else
        log("Lỗi: Tham số không tồn tại!")
    end
end

-- Hàm hiển thị cài đặt
local function showConfig()
    log("=== CÀI ĐẶT ===")
    for key, value in pairs(CONFIG) do
        log(string.format("%s = %s", key, tostring(value)))
    end
end

-- Hàm khởi tạo
local function initialize()
    log("=== SAMP Mobile Auto Move ===")
    log("Đang khởi tạo...")
    
    -- Tải tọa độ từ file
    loadFromFile()
    
    log("Khởi tạo hoàn tất!")
    log("Sử dụng các lệnh sau:")
    log("  /save - Lưu tọa độ hiện tại")
    log("  /goto [index] - Di chuyển đến tọa độ")
    log("  /next - Di chuyển đến tọa độ tiếp theo")
    log("  /stop - Dừng di chuyển")
    log("  /list - Hiển thị danh sách tọa độ")
    log("  /clear - Xóa tất cả tọa độ")
    log("  /status - Hiển thị trạng thái")
    log("  /config - Hiển thị cài đặt")
end

-- Hàm main loop
local function mainLoop()
    while true do
        updateMovement()
        wait(CONFIG.UPDATE_INTERVAL)
    end
end

-- Khởi tạo script
initialize()

-- Bắt đầu main loop
lua_thread.create(mainLoop)

-- API cho các lệnh
function onSave()
    saveCoordinates()
end

function onGoto(index)
    local idx = tonumber(index) or currentCoordIndex
    moveToSavedCoordinate(idx)
end

function onNext()
    moveToNextCoordinate()
end

function onStop()
    stopMoving()
end

function onList()
    listCoordinates()
end

function onClear()
    clearAllCoordinates()
end

function onStatus()
    showStatus()
end

function onConfig()
    showConfig()
end

function onDelete(index)
    local idx = tonumber(index)
    if idx then
        deleteCoordinate(idx)
    else
        log("Lỗi: Vui lòng nhập chỉ số tọa độ!")
    end
end

function onRename(index, name)
    local idx = tonumber(index)
    if idx and name then
        renameCoordinate(idx, name)
    else
        log("Lỗi: Vui lòng nhập chỉ số và tên mới!")
    end
end

function onSetConfig(key, value)
    setConfig(key, value)
end

-- Xuất các hàm chính
return {
    save = onSave,
    goto = onGoto,
    next = onNext,
    stop = onStop,
    list = onList,
    clear = onClear,
    status = onStatus,
    config = onConfig,
    delete = onDelete,
    rename = onRename,
    setConfig = onSetConfig
}