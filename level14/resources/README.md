# Analysis and Exploitation of Level 14

## Vulnerability
Level 14 does not contain specific files to exploit. The solution requires directly manipulating the `/bin/getflag` binary, which is designed to display different flags depending on the UID of the user executing it.

## Discovery
1. Through analysis with GDB, we identified that `/bin/getflag` implements:
   - Anti-debugging protection (using ptrace)
   - UID checks to display different flags
   - A specific comparison with UID 3014 (0xBC6) for the level 14 flag

2. Examining the disassembly, we located the code that handles the response for each level:
   ```
   8048afd: call getuid@plt
   8048b02: mov %eax,0x18(%esp)       # Stores the UID
   8048b06: mov 0x18(%esp),%eax       # Retrieves it for comparison
   ...
   8048bb6: cmp $0xbc6,%eax           # Compares with 3014 (level 14)
   8048bbb: je 8048de5                # Jumps to print flag if it matches
   ```

## Exploitation

We located the memory address where the `call to getuid` occurs and modified the return value:
```bash
    level14@SnowCrash:~$ objdump -d /bin/getflag | grep -A3 "<getuid@plt>"
    [...]
    080484b0 <getuid@plt>:
    8048afd:       e8 ae f9 ff ff          call   80484b0 <getuid@plt>
    8048b02:       89 44 24 18             mov    %eax,0x18(%esp)  ; Critical point to modify
    [...]
``` 
Here is where the `cmp` of the `uid` occurs:
```bash
level14@SnowCrash:~$ objdump -d /bin/getflag | grep -B1 -A1 "cmp.*0xbc6"
 8048bb0:       0f 84 0e 02 00 00       je     8048dc4 <main+0x47e>
 8048bb6:       3d c6 0b 00 00          cmp    $0xbc6,%eax     ; UID check
 8048bbb:       0f 84 24 02 00 00       je     8048de5 <main+0x49f>
```

Using GDB:

1. Bypass anti-debugging protection:
   ```
   catch syscall ptrace
   commands
     set $eax = 0
     continue
   end
   ```

2. Modify the returned UID or jump directly to the flag code:
   ```
   break *0x8048b02
   run
   set $eax = 0xbc6
   continue
   Continuing.
   Check flag.Here is your token : 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
   ```

The flag is displayed by making the program believe we are the user with UID 3014.