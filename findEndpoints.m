function endpoints = findEndpoints(contour, chainCode)
    if isempty(chainCode)
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
        return
    end
    
    
    if chainCode(1)~= chainCode(length(chainCode))
        temp_endpoint = [1];
    else
        temp_endpoint = [];
    end
    
    for index = 1:length(chainCode)-1
        if chainCode(index)~= chainCode(index+1)
            if ~isempty(temp_endpoint)
                if index - temp_endpoint(length(temp_endpoint)) > 2
                    temp_endpoint = [temp_endpoint; index];
                end
            else
                temp_endpoint = [temp_endpoint; index];
            end
        end
    end
    endpoints = temp_endpoint;
    return
end

        
