# Unitat 2. Llenguatges de programació i entorns de desenvolupament

Ja sabem que, perquè un ordinador faci qualsevol tasca, necessita rebre instruccions precises. En aquesta unitat veurem en quins llenguatges s'escriuen aquestes instruccions, com les entén l'ordinador i quines eines utilitzam per programar. Ens centrarem en **Python**, el llenguatge que farem servir durant tot el curs.

## 2.1. Què és un llenguatge de programació?

Un **llenguatge de programació** és un conjunt de regles i símbols que permet als programadors comunicar-se amb un ordinador.

Però per què el necessitam, si tots som capaços de fer servir un ordinador? Doncs perquè sempre ho feim a través d'un programa, una aplicació que ens permet interactuar amb la pantalla, el sistema operatiu, la impressora, la càmera… Els llenguatges de programació són l'idioma en què s'escriuen aquests programes i aplicacions.

Hi ha molts de llenguatges de programació. Per entendre per què, pensa en els idiomes: podem escriure, llegir i fer servir qualsevol idioma per a qualsevol cosa, però alguns tenen avantatges en contextos concrets. Per exemple, la ciència es publica majoritàriament en anglès, i si et dediques a l'arqueologia egípcia, conèixer els jeroglífics és imprescindible. Amb els llenguatges de programació passa el mateix: amb la majoria podem escriure pràcticament qualsevol programa, però alguns són més adequats, o s'han dissenyat expressament, per a un tipus concret de problemes.

## 2.2. Tipus de llenguatges de programació

Les instruccions per a un ordinador es poden escriure de maneres diferents: unes més properes al llenguatge que entén la màquina i unes altres més properes al llenguatge humà. Ho podem imaginar com una escala: **com més amunt pujam, més fàcil ens resulta entendre i escriure el codi; com més avall, més directament es comunica el codi amb el maquinari**.

### 2.2.1. Llenguatges de baix nivell

Són els més propers a la màquina i permeten un control directe del maquinari.

- **Llenguatge màquina**: és el nivell més bàsic, format per instruccions binàries (combinacions de 0 i 1) que el processador executa directament. Per exemple, una instrucció com `10110000 01100001` podia voler dir una cosa tan senzilla com «mou el valor 97 al registre A». Era un llenguatge molt ràpid per a l'ordinador, però molt difícil per a les persones.
- **Llenguatge assemblador**: és una representació simbòlica del llenguatge màquina que utilitza abreviatures anomenades mnemotècnics (per exemple, `MOV`, `ADD` o `JMP`) en lloc de codis binaris. És una mica més comprensible, però depèn molt del tipus de processador: el programador s'ha de preocupar de registres, adreces de memòria i salts entre instruccions.

Podem dir que **aquests llenguatges són al nivell de l'ordinador, no de la persona**.

### 2.2.2. Llenguatges de nivell mitjà

Amb el temps van aparèixer llenguatges com **C**, que combinaven la potència del baix nivell amb una sintaxi més propera al raonament humà. Encara calia saber com funcionava l'ordinador, però ja permetien escriure programes molt més complexos de manera estructurada. Són una mena de pont entre la màquina i el programador.

```c title="Programa en C que suma nombres fins que se n'introdueix un de negatiu"
#include <stdio.h>
int main() {
    int num = 0, suma = 0;
    do {
        suma = suma + num;
        printf("Dona'm un nombre: ");
        scanf("%d", &num);
    } while (num >= 0);
    printf("La suma és: %d", suma);
    return 0;
}
```

### 2.2.3. Llenguatges d'alt nivell

Els **llenguatges d'alt nivell** estan dissenyats perquè els programadors puguin expressar les idees d'una manera més natural, sense preocupar-se de com executa l'ordinador cada passa internament. Python, Java o C++ en són exemples. Són els més utilitzats avui perquè són més fàcils d'aprendre, més portables i molt més productius.

Mira el mateix programa d'abans escrit en Python:

