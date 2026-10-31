# Bases de dades no relacionals: JSON i MongoDB

Les bases de dades relacionals funcionen molt bé quan saps per endavant quines dades guardaràs i aquestes dades canvien poc: les notes d'un institut, l'inventari d'una botiga. Però quan obres una xarxa social o una plataforma de vídeo, generes dades de manera contínua i de formes molt diverses: una publicació només té text, una altra té tres fotos i una ubicació, una altra és un vídeo amb subtítols. En aquest mòdul descobriràs el format **JSON**, les bases de dades **NoSQL** i com es treballa amb **MongoDB**, la base de dades documental més coneguda.

| Fitxa del mòdul | |
| --- | --- |
| **Nivell** | PTD II |
| **Requisits previs** | [Fonaments i disseny](fonaments.md). Per a l'apartat 3, Python: llistes, diccionaris i fitxers |
| **Vídeo** | No n'hi ha cap d'associat. El curs «Hello SQL» de MoureDev només tracta bases de dades relacionals |
| **Durada orientativa** | 6-8 sessions |
| **Relació amb el currículum** | PTD II, competència específica 3 («utilitzar les bases de dades i els diferents repositoris com a fonts de dades») i criteri d'avaluació 3.3 (formats com CSV i JSON; programes que fan servir fitxers). Sabers: formats d'emmagatzematge d'informació i lectura i escriptura de fitxers. Les bases de dades NoSQL no apareixen explícitament al currículum: són ampliació |

## 1. Més enllà de les taules

### 1.1. *Big data*: volum i varietat

Pensa en tot el que passa en un sol minut en una aplicació de missatgeria a tot el món: milions de missatges, àudios, fotos, vídeos, reaccions, estats… I no passa una vegada al dia, sinó contínuament. El terme ***big data*** (dades massives) descriu situacions en què es generen tantes dades, i tan diverses, que les eines tradicionals no les poden gestionar sense dificultats serioses.

El *big data* no és només cosa de les grans empreses tecnològiques. Una plataforma educativa registra accessos, temps de connexió, lliuraments i resultats de qüestionaris; un club esportiu professional recull dades de sensors i estadístiques de joc de cada entrenament. Analitzar aquestes dades permet detectar dificultats d'aprenentatge o millorar el rendiment.

Dues característiques expliquen per què calen noves maneres d'emmagatzemar la informació:

- **Volum**: la quantitat de dades és enorme i creix sense aturar-se. Cal un sistema que pugui créixer sense haver de refer tota l'estructura cada vegada que augmenten els usuaris.
- **Varietat**: les dades tenen formats molt diferents (textos, números, imatges, vídeos, ubicacions, llistes…) i no tots els elements tenen les mateixes característiques.

### 1.2. Dades estructurades, semiestructurades i no estructurades

| Tipus | Característiques | Exemples | On es guarden bé |
| --- | --- | --- | --- |
| **Estructurades** | Estructura fixa i definida per endavant: tots els elements tenen els mateixos camps | Les notes d'un institut, els moviments d'un compte bancari | Bases de dades relacionals |
| **Semiestructurades** | Tenen un ordre intern (noms de camps, jerarquia), però no tots els elements tenen els mateixos camps | Perfils d'usuari d'una xarxa social, dades d'una aplicació en format JSON | Bases de dades documentals |
| **No estructurades** | No es poden dividir en camps sense perdre'n el sentit | Fotos, vídeos, àudios, textos lliures | Sistemes de fitxers i emmagatzematge d'objectes, amb les seves dades descriptives en una base de dades |

Intentar ficar dades semiestructurades en una taula obliga a crear moltes columnes que, a la majoria de files, quedarien buides, o a modificar l'estructura de la taula cada vegada que l'aplicació incorpora una funcionalitat nova.

