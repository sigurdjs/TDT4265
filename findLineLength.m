function lineLength = findLineLength(endpoints)

    if length(endpoints) == 0
        
        return
    end
    
    temp_length = [];
    temp_point = endpoints(size(endpoints, 1), :);
    for point = 1:size(endpoints, 1)
        temp_length = [temp_length; max(abs(temp_point - endpoints(point, :)))];
        temp_point = endpoints(point, :);
    end
    lineLength = temp_length;
    return
end
