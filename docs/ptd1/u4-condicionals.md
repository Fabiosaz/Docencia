# Unitat 4. Estructures condicionals

Fins ara, els nostres programes executaven totes les instruccions, una darrere l'altra, de dalt a baix. Però els programes útils han de **prendre decisions**: mostrar un missatge o un altre, calcular d'una manera o d'una altra, segons les dades que reben.

Les **estructures de control** ens permeten dirigir el flux d'execució del programa segons unes condicions. És a dir, hi haurà instruccions que s'executaran i d'altres que no. Com es decideix quines s'executen? Depèn de les condicions que escriguem al codi. Hi ha tres grans tipus d'estructures de control: les **condicionals**, que veurem en aquesta unitat, les **iteratives** (bucles) i les **de salt**, que veurem a la unitat 5.

## 4.1. La condició: una expressió booleana

Una **condició** és qualsevol expressió que dona com a resultat `True` o `False`. A la unitat 3 ja les hem vistes: són les comparacions (`edat >= 18`, `nota == 10`) i les combinacions amb operadors lògics (`edat >= 18 and te_carnet`).

!!! tip "Comparacions encadenades"
    Python permet escriure intervals com a matemàtiques: `0 <= nota <= 10` és equivalent a `nota >= 0 and nota <= 10`, però més fàcil de llegir.

!!! example "Exercici 4.1. Avalua la condició"
    Amb `nota = 6.5`, quin és el resultat de cada condició?

    `5 <= nota < 7` · `nota > 5 and nota < 6` · `not nota >= 5` · `nota == 6.5 or nota > 10`

    ??? success "Solució"
        `True`, `False`, `False` i `True`.

## 4.2. Condicional simple: `if`

La forma més senzilla executa un bloc d'instruccions **només si** la condició és vertadera. Si és falsa, el bloc es bota i el programa continua.

```python
temperatura = float(input("Quina temperatura fa? "))

if temperatura > 30:
    print("Fa molta calor. Beu aigua!")

print("Bon dia!")   # aquesta línia s'executa sempre
```

Fixa't en tres detalls de sintaxi imprescindibles:

1. La línia de l'`if` acaba amb **dos punts** (`:`).
2. Les instruccions que depenen de la condició van **sagnades** (4 espais). El sagnat no és decoratiu: és el que indica a Python on comença i on acaba el bloc.
3. La primera línia que torna al marge esquerre ja **no** forma part del bloc.

<figure markdown="span">
  ![Un if anotat: els dos punts, el bloc sagnat i la línia que queda fora del bloc](img/u4-sagnat.svg){ width="720" }
  <figcaption>Els tres detalls de sintaxi, sobre el codi de l'exemple.</figcaption>
</figure>

```mermaid
flowchart TD
    A([Inici]) --> B[/Llegir temperatura/]
    B --> C{temperatura > 30?}
    C -- Sí --> D[/Escriure 'Beu aigua!'/]
    D --> E[/Escriure 'Bon dia!'/]
    C -- No --> E
    E --> F([Fi])
```

!!! example "Exercici 4.2. Avís de bateria"
    Escriu un programa que demani el percentatge de bateria del mòbil. Si és inferior al 20 %, ha de mostrar «Bateria baixa: connecta el carregador». En tots els casos, al final ha de mostrar «Nivell de bateria: X %».

    ??? success "Solució"
        ```python
        bateria = int(input("Percentatge de bateria: "))

        if bateria < 20:
            print("Bateria baixa: connecta el carregador")

        print(f"Nivell de bateria: {bateria} %")
        ```

        La darrera línia no està sagnada: per això s'executa sempre, es compleixi o no la condició.

## 4.3. Condicional doble: `if` … `else`

Amb `else` (sinó) indicam què s'ha de fer quan la condició és **falsa**. Sempre s'executa un dels dos blocs, mai tots dos.

```python
edat = int(input("Quants d'anys tens? "))

if edat >= 18:
    print("Ets major d'edat")
else:
    print("Ets menor d'edat")
```

!!! example "Exercici 4.3. Major d'edat"
    Demana a l'usuari la seva edat i digues si és major d'edat o no.

    ??? success "Solució"
        ```python
        edat = int(input("Quants d'anys tens? "))
        if edat >= 18:
            print("Ets major d'edat")
        else:
            print("Ets menor d'edat")
        ```

