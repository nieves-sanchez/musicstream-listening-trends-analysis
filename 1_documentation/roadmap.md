🗺️**HOJA DE RUTA RESONANCE ANALYTICS: MEASURING THE SOUND OF SOCIAL CHANGE 📊** 

Este documento describe la hoja de ruta y organización del proyecto académico del equipo Resonance Analytics, centrado en el análisis de tendencias musicales antes, durante y después de la pandemia del COVID-19 en España.

* Proyecto: Resonance Analytics. Measuring the sound of social change.
* Equipo: 4 personas
* Duración: 2 semanas reales
* Sprint Review 1: 14 de enero
* Sprint Review 2: 21 de enero
* Presentación y entrega: 27 de enero

1. OBJETIVO DEL ESTUDIO: 
Analizar si la pandemia del COVID-19 ha tenido algún tipo de impacto en las tendencias de consumo musical, identificando cambios en popularidad de artistas, géneros y canciones antes, durante y después de la pandemia.

* Rango de años: 2019-2023
* Géneros musicales: Rock, Pop, Latin y Chill

2. PLANIFICACIÓN Y ORGANIZACIÓN:

* Organización del equipo y repositorio
* Extracción de datos desde APIs
* Limpieza y validación de datos
* Almacenamiento y diseño de la base de datos
* Consultas SQL y análisis
* Visualización y presentación de resultados


3. FASES DEL PROYECTO:

* Extracción de datos:
  - Mediante el uso del API de Spotify, se  extraen datos como artista, género, tipo (canción, álbum), nombre, año de lanzamiento y duración de sus canciones.
  - A travñes del API de  Last.fm se extrae información relativa a artistas, su número de reproducciones y volumen de oyentes.
   
* Crear base de datos:
  - Guardar la información recopilada en una BBDD 
  - Crear el modelo de negocio de la bases de datos
  - Crear la bases de datos con sus tablas y relaciones. 
  - Insertar datos.

* Consultas y explotación de datos:
  - Realizar 10 consultas orientadas a responder las preguntas de investigación planteadas.
  - Identificar artistas y géneros más populares en la plataforma.

* Análisis de información:
  - Analizar artistas más escuchados en prepandemia, pandemia y postpandemia
  - Analizar número de oyentes en prepandemia, pandemia y postpandemia
  - Analizar canciones más escuchadas en prepandemia, pandemia y postpandemia
  - Otros análisis exploratorios relevantes en función de los datos disponibles.

4. DIVISIÓN DEL TRABAJO:
Esta división es orientativa y puede variar durante el desarrollo del proyecto.
  - Ana y Valentina extraen datos de Spotipy
  - Nieves y Maria José extraen datos de Lastfm

5. ESTRUCTURA AGILE DEL PROYECTO:

Equipo Scrum

* Product Owner (PO): Rocío
    Define visión, prioriza backlog, valida funcionalidades.
* Scrum Master (SM): Ana María
    Facilita dinámica, tiempos, elimina bloqueos, cuida el proceso.
* Dev Team: Valentina, Nieves, Maria José
    Diseño, lógica, extracción de datos, creación bases de datos, extracción información..., 

Daily Scrum (propuesta estándar)

Cada día (5–7 min) (Breve, ágil, sin discusiones técnicas).

1. ¿Qué hice ayer?
2. ¿Qué haré hoy?
3. ¿Qué bloqueos tengo?

Breve, ágil, sin discusiones técnicas largas.

6. ACUERDOS DEL EQUIPO:

* Compromiso
* Comunicación
* Gestión del tiempo

7. ENTORNOS DE TRABAJO:

* Visual Studio Code
* GitHub
* MySQL
* API de lastfm y de Spotify
* IA como herramienta de apoyo para documentación y resolución de dudas.


❗️Definition of Done (DoD):
Un acuerdo del equipo sobre cuándo una tarea se considera realmente terminada.
Por ejemplo:
* Funciona sin errores
* Está integrada en el flujo
* Está testeada
* Tiene una mínima documentación
* Puede mostrarse en una demo
Si falta algo de la DoD, no está terminado, aunque “parezca terminado”.
