# Pràctica 6. Registre de temperatures

Convertiràs la micro:bit en una petita estació de registre: guardarà en una **llista** les temperatures que mesuri i en calcularà la mitjana, la màxima i la mínima. És la base de qualsevol sistema de monitoratge, des d'una estació meteorològica fins al control de temperatura d'un hivernacle.

| Fitxa de la pràctica | |
| --- | --- |
| **Dispositiu** | micro:bit (o el simulador de MakeCode) |
| **Eines** | [MakeCode](https://makecode.microbit.org/) (nivells 1 i 2) · [Editor de Python de la micro:bit](https://python.microbit.org/) (nivell 3 i ampliacions) |
| **Unitats relacionades** | 5 (bucles, acumuladors) i 7 (llistes i taules) |
| **Nivells** | Tria'n un: 1, 2 o 3. Consulta la [presentació de les pràctiques](index.md) |

!!! info "Quina temperatura mesura?"
    La micro:bit no té un termòmetre independent: fa servir un sensor de dins el processador. Per això dona una **aproximació** de la temperatura ambient, en graus Celsius i sense decimals, que pot ser uns quants graus més alta que la real. Per a aquesta pràctica és suficient.

## Pas 1. Guardar i resumir

La placa ha de funcionar així:

- **Botó A**: mesura la temperatura, l'afegeix a la llista i la mostra.
- **Botó B**: mostra la mitjana, la màxima i la mínima de totes les mesures. Si encara no n'hi ha cap, mostra un avís.

=== "Nivell 1. Blocs"

    1. A **on start**, crea una variable `temperatures` i dona-li com a valor una **llista buida** (categoria **Arrays**).
    2. Amb **on button A pressed**, afegeix al final de la llista el valor del bloc **temperature** (categoria **Input**) i mostra'l.
    3. Amb **on button B pressed**, recorre la llista amb un bucle per calcular la suma, la màxima i la mínima, i mostra els resultats.
    4. Al simulador, pots canviar la temperatura amb el termòmetre que apareix al costat de la placa.
    5. Canvia a la vista **Python** i observa com es tradueixen els blocs de llistes.

=== "Nivell 2. Blocs → Python"

    Fes-ho amb blocs i continua les ampliacions a l'Editor de Python.

=== "Nivell 3. Python directe"

    A l'Editor de Python, `temperature()` retorna la temperatura. Pots fer servir `append()`, `sum()`, `max()`, `min()` i `len()`, com a la unitat 7.

??? success "Solució a l'Editor de Python"
    ```python
    from microbit import *

    temperatures = []

    while True:
        if button_a.was_pressed():
            t = temperature()
            temperatures.append(t)
            display.scroll(str(t))

        if button_b.was_pressed():
            if len(temperatures) == 0:
                display.scroll("CAP MESURA")
            else:
                mitjana = sum(temperatures) / len(temperatures)
                display.scroll("MITJ " + str(round(mitjana, 1)))
                display.scroll("MAX " + str(max(temperatures)))
                display.scroll("MIN " + str(min(temperatures)))
        sleep(100)
    ```

    Comprovar `len(temperatures) == 0` abans de calcular la mitjana evita un error de divisió entre zero.

!!! question "Pregunta 6.1. Sense `max()` ni `min()`"
    Com calcularies la màxima i la mínima sense aquestes funcions, com a l'exercici 7.4?

    ??? success "Resposta"
        Es recorre la llista amb un bucle i es compara cada valor amb el màxim i el mínim trobats fins aleshores:

        ```python
        maxima = temperatures[0]
        minima = temperatures[0]
        for t in temperatures:
            if t > maxima:
                maxima = t
            if t < minima:
                minima = t
        ```

## Pas 2. Ampliacions

!!! example "Ampliació 2.1. Registre automàtic"
    En lloc de mesurar en prémer A, fes que la placa mesuri **automàticament** cada 10 segons. Pista: `running_time()` retorna els mil·lisegons que han passat des que s'ha engegat la placa. Guarda en una variable el moment de la darrera mesura.

    ??? success "Solució a l'Editor de Python"
        ```python
        from microbit import *

        INTERVAL = 10000   # en mil·lisegons
        temperatures = []
        darrera = running_time()

        while True:
            if running_time() - darrera >= INTERVAL:
                temperatures.append(temperature())
                darrera = running_time()
                display.show(".")
                sleep(200)
                display.clear()

            if button_b.was_pressed() and len(temperatures) > 0:
                display.scroll("N " + str(len(temperatures)))
                display.scroll("MITJ " + str(round(sum(temperatures) / len(temperatures), 1)))
            sleep(100)
        ```

        Per què no fer simplement `sleep(10000)` entre mesura i mesura? Perquè durant aquests 10 segons la placa no respondria als botons.

!!! example "Ampliació 2.2. Memòria limitada"
    Una placa té poca memòria. Fes que la llista guardi com a màxim les **20 darreres** mesures: quan n'arribi una de nova i ja n'hi hagi 20, s'ha d'eliminar la més antiga.

    ??? success "Solució (el fragment que canvia)"
        ```python
        MAXIM = 20
        # ...
        temperatures.append(temperature())
        if len(temperatures) > MAXIM:
            temperatures.pop(0)   # elimina la més antiga, que és la primera
        ```

!!! example "Ampliació 2.3. Gràfic a la pantalla"
    La pantalla de la micro:bit és una **taula de 5 × 5 LED**: cada LED s'identifica per la columna `x` (de 0 a 4) i la fila `y` (de 0 a 4, amb el 0 a dalt). Amb el botó A+B, dibuixa un gràfic de barres amb les **5 darreres** mesures: una columna per mesura, més alta com més calor. Fes servir `display.set_pixel(x, y, 9)` per encendre un LED.

    ??? success "Solució a l'Editor de Python"
        ```python
        from microbit import *

        temperatures = [18, 21, 25, 23, 20, 27, 22]   # dades d'exemple per provar

        TEMP_MINIMA = 15   # temperatura que correspon a la barra buida
        TEMP_MAXIMA = 30   # temperatura que correspon a la barra plena

        while True:
            if button_a.is_pressed() and button_b.is_pressed():
                display.clear()
                ultimes = temperatures[-5:]
                for x in range(len(ultimes)):
                    # Converteix la temperatura en una altura de 0 a 5 LED
                    altura = (ultimes[x] - TEMP_MINIMA) * 5 // (TEMP_MAXIMA - TEMP_MINIMA)
                    altura = max(0, min(5, altura))
                    for y in range(5 - altura, 5):
                        display.set_pixel(x, y, 9)
                sleep(3000)
            sleep(100)
        ```

        `temperatures[-5:]` és una llesca amb els 5 darrers elements. La fórmula de l'altura fa una **regla de tres**: 15 °C o menys és una barra buida i 30 °C o més, una barra plena. Com que la fila 0 és la de dalt, una barra d'altura 3 encén les files 2, 3 i 4.

## Repte final

!!! example "Repte. Estació de l'aula"
    Col·locau diverses micro:bit en diferents llocs de l'aula (a prop de la finestra, de la porta, del radiador…). Cada una envia la seva temperatura per ràdio cada minut, amb un identificador (`"F:23"`, `"P:21"`…), a una micro:bit central que guarda les dades en una **taula** (una llista per a cada lloc) i mostra quin és el lloc més calent. A PTD II aprendreu a guardar aquestes dades en fitxers CSV i analitzar-les a l'ordinador.

---

!!! quote "Font"
    Pràctica de creació pròpia. Les instruccions de MicroPython segueixen la [documentació oficial de MicroPython per a micro:bit](https://microbit-micropython.readthedocs.io/en/latest/).
