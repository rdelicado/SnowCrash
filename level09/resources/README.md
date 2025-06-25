1. **File Discovery**

    ```bash
    level09@SnowCrash:~$ ll
    [...]
    -rwsr-sr-x 1 flag09  level09 7640 Mar  5  2016 level09*
    ----r--r-- 1 flag09  level09   26 Mar  5  2016 token
    level09@SnowCrash:~$ ./level09 token
    [...]
    tpmhr
    You should not reverse this
    LD_PRELOAD
    Injection Linked lib detected exit..
    /etc/ld.so.preload
    /proc/self/maps
    /proc/self/maps is unaccessible, probably a LD_PRELOAD attempt exit..
    libc
    You need to provided only one arg.
    00000000 00:00 0
    LD_PRELOAD detected through memory maps exit ..
    [...]
    ```

    SUID binary and permissions:
    - The `level09` binary has the SUID bit set and is owned by `flag09`. This means when executed, it runs with `flag09`'s permissions, even if executed by `level09`.

    Token file:
    - The `token` file can only be read by `flag09 (----r--r--)`. However, the SUID binary can access it.

    Running the binary:
    - When executing `./level09 token`, the actual content of the file is not shown, but rather an apparently encrypted or transformed string.

    Suspicious strings in the binary:
    - Using `strings`, various strings related to anti-reverse-engineering and library manipulation `(LD_PRELOAD, /proc/self/maps, ptrace, etc.)` are observed, indicating the binary attempts to prevent debugging or tampering.

    Possible vulnerability:
    - The binary reads the `token` file and outputs a transformed string. It likely applies a simple transformation (e.g., Caesar cipher, XOR, etc.) to the content before displaying it.

2. **Exploitation:**

    ```bash
    # Create a file with known text.
    level09@SnowCrash:~$ echo "hola" > /tmp/file
    bash: /tmp/file: Permission denied
    level09@SnowCrash:~$ echo "hola" > /var/tmp/file
    # Run `./level09 <file>` and observe the output.
    level09@SnowCrash:~$ echo "a" > /var/tmp/file
    level09@SnowCrash:~$ ./level09 /var/tmp/file
    /wcu3ysw7oswq
    level09@SnowCrash:~$ echo "b" > /var/tmp/file1
    level09@SnowCrash:~$ ./level09 /var/tmp/file1
    /wcu3ysw7oswq>
    level09@SnowCrash:~$ echo "abcdefghijklmnopqrstuwxyz" > /var/tmp/file3
    level09@SnowCrash:~$ ./level09 /var/tmp/file3
    /wcu3ysw7oswq@
    # We can also read the 'token' file
    level09@SnowCrash:~$ cat token
    f4kmm6p|=�p�n��DB�Du{��
    level09@SnowCrash:~$ ./level09 aa
    ab
    level09@SnowCrash:~$ ./level09 aaa
    abc
    level09@SnowCrash:~$ ./level09 aaaa
    abcd
    level09@SnowCrash:~$ ./level09 abaa
    accd
    level09@SnowCrash:~$ ./level09 abba
    acdd
    level09@SnowCrash:~$ ./level09 abbb
    acde
    ```

    **What transformation is applied and how to analyze it?**

    The binary iterates over each byte of the token and adds its position index (0, 1, 2, …).
    To recover the original value of each encrypted character, simply subtract the index:

    Using the transformation example “abba” → “acdd”:
    | i (index) | o[i] (original) | code(o[i]) | operation     | e[i] (result) | code(e[i]) | encrypted char |
    |-----------|-----------------|-------------|---------------|---------------|-------------|----------------|
    | 0         | 'a'             | 97          | 97 + 0 = 97   | 97            | 97          | 'a'            |
    | 1         | 'b'             | 98          | 98 + 1 = 99   | 99            | 99          | 'c'            |
    | 2         | 'b'             | 98          | 98 + 2 = 100  | 100           | 100         | 'd'            |
    | 3         | 'a'             | 97          | 97 + 3 = 100  | 100           | 100         | 'd'            |

    - **i**: position index in the string, starting at 0, then 1, 2, 3…
    - **o[i]**: ASCII code of the *original* character at position i.
    - **e[i]**: ASCII code of the *encrypted* character after the operation.
    - General encryption formula:
        e[i] = o[i] + i
    - To decrypt, invert the addition:
        o[i] = e[i] − i

    We use the file we created `decipher.c` and compile it on the machine:
    ```bash
    scp -P 4242 decipher level09@192.168.18.10:/tmp/decipher
    [...]
    level09@192.168.18.10 password:
    decipher  100%   16KB 552.8KB/s   00:00
    level09@SnowCrash:/tmp$ ls -l decipher.c
    -rw-r--r-- 1 level09 level09 366 May  7 18:01 decipher.c
    # -static to include all C libraries without depending on different glibc versions or others
    # -std=gnu99 to select the C99 standard
    level09@SnowCrash:/tmp$ gcc -static -std=gnu99 decipher.c -o decipher
    # Store the output of ./level09 token in a variable
    cipher=$(./level09 token)
    # Decrypt the string
    ./decipher "$cipher"
    # Example output:
    f3iji1ju5yuevaus41q1afiuq
    # Switch to the flag user
    su flag09
    Password:
    # Don't forget to run getflag!
    getflag
    # Retrieved flag:
    s5cAJpM8ev6XHw998pRWG728z
    ```
python /tmp/script.py `cat token`