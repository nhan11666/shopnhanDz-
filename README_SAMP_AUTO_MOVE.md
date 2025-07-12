# SAMP Mobile Auto Move Script

Script Lua tự động di chuyển đến tọa độ đã lưu cho SAMP Mobile.

## 🚀 Tính năng

- ✅ Lưu và quản lý tọa độ
- ✅ Tự động di chuyển đến tọa độ đã lưu
- ✅ Di chuyển theo chu kỳ (next/previous)
- ✅ Lưu/tải tọa độ từ file
- ✅ Đổi tên và xóa tọa độ
- ✅ Cấu hình tốc độ di chuyển
- ✅ Hiển thị trạng thái và khoảng cách
- ✅ Hệ thống lệnh đơn giản

## 📦 Cài đặt

1. **Tải xuống files:**
   - `samp_mobile_auto_move.lua` - Script chính
   - `samp_commands.lua` - Xử lý lệnh
   - `README_SAMP_AUTO_MOVE.md` - Hướng dẫn này

2. **Đặt files vào thư mục scripts của SAMP Mobile:**
   ```
   /storage/emulated/0/Android/data/com.rockstargames.gtasa/files/SAMP/scripts/
   ```

3. **Khởi chạy script trong game:**
   - Mở SAMP Mobile
   - Vào game và mở console
   - Gõ: `/lua load samp_mobile_auto_move.lua`
   - Gõ: `/lua load samp_commands.lua`

## 🎮 Cách sử dụng

### Lệnh cơ bản

| Lệnh | Mô tả | Ví dụ |
|------|-------|-------|
| `/save` | Lưu tọa độ hiện tại | `/save` |
| `/goto [số]` | Di chuyển đến tọa độ | `/goto 1` |
| `/next` | Di chuyển đến tọa độ tiếp theo | `/next` |
| `/stop` | Dừng di chuyển | `/stop` |
| `/list` | Hiển thị danh sách tọa độ | `/list` |
| `/help` | Hiển thị hướng dẫn | `/help` |

### Lệnh quản lý

| Lệnh | Mô tả | Ví dụ |
|------|-------|-------|
| `/delete [số]` | Xóa tọa độ | `/delete 3` |
| `/clear` | Xóa tất cả tọa độ | `/clear` |
| `/rename [số] [tên]` | Đổi tên tọa độ | `/rename 1 Ngân hàng` |
| `/status` | Hiển thị trạng thái | `/status` |
| `/config` | Hiển thị cài đặt | `/config` |

### Lệnh cấu hình

| Lệnh | Mô tả | Ví dụ |
|------|-------|-------|
| `/set MOVE_SPEED [giá trị]` | Tốc độ di chuyển (0.1-2.0) | `/set MOVE_SPEED 1.5` |
| `/set STOP_DISTANCE [giá trị]` | Khoảng cách dừng | `/set STOP_DISTANCE 3.0` |
| `/set UPDATE_INTERVAL [giá trị]` | Thời gian cập nhật (ms) | `/set UPDATE_INTERVAL 50` |

## 📝 Hướng dẫn chi tiết

### 1. Lưu tọa độ
```
/save
```
- Lưu vị trí hiện tại với tên tự động (Coord_1, Coord_2, ...)
- Tọa độ được lưu vào file `coordinates.txt`

### 2. Di chuyển đến tọa độ
```
/goto 1        # Di chuyển đến tọa độ số 1
/goto          # Di chuyển đến tọa độ hiện tại
/next          # Di chuyển đến tọa độ tiếp theo
```

### 3. Quản lý tọa độ
```
/list                      # Xem danh sách
/rename 1 "Ngân hàng LS"   # Đổi tên
/delete 3                  # Xóa tọa độ số 3
/clear                     # Xóa tất cả
```

### 4. Theo dõi tiến trình
```
/status        # Xem trạng thái hiện tại
/stop          # Dừng di chuyển
```

## ⚙️ Cấu hình

### Tham số có thể thay đổi:

- **MOVE_SPEED**: Tốc độ di chuyển (0.1 - 2.0)
- **STOP_DISTANCE**: Khoảng cách dừng lại (units)
- **UPDATE_INTERVAL**: Thời gian cập nhật (milliseconds)
- **MAX_SAVED_COORDS**: Số lượng tọa độ tối đa (50)
- **AUTO_SAVE**: Tự động lưu file (true/false)

### Ví dụ thay đổi cấu hình:
```
/set MOVE_SPEED 0.5        # Di chuyển chậm hơn
/set STOP_DISTANCE 2.0     # Dừng gần hơn
/set UPDATE_INTERVAL 200   # Cập nhật chậm hơn
```

## 📁 Cấu trúc file

```
coordinates.txt            # File lưu tọa độ
└── Format: name|x|y|z|timestamp
    ├── Ngân hàng LS|1481.23|-1749.45|13.55|1642123456
    ├── Bệnh viện|2034.12|-1401.67|17.29|1642123789
    └── Sân bay|1685.45|-2238.90|13.55|1642124000
```

## 🔧 Khắc phục sự cố

### Script không chạy:
1. Kiểm tra đường dẫn file
2. Đảm bảo SAMP Mobile hỗ trợ Lua
3. Kiểm tra console có lỗi không

### Di chuyển không hoạt động:
1. Kiểm tra có tọa độ đã lưu chưa (`/list`)
2. Thử thay đổi `MOVE_SPEED` (`/set MOVE_SPEED 1.0`)
3. Kiểm tra trạng thái (`/status`)

### Lệnh không phản hồi:
1. Thử gõ lại lệnh
2. Kiểm tra cú pháp lệnh (`/help`)
3. Reload script

## 📋 Ví dụ sử dụng

### Tình huống 1: Lưu các địa điểm quan trọng
```
# Đi đến ngân hàng LS
/save
/rename 1 "Ngân hàng LS"

# Đi đến bệnh viện
/save  
/rename 2 "Bệnh viện"

# Đi đến sân bay
/save
/rename 3 "Sân bay"
```

### Tình huống 2: Di chuyển nhanh
```
/list                    # Xem danh sách
/goto 1                  # Đến ngân hàng
/goto 2                  # Đến bệnh viện  
/next                    # Đến địa điểm tiếp theo
```

### Tình huống 3: Tuần tra tự động
```
/goto 1                  # Bắt đầu từ điểm 1
# Đợi đến nơi...
/next                    # Tự động đến điểm 2
# Đợi đến nơi...
/next                    # Tự động đến điểm 3
```

## ⚠️ Lưu ý quan trọng

1. **Tốc độ di chuyển**: Không đặt quá cao để tránh lag
2. **Khoảng cách**: Điều chỉnh `STOP_DISTANCE` phù hợp
3. **Backup**: Sao lưu file `coordinates.txt` thường xuyên
4. **Server rules**: Tuân thủ quy định server về script/mod

## 🤝 Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra console lỗi
2. Thử reload script
3. Kiểm tra file log
4. Reset cấu hình về mặc định

## 📄 License

Script này được phân phối miễn phí cho mục đích giáo dục và giải trí.

---

**Tác giả**: AI Assistant  
**Phiên bản**: 1.0  
**Ngày cập nhật**: 2024  

Happy gaming! 🎮