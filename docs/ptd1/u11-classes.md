# Unitat 11. Introducció a les classes

Fins ara, les dades i les funcions que hi treballen anaven per separat: una llista amb les notes i, a part, una funció `mitjana(notes)`. La **programació orientada a objectes** (POO) les ajunta: un **objecte** guarda les seves dades i sap fer coses amb elles. És la manera de programar de la majoria d'aplicacions grans, i la base del curs de Java de PTD II. En aquesta unitat en veuràs els conceptes bàsics amb Python.

!!! tip "Vídeo recomanat"
    Curs de Python de MoureDev: [lliçó 13, «Classes»](https://youtu.be/Kp4Mvapo5kc?t=29327). El vídeo és en castellà.

## 11.1. Ja fas servir objectes

En Python, **tot és un objecte**. Quan escrius `nom.upper()` o `notes.append(7)`, demanes a un objecte (una cadena, una llista) que faci una cosa que sap fer. Aquestes «coses que sap fer» són els seus **mètodes**.

```python
nom = "aina"
notes = [6, 8]

print(type(nom))          # <class 'str'>
print(type(notes))        # <class 'list'>

print(nom.upper())        # AINA: un mètode de les cadenes
notes.append(7)           # un mètode de les llistes
print(notes)              # [6, 8, 7]
```

Fixa't en el que diu `type()`: `class 'str'`, `class 'list'`. Cada objecte pertany a una **classe**, que n'és el **motlle**: defineix quines dades té i què sap fer. `"aina"` i `"Biel"` són dos objectes diferents de la mateixa classe `str`. Ara aprendràs a crear les teves pròpies classes.

| Concepte | Què és | Exemple |
| --- | --- | --- |
| **Classe** | El motlle o el model | `Alumne` |
| **Objecte** o **instància** | Un element concret creat amb el motlle | L'alumna Aina, l'alumne Biel |
| **Atribut** | Una dada que guarda cada objecte | El nom, les notes |
| **Mètode** | Una funció que sap fer l'objecte | Afegir una nota, calcular la mitjana |

## 11.2. Definir una classe

Una classe es defineix amb `class` i el nom, que per convenció s'escriu amb majúscula inicial. A dins s'hi defineix un mètode especial, `__init__` (amb dos guions baixos a cada costat), que s'executa automàticament cada vegada que es crea un objecte i que serveix per donar valor als seus atributs:

```python
class Alumne:
    def __init__(self, nom, curs):
        self.nom = nom
        self.curs = curs
        self.notes = []


aina = Alumne("Aina", "1r de Batxillerat")
biel = Alumne("Biel", "1r de Batxillerat")

print(aina.nom)           # Aina
print(biel.nom)           # Biel
print(aina.notes)         # []
```

- `Alumne("Aina", "1r de Batxillerat")` **crea** un objecte nou: crida `__init__` amb aquests arguments.
- `self` és **l'objecte mateix**. `self.nom = nom` vol dir «guarda el nom que he rebut dins aquest objecte». Cada objecte té els seus propis atributs: el `nom` de l'`aina` i el del `biel` són independents.
- `self` és sempre el primer paràmetre dels mètodes, però **no s'escriu** en cridar-los: Python el passa automàticament.
- Als atributs s'hi accedeix amb un punt: `aina.nom`. També es poden modificar: `aina.curs = "2n de Batxillerat"`.

!!! example "Exercici 11.1. La classe Llibre"
    Crea una classe `Llibre` amb els atributs `titol`, `autor` i `pagines`, i un atribut `prestat` que comenci sempre valent `False`. Crea dos llibres i mostra el títol i l'autor de cadascun. Després, marca el primer com a prestat i mostra el valor de `prestat` dels dos.

    ??? success "Solució"
        ```python
        class Llibre:
            def __init__(self, titol, autor, pagines):
                self.titol = titol
                self.autor = autor
                self.pagines = pagines
                self.prestat = False


        llibre1 = Llibre("La plaça del Diamant", "Mercè Rodoreda", 256)
        llibre2 = Llibre("Mort de dama", "Llorenç Villalonga", 160)

        print(llibre1.titol, "-", llibre1.autor)
        print(llibre2.titol, "-", llibre2.autor)

        llibre1.prestat = True
        print(llibre1.prestat, llibre2.prestat)    # True False
        ```

        `prestat` no és un paràmetre: tots els llibres comencen igual, i per això rep el seu valor directament a `__init__`. El nombre de pàgines de l'exemple és orientatiu: depèn de l'edició.

## 11.3. Mètodes

Els **mètodes** són funcions definides dins la classe. Treballen amb els atributs de l'objecte a través de `self`:

```python
class Alumne:
    def __init__(self, nom, curs):
        self.nom = nom
        self.curs = curs
        self.notes = []

    def afegeix_nota(self, nota):
        self.notes.append(nota)

    def mitjana(self):
        if len(self.notes) == 0:
            return None
        return sum(self.notes) / len(self.notes)

    def ha_aprovat(self):
        return self.mitjana() is not None and self.mitjana() >= 5


aina = Alumne("Aina", "1r de Batxillerat")
aina.afegeix_nota(7)
aina.afegeix_nota(8.5)
aina.afegeix_nota(6)

print(aina.notes)                     # [7, 8.5, 6]
print(round(aina.mitjana(), 2))       # 7.17
print(aina.ha_aprovat())              # True
```

Compara-ho amb el que feies abans: les notes i les funcions que hi treballen ara viatgen **juntes** dins l'objecte. Un mètode pot cridar-ne un altre del mateix objecte amb `self`, com fa `ha_aprovat` amb `self.mitjana()`.

!!! example "Exercici 11.2. Mètodes per al llibre"
    Afegeix a la classe `Llibre` tres mètodes:

    - `presta()`: si el llibre no està prestat, el marca com a prestat i retorna `True`; si ja ho estava, retorna `False`.
    - `retorna()`: el marca com a no prestat.
    - `es_llarg()`: retorna `True` si té més de 300 pàgines.

    Prova que no es pot prestar dues vegades seguides el mateix llibre.

    ??? success "Solució"
        ```python
        class Llibre:
            def __init__(self, titol, autor, pagines):
                self.titol = titol
                self.autor = autor
                self.pagines = pagines
                self.prestat = False

            def presta(self):
                if self.prestat:
                    return False
                self.prestat = True
                return True

            def retorna(self):
                self.prestat = False

            def es_llarg(self):
                return self.pagines > 300


        llibre = Llibre("Bearn", "Llorenç Villalonga", 320)
        print(llibre.presta())     # True: s'ha pogut prestar
        print(llibre.presta())     # False: ja estava prestat
        llibre.retorna()
        print(llibre.presta())     # True
        print(llibre.es_llarg())   # True
        ```

## 11.4. Mostrar un objecte: `__str__`

Si fas `print(aina)`, Python mostra una cosa com `<__main__.Alumne object at 0x7f…>`, que no diu res. El mètode especial `__str__` defineix com s'ha de mostrar l'objecte quan es converteix en text, per exemple amb `print()`:

```python
class Alumne:
    def __init__(self, nom, curs):
        self.nom = nom
        self.curs = curs
        self.notes = []

    def __str__(self):
        return f"{self.nom} ({self.curs}): {len(self.notes)} notes"


aina = Alumne("Aina", "1r de Batxillerat")
print(aina)               # Aina (1r de Batxillerat): 0 notes
```

`__str__` ha de **retornar** un text, no mostrar-lo amb `print`.

!!! example "Exercici 11.3. Un rellotge"
    Crea una classe `Rellotge` amb els atributs `hores` i `minuts`. Afegeix-hi:

    - `avanca(minuts)`: fa avançar el rellotge els minuts indicats; quan arriba a 60 minuts, suma una hora, i després de les 23.59 torna a les 0.00.
    - `__str__`: retorna l'hora amb el format `07:05`, sempre amb dues xifres.

    Comprova que un rellotge que marca les 23:50 i avança 75 minuts passa a marcar les 01:05.

    ??? success "Solució"
        ```python
        class Rellotge:
            def __init__(self, hores, minuts):
                self.hores = hores
                self.minuts = minuts

            def avanca(self, minuts):
                total = self.hores * 60 + self.minuts + minuts
                total = total % (24 * 60)
                self.hores = total // 60
                self.minuts = total % 60

            def __str__(self):
                return f"{self.hores:02d}:{self.minuts:02d}"


        r = Rellotge(23, 50)
        print(r)          # 23:50
        r.avanca(75)
        print(r)          # 01:05
        ```

        Passar-ho tot a minuts, fer el càlcul i tornar-ho a passar a hores és més senzill que comprovar els casos un per un. El format `:02d` escriu el nombre amb dues xifres, amb un zero al davant si cal.

## 11.5. Llistes d'objectes

Els objectes es poden guardar en llistes com qualsevol altre valor. Així es pot gestionar un grup sencer:

```python
class Alumne:
    def __init__(self, nom):
        self.nom = nom
        self.notes = []

    def afegeix_nota(self, nota):
        self.notes.append(nota)

    def mitjana(self):
        return sum(self.notes) / len(self.notes)


grup = [Alumne("Aina"), Alumne("Biel"), Alumne("Carla")]

grup[0].afegeix_nota(8)
grup[0].afegeix_nota(9)
grup[1].afegeix_nota(4)
grup[1].afegeix_nota(6)
grup[2].afegeix_nota(7)

for alumne in grup:
    print(f"{alumne.nom}: {alumne.mitjana():.2f}")

millor = grup[0]
for alumne in grup:
    if alumne.mitjana() > millor.mitjana():
        millor = alumne
print("Millor mitjana:", millor.nom)
```

```text
Aina: 8.50
Biel: 5.00
Carla: 7.00
Millor mitjana: Aina
```

!!! example "Exercici 11.4. La prestatgeria"
    Fes servir la classe `Llibre` de l'exercici 11.2 i crea una llista amb quatre llibres. Presta'n dos. Després, recorre la llista i mostra quins llibres estan disponibles i quantes pàgines sumen tots els llibres.

    ??? success "Solució"
        ```python
        class Llibre:
            def __init__(self, titol, autor, pagines):
                self.titol = titol
                self.autor = autor
                self.pagines = pagines
                self.prestat = False

            def presta(self):
                if self.prestat:
                    return False
                self.prestat = True
                return True


        prestatgeria = [
            Llibre("La plaça del Diamant", "Mercè Rodoreda", 256),
            Llibre("Mort de dama", "Llorenç Villalonga", 160),
            Llibre("Bearn", "Llorenç Villalonga", 320),
            Llibre("Nosaltres, els valencians", "Joan Fuster", 290),
        ]

        prestatgeria[0].presta()
        prestatgeria[2].presta()

        total_pagines = 0
        print("Disponibles:")
        for llibre in prestatgeria:
            total_pagines += llibre.pagines
            if not llibre.prestat:
                print("-", llibre.titol)

        print("Pàgines en total:", total_pagines)
        ```

        Mostra *Mort de dama* i *Nosaltres, els valencians*, i 1.026 pàgines en total.

## 11.6. Una primera idea d'herència

Sovint hi ha classes que s'assemblen molt. Un professor i un alumne tenen nom i correu, però l'alumne té notes i el professor, un departament. L'**herència** permet crear una classe nova a partir d'una que ja existeix: la classe **filla** hereta tots els atributs i mètodes de la **mare** i n'hi pot afegir de nous.

```python
class Persona:
    def __init__(self, nom, correu):
        self.nom = nom
        self.correu = correu

    def presenta(self):
        return f"Som {self.nom}"


class Professor(Persona):                 # Professor hereta de Persona
    def __init__(self, nom, correu, departament):
        super().__init__(nom, correu)     # aprofita l'__init__ de Persona
        self.departament = departament

    def presenta(self):                   # substitueix el mètode de la mare
        return f"Som {self.nom}, del departament de {self.departament}"


p = Persona("Aina", "aina@exemple.cat")
m = Professor("Marta", "marta@exemple.cat", "Tecnologia")

print(p.presenta())       # Som Aina
print(m.presenta())       # Som Marta, del departament de Tecnologia
print(m.correu)           # marta@exemple.cat: atribut heretat
```

- `class Professor(Persona)` indica que `Professor` és una classe filla de `Persona`.
- `super().__init__(nom, correu)` crida l'`__init__` de la mare perquè no s'hagi de repetir el codi.
- Si la filla defineix un mètode amb el mateix nom que la mare, el **substitueix**.

L'herència, juntament amb l'encapsulament, el polimorfisme i l'abstracció, la treballaràs a fons a PTD II, amb Java.

!!! example "Exercici 11.5. Vehicles"
    Crea una classe `Vehicle` amb els atributs `marca` i `velocitat_maxima` i un mètode `descripcio()` que retorni un text amb aquestes dades. Crea una classe filla `Bicicleta` que afegeixi l'atribut `electrica` (`True` o `False`) i que substitueixi `descripcio()` per dir també si és elèctrica.

    ??? success "Solució"
        ```python
        class Vehicle:
            def __init__(self, marca, velocitat_maxima):
                self.marca = marca
                self.velocitat_maxima = velocitat_maxima

            def descripcio(self):
                return f"{self.marca}, fins a {self.velocitat_maxima} km/h"


        class Bicicleta(Vehicle):
            def __init__(self, marca, velocitat_maxima, electrica):
                super().__init__(marca, velocitat_maxima)
                self.electrica = electrica

            def descripcio(self):
                tipus = "elèctrica" if self.electrica else "convencional"
                return f"Bicicleta {tipus}: {super().descripcio()}"


        cotxe = Vehicle("Seat", 180)
        bici = Bicicleta("Orbea", 25, True)
        print(cotxe.descripcio())    # Seat, fins a 180 km/h
        print(bici.descripcio())     # Bicicleta elèctrica: Orbea, fins a 25 km/h
        ```

        `super().descripcio()` aprofita el text que ja genera la mare. L'expressió `"elèctrica" if self.electrica else "convencional"` és un condicional en una sola línia.

## 11.7. Reptes

!!! example "Repte 11.1. El compte bancari"
    Crea una classe `Compte` amb el titular i el saldo, que comenci a 0. Afegeix-hi:

    - `ingressa(quantitat)`: només accepta quantitats positives; retorna `True` si l'operació s'ha fet.
    - `retira(quantitat)`: només si la quantitat és positiva i hi ha prou saldo; retorna `True` o `False`.
    - `transfereix(quantitat, altre_compte)`: retira dels doblers d'aquest compte i els ingressa a l'altre, només si es pot retirar.
    - Una llista `moviments` que guardi cada operació feta, i `__str__`.

    ??? success "Solució"
        ```python
        class Compte:
            def __init__(self, titular):
                self.titular = titular
                self.saldo = 0
                self.moviments = []

            def ingressa(self, quantitat):
                if quantitat <= 0:
                    return False
                self.saldo += quantitat
                self.moviments.append(f"+{quantitat:.2f}")
                return True

            def retira(self, quantitat):
                if quantitat <= 0 or quantitat > self.saldo:
                    return False
                self.saldo -= quantitat
                self.moviments.append(f"-{quantitat:.2f}")
                return True

            def transfereix(self, quantitat, altre_compte):
                if self.retira(quantitat):
                    altre_compte.ingressa(quantitat)
                    return True
                return False

            def __str__(self):
                return f"{self.titular}: {self.saldo:.2f} €"


        aina = Compte("Aina")
        biel = Compte("Biel")
        aina.ingressa(100)
        print(aina.retira(150))           # False: no hi ha prou saldo
        print(aina.transfereix(40, biel)) # True
        print(aina, "|", biel)            # Aina: 60.00 € | Biel: 40.00 €
        print(aina.moviments)             # ['+100.00', '-40.00']
        ```

        `transfereix` no repeteix cap comprovació: crida els mètodes que ja la fan. Fixa't que un mètode pot rebre **un altre objecte** com a paràmetre.

!!! example "Repte 11.2. La biblioteca d'aula"
    Combina les classes `Llibre` i `Alumne` en una classe `Biblioteca` que guardi una llista de llibres i tengui els mètodes `afegeix(llibre)`, `cerca(text)` (retorna els llibres el títol dels quals conté el text, sense distingir majúscules) i `disponibles()`. Fes un programa amb un menú per cercar llibres, prestar-los i retornar-los.

    Aquest repte no té una solució única: és una bona base per al projecte final.

## 11.8. Exercicis de repàs

!!! example "Repàs 11.1. Vocabulari"
    En aquest codi, identifica la classe, els objectes, els atributs i els mètodes.

    ```python
    class Gat:
        def __init__(self, nom, edat):
            self.nom = nom
            self.edat = edat

        def miola(self):
            return f"{self.nom} diu: mèu!"

    mixa = Gat("Mixa", 3)
    tom = Gat("Tom", 5)
    print(mixa.miola())
    ```

    ??? success "Solució"
        La classe és `Gat`. Els objectes (instàncies) són `mixa` i `tom`. Els atributs són `nom` i `edat`. Els mètodes són `__init__` i `miola`. El programa mostra `Mixa diu: mèu!`.

!!! example "Repàs 11.2. Caça d'errors"
    Aquest programa té tres errors. Troba'ls i corregeix-los.

    ```python
    class Rectangle:
        def __init__(base, altura):
            self.base = base
            self.altura = altura

        def area():
            return self.base * self.altura

    r = Rectangle(4, 3)
    print(r.area)
    ```

    ??? success "Solució"
        ```python
        class Rectangle:
            def __init__(self, base, altura):
                self.base = base
                self.altura = altura

            def area(self):
                return self.base * self.altura


        r = Rectangle(4, 3)
        print(r.area())     # 12
        ```

        1. A `__init__` hi faltava el paràmetre `self`.
        2. A `area` també.
        3. `r.area` sense parèntesis no crida el mètode: mostraria una cosa com `<bound method Rectangle.area …>`.

!!! example "Repàs 11.3. Què mostra?"
    Sense executar-lo, digues què mostra aquest programa.

    ```python
    class Comptador:
        def __init__(self):
            self.valor = 0

        def incrementa(self):
            self.valor += 1

    a = Comptador()
    b = Comptador()
    a.incrementa()
    a.incrementa()
    b.incrementa()
    print(a.valor, b.valor)
    ```

    ??? success "Solució"
        Mostra `2 1`: cada objecte té el seu propi atribut `valor`.

!!! example "Repàs 11.4. Un cercle"
    Crea una classe `Cercle` amb l'atribut `radi` i els mètodes `area()`, `perimetre()` i `__str__`, que retorni `Cercle de radi 2`. Fes servir `math.pi`.

    ??? success "Solució"
        ```python
        import math


        class Cercle:
            def __init__(self, radi):
                self.radi = radi

            def area(self):
                return math.pi * self.radi ** 2

            def perimetre(self):
                return 2 * math.pi * self.radi

            def __str__(self):
                return f"Cercle de radi {self.radi}"


        c = Cercle(2)
        print(c)                          # Cercle de radi 2
        print(f"{c.area():.2f}")          # 12.57
        print(f"{c.perimetre():.2f}")     # 12.57
        ```

        Amb un radi de 2, l'àrea i el perímetre coincideixen numèricament (4π), però no tenen les mateixes unitats.

!!! example "Repàs 11.5. Un termòstat"
    Crea una classe `Termostat` amb una temperatura objectiu i una temperatura actual. Afegeix-hi `puja()` i `baixa()`, que canviïn l'objectiu de mig en mig grau sense sortir de l'interval de 15 a 30 °C, i `estat()`, que retorni «Escalfant», «Refredant» o «En repòs» segons si la temperatura actual és més baixa, més alta o igual que l'objectiu.

    ??? success "Solució"
        ```python
        class Termostat:
            MINIM = 15
            MAXIM = 30

            def __init__(self, objectiu, actual):
                self.objectiu = objectiu
                self.actual = actual

            def puja(self):
                if self.objectiu + 0.5 <= Termostat.MAXIM:
                    self.objectiu += 0.5

            def baixa(self):
                if self.objectiu - 0.5 >= Termostat.MINIM:
                    self.objectiu -= 0.5

            def estat(self):
                if self.actual < self.objectiu:
                    return "Escalfant"
                elif self.actual > self.objectiu:
                    return "Refredant"
                return "En repòs"


        t = Termostat(21, 19.5)
        print(t.estat())          # Escalfant
        for i in range(4):
            t.baixa()
        print(t.objectiu, t.estat())   # 19.0 Refredant
        ```

        `MINIM` i `MAXIM` són **atributs de classe**: es defineixen fora de `__init__` i són compartits per tots els objectes de la classe.

!!! example "Repàs 11.6. El carretó de la compra"
    Crea una classe `Producte` (nom i preu) i una classe `Carreto` amb una llista de productes i els mètodes `afegeix(producte)`, `total()` i `mes_car()`. Prova-ho amb tres productes.

    ??? success "Solució"
        ```python
        class Producte:
            def __init__(self, nom, preu):
                self.nom = nom
                self.preu = preu


        class Carreto:
            def __init__(self):
                self.productes = []

            def afegeix(self, producte):
                self.productes.append(producte)

            def total(self):
                suma = 0
                for p in self.productes:
                    suma += p.preu
                return suma

            def mes_car(self):
                mes_car = self.productes[0]
                for p in self.productes:
                    if p.preu > mes_car.preu:
                        mes_car = p
                return mes_car


        c = Carreto()
        c.afegeix(Producte("Ratolí", 12.5))
        c.afegeix(Producte("Teclat", 35))
        c.afegeix(Producte("Alfombreta", 6.95))
        print(f"Total: {c.total():.2f} €")      # Total: 54.45 €
        print("Més car:", c.mes_car().nom)      # Més car: Teclat
        ```

!!! example "Repàs 11.7. Herència: figures"
    Crea una classe `Figura` amb un mètode `area()` que retorni 0 i un mètode `descripcio()` que retorni `"Figura d'àrea …"` fent servir `self.area()`. Crea les filles `Quadrat` i `Triangle`, que només substitueixin `area()`. Comprova que `descripcio()` funciona bé a les dues filles sense haver-la reescrit.

    ??? success "Solució"
        ```python
        class Figura:
            def area(self):
                return 0

            def descripcio(self):
                return f"Figura d'àrea {self.area()}"


        class Quadrat(Figura):
            def __init__(self, costat):
                self.costat = costat

            def area(self):
                return self.costat ** 2


        class Triangle(Figura):
            def __init__(self, base, altura):
                self.base = base
                self.altura = altura

            def area(self):
                return self.base * self.altura / 2


        for figura in [Quadrat(3), Triangle(4, 5)]:
            print(figura.descripcio())
        ```

        ```text
        Figura d'àrea 9
        Figura d'àrea 10.0
        ```

        `descripcio()` és a la mare, però `self.area()` crida la versió de cada filla. Aquest comportament, que una mateixa crida faci coses diferents segons l'objecte, s'anomena **polimorfisme**, i el veuràs a fons a PTD II.

---

!!! quote "Fonts"
    Unitat de material propi. S'hi recomana el [curs de Python](https://youtu.be/Kp4Mvapo5kc) de Brais Moure (MoureDev), lliçó 13; no se'n reprodueix el codi. Totes les solucions s'han executat amb Python. Els títols i autors dels llibres dels exemples són reals, però el nombre de pàgines és orientatiu.
