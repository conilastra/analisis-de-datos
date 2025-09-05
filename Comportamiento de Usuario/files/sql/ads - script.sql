-- Tipos de Eventos Más Comunes
SELECT 
    event_type as tipo_evento,
    COUNT(*) as frecuencia,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as porcentaje
FROM ad_events
GROUP BY event_type
ORDER BY frecuencia DESC;


-- Distribución Demográfica de Usuarios
SELECT 
    age_group as grupo_edad,
    user_gender as genero,
    COUNT(*) as cantidad_usuarios,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 1) as porcentaje
FROM users
GROUP BY age_group, user_gender
ORDER BY cantidad_usuarios DESC;


-- Países con Más Actividad
SELECT 
    u.country as pais,
    COUNT(DISTINCT u.user_id) as usuarios,
    COUNT(ae.event_id) as interacciones,
    -- Porcentaje del total de interacciones
    ROUND(COUNT(ae.event_id) * 100.0 / SUM(COUNT(ae.event_id)) OVER(), 1) as porcentaje_interacciones
FROM users u
LEFT JOIN ad_events ae ON u.user_id = ae.user_id
WHERE ae.event_id IS NOT NULL
GROUP BY u.country
ORDER BY interacciones DESC;

-- Top 10 Lugares con Más Compras
SELECT
    u.country,
    SUM(CASE WHEN ae.event_type = 'purchase' THEN 1 ELSE 0 END) AS compras
FROM
    ad_events ae
JOIN
    users u ON ae.user_id = u.user_id
GROUP BY
    u.country
ORDER BY
    compras DESC
LIMIT 10;

-- Mejor Horario para Publicar
SELECT 
    time_of_day as horario,
    COUNT(*) as total_eventos,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as porcentaje
FROM ad_events
GROUP BY time_of_day
ORDER BY total_eventos DESC;

-- Mejor Horario para Generar Compras
SELECT 
    time_of_day as horario,
    COUNT(*) as compras,
    CONCAT(
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1), 
        '%'
    ) as porcentaje
FROM ad_events
WHERE event_type = 'purchase'
GROUP BY time_of_day
ORDER BY compras DESC;

-- Rendimiento por Plataforma
SELECT 
    ad_platform as plataforma,
    COUNT(DISTINCT a.ad_id) as total_ads,
    COUNT(ae.event_id) as total_interacciones,
    COUNT(DISTINCT ae.user_id) as usuarios_alcanzados,
    SUM(CASE WHEN ae.event_type = 'purchase' THEN 1 ELSE 0 END) AS compras
FROM ads a
JOIN ad_events ae ON a.ad_id = ae.ad_id
GROUP BY ad_platform
ORDER BY compras DESC;

-- Performance por Día de la Semana
SELECT 
    day_of_week AS dia,
    COUNT(*) as total_eventos,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    SUM(CASE WHEN ae.event_type = 'purchase' THEN 1 ELSE 0 END) AS compras
FROM ad_events ae
GROUP BY day_of_week
ORDER BY total_eventos DESC;

-- Top 10 Anuncios Más Exitosos
SELECT 
    c.name AS nombre,
    a.ad_platform AS plataforma,
    a.ad_type AS tipo,
    SUM(CASE WHEN ae.event_type = 'purchase' THEN 1 ELSE 0 END) AS compras
FROM ads a
JOIN ad_events ae ON a.ad_id = ae.ad_id
JOIN campaigns c ON a.campaign_id = c.campaign_id
GROUP BY a.ad_id, a.ad_platform, a.ad_type
ORDER BY compras DESC
LIMIT 10;

-- Top 10 Campañas Más Exitosas
SELECT 
    c.name as nombre,
    c.total_budget as presupuesto,
    COUNT(ae.event_id) as interacciones,
    COUNT(CASE WHEN ae.event_type = 'purchase' THEN 1 END) as compras
FROM campaigns c
JOIN ads a ON c.campaign_id = a.campaign_id
JOIN ad_events ae ON a.ad_id = ae.ad_id
GROUP BY c.campaign_id, c.name, c.total_budget
HAVING COUNT(ae.event_id) > 0
ORDER BY compras DESC
LIMIT 10;

