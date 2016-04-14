function endpoints = findEndpoints(contour)
    x_last_sum = abs(contour(1, 1)- contour(size(contour,1), 1));
    y_last_sum = abs(contour(1, 2)- contour(size(contour,1), 2));
    temp_endpoints = [];
    for point = 1:size(contour,1)- 1
        x_sum = abs(contour(point, 1)- contour(point+ 1, 1));
        y_sum = abs(contour(point, 2)- contour(point+ 1, 2));
        if  x_sum ~= x_last_sum && y_sum ~= y_last_sum
            if length(temp_endpoints) > 0
                if abs(sum(temp_endpoints(length(temp_endpoints)- 1,:)) - sum(contour(point, :))) > 2
                    temp_endpoints = [temp_endpoints ;contour(point, :)];
                end
            else
                temp_endpoints = [temp_endpoints ;contour(point, :)];
            end
        end
        x_last_sum = abs(contour(point, 1)- contour(point+ 1, 1));
        y_last_sum = abs(contour(point, 2)- contour(point+ 1, 2));
    end
    endpoints = temp_endpoints;
end

        
