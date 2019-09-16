## Setup

First create the Postgres database:

    CREATE DATABASE antique WITH OWNER osm;
    \c antique
    CREATE EXTENSION PostGIS;

Now load the data with osm2pgsql:

    osm2pgsql -d antique --style antique.style --tag-transform-script antique.lua input.osm
	
Note that input.osm needs to have positive OSM IDs.

Finally, get coastline data from https://osmdata.openstreetmap.de/data/water-polygons.html (water-polygons-split-3857.zip), and place it at /usr/local/share/maps/data/water-polygons-split-3857/water_polygons.shp (.dbf, .shx).

## Configure

in the mml file change the values for 

```
"${DBNAME}", "${DBHOST}",  "${DBUSER}" and  "${DBPASSWORD}"
```

__Examples Using envsubst__

```
DBNAME=antique DBHOST=localhost DBUSER=osm  DBPASSWORD="" envsubst < antique.mml > mml.tmp && mv mml.tmp antique.mml
```

## Compile with carto


`carto -a "3.0.20" antique.mml > antique.xml`

### Database notes

The Lua import script boils down the data into a simple schema. All line/polygon objects have a value in one of four columns: building, landuse, highway or natural. They may optionally have a name and type value.

Point objects have place and name values only.


## Cartography notes

The style is designed for viewing at zoom levels 16-20, although levels 14-15 and 21+ are legible.

Adding more feature types will require adapting the Lua import script, so that the data is attributed to the right column, as well as the .mss file (and potentially .mml).

Fonts are Balthazar and Josefin Sans, both as included in the Google Fonts collection, and licensed under the Open Font License.



Richard Fairhurst (richard@systemeD.net), August 2019
