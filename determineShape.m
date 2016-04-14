function shape = determineShape(descriptors)
 
    if size(descriptors.e, 1) == 6
        shape = 'L-Shape';
        return
    elseif size(descriptors.e, 1) < 4
        shape = 'Square';
        return
    elseif size(descriptors.e, 1) == 4 % Can be a rectangle or a square.
        
        lineLengths = findLineLength(descriptors.e);   
        if unique(lineLengths) > 1
            shape = 'Rectangle';
            return
        else
            shape = 'Square';
            return
        %check if square or rectangle
    end
end

            