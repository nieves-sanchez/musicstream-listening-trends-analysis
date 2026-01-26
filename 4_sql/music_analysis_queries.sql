/* =========================================================
   RESONANCE ANALYTICS · 10 CONSULTAS FINALES (MySQL 8+)
   Tablas:
   - genre   (id_genre, name_genre)
   - tracks  (id_track, name_track, artist_name_raw, artist_name_norm,
              name_album, type_info, release_year, duration_ms, popularity, id_genre)
   - artists (artist_name_raw, artist_name_norm, listeners, playcount, id_genre)
   Periodos:
   - 2019           -> 'pre-pandemia'
   - 2020 / 2021    -> 'pandemia'
   - 2022 / 2023    -> 'post-pandemia'
   ========================================================= */


/* ---------------------------------------------------------
   1) Número de ÁLBUMES lanzados por género y periodo
   --------------------------------------------------------- */
WITH base AS (
    SELECT
        g.name_genre AS genero,
        CASE
            WHEN t.release_year = 2019 THEN 'pre-pandemia'
            WHEN t.release_year IN (2020, 2021) THEN 'pandemia'
            WHEN t.release_year IN (2022, 2023) THEN 'post-pandemia'
            ELSE NULL
        END AS periodo,
        t.name_album
    FROM tracks t
    JOIN genre g
        ON g.id_genre = t.id_genre
    WHERE t.release_year BETWEEN 2019 AND 2023
      AND t.name_album IS NOT NULL
      AND TRIM(t.name_album) <> ''
)
SELECT
    genero,
    periodo,
    COUNT(DISTINCT name_album) AS num_albums
FROM base
WHERE periodo IS NOT NULL
GROUP BY genero, periodo
ORDER BY genero, periodo;


/* ---------------------------------------------------------
   2) Duración media de las CANCIONES por género y periodo
   (en milisegundos y en minutos para interpretarlo fácil)
   --------------------------------------------------------- */
WITH base AS (
    SELECT
        g.name_genre AS genero,
        CASE
            WHEN t.release_year = 2019 THEN 'pre-pandemia'
            WHEN t.release_year IN (2020, 2021) THEN 'pandemia'
            WHEN t.release_year IN (2022, 2023) THEN 'post-pandemia'
            ELSE NULL
        END AS periodo,
        t.duration_ms
    FROM tracks t
    JOIN genre g
        ON g.id_genre = t.id_genre
    WHERE t.type_info = 'track'
      AND t.duration_ms IS NOT NULL
)
SELECT
    genero,
    periodo,
    ROUND(AVG(duration_ms), 0) AS duracion_media_ms,
    ROUND(AVG(duration_ms) / 60000, 2) AS duracion_media_min
FROM base
WHERE periodo IS NOT NULL
GROUP BY genero, periodo
ORDER BY genero, periodo;


/* -------------------------------------------------------------------
   3) Top 10 canciones más populares por género y periodo (se excluye CHILL de este análisis
   pues Spotify devuelve popularidad = 0 para este género)
   + ¿Alguna se repite entre periodos? (solo dentro de los Top 10)
   ------------------------------------------------------------------- */

/* 3A) TOP 10 por género y periodo (excluyendo Chill) */
WITH base AS (
    SELECT
        g.name_genre AS genero,
        CASE
            WHEN t.release_year = 2019 THEN 'pre-pandemia'
            WHEN t.release_year IN (2020, 2021) THEN 'pandemia'
            WHEN t.release_year IN (2022, 2023) THEN 'post-pandemia'
            ELSE NULL
        END AS periodo,
        t.name_track,
        t.artist_name_norm,
        t.popularity,
        t.release_year
    FROM tracks t
    JOIN genre g
        ON g.id_genre = t.id_genre
    WHERE t.type_info = 'track'
      AND LOWER(g.name_genre) <> 'chill'
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY genero, periodo
            ORDER BY popularity DESC, name_track ASC
        ) AS rn
    FROM base
    WHERE periodo IS NOT NULL
)
SELECT
    genero,
    periodo,
    rn AS posicion,
    name_track,
    artist_name_norm,
    popularity,
    release_year
FROM ranked
WHERE rn <= 10
ORDER BY genero, periodo, posicion;

/* 3B) Repetidas entre periodos (mirando SOLO las que están en el Top 10) */
WITH base AS (
    SELECT
        g.name_genre AS genero,
        CASE
            WHEN t.release_year = 2019 THEN 'pre-pandemia'
            WHEN t.release_year IN (2020, 2021) THEN 'pandemia'
            WHEN t.release_year IN (2022, 2023) THEN 'post-pandemia'
            ELSE NULL
        END AS periodo,
        t.name_track,
        t.artist_name_norm,
        t.popularity
    FROM tracks t
    JOIN genre g
        ON g.id_genre = t.id_genre
    WHERE t.type_info = 'track'
      AND LOWER(g.name_genre) <> 'chill'
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY genero, periodo
            ORDER BY popularity DESC, name_track ASC
        ) AS rn
    FROM base
    WHERE periodo IS NOT NULL
),
top10 AS (
    SELECT *
    FROM ranked
    WHERE rn <= 10
)
SELECT
    name_track,
    artist_name_norm,
    COUNT(DISTINCT periodo) AS num_periodos,
    GROUP_CONCAT(DISTINCT periodo ORDER BY periodo SEPARATOR ' | ') AS periodos,
    GROUP_CONCAT(DISTINCT genero  ORDER BY genero  SEPARATOR ' | ') AS generos
