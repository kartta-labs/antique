-- Copyright 2008-2020 Tim Waters
-- Copyright 2020 Google LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- Filtering on nodes
-- we just want place, name
function filter_tags_node (tags, numberofkeys)
	local filter = 0
	if not tags['place'] then filter = 1 end
    return filter, tags
end

-- Filtering on relations: just multipolygons
-- (note that the current dataset doesn't have any multipolygons)
function filter_basic_tags_rel (tags, numberofkeys)
    if tags["type"] ~= "multipolygon" then return 1, tags end
    return 0, tags
end

-- Filtering on ways
--	Columns in planet_osm_polygon:
--	- building (amenity | building | industrial | shop | tourism)
--	- type (i.e. shop type, religion type)
--	- landuse (landuse | leisure) <--- note that we shouldn't set landuse if there's a building tag
--	- name
--	Columns in planet_osm_line:
--	- highway
--	- natural (=coastline)

function filter_tags_way (tags, numberofkeys)

    local filter = 0  -- Will object be filtered out?
    local polygon = 0 -- Will object be treated as polygon?
    local roads = 0   -- Will object be added to planet_osm_roads?
	local type = nil
	local landuse = nil

	-- Collapse into building/landuse tags
	local building = tags["amenity"] or tags["industrial"] or tags["tourism"] or tags["building"] 
	if tags["shop"] then building="shop"; type=tags["shop"] end
	if not building then landuse = tags["landuse"] or tags["leisure"] end
	tags['type'] = type or tags["religion"]
	if building or landuse then 
		tags["building"] = building
		tags["landuse"]  = landuse
		return 0, tags, 1, 0
	end

	-- Otherwise, is it a highway or a coastline?
	if tags["highway"] or tags["natural"] then
		return 0, tags, 0, 0
	end

	-- Not something we recognise
	return 1, tags, 0, 0
end

function filter_tags_relation_member (tags, keyvaluemembers, roles, membercount)
    filter = 0     -- Will object be filtered out?
    linestring = 0 -- Will object be treated as linestring?
    polygon = 0    -- Will object be treated as polygon?
    roads = 0      -- Will object be added to planet_osm_roads?
	membersuperseded = {}
	for i = 1, membercount do
		membersuperseded[i] = 0
	end

    type = tags["type"]

    -- Remove type key
    tags["type"] = nil

    -- Relations with type=boundary are treated as linestring
    if (type == "boundary") then
        linestring = 1
    end
    -- Relations with type=multipolygon and boundary=* are treated as linestring
    if ((type == "multipolygon") and tags["boundary"]) then
        linestring = 1
    -- For multipolygons...
    elseif (type == "multipolygon") then
        -- Treat as polygon
        polygon = 1
    end

    return filter, tags, membersuperseded, linestring, polygon, roads
end
