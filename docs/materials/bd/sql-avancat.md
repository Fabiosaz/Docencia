# SQL avançat i accés des de Python

Amb el que has après fins ara ja pots crear una base de dades i consultar-la. En aquest mòdul veuràs les eines que fan servir les aplicacions reals: **vistes** per simplificar consultes, **procediments** i ***triggers*** perquè la mateixa base de dades faci feina, **índexs** per anar més aviat, **transaccions** perquè les operacions no quedin a mitges i, sobretot, com es connecta un **programa en Python** a la base de dades sense obrir la porta a l'**injecció d'SQL**.

| Fitxa del mòdul | |
| --- | --- |
| **Nivell** | PTD II |
| **Requisits previs** | [SQL: consultar i modificar dades](sql.md) i [SQL: taules i dades relacionades](sql-taules.md). Per a l'apartat 6, Python: funcions, `try`/`except` i `input` |
| **Vídeo** | [Curs «Hello SQL» de MoureDev](https://youtu.be/OuJerKzV5T0), lliçons 18 a 22 (1 hora i 40 minuts, aproximadament) |
| **Durada orientativa** | 6-8 sessions |
| **Relació amb el currículum** | PTD II, criteri d'avaluació 3.3 (mètodes d'accés a sistemes gestors de bases de dades relacionals). Sabers: connexions i execució de consultes des del llenguatge de programació. Les vistes, els procediments, els *triggers* i els índexs no apareixen explícitament al currículum i són ampliació |

