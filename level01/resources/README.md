# SnowCrash

## Level 01 - Flag retrieval process

1. **Search for files accessible by flag01**

   First, I tried to search for files in the system owned by the user `flag01` using the `find` command, but I did not find anything relevant:

   ```bash
   find / -user flag01 2>/dev/null
   ```

2. **Check the `/etc/passwd` file**

   Next, I checked the `/etc/passwd` file to see if I could find any useful information about the user `flag01`. There, I noticed that the entry for `flag01` had what appeared to be an encrypted password:

   ```
   flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
   ```

   The second field (`42hDRfypTqqnw`) corresponds to the encrypted password for `flag01`.

3. **Crack the password with John the Ripper**

   In the previous level, the `john` file suggested that John the Ripper might be useful, but `/usr/sbin/john` turned out to be just a text file:

   ```bash
   file /usr/sbin/john
   /usr/sbin/john: ASCII text
   ```

   Therefore, I used the external John the Ripper program to try to crack the password. I saved the relevant line from `/etc/passwd` in a file called `hash.txt` and ran:

   ```bash
   john hash.txt
   ```

   John the Ripper quickly found the password. The result was:

   ```
   abcdefg          (flag01)
   ```

   This indicates that the password for `flag01` is `abcdefg`.

   Then, I used this password to switch to the `flag01` user:

   ```bash
   su flag01
   ```

   I entered the password `abcdefg` and logged in successfully. Finally, I executed the `getflag` command to obtain the token:

   ```bash
   getflag
   ```

   The system responded with:

   ```
   Check flag.Here is your token : f2av5il02puano7naaf6adaaf
   ```

---
