-- Custom Grow - Centered horizontal, balanced on each line

function(newPositions, activeRegions)
    
    local max_width = 6 -- limit of icons per row
    local max_height = 2 -- max number of rows
    local border_size = 1 -- Outer border size set on icons (only used for calculations, will not change any existing borders)

    local spacing_x = 0
    local spacing_y = 0
    local icon_width = 50
    local icon_height = 50
    local icon_override_size = false

    local grow_direction = 1 --     1 => down    -1 => up
    
    ----------------------
    
    local total = math.min(#activeRegions, max_width * max_height) -- Clips the number of auras if too many
    local effective_height = math.ceil(total / max_width) -- actual number of lines to display
    local effective_width = math.ceil(total / effective_height) -- maximum line width (might be -1 if total is uneven)

    local delta_x = icon_width + spacing_x
    local delta_y = icon_height + spacing_y

    local x, y
    local offset_x, offset_y
    local auras_on_last_line


    for i, regionData in ipairs(activeRegions) do
        local region = regionData.region

        if i > effective_height * effective_width then return end
        
        y = math.ceil(i / effective_width)
        offset_y = 0 - delta_y * (y-1) * grow_direction

        x = (i-1) % effective_width + 1
        -- Negative shift, scaled to the number of auras on the row
        offset_x = 0 - (delta_x/2 * (effective_width+1))
        -- Delta added to each aura, to spread them apart
        offset_x = offset_x + (x * delta_x)

        if y == effective_height then -- last line
            auras_on_last_line = total - ((effective_height-1) * effective_width)
            offset_x = offset_x + math.ceil(delta_x/2 * (effective_width-auras_on_last_line))
        end
        
        if icon_override_size then 
            region:SetRegionWidth(icon_width)
            region:SetRegionHeight(icon_height)
        end

        newPositions[i] = {offset_x, offset_y}
    end
end