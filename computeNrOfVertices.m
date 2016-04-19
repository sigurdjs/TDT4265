function number_of_vertices = computeNrOfVertices( chain_code)
    
    subplot(1,4,1)
    plot(chain_code)
    
    
    len = length(chain_code);
    grid_size = 2;
    meaned_chain_code = nan(len,1);
    for i = 1:len-grid_size
        mean_value = sum(chain_code(i:i+grid_size))/grid_size;
        meaned_chain_code(i:i+grid_size) = mean_value;
    end   
    meaned_chain_code(end-grid_size:end) = sum(chain_code(end-grid_size:end))/grid_size;
        
    subplot(1,4,2)
    plot(meaned_chain_code)
    
    grid_size = 18;
    n = grid_size*floor( len / grid_size );
    filtered_meaned_chain_code = nan( n/grid_size, 1);
    counter = 1;
    for i = 1:grid_size:n-grid_size
        most_frequent_value = mode( meaned_chain_code(i:i+grid_size) );
        filtered_meaned_chain_code(counter) = most_frequent_value;
        counter = counter + 1;
    end
    filtered_meaned_chain_code(counter) = mode( meaned_chain_code(end-grid_size:end));

    filtered_chain_code_diff = differentiateChainCode(filtered_meaned_chain_code);
    

    subplot(1,4,3)
    plot(filtered_meaned_chain_code)
    subplot(1,4,4)
    plot(filtered_chain_code_diff)
    
    number_of_vertices = 0;
    for i = 1:length(filtered_chain_code_diff)
       if filtered_chain_code_diff(i) ~= 0
           number_of_vertices = number_of_vertices + 1;
       end
    end
end