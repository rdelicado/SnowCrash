1. **Busqueda de archivos**

    Lo primero que hice fue un ls -l para ver que habia en el directorio /home encontrando asi un archivo .pcap de captura de paquetes de red
    ```bash
    level02@SnowCrash:~$ ls -la
    total 24
    dr-x------ 1 level02 level02  120 Mar  5  2016 .
    d--x--x--x 1 root    users    340 Aug 30  2015 ..
    -r-x------ 1 level02 level02  220 Apr  3  2012 .bash_logout
    -r-x------ 1 level02 level02 3518 Aug 30  2015 .bashrc
    -r-x------ 1 level02 level02  675 Apr  3  2012 .profile
    ----r--r-- 1 flag02  level02 8302 Aug 30  2015 level02.pcap
    ```

2. **Inspeccionar archivo .pcap con tcpdump**

    Si existe dicho archivo seguramente este instalado el programa tcpdump con el cual se hizo la captura
    ```bash
    which tcpdump
    /usr/sbin/tcpdump
    ````

    A simple vista se observa una comunicacion entre dos direcciones IP y intercambio de paquetes (flags S, S., P., F.) donde muchos de estos paquetes se estan enviando datos tal vez sensibles (length 3, 18, 24, 67...)

    ```bash
    /usr/sbin/tcpdump -r level02.pcap
    [...]
    07:23:12.304425 IP 59.233.235.223.12121 > 59.233.235.218.39247: Flags [P.], seq 22:46, ack 22, win 453, options [nop,nop,TS val 46280426 ecr 18592804], length 24
    [...]
    ```



    