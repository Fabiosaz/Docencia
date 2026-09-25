# Pràctica 2. Detector de dia i nit

La micro:bit pot mesurar la llum que li arriba fent servir els mateixos LED de la pantalla com a sensor. Programaràs un detector que mostri un sol quan hi hagi claror i una lluna quan sigui fosc, com els sensors que encenen automàticament els fanals o els llums del cotxe.

| Fitxa de la pràctica | |
| --- | --- |
| **Dispositiu** | micro:bit (o el simulador de MakeCode) |
| **Eines** | [MakeCode](https://makecode.microbit.org/) (nivells 1 i 2) · [Editor de Python de la micro:bit](https://python.microbit.org/) (nivell 3) |
| **Unitats relacionades** | 4 (condicionals) i 5 (bucles) |
| **Nivells** | Tria'n un: 1, 2 o 3. Consulta la [presentació de les pràctiques](index.md) |

## Pas 0. Explora el sensor

Abans de decidir quan és «de nit», has de saber quins valors dona el sensor. El nivell de llum és un nombre de **0** (fosc total) a **255** (molta llum).

- A **MakeCode**, fes un programa que mostri contínuament el valor del bloc **light level** (categoria **Input**). Al simulador, el valor es canvia arrossegant el cercle groc de la placa.
- A l'**Editor de Python**, mostra el valor de `display.read_light_level()`.

Apunta el valor que dona el sensor a l'aula amb el llum encès, a prop d'una finestra i tapant la placa amb la mà. Tria un **llindar**: el valor a partir del qual consideraràs que és de dia.

## Pas 1. El detector bàsic

=== "Nivell 1. Blocs"

    1. Fes servir el bloc **forever** («per sempre», categoria **Basic**): el que hi posis dins es repetirà contínuament.
    2. A dins, posa un **if … else** (categoria **Logic**) amb la condició **light level < llindar**.
    3. Si la condició es compleix, dibuixa una lluna amb **show leds**; si no, un sol.
    4. Prova-ho al simulador i després canvia a la vista **Python**.

=== "Nivell 2. Blocs → Python"

    Fes el detector amb blocs, passa a la vista **Python** i fes-hi les ampliacions escrivint codi.

=== "Nivell 3. Python directe"

    A l'Editor de Python necessitaràs un bucle `while True`, `display.read_light_level()` i `display.show()` amb una `Image` per a cada dibuix.

??? success "Solució a MakeCode (Python)"
    ```python
    LLINDAR = 50

    def on_forever():
        if input.light_level() < LLINDAR:
            basic.show_leds("""
                . . # # .
                . # # . .
                . # # . .
                . # # . .
                . . # # .
                """)
        else:
            basic.show_leds("""
                # . # . #
                . # # # .
                # # # # #
                . # # # .
                # . # . #
                """)
    basic.forever(on_forever)
    ```

    El bloc **forever** es converteix en una funció que MakeCode executa una vegada i una altra, com un `while True`.

??? success "Solució a l'Editor de Python"
    ```python
    from microbit import *

    LLINDAR = 50
    LLUNA = Image("00990:09900:09900:09900:00990")
    SOL = Image("90909:09990:99999:09990:90909")

    while True:
        if display.read_light_level() < LLINDAR:
            display.show(LLUNA)
        else:
            display.show(SOL)
        sleep(500)
    ```

    Fixa't que el llindar és una **constant amb nom**, com vam veure a la unitat 9: si canvia l'aula, només cal modificar-lo en un lloc.

!!! question "Pregunta 2.1. Per què el llindar?"
    Per què és millor escriure `LLINDAR = 50` al principi que posar el 50 directament dins la condició?

    ??? success "Resposta"
        Perquè el nom explica què significa el nombre i perquè, si cal ajustar-lo (una aula més fosca, un altre sensor), es canvia en un sol lloc. És el que a la unitat 9 anomenàvem evitar els «nombres màgics».

## Pas 2. Ampliacions

!!! example "Ampliació 2.1. Tres nivells de llum"
    Distingeix tres situacions amb `if` … `elif` … `else`: **fosc** (lluna), **penombra** (un altre dibuix que triïs tu) i **clar** (sol). Hauràs de triar dos llindars.

    ??? success "Solució a l'Editor de Python"
        ```python
        from microbit import *

        FOSC = 30
        CLAR = 120
        LLUNA = Image("00990:09900:09900:09900:00990")
        NUVOL = Image("00000:09990:99999:99999:00000")
        SOL = Image("90909:09990:99999:09990:90909")

        while True:
            llum = display.read_light_level()
            if llum < FOSC:
                display.show(LLUNA)
            elif llum < CLAR:
                display.show(NUVOL)
            else:
                display.show(SOL)
            sleep(500)
        ```

        L'ordre de les condicions importa, com vam veure a l'apartat 4.4: primer es comprova el cas més fosc.

!!! example "Ampliació 2.2. Fanal automàtic amb memòria"
    Afegeix un comptador que sumi 1 cada vegada que el detector passa **de dia a nit** (no cada vegada que es comprova que és de nit). En prémer el botó A, la placa mostra quantes vegades s'ha fet de nit. Pista: necessites una variable que recordi l'estat anterior.

    ??? success "Solució a l'Editor de Python"
        ```python
        from microbit import *

        LLINDAR = 50
        nits = 0
        era_de_nit = False

        while True:
            es_de_nit = display.read_light_level() < LLINDAR
            if es_de_nit and not era_de_nit:
                nits += 1
            era_de_nit = es_de_nit

            if button_a.was_pressed():
                display.scroll(str(nits))
            elif es_de_nit:
                display.show(Image("00990:09900:09900:09900:00990"))
            else:
                display.clear()
            sleep(200)
        ```

        La clau és comparar l'estat actual (`es_de_nit`) amb l'anterior (`era_de_nit`): només es compta quan es passa de `False` a `True`. Aquesta tècnica de **detectar canvis d'estat** es fa servir moltíssim en programació de dispositius.

## Repte final

!!! example "Repte. Alarma de calaix"
    Col·loca la micro:bit dins un calaix o una capsa. Si algú l'obre (entra llum), la placa ha de fer sonar una alarma i mostrar una X. L'alarma s'ha de poder desactivar prement A i B alhora. Si tens una micro:bit V2, pots fer servir l'altaveu integrat; amb la V1, cal connectar-hi uns auriculars o un brunzidor.

    ??? success "Una solució a l'Editor de Python"
        ```python
        from microbit import *
        import music

        LLINDAR = 40
        activada = True

        while True:
            if button_a.is_pressed() and button_b.is_pressed():
                activada = False
                display.show(Image.YES)
            if activada and display.read_light_level() > LLINDAR:
                display.show(Image.NO)
                music.pitch(880, 200)
            sleep(100)
        ```

        `music.pitch(freqüència, durada)` fa sonar una nota (880 Hz durant 200 ms). `Image.YES` i `Image.NO` són imatges que ja porta MicroPython.

---

!!! quote "Font"
    Pràctica de creació pròpia. Les instruccions de MicroPython segueixen la [documentació oficial de MicroPython per a micro:bit](https://microbit-micropython.readthedocs.io/en/latest/). Els valors del sensor de llum varien segons la placa i l'aula: per això el pas 0 demana calibrar-lo.
