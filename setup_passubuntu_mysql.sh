#!/bin/bash

# Đọc mật khẩu tạm thời từ log lỗi MySQL
TEMP_PASSWORD=$(sudo grep 'temporary password' /var/log/mysql/error.log | awk '{print $NF}')

# Đặt mật khẩu mới cho người dùng root
NEW_PASSWORD="PGaming@1107A"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$NEW_PASSWORD'; FLUSH PRIVILEGES;" | sudo mysql -u root -p"$TEMP_PASSWORD"

# Chạy mysql_secure_installation
echo -e "\n\n\n\nY\n$NEW_PASSWORD\n$NEW_PASSWORD\nY\nY\nY\nY" | sudo mysql_secure_installation

# Xóa cơ sở dữ liệu "server1" nếu tồn tại và tạo lại
echo "DROP DATABASE IF EXISTS server1;
CREATE DATABASE server1;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$NEW_PASSWORD';
FLUSH PRIVILEGES;
exit" | sudo mysql -u root -p"$NEW_PASSWORD"