!!! tip "Abans de començar"
    Torna a carregar [`institut.sql`](fitxers/institut.sql) per partir de les dades originals. Per a l'apartat 3 necessitaràs també la base de dades `biblioteca` de l'[exercici 3 del mòdul anterior](sql-taules.md#4-relacions-entre-taules).

## 1. Vistes

> **Vídeo:** [`VIEW`](https://youtu.be/OuJerKzV5T0?t=19663)

Al mòdul anterior vas escriure moltes vegades el mateix `JOIN` per veure les notes amb el nom de l'alumne i de l'assignatura. Una **vista** és una consulta guardada amb un nom, que després es fa servir com si fos una taula:

```sql
CREATE VIEW v_notes AS
SELECT a.alumne_id,
       CONCAT(a.nom, ' ', a.llinatges) AS alumne,
       g.nom AS grup,
       s.nom AS assignatura,
       n.nota
FROM notes n
JOIN alumnes a ON n.alumne_id = a.alumne_id
JOIN assignatures s ON n.assignatura_id = s.assignatura_id
LEFT JOIN grups g ON a.grup_id = g.grup_id;
```

```sql
SELECT * FROM v_notes WHERE grup = '1BB' ORDER BY alumne;
```

| alumne_id | alumne | grup | assignatura | nota |
| --- | --- | --- | --- | --- |
| 4 | Dani Oliver Serra | 1BB | Programació i Tractament de Dades I | 6.25 |
| 4 | Dani Oliver Serra | 1BB | Matemàtiques I | 3.50 |
| 4 | Dani Oliver Serra | 1BB | Llengua Catalana i Literatura I | 5.00 |
| 5 | Elena Garcia Ramis | 1BB | Programació i Tractament de Dades I | 7.50 |
| 5 | Elena Garcia Ramis | 1BB | Llengua Catalana i Literatura I | 8.75 |

Una vista **no guarda dades**: cada vegada que la consultes, s'executa la consulta original sobre les dades actuals. Per això, si una nota canvia, la vista ja mostra la nota nova.

Les vistes serveixen per:

- **Simplificar**: les consultes complicades s'escriuen una vegada.
- **Protegir**: es pot donar permís a un usuari per consultar una vista que no mostra certes columnes (per exemple, el correu o la data de naixement) sense donar-li accés a la taula completa.

Per esborrar-la: `DROP VIEW v_notes;`.

!!! example "Exercici 1"
    1. Crea la vista `v_notes` de l'exemple.
    2. Crea la vista `v_suspeses`, a partir de `v_notes`, amb l'alumne, el grup, l'assignatura i la nota de totes les notes inferiors a 5.
    3. Fent servir `v_notes`, calcula la mitjana de cada alumne (amb el nom complet), de la més alta a la més baixa.

    ??? success "Solució"
        ```sql
        CREATE VIEW v_suspeses AS
        SELECT alumne, grup, assignatura, nota
        FROM v_notes
        WHERE nota < 5;

        SELECT * FROM v_suspeses;

        SELECT alumne, ROUND(AVG(nota), 2) AS mitjana
        FROM v_notes
        GROUP BY alumne_id, alumne
        ORDER BY mitjana DESC;
        ```

        `v_suspeses` mostra tres notes: Biel Mas Riera (PTD I, 4,75), Dani Oliver Serra (Matemàtiques I, 3,50) i Gemma Sastre Pujol (PTD II, 4,25). Fixa't que una vista es pot construir a partir d'una altra vista.

## 2. Procediments emmagatzemats

> **Vídeo:** [`STORED PROCEDURE`](https://youtu.be/OuJerKzV5T0?t=20033)

Un **procediment emmagatzemat** és un bloc d'instruccions SQL guardat a la base de dades amb un nom, que pot rebre **paràmetres**. És l'equivalent d'una funció de Python, però s'executa dins el gestor:

```sql
DELIMITER //
CREATE PROCEDURE p_notes_alumne(IN p_alumne_id INT)
BEGIN
    SELECT assignatura, nota
    FROM v_notes
    WHERE alumne_id = p_alumne_id
    ORDER BY nota DESC;
END//
DELIMITER ;
```

```sql
CALL p_notes_alumne(2);
```

!!! info "Per què `DELIMITER`?"
    Dins el procediment hi ha instruccions que acaben amb `;`. Si el client trobàs aquest `;`, pensaria que la instrucció `CREATE PROCEDURE` ja s'ha acabat i l'enviaria a mitges. `DELIMITER //` canvia temporalment el final d'instrucció a `//`, i `DELIMITER ;` el torna a deixar com estava. És una ordre del client (la consola, Workbench), no de l'SQL. A phpMyAdmin hi ha un camp **Delimitador** davall l'editor d'SQL que fa la mateixa funció.

Per esborrar-lo: `DROP PROCEDURE p_notes_alumne;`.

!!! example "Exercici 2"
    Crea el procediment `p_resum_grup`, que rebi el nom d'un grup i mostri, per a cada alumne del grup, el nombre de notes, la mitjana arrodonida a dos decimals i el nombre de suspeses, ordenat per nom. Prova'l amb el grup `'1BA'`.

    ??? success "Solució"
        ```sql
        DELIMITER //
        CREATE PROCEDURE p_resum_grup(IN p_grup VARCHAR(20))
        BEGIN
            SELECT alumne,
                   COUNT(*) AS notes,
                   ROUND(AVG(nota), 2) AS mitjana,
                   SUM(CASE WHEN nota < 5 THEN 1 ELSE 0 END) AS suspeses
            FROM v_notes
            WHERE grup = p_grup
            GROUP BY alumne_id, alumne
            ORDER BY alumne;
        END//
        DELIMITER ;

        CALL p_resum_grup('1BA');
        ```

        | alumne | notes | mitjana | suspeses |
        | --- | --- | --- | --- |
        | Aina Ferrer Pons | 3 | 8.25 | 0 |
        | Biel Mas Riera | 3 | 5.42 | 1 |
        | Carla Vidal Bauzà | 2 | 8.88 | 0 |

        Aquesta és la consulta del repte del mòdul [SQL: consultar i modificar dades](sql.md#9-repte), però ara funciona per a qualsevol grup i sense haver d'escriure a mà els identificadors dels alumnes.

## 3. *Triggers*

> **Vídeo:** [`TRIGGER`](https://youtu.be/OuJerKzV5T0?t=18961)

Un ***trigger*** (disparador) és un bloc d'instruccions que s'executa **automàticament** quan passa alguna cosa a una taula: una inserció, una modificació o un esborrat. Es pot executar abans (`BEFORE`) o després (`AFTER`) de l'operació. Dins el *trigger*:

- `NEW` és la fila tal com quedarà (en `INSERT` i `UPDATE`).
- `OLD` és la fila tal com era (en `UPDATE` i `DELETE`).

Un ús habitual és guardar un **historial de canvis**. Per exemple, cada vegada que es modifica una nota, guardam la nota anterior i la nova:

```sql
CREATE TABLE historial_notes (
    historial_id INT AUTO_INCREMENT PRIMARY KEY,
    alumne_id INT NOT NULL,
    assignatura_id INT NOT NULL,
    nota_anterior DECIMAL(4,2),
    nota_nova DECIMAL(4,2),
    data_canvi DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER tg_historial_notes
AFTER UPDATE ON notes
FOR EACH ROW
BEGIN
    IF NOT (OLD.nota <=> NEW.nota) THEN
        INSERT INTO historial_notes (alumne_id, assignatura_id, nota_anterior, nota_nova)
        VALUES (OLD.alumne_id, OLD.assignatura_id, OLD.nota, NEW.nota);
    END IF;
END//
DELIMITER ;
```

```sql
UPDATE notes SET nota = 5.25 WHERE alumne_id = 2 AND assignatura_id = 1;
SELECT * FROM historial_notes;
```

!!! warning "Compte amb els `NULL` en comparar"
    El *trigger* del vídeo comprova si el correu ha canviat amb `OLD.email <> NEW.email`. Si un dels dos valors és `NULL`, la comparació no dona ni cert ni fals, sinó `NULL`, i el `IF` no s'executa: posar un correu a un usuari que no en tenia **no quedaria registrat**. L'operador `<=>` compara tenint en compte els `NULL` (`NULL <=> NULL` és cert), i per això aquí hem escrit `NOT (OLD.nota <=> NEW.nota)`.

Un *trigger* `BEFORE` també pot **impedir** una operació, llançant un error amb `SIGNAL`. Així es poden imposar regles que les restriccions d'una taula no poden expressar.

!!! example "Exercici 3"
    1. Crea la taula `historial_notes` i el *trigger* `tg_historial_notes` de l'exemple. Puja la nota del Biel a PTD I (alumne 2, assignatura 1) a 5,25 i, després, torna a executar el mateix `UPDATE`. Quantes files hi ha a l'historial? Per què?
    2. A la base de dades `biblioteca`, crea un *trigger* que impedeixi inserir un préstec si l'usuari ja té tres llibres pendents de retornar. Comprova-ho.

    ??? success "Solució"
        1. Una sola fila: el segon `UPDATE` no canvia el valor (ja era 5,25), i la condició del `IF` evita que es registri.

        2.
        ```sql
        USE biblioteca;

        DELIMITER //
        CREATE TRIGGER tg_maxim_prestecs
        BEFORE INSERT ON prestecs
        FOR EACH ROW
        BEGIN
            DECLARE pendents INT;
            SELECT COUNT(*) INTO pendents
            FROM prestecs
            WHERE usuari_id = NEW.usuari_id AND data_retorn IS NULL;
            IF pendents >= 3 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Aquest usuari ja té tres llibres en préstec';
            END IF;
        END//
        DELIMITER ;

        -- Amb les dades de la solució de l'exercici 3 del mòdul anterior,
        -- l'Aina (usuari 1) té un préstec pendent:
        INSERT INTO prestecs (exemplar_id, usuari_id, data_prestec) VALUES (2, 1, '2026-10-25');
        INSERT INTO prestecs (exemplar_id, usuari_id, data_prestec) VALUES (5, 1, '2026-10-26');
        INSERT INTO prestecs (exemplar_id, usuari_id, data_prestec) VALUES (1, 1, '2026-10-27');  -- error
        ```

        Els dos primers préstecs s'accepten (l'Aina passa a tenir-ne tres) i el tercer es rebutja amb el missatge del `SIGNAL`. `DECLARE` crea una variable local i `SELECT … INTO` hi guarda el resultat d'una consulta.

        Aquest *trigger* no comprova si l'exemplar ja està prestat a una altra persona. Com ho faries?

## 4. Índexs

> **Vídeo:** [`INDEX`](https://youtu.be/OuJerKzV5T0?t=18219)

Per trobar les files que compleixen un `WHERE`, el gestor, en principi, ha de revisar **totes** les files de la taula. Amb deu alumnes no es nota, però amb deu milions sí. Un **índex** és una estructura auxiliar, com l'índex alfabètic d'un llibre, que permet trobar les files ràpidament sense recórrer-les totes:

```sql
CREATE INDEX idx_llinatges ON alumnes(llinatges);
DROP INDEX idx_llinatges ON alumnes;
```

- Les claus primàries, les columnes `UNIQUE` i, a MySQL i MariaDB, les claus foranes ja tenen un índex automàticament. Ho pots veure amb `SHOW INDEX FROM alumnes;`.
- `CREATE UNIQUE INDEX` crea un índex que, a més, no permet valors repetits.
- `EXPLAIN` davant una consulta mostra com l'executarà el gestor i quin índex farà servir: `EXPLAIN SELECT * FROM alumnes WHERE llinatges = 'Mas Riera';`.

!!! warning "Els índexs no són gratis"
    Cada índex ocupa espai i s'ha d'actualitzar a cada `INSERT`, `UPDATE` i `DELETE`, cosa que fa més lentes les escriptures. Es creen per a les columnes que es fan servir sovint per cercar, filtrar, ordenar o combinar taules, no per a totes.

!!! info "Un detall del repositori del vídeo"
    El fitxer `01_index.sql` del repositori crea dues vegades un índex amb el mateix nom, `idx_name`. Si l'executes sencer, la segona instrucció dona l'error *Duplicate key name*: al vídeo, l'índex s'esborra entre una prova i l'altra.

## 5. Transaccions i concurrència

> **Vídeo:** [transaccions](https://youtu.be/OuJerKzV5T0?t=20501) · [concurrència](https://youtu.be/OuJerKzV5T0?t=20701)

Algunes operacions necessiten **diverses instruccions** que s'han de fer totes o cap. L'exemple clàssic és una transferència bancària: si es resten els doblers d'un compte i el sistema falla abans de sumar-los a l'altre, els doblers desapareixen. A l'institut: per donar de baixa un alumne s'han d'esborrar les seves notes i, després, l'alumne. Si el segon pas falla, no volem haver perdut les notes.

Una **transacció** agrupa instruccions perquè s'executin com una unitat:

```sql
START TRANSACTION;
DELETE FROM notes WHERE alumne_id = 3;
DELETE FROM alumnes WHERE alumne_id = 3;
-- Si tot ha anat bé:
COMMIT;
-- Si alguna cosa ha fallat, en lloc de COMMIT:
-- ROLLBACK;
```

- `START TRANSACTION` inicia la transacció. Els canvis que es fan a partir d'aquí són provisionals.
- `COMMIT` els confirma i els fa definitius.
- `ROLLBACK` els desfà tots i deixa la base de dades com era abans de començar.

!!! info "*Autocommit*"
    Fora d'una transacció, MySQL i MariaDB funcionen en mode *autocommit*: cada instrucció es confirma automàticament en acabar. Per això un `DELETE` sense transacció no es pot desfer.

Les transaccions també resolen el problema de la **concurrència**: què passa quan dues persones modifiquen les mateixes dades alhora. El gestor aïlla les transaccions entre elles perquè una no vegi els canvis a mitges de l'altra. Aquestes garanties es resumeixen amb les sigles **ACID**:

| Propietat | Significat |
| --- | --- |
| **A**tomicitat | La transacció es fa sencera o no es fa |
| **C**onsistència | La base de dades passa d'un estat vàlid a un altre estat vàlid; es respecten totes les restriccions |
| **I**solament (*isolation*) | Les transaccions simultànies no s'interfereixen |
| **D**urabilitat | Un cop confirmada, la transacció no es perd, encara que se'n vagi el corrent |

!!! example "Exercici 4"
    1. Inicia una transacció, esborra les notes i l'alumne 3 (la Carla) i comprova amb un `SELECT` que ja no hi és. Fes `ROLLBACK` i torna-ho a comprovar.
    2. Per què és important fer servir una transacció en una aplicació que registra la venda d'un producte (resta una unitat de l'estoc i insereix la venda)?

    ??? success "Solució"
        ```sql
        START TRANSACTION;
        DELETE FROM notes WHERE alumne_id = 3;
        DELETE FROM alumnes WHERE alumne_id = 3;
        SELECT COUNT(*) FROM alumnes;     -- 9
        ROLLBACK;
        SELECT COUNT(*) FROM alumnes;     -- 10: la Carla torna a ser-hi, i les seves notes també
        ```

        2. Si l'estoc es restàs però la venda no s'arribàs a inserir (o a l'inrevés), les dades quedarien inconsistents: un producte desaparegut sense venda, o una venda sense descomptar de l'estoc. Amb una transacció, o es fan les dues coses o no se'n fa cap.

## 6. Connectar-se des de Python

> **Vídeo:** [lliçó 19, «Conexión desde código»](https://youtu.be/OuJerKzV5T0?t=20847) · [connectors](https://youtu.be/OuJerKzV5T0?t=20876) · [injecció d'SQL](https://youtu.be/OuJerKzV5T0?t=21149)

Les aplicacions no demanen als usuaris que escriguin SQL: és el programa qui construeix les consultes, les envia al gestor i en mostra els resultats. Per fer-ho, cada llenguatge té un **connector**, una biblioteca que parla amb el gestor. Per a Python i MySQL, el connector oficial és `mysql-connector-python`:

```bash
pip install mysql-connector-python
```

### 6.1. Consultar

```python
import mysql.connector

connexio = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="alumne",
    password="alumne",
    database="institut",
)

cursor = connexio.cursor()
cursor.execute("SELECT nom, llinatges, municipi FROM alumnes ORDER BY llinatges")
for nom, llinatges, municipi in cursor.fetchall():
    print(f"{llinatges}, {nom} ({municipi})")

cursor.close()
connexio.close()
```

```text
Amengual Mir, Joan (Calvià)
Bennàssar Vich, Hug (Marratxí)
Ferrer Pons, Aina (Palma)
…
```

Les passes són sempre les mateixes:

1. **Connectar-se** amb `connect`, indicant on és el servidor, l'usuari, la contrasenya i la base de dades.
2. Crear un **cursor**, l'objecte que envia les consultes i en recull els resultats.
3. **Executar** la consulta amb `execute`.
4. **Recollir** els resultats amb `fetchall()`, que retorna una llista de tuples (una per fila), o `fetchone()`, que en retorna una.
5. **Tancar** el cursor i la connexió.

!!! info "Usuari i contrasenya"
    L'usuari `alumne` amb contrasenya `alumne` és un exemple. Amb XAMPP, l'usuari per defecte és `root` sense contrasenya (`password=""`). Amb MySQL, és l'usuari i la contrasenya que vas triar en instal·lar-lo. En qualsevol cas, **no publiquis mai contrasenyes reals** dins el codi, i encara menys en un repositori públic: guarda-les en un fitxer a part que no es comparteixi o en variables d'entorn.

### 6.2. L'injecció d'SQL

Imagina un programa que demana un municipi i mostra els alumnes que hi viuen. La manera més òbvia de fer-ho és construir la consulta enganxant-hi el text de l'usuari:

```python
def cerca_insegura(municipi):
    consulta = f"SELECT nom, correu FROM alumnes WHERE municipi = '{municipi}'"
    cursor.execute(consulta)
    return cursor.fetchall()
```

Funciona amb `cerca_insegura("Inca")`. Però mira què passa si l'usuari escriu `x' OR '1'='1`. La consulta que s'executa és:

```sql
SELECT nom, correu FROM alumnes WHERE municipi = 'x' OR '1'='1'
```

Com que `'1'='1'` sempre és cert, la consulta retorna **tots** els alumnes amb els seus correus. L'usuari ha aconseguit modificar la consulta escrivint-hi SQL. Això és una **injecció d'SQL**, una de les vulnerabilitats més conegudes i més greus de les aplicacions web: segons com estigui programada l'aplicació, permet llegir dades privades, saltar-se una pantalla d'inici de sessió o modificar dades.

La solució és **no construir mai consultes enganxant textos**, sinó fer servir **consultes parametritzades**: s'escriu `%s` on va cada valor i els valors es passen a part, dins una tupla. El connector s'encarrega que cada valor es tracti sempre com una dada, mai com a codi SQL:

```python
def cerca_segura(municipi):
    consulta = "SELECT nom, correu FROM alumnes WHERE municipi = %s"
    cursor.execute(consulta, (municipi,))
    return cursor.fetchall()
```

Ara, `cerca_segura("x' OR '1'='1")` retorna una llista buida: cerca un municipi que es diu literalment `x' OR '1'='1`, i no n'hi ha cap.

!!! danger "Norma d'or"
    Les dades que venen de fora (del teclat, d'un formulari web, d'un fitxer) **mai** no s'enganxen dins una consulta amb `f"…"`, `+` o `format`. Sempre es passen com a paràmetres.

!!! warning "`(municipi,)` i no `(municipi)`"
    Els paràmetres van dins una tupla. Una tupla d'un sol element necessita la coma final: `(municipi)` és només un text entre parèntesis.

### 6.3. Modificar dades

Quan el programa fa un `INSERT`, un `UPDATE` o un `DELETE`, el connector obre una transacció: els canvis no són definitius fins que es crida `connexio.commit()`. Si hi ha un error, es pot desfer amb `connexio.rollback()`:

```python
import mysql.connector

connexio = mysql.connector.connect(host="localhost", user="alumne",
                                   password="alumne", database="institut")
cursor = connexio.cursor()

alumne_id = int(input("Identificador de l'alumne: "))
assignatura_id = int(input("Identificador de l'assignatura: "))
nota = float(input("Nota: "))

try:
    cursor.execute(
        "INSERT INTO notes (alumne_id, assignatura_id, nota) VALUES (%s, %s, %s)",
        (alumne_id, assignatura_id, nota),
    )
    connexio.commit()
    print("Nota desada.")
except mysql.connector.Error as error:
    connexio.rollback()
    print("No s'ha pogut desar la nota:", error.msg)

cursor.close()
connexio.close()
```

Les restriccions de la base de dades continuen fent la seva feina: si s'introdueix una nota d'11, un alumne que no existeix o una nota que ja hi era, el gestor la rebutja i el programa mostra el missatge d'error en lloc d'aturar-se.

!!! info "I sense servidor? SQLite"
    Python porta incorporat el mòdul `sqlite3`, que treballa amb **SQLite**: una base de dades relacional guardada en un sol fitxer, sense cap servidor. Es fa servir de manera molt semblant (`connect`, `cursor`, `execute` amb paràmetres, `commit`), però els paràmetres s'indiquen amb `?` en lloc de `%s` i hi ha petites diferències d'SQL (per exemple, no existeix `AUTO_INCREMENT`). És una bona opció per a projectes petits i per a aplicacions de mòbil.

!!! example "Exercici 5"
    1. Escriu un programa que demani el nom d'un grup i mostri la llista dels seus alumnes (llinatges i nom), ordenada per llinatges. Fes servir una consulta parametritzada. Prova'l amb `1BA` i amb `x' OR '1'='1`.
    2. Escriu una funció `mitjana_alumne(alumne_id)` que retorni la mitjana de les notes d'un alumne com un `float`, o `None` si no en té cap. Prova-la amb els alumnes 1 i 10.
    3. Quin problema de seguretat té aquesta línia? Reescriu-la correctament.

        ```python
        cursor.execute("DELETE FROM notes WHERE alumne_id = " + input("Alumne: "))
        ```

    ??? success "Solució"
        ```python
        import mysql.connector

        connexio = mysql.connector.connect(host="localhost", user="alumne",
                                           password="alumne", database="institut")
        cursor = connexio.cursor()

        # 1
        grup = input("Grup: ")
        cursor.execute(
            """SELECT a.llinatges, a.nom
               FROM alumnes a
               JOIN grups g ON a.grup_id = g.grup_id
               WHERE g.nom = %s
               ORDER BY a.llinatges""",
            (grup,),
        )
        files = cursor.fetchall()
        if files:
            for llinatges, nom in files:
                print(f"{llinatges}, {nom}")
        else:
            print("No hi ha cap alumne en aquest grup.")


        # 2
        def mitjana_alumne(alumne_id):
            cursor.execute("SELECT AVG(nota) FROM notes WHERE alumne_id = %s", (alumne_id,))
            (mitjana,) = cursor.fetchone()
            return None if mitjana is None else float(mitjana)


        print(mitjana_alumne(1))
        print(mitjana_alumne(10))

        cursor.close()
        connexio.close()
        ```

        Amb `1BA` mostra Ferrer Pons, Aina; Mas Riera, Biel; i Vidal Bauzà, Carla. Amb `x' OR '1'='1` mostra «No hi ha cap alumne en aquest grup». `mitjana_alumne(1)` retorna `8.25` i `mitjana_alumne(10)`, `None`, perquè el Joan no té notes.

        `AVG` sempre retorna una fila, encara que no hi hagi notes; en aquest cas, el valor és `NULL`, que a Python arriba com a `None`. A més, el connector retorna els `DECIMAL` com a objectes `Decimal` de Python; per això es converteixen amb `float`.

        3. És vulnerable a la injecció d'SQL: si l'usuari escriu `1 OR 1=1`, s'esborren **totes** les notes. A més, faltaria el `commit`. Versió correcta:

        ```python
        alumne_id = int(input("Alumne: "))
        cursor.execute("DELETE FROM notes WHERE alumne_id = %s", (alumne_id,))
        connexio.commit()
        ```

## 7. Més enllà: altres clients, PostgreSQL i el núvol

> **Vídeo:** [lliçó 20, «Otros clientes SQL»](https://youtu.be/OuJerKzV5T0?t=21641) · [lliçó 21, «PostgreSQL»](https://youtu.be/OuJerKzV5T0?t=22070) · [lliçó 22, «Despliegue en la nube»](https://youtu.be/OuJerKzV5T0?t=23214)

Les darreres lliçons del vídeo mostren que el que has après no depèn de MySQL:

- **Altres clients.** Hi ha molts programes per connectar-se a una base de dades, a més de Workbench i phpMyAdmin, i molts funcionen amb diversos SGBD alhora.
- **PostgreSQL** és un altre SGBD relacional lliure, molt utilitzat. L'SQL bàsic (`SELECT`, `JOIN`, `GROUP BY`, `INSERT`…) és pràcticament igual; canvien detalls com els tipus autoincrementals o algunes funcions.
- **El núvol.** Les aplicacions reals no tenen la base de dades a l'ordinador del programador, sinó en un servidor accessible per internet. El vídeo en mostra el desplegament en un servei al núvol. Connectar-s'hi des de Python funciona igual que en local, però amb una altra adreça, usuari i contrasenya.

!!! warning "Les credencials, fora del codi"
    Una base de dades al núvol és accessible des de qualsevol lloc d'internet. Si les seves credencials apareixen dins un fitxer de codi publicat, qualsevol persona hi pot entrar. Quan publiquis un projecte, revisa que no hi hagi contrasenyes en cap fitxer, ni tan sols dins un comentari.

## 8. Repte

!!! example "Repte. Una aplicació de consola per a la biblioteca"
    Programa en Python una aplicació de consola per a la base de dades `biblioteca` amb aquest menú:

    ```text
    1. Cercar llibres per títol
    2. Veure els préstecs pendents
    3. Registrar un préstec
    4. Registrar una devolució
    0. Sortir
    ```

    Requisits:

    - Totes les consultes han de ser **parametritzades**.
    - La cerca per títol ha de trobar els llibres que **contenen** el text introduït. Pista: el paràmetre pot ser `f"%{text}%"`, i la consulta, `WHERE titol LIKE %s`. Això no és enganxar text dins la consulta: el text va com a paràmetre.
    - Per registrar un préstec es demanen l'identificador de l'exemplar i el de l'usuari. Si el *trigger* de l'exercici 3 el rebutja, el programa ha de mostrar-ne el missatge sense aturar-se.
    - Registrar una devolució és posar la data d'avui (`CURDATE()`) a `data_retorn` del préstec indicat, només si encara estava pendent.
    - Organitza el codi en **funcions**, una per opció del menú.

    Ampliació: crea una vista `v_prestecs_pendents` i fes-la servir a l'opció 2; afegeix una opció que mostri els préstecs de més de 15 dies (funció `DATEDIFF`).

    ??? success "Solució"
        ```python
        import mysql.connector

        connexio = mysql.connector.connect(host="localhost", user="alumne",
                                           password="alumne", database="biblioteca")
        cursor = connexio.cursor()


        def cercar_llibres():
            text = input("Text del títol: ")
            cursor.execute(
                "SELECT llibre_id, titol, any_publicacio FROM llibres WHERE titol LIKE %s ORDER BY titol",
                (f"%{text}%",),
            )
            files = cursor.fetchall()
            if not files:
                print("No s'ha trobat cap llibre.")
            for llibre_id, titol, any_publicacio in files:
                print(f"[{llibre_id}] {titol} ({any_publicacio})")


        def veure_pendents():
            cursor.execute(
                """SELECT p.prestec_id, CONCAT(u.nom, ' ', u.llinatges), l.titol, p.data_prestec
                   FROM prestecs p
                   JOIN usuaris u ON p.usuari_id = u.usuari_id
                   JOIN exemplars e ON p.exemplar_id = e.exemplar_id
                   JOIN llibres l ON e.llibre_id = l.llibre_id
                   WHERE p.data_retorn IS NULL
                   ORDER BY p.data_prestec"""
            )
            for prestec_id, usuari, titol, data in cursor.fetchall():
                print(f"[{prestec_id}] {data}  {usuari}: {titol}")


        def registrar_prestec():
            exemplar_id = int(input("Exemplar: "))
            usuari_id = int(input("Usuari: "))
            try:
                cursor.execute(
                    "INSERT INTO prestecs (exemplar_id, usuari_id) VALUES (%s, %s)",
                    (exemplar_id, usuari_id),
                )
                connexio.commit()
                print("Préstec registrat.")
            except mysql.connector.Error as error:
                connexio.rollback()
                print("No s'ha pogut registrar:", error.msg)


        def registrar_devolucio():
            prestec_id = int(input("Préstec: "))
            cursor.execute(
                "UPDATE prestecs SET data_retorn = CURDATE() WHERE prestec_id = %s AND data_retorn IS NULL",
                (prestec_id,),
            )
            connexio.commit()
            if cursor.rowcount == 1:
                print("Devolució registrada.")
            else:
                print("No hi ha cap préstec pendent amb aquest número.")


        opcions = {
            "1": cercar_llibres,
            "2": veure_pendents,
            "3": registrar_prestec,
            "4": registrar_devolucio,
        }

        while True:
            print("\n1. Cercar llibres per títol\n2. Veure els préstecs pendents")
            print("3. Registrar un préstec\n4. Registrar una devolució\n0. Sortir")
            opcio = input("Opció: ")
            if opcio == "0":
                break
            elif opcio in opcions:
                try:
                    opcions[opcio]()
                except ValueError:
                    print("Cal escriure un número.")
            else:
                print("Opció no vàlida.")

        cursor.close()
        connexio.close()
        ```

        Alguns detalls:

        - El diccionari `opcions` associa cada tecla a una funció. Així el bucle principal no necessita una cadena llarga d'`elif`.
        - El `try`/`except ValueError` del bucle captura els errors de conversió de tots els `int(input(…))`.
        - Al préstec no s'indica la data: la posa el `DEFAULT (CURRENT_DATE)` de la taula.
        - `cursor.rowcount` diu quantes files ha modificat l'últim `UPDATE`. Si és 0, el préstec no existia o ja s'havia retornat.

---

!!! quote "Fonts"
    Mòdul elaborat a partir del curs en vídeo [«Hello SQL»](https://youtu.be/OuJerKzV5T0) de Brais Moure (MoureDev), al qual s'enllaça per lliçons, i del seu repositori de codi [mouredev/hello-sql](https://github.com/mouredev/hello-sql) ([llicència Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)). Canvis respecte del repositori: no se'n reprodueix el codi literalment; els exemples s'han reescrit per a les bases de dades `institut` i `biblioteca`, amb comentaris en català; la comparació del *trigger* s'ha fet segura davant els `NULL`, i l'exemple d'injecció d'SQL és propi. Són propis: les explicacions, els exercicis, el repte i totes les solucions, provades amb MariaDB i Python.
