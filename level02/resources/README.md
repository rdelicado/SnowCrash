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



