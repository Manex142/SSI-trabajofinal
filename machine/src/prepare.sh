#! /bin/bash
apt update && apt install -y sudo passwd ssh php steghide && apt clean

USERNAME="xmen";
PASSWORD="dummy";

echo "$USERNAME:$PASSWORD:$INITID:$INITID::/home/$USERNAME:/bin/bash" > /root/users.txt

newusers /root/users.txt


## 2. Generación y Ocultación de Claves SSH

KEY_DIR="/root/temp_keys"
mkdir -p $KEY_DIR

# Generar un par de claves SSH RSA sin passphrase
ssh-keygen -t rsa -f $KEY_DIR/id_rsa -N ""

# 2.1. Ocultar la clave privada con Steghide
# Seleccionar contraseña aleatoria del wordlist
STEGO_PASS=$(shuf -n 1 /opt/src/wordlist.txt)
CARRIER_FILE="/opt/src/rick-roll-meme.jpg"
OUTPUT_FILE="/var/www/html/DRAGON BALL/Vulnhub/flag.jpg"

steghide embed -ef "$KEY_DIR/id_rsa" -cf "$CARRIER_FILE" -sf "$OUTPUT_FILE" -p "$STEGO_PASS"

# 2.2. Configurar la clave pública para el usuario
mkdir -p /home/$USERNAME/.ssh
cp $KEY_DIR/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# 2.3. Copiar la flag de usuario
cp /opt/flag/user.txt /home/$USERNAME/user.txt
chown $USERNAME:$USERNAME /home/$USERNAME/user.txt

# 2.4. Copiar la flag de root
cp /opt/flag/root.txt /root/root.txt

# 2.5 Copiar carpeta script necesaria para la flag de root
cp /opt/src/script /home/$USERNAME/script -r
chown root:root /home/$USERNAME/script/shell
chmod u+s /home/$USERNAME/script/shell

# 2.6. Borrar archivos temporales
rm -rf $KEY_DIR
rm -rf /opt/flag
rm -f /opt/src/wordlist.txt
