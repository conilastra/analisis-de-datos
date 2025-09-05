## ¿Qué es Comportamiento de Usuario?
El ámbito que estudia el comportamiento de los usuarios en torno a los anuncios se conoce como análisis del comportamiento del usuario o, de manera más específica en este contexto, análisis de la publicidad digital o publicidad conductual.

Dentro del marketing digital, esto se refiere a la recopilación y análisis de datos sobre cómo las personas interactúan con los anuncios en línea.


## Análisis SQL
### Tipos de Eventos Más Comunes
```sql
SELECT 
    event_type as tipo_evento,
    COUNT(*) as frecuencia,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as porcentaje
FROM ad_events
GROUP BY event_type
ORDER BY frecuencia DESC;
```
<img width="305" height="127" alt="Screenshot 2025-09-04 at 3 36 18 PM" src="https://github.com/user-attachments/assets/bbdaa978-7174-4142-ac59-ef26900cb11d" />



### Distribución Demográfica de Usuarios
```sql
SELECT 
    age_group as grupo_edad,
    user_gender as genero,
    COUNT(*) as cantidad_usuarios,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 1) as porcentaje
FROM users
GROUP BY age_group, user_gender
ORDER BY cantidad_usuarios DESC;
```
<img width="318" height="306" alt="Screenshot 2025-09-04 at 3 46 06 PM" src="https://github.com/user-attachments/assets/08915ac3-a429-4716-a8cb-37b85f5a0754" />



### Países con Más Actividad
```sql
SELECT 
    u.country as pais,
    COUNT(DISTINCT u.user_id) as usuarios,
    COUNT(ae.event_id) as interacciones,
    -- Porcentaje del total de interacciones
    ROUND(COUNT(ae.event_id) * 100.0 / SUM(COUNT(ae.event_id)) OVER(), 1) as porcentaje_interacciones
FROM users u
JOIN ad_events ae ON u.user_id = ae.user_id
WHERE ae.event_id IS NOT NULL
GROUP BY u.country
ORDER BY interacciones DESC;
```
<img width="390" height="187" alt="Screenshot 2025-09-04 at 8 15 30 PM" src="https://github.com/user-attachments/assets/518abe60-77a6-4d4f-bef9-c126b7e0cfb8" />



### Top 10 Lugares con Más Compras
```sql
SELECT
    u.country,
    SUM(CASE WHEN ae.event_type = 'purchase' THEN 1 ELSE 0 END) AS compras
FROM ad_events ae
JOIN users u ON ae.user_id = u.user_id
GROUP BY u.country
ORDER BY compras DESC;
```

<img width="165" height="183" alt="Screenshot 2025-09-04 at 3 54 57 PM" src="https://github.com/user-attachments/assets/db13c56c-deed-45e0-be01-bddd00d1029a" />


### Mejor Horario para Publicar
```sql
SELECT 
    time_of_day as horario,
    COUNT(*) as total_eventos,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as porcentaje
    SUM(CASE WHEN ae.event_type = 'purchase' THEN 1 ELSE 0 END) AS compras
FROM ad_events
GROUP BY time_of_day
ORDER BY total_eventos DESC;
```
<img width="307" height="98" alt="Screenshot 2025-09-04 at 7 08 37 PM" src="https://github.com/user-attachments/assets/7c2a9d5f-0a70-48b1-89e7-3c1bbdbcda98" />



### Mejor Horario para Generar Compras
```sql
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
```
<img width="193" height="96" alt="Screenshot 2025-09-04 at 8 30 41 PM" src="https://github.com/user-attachments/assets/040b641d-5c81-4bca-a5b1-4f772511cd5e" />


### Rendimiento por Plataforma
```sql
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
```
<img width="428" height="66" alt="Screenshot 2025-09-04 at 8 31 44 PM" src="https://github.com/user-attachments/assets/df51d3da-6a45-4f26-a918-7accc3cc5cfe" />


### Performance por Día de la Semana
```sql
SELECT 
    day_of_week AS dia,
    COUNT(*) as total_eventos,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    SUM(CASE WHEN ae.event_type = 'purchase' THEN 1 ELSE 0 END) AS compras
FROM ad_events ae
GROUP BY day_of_week
ORDER BY total_eventos DESC;
```
<img width="307" height="143" alt="Screenshot 2025-09-04 at 8 32 34 PM" src="https://github.com/user-attachments/assets/3ae7c4e9-d915-4c54-94c1-30274c2dc3d6" />



### Top 10 Anuncios Más Exitosos
```sql
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
```
<img width="310" height="184" alt="Screenshot 2025-09-04 at 7 57 09 PM" src="https://github.com/user-attachments/assets/16397473-72c4-492e-8113-4e249db201f5" />


### Top 10 Campañas Más Exitosas
```sql
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
```
<img width="354" height="188" alt="Screenshot 2025-09-04 at 8 00 17 PM" src="https://github.com/user-attachments/assets/b1cc6f48-642c-44c8-9fa5-7ab1b0f54f61" />
