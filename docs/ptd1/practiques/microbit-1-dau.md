# Pràctica 1. El dau electrònic

Programaràs la micro:bit perquè funcioni com un dau: quan la sacsegis, mostrarà un nombre a l'atzar de l'1 al 6. Després l'ampliaràs perquè compti les tirades, dibuixi les cares del dau i guardi estadístiques.

| Fitxa de la pràctica | |
| --- | --- |
| **Dispositiu** | micro:bit (o el simulador de MakeCode) |
| **Eines** | [MakeCode](https://makecode.microbit.org/) (nivells 1 i 2) · [Editor de Python de la micro:bit](https://python.microbit.org/) (nivell 3) |
| **Unitats relacionades** | 1 (algorismes), 3 (variables), 4 (condicionals) i 7 (llistes, a l'ampliació final) |
| **Nivells** | Tria'n un: 1, 2 o 3. Consulta la [presentació de les pràctiques](index.md) |

## Pas 0. Abans de programar: l'algorisme

Com vam veure a la unitat 1, abans d'escriure codi cal pensar l'algorisme. Dibuixa el **diagrama de flux** del dau bàsic: què passa quan s'engega la placa, què espera i què fa quan detecta que l'has sacsejat.

??? success "Un diagrama possible"
    ```mermaid
    flowchart TD
        A([Inici]) --> B{S'ha sacsejat?}
        B -- No --> B
        B -- Sí --> C["valor ← nombre a l'atzar de l'1 al 6"]
        C --> D[/Mostrar valor/]
        D --> B
    ```

    Fixa't que el programa no té final: la placa espera sacsejades mentre té corrent.

## Pas 1. El dau bàsic

=== "Nivell 1. Blocs"

    1. Obre [MakeCode](https://makecode.microbit.org/) i crea un projecte nou.
    2. De la categoria **Input**, arrossega el bloc **on shake** («en sacsejar»).
    3. De la categoria **Basic**, posa-hi a dins el bloc **show number**.
    4. De la categoria **Math**, posa el bloc **pick random 0 to 10** dins el forat del nombre i canvia'l perquè triï de l'1 al 6.
    5. Prova-ho al simulador amb el botó **SHAKE**.
    6. Ara prem el botó **Python** de la part superior i observa el codi que ha generat MakeCode.

    El nom exacte dels blocs depèn de l'idioma de l'editor.

=== "Nivell 2. Blocs → Python"

    Fes les passes del nivell 1 i, un cop funcioni, canvia a la vista **Python**. Les ampliacions del pas 2 les faràs escrivint directament en aquesta vista.

=== "Nivell 3. Python directe"

    Obre l'[Editor de Python de la micro:bit](https://python.microbit.org/) i escriu el programa des de zero. Necessitaràs:

    - `from microbit import *` a la primera línia, per fer servir la placa.
    - `import random` per als nombres a l'atzar.
    - Un bucle `while True` que comprovi contínuament si s'ha sacsejat la placa: `accelerometer.was_gesture("shake")`.
    - `display.show(valor)` per mostrar el nombre.

!!! question "Pregunta 1.1. Llegeix el codi"
    Aquest és el codi que genera MakeCode en passar el dau bàsic a Python:

    ```python
    def on_gesture_shake():
        basic.show_number(randint(1, 6))
    input.on_gesture(Gesture.SHAKE, on_gesture_shake)
    ```

    1. Quina línia correspon a cada bloc?
    2. Per què la segona línia està sagnada?
    3. En què s'assemblen i en què es diferencien `randint(1, 6)` i el `random.randint(1, 6)` que fem servir a VS Code?

    ??? success "Resposta"
        1. La línia `input.on_gesture(...)` correspon al bloc **on shake**: indica que, quan es detecti una sacsejada, s'ha d'executar la funció `on_gesture_shake`. La línia `basic.show_number(...)` correspon a **show number**, i `randint(1, 6)` a **pick random**.
        2. Perquè forma part del bloc de codi que s'executa en sacsejar, igual que les instruccions de dins un `if` o un `for`.
        3. Fan el mateix: retornen un enter a l'atzar entre 1 i 6, tots dos inclosos. La diferència és que a MakeCode `randint` es pot fer servir directament, mentre que en Python normal cal `import random` i escriure `random.randint`.

??? success "Solució del nivell 3"
    ```python
    from microbit import *
    import random

    while True:
        if accelerometer.was_gesture("shake"):
            valor = random.randint(1, 6)
            display.show(valor)
        sleep(100)
    ```

    `sleep(100)` fa una petita pausa de 100 mil·lisegons a cada volta del bucle, perquè la placa no treballi innecessàriament.

## Pas 2. Ampliacions

Fes les ampliacions al teu nivell: amb blocs (nivell 1) o en Python (nivells 2 i 3).

!!! example "Ampliació 2.1. Comptador de tirades"
    Afegeix una variable que compti quantes vegades s'ha tirat el dau. Quan es premi el botó A, la placa ha de mostrar el nombre de tirades.

    ??? success "Solució a MakeCode (Python)"
        ```python
        tirades = 0

        def on_gesture_shake():
            global tirades
            tirades += 1
            basic.show_number(randint(1, 6))
        input.on_gesture(Gesture.SHAKE, on_gesture_shake)

        def on_button_pressed_a():
            basic.show_number(tirades)
        input.on_button_pressed(Button.A, on_button_pressed_a)
        ```

        Com que `tirades` es modifica dins la funció de l'esdeveniment, cal escriure `global tirades`. Amb blocs, fes servir la categoria **Variables** (**set** i **change by**) i el bloc **on button A pressed** d'**Input**.

    ??? success "Solució a l'Editor de Python"
        ```python
        from microbit import *
        import random

        tirades = 0
        while True:
            if accelerometer.was_gesture("shake"):
                tirades += 1
                display.show(random.randint(1, 6))
            if button_a.was_pressed():
                display.scroll(str(tirades))
            sleep(100)
        ```

!!! example "Ampliació 2.2. Les cares del dau"
    En lloc del número, fes que la pantalla dibuixi els punts de la cara del dau. Guarda el nombre a l'atzar en una variable i fes servir `if` … `elif` … `else` per dibuixar una cara diferent per a cada valor.

    ??? success "Solució a MakeCode (Python), amb les tres primeres cares"
        ```python
        def on_gesture_shake():
            valor = randint(1, 6)
            if valor == 1:
                basic.show_leds("""
                    . . . . .
                    . . . . .
                    . . # . .
                    . . . . .
                    . . . . .
                    """)
            elif valor == 2:
                basic.show_leds("""
                    # . . . .
                    . . . . .
                    . . . . .
                    . . . . .
                    . . . . #
                    """)
            elif valor == 3:
                basic.show_leds("""
                    # . . . .
                    . . . . .
                    . . # . .
                    . . . . .
                    . . . . #
                    """)
            else:
                basic.show_number(valor)   # completa tu les cares 4, 5 i 6
        input.on_gesture(Gesture.SHAKE, on_gesture_shake)
        ```

        Cada línia de `show_leds` és una fila de la pantalla: `#` vol dir LED encès i `.`, apagat. Amb blocs, fes servir **if … else if … else** de la categoria **Logic** i el bloc **show leds** de **Basic**.

    ??? success "Solució a l'Editor de Python, amb les tres primeres cares"
        ```python
        from microbit import *
        import random

        while True:
            if accelerometer.was_gesture("shake"):
                valor = random.randint(1, 6)
                if valor == 1:
                    display.show(Image("00000:00000:00900:00000:00000"))
                elif valor == 2:
                    display.show(Image("90000:00000:00000:00000:00009"))
                elif valor == 3:
                    display.show(Image("90000:00000:00900:00000:00009"))
                else:
                    display.show(valor)   # completa tu les cares 4, 5 i 6
            sleep(100)
        ```

        A MicroPython, cada fila de la imatge són cinc xifres separades per `:`. Cada xifra és la brillantor del LED, de 0 (apagat) a 9 (màxima).

!!! example "Ampliació 2.3. És just, el dau? (unitat 7)"
    Comprova si el dau surt equilibrat: guarda en una **llista de 6 comptadors** quantes vegades surt cada valor. Quan es premi el botó B, mostra el valor que ha sortit més vegades. Tira el dau moltes vegades: tots els valors surten més o menys igual?

    ??? success "Solució a l'Editor de Python"
        ```python
        from microbit import *
        import random

        vegades = [0, 0, 0, 0, 0, 0]   # vegades[0] compta els 1; vegades[5], els 6

        while True:
            if accelerometer.was_gesture("shake"):
                valor = random.randint(1, 6)
                vegades[valor - 1] += 1
                display.show(valor)
            if button_b.was_pressed():
                mes_frequent = vegades.index(max(vegades)) + 1
                display.scroll(str(mes_frequent))
            sleep(100)
        ```

        La posició de cada comptador és el valor menys 1, perquè els índexs de les llistes comencen a 0. Si hi ha un empat, `index()` retorna el primer valor que el té.

## Repte final

!!! example "Repte. Dos jugadors"
    Programa un joc per a dos jugadors amb una sola placa: el botó A tira el dau del jugador 1 i el botó B, el del jugador 2. Després de cada ronda, la placa mostra qui ha guanyat (`1`, `2` o `=` si hi ha empat). El primer que guanyi 3 rondes guanya la partida. Pots fer-ho a qualsevol nivell.

    ??? success "Una solució a l'Editor de Python"
        ```python
        from microbit import *
        import random

        punts1 = 0
        punts2 = 0

        while punts1 < 3 and punts2 < 3:
            display.show("A")
            while not button_a.was_pressed():
                sleep(50)
            dau1 = random.randint(1, 6)
            display.show(dau1)
            sleep(1000)

            display.show("B")
            while not button_b.was_pressed():
                sleep(50)
            dau2 = random.randint(1, 6)
            display.show(dau2)
            sleep(1000)

            if dau1 > dau2:
                punts1 += 1
                display.show("1")
            elif dau2 > dau1:
                punts2 += 1
                display.show("2")
            else:
                display.show("=")
            sleep(1000)

        if punts1 == 3:
            display.scroll("GUANYA 1")
        else:
            display.scroll("GUANYA 2")
        ```

        Els bucles `while not button_a.was_pressed()` fan que el programa esperi fins que es premi el botó.

---

!!! quote "Font"
    Pràctica de creació pròpia. El dau bàsic segueix el projecte [«Dice»](https://makecode.microbit.org/projects/dice) de la documentació de MakeCode. Les instruccions de MicroPython segueixen la [documentació oficial de MicroPython per a micro:bit](https://microbit-micropython.readthedocs.io/en/latest/accelerometer.html). El codi Python que genera MakeCode pot variar lleugerament segons la versió de l'editor.
