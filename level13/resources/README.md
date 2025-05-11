1. **File Search**

    - The binary is `SUID` of `flag13`.
    - When executed, it displays:
    - `UID 2013 started us but we we expect 4242`
    - Even if you pass `4242` as an argument, it still shows the same message.
    - In the strings, the following appear:
        - `UID %d started us but we we expect %d`
        and
        - `your token is %s`
    - Functions like `getuid`, `strdup`, `printf` also appear.
    We need to change the UID in some way.

2. **Exploitation**

    Disassembling with `gdb` we can see how it calls the `getuid` function and compares it with 4242.
    ```asm
    [...]
    0x08048595 <+9>:     call   0x8048380 <getuid@plt>
    0x0804859a <+14>:    cmp    $0x1092,%eax ; 0x1092=4242
    [...]
    If we change the return value in the `eax` register to `uid=4242` we could get the token.
    ```asm
    (gdb) break getuid
    Breakpoint 1 at 0x8048380
    (gdb) run
    Starting program: /home/user/level13/level13 

    Breakpoint 1, 0xb7ee4cc0 in getuid () from /lib/i386-linux-gnu/libc.so.6
    (gdb) step
    Single stepping until exit from function getuid,
    which has no line number information.
    0x0804859a in main ()
    (gdb) print $eax
    $1 = 2013
    (gdb) set $eax=4242
    (gdb) print $eax
    $2 = 4242
    (gdb) step
    Single stepping until exit from function main,
    which has no line number information.
    your token is 2A31L79asukciNyi8uppkEuSx
    0xb7e454d3 in __libc_start_main () from /lib/i386-linux-gnu/libc.so.6
    (gdb)
    ```

