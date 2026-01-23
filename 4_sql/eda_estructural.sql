/* ============================================================
   Exploratory Data Analysis (EDA) - Estructural
   Proyecto: Resonance Analytics (2019–2024)
   Objetivo: Validar calidad, estructura y consistencia de datos
   Etapas del estudio:
     - Pre-COVID: 2019
     - COVID: 2020–2021
     - Post-COVID: 2022–2023
   ============================================================ */

USE resonance_analytics;

-- ===================================================
-- 0) REVISIÓN DE ESTRUTURA Y CONTENIDO DE LAS TABLAS
-- ===================================================

/* Tablas del modelo:
   - genre   (id_genre, name_genre)
   - artists (artist_name_raw, artist_name_norm, listeners, playcount, id_genre)
   - tracks  (id_track, name_track, artist_name_raw, artist_name_norm, name_album,
              type_info, release_year, duration_ms, popularity, id_genre)
*/

SELECT id_genre, name_genre
FROM genre
ORDER BY id_genre;

SELECT artist_name_raw, artist_name_norm, listeners, playcount, id_genre
FROM artists
LIMIT 10;

SELECT id_track, name_track, artist_name_norm, name_album, release_year, popularity, id_genre
FROM tracks
LIMIT 10;

-- ============================================================
-- 1) Tamaño de las tablas (filas totales)
-- ============================================================

/*
nombre_tabla  |  total_filas
--------------|--------------
genre		  |       4
artists	      |      1250
tracks	      |      3436

*/

SELECT 'genre' nombre_tabla, COUNT(*) total_filas FROM genre
UNION ALL
SELECT 'artists' nombre_tabla, COUNT(*) total_filas FROM artists
UNION ALL
SELECT 'tracks' nombre_tabla, COUNT(*) total_filas FROM tracks;

-- ============================================================
-- 2) Nulos en variables clave
-- ============================================================
/* Hay cero nulos */

SELECT
  SUM(listeners IS NULL) null_listeners,
  SUM(playcount IS NULL) null_playcount
FROM artists;

SELECT
  SUM(release_year IS NULL) null_release_year,
  SUM(popularity IS NULL) null_popularity
FROM tracks;

-- ============================================================
-- 3) Rango temporal y distribución por año (validación 2019–2023)
-- ============================================================

/*
El dataset cargado cubre el periodo 2019-2023
*/

SELECT
  MIN(release_year) min_year,
  MAX(release_year) max_year
FROM tracks;

/*
2019	736
2020	688
2021	703
2022	668
2023	641
*/

SELECT
  release_year,
  COUNT(*) n_tracks
FROM tracks
GROUP BY release_year
ORDER BY release_year;


-- ============================================================
-- 4) Consistencia de claves (integridad referencial “manual”)
-- ============================================================

/* 4.1) id_genre en artists debe existir en genre */

SELECT DISTINCT a.id_genre
FROM artists a
LEFT JOIN genre g 
ON g.id_genre = a.id_genre
WHERE g.id_genre IS NULL;

/* 4.2) id_genre en tracks debe existir en genre */
SELECT DISTINCT t.id_genre
FROM tracks t
LEFT JOIN genre g ON g.id_genre = t.id_genre
WHERE g.id_genre IS NULL;


-- ==========================
-- 5) Duplicados potenciales
-- ==========================

/* 5.1) id_track debería ser único 
3436	3436	0
*/

SELECT
  COUNT(*) AS n_rows,
  COUNT(DISTINCT id_track) AS n_distinct_id_track,
  (COUNT(*) - COUNT(DISTINCT id_track)) AS possible_duplicates
FROM tracks;

/* 5.2) ¿Hay artistas duplicados por nombre normalizado? 
1250	1174	76
*/

SELECT
  COUNT(*) AS n_rows,
  COUNT(DISTINCT artist_name_norm) AS n_distinct_artist_norm,
  (COUNT(*) - COUNT(DISTINCT artist_name_norm)) AS possible_duplicates
FROM artists;


-- ============================================================
-- 6) Distribución por género (artistas y canciones)
-- ============================================================

/* 6.1) Número de artistas por género 
1	POP		350
2	ROCK	469
3	CHILL	166
4	LATIN	265
*/

SELECT
  a.id_genre,
  g.name_genre,
  COUNT(DISTINCT a.artist_name_norm) AS n_artists
