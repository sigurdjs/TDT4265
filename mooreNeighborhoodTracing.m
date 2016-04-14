function [B, chain_code] = mooreNeighborhoodTracing( T )
    % T is a square tessellation (binary image), containing a 
    % connected component P of black/white cells.
    % The return variable B is a contour sequence (boundary region) of pixels (rows in B) where each pixel
    % contains a x-position (1st column in B) and an y-position (2nd column
    % in B).
    
    % Concept of moore neighborhood
    %
    %   |  7  |   0   |   1   |
    %   -----------------------
    %   |  6  |   p   |   2   |    , where p = boundary pixel
    %   -----------------------
    %   |  5  |   4   |   3   |
    %   -----------------------
    
    global size_of_T;
    global nr_of_rows;
    global nr_of_columns;
    global black_pixel;
    global white_pixel;
    
    % General definitions
    black_pixel = 0;
    white_pixel = 1;
    size_of_T     = size(T);
    nr_of_rows    = size_of_T(1);
    nr_of_columns = size_of_T(2);
    
    T = flipud( T );    % Flip the orientation of T so that the origin of the picture is in the bottom left.
                        % Matlab has origin of a matrix in the top left.
    
    
    % ---------------------------------------------------------
    % Find a starting point by searching for a black cell in T
    % ---------------------------------------------------------
    
    [s, initial_moore_neighbor] = findStartingPoint( T );
    
    if ( s == -1 )
       error('T does not contain any black cells'); 
    end
    
    % ---------------------------------------------------------
    % Initialization of variables
    % ---------------------------------------------------------
    row_iter      = 1;
    chain_code    = NaN( nr_of_rows*nr_of_columns , 1 );
    B             = NaN( nr_of_rows*nr_of_columns , 2 );
    B(row_iter,:) = s;                                                      % insert s in B
    p             = s;                                                      % initialize boundary point
    [c, current_moore_neighbor] = backtrack( p, initial_moore_neighbor );   % initialize current pixel
    
    % Termination variables
    jacobs_stopping_criterion = current_moore_neighbor;
    loop_counter              = 0;
    max_number_of_iterations  = 1000000000;
    
    while ( ~isequal(c,s)  )
        
        loop_counter = loop_counter + 1;
        
        if ( loop_counter > max_number_of_iterations )
            error( 'Unable to find a contour sequence');
        end
        
        x = c(2);
        y = c(1);
        
        if ( T(x, y) == black_pixel )
            row_iter = row_iter + 1;
            
            % add to solution
            B(row_iter,:) = c;
            chain_code(row_iter-1) = current_moore_neighbor;
            
            % backstepping
            p = c;
            [c, current_moore_neighbor] = backtrack( p, current_moore_neighbor );
            
        else
           [c, current_moore_neighbor] = getNextClockwisePixel( c, current_moore_neighbor );
        end
    end
    
    % Remove unused space
    B          = B( 1:row_iter, : );
    chain_code = chain_code( 1:row_iter-1);
end

function [starting_point, initial_moore_neighbor, pixel_entering_dir] = findStartingPoint( T )
    
    global nr_of_columns;
    global nr_of_rows;
    global black_pixel;
    
    initial_moore_neighbor = 8;
    starting_point_found = false;
    starting_point = -1;
    
    for j = 1:nr_of_columns
        for i = 1:nr_of_rows
            if T(i,j) == black_pixel
                starting_point = [j i];  % j = x position, i = y position
                starting_point_found = true;
                break;
            end
        end
        if starting_point_found
            break;
        end
    end
end

function [last_pixel, new_moore_neighbor] = backtrack( current_pixel, moore_neighbor )

    % OBS! Assuming a clockwise rotation
    
    switch( moore_neighbor )
        case 8  % INITIAL STATE
            last_pixel         = current_pixel + [0 -1];
            new_moore_neighbor = 4;
            
        case {0 , 1}
            last_pixel = current_pixel + [-1 0];
            new_moore_neighbor = 6;
            
        case {2, 3}
            last_pixel = current_pixel + [0 1];
            new_moore_neighbor = 0;
            
        case {4, 5}
            last_pixel = current_pixel + [1 0];
            new_moore_neighbor = 2;
            
        case {6, 7}
            last_pixel = current_pixel + [0 -1];
            new_moore_neighbor = 4;
    end
end

function [c, new_moore_neighbor] = getNextClockwisePixel( current_pixel, current_moore_neighbor )

    switch( current_moore_neighbor )
        case 0
            c = current_pixel + [1 0];
            new_moore_neighbor = 1;
            
        case 1
            c = current_pixel + [0 -1];
            new_moore_neighbor = 2;
            
        case 2
            c = current_pixel + [0 -1];
            new_moore_neighbor = 3;
            
        case 3
            c = current_pixel + [-1 0];
            new_moore_neighbor = 4;
            
        case 4
            c = current_pixel + [-1 0];
            new_moore_neighbor = 5;
        
        case 5
            c = current_pixel + [0 1];
            new_moore_neighbor = 6;
        
        case 6
            c = current_pixel + [0 1];
            new_moore_neighbor = 7;
        
        case 7
            c = current_pixel + [1 0];
            new_moore_neighbor = 0;
    end
end