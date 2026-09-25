# Pràctica 4. Seguidor de línia

Programaràs l'mBot2 perquè segueixi una línia negra dibuixada a terra, com fan els robots que transporten material als magatzems i als hospitals.

| Fitxa de la pràctica | |
| --- | --- |
| **Dispositiu** | mBot2 amb CyberPi i sensor RGB quàdruple (el de sota el robot) |
| **Eina** | [mBlock](https://mblock.cc/) (blocs o Python) |
| **Material** | Un circuit amb una línia negra de 2 o 3 cm d'amplada sobre fons blanc (cinta aïllant negra sobre paper o cartolina) |
| **Unitats relacionades** | 4 (condicionals) i 5 (bucles) |
| **Nivells** | Tria'n un: 1, 2 o 3. Consulta la [presentació de les pràctiques](index.md) |

## Com funciona el sensor RGB quàdruple

Sota el robot hi ha **quatre sensors** en fila que detecten si tenen a sota una zona negra (la línia) o blanca. Estan numerats de l'**1** (el de més a la **dreta**) al **4** (el de més a l'**esquerra**). Els dos del mig, el **2** i el **3**, són els que farem servir per seguir la línia.

En Python, `mbuild.quad_rgb_sensor.is_line(n)` retorna `True` si el sensor `n` detecta la línia negra i `False` si no.

