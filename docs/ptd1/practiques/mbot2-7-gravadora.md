# Pràctica 7. El robot gravadora

Programaràs l'mBot2 perquè «aprengui» un recorregut: amb el joystick de CyberPi li indicaràs una seqüència de moviments, que es guardarà en una **llista**, i després el robot la reproduirà tota sola. És la idea de programar un robot industrial ensenyant-li els moviments.

| Fitxa de la pràctica | |
| --- | --- |
| **Dispositiu** | mBot2 amb CyberPi |
| **Eina** | [mBlock](https://mblock.cc/) (blocs o Python) |
| **Unitats relacionades** | 5 (bucles) i 7 (llistes) |
| **Nivells** | Tria'n un: 1, 2 o 3. Consulta la [presentació de les pràctiques](index.md) |

## Funcionament

| Control de CyberPi | Què fa |
| --- | --- |
| Joystick **amunt** | Grava «avançar 10 cm» |
| Joystick **esquerra** | Grava «girar 90° a l'esquerra» |
| Joystick **dreta** | Grava «girar 90° a la dreta» |
| Botó **A** | Reprodueix tota la seqüència gravada |
| Botó **B** | Esborra la seqüència |

Cada moviment es guarda a la llista com una lletra: `"F"` (endavant), `"E"` (esquerra) o `"D"` (dreta). Així, el recorregut en forma de L «endavant, endavant, dreta, endavant» es guarda com `["F", "F", "D", "F"]`.

## Pas 1. Gravar i reproduir

=== "Nivell 1. Blocs"

    1. Crea una **llista** anomenada `moviments` (a mBlock, a la categoria de **variables**).
    2. Dins un bloc **per sempre**, comprova cada control amb **si**: si el joystick va amunt, afegeix `F` a la llista, etc.
    3. Quan es premi A, recorre la llista amb un bucle **repeteix** tantes vegades com elements tengui, i per a cada element fes el moviment corresponent.
    4. Prova-ho i després obre la vista de **Python**.

=== "Nivell 2. Blocs → Python"

    Fes-ho amb blocs i continua les ampliacions a la vista **Python**.

=== "Nivell 3. Python directe"

    Necessitaràs `cyberpi.controller.is_press(...)` amb `"up"`, `"left"`, `"right"`, `"a"` i `"b"`; una llista amb `append()`; i `mbot2.straight(cm, velocitat)` i `mbot2.turn(graus, velocitat)` per moure't.

!!! warning "Una pulsació, un moviment"
    Mentre mantens el joystick amunt, el programa passa moltes vegades pel bucle i gravaria molts de moviments. Per evitar-ho, després de gravar un moviment, **espera que es deixi anar** el control:

    ```python
    while cyberpi.controller.is_press("up"):
        time.sleep(0.05)
    ```

??? success "Solució en Python"
    ```python
    import cyberpi, mbot2, time

    VELOCITAT = 50
    moviments = []

    cyberpi.console.println("Joystick: grava")
    cyberpi.console.println("A: reprodueix  B: esborra")

    while True:
        if cyberpi.controller.is_press("up"):
            moviments.append("F")
            cyberpi.console.println("Endavant (" + str(len(moviments)) + ")")
            while cyberpi.controller.is_press("up"):
                time.sleep(0.05)

        if cyberpi.controller.is_press("left"):
            moviments.append("E")
            cyberpi.console.println("Esquerra (" + str(len(moviments)) + ")")
            while cyberpi.controller.is_press("left"):
                time.sleep(0.05)

        if cyberpi.controller.is_press("right"):
            moviments.append("D")
            cyberpi.console.println("Dreta (" + str(len(moviments)) + ")")
            while cyberpi.controller.is_press("right"):
                time.sleep(0.05)

        if cyberpi.controller.is_press("a"):
            for moviment in moviments:
                if moviment == "F":
                    mbot2.straight(10, VELOCITAT)
                elif moviment == "E":
                    mbot2.turn(-90, VELOCITAT)
                    time.sleep(1)
                else:
                    mbot2.turn(90, VELOCITAT)
                    time.sleep(1)
            cyberpi.console.println("Fet!")
            while cyberpi.controller.is_press("a"):
                time.sleep(0.05)

        if cyberpi.controller.is_press("b"):
            moviments = []
            cyberpi.console.println("Esborrat")
            while cyberpi.controller.is_press("b"):
                time.sleep(0.05)
    ```

    - Els girs amb angle negatiu van cap a l'esquerra i els positius, cap a la dreta.
    - Segons la documentació consultada, `mbot2.turn()` no espera que el gir s'acabi abans de passar a la instrucció següent. Per això hi ha un `time.sleep(1)` després de cada gir: si el vostre robot encadena malament els moviments, ajusta aquesta pausa.

!!! question "Pregunta 7.1. Llista o variables?"
    Podries fer aquest programa sense una llista, amb variables separades (`moviment1`, `moviment2`…)? Quins problemes tindries?

    ??? success "Resposta"
        Hauries de decidir per endavant quants moviments es poden gravar (i crear una variable per a cadascun), i per reproduir-los hauries d'escriure un `if` per a cada variable. Amb una llista, el programa funciona igual amb 3 moviments que amb 300, i es recorre amb un sol bucle. És exactament l'avantatge dels arrays que vam veure a l'apartat 7.1.6.

## Pas 2. Ampliacions

!!! example "Ampliació 2.1. Desfer"
    Afegeix que el joystick **avall** esborri només el **darrer** moviment gravat, per poder corregir un error sense començar de nou. Pista: `pop()`.

    ??? success "Solució (el fragment que s'afegeix)"
        ```python
        if cyberpi.controller.is_press("down"):
            if len(moviments) > 0:
                moviments.pop()
                cyberpi.console.println("Desfet (" + str(len(moviments)) + ")")
            while cyberpi.controller.is_press("down"):
                time.sleep(0.05)
        ```

!!! example "Ampliació 2.2. Tornar a casa"
    Fes que, després de reproduir la seqüència, el robot **torni al punt de partida** fent el recorregut a l'inrevés. Pista: primer ha de girar 180°; després ha de recórrer la llista de darrere cap endavant, i els girs a l'esquerra es converteixen en girs a la dreta i a l'inrevés.

    ??? success "Solució (el fragment de tornada)"
        ```python
        mbot2.turn(180, VELOCITAT)
        time.sleep(2)
        for i in range(len(moviments) - 1, -1, -1):
            moviment = moviments[i]
            if moviment == "F":
                mbot2.straight(10, VELOCITAT)
            elif moviment == "E":
                mbot2.turn(90, VELOCITAT)     # a la tornada, esquerra passa a ser dreta
                time.sleep(1)
            else:
                mbot2.turn(-90, VELOCITAT)
                time.sleep(1)
        ```

!!! example "Ampliació 2.3. Moviments més compactes"
    Si graves deu vegades seguides «endavant», la llista té deu `"F"`. Fes una versió que guardi cada moviment amb la seva repetició, com una **llista de llistes**: `[["F", 10], ["D", 1], ["F", 3]]`. Quan es grava un moviment igual que l'anterior, només s'incrementa el comptador.

## Repte final

!!! example "Repte. Dibuixa la inicial"
    Enganxa un retolador a l'mBot2 de manera que pinti en un paper gran mentre es mou. Grava la seqüència de moviments necessària perquè dibuixi la inicial del teu nom. Hauràs de fer servir també girs de 45° per a les lletres amb diagonals: afegeix-ne els controls que calguin.

---

!!! quote "Font"
    Pràctica de creació pròpia. Les instruccions de Python per a l'mBot2 i CyberPi s'han contrastat amb la [referència de l'mBot2 en Python de lbotics.at](https://www.lbotics.at/mbot2/mbot2-mit-python/grundlagen/fahrfunktionen) i el [manual de Python per a mBot2 i CyberPi de Digital Technology](https://robocoast.tech/wp-content/uploads/2023/05/MakeBlock-mBot2-Python-Booklet-v4-1.pdf). El codi s'ha provat amb una simulació de les llibreries, no amb un robot real.
