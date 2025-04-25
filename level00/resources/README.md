1. **Find the binary `john`**

   I ran the following command to search for files associated with the user `flag00`:

   ```bash
   find / -user flag00 -exec ls -ld {} \; 2>/dev/null
    ----r--r-- 1 flag00 flag00 15 Mar  5  2016 /usr/sbin/john
    ----r--r-- 1 flag00 flag00 15 Mar  5  2016 /rofs/usr/sbin/john
    ```
    The command showed two read-only files named john located at `/usr/sbin/john` and `/rofs/usr/sbin/john`.

2. **Decrypting the message**

    Then, I noticed that the john file contained an encrypted message with the following text:

    ```bash
    cat /usr/sbin/john
    cdiiddwpgswtgt
    ```

3. **Caesar Cipher**

    I assumed it was a Caesar cipher like ROT13. After trying and seeing that it didn't work, I created a program `cesar.c` that would show me all ROTs from 0 to 25, and tried each one until I found the one that worked:
    ```bash
    ./cesar cdiiddwpgswtgt
    [...]
    rot 11 -> nottoohardhere
    [...]
    ```