# Pràctiques amb micro:bit i mBot2

En aquestes pràctiques aplicaràs el que aprens a les unitats programant dispositius reals: la placa **micro:bit** i el robot **mBot2**, que té com a cervell la placa **CyberPi**.

Els dos entorns que farem servir, **MakeCode** per a la micro:bit i **mBlock** per a l'mBot2, permeten programar **amb blocs** o **en Python**, i mostren la correspondència entre les dues maneres. Per això són un bon laboratori: pots entendre la lògica amb blocs i veure com s'escriu el mateix en Python.

## Tres nivells per a cada pràctica

Totes les pràctiques tenen el mateix repte per a tothom, però el pots abordar a tres nivells. Tria el que s'ajusti al teu, i intenta pujar-ne un quan et sentis segur.

| Nivell | Què fas |
| --- | --- |
| **1. Blocs** | Resols el repte amb blocs. Després obres la vista de Python i expliques què fa cada línia. |
| **2. Blocs → Python** | Comences amb blocs, passes a la vista de Python i hi fas les ampliacions escrivint codi. |
| **3. Python directe** | Resols el repte i les ampliacions escrivint Python des del principi. |

## Eines

| Dispositiu | Eina | Blocs | Python | Simulador |
| --- | --- | --- | --- | --- |
| micro:bit | [MakeCode](https://makecode.microbit.org/) | Sí | Sí (i JavaScript) | Sí: pots fer les pràctiques a casa sense placa |
| micro:bit | [Editor de Python](https://python.microbit.org/) | No | Sí (MicroPython) | Sí |
| mBot2 (CyberPi) | [mBlock](https://mblock.cc/) | Sí | Sí | No |

## El Python dels dispositius no és ben bé el de classe

El Python que fas servir en aquests entorns s'assembla molt al que programes a VS Code, però no és exactament igual. Les diferències més importants són aquestes:

| | Python a VS Code | MakeCode (vista Python) | Editor de Python de la micro:bit |
| --- | --- | --- | --- |
| **Entrada de dades** | `input()` | No hi ha `input()`: les dades arriben pels botons i els sensors | No hi ha `input()`: les dades arriben pels botons i els sensors |
| **Sortida** | `print()` | `basic.show_number()`, `basic.show_string()`… a la pantalla de LED | `display.show()`, `display.scroll()`… a la pantalla de LED |
| **Com s'organitza el programa** | De dalt a baix | Per **esdeveniments**: cada bloc «on…» (en sacsejar, en prémer el botó A…) es converteix en una funció que s'executa quan passa l'esdeveniment | Normalment, un bucle `while True` que comprova contínuament els botons i els sensors |
| **Nombres a l'atzar** | `import random` i `random.randint(1, 6)` | `randint(1, 6)`, sense `import` | `import random` i `random.randint(1, 6)` |
| **Pauses** | `time.sleep(1)` (en segons) | `basic.pause(1000)` (en mil·lisegons) | `sleep(1000)` (en mil·lisegons) |
| **Llenguatge** | Python complet | Una versió reduïda de Python: no hi funciona tot, i una variable no pot canviar de tipus | MicroPython, una versió de Python per a dispositius petits |

!!! info "Funcions i `global`"
    A MakeCode veuràs `def` (la manera de crear una **funció**) i, de vegades, `global`. Les funcions les estudiaràs a PTD II; de moment, pensa que `def` agrupa unes quantes instruccions amb un nom perquè s'executin quan passa l'esdeveniment. `global` indica que, dins aquesta funció, es vol modificar una variable creada fora.

## Pràctiques

| Pràctica | Dispositiu | Unitats relacionades |
| --- | --- | --- |
| [1. El dau electrònic](microbit-1-dau.md) | micro:bit | 1, 3, 4 i 7 |
| 2. Detector de dia i nit *(en preparació)* | micro:bit | 4 |
| 3. Esquivar obstacles *(en preparació)* | mBot2 | 4 i 5 |
| 4. Seguidor de línia *(en preparació)* | mBot2 | 5 |
| 5. Missatges xifrats per ràdio *(en preparació)* | micro:bit | 6 |
| 6. Registre de temperatures *(en preparació)* | micro:bit | 7 |
| 7. El robot gravadora *(en preparació)* | mBot2 | 7 |
