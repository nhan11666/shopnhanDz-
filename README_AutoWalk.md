# SA-MP Mobile Auto Walk Script

## Mô tả
Script Lua cho SA-MP Mobile cho phép tự động di chuyển đến các tọa độ đã lưu trước đó.

## Tính năng chính

### 1. Lưu tọa độ
- Lưu vị trí hiện tại của người chơi
- Đặt tên cho từng vị trí đã lưu
- Quản lý danh sách vị trí đã lưu

### 2. Tự động di chuyển
- Di chuyển tự động đến tọa độ đã chọn
- Hiển thị khoảng cách còn lại
- Dừng tự động khi đến đích (trong vòng 2 mét)

### 3. Giao diện người dùng
- Menu thân thiện với người dùng
- Hướng dẫn sử dụng rõ ràng
- Hiển thị thông tin trạng thái

## Cách sử dụng

### Phím tắt
- **F1**: Mở/Đóng menu chính
- **F2**: Bắt đầu/Dừng tự động di chuyển
- **↑/↓**: Di chuyển trong menu
- **Enter**: Chọn tùy chọn

### Các bước sử dụng

1. **Lưu vị trí**:
   - Đi đến vị trí muốn lưu
   - Nhấn F1 để mở menu
   - Chọn "Lưu vị trí hiện tại"

2. **Di chuyển tự động**:
   - Nhấn F1 để mở menu
   - Chọn vị trí muốn di chuyển đến
   - Script sẽ tự động di chuyển đến đó

3. **Xóa vị trí**:
   - Nhấn F1 để mở menu
   - Chọn nút "Xóa" bên cạnh vị trí muốn xóa

## Cài đặt

1. Copy file `samp_mobile_autowalk.lua` vào thư mục scripts của SA-MP Mobile
2. Khởi động lại SA-MP Mobile
3. Script sẽ tự động được tải

## Tùy chỉnh

### Thay đổi tốc độ di chuyển
```lua
local walkSpeed = 1.0  -- Thay đổi giá trị này
```

### Thêm vị trí mặc định
```lua
table.insert(savedLocations, {
    name = "Tên vị trí",
    x = 1000.0,
    y = 1000.0,
    z = 10.0
})
```

### Thay đổi màu sắc
```lua
local colors = {
    background = {0, 0, 0, 180},    -- Màu nền
    text = {255, 255, 255, 255},    -- Màu chữ
    selected = {255, 255, 0, 255},  -- Màu được chọn
    button = {50, 50, 50, 200},     -- Màu nút
    buttonHover = {80, 80, 80, 200} -- Màu nút khi hover
}
```

## Lưu ý

- Script chỉ hoạt động khi bạn đang trong game SA-MP
- Đảm bảo không vi phạm quy tắc server khi sử dụng
- Một số server có thể chặn script tự động di chuyển
- Luôn kiểm tra quy tắc server trước khi sử dụng

## Xử lý lỗi

### Script không hoạt động
- Kiểm tra xem SA-MP Mobile có hỗ trợ Lua scripts không
- Đảm bảo file được đặt đúng thư mục
- Khởi động lại SA-MP Mobile

### Không thể di chuyển
- Kiểm tra xem có bị chặn bởi server không
- Thử giảm tốc độ di chuyển
- Kiểm tra tọa độ có hợp lệ không

## Phiên bản
- **v1.0**: Phiên bản đầu tiên với các tính năng cơ bản

## Tác giả
AI Assistant

## Giấy phép
Script này được tạo cho mục đích học tập và sử dụng cá nhân.