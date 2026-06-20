# Ghi chú báo cáo — `autoUpdateStatus()` trong `PromotionDAO`

**Người báo cáo:** Tùng (CUD Promotion)  
**Liên quan:** `PromotionDAO.autoUpdateStatus()` + luồng Start/Stop promotion  
**Ngày:** 20/06/2026

---

## 1. Vấn đề phát hiện khi test

- Promotion có `EndDate = 20/06/2026`, trong ngày 20/06 bấm **Start** → backend báo *"Update status successfully!"*
- Nhưng trên list vẫn **INACTIVE** — không thấy chạy lại.

---

## 2. Quy tắc nghiệp vụ (đã thống nhất)

| Thời điểm | Trạng thái |
|-----------|------------|
| Trong ngày `EndDate` (đến 23:59:59 ngày 20/06) | Promotion **còn hiệu lực** |
| Từ 00:00 ngày sau (`21/06`) | Promotion **hết hạn** |

→ Hết hạn tính theo **ngày**, không theo **giờ** trong ngày `EndDate`.

---

## 3. Nguyên nhân

`ManagePromotionsController` mỗi lần load list đều gọi:

```java
dao.autoUpdateStatus();
```

SQL hiện tại trong `PromotionDAO`:

```sql
UPDATE Promotions SET IsActive = 0 WHERE EndDate < GETDATE()
```

- `GETDATE()` có **giờ** (ví dụ: `20/06/2026 10:30:00`)
- `EndDate` kiểu `DATE` → so sánh như `20/06/2026 00:00:00`
- Từ **sáng ngày 20/06** đã thỏa `EndDate < GETDATE()` → bị set `IsActive = 0` **sai** (trong khi vẫn còn hiệu lực đến cuối ngày)

**Luồng lỗi:**

```
Start → activatePromo (IsActive = 1) → success
    → forward ManagePromotionsController
    → autoUpdateStatus() tắt lại ngay trong ngày EndDate
    → list vẫn INACTIVE
```

---

## 4. Đề xuất sửa

Đổi điều kiện trong `autoUpdateStatus()` thành:

```sql
UPDATE Promotions
SET IsActive = 0
WHERE EndDate < CAST(GETDATE() AS DATE)
```

**Giải thích:**

| Ngày hệ thống | EndDate = 20/06 | `EndDate < CAST(GETDATE() AS DATE)` | Kết quả |
|---------------|-----------------|-------------------------------------|---------|
| 20/06/2026 | 20/06 | `20/06 < 20/06` → false | **Không** auto tắt |
| 21/06/2026 | 20/06 | `20/06 < 21/06` → true | Auto tắt (đúng) |

Cùng logic với `isPromotionExpired()` phía CUD (đã dùng `CAST(GETDATE() AS DATE)`).

---

## 5. Phạm vi ảnh hưởng

- Promotion hết hạn **từ ngày sau `EndDate`** mới bị auto deactivate
- Start trong ngày `EndDate` hoạt động đúng, không bị tắt lại ngay sau load list
- Filter / thống kê active–inactive nhất quán với quy tắc “còn hiệu lực đến hết ngày EndDate”

---

## 6. Gợi ý test sau khi sửa

1. Promo `EndDate = hôm nay`, `IsActive = 0` → Start → list hiện **RUNNING**, message success.
2. Cùng promo ngày hôm nay → Stop → **INACTIVE**.
3. Promo `EndDate = hôm qua` → Start → báo không start được (phía CUD đã check `isPromotionExpired`).
4. Sang ngày sau `EndDate` → vào trang list → promo tự **INACTIVE** (autoUpdate).

---

## 7. File / hàm cần chỉnh

| File | Hàm | Thay đổi |
|------|-----|----------|
| `src/java/dao/PromotionDAO.java` | `autoUpdateStatus()` | `GETDATE()` → `CAST(GETDATE() AS DATE)` trong điều kiện `WHERE` |

**Không** cần đổi `ManagePromotionsController` nếu chỉ sửa SQL trong DAO.