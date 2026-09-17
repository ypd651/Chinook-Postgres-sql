🎵 Taller de Consultas y Optimización - Base de Datos Chinook
📋 Información General
Campo
Detalle
Nombre
Yeison Pallares Duque
Grupo
D2
Fecha
15/09/2026
Base de datos
Chinook (PostgreSQL)
Herramienta
pgAdmin 4
📖 Descripción del Proyecto
Este taller tiene como objetivo practicar y dominar consultas SQL en PostgreSQL utilizando la base de datos Chinook, una base de datos de ejemplo que simula una tienda de música digital (similar a iTunes). Se abordan desde consultas básicas de filtrado y ordenamiento hasta consultas avanzadas con JOIN, funciones de agregación, y técnicas de optimización mediante índices.
🗄️ Sobre la Base de Datos Chinook
Chinook modela una tienda de música digital con las siguientes tablas principales:
Tabla
Descripción
Artist
Artistas musicales
Album
Álbumes asociados a artistas
Track
Canciones individuales con precio, duración y género
Genre
Géneros musicales
MediaType
Tipos de archivo (MP3, AAC, etc.)
Customer
Clientes de la tienda
Invoice
Facturas de compra
InvoiceLine
Detalle de cada factura (canciones compradas)
Employee
Empleados de la tienda
Playlist / PlaylistTrack
Listas de reproducción
🔗 Relaciones principales
12345
📁 Estructura del Proyecto
1234
🛠️ Requisitos
PostgreSQL 12 o superior
pgAdmin 4 (u otro cliente SQL como DBeaver)
Script de carga de la base de datos Chinook (chinook_schema_data.sql)
🚀 Cómo Ejecutar
Crear la base de datos:
sql
1
Cargar el esquema y los datos:
Abrir pgAdmin 4
Conectarse a la base de datos chinook
Ejecutar el script chinook_schema_data.sql
Ejecutar las consultas del taller:
Abrir el archivo taller_consultas_chinook.sql
Ejecutar las consultas por etapas o de forma individual
⚠️ Nota importante: Los nombres de tablas y columnas fueron creados con mayúsculas iniciales (ej. "Track", "TrackId"), por lo que siempre deben usarse comillas dobles en las consultas.
📝 Contenido por Etapas
Etapa 1: Reconocimiento de la Base de Datos
Exploración inicial de las tablas principales para entender su estructura.
Ejercicio
Descripción
1
Explorar tablas con SELECT * ... LIMIT 10
2
Contar registros con COUNT(*)
3
Responder preguntas teóricas sobre la estructura
Etapa 2: Consultas Básicas
Práctica de filtros, búsqueda de texto, funciones de agregación y agrupación.
Ejercicio
Conceptos clave
1
WHERE, ORDER BY DESC
2
IN, concatenación con ||
3
ILIKE (búsqueda insensible a mayúsculas)
4
COUNT, AVG, MIN, MAX
5
GROUP BY, ORDER BY
6
HAVING (filtro sobre grupos)
Etapa 3: Consultas con JOIN
Unión de múltiples tablas para obtener información relacionada.
Ejercicio
Tablas involucradas
7
Artist ↔ Album
8
Track ↔ Album ↔ Artist (con cálculo de minutos)
9
Invoice ↔ Customer
10
Customer ↔ Invoice ↔ InvoiceLine ↔ Track
11
Agrupación de ventas por país
12
Top 5 artistas por ventas (LIMIT)
Etapa 4: Análisis y Optimización
Uso de EXPLAIN ANALYZE e índices para mejorar el rendimiento.
Ejercicio
Descripción
13
Plan de ejecución inicial (sin índice)
14
Crear índice simple en Composer y comparar
15
Crear índice compuesto en (GenreId, UnitPrice) y comparar
16
Comparar SELECT * vs columnas específicas
Etapa 5: Reto Final
Consulta compleja que integra todo lo aprendido.
Ejercicio
Descripción
17
Reporte de géneros con JOIN, GROUP BY, HAVING, ORDER BY, LIMIT
18
Análisis del plan de ejecución del reto final
📊 Resultados de Optimización
Índice simple (Composer)
Métrica
Antes
Después
Tipo de recorrido
Seq Scan
Index Scan / Bitmap Index Scan
Costo estimado
Alto
Bajo
Tiempo de ejecución
Mayor
Menor
Índice compuesto (GenreId, UnitPrice)
Métrica
Antes
Después
Tipo de recorrido
Seq Scan
Index Scan
Costo estimado
Alto
Bajo
Tiempo de ejecución
Mayor
Menor
Conclusiones clave
Los índices reducen significativamente el costo y tiempo de ejecución en consultas con filtros específicos.
El orden de las columnas en un índice compuesto importa: primero las columnas de igualdad, luego las de rango.
Un índice compuesto en (GenreId, UnitPrice) sirve para filtrar solo por GenreId, pero no para filtrar solo por UnitPrice.
Seleccionar columnas específicas en vez de SELECT * reduce el uso de memoria, ancho de banda y puede habilitar "Index Only Scan".
🧹 Limpieza (Opcional)
Para eliminar los índices creados durante la Etapa 4:
sql
12
📚 Referencias
Documentación oficial de PostgreSQL
Chinook Database - GitHub
EXPLAIN ANALYZE - PostgreSQL Wiki
Proyecto desarrollado como parte del taller de Bases de Datos - Grupo D2 - Septiembre 2026
