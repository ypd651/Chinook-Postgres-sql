-- Nombre: Yeison Pallares Duque
-- Grupo: D2
-- Fecha: 15/09/2026

-- =============================
-- ETAPA 1: Reconocimiento
-- =============================

-- 1. Explorar las tablas principales
SELECT *
FROM public."Artist"
LIMIT 10;

SELECT *
FROM public."Album"}
LIMIT 10;

SELECT *
FROM public."Track"
LIMIT 10;

SELECT *
FROM public."Customer"
LIMIT 10;

SELECT *
FROM public."Invoice"
LIMIT 10;

SELECT *
FROM public."InvoiceLine"
LIMIT 10;

-- 2. Contar registros de las tablas clave
SELECT
COUNT(*) AS cantidad_artistas 
FROM public."Artist";

SELECT 
COUNT(*) AS cantidad_albumes 
FROM public."Album";

SELECT 
COUNT(*) AS cantidad_tracks 
FROM public."Track";

SELECT 
COUNT(*) AS cantidad_clientes 
FROM public."Customer";

SELECT 
COUNT(*) AS cantidad_facturas 
FROM public."Invoice";

SELECT 
COUNT(*) AS cantidad_detalles 
FROM public."InvoiceLine";

-- 3. Preguntas de reconocimiento
-- 1. La tabla con más registros es Track (las canciones).
-- 2. La columna que relaciona Album con Artist es ArtistId.
-- 3. Las tablas que permiten conocer las canciones compradas en una factura son InvoiceLine y Track, también Invoice para saber el cliente.
-- 4. La diferencia es que Invoice es la factura en general con el total y la fecha, mientras que InvoiceLine es el detalle de cada canción que se compró en esa factura.


-- ========================================
-- ETAPA 2: Consultas básicas
-- ========================================

-- Ejercicio 1: Canciones con precio >= 1.00 ordenadas de mayor a menor
SELECT
    "TrackId" AS identificador,
    "Name" AS nombre,
    "UnitPrice" AS precio
FROM public."Track"
WHERE "UnitPrice" >= 1.00
ORDER BY "UnitPrice" DESC;

-- Ejercicio 2: Clientes de Brasil, Canadá o USA
SELECT
    "FirstName" || ' ' || "LastName" AS nombre_completo,
    "Country" AS pais,
    "City" AS ciudad,
    "Email" AS correo_electronico
FROM public."Customer"
WHERE "Country" IN ('Brazil', 'Canada', 'USA')
ORDER BY "Country", "FirstName", "LastName";

-- Ejercicio 3: Canciones que contienen "Love"
SELECT
    "TrackId" AS identificador,
    "Name" AS titulo
FROM public."Track"
WHERE "Name" ILIKE '%love%'
ORDER BY "Name";

-- Ejercicio 4: Funciones de agregación sobre canciones
SELECT
    COUNT(*) AS total_canciones,
    AVG("UnitPrice") AS precio_promedio,
    MIN("UnitPrice") AS precio_minimo,
    MAX("UnitPrice") AS precio_maximo,
    AVG("Milliseconds") AS duracion_promedio_ms
FROM public."Track";

-- Ejercicio 5: Cantidad de clientes por país
SELECT
    "Country" AS pais,
    COUNT("CustomerId") AS clientes
FROM public."Customer"
GROUP BY "Country"
ORDER BY clientes DESC;

-- Ejercicio 6: Países con al menos 2 clientes (CORREGIDO: >= 2)
SELECT
    "Country" AS pais,
    COUNT("CustomerId") AS clientes
FROM public."Customer"
GROUP BY "Country"
HAVING COUNT("CustomerId") >= 2
ORDER BY clientes DESC;

-- ========================================
-- ETAPA 3: Consultas con JOIN
-- ========================================

-- Ejercicio 7: Álbumes y artistas
SELECT
    ar."Name" AS artista,
    al."Title" AS album
FROM public."Artist" AS ar
INNER JOIN public."Album" AS al
    ON ar."ArtistId" = al."ArtistId"
ORDER BY ar."Name", al."Title";

-- Ejercicio 8: Canciones, álbumes, artistas con duración en minutos
SELECT
    t."Name" AS cancion,
    al."Title" AS album,
    ar."Name" AS artista,
    t."UnitPrice" AS precio,
    ROUND((t."Milliseconds" / 60000.0)::numeric, 2) AS duracion_minutos
FROM public."Track" t
JOIN public."Album" al ON t."AlbumId" = al."AlbumId"
JOIN public."Artist" ar ON al."ArtistId" = ar."ArtistId";

-- Ejercicio 9: Clientes y facturas
SELECT
    i."InvoiceId" AS numero_factura,
    c."FirstName" || ' ' || c."LastName" AS nombre_cliente,
    c."Country" AS pais,
    i."InvoiceDate" AS fecha,
    i."Total" AS total
FROM public."Invoice" i
INNER JOIN public."Customer" c
    ON i."CustomerId" = c."CustomerId"
ORDER BY i."InvoiceDate" DESC;

