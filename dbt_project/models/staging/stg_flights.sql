WITH raw AS (
    SELECT *
    FROM {{ source('open_sky', 'flights_raw') }}
),
aircraft AS (
    SELECT *
    FROM {{ source('aircraft_ref', 'aircraft_ref') }}
)
SELECT
    r.icao24,
    r.callsign,
    r.time AS time_position,
    r.lastcontact AS last_contact,
    r.lon AS longitude,
    r.lat AS latitude,
    r.baroaltitude AS baro_altitude,
    r.geoaltitude AS geo_altitude,
    r.onground AS on_ground,
    r.velocity,
    r.heading,
    r.vertrate AS vertical_rate,
    a.registration,
    a.manufacturername,
    a.model,
    a.operator,
    a.categoryDescription
FROM raw r
LEFT JOIN aircraft a
    ON r.icao24 = a.icao24
WHERE r.lon IS NOT NULL
  AND r.lat IS NOT NULL