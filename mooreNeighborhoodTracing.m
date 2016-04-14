function B = mooreNeighborhoodTracing( T )
    % T is a square tessellation (binary image), containing a 
    % connected component P of black/white cells.
    % The return variable B is a contour sequence of pixels (rows in B) where each pixel
    % contains a x-position (1st column in B) and an y-position (2nd column
    % in B).
    
    global size_of_T;
    global nr_of_rows;
    global nr_of_columns;
    global black_pixel;
    global white_pixel;
    global search_dir_up;
    global search_dir_right;
    global search_dir_down;
    global search_dir_left;

    % General definitions
    black_pixel = 0;
    white_pixel = 1;
    search_dir_up    =  1;
    search_dir_right =  2;
    search_dir_down  =  3;
    search_dir_left  =  4;
    
    size_of_T     = size(T);
    nr_of_rows    = size_of_T(1);
    nr_of_columns = size_of_T(2);
    
    % ---------------------------------------------------------
    % Find a starting point by searching for a black cell in T
    % ---------------------------------------------------------
    
    [s, initial_search_direction] = findStartingPoint( T );
    
    if ( s == -1 )
       error('T does not contain any black cells'); 
    end
    
    % ---------------------------------------------------------
    % Initialization of variables
    % ---------------------------------------------------------
    
    B = [];
    B = [ B , s' ];                           % insert s in B
    p = s;                                    % initialize boundary point
    c = backtrack( p, initial_search_direction );   % initialize current pixel
    search_direction = initial_search_direction;
    
    % Termination variables
    termination_counter = 0;
    termination_max_counter_value = nr_of_rows*nr_of_columns;
    
    while ( ~isequal(c,s) || ( search_direction ~= initial_search_direction) )  % Jacob's stopping criterion
        
        if ( T(c(1), c(2)) == black_pixel )
            B = [ B, c' ];
            p = c;
            c = backtrack( p, search_direction );
        else
           [c, search_direction] = getNextClockwisePixel( p, c );
        end
        
        termination_counter = termination_counter + 1;
        if ( termination_counter == termination_max_counter_value )
            error( 'Unable to find a contour sequence');
        end
    end
    
    B = B';
end

function [starting_point, initial_search_direction] = findStartingPoint( T )

    global nr_of_rows;
    global nr_of_columns;
    global black_pixel;
    global search_dir_right;
    
    initial_search_direction = search_dir_right;
    starting_point_found = false;
    starting_point = -1;
    
    for i = 1:nr_of_rows
        for j = 1:nr_of_columns
            if T(i,j) == black_pixel
                starting_point = [i j];
                starting_point_found = true;
                break;
            end
        end
        if starting_point_found
            break;
        end
    end
end

function last_pixel = backtrack( current_pixel, search_direction )

    global search_dir_up;
    global search_dir_right;
    global search_dir_down;
    global search_dir_left;

    switch( search_direction )
        case search_dir_up
            x = current_pixel(1) + 1;
            y = current_pixel(2);
        case search_dir_down
            x = current_pixel(1) - 1;
            y = current_pixel(2);
        case search_dir_right
            x = current_pixel(1);
            y = current_pixel(2) - 1;
        case search_dir_left
            x = current_pixel(1);
            y = current_pixel(2) + 1;
    end
    
    last_pixel = [ x, y ];
end

function [c, search_direction] = getNextClockwisePixel( boundary_pixel, current_pixel )

    up    = 1;
    right = 2;
    down  = 3;
    left  = 4;
    orientation = mat2str( boundary_pixel - current_pixel );
    c1 = current_pixel(1);
    c2 = current_pixel(2);
    switch(orientation)
        case '[1 1]'
            c = [c1, c2+1];
            search_direction = right;
        case '[1 0]'
            c = [c1, c2+1];
            search_direction = right;
        case '[1 -1]'
            c = [c1+1,c2];
            search_direction = down;
        case '[0 1]'
            c = [c1-1,c2];
            search_direction = up;
        case '[0 -1]'
            c = [c1+1,c2];
            search_direction = down;
        case '[-1 1]'
            c = [c1-1,c2];
            search_direction = up;
        case '[-1 0]'
            c = [c1,c2-1];
            search_direction = left;
        case '[-1 -1]'
            c = [c1,c2-1];
            search_direction = left;
    end

end