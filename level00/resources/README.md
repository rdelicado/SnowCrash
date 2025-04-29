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

4. **Manual method**  
   We could also do it manually. Since all the characters are lowercase, we can use the `tr` command to apply a Caesar cipher shift of 11 (ROT11):

   ```bash
   echo "cdiiddwpgswtgt" | tr 'a-z' 'l-za-k'
   ```

   This command shifts each lowercase letter 11 positions forward in the alphabet, effectively decrypting the message. If the text contained both uppercase and lowercase letters, you could use:

   ```bash
   echo "YourTextHere" | tr 'a-zA-Z' 'l-za-kL-ZA-K'
   ```

   This way, you can quickly decrypt Caesar ciphers directly from the command line without writing a program.