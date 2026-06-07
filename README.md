# PRJ301 - Car Wash System (EliteAuto)

**Group 1** | Java Web Application | PRJ301 - Java Web Development

## Mô tả dự án

Hệ thống rửa xe tự động **EliteAuto** là ứng dụng web cho phép khách hàng:
- Đăng ký / Đăng nhập tài khoản
- Quản lý phương tiện (thêm, sửa, xóa xe)
- Xem dashboard cá nhân và các ưu đãi thành viên
- Hệ thống phân loại thành viên (Tier) và thưởng (Reward)

Phần admin có thể quản lý khách hàng và hệ thống.

## Công nghệ sử dụng

- **Backend**: Java Servlet + JSP (Front Controller pattern)
- **Frontend**: Bootstrap 5 + Custom CSS
- **Database**: Microsoft SQL Server
- **Build tool**: Apache Ant (NetBeans Web Project)
- **Server**: Apache Tomcat 9

## Cấu trúc dự án

```
PRJ301_Group1_CarWashSystem/
├── src/
│   └── java/
│       ├── controller/     # Các Servlet Controller
│       ├── dao/            # Data Access Object
│       ├── dto/            # Data Transfer Object (Entity)
│       └── dbutils/        # DB Connection
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── lib/            # Thư viện cần thiết
│   ├── css/
│   ├── img/
│   └── *.jsp             # View pages
├── lib/                    # JDBC Driver & libraries
├── nbproject/              # NetBeans project files
└── build.xml
```

## Yêu cầu để chạy dự án

1. **Java Development Kit (JDK)** 1.8+
2. **Apache Tomcat** 9.x
3. **Microsoft SQL Server** + SQL Server JDBC Driver
4. **NetBeans IDE** (khuyến nghị) hoặc có thể deploy thủ công

## Hướng dẫn setup

### 1. Tạo Database

```sql
CREATE DATABASE AutoWashProDB;
```

Sau đó chạy script tạo bảng (nếu có) hoặc hệ thống sẽ tự tạo khi chạy lần đầu.

### 2. Cấu hình kết nối Database

Mở file [src/java/dbutils/DBUtils.java](src/java/dbutils/DBUtils.java) và chỉnh sửa thông tin:

```java
private static final String DB_NAME = "AutoWashProDB";
private static final String DB_USER_NAME = "SA";
private static final String DB_PASSWORD = "12345";
```

### 3. Thêm SQL Server JDBC Driver

- Copy `sqljdbc4.jar` vào:
  - `lib/`
  - `web/WEB-INF/lib/`

### 4. Build & Deploy (NetBeans)

1. Mở project bằng **NetBeans**
2. Chuột phải project → **Clean and Build**
3. Chuột phải project → **Run**

Hoặc deploy file `.war` thủ công vào Tomcat.

## Tác giả

**Group 1** - PRJ301 Summer 2026

## Lưu ý

- Project này được phát triển phục vụ môn học **PRJ301**.
- Database password hiện tại là hardcode (dùng cho môi trường học tập).
- Không nên sử dụng code này cho mục đích thương mại.

---

> Last updated: 2026
