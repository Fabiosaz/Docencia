# Pràctica 3. Esquivar obstacles

Programaràs l'mBot2 perquè avanci sol per l'aula i, quan detecti un obstacle a davant, s'aturi i giri per evitar-lo. És el mateix principi que fan servir els robots aspiradors i els sensors d'aparcament dels cotxes.

| Fitxa de la pràctica | |
| --- | --- |
| **Dispositiu** | mBot2 amb CyberPi i sensor d'ultrasons 2 |
| **Eina** | [mBlock](https://mblock.cc/) (blocs o Python) |
| **Unitats relacionades** | 4 (condicionals) i 5 (bucles) |
| **Nivells** | Tria'n un: 1, 2 o 3. Consulta la [presentació de les pràctiques](index.md) |

!!! warning "Abans de començar"
    - Treballa a terra o en una taula gran amb vores protegides: el robot pot caure.
    - Posa sempre una manera d'engegar el programa amb un botó, perquè el robot no surti disparat quan el carreguis.
    - Mentre proves, tingues la mà a prop per aturar-lo.

## Com funciona el sensor d'ultrasons

El sensor d'ultrasons (els dos «ulls» de la part davantera) envia un so que les persones no sentim i mesura quant de temps tarda a tornar després de rebotar en un obstacle. Amb aquest temps calcula la **distància en centímetres**. Dona valors entre 3 i 300 cm aproximadament.

En Python, la distància es llegeix amb `mbuild.ultrasonic2.get()`.

## Pas 0. L'algorisme

Dibuixa el diagrama de flux: el robot espera que es premi el botó A; després, repeteix contínuament: llegir la distància; si és menor que 15 cm, aturar-se i girar; si no, avançar.

??? success "Un diagrama possible"
    ```mermaid
    flowchart TD
        A([Inici]) --> B{S'ha premut A?}
        B -- No --> B
        B -- Sí --> C[/"Llegir distància"/]
        C --> D{distància < 15?}
        D -- Sí --> E[Aturar-se i girar 90°]
        D -- No --> F[Avançar]
        E --> C
        F --> C
    ```

## Pas 1. El robot que esquiva

=== "Nivell 1. Blocs"

    1. A mBlock, connecta l'mBot2 i comprova que tens afegides les extensions del **xassís de l'mBot2** i del **sensor d'ultrasons 2**.
    2. Comença el programa amb el bloc que s'executa **en prémer el botó A** de CyberPi.
    3. A dins, posa un bloc **per sempre** amb un **si … si no** que comprovi si la **distància del sensor d'ultrasons** és menor que 15.
    4. Si ho és: **atura els motors** i **gira 90°**. Si no: **avança** a velocitat 50.
    5. Carrega el programa al robot i prova'l. Després obre la vista de **Python**.

    El nom exacte dels blocs depèn de la versió i de l'idioma de mBlock.

=== "Nivell 2. Blocs → Python"

    Fes el programa amb blocs, passa a la vista **Python** i fes-hi les ampliacions escrivint codi.

=== "Nivell 3. Python directe"

    Escriu el programa en Python a mBlock. Necessitaràs:

    - `import cyberpi, mbot2, mbuild`
    - `cyberpi.controller.is_press("a")` per saber si s'ha premut el botó A.
    - `mbuild.ultrasonic2.get()` per llegir la distància.
    - `mbot2.forward(velocitat)` per avançar, `mbot2.EM_stop()` per aturar-se i `mbot2.turn(graus, velocitat)` per girar.

??? success "Solució en Python"
    ```python
    import cyberpi, mbot2, mbuild

    DISTANCIA_MINIMA = 15   # en cm
    VELOCITAT = 50          # en rpm

    cyberpi.console.println("Prem A per començar")
    while not cyberpi.controller.is_press("a"):
        pass

    while True:
        distancia = mbuild.ultrasonic2.get()
        if distancia < DISTANCIA_MINIMA:
            mbot2.EM_stop()
            mbot2.turn(90, VELOCITAT)
        else:
            mbot2.forward(VELOCITAT)
    ```

    - `while not cyberpi.controller.is_press("a"): pass` espera fins que es premi A. La instrucció `pass` vol dir «no facis res»: el bucle només serveix per esperar.
    - Les velocitats es donen en **rpm** (voltes per minut de les rodes). Els girs, en **graus**: un angle positiu gira cap a la dreta i un de negatiu, cap a l'esquerra.

!!! question "Pregunta 3.1. Què passa si…"
    1. …poses `DISTANCIA_MINIMA = 3`?
    2. …el robot va molt ràpid (per exemple, 150 rpm)?
    3. …l'obstacle és una cortina o un jersei?

    ??? success "Resposta"
        1. El robot s'acosta tant que pot xocar abans d'aturar-se: el sensor no mesura bé per sota d'uns 3 cm i el robot necessita una mica d'espai per frenar.
        2. Recorre més distància entre una lectura i la següent, i també pot arribar a xocar. Com més velocitat, més gran ha de ser la distància mínima.
        3. Els materials tous absorbeixen el so en lloc de reflectir-lo, de manera que el sensor pot no detectar-los o donar valors incorrectes. És una limitació real dels sensors d'ultrasons.

## Pas 2. Ampliacions

!!! example "Ampliació 2.1. Semàfor de distància"
    Fes que els LED de CyberPi indiquin la distància a l'obstacle: **verd** si és més gran de 40 cm, **groc** entre 15 i 40 cm i **vermell** si és menor de 15 cm. Mostra també la distància a la pantalla.

    ??? success "Solució en Python"
        ```python
        import cyberpi, mbot2, mbuild

        while not cyberpi.controller.is_press("a"):
            pass

        while True:
            distancia = mbuild.ultrasonic2.get()
            cyberpi.display.show_label(str(round(distancia)) + " cm", 24, "center")

            if distancia < 15:
                cyberpi.led.on(255, 0, 0)        # vermell
                mbot2.EM_stop()
                mbot2.turn(90, 50)
            elif distancia < 40:
                cyberpi.led.on(255, 200, 0)      # groc
                mbot2.forward(30)                # més a poc a poc
            else:
                cyberpi.led.on(0, 255, 0)        # verd
                mbot2.forward(50)
        ```

        `cyberpi.led.on(vermell, verd, blau)` encén els LED amb un color RGB, amb valors de 0 a 255. De passada, el robot frena quan s'acosta a un obstacle.

!!! example "Ampliació 2.2. Gir a l'atzar"
    Perquè el robot no quedi atrapat fent sempre el mateix recorregut, fes que, en trobar un obstacle, giri cap a la dreta o cap a l'esquerra a l'atzar, i un angle a l'atzar entre 90 i 180 graus.

    ??? success "Solució en Python (només el bloc de l'obstacle)"
        ```python
        import random
        # ...
        if distancia < 15:
            mbot2.EM_stop()
            angle = random.randint(90, 180)
            if random.randint(0, 1) == 0:
                angle = -angle          # esquerra
            mbot2.turn(angle, 50)
        ```

!!! example "Ampliació 2.3. Comptador d'obstacles"
    Compta quants obstacles ha esquivat el robot i mostra el nombre a la pantalla. Quan n'hagi esquivat 10, s'ha d'aturar i fer sonar un so.

    ??? success "Solució en Python"
        ```python
        import cyberpi, mbot2, mbuild

        obstacles = 0

        while not cyberpi.controller.is_press("a"):
            pass

        while obstacles < 10:
            if mbuild.ultrasonic2.get() < 15:
                mbot2.EM_stop()
                obstacles += 1
                cyberpi.display.show_label(str(obstacles), 32, "center")
                mbot2.turn(90, 50)
            else:
                mbot2.forward(50)

        mbot2.EM_stop()
        cyberpi.audio.play("hello")
        ```

        La condició del `while` fa que el bucle s'acabi sol quan arriba als 10 obstacles.

## Repte final

!!! example "Repte. Sortir del laberint"
    Construïu un laberint senzill amb capses o llibres. Programa el robot perquè en surti. Una estratègia clàssica és la de **seguir sempre la paret de la dreta**: si pot girar a la dreta, gira; si no, avança; si tampoc pot, gira a l'esquerra. Per fer-ho amb un sol sensor frontal, hauràs de fer girar el robot per «mirar» a cada costat abans de decidir. No hi ha una única solució: prova, mesura i millora.

---

!!! quote "Font"
    Pràctica de creació pròpia. Les instruccions de Python per a l'mBot2 i CyberPi s'han contrastat amb la [referència de l'mBot2 en Python de lbotics.at](https://www.lbotics.at/mbot2/mbot2-mit-python/grundlagen/fahrfunktionen) i el [manual de Python per a mBot2 i CyberPi de Digital Technology](https://robocoast.tech/wp-content/uploads/2023/05/MakeBlock-mBot2-Python-Booklet-v4-1.pdf). El codi s'ha provat amb una simulació de les llibreries, no amb un robot real: si alguna instrucció no funciona a la vostra versió de mBlock, comproveu-la amb la vista de Python que genera mBlock a partir dels blocs.
