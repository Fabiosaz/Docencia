# Unitat 0. Repàs d'electricitat

Abans d'entrar a l'electrònica, convé tenir ben assentades les idees bàsiques d'electricitat que ja vares veure en cursos anteriors: què és el corrent, què són la tensió i la resistència, com es relacionen amb la llei d'Ohm i com es calculen els circuits en sèrie, en paral·lel i mixts. Tot el que ve després (díodes, transistors, portes lògiques, sensors) es basa en això.

## 0.1. El circuit elèctric

Un **circuit elèctric** és un camí tancat per on circulen els electrons. Tot circuit té quatre tipus d'elements:

| Element | Funció | Exemples |
| --- | --- | --- |
| **Generador** | Proporciona l'energia que fa moure els electrons | Pila, bateria, font d'alimentació, placa solar |
| **Conductors** | Uneixen els elements i permeten el pas del corrent | Cables de coure, pistes d'una placa |
| **Receptors** | Transformen l'energia elèctrica en una altra forma d'energia | Bombeta o LED (llum), motor (moviment), resistència (calor), brunzidor (so) |
| **Elements de control i protecció** | Permeten obrir o tancar el circuit i el protegeixen | Interruptor, polsador, commutador, fusible |

Si el camí està tancat i hi ha un generador, hi circula corrent: el circuit està **tancat**. Si el camí s'interromp (per exemple, en obrir un interruptor), deixa de circular: el circuit està **obert**.

!!! warning "Curtcircuit"
    Un **curtcircuit** es produeix quan els dos borns del generador s'uneixen directament amb un conductor, sense cap receptor entremig. La resistència és gairebé nul·la, el corrent es dispara i els cables s'escalfen molt: es poden fondre, provocar un incendi o espenyar la pila. Els **fusibles** i els **interruptors magnetotèrmics** tallen el corrent quan passa massa intensitat.

## 0.2. Les magnituds elèctriques

| Magnitud | Símbol | Unitat | Què és | Analogia hidràulica |
| --- | --- | --- | --- | --- |
| **Intensitat** | I | ampere (A) | Quantitat de càrrega que passa per un punt cada segon | Cabal d'aigua per una canonada |
| **Tensió** o diferència de potencial | V | volt (V) | Energia que dona el generador a cada unitat de càrrega; «empenta» que fa circular el corrent | Diferència d'alçada entre dos dipòsits |
| **Resistència** | R | ohm (Ω) | Oposició d'un material al pas del corrent | Estretor de la canonada |
| **Potència** | P | watt (W) | Energia que consumeix o produeix un element cada segon | — |
| **Energia** | E | joule (J) o kilowatt hora (kWh) | Treball que fa el corrent en un temps | — |

En electrònica és molt habitual treballar amb **múltiples i submúltiples**:

| Prefix | Símbol | Valor | Exemple |
| --- | --- | --- | --- |
| mega | M | 10⁶ = 1.000.000 | 1 MΩ = 1.000.000 Ω |
| kilo | k | 10³ = 1.000 | 4,7 kΩ = 4.700 Ω |
| mil·li | m | 10⁻³ = 0,001 | 20 mA = 0,02 A |
| micro | µ | 10⁻⁶ = 0,000 001 | 100 µF = 0,0001 F |

!!! info "El sentit del corrent"
    Els electrons van del born **negatiu** al **positiu** del generador. Però, per raons històriques, en els esquemes es fa servir el **sentit convencional**, del **positiu** al **negatiu**. És el que farem servir sempre.

## 0.3. La llei d'Ohm

La **llei d'Ohm** relaciona les tres magnituds bàsiques: la intensitat que circula per un element és directament proporcional a la tensió que hi ha entre els seus extrems i inversament proporcional a la seva resistència:

| Per calcular… | Fórmula |
| --- | --- |
| La intensitat | **I = V / R** |
| La tensió | **V = I · R** |
| La resistència | **R = V / I** |

Exemple: una resistència de 470 Ω connectada a una pila de 9 V deixa passar I = 9 / 470 ≈ 0,019 A = **19 mA**.

!!! tip "Unitats coherents"
    Si la tensió és en volts i la resistència en ohms, la intensitat surt en amperes. Si poses la resistència en kΩ, la intensitat sortirà en mA. Passa-ho tot a la unitat base abans de calcular i t'estalviaràs errors.

!!! example "Exercici 0.1. Llei d'Ohm"
    1. Quina intensitat circula per una resistència de 1,5 kΩ connectada a 12 V?
    2. Per una bombeta connectada a 230 V hi passen 0,26 A. Quina resistència té?
    3. Quina tensió hi ha entre els extrems d'una resistència de 220 Ω per la qual passen 25 mA?

    ??? success "Solució"
        1. I = 12 / 1.500 = 0,008 A = **8 mA**.
        2. R = 230 / 0,26 ≈ **885 Ω**.
        3. V = 0,025 · 220 = **5,5 V**.

