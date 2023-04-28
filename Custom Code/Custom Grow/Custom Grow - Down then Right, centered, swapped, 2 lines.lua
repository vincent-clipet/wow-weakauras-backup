-- Custom Grow - Down then Right, centered, compact

function(newPositions, activeRegions)
    
    -- ##### CONFIG #####

    local max_width = 6             -- limit of icons per row

    local border_size = 1           -- Outer border size set on icons (only used for calculations, will not change any existing borders)

    local spacing_x = 0             -- enforce X pixels of spacing between icons, horizontally
    local spacing_y = 0             -- enforce X pixels of spacing between icons, vertically
    local icon_width = 50           -- enforce icon width
    local icon_height = 50          -- enforce icon width

    local swap_even_odd = true      -- swap 1 with 2, 3 with 4, etc ... to match keybinds to visuals


    
    -- ##### SCRIPT #####
    
    local max_height = 2            -- max number of rows

    local x = 0
    local y = 0

    local total = math.min(#activeRegions, max_width * max_height) -- Clips the number of auras if too many
    local i = 0
    
    local offset_x = 0
    local offset_y = 0
    local delta_x = 0
    local delta_y = 0

    for iter, regionData in ipairs(activeRegions) do
        
        if iter > total then break end

        i = iter
        local region = regionData.region
                    
        delta_x = icon_width + spacing_x
        delta_y = icon_height + spacing_y

        -- 2 lines
        if total > max_width then

            if swap_even_odd then
                -- Excludes the last icon from being swapped if there is an odd number of elements 
                if total % 2 == 0 or (total % 2 == 1 and iter < total) then
                    if iter % 2 == 0 then
                        i = i - 1
                    else
                        i = i + 1
                    end
                end
            end

            y = 1 + (i-1)%max_height -- y=1 => top row
            offset_y = 0 - delta_y * (y-1)

            x = math.ceil(i / max_height)
            -- Negative shift, scaled to the number of auras on the row
            offset_x = 0 - (delta_x/2 * (math.ceil(total/max_height)+1))
            -- Delta added to each aura, to spread them apart
            offset_x = offset_x + (x * delta_x)

            -- '(total % max_height)' => gives the number of full rows (from the top)
            -- If current row number is above, we need to shift from half an aura
            if (total % max_height) ~= 0 and (y > (total % max_height)) then
                offset_x = offset_x + math.ceil(delta_x/2)
            end

        -- 1 line
        else
            y = 1
            offset_y = 0

            x = i
            -- Negative shift, scaled to the number of auras on the row
            offset_x = 0 - (delta_x/2 * (total +1 ))
            -- Delta added to each aura, to spread them apart
            offset_x = offset_x + (x * delta_x)

            -- '(total % max_height)' => gives the number of full rows (from the top)
            -- If current row number is above, we need to shift from half an aura
            if (total % max_height) ~= 0 and (y > (total % max_height)) then
                -- offset_x = offset_x + math.ceil(delta_x/2)
            end
        end

        region:SetRegionWidth(icon_width)
        region:SetRegionHeight(icon_height)
        newPositions[iter] = {offset_x, offset_y}

    end
end