#!/bin/bash

# Read the temporary password from MySQL error log
TEMP_PASSWORD=$(sudo grep 'temporary password' /var/log/mysql/error.log | awk '{print $NF}')

# Change MySQL root password
NEW_PASSWORD=$(openssl rand -base64 12)
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$NEW_PASSWORD'; FLUSH PRIVILEGES;" | sudo mysql -u root -p"$TEMP_PASSWORD"

# Run mysql_secure_installation
echo -e "\n\n\n\nY\n$NEW_PASSWORD\n$NEW_PASSWORD\nY\nY\nY\nY" | sudo mysql_secure_installation

# Access MySQL with new password
echo "CREATE DATABASE server1;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$NEW_PASSWORD';
FLUSH PRIVILEGES;
exit" | sudo mysql -u root -p"$NEW_PASSWORD"
