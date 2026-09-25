# Unitat 3. Variables, tipus de dades i operadors

Quan escrivim programes, el que feim és **operacions amb dades**. A l'exemple de l'àrea del triangle, les dades eren la base, l'altura i l'àrea, i les operacions, multiplicar, dividir i mostrar el resultat a la pantalla. En aquesta unitat veurem com guarda Python les dades, de quins tipus poden ser, com s'hi opera i com es converteixen d'un tipus a un altre. També veurem com un programa es comunica amb l'usuari.

## 3.1. Tipus de dades

Hi ha molts de tipus de dades. Si treballam amb el pes d'una persona, necessitarem un nombre amb decimals, com 84,25 kg. Si volem comptar quantes persones han anat a un concert, farem servir un nombre enter, perquè no té sentit dir que hi han anat 13.437,6 persones. I si volem treballar amb els noms dels dies de la setmana, necessitam un tipus de dada que manegi text, com "dilluns", "dijous" o "dissabte".

Els quatre tipus bàsics de dades de Python són:

| Tipus | Nom en Python | Què representa | Exemple |
| --- | --- | --- | --- |
| Enter | `int` | Nombres sense part decimal | `x = 5` |
| Real o de coma flotant | `float` | Nombres amb part decimal | `y = 3.14` |
| Cadena de caràcters | `str` | Text, entre cometes simples o dobles | `missatge = "Hola, món"` |
| Booleà | `bool` | Vertader (`True`) o fals (`False`); útil per decidir entre dos estats | `sessio_iniciada = True` |

!!! warning "Compte amb la coma decimal"
    En Python, els decimals s'escriuen amb **punt**, no amb coma: `3.14` és un nombre real, però `3,14` Python no l'interpreta com un nombre.

!!! info "I el tipus caràcter (`char`)?"
    Molts de llenguatges, com C o Java, tenen un tipus específic per a un sol caràcter, anomenat `char`. **Python no el té**: un caràcter és simplement una cadena de longitud 1, com `"a"`. Internament, però, cada caràcter es guarda com un nombre. Les funcions `ord()` i `chr()` permeten passar d'un caràcter al seu codi numèric i a l'inrevés:

    ```python
    print(ord("A"))   # 65
    print(chr(97))    # a
    ```

Pots saber de quin tipus és qualsevol dada amb la funció `type()`:

```python
print(type(5))        # <class 'int'>
print(type(3.14))     # <class 'float'>
print(type("Hola"))   # <class 'str'>
print(type(True))     # <class 'bool'>
```

!!! example "Exercici 3.1. Quin tipus és?"
    Sense executar-ho, digues de quin tipus és cada valor. Després comprova-ho amb `type()`.

    `7` · `7.0` · `"7"` · `7 / 2` · `7 // 2` · `True` · `"True"`

    ??? success "Solució"
        `int`, `float`, `str`, `float`, `int`, `bool` i `str`.

        Fixa't en dos casos: `7 / 2` sempre dona un `float` (3.5), encara que els dos nombres siguin enters, i `"True"` és un text perquè va entre cometes.

## 3.2. Variables

Quan treballam amb dades, les hem de guardar en algun lloc per poder-les utilitzar tantes vegades com calgui al llarg del programa. Aquests llocs són les **variables**: espais de la memòria de l'ordinador on es guarden dades.

Pensa en les variables com en un calaix amb un nom. Normalment tenim un calaix per a les camisetes, un altre per als banyadors i un altre per als complements. El calaix pot estar buit o tenir coses a dins; hi podem posar coses i treure-les. Les variables funcionen igual: el calaix és un espai de memòria on podem guardar dades, canviar-les o esborrar-les. Per accedir a aquestes dades utilitzam el nom de la variable, que és l'identificador que posam a aquest espai de memòria.

En Python no cal declarar el tipus d'una variable: s'endevina a partir del valor que s'hi assigna.

```python
edat = 25
nom = "Joan"
altura = 1.75
es_estudiant = True
```

