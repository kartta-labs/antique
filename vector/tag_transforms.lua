function filter_tags_dates(keyvalues, nokeys)
  filter = 0
  tagcount = 0

  if nokeys == 0 then
     filter = 1
     return filter, keyvalues
  end
  start_date_int = "-Infinity"
  end_date_int = "Infinity"
  
 if (keyvalues["start_date"] ~= nil ) or (keyvalues["end_date"] ~= nil ) then
  keyvalues["start_date_int"] = start_date_int
  keyvalues["end_date_int"] = end_date_int
  end

  if (keyvalues["start_date"] ~= nil ) then
   year,month,day = nil
   year = string.match(keyvalues["start_date"], "^(-?%d+%d%d%d)")

     if (year ~= nil) then
       y, month = string.match(keyvalues["start_date"], "^(-?%d+%d%d%d)-(%d%d)")
       
       if (month == nil) then
         month = "00"
         day = "00"
       else
         y, m, day = string.match(keyvalues["start_date"], "^(-?%d+%d%d%d)-(%d%d)-(%d%d)")
         if (day == nil) then
           day = "00"
         end

       end

         year = string.sub(year, 0, 4)
         month = string.sub(month, 0, 2)
         day = string.sub(day, 0, 2)
         start_date_int = year..month..day
         keyvalues["start_date_int"] =  start_date_int
       else
         keyvalues["start_date_int"] = "-Infinity"
     end
 end
 
 if (keyvalues["end_date"] ~= nil ) then
   year,month,day = nil
   year = string.match(keyvalues["end_date"], "^(-?%d+%d%d%d)")

     if (year ~= nil) then
       y, month = string.match(keyvalues["end_date"], "^(-?%d+%d%d%d)-(%d%d)")
       if (month == nil) then
         month = "00"
         day = "00"
       else
         y, m, day = string.match(keyvalues["end_date"], "^(-?%d+%d%d%d)-(%d%d)-(%d%d)")
         if (day == nil) then
           day = "00"
         end

       end

         year = string.sub(year, 0, 4)
         month = string.sub(month, 0, 2)
         day = string.sub(day, 0, 2)
         end_date_int = year..month..day
         keyvalues["end_date_int"] =  end_date_int
       else
        
         keyvalues["end_date_int"] = "Infinity"
     end
 end

  return filter, keyvalues
end


-- Filtering on nodes
-- we just want place, name
function filter_tags_node (tags, numberofkeys)

  filters, tags = filter_tags_dates(tags, numberofkeys)

	local filter = 0
	if not tags['place'] then filter = 1 end
    return filter, tags
end

-- Filtering on relations: just multipolygons
-- (note that the current dataset doesn't have any multipolygons)
function filter_basic_tags_rel (tags, numberofkeys)
    filter, tags = filter_tags_dates(tags, numberofkeys)
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
  
    filter, tags = filter_tags_dates(tags, numberofkeys)

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
	if tags["highway"] or tags["natural"] == "coastline" then
		return 0, tags, 0, 0
  end
  
  if tags["natural"] == "water" then
    return 0, tags, 1, 0
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