
function shapeNumber = findShapeNumber(dc)
    temp_shapeNumber = sum(10.^(length(dc)-1:-1:0) .* dc);
    temp = dc;
    temp_best = temp;
    for i = 1:length(dc)
        temp = circshift(temp, [0, -1]);
        if (temp_shapeNumber > sum(10.^(length(temp)-1:-1:0) .* temp))
            temp_best = temp;
            temp_shapeNumber = sum(10.^(length(temp)-1:-1:0) .* temp);
        end
    end
    shapeNumber = temp_best;
end