-- Ejercicio 10: Detalle completo de ventas
SELECT
    c."FirstName" || ' ' || c."LastName" AS cliente,
    i."InvoiceId" AS numero_factura,
    t."Name" AS cancion,
    il."UnitPrice" AS precio_unitario,
    il."Quantity" AS cantidad,
    (il."UnitPrice" * il."Quantity") AS subtotal
FROM public."Customer" c
INNER JOIN public."Invoice" i ON c."CustomerId" = i."CustomerId"
INNER JOIN public."InvoiceLine" il ON i."InvoiceId" = il."InvoiceId"
INNER JOIN public."Track" t ON il."TrackId" = t."TrackId"
ORDER BY i."InvoiceId";

-- Ejercicio 11: Ventas por país de facturación
SELECT
    "BillingCountry" AS pais,
    COUNT("InvoiceId") AS cantidad_facturas,
    SUM("Total") AS total_vendido
FROM public."Invoice"
GROUP BY "BillingCountry"
ORDER BY total_vendido DESC;

-- Ejercicio 12: Top 5 artistas con mayores ventas
SELECT
    ar."Name" AS artista,
    SUM(il."Quantity") AS unidades_vendidas,
    SUM(il."UnitPrice" * il."Quantity") AS ingresos
FROM public."Artist" ar
JOIN public."Album" al ON ar."ArtistId" = al."ArtistId"
JOIN public."Track" t ON al."AlbumId" = t."AlbumId"
JOIN public."InvoiceLine" il ON t."TrackId" = il."TrackId"
GROUP BY ar."Name"
ORDER BY ingresos DESC
LIMIT 5;

-- ========================================
-- ETAPA 4: Análisis y optimización
-- ========================================

-- Ejercicio 13: Plan inicial ANTES del índice
EXPLAIN ANALYZE
SELECT "TrackId", "Name", "Composer"
FROM public."Track"
WHERE "Composer" = 'Steve Harris';

-- Ejercicio 14: Crear índice simple y analizar
CREATE INDEX idx_track_composer ON public."Track"("Composer");
ANALYZE public."Track";

-- Plan DESPUÉS del índice
EXPLAIN ANALYZE
SELECT "TrackId", "Name", "Composer"
FROM public."Track"
WHERE "Composer" = 'Steve Harris';

-- Ejercicio 15: Índice compuesto
-- Plan ANTES
EXPLAIN ANALYZE
SELECT "TrackId", "Name", "UnitPrice"
FROM public."Track"
WHERE "GenreId" = 1 AND "UnitPrice" = 0.99;

-- Crear índice compuesto
CREATE INDEX idx_track_genre_price ON public."Track"("GenreId", "UnitPrice");
ANALYZE public."Track";

-- Plan DESPUÉS
EXPLAIN ANALYZE
SELECT "TrackId", "Name", "UnitPrice"
FROM public."Track"
WHERE "GenreId" = 1 AND "UnitPrice" = 0.99;

-- Ejercicio 16: Comparar SELECT * vs columnas específicas
-- Versión A
EXPLAIN ANALYZE
SELECT * FROM public."Track" WHERE "Milliseconds" > 300000;

-- Versión B (recomendada)
EXPLAIN ANALYZE
SELECT "TrackId", "Name", "Milliseconds"
FROM public."Track"
WHERE "Milliseconds" > 300000;

-- ========================================
-- ETAPA 5: Reto final
-- ========================================

-- Informe de géneros musicales (Top 5 con más de 50 unidades vendidas)
SELECT
    g."Name" AS genero,
    COUNT(DISTINCT t."TrackId") AS canciones_diferentes,
    SUM(il."Quantity") AS unidades_totales,
    SUM(il."UnitPrice" * il."Quantity") AS ingresos,
    ROUND(AVG(il."UnitPrice")::numeric, 2) AS precio_promedio
FROM public."Genre" g
INNER JOIN public."Track" t ON g."GenreId" = t."GenreId"
INNER JOIN public."InvoiceLine" il ON t."TrackId" = il."TrackId"
GROUP BY g."Name"
HAVING SUM(il."Quantity") > 50
ORDER BY ingresos DESC
LIMIT 5;

-- Análisis del plan del reto final
EXPLAIN ANALYZE
SELECT
    g."Name" AS genero,
    COUNT(DISTINCT t."TrackId") AS canciones_diferentes,
    SUM(il."Quantity") AS unidades_totales,
    SUM(il."UnitPrice" * il."Quantity") AS ingresos,
    ROUND(AVG(il."UnitPrice")::numeric, 2) AS precio_promedio
FROM public."Genre" g
INNER JOIN public."Track" t ON g."GenreId" = t."GenreId"
INNER JOIN public."InvoiceLine" il ON t."TrackId" = il."TrackId"
GROUP BY g."Name"
HAVING SUM(il."Quantity") > 50
ORDER BY ingresos DESC
LIMIT 5;

-- ========================================
-- Limpieza (opcional): eliminar índices creados
-- =======================================

DROP INDEX IF EXISTS public.idx_track_composer;
DROP INDEX IF EXISTS public.idx_track_genre_price;" >= 1.00
ORDER BY "UnitPrice" DESC;