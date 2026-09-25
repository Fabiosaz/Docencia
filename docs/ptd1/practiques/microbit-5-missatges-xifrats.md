# Pràctica 5. Missatges xifrats per ràdio

Les micro:bit es poden comunicar entre elles per ràdio. En aquesta pràctica, primer enviaràs missatges d'una placa a una altra i després els xifraràs amb el xifratge de Cèsar de la unitat 6, perquè només els entengui qui coneix la clau.

| Fitxa de la pràctica | |
| --- | --- |
| **Dispositiu** | Dues micro:bit (o el simulador de MakeCode, que en mostra dues quan fas servir la ràdio) |
| **Eines** | [MakeCode](https://makecode.microbit.org/) (pas 1) · [Editor de Python de la micro:bit](https://python.microbit.org/) (pas 2 i ampliacions) |
| **Unitats relacionades** | 6 (cadenes i xifratge de Cèsar) i 7 (llistes) |
| **Nivells** | El pas 1 es pot fer als tres nivells. El xifratge (pas 2) es fa en Python |
| **Treball** | En parelles: cada membre programa una placa |

!!! info "Grups de ràdio"
    Totes les micro:bit que tenen la ràdio activada i estan configurades en el **mateix grup** (un nombre de 0 a 255) reben els missatges que s'hi envien. Cada parella ha de triar un grup diferent per no rebre els missatges de les altres. Això vol dir, també, que **qualsevol** placa que es posi al vostre grup pot llegir els vostres missatges: per això té sentit xifrar-los.

## Pas 1. Enviar i rebre

La placa ha d'enviar el text `HOLA` quan es prem el botó A i mostrar a la pantalla qualsevol missatge que rebi. Carregau el **mateix programa** a les dues plaques.

=== "Nivell 1. Blocs"

    1. A MakeCode, afegeix al bloc **on start** el bloc **radio set group** (categoria **Radio**) amb el número del vostre grup.
    2. Amb el bloc **on button A pressed**, envia el text amb **radio send string**.
    3. Amb el bloc **on radio received receivedString**, mostra el text rebut amb **show string**.
    4. Prova-ho al simulador (apareixeran dues plaques) i després canvia a la vista **Python**.

=== "Nivell 2. Blocs → Python"

    Fes-ho amb blocs, passa a la vista **Python** i continua amb el pas 2 a l'Editor de Python.

=== "Nivell 3. Python directe"

    A l'Editor de Python necessitaràs `import radio`, `radio.on()`, `radio.config(group=...)`, `radio.send(text)` i `radio.receive()`, que retorna el missatge rebut o `None` si no n'ha arribat cap.

??? success "Solució a MakeCode (Python)"
    ```python
    radio.set_group(7)

    def on_button_pressed_a():
        radio.send_string("HOLA")
    input.on_button_pressed(Button.A, on_button_pressed_a)

    def on_received_string(receivedString):
        basic.show_string(receivedString)
    radio.on_received_string(on_received_string)
    ```

    `receivedString` és el **paràmetre** de la funció: la variable on MakeCode deixa el text que ha arribat.

??? success "Solució a l'Editor de Python"
    ```python
    from microbit import *
    import radio

    radio.on()
    radio.config(group=7)

    while True:
        if button_a.was_pressed():
            radio.send("HOLA")
        missatge = radio.receive()
        if missatge:
            display.scroll(missatge)
        sleep(100)
    ```

    `if missatge:` és una manera curta d'escriure `if missatge != None:`: la condició és falsa quan no s'ha rebut res.

## Pas 2. Xifrar els missatges

Ara, cada placa tendrà una **llista de missatges**. El botó A passa al missatge següent de la llista i el mostra; el botó B l'envia **xifrat** amb el xifratge de Cèsar. En rebre un missatge, la placa el **desxifra** i el mostra. Les dues plaques han de fer servir la mateixa clau.

Per simplificar, farem servir només **majúscules sense accents**: els altres caràcters, com els espais, s'envien tal com són.

??? success "Solució a l'Editor de Python"
    ```python
    from microbit import *
    import radio

    CLAU = 3
    MISSATGES = ["HOLA", "VENC", "ESPERA", "SOM AQUI", "ADEU"]

    radio.on()
    radio.config(group=7)
    actual = 0
    display.scroll(MISSATGES[actual])

    while True:
        # Botó A: missatge següent
        if button_a.was_pressed():
            actual = (actual + 1) % len(MISSATGES)
            display.scroll(MISSATGES[actual])

        # Botó B: xifrar i enviar
        if button_b.was_pressed():
            xifrat = ""
            for c in MISSATGES[actual]:
                if "A" <= c <= "Z":
                    xifrat += chr((ord(c) - ord("A") + CLAU) % 26 + ord("A"))
                else:
                    xifrat += c
            radio.send(xifrat)
            display.show(Image.YES)

        # En rebre: desxifrar i mostrar
        rebut = radio.receive()
        if rebut:
            desxifrat = ""
            for c in rebut:
                if "A" <= c <= "Z":
                    desxifrat += chr((ord(c) - ord("A") - CLAU) % 26 + ord("A"))
                else:
                    desxifrat += c
            display.scroll(desxifrat)
        sleep(100)
    ```

    - `(actual + 1) % len(MISSATGES)` fa que, després del darrer missatge, es torni al primer: el mateix truc del mòdul que al xifratge de Cèsar.
    - El xifratge i el desxifratge són el mateix càlcul, amb la clau sumada o restada.

!!! question "Pregunta 5.1. On és la seguretat?"
    1. Si una tercera placa es posa al vostre grup de ràdio, què veu?
    2. Per què no seria una bona idea enviar la clau per ràdio abans del missatge?

    ??? success "Resposta"
        1. Veu els missatges **xifrats**: rep el mateix que la vostra placa, però, si no sap la clau, no els entén… almenys fins que provi les 25 claus possibles, com al repte 6.1.
        2. Perquè qualsevol que escoltés el grup rebria la clau i podria desxifrar-ho tot. El gran problema del xifratge simètric és com posar-se d'acord en la clau sense que ningú més l'aconsegueixi. La criptografia moderna ho resol amb el xifratge asimètric, amb una clau pública i una de privada.

## Pas 3. Ampliacions

!!! example "Ampliació 3.1. La placa espia"
    Programa una tercera placa que escolti el grup de ràdio i, en rebre un missatge xifrat, en mostri **tots els desxifratges possibles** (claus de l'1 al 25) una darrere l'altra, fins que es premi A. Així veureu per què el xifratge de Cèsar és insegur.

    ??? success "Solució a l'Editor de Python"
        ```python
        from microbit import *
        import radio

        radio.on()
        radio.config(group=7)

        while True:
            rebut = radio.receive()
            if rebut:
                for clau in range(1, 26):
                    if button_a.was_pressed():
                        break
                    prova = ""
                    for c in rebut:
                        if "A" <= c <= "Z":
                            prova += chr((ord(c) - ord("A") - clau) % 26 + ord("A"))
                        else:
                            prova += c
                    display.scroll(str(clau) + ":" + prova)
            sleep(100)
        ```

!!! example "Ampliació 3.2. Clau secreta amb els botons"
    En lloc de tenir la clau escrita al programa, fes que en engegar la placa l'usuari la triï: A augmenta la clau, B la disminueix i A+B la confirma. D'aquesta manera, el programa pot ser públic i la clau, secreta.

## Repte final

!!! example "Repte. Telègraf Morse"
    Converteix la parella de plaques en un telègraf: a la placa emissora, una pulsació curta del botó A envia un punt i una de llarga, una ratlla; la placa receptora ho mostra i, quan rep una lletra completa (per exemple, amb el botó B), la tradueix. Necessitaràs una estructura per guardar la correspondència entre cada lletra i el seu codi Morse: una llista de parelles o, si has vist l'apartat 7.3, un diccionari.

---

!!! quote "Font"
    Pràctica de creació pròpia, que aplica el xifratge de Cèsar de la unitat 6 (basat en el material de Lope González Vázquez). Les instruccions de ràdio segueixen la [documentació de la ràdio de MicroPython per a micro:bit](https://microbit-micropython.readthedocs.io/en/latest/radio.html).
