-- models/marts/mart_flight_summary.sql

WITH base AS (
    SELECT *
    FROM {{ ref('int_flights') }}
),

aggregated AS (
    SELECT
        DATE_TRUNC('hour', TO_TIMESTAMP(time_position)) AS hour,
        COUNT(*) AS total_flights,
        SUM(CASE WHEN on_ground = false THEN 1 ELSE 0 END) AS flights_in_air,
        SUM(CASE WHEN on_ground = true THEN 1 ELSE 0 END) AS flights_on_ground,
        AVG(velocity_kmh) AS avg_speed_kmh,
        AVG(baro_altitude) AS avg_baro_altitude_m,
        AVG(geo_altitude) AS avg_geo_altitude_m
    FROM base
    WHERE latitude IS NOT NULL AND longitude IS NOT NULL
    GROUP BY 1
)

SELECT *
FROM aggregated