FROM top10
GROUP BY name_track, artist_name_norm
HAVING COUNT(DISTINCT periodo) > 1
ORDER BY num_periodos DESC, name_track ASC;

/* Resultado observado en nuestro dataset: no se repiten canciones entre periodos dentro del Top 10.*/

/* ---------------------------------------------------------
   4) Evolución de la popularidad por AÑO y GÉNERO
   (se excluye CHILL de este análisis pues Spotify devuelve 
    popularidad = 0 para este género) + periodo calculado
   --------------------------------------------------------- */
WITH base AS (
    SELECT
        g.name_genre AS genero,
        t.release_year AS anio,
        CASE
            WHEN t.release_year = 2019 THEN 'pre-pandemia'
            WHEN t.release_year IN (2020, 2021) THEN 'pandemia'
            WHEN t.release_year IN (2022, 2023) THEN 'post-pandemia'
            ELSE NULL
        END AS periodo,
        t.popularity
    FROM tracks t
    JOIN genre g
        ON g.id_genre = t.id_genre
    WHERE t.type_info = 'track'
      AND LOWER(g.name_genre) <> 'chill'
      AND t.release_year BETWEEN 2019 AND 2023
      AND t.popularity IS NOT NULL
)
SELECT
    genero,
    periodo,
    anio,
    ROUND(AVG(popularity), 2) AS popularidad_media
FROM base
WHERE periodo IS NOT NULL
GROUP BY genero, periodo, anio
ORDER BY genero, anio;


/* ---------------------------------------------------------
   5) Número de CANCIONES lanzadas por género y periodo
   --------------------------------------------------------- */
WITH base AS (
    SELECT
        g.name_genre AS genero,
        CASE
            WHEN t.release_year = 2019 THEN 'pre-pandemia'
            WHEN t.release_year IN (2020, 2021) THEN 'pandemia'
            WHEN t.release_year IN (2022, 2023) THEN 'post-pandemia'
            ELSE NULL
        END AS periodo,
        t.id_track
    FROM tracks t
    JOIN genre g
        ON g.id_genre = t.id_genre
    WHERE t.type_info = 'track'
)
SELECT
    genero,
    periodo,
    COUNT(*) AS num_canciones
FROM base
WHERE periodo IS NOT NULL
GROUP BY genero, periodo
ORDER BY genero, periodo;


/* ---------------------------------------------------------
   6) En nuestra muestra, ¿cuál fue la canción más popular
      en la PANDEMIA? (2020-2021)
   - Si hay empates, devuelve todas.
   --------------------------------------------------------- */
WITH pandemia AS (
    SELECT
        t.name_track,
        t.artist_name_norm,
        g.name_genre AS genero,
        t.release_year,
        t.popularity
    FROM tracks t
    JOIN genre g
        ON g.id_genre = t.id_genre
    WHERE t.type_info = 'track'
      AND t.release_year IN (2020, 2021)
      AND t.popularity IS NOT NULL
),
max_pop AS (
    SELECT MAX(popularity) AS max_popularity
    FROM pandemia
)
SELECT
    p.name_track,
    p.artist_name_norm,
    p.genero,
    p.release_year,
    p.popularity
FROM pandemia p
JOIN max_pop m
    ON p.popularity = m.max_popularity
ORDER BY p.name_track ASC;


/* ---------------------------------------------------------
   7) Su artista (el de la #6), ¿cuántas canciones tiene en
      PANDEMIA y qué posición ocupa vs otros artistas?
   - Si en #6 hay empate de canciones/artistas, sale para todos.
   --------------------------------------------------------- */
WITH pandemia_tracks AS (
    SELECT
        t.artist_name_norm,
        t.name_track,
        t.popularity
    FROM tracks t
    WHERE t.type_info = 'track'
      AND t.release_year IN (2020, 2021)
),
top_song AS (
    SELECT MAX(popularity) AS max_popularity
    FROM pandemia_tracks
),
artistas_top AS (
    SELECT DISTINCT
        pt.artist_name_norm
    FROM pandemia_tracks pt
    JOIN top_song ts
        ON pt.popularity = ts.max_popularity
),
conteos AS (
    SELECT
        artist_name_norm,
        COUNT(*) AS num_canciones_pandemia
    FROM pandemia_tracks
    GROUP BY artist_name_norm
),
ranking AS (
    SELECT
        c.*,
        DENSE_RANK() OVER (ORDER BY c.num_canciones_pandemia DESC) AS posicion_por_num_canciones
    FROM conteos c
)
SELECT
    r.artist_name_norm,
    r.num_canciones_pandemia,
    r.posicion_por_num_canciones
