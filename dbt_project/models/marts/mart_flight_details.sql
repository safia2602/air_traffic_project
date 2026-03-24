-- models/marts/mart_flight_summary.sql

WITH transformed AS (
    SELECT
        minute,
        on_ground,
        velocity_kmh,
        baro_altitude,
        geo_altitude,
        CASE WHEN on_ground THEN 0 ELSE 1 END AS is_airborne
    FROM {{ ref('int_flights') }}
)

SELECT
    minute,
    icao24,
    SUM(is_airborne) AS flights_in_air,
    SUM(CASE WHEN on_ground THEN 1 ELSE 0 END) AS flights_on_ground,
    ROUND(AVG(velocity_kmh), 2) AS avg_speed_kmh,
    ROUND(MAX(velocity_kmh), 2) AS max_speed_kmh,
    ROUND(MIN(velocity_kmh), 2) AS min_speed_kmh,
    ROUND(AVG(baro_altitude), 2) AS avg_baro_altitude_m,
    ROUND(MAX(baro_altitude), 2) AS max_baro_altitude_m,
    ROUND(MIN(baro_altitude), 2) AS min_baro_altitude_m,
    ROUND(AVG(geo_altitude), 2) AS avg_geo_altitude_m,
    ROUND(MAX(geo_altitude), 2) AS max_geo_altitude_m,
    ROUND(MIN(geo_altitude), 2) AS min_geo_altitude_m
FROM transformed
GROUP BY minute, icao24
ORDER BY minute;