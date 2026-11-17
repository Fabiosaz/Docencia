# Unitat 9. Usabilitat, llegibilitat del codi i documentació

Un programa que funciona no és necessàriament un bon programa. Pensa en dues persones que el faran servir:

- La **persona usuària**, que no veu el codi. Només veu el que surt a la pantalla. Per a ella, un bon programa és el que s'entén sense esforç, avisa quan s'equivoca i li diu com fer-ho bé.
- La **persona programadora** que haurà de mantenir el programa, que potser ets tu mateix d'aquí a sis mesos. Per a ella, un bon programa és el que es llegeix i s'entén fàcilment, i en què és fàcil trobar i corregir els errors.

En aquesta unitat veurem com pensar en totes dues: com escriure codi llegible i ben comentat, com trobar errors amb el depurador, com fer programes de terminal agradables d'usar i com documentar-los.


!!! tip "Vídeo recomanat"
    Curs de Python de MoureDev: [lliçó 14, «Excepcions»](https://youtu.be/Kp4Mvapo5kc?t=32030), per a l'apartat 9.3.4. El vídeo és en castellà.

## 9.1. Codi llegible

El codi s'escriu una vegada, però es llegeix moltes. Per això la **llegibilitat** és una qualitat fonamental del codi. Compara aquests dos programes, que fan exactament el mateix:

=== "Poc llegible"

    ```python
    a=float(input())
    b=int(input())
    c=a*b
    if c>50:c=c*0.9
    print(c)
    ```

=== "Llegible"

    ```python
    # Calcula el total d'una compra aplicant un descompte si supera un import mínim

    IMPORT_MINIM_DESCOMPTE = 50   # en euros
    DESCOMPTE = 0.10              # 10 %

    preu_unitari = float(input("Preu per unitat (€): "))
    quantitat = int(input("Quantitat: "))

    total = preu_unitari * quantitat
    if total > IMPORT_MINIM_DESCOMPTE:
        total = total * (1 - DESCOMPTE)

    print(f"Total a pagar: {total:.2f} €")
    ```

El segon és més llarg, però s'entén al primer cop d'ull. Aquestes són les pràctiques que el fan llegible:

- **Noms descriptius.** `preu_unitari` diu què conté; `a`, no. Les variables d'un sol caràcter només són acceptables per a comptadors de bucles (`i`, `j`).
- **Constants amb nom en lloc de «nombres màgics».** Si veus `c > 50` al codi, no saps què vol dir aquest 50. `IMPORT_MINIM_DESCOMPTE` ho explica tot sol i, si el descompte canvia, només s'ha de modificar en un lloc.
- **Espais i línies en blanc.** Un espai a cada costat dels operadors (`total = preu * quantitat`) i una línia en blanc entre blocs que fan coses diferents.
- **Una instrucció per línia** i el bloc de l'`if` a la línia següent, sagnat.
- **Missatges clars a l'`input()` i al `print()`**, que també ajuden qui llegeix el codi a entendre què fa cada línia.

!!! info "La guia d'estil de Python: PEP 8"
    La comunitat de Python té una guia d'estil oficial, anomenada [PEP 8](https://peps.python.org/pep-0008/). Entre d'altres coses, recomana sagnar amb 4 espais, escriure les variables en minúscules amb les paraules separades per `_` (`preu_unitari`), les constants en majúscules (`DESCOMPTE`) i no escriure línies massa llargues. Seguir una guia d'estil fa que el codi de persones diferents s'assembli i es pugui llegir igual de bé.

## 9.2. Comentaris

Els **comentaris** són textos que s'escriuen dins el codi però que Python **no executa**. Serveixen perquè els programadors es deixin missatges sobre el funcionament del programa. En Python, un comentari comença amb `#` i arriba fins al final de la línia. Per als textos llargs, sovint es fan servir les cometes triples.

```python
# Comentari d'una sola línia

total = preu * quantitat   # comentari al final d'una línia de codi

"""
Text de diverses línies.
Sol fer-se servir per descriure què fa un programa, una funció o un mòdul,
o per explicar per què s'ha pres una decisió de disseny concreta i no una altra.
"""
```

Comentar bé no vol dir comentar-ho tot. Un comentari que repeteix el que ja diu el codi no aporta res:

```python
comptador = comptador + 1   # suma 1 al comptador  ← inútil
```

Els bons comentaris expliquen el que el codi **no** diu per si sol:

- **Què fa** un programa o un bloc (una capçalera al principi del fitxer).
- **Per què** s'ha fet d'una manera determinada, sobretot si no és evident.
- **Les unitats** i el significat de les dades (`# temperatura en °C`).
- **Les limitacions** conegudes (`# no funciona amb nombres negatius`).

Una bona pràctica és començar cada programa amb una **capçalera**:

```python
"""
Programa: Gestor de la llista de la compra
Autoria:  Nom i llinatges
Data:     2026-10-15
Descripció: Permet afegir, eliminar i mostrar productes d'una llista
            de la compra mitjançant un menú de terminal.
"""
```

!!! warning "Codi i comentaris han d'anar d'acord"
    Quan modifiquis el codi, revisa'n els comentaris. Un comentari desactualitzat, que diu una cosa diferent del que fa el codi, és pitjor que no tenir-ne cap.

!!! example "Exercici 9.1. Fes-lo llegible"
    Reescriu aquest programa perquè sigui llegible: noms descriptius, constants amb nom, capçalera, comentaris útils i missatges clars. Primer esbrina què fa.

    ```python
    n=int(input())
    t=0
    for i in range(n):
     x=float(input())
     if x>=5:t=t+1
    print(t,t/n*100)
    ```

    ??? success "Solució"
        ```python
        """
        Programa: Percentatge d'aprovats
        Descripció: Demana les notes d'un grup i mostra quants alumnes han
                    aprovat i quin percentatge representen.
        """

        NOTA_APROVAT = 5

        alumnes = int(input("Nombre d'alumnes del grup: "))
        aprovats = 0

        for i in range(alumnes):
            nota = float(input(f"Nota de l'alumne {i + 1}: "))
            if nota >= NOTA_APROVAT:
                aprovats += 1

        percentatge = aprovats / alumnes * 100
        print(f"Aprovats: {aprovats} de {alumnes} ({percentatge:.1f} %)")
        ```

        Encara es podria millorar: què passa si l'usuari escriu 0 alumnes? I si escriu una nota com «7,5» amb coma?

## 9.3. Depuració

Com vam veure a la unitat 8, els errors poden ser de sintaxi, d'execució o de lògica. La **depuració** (en anglès *debugging*, literalment «treure insectes») és el procés de trobar i corregir aquests errors. És com fer de detectiu: se cerquen pistes (els errors), s'analitzen les causes i es resol el problema.

### 9.3.1. Llegir els missatges d'error

Quan Python troba un error d'execució, mostra un missatge (*traceback*) que diu **quin tipus d'error** és i **a quina línia** s'ha produït. Llegeix-lo sempre de baix a dalt:

```text
Traceback (most recent call last):
  File "notes.py", line 4, in <module>
    mitjana = suma / quantes
ZeroDivisionError: division by zero
```

La darrera línia diu què ha passat (una divisió entre zero) i la de sobre, on (línia 4). Els errors més habituals al principi són:

| Error | Què vol dir |
| --- | --- |
| `SyntaxError` | Hi ha alguna cosa mal escrita: falten dos punts, un parèntesi, unes cometes… |
| `IndentationError` | El sagnat no és correcte. |
| `NameError` | Fas servir una variable que no existeix (sovint, per un error en escriure'n el nom). |
| `TypeError` | Operació entre tipus incompatibles, com `"5" + 3`. |
| `ValueError` | El valor no és adequat, com `int("hola")`. |
| `IndexError` | Accedeixes a una posició que no existeix d'una llista o una cadena. |
| `ZeroDivisionError` | Divisió entre zero. |

### 9.3.2. Mostrar valors intermedis

La tècnica més senzilla per trobar un error de lògica és afegir temporalment `print()` per veure el valor de les variables en diferents punts del programa. Quan trobis l'error, esborra aquests `print()`.

```python
suma = 0
for i in range(1, 5):
    suma += i
    print("DEPURACIÓ: i =", i, "suma =", suma)   # esborrar quan funcioni
```

### 9.3.3. El depurador

Gairebé tots els IDE tenen un **depurador** (*debugger*), una eina que permet executar el programa **pas a pas** i veure en tot moment el valor de les variables. A Visual Studio Code:

1. Posa un **punt de ruptura** (*breakpoint*) a la línia on vols que s'aturi l'execució: fes clic just a l'esquerra del número de línia i hi apareixerà un punt vermell. Si vols seguir el programa des del principi, posa'l a la primera línia.
2. Prem ++f5++ (o el menú **Run → Start Debugging**). La primera vegada, si t'ho demana, tria **Python Debugger** i l'opció del fitxer actual.
3. El programa s'atura al punt de ruptura. Avança amb els botons de la barra de depuració: **Step Over** (++f10++) executa la línia sencera i passa a la següent; **Step Into** (++f11++) entra dins la línia si crida una funció; **Continue** (++f5++) continua fins al punt de ruptura següent, i **Stop** (++shift+f5++) atura la depuració.
4. Observa el panell **Variables** de la barra lateral: mostra el valor de cada variable en aquell moment. Quan un valor no és el que esperaves, has trobat on és l'error.

El depurador no només serveix per trobar errors: també és una manera excel·lent d'**entendre com funciona** un algorisme que no acabes d'entendre. Executa'l pas a pas i mira què passa.

!!! tip "Els errors intermitents"
    Els errors més difícils de trobar són els que no apareixen a totes les execucions, sinó només en certes condicions: amb unes dades concretes, un cas límit… Per això és tan important la taula de proves de la unitat 8, amb casos normals, casos límit i dades incorrectes.

!!! example "Exercici 9.2. Caça l'error amb el depurador"
    Aquest programa hauria de calcular la mitjana de les notes, però dona un resultat incorrecte. Executa'l pas a pas amb el depurador de VS Code, observa el valor de les variables i troba l'error.

    ```python
    notes = [6, 8, 7, 9]
    suma = 0
    for i in range(1, len(notes)):
        suma += notes[i]
    print("Mitjana:", suma / len(notes))
    ```

    ??? success "Solució"
        El bucle comença a l'índex 1, de manera que se salta la primera nota (el 6). La suma dona 24 en lloc de 30, i la mitjana 6.0 en lloc de 7.5. S'ha de fer `range(len(notes))` o, millor encara, `for nota in notes:`.

### 9.3.4. Controlar els errors: excepcions

Hi ha errors que no són culpa del programador, sinó de les dades: l'usuari escriu lletres on s'esperava un nombre, un divisor val zero, un fitxer no existeix… Quan passa, Python **llança una excepció**: atura el programa i mostra el missatge d'error. Però el programa pot **capturar** l'excepció i reaccionar-hi, amb l'estructura `try` … `except`:

```python
try:
    edat = int(input("Edat: "))
    print("L'any que ve tendràs", edat + 1, "anys")
except ValueError:
    print("Això no és un nombre enter")
```

- Python executa el bloc `try`. Si tot va bé, se salta el bloc `except`.
- Si alguna instrucció del `try` provoca un `ValueError`, la resta del `try` ja no s'executa i salta directament al bloc `except`. El programa **no s'atura**.

Es poden capturar diversos tipus d'error, cadascun amb el seu missatge, i afegir-hi dos blocs opcionals:

```python
try:
    dividend = int(input("Dividend: "))
    divisor = int(input("Divisor: "))
    resultat = dividend / divisor
except ValueError:
    print("Has d'escriure nombres enters")
except ZeroDivisionError:
    print("No es pot dividir entre zero")
else:
    print("Resultat:", resultat)
finally:
    print("Operació acabada")
```

| Bloc | S'executa… |
| --- | --- |
| `try` | Sempre: és el codi que pot fallar |
| `except TipusError` | Només si dins el `try` hi ha hagut un error d'aquest tipus |
| `else` | Només si **no** hi ha hagut cap error |
| `finally` | Sempre, hi hagi hagut error o no |

Les excepcions més habituals són les que ja coneixes de l'apartat 9.3.1: `ValueError`, `ZeroDivisionError`, `IndexError`, `KeyError`, `TypeError` i `NameError`.

La combinació més útil és un bucle que torna a demanar la dada fins que és correcta:

```python
while True:
    try:
        nota = float(input("Nota (0-10): "))
        if 0 <= nota <= 10:
            break                 # dada correcta: sortim del bucle
        print("La nota ha de ser entre 0 i 10")
    except ValueError:
        print("Escriu un nombre, per exemple 7.5")

print("Nota desada:", nota)
```

!!! warning "No capturis errors a cegues"
    Python permet escriure `except:` sense cap tipus d'error, i aleshores ho captura tot, fins i tot els errors de programació com un nom de variable mal escrit. És una mala pràctica: amaga els errors en lloc de solucionar-los. Indica sempre quin tipus d'error esperes.

!!! example "Exercici 9.3. Què mostra?"
    Sense executar-lo, digues què mostra aquest programa si l'usuari escriu `8`, si escriu `0` i si escriu `vuit`.

    ```python
    try:
        n = int(input("Nombre: "))
        print(100 / n)
    except ValueError:
        print("A")
    except ZeroDivisionError:
        print("B")
    else:
        print("C")
    finally:
        print("D")
    ```

    ??? success "Solució"
        - Amb `8`: `12.5`, `C` i `D`.
        - Amb `0`: `B` i `D`. L'error es produeix en dividir, després d'haver llegit el nombre.
        - Amb `vuit`: `A` i `D`. L'error es produeix en convertir, i la divisió ja no s'executa.

        `D` surt sempre, perquè és al bloc `finally`.

!!! example "Exercici 9.4. Una calculadora que no s'atura"
    Fes una calculadora que demani dos nombres (poden tenir decimals) i una operació (`+`, `-`, `*` o `/`) i mostri el resultat. El programa no s'ha d'aturar mai amb un error: si un nombre no és vàlid, l'ha de tornar a demanar; si es divideix entre zero o l'operació no existeix, ho ha de dir.

    ??? success "Solució"
        ```python
        while True:
            try:
                a = float(input("Primer nombre: ").replace(",", "."))
                break
            except ValueError:
                print("No és un nombre vàlid. Exemple: 3.5")

        while True:
            try:
                b = float(input("Segon nombre: ").replace(",", "."))
                break
            except ValueError:
                print("No és un nombre vàlid. Exemple: 3.5")

        operacio = input("Operació (+, -, *, /): ")

        try:
            match operacio:
                case "+":
                    print("Resultat:", a + b)
                case "-":
                    print("Resultat:", a - b)
                case "*":
                    print("Resultat:", a * b)
                case "/":
                    print("Resultat:", a / b)
                case _:
                    print("Aquesta operació no existeix")
        except ZeroDivisionError:
            print("No es pot dividir entre zero")
        ```

        Els dos bucles de lectura són iguals. A la unitat 10 aprendràs a escriure aquest codi una sola vegada, dins una **funció**, i cridar-la dues vegades.

## 9.4. Usabilitat i experiència d'usuari

La **usabilitat** és la facilitat amb què una persona pot fer servir un programa per aconseguir el que vol: que n'aprengui a fer-lo servir ràpidament, que el faci servir sense errors i que no s'hi perdi. L'**experiència d'usuari** (UX, de l'anglès *user experience*) és un concepte més ampli: inclou tot el que la persona sent i percep quan fa servir el programa, també si li resulta agradable i útil.

Una aplicació **amigable** (en anglès, *user-friendly*) és la que s'entén sense manual, no deixa l'usuari perdut i perdona els errors.

### 9.4.1. Principis bàsics

L'expert en usabilitat Jakob Nielsen va formular deu principis generals (heurístiques) per dissenyar interfícies. Aquests en són alguns, adaptats als programes de terminal que feim:

| Principi | Què vol dir en un programa de terminal |
| --- | --- |
| **Visibilitat de l'estat del sistema** | L'usuari ha de saber sempre què passa: confirma les accions («Producte afegit») i indica on és (títol del menú). |
| **Parlar el llenguatge de l'usuari** | Missatges en llenguatge clar, no tècnic. «Escriu un nombre de l'1 al 5» és millor que «Input inválido». |
| **Control i llibertat** | Permet sortir o tornar enrere en qualsevol moment. Demana confirmació abans d'accions que no es poden desfer, com esborrar-ho tot. |
| **Coherència** | Fes servir sempre les mateixes paraules, el mateix format i les mateixes tecles per a les mateixes coses. |
| **Prevenció d'errors** | Indica el format esperat abans que l'usuari s'equivoqui: «Data (dd/mm/aaaa):», «Preu (€):». |
| **Ajudar a recuperar-se dels errors** | Si hi ha un error, digues què ha fallat i com fer-ho bé, i torna a demanar la dada. Mai no deixis que el programa s'aturi amb un *traceback*. |
| **Disseny minimalista** | Mostra només la informació necessària, ben ordenada i alineada. |

### 9.4.2. Abans i després

Mira aquest programa. Funciona, però és molt poc usable:

```python
x = input(">")
if x == "1":
    print(float(input()) * 1.21)
```

Qui el faci servir no sabrà què ha d'escriure a cada `input()`, i si escriu una lletra el programa s'aturarà amb un error. Aquesta és una versió molt més usable:

```python
print("=== CALCULADORA D'IVA ===")
print("1. Afegir l'IVA a un preu")
print("2. Sortir")

opcio = input("Tria una opció (1-2): ").strip()
while opcio not in ["1", "2"]:
    opcio = input("Opció no vàlida. Escriu 1 o 2: ").strip()

if opcio == "1":
    text = input("Preu sense IVA (€), per exemple 12.50: ").replace(",", ".")
    while not text.replace(".", "", 1).isdigit():
        text = input("Això no és un preu vàlid. Escriu només xifres, per exemple 12.50: ").replace(",", ".")
    preu = float(text)
    print(f"Preu amb IVA (21 %): {preu * 1.21:.2f} €")

print("Fins aviat!")
```

Fixa't en els detalls:

- Un **títol** diu on som i el **menú** mostra totes les opcions.
- Cada `input()` indica **què** s'ha d'escriure, en **quines unitats** i amb un **exemple**.
- Accepta la coma decimal, que és la que fem servir habitualment, i la converteix en punt.
- Si l'usuari s'equivoca, el programa **ho diu, explica com fer-ho bé i torna a demanar la dada**, en lloc d'aturar-se.
- El resultat surt **amb format**: dues xifres decimals i el símbol de l'euro.

!!! info "Recorda: `try` … `except`"
    Validar totes les entrades amb mètodes de cadenes pot ser complicat. Python té una estructura, `try` … `except`, que permet **intentar** una instrucció i, si provoca un error, fer una altra cosa en lloc d'aturar el programa:

    ```python
    while True:
        try:
            edat = int(input("Edat: "))
            break                        # si la conversió ha anat bé, sortim del bucle
        except ValueError:
            print("Escriu un nombre enter, per exemple 16.")
    ```

    La tens explicada a l'apartat 9.3.4.

### 9.4.3. Presentar la informació amb claredat

Les f-strings permeten alinear els resultats en columnes. El nombre després dels dos punts indica l'amplada; `<` alinea a l'esquerra, `>` a la dreta i `^` al centre:

```python
productes = [["Entrepà", 3.5], ["Aigua", 1.0], ["Croissant", 1.8]]

print(f"{'Producte':<12}{'Preu':>8}")
print("-" * 20)
for producte in productes:
    nom = producte[0]
    preu = producte[1]
    print(f"{nom:<12}{preu:>7.2f}€")
```

```text title="Sortida"
Producte        Preu
--------------------
Entrepà        3.50€
Aigua          1.00€
Croissant      1.80€
```

!!! example "Exercici 9.5. Millora la usabilitat"
    Tria un dels programes amb menú que has fet (per exemple, la llista de la compra de l'exercici 7.6) i millora'n la usabilitat aplicant els principis de l'apartat 9.4: títol, missatges clars, validació de totes les entrades, confirmació de les accions, demanar confirmació abans d'esborrar i sortida ben formatada. Fes una llista dels canvis que has fet i del principi que aplica cada un.

!!! example "Exercici 9.6. Avaluació d'usabilitat"
    Intercanvia el programa de l'exercici anterior amb un company o una companya. Fes-lo servir **sense mirar el codi** i sense que ningú t'expliqui res, i apunta:

    1. Les vegades que no has sabut què havies de fer.
    2. Els errors que has comès i si el programa t'ha ajudat a corregir-los.
    3. Tres propostes de millora.

## 9.5. Documentació

Un programa sense documentació és molt difícil de fer servir i de mantenir. Hi ha dos tipus de documentació, adreçats a dos públics diferents:

| | Documentació tècnica | Manual d'usuari |
| --- | --- | --- |
| **Per a qui** | Programadors que mantindran o milloraran el codi | Persones que faran servir el programa |
| **Què explica** | Com està fet el programa | Com es fa servir el programa |
| **On es troba** | Comentaris dins el codi i un fitxer `README` | Un document a part o l'ajuda del mateix programa |
| **Llenguatge** | Tècnic | Senzill, sense tecnicismes |

### 9.5.1. El fitxer README

El `README` (literalment, «llegeix-me») és el primer document que es consulta en obrir un projecte. Sol ser un fitxer de text, sovint en format Markdown (`README.md`), amb aquesta estructura:

1. **Nom del projecte** i una frase que expliqui què fa.
2. **Requisits**: què cal tenir instal·lat (per exemple, Python 3.10 o superior).
3. **Instal·lació i execució**: com posar-lo en marxa, pas a pas.
4. **Ús**: un exemple de com funciona.
5. **Estructura**: quins fitxers té el projecte i què fa cada un.
6. **Autoria, data i llicència.**

### 9.5.2. El manual d'usuari

El **manual d'usuari** (o guia d'ús) explica a la persona usuària com fer servir el programa. Ha de ser clar, complet i senzill. Una estructura habitual és:

1. **Introducció**: per a què serveix el programa i a qui va adreçat.
2. **Posada en marxa**: com s'obre o s'executa.
3. **Funcions**: una secció per a cada opció del menú, explicada pas a pas i amb captures de pantalla o exemples del que es veu a la terminal.
4. **Errors habituals**: què fer si surt un missatge d'error o alguna cosa no funciona.
5. **Preguntes freqüents.**

### 9.5.3. Característiques d'una bona documentació

- **Actualitzada**: descriu el programa tal com és ara, no com era fa tres versions.
- **Clara i concisa**: frases curtes, sense ambigüitats, adaptades al públic a qui es dirigeix.
- **Completa**: cobreix totes les funcions i els casos d'error.
- **Ben estructurada**: amb títols, llistes numerades per als passos i un índex si és llarga.
- **Amb exemples**: un exemple sovint s'entén millor que un paràgraf d'explicació.

!!! example "Exercici 9.7. README i manual d'usuari"
    Escriu el `README.md` i un manual d'usuari breu (una o dues pàgines) del programa que has millorat a l'exercici 9.3, seguint les estructures dels apartats 9.5.1 i 9.5.2.

## 9.6. Exercicis de repàs

Més exercicis per practicar tota la unitat: llegir i millorar codi, interpretar errors i pensar en qui farà servir el programa.

!!! example "Repàs 9.1. Bon nom o mal nom?"
    Quins d'aquests noms són adequats segons les recomanacions de la unitat? Proposa una alternativa per als que no ho són.

    `x1` · `preu_total` · `PreuTotal` · `IVA` (una constant) · `la_variable_on_guard_el_nom_de_l_alumne` · `n` (comptador d'un bucle curt) · `dada`

    ??? success "Solució"
        - Adequats: `preu_total`, `IVA` (les constants, en majúscules) i `n` com a comptador d'un bucle curt.
        - `x1`: no diu què conté. Millor `nota_examen`, per exemple.
        - `PreuTotal`: en Python, les variables s'escriuen en minúscules i amb guions baixos: `preu_total`.
        - `la_variable_on_guard_el_nom_de_l_alumne`: massa llarg. N'hi ha prou amb `nom_alumne`.
        - `dada`: massa genèric. Quina dada? `temperatura`, `edat`…

!!! example "Repàs 9.2. Comentaris útils i inútils"
    Quins d'aquests comentaris aporten informació i quins sobren?

    ```python
    i = i + 1                    # suma 1 a i
    PES_MAXIM = 23               # en kg, límit de la companyia aèria
    total = total * 1.21         # multiplica el total per 1.21
    if edat >= 16:               # edat mínima legal per treballar
        print("Pots treballar")  # mostra un missatge
    ```

    ??? success "Solució"
        Són útils el segon (indica les unitats i d'on surt el valor) i el quart (explica **per què** es compara amb 16). Els altres tres repeteixen el que ja diu el codi. El tercer seria útil si digués el que el codi no diu: `# afegim el 21 % d'IVA`; i encara millor amb una constant `IVA = 0.21`.

!!! example "Repàs 9.3. Fes-lo llegible"
    Aquest programa funciona, però costa d'entendre. Reescriu-lo amb noms descriptius, constants, espais i comentaris, sense canviar el que fa.

    ```python
    h=float(input())
    p=float(input())
    s=h*p
    if h>40:s=s+(h-40)*p*0.5
    print(s)
    ```

    ??? success "Solució"
        ```python
        # Calcula el sou setmanal, amb un plus per les hores extres

        HORES_NORMALS = 40    # hores setmanals sense plus
        PLUS_EXTRA = 0.5      # les hores extres es paguen un 50 % més

        hores = float(input("Hores treballades aquesta setmana: "))
        preu_hora = float(input("Preu per hora (€): "))

        sou = hores * preu_hora
        if hores > HORES_NORMALS:
            hores_extres = hores - HORES_NORMALS
            sou = sou + hores_extres * preu_hora * PLUS_EXTRA

        print(f"Sou setmanal: {sou:.2f} €")
        ```

        Per saber què feia el programa original, primer s'ha hagut de desxifrar. Amb la versió nova, es llegeix.

!!! example "Repàs 9.4. Què diu el missatge d'error?"
    Per a cada fragment, digues quin error dona Python i com es corregeix.

    1. `print(resultat)` sense haver creat abans la variable `resultat`.
    2. `edat = input("Edat: ")` i després `print(edat + 1)`.
    3. `nombre = int("3.7")`
    4. `paraula = "sol"` i després `print(paraula[3])`.
    5. `print(10 / (5 - 5))`

    ??? success "Solució"
        1. `NameError`: la variable no existeix. S'ha de crear abans o revisar si el nom està ben escrit.
        2. `TypeError`: `input()` retorna un text i no es pot sumar amb un enter. Solució: `int(input("Edat: "))`.
        3. `ValueError`: `int()` no pot convertir un text amb decimals. Solució: `float("3.7")`.
        4. `IndexError`: `"sol"` té les posicions 0, 1 i 2.
        5. `ZeroDivisionError`: el divisor val 0. S'ha de comprovar abans de dividir.

!!! example "Repàs 9.5. Llegeix el traceback"
    Un programa s'atura amb aquest missatge. A quina línia és l'error, de quin tipus és i quina en pot ser la causa?

    ```text
    Traceback (most recent call last):
      File "compra.py", line 7, in <module>
        total = total + preus[i]
    IndexError: list index out of range
    ```

    ??? success "Solució"
        L'error és a la **línia 7** del fitxer `compra.py` i és un `IndexError`: s'intenta accedir a una posició de la llista `preus` que no existeix. La causa més probable és un bucle en què `i` arriba a un valor igual o superior a `len(preus)`, per exemple `range(len(preus) + 1)` o `range(1, len(preus) + 1)`.

!!! example "Repàs 9.6. Error de lògica: la mitjana"
    Aquest programa no dona cap error, però el resultat és incorrecte: amb les notes 6, 8 i 10 mostra 17.33 en lloc de 8.00. Troba l'error afegint un `print()` de depuració i corregeix-lo.

    ```python
    nota1 = float(input("Nota 1: "))
    nota2 = float(input("Nota 2: "))
    nota3 = float(input("Nota 3: "))

    mitjana = nota1 + nota2 + nota3 / 3
    print(f"Mitjana: {mitjana:.2f}")
    ```

    ??? success "Solució"
        ```python
        nota1 = float(input("Nota 1: "))
        nota2 = float(input("Nota 2: "))
        nota3 = float(input("Nota 3: "))

        mitjana = (nota1 + nota2 + nota3) / 3
        print(f"Mitjana: {mitjana:.2f}")
        ```

        Faltaven els parèntesis: la divisió té més prioritat que la suma, i només es dividia entre 3 la darrera nota. És un error de **lògica**: Python no avisa, i només es detecta comparant el resultat amb el que s'esperava.

!!! example "Repàs 9.7. Error de lògica: el comptador"
    Aquest programa hauria de comptar quants nombres parells hi ha entre l'1 i el 20 (n'hi ha 10), però mostra 1. Per què? Corregeix-lo.

    ```python
    for n in range(1, 21):
        parells = 0
        if n % 2 == 0:
            parells = parells + 1
    print("Parells:", parells)
    ```

    ??? success "Solució"
        ```python
        parells = 0
        for n in range(1, 21):
            if n % 2 == 0:
                parells = parells + 1
        print("Parells:", parells)
        ```

        El comptador es posa a zero **dins** el bucle, a cada volta. S'ha d'inicialitzar abans. Amb el depurador o amb un `print(n, parells)` dins el bucle es veu de seguida que `parells` no passa mai d'1.

!!! example "Repàs 9.8. Un programa que no s'atura mai amb un error"
    Aquest programa s'atura amb un *traceback* si l'usuari escriu lletres o deixa la resposta en blanc. Millora'l perquè torni a demanar la dada fins que sigui un nombre enter entre 1 i 10, amb missatges que expliquin què s'espera.

    ```python
    n = int(input())
    print(n * 2)
    ```

    ??? success "Solució"
        ```python
        resposta = input("Escriu un nombre enter de l'1 al 10: ")
        while not resposta.isdigit() or int(resposta) < 1 or int(resposta) > 10:
            print("Això no és vàlid. Ha de ser un nombre enter entre 1 i 10, per exemple 7.")
            resposta = input("Escriu un nombre enter de l'1 al 10: ")

        n = int(resposta)
        print(f"El doble de {n} és {n * 2}")
        ```

        La dada es llegeix com a text i no es converteix fins que s'ha comprovat amb `isdigit()` que només té xifres. L'ordre de les condicions importa: si `resposta.isdigit()` és fals, Python ja no avalua `int(resposta)`, que donaria error. S'apliquen tres principis d'usabilitat: prevenir errors (el missatge indica el format), ajudar a recuperar-se'n i parlar el llenguatge de l'usuari.

!!! example "Repàs 9.9. Quin principi s'incompleix?"
    Indica quin principi d'usabilitat incompleix cada situació i com ho arreglaries.

    1. Després d'escriure un producte, el programa no mostra res i torna al menú.
    2. Si l'usuari s'equivoca, apareix `ValueError: invalid literal for int() with base 10`.
    3. En un menú se surt amb la `S`, i en un altre, amb el `0`.
    4. El programa esborra totes les dades en triar l'opció 5, sense demanar res.
    5. El programa demana `Data:` i només accepta el format `2026-11-16`.

    ??? success "Solució"
        1. **Visibilitat de l'estat del sistema**: cal confirmar l'acció («Producte afegit»).
        2. **Ajudar a recuperar-se dels errors** i **parlar el llenguatge de l'usuari**: s'ha de controlar l'error, explicar-lo amb paraules clares i tornar a demanar la dada.
        3. **Coherència**: la mateixa tecla per sortir a tot arreu.
        4. **Control i llibertat**: s'ha de demanar confirmació abans d'una acció que no es pot desfer.
        5. **Prevenció d'errors**: s'ha d'indicar el format esperat, `Data (aaaa-mm-dd):`.

!!! example "Repàs 9.10. Escriu un README"
    Escriu el fitxer `README` del programa de l'exercici «Fes-lo llegible» (el càlcul del sou setmanal), seguint l'estructura de la unitat.

    ??? success "Solució"
        Resposta orientativa:

        ```markdown
        # Sou setmanal

        Calcula el sou d'una setmana a partir de les hores treballades i del preu
        per hora, amb un plus del 50 % per a les hores que passen de 40.

        ## Requisits

        Python 3.10 o superior.

        ## Execució

            python sou.py

        ## Ús

            Hores treballades aquesta setmana: 45
            Preu per hora (€): 10
            Sou setmanal: 475.00 €

        ## Estructura

        - `sou.py`: el programa.
        - `README.md`: aquest document.

        ## Autoria

        Aina Ferrer, novembre de 2026. Llicència CC BY-SA 4.0.
        ```

---

!!! quote "Font"
    Unitat elaborada en bona part amb material propi, a partir de la base de Lope González Vázquez ([CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ca)). De [«Tema 11. Fundamentos de programación»](https://lopegonzalez.es/eso-y-bachillerato/tic-i-1o-bachillerato/tema-11-fundamentos-de-programacion/) (TIC I) provenen la idea de la depuració com a feina de detectiu, el depurador amb punts de ruptura, l'inspector de variables i els errors intermitents (adaptats de PyCharm a Visual Studio Code) i la importància de la documentació. De [«Tema 1. Introducción a la programación»](https://lopegonzalez.es/eso-y-bachillerato/creacion-digital-y-pensamiento-computacional-1o-bachillerato/tema-1-introduccion-a-la-programacion/) (Creación digital y pensamiento computacional) prové l'explicació dels comentaris. Són propis els apartats 9.1 (llegibilitat), 9.3.4 (excepcions), 9.3.1-9.3.2, 9.4 (usabilitat i UX), 9.5 (documentació), els exercicis i les solucions. Els principis de l'apartat 9.4.1 són una selecció adaptada de les deu heurístiques d'usabilitat de Jakob Nielsen.
