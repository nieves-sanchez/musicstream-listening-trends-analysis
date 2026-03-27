#  MusicStream — Análisis de tendencias musicales (2019–2023) 📊🎶

Proyecto de análisis de datos centrado en la evolución del consumo musical en España antes, durante y después de la pandemia (2019–2023).

El objetivo es identificar cambios en la popularidad de artistas, géneros y canciones combinando datos extraídos mediante APIs públicas y estructurados en una base de datos relacional.

---

**📌 Mi contribución en este proyecto**  
Me encargué de la extracción y limpieza de datos desde la API de Last.fm, el diseño de la base de datos relacional en MySQL, el EDA en SQL para validar la carga en Workbench, y la mitad de las consultas analíticas finales.

---

## 🎯 Objetivo del proyecto

Analizar si la pandemia de la COVID-19 ha tenido un impacto en las tendencias de
consumo musical, identificando variaciones en la popularidad de artistas,
géneros y canciones a lo largo de tres periodos temporales:
- Pre-pandemia (2019)
- Pandemia (2020–2021)
- Post-pandemia (2022–2023)

---

## 🎧 Fuentes de datos y extracción

Los datos utilizados en el proyecto se obtienen a través de APIs públicas de
plataformas musicales:

- **Spotify API**: extracción de información a nivel de canción, incluyendo
  artista, género, tipo de contenido (canción o álbum), año de lanzamiento,
  duración y métricas de popularidad.
- **Last.fm API**: obtención de métricas agregadas a nivel de artista, como
  número de oyentes y número de reproducciones.

La extracción se realizó mediante un muestreo aproximado de **200 canciones por
año y género**, abarcando el periodo 2019–2023, con el fin de garantizar un
volumen de datos suficiente y equilibrado para el análisis comparativo.

---

## 🗄️ Modelo de datos

Los datos se almacenan en una base de datos relacional implementada en **MySQL**.
El modelo incluye tablas principales para artistas, canciones y géneros.

El diagrama entidad-relación del modelo puede consultarse aquí:

📎 `1_documentation/resonance_analytics_diagram.svg`

---

## 🔎 Análisis exploratorio de datos (EDA)

Antes del desarrollo de las consultas SQL finales, se realizó un análisis
exploratorio de la base de datos con el objetivo de comprender la estructura,
volumen y distribución de los datos, así como detectar valores nulos,
duplicados y posibles inconsistencias.

Este análisis preliminar permitió definir los filtros aplicados en las
consultas, los periodos temporales de estudio y las limitaciones consideradas
en el análisis posterior.

---

## 📊 Consultas SQL

El directorio `4_sql/` contiene las consultas SQL desarrolladas durante el
proyecto. En particular, el archivo:

- `music_analysis_queries.sql`

recoge las **diez consultas finales**, diseñadas para responder a las preguntas
de investigación planteadas. Estas consultas son ejecutables directamente en
**MySQL Workbench** y abarcan análisis comparativos por género, artista y
periodo temporal.

---

## 📁 Estructura del repositorio

```text
├── 1_documentation/        # Documentación y diagramas
├── 2_notebooks/            # Notebooks de análisis y visualización
├── 3_data/
│   ├── raw/                # Datos originales extraídos de las APIs
│   └── processed/          # Datos limpios y finales
├── 4_sql/                  # Consultas SQL
├── 5_database/             # Scripts de creación de la base de datos
└── README.md
```

## ⚠️ Limitaciones del estudio

### Género Chill:

Durante la extracción de datos mediante la API de Spotify se observó que las
canciones asociadas al género Chill no disponen de métricas de popularidad,
mostrando valores iguales a cero. Debido a esta limitación, dicho género no se
incluye en los análisis comparativos basados en popularidad entre géneros.

No obstante, se decidió mantener el género Chill dentro del proyecto debido a
su relevancia contextual, ya que fue un género especialmente representativo
durante el periodo de la pandemia, lo que permite preservar la coherencia
temática del estudio.

### Uso de metadatos básicos de Spotify:

El análisis se basa exclusivamente en metadatos básicos proporcionados por la
API de Spotify. No se han utilizado audio features (como energía, tempo,
danceability o valence), lo que limita la posibilidad de realizar análisis
musicales más avanzados basados en características sonoras.

Como consecuencia, el enfoque del proyecto se centra en el consumo y la
popularidad musical, y no en el análisis técnico del contenido sonoro.

## 🧪 Nota metodológica: variación del género dominante por artista

Para estudiar la evolución estilística de los artistas entre 2019 y 2023, se
identificó el género dominante por artista y periodo, definido como aquel género
con mayor número de canciones publicadas en cada intervalo temporal.

Los periodos analizados fueron: pre-pandemia (2019), pandemia (2020–2021) y
post-pandemia (2022–2023). El análisis se limita a aquellos artistas con
presencia en los tres periodos, con el fin de evitar comparaciones incompletas o
sesgadas por falta de datos.

Los resultados obtenidos no se interpretan como un cambio absoluto en la
identidad musical de los artistas, sino como variaciones en el peso relativo de
los géneros predominantes a lo largo del tiempo.


## 🔁 Reproducibilidad

El flujo de trabajo del proyecto sigue un orden lógico:

Extracción y limpieza de datos

Almacenamiento en base de datos MySQL

Ejecución de consultas SQL

Análisis y visualización en notebooks

Este enfoque permite reproducir los resultados y facilitar la comprensión del
proceso analítico completo.


## 📽️ Presentación del proyecto

La presentación final del proyecto puede consultarse en el siguiente enlace:

📄 [Ver presentación (PDF)](1_documentation/presentation_resonance_analytics.pdf)


## 👥 Autoría

Proyecto realizado por:
- Valentina Castillo
- Ana María Castro
- María José Moral
- Nieves Sánchez

Repositorio original: https://github.com/Narciandi90/Adalab-proyecto-da-promo-64-modulo-2-team-1