```python title="El mateix programa en Python"
suma = 0
num = 0
while num >= 0:
    suma = suma + num
    num = int(input("Dona'm un nombre: "))
print("La suma és:", suma)
```

Dins dels llenguatges d'alt nivell en podem distingir dos grans grups:

- **Imperatius**: descriuen **com** s'ha de fer una tasca, amb instruccions seqüencials. Exemples: C, Pascal, Python.
- **Declaratius**: descriuen **què** es vol aconseguir, sense especificar com s'ha de fer. Exemples: SQL, HTML.

### 2.2.4. Llenguatges d'script i de propòsit específic

- Els **llenguatges d'script** s'utilitzen principalment per automatitzar tasques i per al desenvolupament web, i destaquen per la seva senzillesa i flexibilitat. Exemples: JavaScript i PHP.
- Els **llenguatges de propòsit específic** estan dissenyats per resoldre problemes d'un àmbit concret, com R per a l'estadística o MATLAB per a les matemàtiques i l'enginyeria.

## 2.3. Compiladors i intèrprets

Escrivim el codi en llenguatges d'alt nivell, però els ordinadors només entenen el llenguatge màquina. Aleshores, com és possible que entenguin una instrucció com `print("Hola")`?

La resposta són els **compiladors** i els **intèrprets**, programes que fan de traductors entre el nostre codi i el processador.

- Un **compilador** tradueix **tot el programa** a llenguatge màquina **abans d'executar-lo**. El resultat és un arxiu executable (per exemple, un `.exe`). Llenguatges com C o C++ funcionen així.
- Un **intèrpret** tradueix i executa el codi **línia a línia**. Això permet provar el programa ràpidament, encara que l'execució pot ser una mica més lenta. **Python** funciona d'aquesta manera.
- **Java** combina totes dues idees: el compilador tradueix primer el programa a un llenguatge intermedi anomenat *bytecode*, que no depèn del sistema operatiu, i després la **Màquina Virtual de Java** (JVM) l'executa fent d'intèrpret. Per això un mateix programa Java pot funcionar a Windows, macOS o Linux sense canvis: és **multiplataforma**.

| | Compilat | Interpretat |
| --- | --- | --- |
| Quan es tradueix | Tot el programa, abans d'executar-lo | Línia a línia, mentre s'executa |
| Resultat | Un arxiu executable | No genera executable; cal l'intèrpret |
| Velocitat d'execució | Més ràpida | Sol ser més lenta |
| Detecció d'errors | Abans d'executar, en compilar | Quan s'arriba a la línia amb l'error |
| Exemples | C, C++ | Python, JavaScript |

!!! info "Un matís"
    Internament, Python també tradueix el codi a un *bytecode* abans d'executar-lo, però aquest procés és automàtic i invisible per a nosaltres. Per això, a efectes pràctics, el consideram un llenguatge interpretat.

## 2.4. Per què Python?

Python és un llenguatge d'alt nivell i un dels més fàcils d'aprendre. Té una sintaxi molt clara i concisa, que elimina molts de detalls difícils de recordar i en fa l'aprenentatge més àgil.

Un altre avantatge és la seva enorme **biblioteca estàndard** (les eines que ofereix per defecte), que es pot ampliar amb una de les col·leccions de biblioteques més grans del món, creades i mantingudes per una gran comunitat de programadors.

El va desenvolupar Guido van Rossum i se'n va publicar la primera versió el 1991. S'ha fet popular per la seva senzillesa i versatilitat, i és ideal tant per a principiants com per a programadors experimentats.

![Guido van Rossum, creador de Python](img/u2/guido-van-rossum.jpg){ width="360" }

Aquestes són les principals aplicacions de Python:

- **Desenvolupament web**, amb *frameworks* com Django i Flask.
- **Ciència de dades**, amb biblioteques molt potents com pandas, NumPy i SciPy.
- **Intel·ligència artificial**, amb eines com TensorFlow i scikit-learn.
- **Automatització** de tasques en sistemes operatius i aplicacions.
- **Desenvolupament de programari** d'escriptori.

