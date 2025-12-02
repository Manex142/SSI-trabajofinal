#! /bin/bash
apt update && apt install -y sudo passwd ssh php && apt clean

USERNAME="dummy";
PASSWORD="dummy";

echo "$USERNAME:$PASSWORD:$INITID:$INITID::/home/$USERNAME:/bin/bash" > /root/users.txt

newusers /root/users.txt