FROM ranking r
JOIN artistas_top a
    ON a.artist_name_norm = r.artist_name_norm
ORDER BY r.posicion_por_num_canciones, r.artist_name_norm;

/* ---------------------------------------------------------
   8) Chill en pandemia lidera lanzamientos:
      ¿Cuáles son sus artistas con MÁS oyentes (listeners)?
   (se usa la tabla artists)
   --------------------------------------------------------- */
 SELECT 
    a.artist_name_raw as artista,
    FORMAT(a.listeners, 0) as oyentes,
    FORMAT(a.playcount, 0) as reproducciones,
    COUNT(DISTINCT t.name_track) as total_canciones,
    COUNT(DISTINCT t.name_album) as total_albumes
FROM tracks t
JOIN artists a ON t.artist_name_norm = a.artist_name_norm
JOIN genre g ON t.id_genre = g.id_genre
WHERE g.name_genre = 'CHILL'
  AND t.release_year BETWEEN 2019 AND 2023
GROUP BY a.artist_name_raw, a.listeners, a.playcount
ORDER BY a.listeners DESC
LIMIT 10;

/* ---------------------------------------------------------
   9) Variación del género dominante por artista entre periodos.
   GÉNERO DOMINANTE para cada artista y año: el que más se repite por número de tracks 
   CONTROL DE NULOS: solo se comparan artistas con datos en los tres periodos
   --------------------------------------------------------- */
  WITH conteo_por_anio AS (
  SELECT
    t.artist_name_norm AS artista,
    g.name_genre       AS genero,
    t.release_year     AS anio,
    COUNT(*)           AS total,
    ROW_NUMBER() OVER (
      PARTITION BY t.artist_name_norm, t.release_year
      ORDER BY COUNT(*) DESC, g.name_genre
    ) AS rn
  FROM tracks t
  JOIN genre g ON t.id_genre = g.id_genre
  WHERE t.type_info = 'track'
    AND t.release_year BETWEEN 2019 AND 2023
  GROUP BY t.artist_name_norm, g.name_genre, t.release_year
),
pivot AS (
  SELECT
    a.artista,
    MAX(CASE WHEN a.anio = 2019 THEN a.genero END)          AS genero_pre,
    MAX(CASE WHEN a.anio IN (2020, 2021) THEN a.genero END) AS genero_pandemia,
    MAX(CASE WHEN a.anio IN (2022, 2023) THEN a.genero END) AS genero_post
  FROM conteo_por_anio a
  WHERE a.rn = 1
  GROUP BY a.artista
)
SELECT *
FROM pivot
WHERE
  genero_pre IS NOT NULL
  AND genero_pandemia IS NOT NULL
  AND genero_post IS NOT NULL
  AND (
    genero_pre <> genero_pandemia
    OR genero_pandemia <> genero_post
  )
ORDER BY artista;

/* ---------------------------------------------------------
   10) Durante la pandemia, ¿qué artistas se incorporaron a Chill?
   Definición (simple y defendible):
   - Tienen AL MENOS 1 canción en Chill en 2020-2021
   - Y NO tenían ninguna canción en Chill en 2019 (pre-pandemia)
   --------------------------------------------------------- */
WITH chill_pandemia AS (
    SELECT DISTINCT
        t.artist_name_norm
    FROM tracks t
    JOIN genre g ON g.id_genre = t.id_genre
    WHERE t.type_info = 'track'
      AND LOWER(g.name_genre) = 'chill'
      AND t.release_year IN (2020, 2021)
),
chill_pre AS (
    SELECT DISTINCT
        t.artist_name_norm
    FROM tracks t
    JOIN genre g ON g.id_genre = t.id_genre
    WHERE t.type_info = 'track'
      AND LOWER(g.name_genre) = 'chill'
      AND t.release_year = 2019
)
SELECT
    cp.artist_name_norm
FROM chill_pandemia cp
LEFT JOIN chill_pre cpre
    ON cpre.artist_name_norm = cp.artist_name_norm
WHERE cpre.artist_name_norm IS NULL
ORDER BY cp.artist_name_norm ASC;

SELECT
    LOWER(TRIM(name_track))       AS track_key,
    LOWER(TRIM(artist_name_norm)) AS artist_key,
    COUNT(DISTINCT release_year)  AS num_anios
FROM tracks
WHERE type_info = 'track'
  AND release_year BETWEEN 2019 AND 2023
GROUP BY track_key, artist_key
HAVING COUNT(DISTINCT release_year) > 1
ORDER BY num_anios DESC;