**Python no és només una eina per programar, sinó una plataforma per innovar i resoldre problemes en molts d'àmbits.**

## 2.5. Entorns de desenvolupament integrat (IDE)

Per escriure, provar i corregir programes de manera eficient, necessitam un lloc on fer-ho: un **entorn de desenvolupament integrat** o **IDE** (de l'anglès *Integrated Development Environment*).

Un IDE és el taller del programador. Igual que un mecànic necessita eines, un programador necessita un entorn que li faciliti la feina. Un IDE sol incloure:

- **Editor de codi**: on escrivim el programa. Sol acolorir les paraules clau, completar automàticament el codi i sagnar-lo, cosa que el fa més llegible.
- **Compilador o intèrpret integrat**: tradueix el codi al llenguatge que entén l'ordinador.
- **Depurador** (*debugger*): permet executar el programa pas a pas, veure el valor de les variables i trobar errors sense haver d'anar a les palpentes.
- **Gestor d'arxius**: manté organitzats tots els fitxers d'un mateix programa.
- **Consola de sortida**: mostra els resultats, els missatges o els errors que genera el programa.

És com un quadern intel·ligent per programar: no només hi escrivim, sinó que també ens corregeix, ens suggereix millores i ens ajuda a entendre on ens hem equivocat.

Alguns dels IDE més habituals per a Python són:

| IDE | Per a qui és | Observacions |
| --- | --- | --- |
| [Thonny](https://thonny.org/) | Principiants | Molt senzill; els instal·ladors de Windows i macOS ja inclouen Python, i té un depurador que mostra pas a pas què passa. **Recomanat per començar.** |
| [Visual Studio Code](https://code.visualstudio.com/) | Nivell mitjà i avançat | Editor molt popular i ampliable amb extensions per a molts de llenguatges. |
| [PyCharm](https://www.jetbrains.com/pycharm/) | Professionals | Un dels entorns més utilitzats professionalment per programar en Python. |
| [Google Colab](https://colab.research.google.com/) | Qualsevol, des del navegador | No cal instal·lar res; funciona amb un compte de Google. Molt utilitzat en ciència de dades. |

!!! tip "Instal·lar Thonny a casa"
    Descarrega Thonny des de [thonny.org](https://thonny.org/) (hi ha versions per a Windows, macOS i Linux) i instal·la'l amb les opcions per defecte. A Windows i macOS no cal instal·lar Python a part, perquè l'instal·lador de Thonny ja l'inclou. Quan l'obris, escriu `print("Hola, món!")` a l'editor, desa l'arxiu i prem el botó verd **Run** (o la tecla ++f5++). Si a la part inferior (la consola, o *Shell*) apareix `Hola, món!`, ja tens l'entorn a punt.

## 2.6. Estructura d'un programa en Python

L'estructura d'un programa en Python es caracteritza per la seva senzillesa, que en fa el codi més fàcil de llegir i de mantenir. Vegem-ne els components principals. No cal que te n'aprenguis ara la sintaxi, perquè la veurem amb detall més endavant, però és bo que et comenci a sonar.

### Importació de mòduls

Python inclou moltíssimes funcions, però encara les podem ampliar amb biblioteques (**mòduls**) que ofereixen eines addicionals. Importar mòduls permet reutilitzar codi fet per altres. Les importacions se solen posar al principi del programa.

```python
import math
import sys
from datetime import datetime
```

Aquests tres mòduls ofereixen eines per fer càlculs matemàtics, interactuar amb el sistema operatiu i treballar amb dates i hores, respectivament.

### Definició de funcions i classes

Les **funcions** agrupen blocs de codi reutilitzables i les **classes** permeten la programació orientada a objectes (que veurem a 2n de batxillerat).

```python
def calcular_area_cercle(radi):
    return math.pi * radi ** 2

class Persona:
    def __init__(self, nom, edat):
        self.nom = nom
        self.edat = edat
```

Aquí hem definit una funció que calcula l'àrea d'un cercle i una classe per representar persones.

### Comentaris

Els **comentaris** són fonamentals per entendre i mantenir el codi. Encara que són dins del programa, no s'executen: només serveixen perquè els programadors es deixin missatges sobre com funciona el codi.

Python utilitza el símbol `#` per als comentaris d'una línia i les cometes triples (`"""` o `'''`) per als textos de diverses línies.

```python
# Aquest és un comentari d'una sola línia

"""
Aquest és un text de diverses línies.
Es fa servir per descriure funcions, classes o mòduls.
També s'utilitza per explicar per què el programador
ha pres una decisió de disseny concreta i no una altra.
"""
```

### Sagnat

Python utilitza el **sagnat** (els espais a l'inici de la línia) per definir blocs de codi, i això és molt important: **cada nivell de sagnat (normalment, quatre espais) indica un bloc nou**. Un sagnat incorrecte provoca errors o fa que el programa faci una altra cosa.

```python
def saludar(nom):
    if nom:
        print(f"Hola, {nom}!")
    else:
        print("Hola, món!")
```

### Un exemple complet

```python
import math

def calcular_area_cercle(radi):
    """Calcula l'àrea d'un cercle a partir del radi."""
    return math.pi * radi ** 2

class Persona:
    """Representa una persona amb un nom i una edat."""
    def __init__(self, nom, edat):
        self.nom = nom
        self.edat = edat

def main():
    """Funció principal del programa."""
    radi = float(input("Introdueix el radi del cercle: "))
    area = calcular_area_cercle(radi)
    print(f"L'àrea del cercle és: {area}")

    persona = Persona("Joana", 30)
    print(f"Nom: {persona.nom}, edat: {persona.edat}")

if __name__ == "__main__":
    main()
```

La darrera línia, `if __name__ == "__main__":`, indica que la funció `main()` s'ha d'executar quan executam directament aquest arxiu. De moment, basta que sàpigues que és una manera habitual de marcar on comença el programa.

!!! example "Exercici 2.1. El meu primer programa"
    1. Instal·la Thonny (o fes servir l'entorn que tengueu a l'aula) i executa el programa `print("Hola, món!")`.
    2. Copia l'exemple complet d'aquesta unitat, executa'l i prova-lo amb diferents valors del radi.
    3. Canvia el nom i l'edat de la persona per les teves dades i torna'l a executar.
    4. Esborra els quatre espais d'una línia del cos d'una funció i torna a executar el programa. Quin missatge d'error apareix? Què vol dir?

!!! example "Exercici 2.2. Compilat o interpretat?"
    Cerca informació sobre aquests llenguatges i classifica'ls en una taula segons si són de baix nivell, de nivell mitjà o d'alt nivell, i segons si normalment es compilen o s'interpreten: C, Python, JavaScript, assemblador, C++, PHP, Java.

---

!!! quote "Font"
    Unitat elaborada a partir de materials de Lope González Vázquez ([CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ca)): [«Tema 11. Fundamentos de programación»](https://lopegonzalez.es/eso-y-bachillerato/tic-i-1o-bachillerato/tema-11-fundamentos-de-programacion/) (TIC I), [«Tema 2. Introducción a la programación»](https://lopegonzalez.es/eso-y-bachillerato/programacion-y-computacion-2o-bachillerato/tema-2-introduccion-a-la-programacion/) i [«Tema 1. Ingeniería del software»](https://lopegonzalez.es/eso-y-bachillerato/programacion-y-computacion-2o-bachillerato/tema-1-ingenieria-del-software/) (Programación y computación). Canvis: traducció al català, adaptació al currículum de Programació i Tractament de Dades I de les Illes Balears, combinació de les fonts, exemples de Java passats a Python i canvi de l'entorn de treball (PyCharm) per Thonny. Són propis la taula comparativa entre llenguatges compilats i interpretats, la nota sobre el *bytecode* de Python, les instruccions d'instal·lació de Thonny i els exercicis 2.1 i 2.2.
