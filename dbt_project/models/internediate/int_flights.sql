WITH base AS (
    SELECT *
    FROM {{ ref('stg_flights') }}
),

transformed AS (
    SELECT
        icao24,
        callsign,
        time_position,
        last_contact,
        latitude,
        longitude,
        velocity * 3.6 AS velocity_kmh,
        vertical_rate,
        on_ground,
        baro_altitude,
        geo_altitude,
        CASE WHEN on_ground = false THEN 1 ELSE 0 END AS is_airborne,
        DATE_TRUNC('hour', TO_TIMESTAMP(time_position)) AS hour,
        DATE_TRUNC('minute', TO_TIMESTAMP(time_position)) AS minute,
        CASE WHEN on_ground THEN 'Ground' ELSE 'Air' END AS status
    FROM base
)

SELECT *
FROM transformed;