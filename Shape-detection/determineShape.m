function shape = determineShape(descriptors)

    if size(descriptors.e, 1) == 6
        shape = 'L-Shape';
        return
    elseif size(descriptors.e, 1) > 20
        shape = 'Circle';
        return
    elseif size(descriptors.e, 1) == 4 % Can be a rectangle or a square.   
        if length(unique(descriptors.ll)) == 2
            shape = 'Rectangle';
            return
        elseif length(unique(descriptors.ll)) == 1
            shape = 'Square';
            return
            %check if square or rectangle
        end
    end
    shape = 'Unknown';
end

            