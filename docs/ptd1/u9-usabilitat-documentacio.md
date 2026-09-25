# Unitat 9. Usabilitat, llegibilitat del codi i documentació

Un programa que funciona no és necessàriament un bon programa. Pensa en dues persones que el faran servir:

- La **persona usuària**, que no veu el codi. Només veu el que surt a la pantalla. Per a ella, un bon programa és el que s'entén sense esforç, avisa quan s'equivoca i li diu com fer-ho bé.
- La **persona programadora** que haurà de mantenir el programa, que potser ets tu mateix d'aquí a sis mesos. Per a ella, un bon programa és el que es llegeix i s'entén fàcilment, i en què és fàcil trobar i corregir els errors.

En aquesta unitat veurem com pensar en totes dues: com escriure codi llegible i ben comentat, com trobar errors amb el depurador, com fer programes de terminal agradables d'usar i com documentar-los.

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

!!! info "Per saber-ne més: `try` … `except`"
    Validar totes les entrades amb mètodes de cadenes pot ser complicat. Python té una estructura, `try` … `except`, que permet **intentar** una instrucció i, si provoca un error, fer una altra cosa en lloc d'aturar el programa:

    ```python
    while True:
        try:
            edat = int(input("Edat: "))
            break                        # si la conversió ha anat bé, sortim del bucle
        except ValueError:
            print("Escriu un nombre enter, per exemple 16.")
    ```

    La tornarem a trobar a PTD II.

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

!!! example "Exercici 9.3. Millora la usabilitat"
    Tria un dels programes amb menú que has fet (per exemple, la llista de la compra de l'exercici 7.6) i millora'n la usabilitat aplicant els principis de l'apartat 9.4: títol, missatges clars, validació de totes les entrades, confirmació de les accions, demanar confirmació abans d'esborrar i sortida ben formatada. Fes una llista dels canvis que has fet i del principi que aplica cada un.

!!! example "Exercici 9.4. Avaluació d'usabilitat"
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

!!! example "Exercici 9.5. README i manual d'usuari"
    Escriu el `README.md` i un manual d'usuari breu (una o dues pàgines) del programa que has millorat a l'exercici 9.3, seguint les estructures dels apartats 9.5.1 i 9.5.2.

---

!!! quote "Font"
    Unitat elaborada en bona part amb material propi, a partir de la base de Lope González Vázquez ([CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ca)). De [«Tema 11. Fundamentos de programación»](https://lopegonzalez.es/eso-y-bachillerato/tic-i-1o-bachillerato/tema-11-fundamentos-de-programacion/) (TIC I) provenen la idea de la depuració com a feina de detectiu, el depurador amb punts de ruptura, l'inspector de variables i els errors intermitents (adaptats de PyCharm a Visual Studio Code) i la importància de la documentació. De [«Tema 1. Introducción a la programación»](https://lopegonzalez.es/eso-y-bachillerato/creacion-digital-y-pensamiento-computacional-1o-bachillerato/tema-1-introduccion-a-la-programacion/) (Creación digital y pensamiento computacional) prové l'explicació dels comentaris. Són propis els apartats 9.1 (llegibilitat), 9.3.1-9.3.2, 9.4 (usabilitat i UX), 9.5 (documentació), els exercicis i les solucions. Els principis de l'apartat 9.4.1 són una selecció adaptada de les deu heurístiques d'usabilitat de Jakob Nielsen.