Aquí, les variables són `edat`, `nom`, `altura` i `es_estudiant`, i guarden, respectivament, les dades `25`, `"Joan"`, `1.75` i `True`.

!!! tip "Com posar nom a les variables"
    - Els noms poden tenir lletres, xifres i el caràcter `_`, però **no poden començar per una xifra** ni contenir espais.
    - Python distingeix majúscules i minúscules: `edat` i `Edat` són variables diferents.
    - No es poden utilitzar paraules reservades del llenguatge, com `if`, `for` o `print`.
    - Tria noms que expliquin què contenen: `preu_total` és molt més clar que `pt` o `x`.
    - Per convenció, en Python els noms de variables s'escriuen en minúscules i amb les paraules separades per `_`.

!!! example "Exercici 3.2. Noms vàlids"
    Quins d'aquests noms de variable són vàlids en Python? Per què no ho són els altres?

    `edat2` · `2edat` · `preu total` · `preu_total` · `for` · `Nom` · `nota-final`

    ??? success "Solució"
        Són vàlids `edat2`, `preu_total` i `Nom` (encara que, per convenció, les variables s'escriuen en minúscules).

        No ho són `2edat` (comença per una xifra), `preu total` (té un espai), `for` (és una paraula reservada) i `nota-final` (Python interpreta el guionet com una resta: `nota - final`).

!!! example "Exercici 3.3. Intercanviar dues variables"
    Tens `a = 5` i `b = 8`. Escriu les instruccions necessàries perquè `a` valgui 8 i `b` valgui 5, sense escriure cap d'aquests nombres. Pista: pensa en com intercanviaries el contingut de dos gots plens.

    ??? success "Solució"
        Cal un tercer «got», una variable auxiliar:

        ```python
        a = 5
        b = 8
        aux = a
        a = b
        b = aux
        print(a, b)   # 8 5
        ```

        Si escrius `a = b` i després `b = a`, les dues variables acaben valent 8, perquè el 5 s'ha perdut en la primera assignació. Python també permet fer-ho en una sola línia, `a, b = b, a`, que veurem a la unitat 5.

## 3.3. Constants

En molts de llenguatges hi ha un tipus especial de variables, les **constants**: funcionen igual que les variables, però un cop se'ls assigna un valor, no es pot canviar. Una variable que no varia? Exacte.

Python no té una manera estricta de definir constants, però **per convenció** s'escriuen amb majúscules per indicar que el seu valor no s'ha de modificar:

```python
PI = 3.14159
GRAVETAT = 9.81
```

## 3.4. Operadors

Els operadors permeten fer càlculs, comparacions i operacions lògiques amb les dades.

### 3.4.1. Operadors aritmètics

S'utilitzen per fer les operacions matemàtiques bàsiques. Suposem que `a = 10` i `b = 5`:

| Operador | Operació | Exemple | Resultat |
| --- | --- | --- | --- |
| `+` | Suma | `a + b` | `15` |
| `-` | Resta | `a - b` | `5` |
| `*` | Multiplicació | `a * b` | `50` |
| `/` | Divisió (sempre dona un `float`) | `a / b` | `2.0` |
| `//` | Divisió entera (quocient sense decimals) | `a // b` | `2` |
| `%` | Mòdul (residu de la divisió) | `a % b` | `0` |
| `**` | Potència | `a ** b` | `100000` |

!!! tip "Per a què serveix el mòdul?"
    L'operador `%` és molt més útil del que sembla. Per exemple, un nombre `n` és parell si `n % 2 == 0`, i `n % 10` et dona la darrera xifra de `n`.

!!! example "Exercici 3.4. Calcula sense ordinador"
    Quin és el resultat de cada operació?

    `17 / 5` · `17 // 5` · `17 % 5` · `2 ** 10` · `10 % 2` · `7 % 10`

    ??? success "Solució"
        `3.4`, `3`, `2`, `1024`, `0` i `7`. Quan el dividend és més petit que el divisor, el quocient enter és 0 i el residu és el mateix dividend: per això `7 % 10` dona 7.

!!! example "Exercici 3.5. Hores, minuts i segons"
    La variable `total = 3725` conté una durada en segons. Escriu les instruccions que calculin i mostrin quantes hores, minuts i segons són (1 h, 2 min i 5 s). Pista: fes servir `//` i `%`. Prova-ho també amb altres valors.

    ??? success "Solució"
        ```python
        total = 3725
        hores = total // 3600
        minuts = (total % 3600) // 60
        segons = total % 60
        print(hores, "h,", minuts, "min i", segons, "s")
        ```

        `total % 3600` són els segons que sobren després de treure les hores completes; dividint-los entre 60 obtenim els minuts.

### 3.4.2. Operadors de comparació

S'utilitzen per comparar dos valors i sempre donen un resultat booleà (`True` o `False`). És com fer una pregunta que es respon amb sí o no. Per exemple, tens més de 18 anys? No. En Python es faria així: `edat > 18`, i el resultat seria `False`.

Suposem que `a = 7` i `b = 12`:

| Operador | Significat | Exemple | Resultat |
| --- | --- | --- | --- |
| `==` | Igual a | `a == b` | `False` |
| `!=` | Diferent de | `a != b` | `True` |
| `>` | Major que | `a > b` | `False` |
| `>=` | Major o igual que | `a >= 7` | `True` |
| `<` | Menor que | `a < b` | `True` |
| `<=` | Menor o igual que | `b <= 10` | `False` |

!!! warning "No confonguis `=` i `==`"
    Un sol `=` **assigna** un valor a una variable (`a = 7`). Dos `==` **comparen** dos valors (`a == 7`).

!!! example "Exercici 3.6. Vertader o fals?"
    Amb `a = 7` i `b = 12`, quin és el resultat de cada comparació?

    `a * 2 > b` · `a + 5 == b` · `b % a != 0` · `"abc" == "ABC"`

    ??? success "Solució"
        `True`, `True`, `True` i `False`. A l'última, Python distingeix majúscules i minúscules: per a ell, `"abc"` i `"ABC"` són textos diferents.

### 3.4.3. Operadors lògics

Permeten treballar amb valors booleans, i el resultat també és booleà.

- **`and`** (i): dona `True` si els dos valors són `True`; si qualsevol dels dos és `False`, el resultat és `False`. És molt intuïtiu: si el semàfor és verd **i** no vénen cotxes, travessam. Dit en Python: `travessar = semafor_verd and no_venen_cotxes`.
- **`or`** (o): dona `True` quan almenys un dels dos valors és `True`.
- **`not`** (no): inverteix el valor: `True` passa a ser `False` i a l'inrevés.

| `A` | `B` | `A and B` | `A or B` | `not A` |
| --- | --- | --- | --- | --- |
| `True` | `True` | `True` | `True` | `False` |
| `True` | `False` | `False` | `True` | `False` |
| `False` | `True` | `False` | `True` | `True` |
| `False` | `False` | `False` | `False` | `True` |

L'ordre en què s'apliquen aquests operadors pot canviar el resultat. De més a menys prioritat, primer s'aplica `not`, després `and` i finalment `or`.

!!! example "Exercici 3.7. Endevina el resultat"
    Esbrina el resultat d'aquestes instruccions **sense executar-les**. Després comprova-ho amb Python.

    ```python
    print(False and False or True)
    print(True or False and False)
    print(not True or 5 > 3 and 2 == 2)
    ```

    ??? success "Solució"
        `True`, `True` i `True`. A la tercera, primer s'avaluen les comparacions (`5 > 3` és `True` i `2 == 2` és `True`); després `not True` (que és `False`); després `and` (`True and True` és `True`), i finalment `or` (`False or True` és `True`).

!!! example "Exercici 3.8. Escriu la condició"
    Suposant que `n` és una variable amb un nombre enter, escriu una expressió que sigui `True` quan:

    1. `n` és entre 1 i 10, tots dos inclosos.
    2. `n` és parell o múltiple de 5.
    3. `n` no és zero i és negatiu.

    ??? success "Solució"
        1. `n >= 1 and n <= 10`
        2. `n % 2 == 0 or n % 5 == 0`
        3. `n != 0 and n < 0` (de fet, n'hi ha prou amb `n < 0`, perquè un nombre negatiu mai no és zero)

### 3.4.4. Expressions compostes i precedència

Les **expressions compostes** combinen diversos operadors. Per avaluar-les bé, cal conèixer l'**ordre de precedència**, que és semblant al de les matemàtiques. De més a menys prioritat:

1. Parèntesis `()`.
2. Potència `**`.
3. Signes `+` i `-` davant d'un valor (per exemple, `-a`).
4. Multiplicació `*`, divisió `/`, divisió entera `//` i mòdul `%`.
5. Suma `+` i resta `-`.
6. Comparacions: `==`, `!=`, `>`, `<`, `>=`, `<=`.
7. Operadors lògics: `not`, `and`, `or`.

```python
a = 5
b = 3
c = 2
d = 4

# Primer (a + b) = 8, després 8 * c = 16 i finalment 16 / d = 4.0
resultat = (a + b) * c / d

# c ** d = 16; b * 16 = 48; a / b = 1.666...; 5 + 48 - 1.666... = 51.333...
resultat = a + b * c ** d - (a / b)
```

!!! tip "Consell"
    Quan tenguis dubtes sobre l'ordre, posa-hi parèntesis. No canvien el resultat si ja era l'ordre correcte i fan el codi molt més fàcil de llegir.

!!! example "Exercici 3.9. Ordre de les operacions"
    Calcula el resultat sense ordinador i després comprova'l:

    `2 + 3 * 4` · `(2 + 3) * 4` · `10 - 4 - 3` · `20 / 2 * 5` · `-2 ** 2` · `2 ** 3 ** 2`

    ??? success "Solució"
        `14`, `20`, `3`, `50.0`, `-4` i `512`.

        Els dos darrers sorprenen sovint. `-2 ** 2` dona -4 perquè la potència té més prioritat que el signe: es calcula `-(2 ** 2)`. I `2 ** 3 ** 2` dona 512 perquè les potències encadenades es calculen de dreta a esquerra: `2 ** (3 ** 2)`, és a dir, `2 ** 9`. En canvi, les restes i les divisions encadenades es calculen d'esquerra a dreta.

### 3.4.5. Operadors amb cadenes de text

Les cadenes també admeten alguns operadors. El `+` **concatena** (uneix) cadenes i el `*` les **repeteix**:

```python
nom = "Joan"
salutacio = "Hola, " + nom + "!"   # "Hola, Joan!"
repeticio = "Hola" * 3             # "HolaHolaHola"
```

A la unitat 6 veurem moltes més coses que es poden fer amb les cadenes.

!!! example "Exercici 3.10. Un títol emmarcat"
    Fes que el programa mostri aquest títol, fent servir l'operador `*` per a les línies:

    ```text
    ====================
       BENVINGUTS
    ====================
    ```

    ??? success "Solució"
        ```python
        linia = "=" * 20
        print(linia)
        print("   BENVINGUTS")
        print(linia)
        ```

## 3.5. Conversions de tipus

Sovint necessitam convertir una dada d'un tipus a un altre. Per exemple, no podem sumar un nombre i un text: `"5" + 3` provoca un error. Python té funcions per fer aquestes conversions:

| Funció | Converteix a | Exemple | Resultat |
| --- | --- | --- | --- |
| `int()` | Enter | `int("42")` | `42` |
| | | `int(3.99)` | `3` (elimina els decimals, no arrodoneix) |
| `float()` | Real | `float("2.5")` | `2.5` |
| | | `float(7)` | `7.0` |
| `str()` | Cadena | `str(25)` | `"25"` |
| `bool()` | Booleà | `bool(0)` | `False` (qualsevol altre nombre dona `True`) |
| `round()` | Enter arrodonit | `round(3.7)` | `4` |

```python
edat = 16
missatge = "Tens " + str(edat) + " anys"   # sense str() donaria error
print(missatge)

preu = float("19.95")
print(preu * 2)   # 39.9
```

Si la conversió no és possible, Python dona un error. Per exemple, `int("hola")` o `int("3.5")` provoquen un `ValueError`, perquè aquestes cadenes no representen un nombre enter.

!!! info "Conversions automàtiques"
    En algunes operacions, Python converteix els tipus automàticament. Per exemple, si sumes un `int` i un `float`, el resultat és un `float`: `2 + 0.5` dona `2.5`. En canvi, mai no converteix automàticament entre text i nombres.

!!! example "Exercici 3.11. Conversions"
    Quin és el resultat de cada instrucció? N'hi ha dues que donen error: quines i per què?

    `int("7") + 3` · `"7" + str(3)` · `int(7.9)` · `float("3")` · `int("3.5")` · `"7" + 3`

    ??? success "Solució"
        `10`, `"73"`, `7`, `3.0`, error i error.

        `int("3.5")` dona `ValueError` perquè la cadena no representa un nombre enter (per convertir-la cal `float("3.5")`). `"7" + 3` dona `TypeError` perquè Python no suma textos amb nombres: s'ha de convertir abans l'un o l'altre.

## 3.6. Interacció amb l'usuari

Quan programam, la interacció amb l'usuari és molt important: ens permet mostrar-li dades (sortida o *output*) i llegir les dades que introdueix pel teclat (entrada o *input*).

### 3.6.1. Mostrar dades a la pantalla

Python utilitza la funció `print()` per mostrar dades a la pantalla. És molt flexible i permet mostrar text, variables i resultats d'expressions.

```python
print(valor1, valor2, ..., sep=' ', end='\n')
```

On:

- `valor1`, `valor2`… són els valors que volem mostrar: text, nombres, variables, etc.
- `sep` indica el separador entre els valors (per defecte, un espai).
- `end` indica què es mostra al final (per defecte, un salt de línia).

```python
# Mostrar un text
print("Hola, món")

# Mostrar diversos valors
nom = "Joan"
edat = 25
print("Nom:", nom, "Edat:", edat)

# Canviar el separador i el final de línia
print("Python", "és", "genial", sep="-", end="!\n")   # Python-és-genial!
```

Sovint és més còmode fer servir les **f-strings** (cadenes amb format): es posa una `f` davant de les cometes i les variables entre claus `{}`:

```python
nom = "Anna"
edat = 30
print(f"Nom: {nom}, edat: {edat}")

preu = 12.3456
print(f"Preu: {preu:.2f} €")   # Preu: 12.35 € (dues xifres decimals)
```

### 3.6.2. Llegir dades del teclat

La funció `input()` llegeix les dades que l'usuari escriu pel teclat. **Sempre retorna una cadena de text**, de manera que, si esperam un nombre, l'hem de convertir al tipus adequat.

```python
# Llegir un text
nom = input("Com et dius? ")
print("Hola,", nom)

# Llegir un nombre enter
edat = int(input("Quants d'anys tens? "))
print("Tens", edat, "anys")

# Llegir un nombre real
altura = float(input("Quant mesures, en metres? "))
print("Mesures", altura, "metres")
```

!!! warning "Error freqüent"
    Si oblides la conversió, el programa no funcionarà com esperes:

    ```python
    num = input("Escriu un nombre: ")   # l'usuari escriu 5
    print(num * 2)                      # mostra 55, no 10!
    ```

    `num` és la cadena `"5"`, i `"5" * 2` repeteix la cadena. La solució és `num = int(input("Escriu un nombre: "))`.

!!! example "Exercici 3.12. Conversor de temperatura"
    Escriu un programa que demani una temperatura en graus Celsius i la mostri en graus Fahrenheit. La fórmula és F = C × 9 / 5 + 32.

    ??? success "Solució"
        ```python
        celsius = float(input("Temperatura en graus Celsius: "))
        fahrenheit = celsius * 9 / 5 + 32
        print(f"{celsius} °C són {fahrenheit} °F")
        ```

!!! example "Exercici 3.13. La factura del bar"
    Escriu un programa que demani el preu d'un entrepà, el d'una beguda i quants de companys sou. Ha de mostrar el total i quant ha de pagar cadascú, amb dues xifres decimals.

    ??? success "Solució"
        ```python
        entrepa = float(input("Preu de l'entrepà: "))
        beguda = float(input("Preu de la beguda: "))
        persones = int(input("Quantes persones sou? "))
        total = (entrepa + beguda) * persones
        print(f"Total: {total:.2f} €")
        print(f"Cadascú paga: {total / persones:.2f} €")
        ```

## 3.7. Reptes

Aquests reptes combinen tot el que has après a la unitat.

!!! example "Repte 3.1. Caràcters i codis"
    Escriu un programa que demani una lletra a l'usuari i mostri el seu codi numèric amb `ord()`. Després, que mostri la lletra següent de l'alfabet fent servir `chr()`. Què passa si escrius la `z`?

    ??? success "Solució"
        ```python
        lletra = input("Escriu una lletra: ")
        codi = ord(lletra)
        print(f"El codi de '{lletra}' és {codi}")
        print(f"La lletra següent és '{chr(codi + 1)}'")
        # Amb la z, surt '{', que és el caràcter següent a la taula de codis
        ```

!!! example "Repte 3.2. El canvi en monedes"
    Una màquina expenedora ha de tornar el canvi amb el menor nombre de monedes possible. Escriu un programa que demani l'import del canvi **en cèntims** i mostri quantes monedes de 2 €, 1 €, 50, 20, 10, 5, 2 i 1 cèntims ha de tornar. Per exemple, 387 cèntims són 1 moneda de 2 €, 1 d'1 €, 1 de 50, 1 de 20, 1 de 10, 1 de 5 i 1 de 2. Pista: `//` i `%`, com a l'exercici 3.5.

    ??? success "Solució"
        ```python
        canvi = int(input("Canvi en cèntims: "))

        m200 = canvi // 200
        canvi = canvi % 200
        m100 = canvi // 100
        canvi = canvi % 100
        m50 = canvi // 50
        canvi = canvi % 50
        m20 = canvi // 20
        canvi = canvi % 20
        m10 = canvi // 10
        canvi = canvi % 10
        m5 = canvi // 5
        canvi = canvi % 5
        m2 = canvi // 2
        m1 = canvi % 2

        print(f"2 €: {m200}  1 €: {m100}  50 c: {m50}  20 c: {m20}")
        print(f"10 c: {m10}  5 c: {m5}  2 c: {m2}  1 c: {m1}")
        ```

        Si et sembla que hi ha massa línies repetides, tens raó: a la unitat 7 veurem com fer-ho amb una llista i un bucle.

---

!!! quote "Font"
    Unitat elaborada a partir de materials de Lope González Vázquez ([CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ca)): [«Tema 11. Fundamentos de programación»](https://lopegonzalez.es/eso-y-bachillerato/tic-i-1o-bachillerato/tema-11-fundamentos-de-programacion/) (TIC I) i [«Tema 1. Introducción a la programación»](https://lopegonzalez.es/eso-y-bachillerato/creacion-digital-y-pensamiento-computacional-1o-bachillerato/tema-1-introduccion-a-la-programacion/) (Creación digital y pensamiento computacional). Canvis: traducció al català, adaptació al currículum de Programació i Tractament de Dades I de les Illes Balears i reorganització en taules. Són propis l'apartat 3.5 (conversions de tipus), els requadres sobre el tipus `char`, els noms de variables, la coma decimal i l'error freqüent amb `input()`, tots els exercicis i reptes i totes les solucions, excepte les dues primeres expressions de l'exercici 3.7 i l'enunciat de l'exercici 3.12, que provenen de Lope.