## 0.4. Potència i energia

La **potència** d'un element és l'energia que transforma cada segon:

**P = V · I**

Combinant-la amb la llei d'Ohm, també es pot calcular com P = I² · R o P = V² / R.

L'**energia** consumida depèn de la potència i del temps que funciona l'aparell:

**E = P · t**

Si la potència es posa en watts i el temps en segons, l'energia surt en joules. Però a la factura de la llum es fa servir el **kilowatt hora** (kWh): l'energia que consumeix un aparell d'1 kW durant 1 hora. Per calcular en kWh, posa la potència en **kW** i el temps en **hores**.

Exemple: un microones de 800 W funciona 15 minuts cada dia durant un mes de 30 dies:

- Temps: 0,25 h/dia · 30 dies = 7,5 h.
- Energia: E = 0,8 kW · 7,5 h = **6 kWh**.
- Si suposam que el kWh costa 0,15 €, el cost és 6 · 0,15 = **0,90 €**.

!!! info "Les resistències també tenen potència"
    Una resistència transforma l'energia en calor. Si s'hi dissipa més potència de la que pot suportar, s'escalfa massa i es crema. Les resistències de 4 mm que feim servir al taller solen ser de **¼ W** (0,25 W).

!!! example "Exercici 0.2. Potència i energia"
    1. Un forn elèctric de 2.300 W es connecta a 230 V. Quina intensitat consumeix?
    2. Si funciona 1 hora i mitja, quanta energia consumeix en kWh?
    3. Una resistència de 100 Ω i ¼ W es connecta a 9 V. Aguantarà?

    ??? success "Solució"
        1. I = P / V = 2.300 / 230 = **10 A**.
        2. E = 2,3 kW · 1,5 h = **3,45 kWh**.
        3. P = V² / R = 81 / 100 = **0,81 W**, molt més que 0,25 W. **No aguantarà**: s'escalfarà i es cremarà. Cal una resistència de més potència o de més valor.

## 0.5. Associació de resistències

### 0.5.1. Circuit en sèrie

Els elements estan connectats **un darrere l'altre**, de manera que només hi ha un camí per al corrent.

![Circuit en sèrie](img/u0-serie.svg){ width="360" }

- La **intensitat** és la **mateixa** per a tots els elements.
- La **tensió** del generador es **reparteix** entre els elements: V = V₁ + V₂ + …
- La **resistència equivalent** és la **suma**: R_T = R₁ + R₂ + …
- Si un element s'espenya i obre el circuit, **tots deixen de funcionar**.

### 0.5.2. Circuit en paral·lel

Els elements estan connectats **entre els mateixos dos punts**, de manera que el corrent es divideix en diverses branques.

![Circuit en paral·lel](img/u0-parallel.svg){ width="260" }

- La **tensió** és la **mateixa** per a tots els elements.
- La **intensitat** total es **reparteix** entre les branques: I = I₁ + I₂ + …
- La **resistència equivalent** compleix 1/R_T = 1/R₁ + 1/R₂ + … i sempre és **més petita** que la més petita de les resistències.
- Per a dues resistències: **R_T = (R₁ · R₂) / (R₁ + R₂)**.
- Si un element s'espenya, **els altres continuen funcionant**. Per això les instal·lacions de les cases es fan en paral·lel.

### 0.5.3. Circuit mixt

Combina parts en sèrie i parts en paral·lel. Es resol **per passos**: se substitueixen els grups en paral·lel i en sèrie per la seva resistència equivalent fins que en queda una, es calcula la intensitat total i es torna enrere calculant les tensions i les intensitats de cada element.

![Circuit mixt](img/u0-mixt.svg){ width="420" }

Exemple amb aquest circuit:

1. R₂ i R₃ són en paral·lel: R₂₃ = (6 · 3) / (6 + 3) = 18 / 9 = **2 Ω**.
2. R₁ i R₂₃ són en sèrie: R_T = 4 + 2 = **6 Ω**.
3. Intensitat total: I = 12 / 6 = **2 A**. És la que passa per R₁.
4. Tensió a R₁: V₁ = 2 · 4 = **8 V**. La que queda per al paral·lel: V₂₃ = 12 − 8 = **4 V**.
5. Intensitats de les branques: I₂ = 4 / 6 ≈ **0,67 A**; I₃ = 4 / 3 ≈ **1,33 A**. Comprovació: 0,67 + 1,33 = 2 A. ✔

