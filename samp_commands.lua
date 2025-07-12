-- SAMP Mobile Command Handler
-- Xử lý các lệnh cho script tự động di chuyển

-- Import script auto move
local autoMove = require('samp_mobile_auto_move')

-- Hàm xử lý lệnh
local function handleCommand(command, params)
    local cmd = string.lower(command)
    
    if cmd == "/save" or cmd == "save" then
        autoMove.save()
        
    elseif cmd == "/goto" or cmd == "goto" then
        if params and params ~= "" then
            local index = tonumber(params)
            if index then
                autoMove.goto(index)
            else
                print("[CMD] Lỗi: Vui lòng nhập số chỉ mục hợp lệ!")
                print("[CMD] Sử dụng: /goto [số]")
            end
        else
            autoMove.goto()
        end
        
    elseif cmd == "/next" or cmd == "next" then
        autoMove.next()
        
    elseif cmd == "/stop" or cmd == "stop" then
        autoMove.stop()
        
    elseif cmd == "/list" or cmd == "list" then
        autoMove.list()
        
    elseif cmd == "/clear" or cmd == "clear" then
        autoMove.clear()
        
    elseif cmd == "/status" or cmd == "status" then
        autoMove.status()
        
    elseif cmd == "/config" or cmd == "config" then
        autoMove.config()
        
    elseif cmd == "/delete" or cmd == "delete" then
        if params and params ~= "" then
            autoMove.delete(params)
        else
            print("[CMD] Lỗi: Vui lòng nhập chỉ số tọa độ cần xóa!")
            print("[CMD] Sử dụng: /delete [số]")
        end
        
    elseif cmd == "/rename" or cmd == "rename" then
        if params and params ~= "" then
            local index, name = params:match("(%d+)%s+(.+)")
            if index and name then
                autoMove.rename(index, name)
            else
                print("[CMD] Lỗi: Định dạng không đúng!")
                print("[CMD] Sử dụng: /rename [số] [tên mới]")
            end
        else
            print("[CMD] Lỗi: Vui lòng nhập chỉ số và tên mới!")
            print("[CMD] Sử dụng: /rename [số] [tên mới]")
        end
        
    elseif cmd == "/set" or cmd == "set" then
        if params and params ~= "" then
            local key, value = params:match("(%S+)%s+(.+)")
            if key and value then
                -- Chuyển đổi giá trị số và boolean
                local numValue = tonumber(value)
                if numValue then
                    autoMove.setConfig(key, numValue)
                elseif value:lower() == "true" then
                    autoMove.setConfig(key, true)
                elseif value:lower() == "false" then
                    autoMove.setConfig(key, false)
                else
                    autoMove.setConfig(key, value)
                end
            else
                print("[CMD] Lỗi: Định dạng không đúng!")
                print("[CMD] Sử dụng: /set [tham số] [giá trị]")
            end
        else
            print("[CMD] Lỗi: Vui lòng nhập tham số và giá trị!")
            print("[CMD] Sử dụng: /set [tham số] [giá trị]")
        end
        
    elseif cmd == "/help" or cmd == "help" or cmd == "/?" or cmd == "?" then
        print("[CMD] === HƯỚNG DẪN SỬ DỤNG ===")
        print("[CMD] /save - Lưu tọa độ hiện tại")
        print("[CMD] /goto [số] - Di chuyển đến tọa độ (không có số = tọa độ hiện tại)")
        print("[CMD] /next - Di chuyển đến tọa độ tiếp theo")
        print("[CMD] /stop - Dừng di chuyển")
        print("[CMD] /list - Hiển thị danh sách tọa độ")
        print("[CMD] /delete [số] - Xóa tọa độ theo chỉ số")
        print("[CMD] /clear - Xóa tất cả tọa độ")
        print("[CMD] /rename [số] [tên] - Đổi tên tọa độ")
        print("[CMD] /status - Hiển thị trạng thái hiện tại")
        print("[CMD] /config - Hiển thị cài đặt")
        print("[CMD] /set [tham số] [giá trị] - Thay đổi cài đặt")
        print("[CMD] /help - Hiển thị hướng dẫn này")
        
    else
        print("[CMD] Lệnh không tồn tại: " .. cmd)
        print("[CMD] Sử dụng /help để xem danh sách lệnh")
    end
end

-- Hàm đăng ký lệnh cho SAMP Mobile
local function registerCommands()
    -- Danh sách các lệnh
    local commands = {
        "save", "goto", "next", "stop", "list", "clear", 
        "status", "config", "delete", "rename", "set", "help"
    }
    
    -- Đăng ký từng lệnh
    for _, cmd in ipairs(commands) do
        sampRegisterChatCommand(cmd, function(params)
            handleCommand("/" .. cmd, params)
        end)
    end
    
    print("[CMD] Đã đăng ký tất cả lệnh!")
end

-- Xử lý tin nhắn chat (backup cho trường hợp lệnh không hoạt động)
local function onReceiveRpc(id, bs)
    if id == 101 then -- Chat message RPC
        local message = raknetBitStreamReadString(bs, raknetBitStreamGetNumberOfBytesUsed(bs))
        
        -- Kiểm tra xem có phải lệnh không
        if message and message:sub(1, 1) == "/" then
            local command, params = message:match("^(/[^%s]+)%s*(.*)")
            if command then
                handleCommand(command, params)
            end
        end
    end
end

-- Khởi tạo
registerCommands()

-- Đăng ký event handler (nếu cần)
-- sampAddChatMessage = hookFunction(sampAddChatMessage, onReceiveRpc)

print("[CMD] Command Handler đã sẵn sàng!")
print("[CMD] Sử dụng /help để xem danh sách lệnh")