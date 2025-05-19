1. **File search**

    The first thing I did was an `ls -l` to see what was in the /home directory, finding a .pcap network packet capture file:
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

2. **Inspecting the .pcap file with tcpdump**

    If this file exists, the tcpdump program is probably installed, which was used to capture the traffic:
    ```bash
    which tcpdump
    /usr/sbin/tcpdump
    ```

    At first glance, you can see communication between two IP addresses and packet exchanges (flags S, S., P., F.), where many of these packets are sending potentially sensitive data (length 3, 18, 24, 67...)

    ```bash
    /usr/sbin/tcpdump -r level02.pcap
    [...]
    07:23:12.304425 IP 59.233.235.223.12121 > 59.233.235.218.39247: Flags [P.], seq 22:46, ack 22, win 453, options [nop,nop,TS val 46280426 ecr 18592804], length 24
    [...]
    ```

    I transferred the file to my local machine:
    ```bash
    scp -P 4242 level02@10.156.22.151:level02.pcap .
    ```

3. **Identifying passwords**

    Using `tshark` I can see the output in plain text, and with `xxd` (which converts hex to plain text), I can observe that within the packets there is a login attempt with a password:
    
    ```bash
    tshark -r level02.pcap -Y 'tcp' -T fields -e tcp.payload | xxd -r -p
    wwwbugs login: lleevveellXX
    Password: ft_wandrNDRelL0L
    ``` 
    
    This output is not exact, as the `xxd` command or the protocol itself may alter the output, so you have to play with the text.

    ```bash 
    ft_wandrNDRelL0l   -> removing repeated words we get ft_waNDReL0L
    ``` 

    Another way to visualize it is with the following command:

    ```bash
    sudo tshark -r level02.pcap -Y 'tcp' -T fields -e tcp.payload
    [...]
    66
    74
    5f
    77
    61
    6e
    64
    72
    7f
    7f
    7f
    4e
    44
    52
    65
    6c
    7f
    4c
    30
    4c
    0d
    [...]
    ```  

    66 = f
    74 = t
    5f = _
    77 = w
    61 = a
    6e = n
    64 = d
    72 = r
    7f = DEL (delete)
    7f = DEL
    7f = DEL
    4e = N
    44 = D
    52 = R
    65 = e
    6c = l
    7f = DEL
    4c = L
    30 = 0
    4c = L
    0d = carriage return (Enter)

    What does this mean?

    The user typed: ft_wandr
    Then pressed backspace 3 times (7f), deleting the last 3 letters: r, d, n
    Then typed: NDR
    Then: el
    Pressed backspace once (7f), deleting the l
    Finally typed: L0L
    And pressed Enter (0d)

    Step-by-step reconstruction:

    Write: ft_wandr
    Press backspace 3 times: removes r, d, n → remains ft_wa
    Write: NDR → ft_waNDR
    Write: el → ft_waNDRel
    Press backspace once: removes l → ft_waNDReL
    Write: L0L → ft_waNDReL0L
    Therefore, the correct password is: ft_waNDReL0L
    
4. **Using Wireshark**

    By opening the .pcap file in Wireshark and following the TCP stream, you can see the password attempt in plain text within the last packets:

    ```bash
    Password: 
    ft_wandr...NDRel.L0L
    ```  

    In this view, each `.` represents a non-printable character captured in the network traffic. Specifically:
    - `0d` is a carriage return (`\r`), which usually appears at the end of a line (when pressing Enter).
    - `7f` is the DEL (delete) character, which is sent when the user presses the backspace key to erase a character.

    Therefore, when you see a sequence like `...`, it means the user pressed backspace three times, deleting the previous three characters. A single `.` means one character was deleted. To reconstruct the actual password, you need to remove the deleted characters accordingly:

    - For example, in `ft_wandr...NDRel.L0L`, the three dots after `ft_wandr` indicate that `r`, `d`, and `n` were deleted, leaving `ft_wa`. Then, the user typed `NDRel`, deleted the last `l` (as indicated by the next dot), and finally typed `L0L`.

    By applying this logic, you can accurately reconstruct the password as it was intended: `ft_waNDReL0L`.



tcpdump -X -r level02.pcap  | grep -i "0x0030" > /tmp/pass.txt
-X para hexadecimal
-r para leer archivo
Si lo pasas a decimal, 0x0030 = 48. Eso significa que en esa línea, los datos que ves empiezan en el byte número 48 del archivo o captura.
Piensa que el archivo de datos es como una fila de casillas numeradas: 0, 1, 2, 3... y así sucesivamente.

Entonces, la línea que dice 0x0030 significa: "Los bytes que te voy a mostrar están a partir del casillero 48."

Esa posición es importante porque te ayuda a saber dónde están exactamente los datos que quieres leer o analizar, como la contraseña.

cut -c23- /tmp/pass.txt
cortamos a partir de la linea 23 o 21, segun...
vemos ascii mas contrasena
cut -c56- /tmp/pass.txt
cortamos a partir de la linea aprox 56 vemos la contrena
🧩 ¿Qué pasó exactamente?
1. El binario pidió la contraseña
Cuando ejecutaste el binario, imprimió:

makefile
Copiar
Editar
Password:
Y tú o el programa empezó a escribir la contraseña letra por letra, en formato hexadecimal (como lo veías en /tmp/pass.txt).

2. Se grabó la entrada del teclado
En ese archivo se registraron los caracteres que se fueron escribiendo, y también los caracteres DEL (0x7f) cuando se pulsó la tecla de borrar (como cuando te equivocas y corriges).

Ejemplo simplificado:

css
Copiar
Editar
f t _ w a n d r [DEL][DEL][DEL] N D R e l [DEL] L 0 L [DEL]
3. Después de escribir la contraseña, se pulsó ENTER
Al pulsar ENTER, el binario validó la contraseña y devolvió el mensaje:

nginx
Copiar
Editar
Login incorrect
🤔 Pero entonces… ¿la contraseña era incorrecta?
No. Lo importante es esto:

❗ Tú no estabas ejecutando el binario para probar la contraseña ya reconstruida. Solo estabas capturando cómo se escribió mal y con errores.
💡 ¿Cuándo fue "correcta" la contraseña?
Nunca se llegó a probar la contraseña correcta (ft_waNDReLoL) en ese intento.

Solo se grabó el intento con errores (y correcciones parciales), que resultó en:

nginx
Copiar
Editar
Login incorrect
✅ ¿Qué debes hacer tú?
Tú reconstruiste a mano la secuencia de caracteres, limpiando los caracteres borrados (DEL).
Eso te dio:

nginx
Copiar
Editar
ft_waNDReLoL
Y esa es la contraseña que debes probar ahora, manualmente, en el binario real.