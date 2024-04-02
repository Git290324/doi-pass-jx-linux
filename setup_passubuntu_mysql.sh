#!/bin/bash

# Đọc mật khẩu tạm thời từ log lỗi MySQL
TEMP_PASSWORD=$(sudo grep 'temporary password' /var/log/mysql/error.log | awk '{print $NF}')

# Đặt mật khẩu mới cho người dùng root
NEW_PASSWORD="PGaming@1107A"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$NEW_PASSWORD'; FLUSH PRIVILEGES;" | sudo mysql -u root -p"$TEMP_PASSWORD"

# Chạy mysql_secure_installation
echo -e "\n\n\n\nY\n\n\nY\nY\nY\nY" | sudo mysql_secure_installation

# Truy cập MySQL với mật khẩu mới
echo "CREATE DATABASE server1;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$NEW_PASSWORD';
FLUSH PRIVILEGES;
exit" | sudo mysql -u root -p"$NEW_PASSWORD"
