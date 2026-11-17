# Unitat 10. Funcions i mòduls

A mesura que els programes creixen, apareixen dos problemes. El primer: hi ha trossos de codi que es repeteixen, com el bucle que torna a demanar una dada fins que és correcta. El segon: un programa de 200 línies seguides és difícil de llegir, de provar i de corregir. Les **funcions** resolen tots dos: permeten donar un nom a un bloc de codi, escriure'l una sola vegada i fer-lo servir tantes vegades com calgui. Els **mòduls** fan el mateix a una escala més gran: agrupen funcions en fitxers que es poden reutilitzar en molts de programes.

!!! tip "Vídeo recomanat"
    Curs de Python de MoureDev: [lliçó 12, «Funcions»](https://youtu.be/Kp4Mvapo5kc?t=26619) i [lliçó 15, «Mòduls»](https://youtu.be/Kp4Mvapo5kc?t=34583). El vídeo és en castellà.

## 10.1. Per què serveixen les funcions

Ja fas servir funcions des de la unitat 3: `print()`, `input()`, `len()`, `int()`… Algú les ha programades i tu només les **crides** pel seu nom, sense saber com funcionen per dins. Ara aprendràs a crear les teves.

Una funció és un bloc de codi amb un nom, que fa una tasca concreta. Fer servir funcions té tres avantatges:

- **No repetir codi.** Si una tasca es fa en diversos llocs, s'escriu una vegada i es crida tantes vegades com calgui. Si després s'ha de corregir, es corregeix en un sol lloc.
- **Dividir el problema.** És el **disseny descendent** de la unitat 8: cada tasca petita es converteix en una funció.
- **Llegibilitat.** `mitjana = calcula_mitjana(notes)` s'entén sense haver de llegir com es calcula.

## 10.2. Definir i cridar una funció

Una funció es **defineix** amb la paraula `def`, el nom, uns parèntesis i dos punts. El bloc sagnat és el **cos** de la funció:

```python
def saluda():
    print("Hola!")
    print("Benvingut al programa")


saluda()        # primera crida
saluda()        # segona crida
```

```text
Hola!
Benvingut al programa
Hola!
Benvingut al programa
```

- Definir una funció **no l'executa**: només li dona un nom. El codi s'executa quan es **crida**, escrivint el nom i els parèntesis.
- Una funció s'ha de definir **abans** de cridar-la. Per això les funcions s'escriuen al principi del fitxer.
- Els noms de les funcions segueixen les mateixes normes que els de les variables: en minúscules i amb guions baixos. Convé que siguin un verb: `mostra_menu`, `calcula_preu`, `demana_edat`.

!!! example "Exercici 10.1. La capçalera"
    Escriu una funció `capcalera()` que mostri una línia de 30 signes `=`, el text «GESTIÓ DE NOTES» i una altra línia de 30 signes `=`. Crida-la dues vegades.

    ??? success "Solució"
        ```python
        def capcalera():
            print("=" * 30)
            print("GESTIÓ DE NOTES")
            print("=" * 30)


        capcalera()
        capcalera()
        ```

## 10.3. Paràmetres

Una funció que sempre fa exactament el mateix és poc útil. Els **paràmetres** són variables que la funció rep quan es crida, i que en permeten canviar el comportament:

```python
def saluda(nom):
    print(f"Hola, {nom}!")


saluda("Aina")
saluda("Biel")
```

```text
Hola, Aina!
Hola, Biel!
```

- Al `def`, `nom` és un **paràmetre**: una variable que només existeix dins la funció.
- A la crida, `"Aina"` és un **argument**: el valor concret que pren el paràmetre aquella vegada.

Una funció pot tenir diversos paràmetres, separats per comes. Els arguments s'assignen **per ordre**, però també es poden indicar **pel nom**, i aleshores l'ordre no importa. A més, un paràmetre pot tenir un **valor per defecte**, que es fa servir si no s'indica cap argument:

```python
def linia(caracter="-", llargada=20):
    print(caracter * llargada)


linia()                        # --------------------
linia("*")                     # ********************
linia("=", 10)                 # ==========
linia(llargada=5)              # -----
```

!!! example "Exercici 10.2. Una targeta"
    Escriu una funció `targeta(nom, curs, materia="PTD I")` que mostri les tres dades en línies separades, emmarcades amb dues línies de guions. Crida-la amb i sense el tercer argument, i una vegada indicant els arguments pel nom.

    ??? success "Solució"
        ```python
        def targeta(nom, curs, materia="PTD I"):
            print("-" * 25)
            print("Nom:", nom)
            print("Curs:", curs)
            print("Matèria:", materia)
            print("-" * 25)


        targeta("Aina Ferrer", "1r de Batxillerat")
        targeta("Biel Mas", "2n de Batxillerat", "PTD II")
        targeta(curs="1r de Batxillerat", nom="Carla Vidal")
        ```

## 10.4. Retornar valors

Les funcions que hem fet fins ara **mostren** coses per pantalla. Però sovint volem que una funció **calculi** un resultat i el torni al programa, perquè el puguem guardar, fer-hi operacions o mostrar-lo com vulguem. Això es fa amb `return`:

```python
def area_rectangle(base, altura):
    return base * altura


a = area_rectangle(4, 3)
print(a)                                   # 12
print(area_rectangle(2, 5) + 1)            # 11
```

- `return` acaba la funció immediatament i torna el valor indicat al lloc on s'ha cridat.
- Una funció sense `return` torna `None`, que vol dir «res».

!!! warning "`print` no és `return`"
    És l'error més habitual quan es comença. Compara aquestes dues funcions:

    ```python
    def doble_print(n):
        print(n * 2)

    def doble_return(n):
        return n * 2

    x = doble_print(5)      # mostra 10, però x val None
    y = doble_return(5)     # no mostra res, i y val 10
    ```

    Si la funció ha de **calcular** alguna cosa, fes servir `return` i deixa els `print` per al programa principal. Així la funció serveix en més situacions: pots mostrar el resultat, guardar-lo en una llista o fer-hi més càlculs.

Una funció pot tenir diversos `return`, per exemple un a cada branca d'un condicional, i pot retornar **diversos valors** alhora en forma de tupla, que es desempaqueta en rebre-la:

```python
def qualificacio(nota):
    if nota < 5:
        return "Insuficient"
    elif nota < 7:
        return "Suficient o bé"
    elif nota < 9:
        return "Notable"
    return "Excel·lent"


def minim_i_maxim(llista):
    return min(llista), max(llista)


print(qualificacio(7.5))                 # Notable
petit, gran = minim_i_maxim([4, 9, 2, 7])
print(petit, gran)                       # 2 9
```

!!! example "Exercici 10.3. Funcions que calculen"
    Escriu aquestes funcions, totes amb `return` i sense cap `print` a dins, i prova-les des del programa principal:

    1. `es_parell(n)`: retorna `True` si `n` és parell i `False` si no ho és.
    2. `mitjana(llista)`: retorna la mitjana d'una llista de nombres, o `None` si la llista és buida.
    3. `compta_vocals(text)`: retorna quantes vocals sense accent té un text, en majúscules o en minúscules.
    4. `preu_final(preu, descompte=0)`: retorna el preu aplicant-hi el descompte en percentatge, arrodonit a dos decimals.

    ??? success "Solució"
        ```python
        def es_parell(n):
            return n % 2 == 0


        def mitjana(llista):
            if len(llista) == 0:
                return None
            return sum(llista) / len(llista)


        def compta_vocals(text):
            vocals = 0
            for caracter in text.lower():
                if caracter in "aeiou":
                    vocals += 1
            return vocals


        def preu_final(preu, descompte=0):
            return round(preu * (1 - descompte / 100), 2)


        print(es_parell(10), es_parell(7))        # True False
        print(mitjana([6, 8, 7]))                 # 7.0
        print(mitjana([]))                        # None
        print(compta_vocals("Hola, Mallorca"))    # 5
        print(preu_final(80, 15))                 # 68.0
        print(preu_final(80))                     # 80.0
        ```

        `es_parell` no necessita cap `if`: la comparació `n % 2 == 0` ja és un valor `True` o `False`, i es pot retornar directament.

!!! example "Exercici 10.4. Llegir un nombre sense errors"
    A l'exercici 9.4 vas escriure dues vegades el mateix bucle per llegir un nombre. Escriu una funció `llegeix_nombre(missatge)` que mostri el missatge, torni a demanar la dada fins que sigui un nombre vàlid (acceptant la coma decimal) i el retorni com a `float`. Fes-la servir per demanar l'amplada i l'altura d'una habitació i mostrar-ne la superfície.

    ??? success "Solució"
        ```python
        def llegeix_nombre(missatge):
            while True:
                try:
                    return float(input(missatge).replace(",", "."))
                except ValueError:
                    print("No és un nombre vàlid. Exemple: 3.5")


        amplada = llegeix_nombre("Amplada (m): ")
        altura = llegeix_nombre("Llargada (m): ")
        print(f"Superfície: {amplada * altura:.2f} m²")
        ```

        El `return` dins el `try` fa dues coses alhora: surt del bucle i retorna el valor. Aquesta funció la podràs copiar a tots els programes que demanin nombres.

## 10.5. L'àmbit de les variables

Les variables que es creen dins una funció, inclosos els paràmetres, són **locals**: només existeixen mentre la funció s'executa, i no es veuen des de fora. Les que es creen fora de les funcions, al programa principal, són **globals**.

```python
def calcula():
    resultat = 42          # variable local
    return resultat


calcula()
print(resultat)            # NameError: name 'resultat' is not defined
```

Una funció **pot llegir** una variable global, però si li assigna un valor, Python crea una variable local nova amb el mateix nom i la global no canvia:

```python
comptador = 0


def suma_un():
    comptador = 1          # crea una variable LOCAL; la global continua valent 0
    print("Dins:", comptador)


suma_un()
print("Fora:", comptador)
```

```text
Dins: 1
Fora: 0
```

Per modificar una variable global des d'una funció, s'ha de declarar amb `global`. És el que veuràs als programes de MakeCode de les [pràctiques](practiques/index.md):

```python
comptador = 0


def suma_un():
    global comptador
    comptador = comptador + 1


suma_un()
suma_un()
print(comptador)           # 2
```

!!! tip "Millor paràmetres i `return` que `global`"
    `global` és útil en casos com els programes per esdeveniments de la micro:bit, però en un programa normal és millor que les funcions rebin les dades pels paràmetres i tornin el resultat amb `return`. Així cada funció és independent i es pot entendre i provar per separat.

!!! example "Exercici 10.5. Què mostra?"
    Sense executar-lo, digues què mostra aquest programa.

    ```python
    x = 10


    def canvia(x):
        x = x * 2
        return x


    def mostra():
        print("x val", x)


    y = canvia(x)
    print(x, y)
    mostra()
    ```

    ??? success "Solució"
        ```text
        10 20
        x val 10
        ```

        Dins `canvia`, `x` és el **paràmetre**, una variable local que comença valent 10 i passa a valer 20; la `x` global no canvia. `mostra()` no té cap `x` pròpia i llegeix la global, que continua valent 10.

## 10.6. Documentar les funcions

A la unitat 9 vas veure la importància de comentar el codi. Les funcions es documenten amb un ***docstring***: un text entre tres cometes just a la primera línia del cos, que explica què fa la funció, què rep i què retorna.

```python
def preu_final(preu, descompte=0):
    """Calcula el preu final d'un producte.

    preu: preu original en euros.
    descompte: percentatge de descompte (0 per defecte).
    Retorna el preu amb el descompte aplicat, arrodonit a dos decimals.
    """
    return round(preu * (1 - descompte / 100), 2)
```

El *docstring* no és un simple comentari: Python el guarda, i es pot consultar amb `help(preu_final)`. VS Code el mostra quan passes el ratolí per damunt del nom de la funció.

## 10.7. Mòduls

Un **mòdul** és un fitxer de Python amb funcions (i variables) que es poden fer servir des d'altres programes. Python porta incorporats molts de mòduls, la **biblioteca estàndard**, i n'hi ha milers més que es poden instal·lar.

### 10.7.1. Importar un mòdul

Hi ha tres maneres d'importar un mòdul:

```python
import math                       # s'importa tot el mòdul
print(math.sqrt(16))              # 4.0: davant cada funció, el nom del mòdul
print(math.pi)                    # 3.141592653589793

from random import randint        # s'importa només una funció
print(randint(1, 6))              # sense el nom del mòdul davant

import statistics as st           # s'importa amb un nom més curt
print(st.median([3, 1, 4, 1, 5])) # 3
```

La primera és la més clara: en llegir `math.sqrt`, se sap d'on surt la funció.

Alguns mòduls de la biblioteca estàndard que et seran útils:

| Mòdul | Per a què serveix | Exemples |
| --- | --- | --- |
| `math` | Funcions matemàtiques | `math.sqrt(x)`, `math.pi`, `math.floor(x)`, `math.ceil(x)` |
| `random` | Nombres i eleccions aleatoris | `random.randint(1, 6)`, `random.choice(llista)`, `random.shuffle(llista)` |
| `statistics` | Estadística | `statistics.mean(llista)`, `statistics.median(llista)`, `statistics.mode(llista)` |
| `datetime` | Dates i hores | `datetime.date.today()` |
| `time` | Temps | `time.sleep(1)` (espera un segon) |

!!! example "Exercici 10.6. El sorteig"
    Fes un programa que, a partir de la llista `["Aina", "Biel", "Carla", "Dani", "Elena", "Fèlix"]`, triï a l'atzar una persona per a delegada i formi dos equips de tres persones barrejant la llista. Mostra també la mitjana i la mediana de les edats `[16, 17, 16, 18, 16, 17]` amb el mòdul `statistics`.

    ??? success "Solució"
        ```python
        import random
        import statistics

        alumnes = ["Aina", "Biel", "Carla", "Dani", "Elena", "Fèlix"]
        edats = [16, 17, 16, 18, 16, 17]

        print("Delegada o delegat:", random.choice(alumnes))

        random.shuffle(alumnes)        # barreja la llista
        print("Equip 1:", alumnes[:3])
        print("Equip 2:", alumnes[3:])

        print("Mitjana d'edat:", round(statistics.mean(edats), 2))
        print("Mediana d'edat:", statistics.median(edats))
        ```

        Els noms i els equips canvien a cada execució. La mitjana és 16.67 i la mediana, 16.5.

### 10.7.2. Crear un mòdul propi

Qualsevol fitxer `.py` és un mòdul. Si guardes funcions en un fitxer, les pots importar des d'un altre fitxer **de la mateixa carpeta**:

```python title="eines.py"
def llegeix_nombre(missatge):
    """Demana un nombre fins que l'usuari n'escriu un de vàlid."""
    while True:
        try:
            return float(input(missatge).replace(",", "."))
        except ValueError:
            print("No és un nombre vàlid. Exemple: 3.5")


def mitjana(llista):
    """Retorna la mitjana d'una llista, o None si és buida."""
    if len(llista) == 0:
        return None
    return sum(llista) / len(llista)
```

```python title="notes.py"
import eines

notes = []
for i in range(3):
    notes.append(eines.llegeix_nombre(f"Nota {i + 1}: "))

print("Mitjana:", round(eines.mitjana(notes), 2))
```

!!! warning "No posis al mòdul el nom d'un mòdul de Python"
    Si guardes un fitxer amb el nom `random.py` o `math.py`, Python l'importarà en lloc del mòdul original, i els programes deixaran de funcionar. Tria noms propis, com `eines.py` o `utilitats.py`.

### 10.7.3. Mòduls de tercers

A més de la biblioteca estàndard, hi ha milers de mòduls creats per altres programadors, que s'instal·len amb l'ordre `pip` des de la terminal de VS Code. Per exemple, `pip install matplotlib` instal·la una biblioteca per fer gràfics. Els estudiaràs a PTD II.

!!! example "Exercici 10.7. El teu mòdul de geometria"
    Crea un mòdul `geometria.py` amb tres funcions: `area_cercle(radi)`, `area_rectangle(base, altura)` i `area_triangle(base, altura)`. Fes servir `math.pi` per a la del cercle. Després, crea un programa `calcula.py` que l'importi i mostri l'àrea d'un cercle de radi 2, d'un rectangle de 4 × 3 i d'un triangle de base 6 i altura 4.

    ??? success "Solució"
        ```python title="geometria.py"
        import math


        def area_cercle(radi):
            return math.pi * radi ** 2


        def area_rectangle(base, altura):
            return base * altura


        def area_triangle(base, altura):
            return base * altura / 2
        ```

        ```python title="calcula.py"
        import geometria

        print(f"Cercle: {geometria.area_cercle(2):.2f}")         # 12.57
        print("Rectangle:", geometria.area_rectangle(4, 3))       # 12
        print("Triangle:", geometria.area_triangle(6, 4))         # 12.0
        ```

## 10.8. Reptes

!!! example "Repte 10.1. El xifratge de Cèsar, amb funcions"
    Reescriu el xifratge de Cèsar de la unitat 6 amb dues funcions: `xifra(text, desplacament)`, que retorna el text xifrat, i `desxifra(text, desplacament)`, que retorna el text original. `desxifra` no ha de repetir el codi de `xifra`. Comprova que `desxifra(xifra("hola", 3), 3)` torna `"hola"`.

    ??? success "Solució"
        ```python
        ALFABET = "abcdefghijklmnopqrstuvwxyz"


        def xifra(text, desplacament):
            """Xifra un text en minúscules amb el xifratge de Cèsar."""
            resultat = ""
            for caracter in text:
                if caracter in ALFABET:
                    posicio = (ALFABET.index(caracter) + desplacament) % len(ALFABET)
                    resultat += ALFABET[posicio]
                else:
                    resultat += caracter
            return resultat


        def desxifra(text, desplacament):
            """Desfà el xifratge de Cèsar: desplaçar cap enrere és xifrar amb el desplaçament contrari."""
            return xifra(text, -desplacament)


        secret = xifra("ens veim a les cinc", 3)
        print(secret)                     # hqv yhlp d ohv flqf
        print(desxifra(secret, 3))        # ens veim a les cinc
        print(desxifra(xifra("hola", 3), 3) == "hola")   # True
        ```

        Desxifrar amb un desplaçament de 3 és el mateix que xifrar amb un desplaçament de −3. Per això `desxifra` només ha de cridar `xifra`. L'operador `%` també funciona amb nombres negatius: `-1 % 26` val 25.

!!! example "Repte 10.2. La llista de la compra, en funcions"
    Reprèn la llista de la compra de l'exercici 7.6 i reorganitza-la en funcions: `mostra_menu()`, `afegeix(llista)`, `elimina(llista)`, `mostra(llista)` i un programa principal amb el bucle del menú. Cap funció no ha de fer servir `global`: la llista es passa com a paràmetre.

    ??? success "Solució"
        ```python
        def mostra_menu():
            print("\n1. Afegir un producte")
            print("2. Eliminar un producte")
            print("3. Veure la llista")
            print("0. Sortir")


        def afegeix(llista):
            producte = input("Producte: ").strip().lower()
            if producte in llista:
                print("Ja hi és")
            else:
                llista.append(producte)
                print("Afegit:", producte)


        def elimina(llista):
            producte = input("Producte que vols eliminar: ").strip().lower()
            if producte in llista:
                llista.remove(producte)
                print("Eliminat:", producte)
            else:
                print("No és a la llista")


        def mostra(llista):
            if len(llista) == 0:
                print("La llista és buida")
            for i, producte in enumerate(llista, start=1):
                print(f"{i}. {producte}")


        compra = []
        opcio = ""
        while opcio != "0":
            mostra_menu()
            opcio = input("Opció: ")
            match opcio:
                case "1":
                    afegeix(compra)
                case "2":
                    elimina(compra)
                case "3":
                    mostra(compra)
                case "0":
                    print("Fins aviat!")
                case _:
                    print("Opció no vàlida")
        ```

        Les funcions **modifiquen** la llista que reben perquè les llistes són mutables: la funció i el programa principal treballen sobre la mateixa llista. Amb un nombre o una cadena no passaria. `enumerate(llista, start=1)` retorna parelles (número, element) i estalvia un comptador.

## 10.9. Exercicis de repàs

Més exercicis per practicar tota la unitat, ordenats de menys a més dificultat. A tots, les funcions han de **retornar** el resultat; els `print` van al programa principal, excepte quan l'enunciat demana mostrar alguna cosa.

!!! example "Repàs 10.1. Definició o crida?"
    En aquest programa, quines línies defineixen una funció, quines la criden i quins són els paràmetres i els arguments? Què mostra?

    ```python
    def resta(a, b):
        return a - b

    x = resta(10, 4)
    print(resta(x, 1))
    print(resta(b=10, a=4))
    ```

    ??? success "Solució"
        La primera línia defineix la funció `resta`, amb els paràmetres `a` i `b`. Hi ha tres crides: `resta(10, 4)`, amb els arguments 10 i 4; `resta(x, 1)`, amb 6 i 1; i `resta(b=10, a=4)`, amb arguments amb nom. Mostra `5` i `-6`: a la darrera crida, `a` val 4 i `b` val 10.

!!! example "Repàs 10.2. Caça d'errors"
    Aquest programa té tres errors. Troba'ls i corregeix-los.

    ```python
    print(quadrat(4))

    def quadrat(n)
        resultat = n * n

    print("Fi")
    ```

    ??? success "Solució"
        ```python
        def quadrat(n):
            return n * n


        print(quadrat(4))
        print("Fi")
        ```

        1. Es cridava la funció abans de definir-la.
        2. Faltaven els dos punts al `def`.
        3. La funció calculava el resultat però no el retornava: `print(quadrat(4))` hauria mostrat `None`.

!!! example "Repàs 10.3. El major de tres"
    Escriu `maxim3(a, b, c)`, que retorni el més gran de tres nombres sense fer servir `max()`.

    ??? success "Solució"
        ```python
        def maxim3(a, b, c):
            if a >= b and a >= c:
                return a
            elif b >= c:
                return b
            return c


        print(maxim3(3, 9, 5), maxim3(9, 3, 5), maxim3(3, 5, 9))   # 9 9 9
        ```

!!! example "Repàs 10.4. Any de traspàs"
    Escriu `es_de_traspas(any)`, que retorni `True` si un any és de traspàs: és múltiple de 4, excepte els múltiples de 100 que no ho són de 400. Prova-la amb 2024, 2026, 1900 i 2000.

    ??? success "Solució"
        ```python
        def es_de_traspas(a):
            return a % 4 == 0 and (a % 100 != 0 or a % 400 == 0)


        for a in [2024, 2026, 1900, 2000]:
            print(a, es_de_traspas(a))
        ```

        ```text
        2024 True
        2026 False
        1900 False
        2000 True
        ```

        S'ha canviat el nom del paràmetre per `a`: `any` és el nom d'una funció de Python i no convé fer-lo servir com a variable.

!!! example "Repàs 10.5. Nombres primers"
    Escriu `es_primer(n)` i fes-la servir per mostrar tots els nombres primers fins a 50. Compara el programa amb el de l'exercici de repàs 5.21: és més fàcil de llegir?

    ??? success "Solució"
        ```python
        def es_primer(n):
            if n < 2:
                return False
            for d in range(2, n):
                if n % d == 0:
                    return False
            return True


        for n in range(1, 51):
            if es_primer(n):
                print(n, end=" ")
        print()
        ```

        `2 3 5 7 11 13 17 19 23 29 31 37 41 43 47`. El `return False` dins el bucle fa la feina del `break` i de la bandera de la unitat 5, i el programa principal es llegeix com una frase.

!!! example "Repàs 10.6. Paraules"
    Escriu tres funcions sobre cadenes i prova-les: `es_palindrom(text)`, que no tengui en compte els espais ni les majúscules; `inicials(nom_complet)`, que retorni les inicials en majúscules (`"aina ferrer pons"` → `"AFP"`); i `paraula_mes_llarga(frase)`.

    ??? success "Solució"
        ```python
        def es_palindrom(text):
            net = text.replace(" ", "").lower()
            return net == net[::-1]


        def inicials(nom_complet):
            resultat = ""
            for paraula in nom_complet.split():
                resultat += paraula[0].upper()
            return resultat


        def paraula_mes_llarga(frase):
            mes_llarga = ""
            for paraula in frase.split():
                if len(paraula) > len(mes_llarga):
                    mes_llarga = paraula
            return mes_llarga


        print(es_palindrom("Radar"), es_palindrom("Mallorca"))  # True False
        print(inicials("aina ferrer pons"))                     # AFP
        print(paraula_mes_llarga("la programació és divertida"))  # programació
        ```

!!! example "Repàs 10.7. Estadístiques d'una llista"
    Escriu `estadistiques(llista)`, que retorni quatre valors alhora: el mínim, el màxim, la mitjana i quants elements superen la mitjana. Desempaqueta'ls en quatre variables i mostra'ls.

    ??? success "Solució"
        ```python
        def estadistiques(llista):
            mitjana = sum(llista) / len(llista)
            per_sobre = 0
            for valor in llista:
                if valor > mitjana:
                    per_sobre += 1
            return min(llista), max(llista), mitjana, per_sobre


        minim, maxim, mitj, sobre = estadistiques([6, 8, 4, 9, 7])
        print(minim, maxim, mitj, sobre)    # 4 9 6.8 3
        ```

!!! example "Repàs 10.8. Una funció que en crida una altra"
    Escriu `nota_final(examens, treball)`: `examens` és una llista de notes que compten un 70 %, i `treball` és una nota que compta un 30 %. La funció ha de fer servir la funció `mitjana` de l'exercici 10.3 i retornar la nota final arrodonida a un decimal.

    ??? success "Solució"
        ```python
        def mitjana(llista):
            if len(llista) == 0:
                return None
            return sum(llista) / len(llista)


        def nota_final(examens, treball):
            return round(mitjana(examens) * 0.7 + treball * 0.3, 1)


        print(nota_final([6, 7.5, 8], 9))    # 7.7
        ```

!!! example "Repàs 10.9. Validar un DNI amb funcions"
    Reorganitza la comprovació del DNI de l'exercici de repàs 6.19 en dues funcions: `lletra_dni(numero)`, que retorni la lletra que correspon a un número, i `dni_valid(dni)`, que retorni `True` o `False`. El programa principal només ha de demanar el DNI i mostrar el resultat.

    ??? success "Solució"
        ```python
        LLETRES = "TRWAGMYFPDXBNJZSQVHLCKE"


        def lletra_dni(numero):
            return LLETRES[numero % 23]


        def dni_valid(dni):
            dni = dni.strip().upper()
            if len(dni) != 9 or not dni[:8].isdigit():
                return False
            return dni[8] == lletra_dni(int(dni[:8]))


        dni = input("DNI: ")
        if dni_valid(dni):
            print("DNI correcte")
        else:
            print("DNI incorrecte")
        ```

        Amb `12345678Z` mostra «DNI correcte», i amb `12345678A`, «DNI incorrecte».

!!! example "Repàs 10.10. Un mòdul de conversions"
    Crea un mòdul `conversions.py` amb les funcions `celsius_a_fahrenheit(c)`, `km_a_milles(km)` i `euros_a_lliures(euros, canvi)`, totes amb el seu *docstring*. Després escriu un programa que l'importi amb `import conversions as conv` i converteixi 25 °C, 10 km i 50 € amb un canvi de 0,85. Mostra els resultats amb dos decimals.

    ??? success "Solució"
        ```python title="conversions.py"
        def celsius_a_fahrenheit(c):
            """Converteix una temperatura de graus Celsius a graus Fahrenheit."""
            return c * 9 / 5 + 32


        def km_a_milles(km):
            """Converteix quilòmetres a milles."""
            return km / 1.609344


        def euros_a_lliures(euros, canvi):
            """Converteix euros a lliures amb el canvi indicat (lliures per euro)."""
            return euros * canvi
        ```

        ```python title="programa.py"
        import conversions as conv

        print(f"{conv.celsius_a_fahrenheit(25):.2f} °F")    # 77.00 °F
        print(f"{conv.km_a_milles(10):.2f} milles")         # 6.21 milles
        print(f"{conv.euros_a_lliures(50, 0.85):.2f} £")    # 42.50 £
        ```

        El canvi entre l'euro i la lliura varia cada dia: per això és un paràmetre i no un valor fix dins la funció.

!!! example "Repàs 10.11. Endevina el nombre"
    Programa el joc d'endevinar un nombre de l'1 al 100 amb aquestes funcions: `demana_enter(missatge, minim, maxim)`, que torni a demanar la dada fins que sigui un enter dins el rang; `pista(secret, intent)`, que retorni «Més gran», «Més petit» o «Encertat!»; i un programa principal que compti els intents.

    ??? success "Solució"
        ```python
        import random


        def demana_enter(missatge, minim, maxim):
            while True:
                try:
                    n = int(input(missatge))
                    if minim <= n <= maxim:
                        return n
                    print(f"Ha de ser entre {minim} i {maxim}")
                except ValueError:
                    print("Escriu un nombre enter")


        def pista(secret, intent):
            if intent < secret:
                return "Més gran"
            elif intent > secret:
                return "Més petit"
            return "Encertat!"


        secret = random.randint(1, 100)
        intents = 0
        resposta = ""
        while resposta != "Encertat!":
            intent = demana_enter("Quin nombre és? ", 1, 100)
            intents += 1
            resposta = pista(secret, intent)
            print(resposta)

        print("Ho has aconseguit en", intents, "intents")
        ```

!!! example "Repàs 10.12. Funcions que reben funcions (amplia)"
    En Python, una funció també és un valor i es pot passar com a argument. La funció `sorted()` té un paràmetre `key` que rep una funció i ordena segons el que aquesta retorna. Fes servir `sorted()` amb `key=len` per ordenar la llista `["kiwi", "poma", "mandarina", "figa", "plàtan"]` per la longitud de les paraules, i després amb una funció pròpia `darrera_lletra(paraula)` per ordenar-la per la darrera lletra.

    ??? success "Solució"
        ```python
        def darrera_lletra(paraula):
            return paraula[-1]


        fruites = ["kiwi", "poma", "mandarina", "figa", "plàtan"]
        print(sorted(fruites, key=len))
        print(sorted(fruites, key=darrera_lletra))
        ```

        ```text
        ['kiwi', 'poma', 'figa', 'plàtan', 'mandarina']
        ['poma', 'mandarina', 'figa', 'kiwi', 'plàtan']
        ```

        Fixa't que s'escriu `key=len` i no `key=len()`: es passa la funció, no el resultat de cridar-la. Quan dos elements empaten, `sorted()` en conserva l'ordre original.

---

!!! quote "Fonts"
    Unitat de material propi. S'hi recomana el [curs de Python](https://youtu.be/Kp4Mvapo5kc) de Brais Moure (MoureDev), lliçons 12 i 15; no se'n reprodueix el codi. Els exercicis reprenen programes de les unitats 6, 7 i 9 (xifratge de Cèsar, llista de la compra, validació d'entrades i DNI) per mostrar com els milloren les funcions. Totes les solucions s'han executat amb Python.