FROM artists a
JOIN genre g ON g.id_genre = a.id_genre
GROUP BY a.id_genre, g.name_genre
ORDER BY a.id_genre;

/* 6.2) Número de canciones por género (CORREGIDO: se cuentan tracks)
1	POP		907
2	ROCK	934
3	CHILL	664
4	LATIN	931
 */
 
SELECT
  t.id_genre,
  g.name_genre,
  COUNT(DISTINCT t.id_track) AS n_tracks
FROM tracks t
JOIN genre g ON g.id_genre = t.id_genre
GROUP BY t.id_genre, g.name_genre
ORDER BY t.id_genre;


-- ============================================================
-- 7) Top artistas (listeners y playcount)
-- ============================================================

/* Top 10 por listeners 
coldplay	8939954
radiohead	8064930
lady gaga	7548754
nirvana	7387096
red hot chili peppers	7118516
queen	7098803
katy perry	6974662
arctic monkeys	6939434
the killers	6809565
linkin park	6782765
*/

SELECT
  artist_name_norm,
  listeners
FROM artists
ORDER BY listeners DESC
LIMIT 10;

/* Top 10 por playcount 
taylor swift	3541186078
bts	2719588783
lana del rey	1508836375
radiohead	1318326687
the weeknd	1068720339
the beatles	1068361552
ariana grande	1049297130
lady gaga	991482146
kendrick lamar	989439307
arctic monkeys	902266821
*/

SELECT
  artist_name_norm,
  playcount
FROM artists
ORDER BY playcount DESC
LIMIT 10;


-- ============================================================
-- 8) Métricas descriptivas por género (artists y tracks)
-- ============================================================

/* Promedio de listeners por género 
1	POP	1084763
2	ROCK	1090702
3	CHILL	34733
4	LATIN	330608
*/

SELECT
  a.id_genre,
  g.name_genre,
  ROUND(AVG(a.listeners)) AS avg_listeners
FROM artists a
JOIN genre g ON g.id_genre = a.id_genre
GROUP BY a.id_genre, g.name_genre
ORDER BY a.id_genre;

/* Promedio de popularidad por género (tracks) 
1	POP	65.99
2	ROCK	55.70
3	CHILL	0.00
4	LATIN	66.75
*/

SELECT
  t.id_genre,
  g.name_genre,
  ROUND(AVG(t.popularity), 2) AS avg_popularity
FROM tracks t
JOIN genre g ON g.id_genre = t.id_genre
GROUP BY t.id_genre, g.name_genre
ORDER BY t.id_genre;


-- ============================================================
-- 9) Calidad/valores extremos (ceros y outliers básicos)
-- ============================================================

/* Artistas con listeners o playcount en 0
Todo nulo
 */

SELECT *
FROM artists
WHERE listeners = 0 OR playcount = 0
ORDER BY listeners ASC, playcount ASC;

/* Canciones con popularity en 0 (si existieran) 
Salen 664 filas
*/
SELECT id_track, name_track, artist_name_norm, release_year, popularity
FROM tracks
WHERE popularity = 0
ORDER BY release_year, popularity;

/* Duraciones sospechosas (muy cortas / muy largas) 
13090	817832	220148
*/

SELECT
  MIN(duration_ms) AS min_duration_ms,
  MAX(duration_ms) AS max_duration_ms,
  ROUND(AVG(duration_ms)) AS avg_duration_ms
FROM tracks;


-- ============================================================
-- 10) Limitaciones del dataset y decisiones metodológicas
-- ============================================================

/*
LIMITACIONES DETECTADAS DURANTE EL EDA:

1) Métrica de popularidad en Spotify:
   - El género CHILL no dispone de métricas de popularidad a nivel de canción
     (popularity = 0 en el 100% de los registros).
   - Esto impide realizar análisis temporales de popularidad para este género.

2) Métricas de Last.fm:
   - listeners y playcount son métricas acumuladas históricas por artista.
   - No están segmentadas por año y no permiten análisis de evolución temporal.

3) Cobertura temporal:
   - El dataset incluye datos entre 2019 y 2023.

DECISIONES METODOLÓGICAS:

- Los análisis de popularidad y rankings temporales se realizarán únicamente
  para los géneros que disponen de métricas de popularidad válidas en Spotify.
- El género CHILL se mantiene en el estudio y se analiza mediante métricas
  alternativas disponibles, como duración de las canciones y volumen de
  lanzamientos por año.
- No se mezclarán métricas incompatibles en una misma comparación.
*/