!!! example "Exercici 0.3. Sèrie i paral·lel"
    Tens dues resistències, R₁ = 100 Ω i R₂ = 300 Ω, i una pila de 12 V.

    1. Connectades en **sèrie**: calcula la resistència equivalent, la intensitat i la tensió a cada resistència.
    2. Connectades en **paral·lel**: calcula la resistència equivalent, la intensitat de cada branca i la total.
    3. En quin dels dos casos es consumeix més potència?

    ??? success "Solució"
        1. Sèrie: R_T = 400 Ω; I = 12 / 400 = **0,03 A** (30 mA); V₁ = 0,03 · 100 = **3 V**; V₂ = 0,03 · 300 = **9 V**.
        2. Paral·lel: R_T = (100 · 300) / 400 = **75 Ω**; I₁ = 12 / 100 = **0,12 A**; I₂ = 12 / 300 = **0,04 A**; I = **0,16 A**.
        3. Sèrie: P = 12 · 0,03 = 0,36 W. Paral·lel: P = 12 · 0,16 = 1,92 W. Es consumeix **més en paral·lel**, perquè la resistència equivalent és més petita i passa més corrent.

!!! example "Exercici 0.4. Circuit mixt"
    Una pila de 9 V alimenta R₁ = 150 Ω en sèrie amb un paral·lel format per R₂ = 200 Ω i R₃ = 200 Ω. Calcula la resistència equivalent, la intensitat total, la tensió a R₁ i al paral·lel, i la intensitat per R₂.

    ??? success "Solució"
        - R₂₃ = (200 · 200) / 400 = **100 Ω** (dues resistències iguals en paral·lel donen la meitat).
        - R_T = 150 + 100 = **250 Ω**.
        - I = 9 / 250 = **0,036 A** (36 mA).
        - V₁ = 0,036 · 150 = **5,4 V**; V₂₃ = 0,036 · 100 = **3,6 V**.
        - I₂ = 3,6 / 200 = **0,018 A** (18 mA), la meitat del total, com era d'esperar.

## 0.6. Mesurar amb el polímetre

El **polímetre** (o multímetre) mesura tensió, intensitat, resistència i, en molts models, continuïtat, díodes i capacitat. La manera de connectar-lo depèn del que vulguem mesurar:

![Mesura de la intensitat i de la tensió](img/u0-mesures.svg){ width="320" }

| Magnitud | Com es connecta | Precaucions |
| --- | --- | --- |
| **Tensió** (voltímetre) | En **paral·lel** amb l'element, amb el circuit funcionant | Tria corrent continu (V⎓) o altern (V~) |
| **Intensitat** (amperímetre) | En **sèrie**: s'ha d'obrir el circuit i fer passar el corrent per l'aparell | Canvia la punta vermella al born d'intensitat. Mai no el connectis en paral·lel: seria un curtcircuit |
| **Resistència** (ohmímetre) | Als extrems de l'element, **amb el circuit sense alimentació** | Si l'element és dins d'un circuit, almanco una pota ha d'estar desconnectada |
| **Continuïtat** | Com la resistència | Xiula si hi ha connexió: útil per comprovar cables i soldadures |

Comença sempre per l'**escala més alta** si no saps el valor aproximat, i baixa fins que la lectura tengui prou xifres.

## 0.7. Seguretat elèctrica

Al taller treballarem amb piles i fonts de poca tensió (fins a 12 V), que no són perilloses per a les persones. La xarxa elèctrica de 230 V, en canvi, **pot ser mortal**. Normes bàsiques:

- No manipulis mai aparells connectats a la xarxa ni obris aparells endollats.
- No toquis endolls ni interruptors amb les mans mullades.
- No sobrecarreguis els endolls amb lladres i allargadors encadenats.
- Desendolla tirant de l'endoll, no del cable.
- Les piles i bateries també poden ser perilloses si es curtcircuiten: s'escalfen i les de liti poden incendiar-se. No les guardis soltes amb objectes metàl·lics.

Les instal·lacions dels habitatges tenen un **quadre de protecció** amb un **interruptor diferencial** (talla el corrent si detecta una fuita cap a terra, per exemple a través d'una persona) i **interruptors magnetotèrmics** (tallen si hi ha sobrecàrrega o curtcircuit).

## 0.8. Reptes

!!! example "Repte 0.1. Comprovar la llei d'Ohm"
    Al taller o amb un simulador de circuits (per exemple, el de Tinkercad), munta una resistència de valor conegut amb una font de tensió variable. Mesura la intensitat per a 5 tensions diferents, fes la gràfica I-V en un full de càlcul i comprova que és una recta. Calcula la resistència a partir del pendent i compara-la amb el valor nominal.

!!! example "Repte 0.2. El consum de casa"
    Fes una llista de 8 aparells de casa amb la seva potència (és a l'etiqueta) i estima quantes hores al dia funciona cada un. Calcula l'energia mensual en kWh de cada aparell i el total. Quin aparell consumeix més? Coincideix amb el que esperaves? Proposa dues mesures d'estalvi i calcula quanta energia estalviarien.

---

!!! quote "Font"
    Unitat de creació pròpia. L'Aula de Martín té una unitat equivalent («UD0. Conceptos básicos de electricidad»), però el seu contingut és en una presentació i un PDF de Google Drive que no s'han pogut consultar en preparar aquesta versió. Esquemes elaborats amb [Schemdraw](https://schemdraw.readthedocs.io/).
