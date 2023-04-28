-- Custom Grow - Right then down, centered

function(newPositions, activeRegions)
    local limit = 6 -- limit of icons per row
    local rows = 2 -- total rows
    local spacing = 1 -- spacing between icons
    ----------------------
    local check = true
    local xCount = 0
    local yCount = 0
    local tCount = 0
    
    local xOffset = 0
    local yOffset = 0
    local total = #activeRegions
    
    for i, regionData in ipairs(activeRegions) do
        local region = regionData.region
        
        local regionsLeft = total - tCount
        local rowTotal = 1
        
        if total <= limit then
            rowTotal = total
        elseif (regionsLeft < limit and xCount < 1) or not check then
            check = false
            rowTotal = regionsLeft
        elseif yCount >= rows-1 then
            rowTotal = regionsLeft
        elseif total > limit then
            rowTotal = limit
        end
        
        xOffset = 0 - (region.width + spacing) / 2 * (rowTotal-1) + (xCount * (region.width + spacing))
        yOffset = 0 - (region.height + spacing) * yCount -- change '-' to '+' after 0 to grow up instead of down
        
        xCount = xCount + 1
        
        if yCount < rows-1 and check then
            tCount = tCount + 1
            if xCount >= limit then
                xCount = 0
                yCount = yCount + 1
            end
        end
        
        newPositions[i] = {xOffset, yOffset}
    end
end