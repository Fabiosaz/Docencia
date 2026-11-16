# SQL: consultar i modificar dades

**SQL** (*Structured Query Language*, llenguatge de consultes estructurat) és el llenguatge estàndard per comunicar-se amb les bases de dades relacionals. Amb SQL demanam dades al gestor («dona'm els alumnes de Palma ordenats per llinatges»), en calculam («quina és la nota mitjana de cada assignatura?») i les modificam. En aquest mòdul aprendràs a fer-ho sobre una base de dades ja creada; al mòdul [SQL: taules i dades relacionades](sql-taules.md) aprendràs a crear-ne l'estructura.

| Fitxa del mòdul | |
| --- | --- |
| **Nivell** | PTD II |
| **Requisits previs** | [Bases de dades relacionals: fonaments i disseny](fonaments.md), almenys els apartats 1 a 3 |
| **Vídeo** | [Curs «Hello SQL» de MoureDev](https://youtu.be/OuJerKzV5T0), lliçons 4 a 11 (unes 2 hores i 15 minuts) |
| **Durada orientativa** | 8-10 sessions |
| **Relació amb el currículum** | PTD II, criteri d'avaluació 3.2: realitzar operacions de manipulació de la base de dades (creació, consulta, actualització i eliminació). Sabers: DML i consultes `SELECT` (selecció, filtratge i ordre; operadors de comparació, lògics i aritmètics) |

!!! tip "Com fer servir el vídeo i aquesta pàgina"
    El vídeo fa servir la base de dades `hello_mysql`, amb una taula d'usuaris. Els exemples i els exercicis d'aquesta pàgina fan servir la base de dades `institut`, que ja coneixes del mòdul de fonaments. Així, primer veus cada instrucció al vídeo i després la practiques amb unes altres dades, que és com es comprova si s'ha entès de debò.

## 1. Preparar l'entorn

> **Vídeo:** [lliçó 4, «Configuración e instalación»](https://youtu.be/OuJerKzV5T0?t=2753) · [lliçó 5, «Primeros pasos»](https://youtu.be/OuJerKzV5T0?t=3282) · [lliçó 6, «Conexión y cliente SQL»](https://youtu.be/OuJerKzV5T0?t=3555)

Per treballar amb SQL necessites dues peces:

- Un **servidor** de bases de dades, l'SGBD, que guarda les dades i executa les instruccions.
- Un **client**, el programa on escrius les instruccions i veus els resultats.

Hi ha dues opcions habituals. Fes servir la que indiqui el teu professor:

| | Opció A: XAMPP i phpMyAdmin | Opció B: MySQL i MySQL Workbench |
| --- | --- | --- |
| Servidor | MariaDB, inclòs dins [XAMPP](https://www.apachefriends.org/) | [MySQL Community Server](https://dev.mysql.com/downloads/mysql/) |
| Client | phpMyAdmin, al navegador: `http://localhost/phpmyadmin` | [MySQL Workbench](https://dev.mysql.com/downloads/workbench/), aplicació d'escriptori |
| Avantatges | Una sola instal·lació; inclou també un servidor web per a projectes web | És el que fa servir el vídeo; editor amb colors, autocompletat i diagrames E-R |
| Com s'engega | Obre el tauler de XAMPP i prem *Start* a **Apache** i a **MySQL** | El servidor s'engega tot sol; a Workbench, obre la connexió local |

!!! info "MySQL o MariaDB?"
    MariaDB és una derivació lliure de MySQL. Per a tot el que veuràs en aquest mòdul, les instruccions són les mateixes. Totes les solucions d'aquesta pàgina s'han provat amb MariaDB.

### 1.1. Carregar les bases de dades

Descarrega aquests dos fitxers:

- [`institut.sql`](fitxers/institut.sql): la base de dades dels exercicis, amb grups, alumnes, professors, assignatures i notes. Les dades són inventades.
- [`hello_mysql.sql`](fitxers/hello_mysql.sql): una taula `users` semblant a la del vídeo, per si vols repetir-ne els exemples.

!!! warning "Sobre `hello_mysql.sql`"
    Al vídeo, les dades de la taula `users` s'introdueixen a mà a la [lliçó 7](https://youtu.be/OuJerKzV5T0?t=4381), i el repositori del curs no les inclou. Aquest fitxer és una **reconstrucció pròpia** amb la mateixa estructura; per tant, els resultats de les consultes no coincidiran exactament amb els del vídeo.

Per carregar-los:

=== "phpMyAdmin"

    1. Obre `http://localhost/phpmyadmin`.
    2. Ves a la pestanya **Importar**, tria el fitxer `.sql` i prem **Importar** (o **Continuar**) al final de la pàgina.
    3. A l'esquerra apareixerà la base de dades nova. Per escriure consultes, selecciona-la i obre la pestanya **SQL**.

=== "MySQL Workbench"

    1. Obre la connexió local.
    2. Menú **File → Open SQL Script…** i tria el fitxer `.sql`.
    3. Executa'l tot amb la icona del llamp. Després, prem el botó d'actualitzar del panell **Schemas** perquè hi aparegui.
    4. Per escriure consultes, obre una pestanya nova d'SQL i fes doble clic sobre la base de dades a **Schemas** per seleccionar-la (o escriu `USE institut;`).

!!! warning "Els fitxers comencen esborrant"
    Els dos fitxers comencen amb `DROP DATABASE IF EXISTS`: si tornes a carregar-los, la base de dades es reinicia amb les dades originals. És útil quan has fet proves i vols començar de nou, però perdràs els canvis que hagis fet.

### 1.2. Les dades de l'institut

Aquest és l'esquema de la base de dades `institut`:

- **grups** (<u>grup_id</u>, nom, curs)
- **alumnes** (<u>alumne_id</u>, nom, llinatges, data_naixement, municipi, correu, *grup_id* → grups)
- **professors** (<u>professor_id</u>, nom, llinatges, departament)
- **assignatures** (<u>assignatura_id</u>, nom, hores_setmana, *professor_id* → professors)
- **notes** (<u>*alumne_id* → alumnes, *assignatura_id* → assignatures</u>, nota)

En aquest mòdul treballarem sobretot amb **una taula cada vegada**. Combinar dades de diverses taules (per exemple, veure el nom de l'alumne al costat de les seves notes) és el tema del mòdul següent.

## 2. Les primeres consultes: `SELECT`

> **Vídeo:** [lliçó 8, «Consulta de datos: SELECT»](https://youtu.be/OuJerKzV5T0?t=5618) · [`DISTINCT`](https://youtu.be/OuJerKzV5T0?t=6089) · [comentaris](https://youtu.be/OuJerKzV5T0?t=7512)

La instrucció `SELECT` llegeix dades d'una taula. La forma més senzilla és:

```sql
SELECT columnes FROM taula;
```

```sql
-- Totes les columnes de la taula alumnes
SELECT * FROM alumnes;

-- Només el nom i els llinatges
SELECT nom, llinatges FROM alumnes;

-- Els municipis, sense repetir-ne cap
SELECT DISTINCT municipi FROM alumnes;
```

Algunes normes d'escriptura:

- Cada instrucció acaba amb **punt i coma** (`;`).
- Les paraules clau (`SELECT`, `FROM`…) no distingeixen majúscules i minúscules, però s'escriuen en majúscules per convenció, perquè es distingeixin dels noms de taules i columnes.
- Els **textos** van entre cometes simples: `'Palma'`. Els nombres, sense cometes.
- Els **comentaris** d'una línia comencen amb `--` (amb un espai després) i els de diverses línies van entre `/*` i `*/`.

!!! tip "`SELECT *` per explorar, columnes concretes per treballar"
    `SELECT *` és pràctic per veure què hi ha a una taula, però en una aplicació real s'han d'indicar les columnes que es necessiten: és més eficient i el resultat no canvia si algú afegeix columnes a la taula.

!!! example "Exercici 1"
    1. Mostra el nom, els llinatges i el correu de tots els alumnes.
    2. Mostra tots els departaments dels professors, sense repetir-ne cap.
    3. Mostra totes les dades de la taula `assignatures`.

    ??? success "Solució"
        ```sql
        SELECT nom, llinatges, correu FROM alumnes;
        SELECT DISTINCT departament FROM professors;
        SELECT * FROM assignatures;
        ```

        La segona consulta retorna tres departaments: Tecnologia, Matemàtiques i Llengua catalana. Sense `DISTINCT`, Tecnologia sortiria dues vegades.

## 3. Filtrar i ordenar

> **Vídeo:** [`WHERE`](https://youtu.be/OuJerKzV5T0?t=6384) · [`ORDER BY`](https://youtu.be/OuJerKzV5T0?t=6592) · [`LIKE`](https://youtu.be/OuJerKzV5T0?t=6894) · [`AND`, `OR`, `NOT`](https://youtu.be/OuJerKzV5T0?t=7194) · [`LIMIT`](https://youtu.be/OuJerKzV5T0?t=7395)

### 3.1. `WHERE`: triar files

`WHERE` indica una condició: només surten les files que la compleixen.

```sql
SELECT nom, llinatges FROM alumnes WHERE municipi = 'Palma';
SELECT * FROM notes WHERE nota >= 9;
```

| Operador | Significat |
| --- | --- |
| `=` | Igual (només un `=`, no `==` com a Python) |
| `<>` o `!=` | Diferent |
| `<`, `<=`, `>`, `>=` | Menor, menor o igual, major, major o igual |

Les condicions es combinen amb `AND`, `OR` i `NOT`, i es poden agrupar amb parèntesis:

```sql
-- Alumnes de Palma del grup 1
SELECT nom FROM alumnes WHERE municipi = 'Palma' AND grup_id = 1;

-- Alumnes que no són de Palma
SELECT nom, municipi FROM alumnes WHERE NOT municipi = 'Palma';
```

!!! warning "`AND` va abans que `OR`"
    Igual que a Python, `AND` s'avalua abans que `OR`. `WHERE municipi = 'Palma' OR municipi = 'Inca' AND grup_id = 2` vol dir «de Palma (de qualsevol grup), o d'Inca i del grup 2». Si vols «de Palma o d'Inca, i del grup 2», posa parèntesis: `WHERE (municipi = 'Palma' OR municipi = 'Inca') AND grup_id = 2`.

### 3.2. `LIKE`: cercar dins un text

`LIKE` compara un text amb un **patró**, on `%` vol dir «qualsevol seqüència de caràcters, fins i tot cap» i `_` vol dir «exactament un caràcter»:

| Patró | Troba els textos que… |
| --- | --- |
| `'B%'` | comencen per B |
| `'%a'` | acaben en a |
| `'%Vi%'` | contenen «Vi» |
| `'_i%'` | tenen una i com a segona lletra |

```sql
SELECT nom, llinatges FROM alumnes WHERE llinatges LIKE '%Vi%';
```

!!! info "Majúscules i minúscules"
    Amb la configuració habitual de MySQL i MariaDB, les comparacions de text **no distingeixen** majúscules i minúscules: `'%vi%'` troba el mateix que `'%Vi%'`. Altres SGBD, com PostgreSQL, sí que les distingeixen.

### 3.3. `ORDER BY` i `LIMIT`

`ORDER BY` ordena el resultat, de manera ascendent (`ASC`, per defecte) o descendent (`DESC`). Es pot ordenar per diverses columnes: si dues files empaten en la primera, decideix la segona. `LIMIT` retalla el resultat a un nombre de files.

```sql
-- Alumnes ordenats per municipi i, dins cada municipi, per llinatges
SELECT nom, llinatges, municipi FROM alumnes ORDER BY municipi, llinatges;

-- Les tres notes més altes
SELECT * FROM notes ORDER BY nota DESC LIMIT 3;
```

!!! warning "Sense `ORDER BY`, l'ordre no està garantit"
    Si no poses `ORDER BY`, les files solen sortir en l'ordre en què es varen inserir, però l'SGBD no ho garanteix. Si l'ordre importa, indica'l sempre.

L'ordre de les clàusules és fix:

```sql
SELECT … FROM … WHERE … ORDER BY … LIMIT …;
```

!!! example "Exercici 2"
    1. Alumnes de Palma (nom i llinatges), ordenats per llinatges.
    2. Alumnes de Marratxí o que no tenen correu. Pista: la condició per a «no té correu» és `correu IS NULL`; ho veuràs a l'apartat següent.
    3. Alumnes amb un llinatge que contingui «Vi».
    4. Les tres notes més altes de la taula `notes`.
    5. Professors del departament de Tecnologia, ordenats per nom de manera descendent.

    ??? success "Solució"
        ```sql
        SELECT nom, llinatges FROM alumnes WHERE municipi = 'Palma' ORDER BY llinatges;
        SELECT nom, llinatges, correu FROM alumnes WHERE municipi = 'Marratxí' OR correu IS NULL;
        SELECT nom, llinatges FROM alumnes WHERE llinatges LIKE '%Vi%';
        SELECT * FROM notes ORDER BY nota DESC LIMIT 3;
        SELECT nom, llinatges FROM professors WHERE departament = 'Tecnologia' ORDER BY nom DESC;
        ```

        Resultats:

        1. Aina Ferrer Pons, Irene Fiol Torres, Elena Garcia Ramis, Gemma Sastre Pujol i Carla Vidal Bauzà.
        2. Biel (de Marratxí, amb correu), Dani (d'Inca, sense correu) i Hug (de Marratxí, sense correu).
        3. Carla Vidal Bauzà i Hug Bennàssar Vich.
        4. Les notes 9,75 (alumne 3), 9,25 (alumne 1) i 9,00 (alumne 6).
        5. Xavier i Marta.

## 4. Valors nuls i funcions d'agregació

> **Vídeo:** [`NULL`](https://youtu.be/OuJerKzV5T0?t=7615) · [`MIN`, `MAX`](https://youtu.be/OuJerKzV5T0?t=7834) · [`COUNT`](https://youtu.be/OuJerKzV5T0?t=8043) · [`SUM`](https://youtu.be/OuJerKzV5T0?t=8128) · [`AVG`](https://youtu.be/OuJerKzV5T0?t=8293)

### 4.1. `NULL`: el valor que falta

`NULL` indica que **no hi ha cap valor**: no és zero, ni un text buit, sinó «desconegut» o «no aplicable». A la base de dades `institut`, el Dani i el Hug no tenen correu, i el Joan no té grup.

Com que `NULL` no és un valor, **no es pot comparar amb `=`**. Per comprovar-lo es fa servir `IS NULL` i `IS NOT NULL`:

```sql
SELECT nom FROM alumnes WHERE correu IS NULL;      -- correcte
SELECT nom FROM alumnes WHERE correu = NULL;       -- incorrecte: no retorna cap fila
```

### 4.2. Funcions d'agregació

Les **funcions d'agregació** resumeixen moltes files en un sol valor:

| Funció | Retorna |
| --- | --- |
| `COUNT(*)` | El nombre de files |
| `COUNT(columna)` | El nombre de valors **no nuls** d'aquesta columna |
| `SUM(columna)` | La suma |
| `AVG(columna)` | La mitjana |
| `MIN(columna)`, `MAX(columna)` | El valor mínim i el màxim |

```sql
SELECT MAX(nota), MIN(nota), AVG(nota) FROM notes;
SELECT COUNT(*) FROM alumnes WHERE municipi = 'Palma';
```

!!! info "Les funcions d'agregació ignoren els `NULL`"
    `SELECT COUNT(*), COUNT(correu), COUNT(grup_id) FROM alumnes;` retorna 10, 8 i 9: hi ha 10 alumnes, però només 8 tenen correu i 9 tenen grup. Amb `AVG` passa el mateix: la mitjana es calcula només amb els valors que existeixen.

!!! example "Exercici 3"
    1. Nom dels alumnes que no tenen grup assignat.
    2. Quantes notes hi ha a la taula `notes`, i quina és la nota més alta, la més baixa i la mitjana?
    3. Quants alumnes són de Palma?
    4. Quantes hores setmanals sumen totes les assignatures?
    5. Per què `SELECT COUNT(correu) FROM alumnes;` i `SELECT COUNT(*) FROM alumnes;` donen resultats diferents?

    ??? success "Solució"
        ```sql
        SELECT nom FROM alumnes WHERE grup_id IS NULL;
        SELECT COUNT(*), MAX(nota), MIN(nota), AVG(nota) FROM notes;
        SELECT COUNT(*) FROM alumnes WHERE municipi = 'Palma';
        SELECT SUM(hores_setmana) FROM assignatures;
        ```

        1. Joan. 2. 17 notes; la més alta és 9,75, la més baixa 3,50 i la mitjana, 6,926471. 3. Cinc. 4. 18 hores. 5. `COUNT(correu)` no compta els dos alumnes que tenen el correu a `NULL`; `COUNT(*)` compta totes les files.

## 5. Més eines per filtrar i presentar

> **Vídeo:** [`IN`](https://youtu.be/OuJerKzV5T0?t=8335) · [`BETWEEN`](https://youtu.be/OuJerKzV5T0?t=8559) · [àlies](https://youtu.be/OuJerKzV5T0?t=8667) · [`CONCAT`](https://youtu.be/OuJerKzV5T0?t=8826)

- `IN` comprova si un valor és dins una llista. És una manera curta d'escriure diversos `OR`.
- `BETWEEN a AND b` comprova si un valor està entre `a` i `b`, **tots dos inclosos**. Funciona amb nombres, dates i textos.
- `AS` dona un **àlies**, un nom nou, a una columna del resultat. Si l'àlies té espais o accents, posa'l entre cometes.
- `CONCAT` uneix diversos textos en un.

```sql
SELECT CONCAT(nom, ' ', llinatges) AS alumne, municipi
FROM alumnes
WHERE municipi IN ('Inca', 'Llucmajor', 'Calvià');

SELECT nom, data_naixement
FROM alumnes
WHERE data_naixement BETWEEN '2009-01-01' AND '2009-12-31'
ORDER BY data_naixement;
```

Les dates s'escriuen entre cometes i en format **any-mes-dia**: `'2009-12-31'`.

!!! tip "Algunes funcions útils"
    MySQL té moltes funcions per treballar amb els valors. Aquestes són de les més útils: `UPPER(text)` i `LOWER(text)` (majúscules i minúscules), `CHAR_LENGTH(text)` (nombre de caràcters; `LENGTH` compta bytes i dona un resultat més gran amb lletres accentuades), `ROUND(nombre, decimals)` (arrodonir), `YEAR(data)` i `MONTH(data)` (any i mes d'una data) i `CURDATE()` (la data d'avui).

!!! example "Exercici 4"
    1. Mostra en una sola columna, anomenada `alumne`, el nom i els llinatges dels alumnes d'Inca, Llucmajor o Calvià, i en una altra el seu municipi.
    2. Alumnes nascuts el 2009, ordenats per data de naixement. Resol-ho de dues maneres: amb `BETWEEN` i amb la funció `YEAR`.
    3. Notes entre 5 i 7, totes dues incloses.
    4. Mitjana de les notes arrodonida a dos decimals, amb l'àlies `mitjana`.

    ??? success "Solució"
        ```sql
        SELECT CONCAT(nom, ' ', llinatges) AS alumne, municipi
        FROM alumnes
        WHERE municipi IN ('Inca', 'Llucmajor', 'Calvià');

        SELECT nom, data_naixement FROM alumnes
        WHERE data_naixement BETWEEN '2009-01-01' AND '2009-12-31'
        ORDER BY data_naixement;

        SELECT nom, data_naixement FROM alumnes
        WHERE YEAR(data_naixement) = 2009
        ORDER BY data_naixement;

        SELECT * FROM notes WHERE nota BETWEEN 5 AND 7;

        SELECT ROUND(AVG(nota), 2) AS mitjana FROM notes;
        ```

        1. Dani Oliver Serra (Inca), Fèlix Roig Coll (Llucmajor) i Joan Amengual Mir (Calvià).
        2. Aina, Joan, Elena, Biel i Carla, en aquest ordre.
        3. Sis notes: 7,00, 5,50, 6,00, 6,25, 5,00 i 6,50. El 5,00 i el 7,00 hi surten perquè `BETWEEN` inclou els extrems.
        4. 6,93.

## 6. Agrupar: `GROUP BY` i `HAVING`

> **Vídeo:** [`GROUP BY`](https://youtu.be/OuJerKzV5T0?t=8960) · [`HAVING`](https://youtu.be/OuJerKzV5T0?t=9265)

Fins ara, les funcions d'agregació resumien **tota** la taula en un valor. Amb `GROUP BY`, les files s'agrupen segons una columna i la funció es calcula **per a cada grup**:

```sql
-- Quants d'alumnes hi ha de cada municipi
SELECT municipi, COUNT(*) AS alumnes
FROM alumnes
GROUP BY municipi
ORDER BY alumnes DESC;
```

| municipi | alumnes |
| --- | --- |
| Palma | 5 |
| Marratxí | 2 |
| Inca | 1 |
| Llucmajor | 1 |
| Calvià | 1 |

`HAVING` filtra els **grups**, de la mateixa manera que `WHERE` filtra les files:

```sql
-- Municipis amb més d'un alumne
SELECT municipi, COUNT(*) AS alumnes
FROM alumnes
GROUP BY municipi
HAVING COUNT(*) > 1;
```

!!! warning "`WHERE` o `HAVING`?"
    - `WHERE` actua **abans** d'agrupar: decideix quines files entren als grups. No pot fer servir funcions d'agregació.
    - `HAVING` actua **després** d'agrupar: decideix quins grups surten al resultat. Sol contenir funcions d'agregació.

    Per exemple, «quants suspensos té cada alumne» filtra notes (`WHERE nota < 5`) i després agrupa per alumne. En canvi, «alumnes amb una mitjana de 7 o més» agrupa per alumne i després filtra els grups (`HAVING AVG(nota) >= 7`).

    El vídeo mostra un exemple de `HAVING` sense `GROUP BY`. És vàlid en MySQL, però poc habitual: `HAVING` gairebé sempre acompanya `GROUP BY`.

L'ordre complet de les clàusules és:

```sql
SELECT … FROM … WHERE … GROUP BY … HAVING … ORDER BY … LIMIT …;
```

!!! info "Què es pot posar al `SELECT` quan s'agrupa?"
    Quan hi ha `GROUP BY`, al `SELECT` només hi hauria d'haver les columnes per les quals s'agrupa i funcions d'agregació. Si demanes `SELECT nom, municipi, COUNT(*) … GROUP BY municipi`, quin nom hauria de mostrar, si cada municipi té diversos alumnes? Segons la configuració, MySQL dona error o en tria un a l'atzar.

!!! example "Exercici 5"
    1. Nombre d'alumnes de cada municipi, de més a menys.
    2. Per a cada alumne (`alumne_id`), la mitjana de les seves notes arrodonida a dos decimals. Mostra només els que tenen una mitjana de 7 o més, de la més alta a la més baixa.
    3. Nombre d'assignatures suspeses (nota inferior a 5) de cada alumne que en té alguna.
    4. Nombre d'alumnes nascuts cada any.

    ??? success "Solució"
        ```sql
        SELECT municipi, COUNT(*) AS alumnes
        FROM alumnes
        GROUP BY municipi
        ORDER BY alumnes DESC;

        SELECT alumne_id, ROUND(AVG(nota), 2) AS mitjana
        FROM notes
        GROUP BY alumne_id
        HAVING AVG(nota) >= 7
        ORDER BY mitjana DESC;

        SELECT alumne_id, COUNT(*) AS suspeses
        FROM notes
        WHERE nota < 5
        GROUP BY alumne_id;

        SELECT YEAR(data_naixement) AS any_naixement, COUNT(*) AS alumnes
        FROM alumnes
        GROUP BY YEAR(data_naixement);
        ```

        2. Cinc alumnes: el 6 (9,00), el 3 (8,88), l'1 i el 9 (8,25) i el 5 (8,13).
        3. Els alumnes 2, 4 i 7, amb una assignatura suspesa cadascun.
        4. Tres alumnes el 2008, cinc el 2009 i dos el 2010.

        Fixa't que a la consulta 3 la condició va a `WHERE` (filtra notes), i a la 2, a `HAVING` (filtra alumnes ja agrupats).

## 7. Resultats condicionals: `CASE` i `IFNULL`

> **Vídeo:** [`CASE`](https://youtu.be/OuJerKzV5T0?t=9486) · [`IFNULL`](https://youtu.be/OuJerKzV5T0?t=10023) · [altres modificadors](https://youtu.be/OuJerKzV5T0?t=10191)

`CASE` crea una columna el valor de la qual depèn d'unes condicions, com un `if`/`elif`/`else` de Python. Les condicions s'avaluen en ordre i s'aplica la primera que es compleix:

```sql
SELECT alumne_id, assignatura_id, nota,
    CASE
        WHEN nota < 5 THEN 'Insuficient'
        WHEN nota < 6 THEN 'Suficient'
        WHEN nota < 7 THEN 'Bé'
        WHEN nota < 9 THEN 'Notable'
        ELSE 'Excel·lent'
    END AS qualificacio
FROM notes;
```

`IFNULL(valor, alternativa)` retorna `valor` si no és nul, i `alternativa` si ho és:

```sql
SELECT nom, IFNULL(correu, 'sense correu') AS correu FROM alumnes;
```

!!! example "Exercici 6"
    1. Mostra les notes dels alumnes 1, 2 i 4 amb una columna `qualificacio` que digui Insuficient, Suficient, Bé, Notable o Excel·lent.
    2. Mostra el nom i el correu dels alumnes dels grups 2 i 4. Si un alumne no té correu, ha de sortir el text «sense correu».
    3. Per a cada assignatura (`assignatura_id`), mostra quants d'alumnes hi tenen nota, la mitjana arrodonida a dos decimals i quants l'han aprovada. Pista: suma 1 per a cada nota aprovada i 0 per a cada suspesa amb `SUM(CASE … END)`.

    ??? success "Solució"
        ```sql
        SELECT alumne_id, assignatura_id, nota,
            CASE
                WHEN nota < 5 THEN 'Insuficient'
                WHEN nota < 6 THEN 'Suficient'
                WHEN nota < 7 THEN 'Bé'
                WHEN nota < 9 THEN 'Notable'
                ELSE 'Excel·lent'
            END AS qualificacio
        FROM notes
        WHERE alumne_id IN (1, 2, 4);

        SELECT nom, IFNULL(correu, 'sense correu') AS correu
        FROM alumnes
        WHERE grup_id IN (2, 4);

        SELECT assignatura_id,
               COUNT(*) AS alumnes,
               ROUND(AVG(nota), 2) AS mitjana,
               SUM(CASE WHEN nota >= 5 THEN 1 ELSE 0 END) AS aprovats
        FROM notes
        GROUP BY assignatura_id;
        ```

        Resultat de la tercera consulta:

        | assignatura_id | alumnes | mitjana | aprovats |
        | --- | --- | --- | --- |
        | 1 | 5 | 7.35 | 4 |
        | 2 | 4 | 6.00 | 3 |
        | 3 | 4 | 7.25 | 4 |
        | 4 | 2 | 6.63 | 1 |
        | 5 | 2 | 7.38 | 2 |

        Per què a la primera consulta la condició `nota < 6` dona «Suficient» i no inclou també els suspesos? Perquè el `CASE` s'atura a la primera condició certa: una nota de 4,75 ja ha sortit per `nota < 5`.

## 8. Modificar dades: `INSERT`, `UPDATE` i `DELETE`

> **Vídeo:** [lliçó 11, «Escritura de datos»](https://youtu.be/OuJerKzV5T0?t=10289) · [`INSERT`](https://youtu.be/OuJerKzV5T0?t=10370) · [`UPDATE`](https://youtu.be/OuJerKzV5T0?t=10621) · [`DELETE`](https://youtu.be/OuJerKzV5T0?t=10920)

### 8.1. Inserir

```sql
INSERT INTO alumnes (nom, llinatges, data_naixement, municipi, grup_id)
VALUES ('Lluc', 'Cerdà Vives', '2009-10-12', 'Manacor', 2);
```

- Les columnes i els valors van **en el mateix ordre**.
- Les columnes que no s'indiquen queden a `NULL` o prenen el seu valor per defecte. Aquí no hem indicat `alumne_id` perquè és `AUTO_INCREMENT`: el gestor hi posa el número següent. Tampoc no hem indicat el correu, que quedarà a `NULL`.
- Es poden inserir diverses files d'una vegada, separant els grups de valors amb comes: `VALUES (…), (…), (…);`.

L'SGBD comprova les restriccions de la taula: si intentes inserir una nota d'11, un correu repetit o un alumne d'un grup que no existeix, l'operació falla.

### 8.2. Modificar

```sql
UPDATE alumnes
SET correu = 'lluc.cerda@exemple.cat', municipi = 'Petra'
WHERE alumne_id = 11;
```

### 8.3. Esborrar

```sql
DELETE FROM alumnes WHERE alumne_id = 11;
```

!!! danger "Mai no oblidis el `WHERE`"
    Un `UPDATE` o un `DELETE` **sense `WHERE` afecta totes les files de la taula**. `DELETE FROM notes;` esborra totes les notes, i no es pot desfer.

    Un bon hàbit: abans d'executar un `UPDATE` o un `DELETE`, executa un `SELECT` amb el mateix `WHERE` per veure exactament quines files es modificaran. A més, filtra sempre que puguis per la **clau primària**, que identifica una sola fila.

!!! info "El mode segur de MySQL Workbench"
    Workbench activa per defecte el «mode d'actualització segura» (*safe update mode*), que rebutja els `UPDATE` i els `DELETE` que no filtren per una columna clau. Si et dona aquest error, revisa primer el `WHERE`: sovint t'està salvant d'un error.

!!! example "Exercici 7"
    Fes aquestes operacions en ordre i comprova el resultat de cada una amb un `SELECT`. Al final, pots tornar a carregar `institut.sql` per recuperar les dades originals.

    1. Insereix un alumne nou: Kai Pou Salom, nascut el 3 de febrer de 2010, de Sóller, del grup 4 i sense correu. Quin `alumne_id` li ha assignat el gestor?
    2. Posa-li el correu `kai.pou@exemple.cat`.
    3. Posa-li dues notes: un 7,5 a l'assignatura 5 i un 6 a l'assignatura 1, amb una sola instrucció.
    4. Intenta inserir una nota de 12 al mateix alumne a l'assignatura 2. Què passa? Per què?
    5. Intenta posar al Kai el correu de l'Aina (`aina.ferrer@exemple.cat`). Què passa?
    6. L'alumne s'ha donat de baixa: esborra les seves notes i, després, l'alumne. Què passaria si intentassis esborrar primer l'alumne?

    ??? success "Solució"
        ```sql
        -- 1
        INSERT INTO alumnes (nom, llinatges, data_naixement, municipi, grup_id)
        VALUES ('Kai', 'Pou Salom', '2010-02-03', 'Sóller', 4);
        SELECT * FROM alumnes WHERE nom = 'Kai';

        -- 2
        UPDATE alumnes SET correu = 'kai.pou@exemple.cat' WHERE alumne_id = 11;

        -- 3
        INSERT INTO notes (alumne_id, assignatura_id, nota)
        VALUES (11, 5, 7.5), (11, 1, 6);

        -- 4
        INSERT INTO notes (alumne_id, assignatura_id, nota) VALUES (11, 2, 12);

        -- 5
        UPDATE alumnes SET correu = 'aina.ferrer@exemple.cat' WHERE alumne_id = 11;

        -- 6
        DELETE FROM notes WHERE alumne_id = 11;
        DELETE FROM alumnes WHERE alumne_id = 11;
        ```

        1. L'11, perquè n'hi havia deu. Si abans havies provat els exemples de l'apartat 8 o havies inserit i esborrat altres alumnes, el número serà més alt i l'hauràs de canviar a la resta d'instruccions: `AUTO_INCREMENT` no reaprofita els números esborrats.
        4. Error: la restricció `CHECK (nota BETWEEN 0 AND 10)` no ho permet. És integritat de domini.
        5. Error de valor duplicat, perquè el camp `correu` és `UNIQUE`.
        6. El gestor no deixaria esborrar l'alumne mentre tingués notes, perquè les claus foranes de `notes` apuntarien a un alumne inexistent. És integritat referencial.

## 9. Repte

!!! example "Repte. L'informe de la tutora"
    La tutora del 1BA (grup 1) prepara la sessió d'avaluació i et demana unes consultes. Resol cada una amb una sola instrucció SQL, sense mirar els resultats a ull. De moment, treballa amb els identificadors (`alumne_id`, `assignatura_id`); al mòdul següent hi podràs afegir els noms.

    1. Llista dels alumnes del grup (`alumne_id`, nom complet en una sola columna i correu), per ordre alfabètic de llinatges.
    2. Quants alumnes del grup tenen el correu registrat?
    3. Totes les notes dels alumnes 1, 2 i 3, ordenades per alumne i, dins cada alumne, de la nota més alta a la més baixa.
    4. Per a cada un d'aquests alumnes: nombre de notes, mitjana arrodonida a dos decimals, nota més alta i nota més baixa.
    5. Una columna `promociona` que digui «Sí» si l'alumne no té cap suspesa i «Revisar» si en té alguna. Pista: compara la nota mínima de cada alumne.

    ??? success "Solució"
        ```sql
        -- 1
        SELECT alumne_id, CONCAT(nom, ' ', llinatges) AS alumne, correu
        FROM alumnes
        WHERE grup_id = 1
        ORDER BY llinatges;

        -- 2
        SELECT COUNT(correu) FROM alumnes WHERE grup_id = 1;

        -- 3
        SELECT * FROM notes
        WHERE alumne_id IN (1, 2, 3)
        ORDER BY alumne_id, nota DESC;

        -- 4
        SELECT alumne_id,
               COUNT(*) AS notes,
               ROUND(AVG(nota), 2) AS mitjana,
               MAX(nota) AS maxima,
               MIN(nota) AS minima
        FROM notes
        WHERE alumne_id IN (1, 2, 3)
        GROUP BY alumne_id;

        -- 5
        SELECT alumne_id,
               CASE WHEN MIN(nota) >= 5 THEN 'Sí' ELSE 'Revisar' END AS promociona
        FROM notes
        WHERE alumne_id IN (1, 2, 3)
        GROUP BY alumne_id;
        ```

        Resultats de les consultes 4 i 5:

        | alumne_id | notes | mitjana | maxima | minima | promociona |
        | --- | --- | --- | --- | --- | --- |
        | 1 | 3 | 8.25 | 9.25 | 7.00 | Sí |
        | 2 | 3 | 5.42 | 6.00 | 4.75 | Revisar |
        | 3 | 2 | 8.88 | 9.75 | 8.00 | Sí |

        A les consultes 3, 4 i 5 hem escrit a mà els identificadors 1, 2 i 3 perquè sabíem quins alumnes són del grup 1. Si el grup canviàs, la consulta deixaria de ser correcta. Al mòdul següent ho resoldràs combinant les taules `alumnes` i `notes`.

## 10. Exercicis de repàs

Vint-i-sis exercicis més sobre la base de dades `institut`, ordenats de menys a més dificultat. Escriu cada consulta abans de mirar la solució i compara el teu resultat amb el que s'hi mostra. Tots es resolen amb una sola taula.

!!! example "Repàs 1. Els grups"
    Mostra el nom i el curs de tots els grups, ordenats pel nom.

    ??? success "Solució"
        ```sql
        SELECT nom, curs FROM grups ORDER BY nom;
        ```

        Resultat:

        | nom | curs |
        | --- | --- |
        | 1BA | 1r de Batxillerat |
        | 1BB | 1r de Batxillerat |
        | 2BA | 2n de Batxillerat |
        | 4EA | 4t d'ESO |

!!! example "Repàs 2. Del més gran al més jove"
    Mostra el nom, els llinatges i la data de naixement dels alumnes, del més gran al més jove.

    ??? success "Solució"
        ```sql
        SELECT nom, llinatges, data_naixement
        FROM alumnes
        ORDER BY data_naixement;
        ```

        Resultat:

        | nom | llinatges | data_naixement |
        | --- | --- | --- |
        | Fèlix | Roig Coll | 2008-02-17 |
        | Gemma | Sastre Pujol | 2008-09-04 |
        | Dani | Oliver Serra | 2008-12-30 |
        | Aina | Ferrer Pons | 2009-03-14 |
        | Joan | Amengual Mir | 2009-04-29 |
        | Elena | Garcia Ramis | 2009-05-08 |
        | Biel | Mas Riera | 2009-07-02 |
        | Carla | Vidal Bauzà | 2009-11-23 |
        | Hug | Bennàssar Vich | 2010-01-21 |
        | Irene | Fiol Torres | 2010-06-11 |

        El més gran és el que va néixer **abans**: per això l'ordre és ascendent.

!!! example "Repàs 3. Fora de Palma"
    Mostra el nom i el municipi dels alumnes que no són de Palma, ordenats per municipi i, dins cada municipi, per nom.

    ??? success "Solució"
        ```sql
        SELECT nom, municipi
        FROM alumnes
        WHERE municipi <> 'Palma'
        ORDER BY municipi, nom;
        ```

        Resultat:

        | nom | municipi |
        | --- | --- |
        | Joan | Calvià |
        | Dani | Inca |
        | Fèlix | Llucmajor |
        | Biel | Marratxí |
        | Hug | Marratxí |

!!! example "Repàs 4. Llinatges que comencen per F o per B"
    Mostra el nom i els llinatges dels alumnes el primer llinatge dels quals comença per F o per B.

    ??? success "Solució"
        ```sql
        SELECT nom, llinatges
        FROM alumnes
        WHERE llinatges LIKE 'F%' OR llinatges LIKE 'B%';
        ```

        Resultat:

        | nom | llinatges |
        | --- | --- |
        | Aina | Ferrer Pons |
        | Hug | Bennàssar Vich |
        | Irene | Fiol Torres |

!!! example "Repàs 5. Noms de quatre lletres"
    Mostra els noms d'alumne que tenen exactament quatre lletres. Resol-ho amb `LIKE`.

    ??? success "Solució"
        ```sql
        SELECT nom FROM alumnes WHERE nom LIKE '____';
        ```

        Resultat:

        | nom |
        | --- |
        | Aina |
        | Biel |
        | Dani |
        | Joan |

        Cada guió baix representa exactament un caràcter. També es pot fer amb `WHERE CHAR_LENGTH(nom) = 4`.

!!! example "Repàs 6. Assignatures de quatre hores"
    Mostra, per ordre alfabètic, el nom de les assignatures que tenen 4 hores setmanals.

    ??? success "Solució"
        ```sql
        SELECT nom FROM assignatures WHERE hores_setmana = 4 ORDER BY nom;
        ```

        Resultat:

        | nom |
        | --- |
        | Matemàtiques I |
        | Programació i Tractament de Dades I |
        | Programació i Tractament de Dades II |

!!! example "Repàs 7. L'alumne més jove"
    Mostra el nom, els llinatges i la data de naixement de l'alumne més jove, amb `ORDER BY` i `LIMIT`.

    ??? success "Solució"
        ```sql
        SELECT nom, llinatges, data_naixement
        FROM alumnes
        ORDER BY data_naixement DESC
        LIMIT 1;
        ```

        Resultat:

        | nom | llinatges | data_naixement |
        | --- | --- | --- |
        | Irene | Fiol Torres | 2010-06-11 |

!!! example "Repàs 8. Les cinc notes més baixes"
    Mostra les cinc notes més baixes de la taula `notes`, de la més baixa a la més alta.

    ??? success "Solució"
        ```sql
        SELECT * FROM notes ORDER BY nota LIMIT 5;
        ```

        Resultat:

        | alumne_id | assignatura_id | nota |
        | --- | --- | --- |
        | 4 | 2 | 3.50 |
        | 7 | 4 | 4.25 |
        | 2 | 1 | 4.75 |
        | 4 | 3 | 5.00 |
        | 2 | 2 | 5.50 |

!!! example "Repàs 9. Nascuts a partir del juliol"
    Mostra el nom i la data de naixement dels alumnes nascuts entre el juliol i el desembre, de qualsevol any.

    ??? success "Solució"
        ```sql
        SELECT nom, data_naixement
        FROM alumnes
        WHERE MONTH(data_naixement) >= 7
        ORDER BY MONTH(data_naixement);
        ```

        Resultat:

        | nom | data_naixement |
        | --- | --- |
        | Biel | 2009-07-02 |
        | Gemma | 2008-09-04 |
        | Carla | 2009-11-23 |
        | Dani | 2008-12-30 |

!!! example "Repàs 10. Dues condicions"
    Mostra el nom, la data de naixement i el `grup_id` dels alumnes dels grups 1 o 2 que varen néixer el 2009.

    ??? success "Solució"
        ```sql
        SELECT nom, data_naixement, grup_id
        FROM alumnes
        WHERE grup_id IN (1, 2) AND YEAR(data_naixement) = 2009;
        ```

        Resultat:

        | nom | data_naixement | grup_id |
        | --- | --- | --- |
        | Aina | 2009-03-14 | 1 |
        | Biel | 2009-07-02 | 1 |
        | Carla | 2009-11-23 | 1 |
        | Elena | 2009-05-08 | 2 |

        Si ho escrius amb `OR`, calen parèntesis: `(grup_id = 1 OR grup_id = 2) AND …`.

!!! example "Repàs 11. Quants tenen correu?"
    Amb una sola consulta, mostra quants alumnes hi ha, quants tenen correu i quants no en tenen.

    ??? success "Solució"
        ```sql
        SELECT COUNT(*) AS alumnes,
               COUNT(correu) AS amb_correu,
               COUNT(*) - COUNT(correu) AS sense_correu
        FROM alumnes;
        ```

        Resultat:

        | alumnes | amb_correu | sense_correu |
        | --- | --- | --- |
        | 10 | 8 | 2 |

!!! example "Repàs 12. Quants municipis diferents?"
    Mostra de quants municipis diferents són els alumnes. Pista: `DISTINCT` també es pot posar dins `COUNT()`.

    ??? success "Solució"
        ```sql
        SELECT COUNT(DISTINCT municipi) AS municipis FROM alumnes;
        ```

        Resultat:

        | municipis |
        | --- |
        | 5 |

!!! example "Repàs 13. Les notes de PTD I"
    Mostra quantes notes hi ha de l'assignatura 1 i quina n'és la mitjana (amb dos decimals), la més alta i la més baixa.

    ??? success "Solució"
        ```sql
        SELECT COUNT(*) AS notes,
               ROUND(AVG(nota), 2) AS mitjana,
               MAX(nota) AS maxima,
               MIN(nota) AS minima
        FROM notes
        WHERE assignatura_id = 1;
        ```

        Resultat:

        | notes | mitjana | maxima | minima |
        | --- | --- | --- | --- |
        | 5 | 7.35 | 9.75 | 4.75 |

!!! example "Repàs 14. LLINATGES, Nom"
    Mostra una sola columna, anomenada `alumne`, amb el format `FERRER PONS, Aina`, ordenada alfabèticament.

    ??? success "Solució"
        ```sql
        SELECT CONCAT(UPPER(llinatges), ', ', nom) AS alumne
        FROM alumnes
        ORDER BY alumne;
        ```

        Resultat:

        | alumne |
        | --- |
        | AMENGUAL MIR, Joan |
        | BENNÀSSAR VICH, Hug |
        | FERRER PONS, Aina |
        | FIOL TORRES, Irene |
        | GARCIA RAMIS, Elena |
        | MAS RIERA, Biel |
        | OLIVER SERRA, Dani |
        | ROIG COLL, Fèlix |
        | SASTRE PUJOL, Gemma |
        | VIDAL BAUZÀ, Carla |

!!! example "Repàs 15. Quants d'anys fan el 2026?"
    Mostra el nom de cada alumne i els anys que compleix durant el 2026, del més jove al més gran.

    ??? success "Solució"
        ```sql
        SELECT nom, 2026 - YEAR(data_naixement) AS anys
        FROM alumnes
        ORDER BY anys, nom;
        ```

        Resultat:

        | nom | anys |
        | --- | --- |
        | Hug | 16 |
        | Irene | 16 |
        | Aina | 17 |
        | Biel | 17 |
        | Carla | 17 |
        | Elena | 17 |
        | Joan | 17 |
        | Dani | 18 |
        | Fèlix | 18 |
        | Gemma | 18 |

!!! example "Repàs 16. Notes per alumne"
    Mostra, per a cada `alumne_id`, quantes notes té, de més a menys.

    ??? success "Solució"
        ```sql
        SELECT alumne_id, COUNT(*) AS notes
        FROM notes
        GROUP BY alumne_id
        ORDER BY notes DESC, alumne_id;
        ```

        Resultat:

        | alumne_id | notes |
        | --- | --- |
        | 1 | 3 |
        | 2 | 3 |
        | 4 | 3 |
        | 3 | 2 |
        | 5 | 2 |
        | 6 | 1 |
        | 7 | 1 |
        | 8 | 1 |
        | 9 | 1 |

        L'alumne 10 no hi surt perquè no té cap fila a la taula `notes`.

!!! example "Repàs 17. Alumnes per grup"
    Mostra quants alumnes té cada `grup_id`. Què passa amb l'alumne que no té grup?

    ??? success "Solució"
        ```sql
        SELECT grup_id, COUNT(*) AS alumnes
        FROM alumnes
        GROUP BY grup_id;
        ```

        Resultat:

        | grup_id | alumnes |
        | --- | --- |
        | NULL | 1 |
        | 1 | 3 |
        | 2 | 2 |
        | 3 | 2 |
        | 4 | 2 |

        `GROUP BY` forma un grup amb totes les files que tenen `NULL`: per això apareix una fila amb `grup_id` nul i un alumne.

!!! example "Repàs 18. La diferència de notes"
    Per a cada assignatura (`assignatura_id`), mostra la nota més alta, la més baixa i la diferència entre totes dues.

    ??? success "Solució"
        ```sql
        SELECT assignatura_id,
               MAX(nota) AS maxima,
               MIN(nota) AS minima,
               MAX(nota) - MIN(nota) AS diferencia
        FROM notes
        GROUP BY assignatura_id;
        ```

        Resultat:

        | assignatura_id | maxima | minima | diferencia |
        | --- | --- | --- | --- |
        | 1 | 9.75 | 4.75 | 5.00 |
        | 2 | 8.00 | 3.50 | 4.50 |
        | 3 | 9.25 | 5.00 | 4.25 |
        | 4 | 9.00 | 4.25 | 4.75 |
        | 5 | 8.25 | 6.50 | 1.75 |

!!! example "Repàs 19. Assignatures amb més de tres notes"
    Mostra el `assignatura_id` i el nombre de notes de les assignatures que en tenen més de tres.

    ??? success "Solució"
        ```sql
        SELECT assignatura_id, COUNT(*) AS notes
        FROM notes
        GROUP BY assignatura_id
        HAVING COUNT(*) > 3;
        ```

        Resultat:

        | assignatura_id | notes |
        | --- | --- |
        | 1 | 5 |
        | 2 | 4 |
        | 3 | 4 |

!!! example "Repàs 20. Departaments amb més d'un professor"
    Mostra els departaments que tenen més d'un professor, i quants en tenen.

    ??? success "Solució"
        ```sql
        SELECT departament, COUNT(*) AS professors
        FROM professors
        GROUP BY departament
        HAVING COUNT(*) > 1;
        ```

        Resultat:

        | departament | professors |
        | --- | --- |
        | Tecnologia | 2 |

!!! example "Repàs 21. Mitjana dels aprovats"
    Per a cada assignatura, calcula la mitjana (amb dos decimals) **només de les notes aprovades**.

    ??? success "Solució"
        ```sql
        SELECT assignatura_id, ROUND(AVG(nota), 2) AS mitjana_aprovats
        FROM notes
        WHERE nota >= 5
        GROUP BY assignatura_id;
        ```

        Resultat:

        | assignatura_id | mitjana_aprovats |
        | --- | --- |
        | 1 | 8.00 |
        | 2 | 6.83 |
        | 3 | 7.25 |
        | 4 | 9.00 |
        | 5 | 7.38 |

        La condició filtra **files** abans d'agrupar: per això va a `WHERE` i no a `HAVING`.

!!! example "Repàs 22. Assignatures llargues i curtes"
    Mostra el nom de cada assignatura i una columna `tipus` que digui «Llarga» si té 4 hores setmanals o més i «Curta» si en té menys.

    ??? success "Solució"
        ```sql
        SELECT nom,
               CASE WHEN hores_setmana >= 4 THEN 'Llarga' ELSE 'Curta' END AS tipus
        FROM assignatures;
        ```

        Resultat:

        | nom | tipus |
        | --- | --- |
        | Programació i Tractament de Dades I | Llarga |
        | Matemàtiques I | Llarga |
        | Llengua Catalana i Literatura I | Curta |
        | Programació i Tractament de Dades II | Llarga |
        | Tecnologia | Curta |

!!! example "Repàs 23. Quantes notes de cada qualificació?"
    Mostra quantes notes hi ha de cada qualificació: Insuficient (menys de 5), Aprovat (de 5 a menys de 7), Notable (de 7 a menys de 9) i Excel·lent (9 o més).

    ??? success "Solució"
        ```sql
        SELECT CASE
                   WHEN nota < 5 THEN 'Insuficient'
                   WHEN nota < 7 THEN 'Aprovat'
                   WHEN nota < 9 THEN 'Notable'
                   ELSE 'Excel·lent'
               END AS qualificacio,
               COUNT(*) AS notes
        FROM notes
        GROUP BY qualificacio
        ORDER BY MIN(nota);
        ```

        Resultat:

        | qualificacio | notes |
        | --- | --- |
        | Insuficient | 3 |
        | Aprovat | 5 |
        | Notable | 6 |
        | Excel·lent | 3 |

        MySQL i MariaDB permeten agrupar per l'àlies d'una columna calculada. L'`ORDER BY MIN(nota)` ordena les qualificacions de la més baixa a la més alta.

!!! example "Repàs 24. Sense professor"
    Mostra el nom de cada assignatura i el `professor_id`. Si no té professor assignat, ha de sortir un 0.

    ??? success "Solució"
        ```sql
        SELECT nom, IFNULL(professor_id, 0) AS professor_id FROM assignatures;
        ```

        Resultat:

        | nom | professor_id |
        | --- | --- |
        | Programació i Tractament de Dades I | 1 |
        | Matemàtiques I | 2 |
        | Llengua Catalana i Literatura I | 3 |
        | Programació i Tractament de Dades II | 4 |
        | Tecnologia | 0 |

!!! example "Repàs 25. Troba l'error"
    Aquestes tres consultes estan malament: una no retorna el que s'espera i les altres dues donen error. Explica per què i corregeix-les.

    ```sql
    SELECT nom FROM alumnes WHERE grup_id = NULL;

    SELECT municipi, COUNT(*) FROM alumnes WHERE COUNT(*) > 1 GROUP BY municipi;

    SELECT nom FROM alumnes ORDER BY nom WHERE grup_id = 1;
    ```

    ??? success "Solució"
        ```sql
        SELECT nom FROM alumnes WHERE grup_id IS NULL;

        SELECT municipi, COUNT(*) FROM alumnes GROUP BY municipi HAVING COUNT(*) > 1;

        SELECT nom FROM alumnes WHERE grup_id = 1 ORDER BY nom;
        ```

        1. Amb `= NULL` no es troba mai cap fila: s'ha de fer servir `IS NULL`.
        2. Les funcions d'agregació no es poden fer servir a `WHERE`; els grups es filtren amb `HAVING`.
        3. L'ordre de les clàusules és fix: `WHERE` va abans d'`ORDER BY`.

!!! example "Repàs 26. Altes, canvis i baixes"
    Fes aquestes operacions, en ordre, i comprova'n el resultat. Després, torna a carregar `institut.sql`.

    1. Afegeix el grup `2BB`, de 2n de Batxillerat.
    2. Assigna a aquest grup l'alumne que no en té cap.
    3. L'assignatura Tecnologia passa a tenir 2 hores setmanals.
    4. Puja mig punt totes les notes de l'assignatura 2 que siguin inferiors a 5.
    5. Esborra les notes de l'assignatura 5.

    ??? success "Solució"
        ```sql
        INSERT INTO grups (nom, curs) VALUES ('2BB', '2n de Batxillerat');

        UPDATE alumnes SET grup_id = 5 WHERE grup_id IS NULL;

        UPDATE assignatures SET hores_setmana = 2 WHERE nom = 'Tecnologia';

        UPDATE notes SET nota = nota + 0.5 WHERE assignatura_id = 2 AND nota < 5;

        DELETE FROM notes WHERE assignatura_id = 5;
        ```

        - El grup nou rep el `grup_id` 5, perquè n'hi havia quatre. El `UPDATE` de l'alumne modifica una sola fila (en Joan).
        - La nota d'en Dani a Matemàtiques I passa de 3,50 a 4,00.
        - S'esborren dues notes, i a la taula en queden 15.

        Abans de cada `UPDATE` o `DELETE`, executa un `SELECT` amb el mateix `WHERE` per veure quines files canviaran.

---

!!! quote "Fonts"
    Mòdul elaborat a partir del curs en vídeo [«Hello SQL»](https://youtu.be/OuJerKzV5T0) de Brais Moure (MoureDev), al qual s'enllaça per lliçons, i del seu repositori de codi [mouredev/hello-sql](https://github.com/mouredev/hello-sql) ([llicència Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)). Canvis respecte del repositori: no se'n reprodueix el codi literalment; els exemples s'han reescrit per a la base de dades `institut`, amb comentaris en català, i la taula `users` del fitxer `hello_mysql.sql` és una reconstrucció pròpia. Les opcions d'instal·lació amb XAMPP i phpMyAdmin segueixen la proposta del [«Tema 4. Bases de datos relacionales»](https://lopegonzalez.es/eso-y-bachillerato/programacion-y-computacion-2o-bachillerato/tema-4-bases-de-datos-relacionales/) de Lope González Vázquez ([CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ca)). Són propis: la base de dades `institut`, les explicacions, els exercicis, el repte i totes les solucions, provades amb MariaDB.