!!! example "Exercici 4.4. Parell o senar"
    Demana un nombre enter i digues si és parell o senar.

    ??? success "Solució"
        ```python
        n = int(input("Escriu un nombre enter: "))
        if n % 2 == 0:
            print(f"{n} és parell")
        else:
            print(f"{n} és senar")
        ```

## 4.4. Condicional múltiple: `if` … `elif` … `else`

Quan hi ha més de dues possibilitats, afegim tantes branques `elif` (abreviatura d'*else if*, «sinó, si») com calguin.

```python linenums="1"
edat = 20

if edat < 18:
    print("Ets menor d'edat")
elif edat >= 18 and edat < 65:
    print("Ets una persona adulta")
else:
    print("Jubilat! Enhorabona")
```

Vegem què fa aquest codi línia a línia. A la línia 1 cream la variable `edat` i hi guardam el valor 20. La resta és una estructura condicional amb dues condicions:

- A la línia 3 preguntam: «És `edat` menor que 18?». Si ho és, s'executa el bloc que té a dins (línia 4) i **ja no es comprova res més** (línies 5 a 8).
- Si no ho és, el programa bota a la línia 5 i comprova la segona condició: «És `edat` major o igual que 18 i menor que 65?». Si ho és, s'executa la línia 6 i s'acaba l'estructura.
- Si tampoc no ho és, s'executa el bloc de l'`else` (línia 8).

!!! info "Només s'executa una branca"
    Python comprova les condicions **en ordre** i executa **només la primera** que és vertadera. Per això, a la línia 5 la part `edat >= 18` és redundant: si hem arribat fins allà, ja sabem que l'edat no és menor que 18. Podríem escriure simplement `elif edat < 65:`. L'`else` final és opcional.

!!! warning "Error freqüent: l'ordre de les condicions"
    Aquest programa té un error. Saps quin?

    ```python
    nota = 9.5
    if nota >= 5:
        print("Aprovat")
    elif nota >= 9:
        print("Excel·lent")
    ```

    ??? success "Resposta"
        Qualsevol nota de 9 o més també és major o igual que 5, de manera que sempre entra a la primera branca i mai no arriba a mostrar «Excel·lent». Quan les condicions se solapen, cal posar primer la més restrictiva (`nota >= 9`).

!!! example "Exercici 4.5. El major de dos"
    Demana dos nombres i mostra quin és el major. Tingues en compte que poden ser iguals.

    ??? success "Solució"
        ```python
        a = float(input("Primer nombre: "))
        b = float(input("Segon nombre: "))
        if a > b:
            print(f"El major és {a}")
        elif b > a:
            print(f"El major és {b}")
        else:
            print("Són iguals")
        ```

!!! example "Exercici 4.6. Positiu, negatiu o zero"
    Demana un nombre i digues si és positiu, negatiu o zero.

    ??? success "Solució"
        ```python
        n = float(input("Escriu un nombre: "))
        if n > 0:
            print("Positiu")
        elif n < 0:
            print("Negatiu")
        else:
            print("Zero")
        ```

!!! example "Exercici 4.7. Qualificacions"
    Demana una nota de 0 a 10 i mostra la qualificació: insuficient (menys de 5), suficient (de 5 a menys de 6), bé (de 6 a menys de 7), notable (de 7 a menys de 9) o excel·lent (9 o més). Si la nota no és entre 0 i 10, mostra un missatge d'error.

    ??? success "Solució"
        ```python
        nota = float(input("Nota (0-10): "))
        if not 0 <= nota <= 10:
            print("La nota ha de ser entre 0 i 10")
        elif nota < 5:
            print("Insuficient")
        elif nota < 6:
            print("Suficient")
        elif nota < 7:
            print("Bé")
        elif nota < 9:
            print("Notable")
        else:
            print("Excel·lent")
        ```

## 4.5. Condicionals niades

Dins un bloc condicional hi pot haver qualsevol instrucció, també un altre `if`. Parlam aleshores de **condicionals niades** (o imbricades).

```python
te_entrada = input("Tens entrada? (s/n) ") == "s"
edat = int(input("Quants d'anys tens? "))

if te_entrada:
    if edat >= 16:
        print("Pots entrar al concert")
    else:
        print("Has d'anar acompanyat d'una persona adulta")
else:
    print("Primer has de comprar l'entrada")
```

Niar condicionals és útil, però si hi ha massa nivells, el codi costa molt de llegir. Sovint es pot simplificar amb operadors lògics o amb `elif`:

=== "Niat"

    ```python
    if edat >= 18:
        if te_carnet:
            print("Pots conduir")
    ```

=== "Amb `and`"

    ```python
    if edat >= 18 and te_carnet:
        print("Pots conduir")
    ```

!!! example "Exercici 4.8. Any de traspàs"
    Un any és de traspàs si és divisible entre 4, excepte els que són divisibles entre 100, que només ho són si també són divisibles entre 400. Així, 2024 i 2000 són de traspàs, però 1900 no. Demana un any i digues si és de traspàs.

    ??? success "Solució"
        ```python
        any_ = int(input("Escriu un any: "))
        if (any_ % 4 == 0 and any_ % 100 != 0) or any_ % 400 == 0:
            print(f"{any_} és de traspàs")
        else:
            print(f"{any_} no és de traspàs")
        ```

        Hem escrit `any_` amb guió baix perquè `any` és el nom d'una funció de Python i és millor no tapar-la.

!!! example "Exercici 4.9. Tarifa del bus"
    Una línia de bus cobra 2 € el bitllet ordinari. Els menors de 14 anys i els majors de 65 paguen la meitat, i els menors de 6 anys viatgen gratis. Demana l'edat i mostra el preu del bitllet.

    ??? success "Solució"
        ```python
        edat = int(input("Edat del viatger: "))
        PREU = 2.0
        if edat < 6:
            preu = 0
        elif edat < 14 or edat > 65:
            preu = PREU / 2
        else:
            preu = PREU
        print(f"El bitllet costa {preu:.2f} €")
        ```

        Els preus i les edats d'aquest exercici són inventats.

## 4.6. Selecció per casos: `match` … `case`

Quan hem de comparar **una mateixa variable** amb molts de valors concrets, una cadena d'`elif` es fa llarga. Des de la versió 3.10, Python té l'estructura `match`, semblant al `switch` d'altres llenguatges.

```python
dia = int(input("Escriu un nombre de l'1 al 7: "))

match dia:
    case 1:
        print("Dilluns")
    case 2:
        print("Dimarts")
    case 3:
        print("Dimecres")
    case 4:
        print("Dijous")
    case 5:
        print("Divendres")
    case 6 | 7:
        print("Cap de setmana!")
    case _:
        print("Aquest dia no existeix")
```

- `case 6 | 7` agrupa diversos valors en un mateix cas.
- `case _` és el cas per defecte, equivalent a l'`else`: s'executa si no coincideix cap dels anteriors.

!!! info "Compte amb la versió"
    `match` no funciona en versions de Python anteriors a la 3.10. Si el teu entorn dona un error de sintaxi en aquesta línia, comprova la versió o fes servir `if` … `elif`.

!!! example "Exercici 4.10. Dies de la setmana"
    Demana un nombre de l'1 al 7 i mostra el dia de la setmana corresponent. Resol-lo primer amb `if` … `elif` i després amb `match`.

    ??? success "Solució amb `if` … `elif`"
        ```python
        dia = int(input("Escriu un nombre de l'1 al 7: "))
        if dia == 1:
            print("Dilluns")
        elif dia == 2:
            print("Dimarts")
        elif dia == 3:
            print("Dimecres")
        elif dia == 4:
            print("Dijous")
        elif dia == 5:
            print("Divendres")
        elif dia == 6:
            print("Dissabte")
        elif dia == 7:
            print("Diumenge")
        else:
            print("Nombre no vàlid")
        ```

        La versió amb `match` és l'exemple de l'apartat 4.6, amb un `case` per al dissabte i un altre per al diumenge. A la unitat 7 veurem una manera molt més curta de fer-ho amb una llista.

## 4.7. Reptes

!!! example "Repte 4.1. Calculadora"
    Escriu una calculadora que demani dos nombres i una operació (`+`, `-`, `*` o `/`) i mostri el resultat. Resol-la amb `match`. Si l'operació no és cap de les quatre, ha de mostrar un missatge d'error, i si l'usuari intenta dividir entre zero, també.

    ??? success "Solució"
        ```python
        a = float(input("Primer nombre: "))
        operacio = input("Operació (+, -, *, /): ")
        b = float(input("Segon nombre: "))

        match operacio:
            case "+":
                print(f"{a} + {b} = {a + b}")
            case "-":
                print(f"{a} - {b} = {a - b}")
            case "*":
                print(f"{a} * {b} = {a * b}")
            case "/":
                if b == 0:
                    print("No es pot dividir entre zero")
                else:
                    print(f"{a} / {b} = {a / b}")
            case _:
                print("Operació no vàlida")
        ```

!!! example "Repte 4.2. Pedra, paper, tisora"
    Programa el joc de pedra, paper, tisora contra l'ordinador. L'usuari escriu la seva jugada i l'ordinador en tria una a l'atzar. El programa mostra les dues jugades i qui ha guanyat. Per fer que l'ordinador triï a l'atzar, escriu `import random` a la primera línia i fes servir `random.randint(1, 3)`, que retorna un enter a l'atzar entre 1 i 3.

    ??? success "Solució"
        ```python
        import random

        usuari = input("Pedra, paper o tisora? ").strip().lower()

        numero = random.randint(1, 3)
        if numero == 1:
            ordinador = "pedra"
        elif numero == 2:
            ordinador = "paper"
        else:
            ordinador = "tisora"
        print(f"L'ordinador ha triat {ordinador}")

        if usuari != "pedra" and usuari != "paper" and usuari != "tisora":
            print("Jugada no vàlida")
        elif usuari == ordinador:
            print("Empat!")
        elif (usuari == "pedra" and ordinador == "tisora") or \
             (usuari == "paper" and ordinador == "pedra") or \
             (usuari == "tisora" and ordinador == "paper"):
            print("Has guanyat!")
        else:
            print("Guanya l'ordinador")
        ```

        La barra inversa `\` al final d'una línia indica que la instrucció continua a la línia següent. També es pot evitar posant tota la condició entre parèntesis.

## 4.8. Exercicis de repàs

Més exercicis per practicar tota la unitat, ordenats de menys a més dificultat. Els dos primers es resolen sense ordinador. Prova cada programa amb diversos valors, sobretot amb els que queden just a la frontera entre dos casos.

!!! example "Repàs 4.1. Segueix el codi"
    Sense executar-lo, digues què mostra aquest programa quan `x` val 15, quan val 25 i quan val 5.

    ```python
    if x > 10:
        print("A")
    if x > 20:
        print("B")
    else:
        print("C")
    print("D")
    ```

    ??? success "Solució"
        - Amb 15: `A`, `C` i `D`.
        - Amb 25: `A`, `B` i `D`.
        - Amb 5: `C` i `D`.

        Són **dos** condicionals independents: l'`else` només pertany al segon `if`. La darrera línia no està sagnada i s'executa sempre.

!!! example "Repàs 4.2. if o elif?"
    Aquests dos programes semblen iguals. Què mostra cadascun si `nota` val 9?

    ```python
    # Programa 1                  # Programa 2
    if nota >= 5:                 if nota >= 5:
        print("Aprovat")              print("Aprovat")
    if nota >= 7:                 elif nota >= 7:
        print("Notable")              print("Notable")
    if nota >= 9:                 elif nota >= 9:
        print("Excel·lent")           print("Excel·lent")
    ```

    ??? success "Solució"
        El programa 1 mostra `Aprovat`, `Notable` i `Excel·lent`: són tres condicionals independents i es comproven tots.

        El programa 2 només mostra `Aprovat`: en una cadena `if` … `elif` s'executa **només el primer bloc** la condició del qual és vertadera, i la resta ja no es comprova. Per fer-lo bé, s'han d'ordenar les condicions de la més restrictiva a la menys restrictiva: primer `nota >= 9`, després `nota >= 7` i al final `nota >= 5`.

!!! example "Repàs 4.3. Caça d'errors"
    Aquest programa hauria de dir si un nombre és positiu, però té quatre errors. Troba'ls i corregeix-los.

    ```python
    n = input("Escriu un nombre: ")
    if n > 0
        print("És positiu")
    else:
    print("No és positiu")
    if n = 0:
        print("De fet, és zero")
    ```

    ??? success "Solució"
        ```python
        n = int(input("Escriu un nombre: "))
        if n > 0:
            print("És positiu")
        else:
            print("No és positiu")
        if n == 0:
            print("De fet, és zero")
        ```

        1. `input()` retorna un text: s'ha de convertir amb `int()` per poder comparar-lo amb un nombre.
        2. Falten els dos punts al final de la línia de l'`if`.
        3. El `print` de l'`else` no està sagnat.
        4. Per comparar es fa servir `==`; un sol `=` és una assignació.

!!! example "Repàs 4.4. Simplifica"
    Reescriu aquest programa perquè faci el mateix amb **un sol** `if` … `else`, sense condicionals niades.

    ```python
    edat = int(input("Edat: "))
    carnet = input("Tens carnet? (s/n) ")

    if edat >= 18:
        if carnet == "s":
            print("Pots conduir")
        else:
            print("No pots conduir")
    else:
        print("No pots conduir")
    ```

    ??? success "Solució"
        ```python
        edat = int(input("Edat: "))
        carnet = input("Tens carnet? (s/n) ")

        if edat >= 18 and carnet == "s":
            print("Pots conduir")
        else:
            print("No pots conduir")
        ```

        Quan dues condicions niades duen al mateix resultat, es poden unir amb `and`. El codi queda més curt i no repeteix el missatge.

!!! example "Repàs 4.5. Aprovat o suspès"
    Demana una nota i mostra «Aprovat» si és igual o superior a 5 i «Suspès» en cas contrari.

    ??? success "Solució"
        ```python
        nota = float(input("Nota: "))

        if nota >= 5:
            print("Aprovat")
        else:
            print("Suspès")
        ```

!!! example "Repàs 4.6. De menor a major"
    Demana dos nombres i mostra'ls ordenats de menor a major.

    ??? success "Solució"
        ```python
        a = float(input("Primer nombre: "))
        b = float(input("Segon nombre: "))

        if a <= b:
            print(a, b)
        else:
            print(b, a)
        ```

!!! example "Repàs 4.7. El major de tres"
    Demana tres nombres enters i mostra el més gran. Prova'l amb el més gran a cada una de les tres posicions, i també amb nombres repetits.

    ??? success "Solució"
        ```python
        a = int(input("Primer nombre: "))
        b = int(input("Segon nombre: "))
        c = int(input("Tercer nombre: "))

        if a >= b and a >= c:
            print("El més gran és", a)
        elif b >= c:
            print("El més gran és", b)
        else:
            print("El més gran és", c)
        ```

        Si s'arriba a l'`elif`, ja sabem que `a` no és el més gran; per això n'hi ha prou de comparar `b` amb `c`.

!!! example "Repàs 4.8. Múltiple de 3, de 5 o de tots dos"
    Demana un nombre enter i digues si és múltiple de 3 i de 5 alhora, només de 3, només de 5 o de cap dels dos.

    ??? success "Solució"
        ```python
        n = int(input("Nombre: "))

        if n % 3 == 0 and n % 5 == 0:
            print("És múltiple de 3 i de 5")
        elif n % 3 == 0:
            print("És múltiple de 3")
        elif n % 5 == 0:
            print("És múltiple de 5")
        else:
            print("No és múltiple ni de 3 ni de 5")
        ```

        El cas més restrictiu (múltiple de tots dos) ha d'anar el primer. Si es posàs al final, el 15 quedaria atrapat a la branca «múltiple de 3».

!!! example "Repàs 4.9. Franges d'edat"
    Demana una edat i mostra la franja que li correspon: infant (menys de 12 anys), adolescent (de 12 a 17), adult (de 18 a 64) o sènior (65 o més). Si l'edat és negativa, mostra un missatge d'error.

    ??? success "Solució"
        ```python
        edat = int(input("Edat: "))

        if edat < 0:
            print("L'edat no pot ser negativa")
        elif edat < 12:
            print("Infant")
        elif edat < 18:
            print("Adolescent")
        elif edat < 65:
            print("Adult")
        else:
            print("Sènior")
        ```

        No cal escriure `edat >= 12 and edat < 18`: si el programa arriba al segon `elif`, ja sabem que l'edat no és menor de 12.

!!! example "Repàs 4.10. Descompte segons l'import"
    Una botiga aplica un descompte segons l'import de la compra: cap descompte si és inferior a 50 €, un 5 % si és de 50 € a 100 € (tots dos inclosos) i un 10 % si supera els 100 €. Demana l'import i mostra el preu final amb dues xifres decimals.

    ??? success "Solució"
        ```python
        import_compra = float(input("Import de la compra: "))

        if import_compra < 50:
            descompte = 0
        elif import_compra <= 100:
            descompte = 5
        else:
            descompte = 10

        preu_final = import_compra * (1 - descompte / 100)
        print(f"Descompte: {descompte} %")
        print(f"Preu final: {preu_final:.2f} €")
        ```

        El condicional només decideix el **percentatge**; el càlcul i els `print` s'escriuen una sola vegada, després. Prova sempre els valors de les fronteres (50 i 100).

!!! example "Repàs 4.11. Vocal o consonant"
    Demana una lletra minúscula i digues si és una vocal o una consonant. Suposa que l'usuari escriu una sola lletra sense accent.

    ??? success "Solució"
        ```python
        lletra = input("Escriu una lletra minúscula: ")

        if lletra == "a" or lletra == "e" or lletra == "i" or lletra == "o" or lletra == "u":
            print("És una vocal")
        else:
            print("És una consonant")
        ```

        No es pot escriure `lletra == "a" or "e"`: a cada costat de l'`or` hi ha d'haver una comparació completa. A la unitat 6 veuràs una manera més curta: `lletra in "aeiou"`.

!!! example "Repàs 4.12. Quin triangle és?"
    Demana les longituds dels tres costats d'un triangle i digues si és equilàter (tres costats iguals), isòsceles (dos costats iguals) o escalè (tots diferents).

    ??? success "Solució"
        ```python
        a = float(input("Costat a: "))
        b = float(input("Costat b: "))
        c = float(input("Costat c: "))

        if a == b and b == c:
            print("Equilàter")
        elif a == b or b == c or a == c:
            print("Isòsceles")
        else:
            print("Escalè")
        ```

!!! example "Repàs 4.13. Es pot formar un triangle?"
    Tres segments formen un triangle només si cada un és més curt que la suma dels altres dos. Demana tres longituds i digues si poden formar un triangle.

    ??? success "Solució"
        ```python
        a = float(input("Costat a: "))
        b = float(input("Costat b: "))
        c = float(input("Costat c: "))

        if a < b + c and b < a + c and c < a + b:
            print("Poden formar un triangle")
        else:
            print("No poden formar un triangle")
        ```

!!! example "Repàs 4.14. On és el punt?"
    Demana les coordenades `x` i `y` d'un punt i digues on es troba: a l'origen, sobre l'eix X, sobre l'eix Y o en quin quadrant (primer: `x` i `y` positives; segon: `x` negativa i `y` positiva; tercer: totes dues negatives; quart: `x` positiva i `y` negativa).

    ??? success "Solució"
        ```python
        x = float(input("x: "))
        y = float(input("y: "))

        if x == 0 and y == 0:
            print("És a l'origen")
        elif y == 0:
            print("És sobre l'eix X")
        elif x == 0:
            print("És sobre l'eix Y")
        elif x > 0 and y > 0:
            print("Primer quadrant")
        elif x < 0 and y > 0:
            print("Segon quadrant")
        elif x < 0 and y < 0:
            print("Tercer quadrant")
        else:
            print("Quart quadrant")
        ```

!!! example "Repàs 4.15. Els dies del mes"
    Demana el número d'un mes (de l'1 al 12) i mostra quants de dies té, fent servir `match`. Per al febrer, mostra «28 o 29 dies». Si el número no és vàlid, mostra un missatge d'error.

    ??? success "Solució"
        ```python
        mes = int(input("Número del mes: "))

        match mes:
            case 1 | 3 | 5 | 7 | 8 | 10 | 12:
                print("31 dies")
            case 4 | 6 | 9 | 11:
                print("30 dies")
            case 2:
                print("28 o 29 dies")
            case _:
                print("Aquest mes no existeix")
        ```

!!! example "Repàs 4.16. L'entrada del cinema"
    Un cinema cobra 8 € l'entrada general, 5 € als menors de 12 anys i 6 € als majors de 65. A més, els dimecres tothom té 2 € de descompte. Demana l'edat i el dia de la setmana (en minúscules) i mostra el preu de l'entrada.

    ??? success "Solució"
        ```python
        edat = int(input("Edat: "))
        dia = input("Dia de la setmana: ")

        if edat < 12:
            preu = 5
        elif edat > 65:
            preu = 6
        else:
            preu = 8

        if dia == "dimecres":
            preu = preu - 2

        print(f"Preu de l'entrada: {preu} €")
        ```

        Hi ha dues decisions independents (la tarifa per edat i el descompte del dia), i per això es resolen amb dos condicionals seguits, no amb un de sol.

!!! example "Repàs 4.17. Hora correcta"
    Demana una hora i uns minuts. Si no formen una hora vàlida (hores de 0 a 23 i minuts de 0 a 59), mostra «Hora incorrecta». Si és vàlida, digues si és matí (abans de les 12), horabaixa (de les 12 a les 19.59) o vespre.

    ??? success "Solució"
        ```python
        hora = int(input("Hora: "))
        minuts = int(input("Minuts: "))

        if hora < 0 or hora > 23 or minuts < 0 or minuts > 59:
            print("Hora incorrecta")
        else:
            if hora < 12:
                print("És matí")
            elif hora < 20:
                print("És horabaixa")
            else:
                print("És vespre")
        ```

!!! example "Repàs 4.18. El caixer automàtic"
    Un compte té un saldo de 500 €. Demana quina quantitat es vol retirar. El caixer només dona bitllets, de manera que la quantitat ha de ser positiva i múltiple de 10, i no pot superar el saldo. Mostra el saldo que queda o el motiu pel qual no es pot fer l'operació.

    ??? success "Solució"
        ```python
        saldo = 500

        quantitat = int(input("Quantitat a retirar: "))

        if quantitat <= 0:
            print("La quantitat ha de ser positiva")
        elif quantitat % 10 != 0:
            print("La quantitat ha de ser múltiple de 10")
        elif quantitat > saldo:
            print("No tens prou saldo")
        else:
            saldo = saldo - quantitat
            print(f"Operació feta. Saldo: {saldo} €")
        ```

!!! example "Repàs 4.19. L'equació de segon grau"
    Demana els coeficients `a`, `b` i `c` d'una equació de segon grau (amb `a` diferent de 0) i mostra'n les solucions reals. Recorda que depenen del discriminant, `b² − 4ac`: si és positiu n'hi ha dues, si és zero n'hi ha una i si és negatiu no n'hi ha cap. L'arrel quadrada es pot calcular elevant a 0.5.

    ??? success "Solució"
        ```python
        a = float(input("a: "))
        b = float(input("b: "))
        c = float(input("c: "))

        discriminant = b ** 2 - 4 * a * c

        if discriminant > 0:
            x1 = (-b + discriminant ** 0.5) / (2 * a)
            x2 = (-b - discriminant ** 0.5) / (2 * a)
            print("Dues solucions:", x1, "i", x2)
        elif discriminant == 0:
            x = -b / (2 * a)
            print("Una solució:", x)
        else:
            print("No té solucions reals")
        ```

        Compte amb els parèntesis de `(2 * a)`: sense ells, es dividiria entre 2 i després es multiplicaria per `a`.

---

!!! quote "Font"
    Unitat elaborada a partir de materials de Lope González Vázquez ([CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ca)): [«Tema 11. Fundamentos de programación»](https://lopegonzalez.es/eso-y-bachillerato/tic-i-1o-bachillerato/tema-11-fundamentos-de-programacion/) (TIC I) i [«Tema 1. Introducción a la programación»](https://lopegonzalez.es/eso-y-bachillerato/creacion-digital-y-pensamiento-computacional-1o-bachillerato/tema-1-introduccion-a-la-programacion/) (Creación digital y pensamiento computacional). Canvis: traducció al català i adaptació al currículum de Programació i Tractament de Dades I de les Illes Balears. Els enunciats dels exercicis 4.3 a 4.7 i 4.10 provenen dels exercicis resolts de Lope (el 4.7, amb l'escala de qualificacions adaptada). Són propis els apartats 4.1, 4.2, 4.3, 4.5 i 4.6 (`match`), els requadres, el diagrama de flux, la resta d'exercicis, els reptes i totes les solucions.
