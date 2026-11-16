# Web de docència (MkDocs Material → GitHub Pages)

Regles de treball per a qualsevol sessió que modifiqui aquest repositori.

## Límits tècnics (allotjament gratuït a GitHub Pages)

- La web és **estàtica**. No s'hi pot afegir res que necessiti servidor: PHP, bases de dades, inici de sessió, formularis que guardin respostes ni frameworks amb renderitzat al servidor.
- Es manté **MkDocs Material**. L'estètica es canvia a `docs/stylesheets/extra.css`, `mkdocs.yml` i `overrides/`. No es canvia de plataforma.
- **Pes**: cap vídeo al repositori (s'incrusten des de YouTube amb `youtube-nocookie.com`); imatges de menys de 300 KB, preferiblement SVG o WebP. Límit de GitHub Pages: 1 GB de web publicada.
- Sense ús comercial.

## Abans de publicar

- `mkdocs build --strict` sense avisos.
- Comprovar el desplegament de GitHub Actions i mirar la pàgina en mode clar, fosc i mòbil.
- Un commit per canvi coherent, per poder-lo desfer per separat.

## Estil visual

- Cada matèria té un color (variables `--mat…` a `extra.css`), que s'aplica segons la primera carpeta de l'URL (`overrides/main.html`).
- Els índexs de matèria fan servir `<div class="grid cards unitats" markdown>`: icona i etiqueta, títol amb enllaç i una línia de descripció.
- Les il·lustracions pròpies són SVG amb fons clar propi (`#f8fafc`), text alternatiu i peu de figura (`<figure markdown="span">`). No s'hi reutilitzen imatges de tercers.

## Contingut

- Català amb formes balears. Exercicis al final de cada apartat amb la solució a `??? success`.
- No s'inventen dades ni referències; el codi de les solucions s'executa abans de publicar-lo.
- Cada pàgina acaba amb el requadre de fonts i llicències.