!!! tip "Calibra el sensor"
    Si el robot no distingeix bé la línia, calibra el sensor: consulta com fer-ho a la [guia del sensor RGB quàdruple de Makeblock](https://education.makeblock.com/help/mbuild-quad-rgb-sensor/).

## Pas 0. L'algorisme

Pensa què ha de fer el robot en cada situació:

| Sensor 3 (mig esquerra) | Sensor 2 (mig dreta) | Situació | Què ha de fer |
| --- | --- | --- | --- |
| Línia | Línia | El robot està centrat | Avançar recte |
| Línia | Blanc | La línia s'ha desplaçat cap a l'esquerra | Girar cap a l'esquerra |
| Blanc | Línia | La línia s'ha desplaçat cap a la dreta | Girar cap a la dreta |
| Blanc | Blanc | El robot ha perdut la línia | Aturar-se |

Aquesta taula és, en realitat, un **algorisme**: una estructura `if` … `elif` … `else` amb quatre casos.

## Pas 1. El seguidor bàsic

=== "Nivell 1. Blocs"

    1. Comença el programa amb el bloc que s'executa **en prémer el botó A**.
    2. Dins un bloc **per sempre**, fes servir **si … si no** niats (o amb **i**) per distingir els quatre casos de la taula, amb el bloc que diu si **el sensor RGB quàdruple detecta la línia** al sensor 2 i al sensor 3.
    3. Per girar suaument, fes que cada roda vagi a una velocitat diferent: per girar a l'esquerra, la roda esquerra ha d'anar més a poc a poc que la dreta.
    4. Prova-ho al circuit i després obre la vista de **Python**.

=== "Nivell 2. Blocs → Python"

    Fes el programa amb blocs, passa a la vista **Python** i fes-hi les ampliacions escrivint codi.

=== "Nivell 3. Python directe"

    A més de `mbuild.quad_rgb_sensor.is_line(n)`, necessitaràs moure cada motor per separat amb `mbot2.EM_set_speed(velocitat, motor)`, on `motor` és 1 o 2. Als exemples d'aquesta pràctica, l'1 és el de l'esquerra i el 2, el de la dreta: comprova amb el teu robot que és així.

!!! info "Per què la roda dreta va amb velocitat negativa?"
    Els dos motors estan muntats un davant de l'altre, mirant cap a costats oposats. Per això, perquè les dues rodes facin avançar el robot, un motor ha de girar en un sentit i l'altre en el contrari: la velocitat del motor 2 s'escriu en negatiu. Si en provar-ho el robot gira al revés del que esperes, intercanvia els números dels motors.

??? success "Solució en Python"
    ```python
    import cyberpi, mbot2, mbuild

    RAPID = 40   # rpm
    LENT = 10    # rpm

    while not cyberpi.controller.is_press("a"):
        pass

    while True:
        esquerra = mbuild.quad_rgb_sensor.is_line(3)
        dreta = mbuild.quad_rgb_sensor.is_line(2)

        if esquerra and dreta:          # centrat: recte
            mbot2.EM_set_speed(RAPID, 1)
            mbot2.EM_set_speed(-RAPID, 2)
        elif esquerra:                  # la línia se'n va a l'esquerra
            mbot2.EM_set_speed(LENT, 1)
            mbot2.EM_set_speed(-RAPID, 2)
        elif dreta:                     # la línia se'n va a la dreta
            mbot2.EM_set_speed(RAPID, 1)
            mbot2.EM_set_speed(-LENT, 2)
        else:                           # línia perduda
            mbot2.EM_stop()
    ```

    Els noms `esquerra` i `dreta` fan que les condicions es llegeixin gairebé com la taula de l'algorisme.

!!! question "Pregunta 4.1. Velocitat i precisió"
    Prova el programa amb `RAPID = 80`. Què passa a les corbes? Per què?

    ??? success "Resposta"
        El robot sovint se surt de la línia a les corbes: entre una lectura dels sensors i la següent recorre massa distància i, quan corregeix, ja és tard. Hi ha un compromís entre **velocitat** i **precisió**, com passa en molts de sistemes reals.

## Pas 2. Ampliacions

!!! example "Ampliació 2.1. No et perdis"
    Quan el robot perd la línia, en lloc d'aturar-se, fes que la busqui: que giri cap al costat on l'ha vista per última vegada. Pista: guarda en una variable per quin costat s'ha vist la línia l'última vegada.

    ??? success "Solució en Python"
        ```python
        import cyberpi, mbot2, mbuild

        RAPID = 40
        LENT = 10
        ultim_costat = "esquerra"

        while not cyberpi.controller.is_press("a"):
            pass

        while True:
            esquerra = mbuild.quad_rgb_sensor.is_line(3)
            dreta = mbuild.quad_rgb_sensor.is_line(2)

            if esquerra and dreta:
                mbot2.EM_set_speed(RAPID, 1)
                mbot2.EM_set_speed(-RAPID, 2)
            elif esquerra:
                ultim_costat = "esquerra"
                mbot2.EM_set_speed(LENT, 1)
                mbot2.EM_set_speed(-RAPID, 2)
            elif dreta:
                ultim_costat = "dreta"
                mbot2.EM_set_speed(RAPID, 1)
                mbot2.EM_set_speed(-LENT, 2)
            elif ultim_costat == "esquerra":   # perduda: la busca girant sobre si mateix
                mbot2.EM_set_speed(-LENT, 1)
                mbot2.EM_set_speed(-LENT, 2)
            else:
                mbot2.EM_set_speed(LENT, 1)
                mbot2.EM_set_speed(LENT, 2)
        ```

        Quan les dues rodes giren en el mateix sentit de motor, el robot gira sobre si mateix. Si gira cap al costat equivocat, canvia els signes.

!!! example "Ampliació 2.2. Estació d'aturada"
    Posa un tros de cinta **vermella** al circuit. Quan el robot hi passi per sobre, s'ha d'aturar 3 segons, fer un so i continuar. Pista: `mbuild.quad_rgb_sensor.get_color_sta(n)` retorna el color que detecta el sensor `n` com a text: `"white"`, `"black"`, `"red"`, `"green"`…

    ??? success "Solució en Python (el bloc que s'afegeix al principi del bucle)"
        ```python
        import time
        # ... dins el while True, abans de comprovar la línia:
        if mbuild.quad_rgb_sensor.get_color_sta(2) == "red":
            mbot2.EM_stop()
            cyberpi.audio.play("hello")
            time.sleep(3)
            mbot2.straight(5, 30)   # avança 5 cm per sortir de la marca
        ```

        Sense l'última línia, el robot detectaria la marca vermella una altra vegada en tornar a comprovar-la i quedaria aturat per sempre.

## Repte final

!!! example "Repte. La cursa"
    Organitzau una cursa: tots els robots fan el mateix circuit i es cronometra quant tarden a fer una volta. Ajusta les velocitats i la manera de girar per aconseguir el millor temps **sense sortir de la línia**. Documenta cada prova en una taula (valors de `RAPID` i `LENT`, temps, s'ha sortit o no), com les taules de proves de la unitat 8.

---

!!! quote "Font"
    Pràctica de creació pròpia. Les instruccions de Python per a l'mBot2 i el sensor RGB quàdruple s'han contrastat amb la [referència del sensor RGB quàdruple de lbotics.at](https://www.lbotics.at/mbot2/mbot2-mit-python/grundlagen/quad-rgb-sensor), la [referència de l'ultrasons de lbotics.at](https://www.lbotics.at/mbot2/mbot2-mit-python/grundlagen/ultra-sonic-sensor-2) i el [manual de Python per a mBot2 i CyberPi de Digital Technology](https://robocoast.tech/wp-content/uploads/2023/05/MakeBlock-mBot2-Python-Booklet-v4-1.pdf). El codi s'ha provat amb una simulació de les llibreries, no amb un robot real: el número i el sentit de cada motor s'han de comprovar amb el vostre robot.
