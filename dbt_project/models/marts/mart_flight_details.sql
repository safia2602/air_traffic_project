WITH base AS (
    SELECT *
    FROM {{ ref('int_flights') }}
),

aircraft AS (
    SELECT *
    FROM {{ source('aircraft_ref', 'aircraft_ref') }}
),

joined AS (
    SELECT
        b.icao24,
        b.callsign,
        b.on_ground,
        b.velocity_kmh,
        b.baro_altitude,
        b.geo_altitude,
        b.vertical_rate,
        b.latitude,
        b.longitude,
        b.time_position,
        a.registration,
        a.manufacturername,
        a.model,
        a.operator,
        a.categoryDescription
    FROM base b
    LEFT JOIN aircraft a
        ON b.icao24 = a.icao24
    WHERE b.latitude IS NOT NULL
      AND b.longitude IS NOT NULL
)

SELECT
    DATE_TRUNC('minute', TO_TIMESTAMP(time_position)) AS minute,
    icao24,
    callsign,
    on_ground,

    AVG(velocity_kmh) AS avg_velocity_kmh,
    AVG(baro_altitude) AS avg_baro_altitude,
    AVG(geo_altitude) AS avg_geo_altitude,
    AVG(vertical_rate) AS avg_vertical_rate,
    AVG(latitude) AS avg_latitude,
    AVG(longitude) AS avg_longitude,

    registration,
    manufacturername,
    model,
    operator,
    categoryDescription,

    SUM(CASE WHEN on_ground = false THEN 1 ELSE 0 END) AS flights_in_air,
    SUM(CASE WHEN on_ground THEN 1 ELSE 0 END) AS flights_on_ground

FROM joined

GROUP BY
    DATE_TRUNC('minute', TO_TIMESTAMP(time_position)),
    icao24,
    callsign,
    on_ground,
    registration,
    manufacturername,
    model,
    operator,
    categoryDescription

ORDER BY minute, icao24;