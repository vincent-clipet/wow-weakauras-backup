-- Custom Grow - Down then Right, leftovers down

function(newPositions, activeRegions)
    
    local max_width = 6 -- limit of icons per row
    local max_height = 2 -- max number of rows
    local border_size = 1 -- Outer border size set on icons (only used for calculations, will not change any existing borders)

    local spacing_x = 0
    local spacing_y = 0
    local icon_width = 50
    local icon_height = 50
    
    local overflow_spacing_x = 0
    local overflow_spacing_y = 0
    local overflow_icon_width = 40
    local overflow_icon_height = 40
    
    ----------------------
    
    local x = 0
    local y = 0
    local total = math.min(#activeRegions, max_width * max_height) -- Clips the number of auras if too many    
    local overflow = math.max(#activeRegions - max_width * max_height, 0) -- # of auras over the limit
    local overflow_fitting = math.max(0, math.floor((icon_width*max_width + (max_width-1)*spacing_x + border_size*2) / (overflow_icon_width+overflow_spacing_x))) -- # of auras that can fit
    local total_overflow = math.min(overflow, overflow_fitting)
    
    local offset_x = 0
    local offset_y = 0
    local delta_x = 0
    local delta_y = 0
    
    for i, regionData in ipairs(activeRegions) do
        local region = regionData.region
        
        if total - i >= 0 then -- Under limit
            
            delta_x = icon_width + spacing_x
            delta_y = icon_height + spacing_y
            
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
            
            region:SetRegionWidth(icon_width)
            region:SetRegionHeight(icon_height)
            newPositions[i] = {offset_x, offset_y}
            
        else -- Over-limit
            x = i - total
            if x <= total_overflow then
                delta_x = overflow_icon_width + overflow_spacing_x
                delta_y = (overflow_icon_height+icon_height)/2 + overflow_spacing_y -- + 1 + border_size
                
                offset_y = 0 - (max_height-1)*icon_height - delta_y
                
                -- Negative shift, scaled to the number of auras on the row
                offset_x = 0 - (delta_x/2 * (total_overflow+1))
                -- Delta added to each aura, to spread them apart
                offset_x = offset_x + (x * delta_x)
                
                region:SetRegionWidth(overflow_icon_width)
                region:SetRegionHeight(overflow_icon_height)
                newPositions[i] = {offset_x, offset_y}
            end
        end
    end
end

