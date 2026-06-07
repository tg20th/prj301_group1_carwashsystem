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
├── sql/
│   └── init.sql            # Script khởi tạo database + seed data (QUAN TRỌNG)
├── src/
│   └── java/
│       ├── controller/     # Các Servlet Controller
│       ├── dao/            # Data Access Object
│       ├── dto/            # Data Transfer Object (Entity)
│       └── dbutils/        # DB Connection (hardcoded config)
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── lib/            # Runtime libraries (JSTL + sqljdbc4)
│   ├── css/
│   ├── img/
│   └── *.jsp             # View pages
├── lib/                    # Compile-time libraries (committed for portability)
│   ├── javaee-api-7.0.jar
│   ├── servlet-api.jar
│   └── sqljdbc4.jar
├── nbproject/              # NetBeans Ant project metadata (cleaned for sharing)
├── build.xml
└── README.md
```

## Yêu cầu để chạy dự án

1. **Java Development Kit (JDK)** 1.8+
2. **Apache Tomcat** 9.x (đã add vào NetBeans Server)
3. **Microsoft SQL Server** (Express hoặc Developer) + SQL Authentication (SA hoặc user có quyền)
4. **NetBeans IDE** 12+ / 17+ / 19+ (khuyến nghị) hoặc Apache NetBeans. Có thể build thủ công bằng Ant.

## Hướng dẫn setup (cho collaborator clone về)

### Bước 1: Clone & Mở project

```bash
git clone <repo-url>
cd prj301_group1_carwashsystem
```

Mở thư mục bằng **NetBeans** → "Open Project".  
Project metadata (project.properties + project.xml) đã được dọn để không còn absolute path hay merge conflict.

### Bước 2: Khởi tạo Database (BẮT BUỘC)

Mở file [sql/init.sql](sql/init.sql) bằng SSMS hoặc Azure Data Studio và **execute toàn bộ script**.

Script sẽ:
- Tạo database `AutoWashProDB` (nếu chưa có)
- Tạo đầy đủ 5 bảng: `LoyaltyTiers`, `Accounts`, `Customers`, `Vehicles`, `Rewards`
- Seed dữ liệu Tier + Reward mẫu
- Tạo 2 tài khoản demo (xem comment cuối script)

> **Lưu ý**: Script an toàn để chạy lại nhiều lần trong quá trình dev (nó DROP TABLE trước khi CREATE).

### Bước 3: Cấu hình kết nối Database (nếu cần thay đổi)

Mở file [src/java/dbutils/DBUtils.java](src/java/dbutils/DBUtils.java) và chỉnh nếu bạn dùng:
- Database name khác
- SQL Server instance không phải `localhost:1433`
- User/password khác SA/12345

Mặc định trong code:
```java
DB_NAME = "AutoWashProDB"
DB_USER_NAME = "SA"
DB_PASSWORD = "12345"
url = "jdbc:sqlserver://localhost:1433;databaseName=" + DB_NAME
```

### Bước 4: Build & Run trong NetBeans

1. Chuột phải project → **Clean and Build**
2. Chuột phải project → **Run**

NetBeans sẽ tự build WAR và deploy lên Tomcat đã đăng ký.

Truy cập: `http://localhost:8080/CarWashSystem` (path được set trong `web/META-INF/context.xml`)

### Demo accounts (sau khi chạy init.sql)

- Customer: `demo.customer@eliteauto.local` / `Customer@123`
- Admin: `admin@eliteauto.local` / `Admin@123` (RoleID=1)

### Deploy thủ công (không dùng NetBeans)

1. Clean & Build để tạo `dist/CarWashSystem.war`
2. Copy file war vào `webapps/` của Tomcat
3. Khởi động Tomcat → truy cập `/CarWashSystem`

## Những gì đã được fix để collaborator clone dùng ngay

- Loại bỏ toàn bộ absolute path (`D:\ThuVienJAVA\...`, `C:\Tomcat\...`) trong `nbproject/project.properties`
- Xóa các dấu tích Git merge conflict còn sót lại
- Tham chiếu thư viện (javac.classpath + web-module-libraries) dùng đường dẫn tương đối đến `lib/`
- Bổ sung script SQL đầy đủ (`sql/init.sql`) — trước đây không có script nào
- Dọn stray file `nbproject/build-impl.xml~`
- Cập nhật hướng dẫn README rõ ràng hơn

Các file Java **không bị thay đổi** theo yêu cầu (DB connection vẫn hardcoded trong DBUtils.java).

## Tác giả

**Group 1** - PRJ301 Summer 2026

## Lưu ý quan trọng

- Project này được phát triển phục vụ môn học **PRJ301** (học tập).
- **Mật khẩu database và tài khoản user được hardcode** (SA / 12345, và password plaintext trong DB). Chỉ dùng cho môi trường học tập / demo.
- Mật khẩu người dùng được lưu **plaintext** (không hash) — không dùng cho production.
- Không nên sử dụng code này cho mục đích thương mại hoặc thực tế.
- Sau khi clone, nếu bạn gặp lỗi "library not found" trong NetBeans:
  - Right-click project → Properties → Libraries → Add JAR/Folder → chọn các file trong thư mục `lib/`.

## Tác giả

**Group 1** - PRJ301 Summer 2026

---

> Last updated: 2026 (fixed for collaborator clone readiness)