!!! example "Exercici 1. Classifica-les"
    Indica si aquestes dades són estructurades, semiestructurades o no estructurades:

    1. L'horari de classes de l'institut (grup, dia, hora, assignatura, aula).
    2. Un missatge de veu.
    3. La configuració d'un usuari en un videojoc: alguns jugadors han personalitzat els controls, d'altres el so, d'altres la interfície, i cada actualització del joc afegeix opcions noves.
    4. Les fotos d'una excursió.
    5. Les publicacions d'una xarxa social: totes tenen autor i data, però unes tenen text, d'altres imatges, d'altres enquestes.
    6. El registre d'entrades i sortides del pàrquing de l'institut (matrícula, data i hora d'entrada, data i hora de sortida).

    ??? success "Solució"
        1. Estructurades. 2. No estructurades. 3. Semiestructurades. 4. No estructurades: la imatge en si; la data, l'autor o la ubicació de cada foto sí que es poden guardar de manera estructurada. 5. Semiestructurades. 6. Estructurades.

## 2. JSON

**JSON** (*JavaScript Object Notation*) és un **format d'intercanvi de dades** en text. No és una base de dades ni un llenguatge de programació: és una manera d'escriure dades perquè les puguin llegir fàcilment tant les persones com els programes. És el format que fan servir la majoria d'aplicacions web i de mòbil per enviar dades entre el servidor i l'aplicació. Per exemple, quan una aplicació del temps et mostra la previsió, el servidor li ha enviat una cosa semblant a:

```json
{
  "municipi": "Palma",
  "temperatura": 27,
  "humitat": 62,
  "vent": 18.5,
  "avis": false
}
```

### 2.1. Estructura

Un document JSON es construeix amb:

- **Objectes**, entre claus `{ }`: conjunts de parelles **clau: valor**, separades per comes.
- **Llistes** (*arrays*), entre claudàtors `[ ]`: valors separats per comes.

I els valors només poden ser d'aquests tipus:

| Tipus JSON | Exemple | En Python |
| --- | --- | --- |
| Text (*string*) | `"Palma"` | `str` |
| Nombre | `27`, `18.5` | `int`, `float` |
| Booleà | `true`, `false` | `True`, `False` |
| Nul | `null` | `None` |
| Objecte | `{"mitjana": 8.4, "vots": 5200}` | `dict` |
| Llista | `["aventura", "misteri"]` | `list` |

Els objectes i les llistes es poden **niuar**, és a dir, posar els uns dins els altres. Així es representen dades complexes en un sol document:

```json
{
  "usuari": "PixelMallorquí",
  "nivell": 27,
  "assoliments": ["Primer torneig", "100 partides"],
  "equip": {
    "arma": "Espasa làser",
    "escut": "Escut d'energia"
  }
}
```

Com veus, un document JSON s'assembla molt a un diccionari de Python. Però hi ha diferències que fan que un text JSON que «sembla Python» no sigui vàlid.

### 2.2. Les regles

Un JSON només és vàlid si compleix aquestes normes estrictes:

1. Les **claus** van sempre entre **cometes dobles**.
2. Els **textos** també van entre cometes dobles. Les cometes simples no són vàlides.
3. **No** hi pot haver una **coma després de l'últim element** d'un objecte o d'una llista.
4. Els booleans i el nul s'escriuen en minúscula: `true`, `false`, `null`.
5. No s'hi poden posar comentaris.

!!! tip "Eines"
    Hi ha validadors en línia com [JSONLint](https://jsonlint.com/) que comproven si un JSON és vàlid i assenyalen on és l'error. Visual Studio Code també marca en vermell els errors dels fitxers `.json` i els pot formatar (clic dret → **Format Document**).

!!! example "Exercici 2. Troba els errors"
    Cap d'aquests fragments no és un JSON vàlid. Explica per què i corregeix-los.

    1. `{nom: "Aina", edat: 17}`
    2. `{'nom': 'Aina'}`
    3. `{"actiu": True}`
    4. `{"notes": [7, 8, ], "tutor": null}`
    5. `{"nom": "Aina", "edat": 17,}`

    ??? success "Solució"
        1. Les claus no tenen cometes: `{"nom": "Aina", "edat": 17}`.
        2. Fa servir cometes simples: `{"nom": "Aina"}`.
        3. `True` s'escriu en minúscula: `{"actiu": true}`.
        4. Sobra la coma després del 8: `{"notes": [7, 8], "tutor": null}`. El `null` sí que és correcte.
        5. Sobra la coma final: `{"nom": "Aina", "edat": 17}`.

        Els errors 2 i 3 són típics de qui ve de Python: el diccionari `{'actiu': True}` és Python vàlid, però no JSON vàlid.

!!! example "Exercici 3. Escriu un JSON"
    Una plataforma de videojocs vol guardar la informació de cada jugador en JSON. Escriu el document d'un jugador amb:

    - Nom d'usuari, edat, país, nivell i punts totals.
    - Una llista d'almenys tres assoliments.
    - La configuració del perfil: si és públic i si té les notificacions activades.
    - Les dues darreres partides; de cada una, la data, els punts obtinguts i la durada en minuts.

    Comprova que és vàlid amb un validador.

    ??? success "Solució"
        ```json
        {
          "usuari": "PixelMallorquí",
          "edat": 17,
          "pais": "Espanya",
          "nivell": 12,
          "punts": 8450,
          "assoliments": ["Primera victòria", "100 partides", "Nivell 10"],
          "configuracio": {
            "perfilPublic": false,
            "notificacions": true
          },
          "darreresPartides": [
            {"data": "2026-10-20", "punts": 1200, "minuts": 35},
            {"data": "2026-10-24", "punts": 980, "minuts": 28}
          ]
        }
        ```

        - La configuració és un **objecte** dins l'objecte principal, perquè agrupa dues dades relacionades.
        - Les partides són una **llista d'objectes**: cada partida té els mateixos camps i n'hi pot haver tantes com calgui.
        - Les dates s'escriuen com a text, perquè JSON no té un tipus data. El format `"any-mes-dia"` és el més habitual perquè s'ordena bé.
        - En una base de dades relacional, aquest jugador ocuparia almenys tres taules: jugadors, assoliments i partides.

## 3. JSON amb Python

Python porta incorporat el mòdul `json`, que converteix entre text JSON i les estructures de Python (diccionaris, llistes…). Per als exemples d'aquest apartat i dels següents, descarrega [`titols.json`](fitxers/titols.json): un catàleg inventat d'una plataforma de vídeo, amb sèries, pel·lícules i documentals. Desa'l a la mateixa carpeta que el teu programa.

| Funció | Fa |
| --- | --- |
| `json.load(fitxer)` | Llegeix un fitxer JSON i el converteix en dades de Python |
| `json.dump(dades, fitxer)` | Escriu dades de Python en un fitxer JSON |
| `json.loads(text)` | Converteix un text JSON (*string*) en dades de Python |
| `json.dumps(dades)` | Converteix dades de Python en un text JSON |

```python
import json

with open("titols.json", encoding="utf-8") as fitxer:
    titols = json.load(fitxer)

print(type(titols), len(titols))
print(titols[0]["titol"], titols[0]["valoracio"]["mitjana"])
```

```text
<class 'list'> 6
Els guardians de Cabrera 8.4
```

El fitxer conté una **llista** de sis **diccionaris**. Per accedir a les dades niuades s'encadenen els índexs i les claus: `titols[0]["valoracio"]["mitjana"]`.

Per escriure, `json.dump` té dos paràmetres molt útils: `indent=2`, que fa el fitxer llegible amb sagnats, i `ensure_ascii=False`, que guarda els accents tal qual en lloc de convertir-los en codis com `à`.

```python
with open("copia.json", "w", encoding="utf-8") as fitxer:
    json.dump(titols, fitxer, ensure_ascii=False, indent=2)
```

!!! warning "No tots els documents tenen els mateixos camps"
    A `titols.json`, les sèries tenen `temporades` i les pel·lícules, `durada`; i una pel·lícula no té `valoracio`. Si accedeixes a `t["valoracio"]` en un document que no la té, Python dona un `KeyError`. Comprova-ho abans amb `"valoracio" in t`, o fes servir `t.get("valoracio")`, que retorna `None` si la clau no existeix.

!!! example "Exercici 4"
    Escriu un programa que llegeixi `titols.json` i:

    1. Mostri el títol i la valoració mitjana dels títols que tenen una mitjana de 8 o més.
    2. Mostri el nombre total d'episodis de cada títol que té temporades.
    3. Desi en un fitxer nou, `pellicules.json`, només les pel·lícules disponibles, amb els accents llegibles i amb sagnat.

    ??? success "Solució"
        ```python
        import json

        with open("titols.json", encoding="utf-8") as fitxer:
            titols = json.load(fitxer)

        # 1. Títols amb una valoració mitjana de 8 o més
        for t in titols:
            if "valoracio" in t and t["valoracio"]["mitjana"] >= 8:
                print(t["titol"], t["valoracio"]["mitjana"])

        # 2. Nombre total d'episodis de cada sèrie o documental
        for t in titols:
            if "temporades" in t:
                total = sum(temporada["episodis"] for temporada in t["temporades"])
                print(f"{t['titol']}: {total} episodis")

        # 3. Fitxer nou només amb les pel·lícules disponibles
        pellicules = [t for t in titols if t["tipus"] == "pellicula" and t["disponible"]]
        with open("pellicules.json", "w", encoding="utf-8") as fitxer:
            json.dump(pellicules, fitxer, ensure_ascii=False, indent=2)
        print(len(pellicules), "pel·lícules desades")
        ```

        ```text
        Els guardians de Cabrera 8.4
        La Mediterrània submergida 9.0
        Els guardians de Cabrera: 14 episodis
        La Mediterrània submergida: 5 episodis
        Institut Son Robot: 10 episodis
        2 pel·lícules desades
        ```

        Les dues pel·lícules desades són *Tramuntana* i *El darrer far*; *Codi vermell* no està disponible. Sense la comprovació `"valoracio" in t`, el programa s'aturaria amb un `KeyError` en arribar a *El darrer far*.

## 4. Bases de dades NoSQL

Les bases de dades **NoSQL** guarden les dades sense fer servir el model de taules relacionades. El nom no vol dir «sense SQL», sinó ***not only SQL***, «no només SQL»: no vénen a substituir les bases de dades relacionals, sinó a complementar-les allà on aquestes no s'adapten bé.

Pensa en una aplicació de missatgeria: un missatge pot ser només text, però també pot incloure imatges, àudios, respostes a un altre missatge o reaccions. En un model NoSQL, cada missatge guarda només la informació que necessita, sense columnes buides i sense haver de modificar l'estructura general quan l'aplicació incorpora una novetat.

### 4.1. Models NoSQL

| Model | Com guarda les dades | Bo per a… | Exemple de SGBD |
| --- | --- | --- | --- |
| **Documental** | Documents semblants a JSON, agrupats en col·leccions | Aplicacions web i de mòbil, catàlegs, perfils d'usuari | [MongoDB](https://www.mongodb.com/) |
| **Clau-valor** | Cada clau té associat un valor, com un diccionari gegant | Sessions d'usuari, memòria cau, dades que s'han de recuperar a l'instant | [Redis](https://redis.io/) |
| **Orientat a columnes** | Les dades s'organitzen per columnes en lloc de per files | Anàlisi de volums enormes de dades | [Apache Cassandra](https://cassandra.apache.org/) |
| **De grafs** | Nodes i relacions entre ells | Xarxes socials, recomanacions, rutes: quan el més important són les connexions | [Neo4j](https://neo4j.com/) |

### 4.2. Relacional o NoSQL?

No hi ha un model millor que l'altre en tots els casos. Cada un respon a problemes diferents:

| | Relacional | Documental (NoSQL) |
| --- | --- | --- |
| Estructura | Fixa: es defineix **abans** d'inserir dades | Flexible: cada document porta la seva estructura |
| Relacions | Claus foranes, controlades pel gestor | Documents niuats o referències, controlades per l'aplicació |
| Integritat | El gestor imposa restriccions (`NOT NULL`, `CHECK`, `FOREIGN KEY`…) | L'aplicació ha de vigilar que les dades siguin correctes |
| Consultes | SQL, un llenguatge estàndard | Llenguatge propi de cada SGBD |
| Adequada per a… | Dades estructurades on la consistència és clau: notes, comptabilitat, reserves | Dades variades i canviants, i aplicacions que han de créixer ràpidament |

!!! info "Moltes aplicacions en fan servir més d'una"
    És habitual que una mateixa aplicació combini models: per exemple, una botiga en línia pot guardar les comandes i els pagaments en una base de dades relacional, el catàleg de productes en una documental i les sessions dels usuaris en una de clau-valor.

!!! example "Exercici 5. Quin model?"
    Quin model triaries per a cada cas? Justifica-ho.

    1. La gestió de les matrícules i les notes d'una universitat.
    2. Un sistema que suggereix «persones que potser coneixes» a partir dels amics dels teus amics.
    3. El catàleg d'una botiga en línia que ven des de llibres fins a bicicletes, cada producte amb característiques molt diferents.
    4. Guardar, durant uns minuts, el carretó de la compra de cada usuari que navega per una web.
    5. El sistema de reserves de seients d'una companyia aèria.

    ??? success "Solució"
        1. **Relacional**: dades estructurades i estables on la integritat és essencial.
        2. **Grafs**: el que importa són les connexions entre persones.
        3. **Documental**: cada producte té camps diferents (un llibre té autor i pàgines; una bicicleta, talla i nombre de marxes).
        4. **Clau-valor**: la clau és l'identificador de la sessió i el valor, el carretó; s'ha de recuperar molt de pressa i és temporal.
        5. **Relacional**: no es pot vendre dues vegades el mateix seient, i les transaccions del gestor ho garanteixen.

        En alguns casos es podrien defensar altres opcions. El que compta és la justificació.

## 5. MongoDB

**MongoDB** és una base de dades **documental**. Organitza la informació en tres nivells:

| MongoDB | Equivalent aproximat en una base de dades relacional |
| --- | --- |
| **Base de dades**: el contenidor de tota la informació d'una aplicació | Base de dades |
| **Col·lecció**: un grup de documents del mateix tipus, com `usuaris` o `titols` | Taula |
| **Document**: un element, amb estructura semblant a JSON | Fila |
| **Camp**: una parella clau-valor d'un document | Columna |

La diferència fonamental és que **una col·lecció no obliga que tots els seus documents tenguin la mateixa estructura**. En una base de dades relacional, l'estructura es defineix abans d'inserir les dades; a MongoDB, cada document defineix la seva estructura en el moment de guardar-se.

Cada document té un camp `_id` que l'identifica, com una clau primària. Si no l'indiques, MongoDB el crea automàticament amb un valor de tipus `ObjectId`, per exemple `ObjectId("6720f1a2c3b4d5e6f7a8b9c0")`.

!!! info "JSON i BSON"
    Internament, MongoDB no guarda text JSON, sinó **BSON** (*Binary JSON*), una versió binària que ocupa menys, es llegeix més de pressa i té més tipus de dades, com dates o el mateix `ObjectId`. Per a nosaltres, però, els documents s'escriuen i es veuen com a JSON.

### 5.1. Preparar l'entorn

Necessites un servidor de MongoDB i un client:

- **Servidor**: [MongoDB Community Server](https://www.mongodb.com/try/download/community), instal·lat a l'ordinador, o un clúster gratuït a [MongoDB Atlas](https://www.mongodb.com/atlas), el servei al núvol de MongoDB. Consulta'n les condicions actuals abans de registrar-t'hi.
- **Client**: [MongoDB Compass](https://www.mongodb.com/products/tools/compass), l'aplicació gràfica oficial. Compass inclou a la part inferior un intèrpret d'ordres, **mongosh**, on es poden escriure les ordres directament.

Lope González explica pas a pas la instal·lació i la configuració a la pàgina [«Instalación y configuración de MongoDB»](https://lopegonzalez.es/eso-y-bachillerato/programacion-y-computacion-2o-bachillerato/tema-5-bases-de-datos-no-relacionales/instalacion-y-configuracion-de-mongodb/) (en castellà).

### 5.2. Crear la base de dades i importar documents

A MongoDB, una base de dades i una col·lecció no existeixen de debò fins que s'hi guarda el primer document.

=== "Compass"

    1. Connecta't al servidor i, al costat del nom de la connexió, prem **+** per crear una base de dades.
    2. Posa `plataforma` com a nom de la base de dades i `titols` com a nom de la col·lecció, i prem **Create Database**.
    3. Obre la col·lecció `titols` i prem **ADD DATA → Import JSON or CSV file**. Tria `titols.json` i importa'l.
    4. A la pestanya **Documents** veuràs els sis documents, cada un amb el seu `_id`.

=== "mongosh"

    ```javascript
    use plataforma
    db.titols.insertOne({
      tipus: "serie",
      titol: "Els guardians de Cabrera",
      any: 2023,
      generes: ["aventura", "misteri"]
    })
    ```

    `use` selecciona la base de dades (i la crearà quan s'hi guardi el primer document). `insertOne` insereix un document; `insertMany` en rep una llista. Per importar el fitxer sencer, és més còmode fer-ho amb Compass.

    A mongosh, les claus es poden escriure sense cometes (`tipus: "serie"`), perquè és JavaScript; però si una clau té un punt, com `"valoracio.mitjana"`, ha d'anar entre cometes.

Fixa't en dos documents de la mateixa col·lecció. Una sèrie:

```json
{
  "tipus": "serie",
  "titol": "Els guardians de Cabrera",
  "any": 2023,
  "generes": ["aventura", "misteri"],
  "edat": 12,
  "disponible": true,
  "temporades": [
    { "numero": 1, "episodis": 8 },
    { "numero": 2, "episodis": 6 }
  ],
  "valoracio": { "mitjana": 8.4, "vots": 5200 }
}
```

I una pel·lícula, que no té `temporades` sinó `durada` i `idiomes`:

```json
{
  "tipus": "pellicula",
  "titol": "Tramuntana",
  "any": 2019,
  "generes": ["drama"],
  "durada": 104,
  "edat": 16,
  "disponible": true,
  "idiomes": ["ca", "es"],
  "valoracio": { "mitjana": 7.1, "vots": 3100 }
}
```

En una base de dades relacional, guardar-les a la mateixa taula obligaria a tenir columnes que quedarien buides en uns casos o en uns altres, o bé a repartir-les en diverses taules. A MongoDB conviuen sense problemes a la mateixa col·lecció.

### 5.3. Consultar

A Compass, a la pestanya **Documents** hi ha una barra de filtre (**Filter**): s'hi escriu un objecte amb les condicions i es prem **Find**. A mongosh, el mateix filtre es passa a `db.titols.find()`:

```javascript
db.titols.find({ tipus: "serie" })
```

**Igualtat.** Les condicions més senzilles són parelles camp: valor. Si n'hi ha diverses, s'han de complir totes (com `AND`):

```javascript
{ tipus: "pellicula", disponible: true }
```

**Operadors de comparació.** Comencen amb `$`:

| Operador | Significat | Exemple |
| --- | --- | --- |
| `$gt`, `$gte` | Major que, major o igual que | `{ any: { $gte: 2021 } }` |
| `$lt`, `$lte` | Menor que, menor o igual que | `{ durada: { $lt: 110 } }` |
| `$ne` | Diferent de | `{ tipus: { $ne: "pellicula" } }` |
| `$in` | És un dels valors de la llista | `{ generes: { $in: ["accio", "drama"] } }` |
| `$exists` | El camp existeix (o no) | `{ valoracio: { $exists: false } }` |

**Combinar condicions amb `$or`**:

```javascript
{ $or: [ { edat: { $lte: 7 } }, { generes: "comedia" } ] }
```

**Llistes.** Si un camp és una llista, la condició es compleix quan **algun** element hi coincideix. `{ generes: "misteri" }` troba els títols que tenen «misteri» entre els seus gèneres. `$all` exigeix que hi siguin tots: `{ generes: { $all: ["misteri", "drama"] } }`.

**Camps niuats.** S'hi accedeix amb un punt, i la clau va entre cometes:

```javascript
{ "valoracio.mitjana": { $gt: 8 } }
{ "temporades.episodis": { $gte: 10 } }
```

**Projecció, ordre i límit.** El segon paràmetre de `find` indica quins camps es mostren (1 per mostrar-lo, 0 per amagar-lo). Compass ho té a les opcions del filtre (**Options**: *Project*, *Sort*, *Limit*):

```javascript
db.titols.find({ tipus: "pellicula" }, { titol: 1, durada: 1, _id: 0 })
db.titols.find({}).sort({ "valoracio.mitjana": -1 }).limit(3)
db.titols.countDocuments({ disponible: true })
```

L'1 de `sort` vol dir ascendent i el −1, descendent.

| SQL | MongoDB |
| --- | --- |
| `SELECT * FROM titols WHERE tipus = 'serie'` | `db.titols.find({ tipus: "serie" })` |
| `SELECT titol, durada FROM titols WHERE …` | `db.titols.find({ … }, { titol: 1, durada: 1, _id: 0 })` |
| `… WHERE any >= 2021` | `{ any: { $gte: 2021 } }` |
| `… ORDER BY mitjana DESC LIMIT 3` | `.sort({ "valoracio.mitjana": -1 }).limit(3)` |
| `SELECT COUNT(*) … WHERE disponible` | `db.titols.countDocuments({ disponible: true })` |

!!! tip "L'assistent d'IA de Compass"
    Compass incorpora un assistent que proposa filtres a partir d'una descripció en llenguatge natural. Fes-lo servir com a ajuda per comprovar o desencallar-te, mai com a primera opció: si no domines la sintaxi, no sabràs detectar quan s'equivoca.

!!! example "Exercici 6"
    Escriu el filtre de cada consulta sobre la col·lecció `titols` i indica quins títols retorna.

    1. Títols estrenats el 2021 o després.
    2. Títols del gènere misteri.
    3. Pel·lícules disponibles.
    4. Títols amb una valoració mitjana superior a 8.
    5. Títols que no tenen valoració.
    6. Títols aptes per a menors de 12 anys (edat inferior a 12) i de ciència-ficció.
    7. Pel·lícules que es poden veure en anglès (`"en"`).
    8. Els tres títols amb millor valoració, de més a menys, mostrant només el títol i la valoració.

    ??? success "Solució"
        | # | Filtre | Resultat |
        | --- | --- | --- |
        | 1 | `{ any: { $gte: 2021 } }` | Els guardians de Cabrera, La Mediterrània submergida, Codi vermell, Institut Son Robot |
        | 2 | `{ generes: "misteri" }` | Els guardians de Cabrera, El darrer far |
        | 3 | `{ tipus: "pellicula", disponible: true }` | Tramuntana, El darrer far |
        | 4 | `{ "valoracio.mitjana": { $gt: 8 } }` | Els guardians de Cabrera, La Mediterrània submergida |
        | 5 | `{ valoracio: { $exists: false } }` | El darrer far |
        | 6 | `{ generes: "ciencia-ficcio", edat: { $lt: 12 } }` | Institut Son Robot |
        | 7 | `{ tipus: "pellicula", idiomes: "en" }` | Codi vermell |

        8\.
        ```javascript
        db.titols.find({}, { titol: 1, valoracio: 1, _id: 0 })
                 .sort({ "valoracio.mitjana": -1 })
                 .limit(3)
        ```

        Resultat: La Mediterrània submergida (9,0), Els guardians de Cabrera (8,4) i Institut Son Robot (7,8).

        A la consulta 5, *El darrer far* és una pel·lícula que encara no té valoracions: a MongoDB, el camp simplement no hi és. En una taula relacional, la columna existiria i valdria `NULL`.

### 5.4. Modificar i esborrar

```javascript
// Canviar un camp d'un document
db.titols.updateOne({ titol: "Codi vermell" }, { $set: { disponible: true } })

// Afegir un element a una llista
db.titols.updateOne({ titol: "Tramuntana" }, { $push: { generes: "historic" } })

// Esborrar un document
db.titols.deleteOne({ titol: "Codi vermell" })
```

El primer paràmetre és el filtre que tria el document, igual que el `WHERE` de l'SQL. `updateMany` i `deleteMany` afecten **tots** els documents que compleixen el filtre; amb un filtre buit, `{}`, afecten tota la col·lecció.

!!! danger "Sense `$set`, el document se substitueix"
    A `updateOne`, si escrius `{ disponible: true }` sense `$set`, mongosh dona error, però altres eines i mètodes, com `replaceOne`, **substitueixen el document sencer** pel nou, i es perden tots els altres camps. Fes servir sempre `$set` per canviar camps concrets.

A Compass, també pots editar o esborrar un document directament des de la pestanya **Documents**, amb les icones que apareixen en passar-hi el ratolí per damunt.

### 5.5. Analitzar l'estructura

MongoDB no imposa una estructura, però la pot **deduir** a partir dels documents. A Compass, la pestanya **Schema** de la col·lecció (botó **Analyze Schema**) mostra:

- Tots els camps que apareixen a algun document.
- El tipus de dada de cada camp (*String*, *Number*, *Array*, *Object*, *Boolean*…).
- El percentatge de documents que tenen cada camp.

A `titols`, per exemple, veuràs que `temporades` només apareix en una part dels documents (les sèries i el documental), que `durada` i `idiomes` només són a les pel·lícules i que `narradora` només és en un document. Aquesta anàlisi ajuda a detectar errors, com un camp que en uns documents és un nombre i en d'altres, un text.

## 6. Relacions a MongoDB

Les dades d'una aplicació continuen estant relacionades: un usuari valora molts títols, i un títol rep valoracions de molts usuaris. A MongoDB hi ha dues maneres de representar-ho.

### 6.1. Documents niuats

La informació relacionada es guarda **dins** el mateix document. Ja ho has vist: les temporades d'una sèrie són una llista d'objectes dins el document de la sèrie. Així, una sola consulta obté tota la informació, sense cap `JOIN`.

És adequat quan les dades niuades **pertanyen** al document principal, es consulten juntes i no creixen sense límit: les temporades d'una sèrie, l'adreça d'un client, les línies d'una comanda.

### 6.2. Referències

Cada entitat va a la seva col·lecció, i els documents es relacionen guardant l'`_id` d'un altre document, com una clau forana. Per exemple, amb les col·leccions `usuaris` i `valoracions`:

```javascript
// Col·lecció usuaris
{ _id: ObjectId("…a1"), nom: "Laura", correu: "laura@exemple.cat", pla: "premium" }

// Col·lecció valoracions
{
  usuari_id: ObjectId("…a1"),        // apunta a un document d'usuaris
  titol_id: ObjectId("…c7"),         // apunta a un document de titols
  puntuacio: 9,
  comentari: "Molt recomanable"
}
```

Ara es poden cercar, per exemple, totes les valoracions d'un usuari: `db.valoracions.find({ usuari_id: ObjectId("…a1") })`. Per combinar documents de diverses col·leccions, MongoDB té l'etapa `$lookup` del seu sistema d'agregacions, que fa una funció semblant al `JOIN`; és un tema més avançat.

!!! warning "MongoDB no comprova les referències"
    A diferència d'una clau forana, MongoDB **no** comprova que l'`_id` guardat a `usuari_id` existeixi de debò, ni impedeix esborrar un usuari que té valoracions. Mantenir la coherència de les referències és feina de l'aplicació.

Les referències són adequades quan les dades relacionades tenen sentit per si mateixes, es consulten per separat o poden créixer molt: un títol pot tenir milers de valoracions, i posar-les totes dins el document del títol el faria enorme.

!!! example "Exercici 7. Niuar o referenciar?"
    Per a cada cas, decideix si niuaries les dades o faries servir referències. Justifica-ho.

    1. Les adreces d'enviament d'un client d'una botiga en línia (normalment una o dues).
    2. Els comentaris d'una publicació en una xarxa social amb milions d'usuaris.
    3. Els ingredients de cada recepta en una aplicació de cuina.
    4. Els alumnes i les assignatures d'un institut, sabent que una assignatura té molts alumnes i un alumne cursa moltes assignatures.

    ??? success "Solució"
        1. **Niuar**: les adreces pertanyen al client, són poques i es consulten amb ell.
        2. **Referenciar**: una publicació pot tenir milers de comentaris, i cada comentari té el seu autor, la seva data i les seves reaccions.
        3. **Niuar**: els ingredients formen part de la recepta i sempre es mostren junts. Si l'aplicació hagués de cercar «receptes amb tomàtiga» o calcular informació nutricional, també es podrien niuar, perquè MongoDB pot cercar dins llistes.
        4. **Referenciar**: és una relació N:M entre dues entitats que tenen sentit per si mateixes. Fins i tot val la pena plantejar-se si és un cas per a una base de dades relacional.

## 7. Repte

!!! example "Repte. Una xarxa social escolar"
    Vols crear una petita xarxa social per a l'institut. Els usuaris (alumnes i professors) fan publicacions que poden ser de tipus diferents: només text, text amb una o diverses imatges, o una enquesta amb opcions i vots. Les publicacions reben comentaris i «m'agrada».

    1. Decideix quines col·leccions necessites i quines dades niuaries o referenciaries. Justifica cada decisió.
    2. Escriu en JSON un document de cada tipus de publicació (text, imatges i enquesta).
    3. Crea la base de dades a MongoDB, insereix-hi almenys dos usuaris i cinc publicacions de tipus variats, i comprova l'estructura amb la pestanya **Schema**.
    4. Escriu els filtres per trobar: les publicacions d'un usuari concret; les enquestes; les publicacions amb més de 10 «m'agrada»; les publicacions que tenen alguna imatge.
    5. Quines dades d'aquesta aplicació guardaries en una base de dades relacional, si n'haguessis de fer servir una també? Per què?

    ??? success "Solució orientativa"
        **Col·leccions**: `usuaris` i `publicacions`. Els comentaris poden anar niuats dins la publicació si són pocs (una xarxa escolar petita) o en una col·lecció `comentaris` amb referències si n'hi pot haver molts.

        Una enquesta:

        ```json
        {
          "autor_id": "ObjectId de l'usuari",
          "tipus": "enquesta",
          "data": "2026-10-28",
          "text": "Quin dia feim la sortida?",
          "opcions": [
            { "text": "Dijous", "vots": 14 },
            { "text": "Divendres", "vots": 21 }
          ],
          "magrada": 8
        }
        ```

        Una publicació amb imatges tendria un camp `imatges` amb una llista d'adreces dels fitxers (les imatges en si no es guarden a la base de dades: són dades no estructurades), i una de text, només `text`.

        Filtres:

        ```javascript
        { autor_id: ObjectId("…") }
        { tipus: "enquesta" }
        { magrada: { $gt: 10 } }
        { imatges: { $exists: true } }
        ```

        Per als usuaris (correu únic, rol, grup) es podria defensar una base de dades relacional: són dades estructurades i interessa que el gestor garanteixi, per exemple, que no hi ha dos comptes amb el mateix correu.

---

!!! quote "Fonts"
    Mòdul elaborat a partir de [«Tema 5. Bases de datos no relacionales»](https://lopegonzalez.es/eso-y-bachillerato/programacion-y-computacion-2o-bachillerato/tema-5-bases-de-datos-no-relacionales/) de Lope González Vázquez ([CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ca)). Canvis respecte de l'original: traducció al català; la col·lecció d'exemple (una plataforma de vídeo) es manté com a idea però amb títols i dades inventats; no s'han reproduït les imatges originals. L'exercici 3 adapta l'«Ejercicio resuelto – Plataforma de videojuegos» de Lope. Són propis: el fitxer `titols.json`, els apartats de JSON amb Python, la comparació entre models, la modificació de documents, la reflexió sobre niuar o referenciar, la resta d'exercicis, el repte i les solucions. Les consultes s'han provat amb `mongomock`, una biblioteca de Python que imita MongoDB, i no amb un servidor MongoDB real.
