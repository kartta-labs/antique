## Antique vector style

This is an antique-style vector map for Mapbox GL. The tiles are served by Tegola and the style is compiled by Glug.

### Prerequisites

- osm2pgsql
- Tegola
- glug (`gem install glug`)

### How to

- Load data into a PostGIS database with osm2pgsql
- Change `antique.toml` to have your connection details (database, user, password)
- Compile the Glug stylesheet to JSON: `glug antique.glug > antique_style.json`
- Serve the tiles with Tegola: `tegola serve --config antique.toml`

### Configuration

Paths are currently set up on the basis that static files are served at
http://localhost/ using standard port 80 (by your webserver of choice), vector
tiles at http://localhost:8080/ (Tegola's default). Mapbox GL does not permit
relative URLs so these will, of course, need to be changed before any
deployment.

### Notes

Only a subset of OSM data is rendered, corresponding to the original Antique
raster style (but ported to use standard OSM keys/values). There is currently no
indexing and limited query-time filtering: this could be trivially added to the
.toml layer queries. Mapbox GL JS code is bundled in the
`../third_party/vecor/mbgl/` directory but this could be fetched from a CDN or
similar.
