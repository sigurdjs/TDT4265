function B = contourTracing_MooreNeighborhoodMethod( T )
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
    
    size_of_T     = size(T);
    nr_of_rows    = size_of_T(1);
    nr_of_columns = size_of_T(2);
    
    % General definitions
    black_pixel = 0;
    white_pixel = 1;
    search_dir_up    =  1;
    search_dir_right =  2;
    search_dir_down  =  3;
    search_dir_left  =  4;

    % Initialize contour sequence B
    B_clockwise = [];
    B_counter_clockwise = [];
    
    % Find a starting point by searching for a black cell in T from left to
    % right
    clockwise_search_direction = search_dir_right;
    counter_clockwise_search_direction = search_dir_right;
    s = findStartingPoint( T );

    if ( s == -1 )
       error('T does not contain any black cells'); 
    end
    
    % insert starting point in B_clockwise (only need to insert it in one of the lists) 
    B_clockwise = [ B_clockwise , s' ];
    B_counter_clockwise = [ B_counter_clockwise, s' ];
    
    p_clockwise = s;  % boundary point clockwise direction
    c_clockwise = backtrack( p_clockwise, clockwise_search_direction );
    
    p_counter_clockwise = p_clockwise;
    c_counter_clockwise = c_clockwise;
    
    % Termination variables
    counter = 0;
    max_counter = 100000;
    
    end_of_clockwise_search_found         = false;
    end_of_counter_clockwise_search_found = false;
    
    
    clockwise_second_last_pixel         = -1;
    counter_clockwise_second_last_pixel = -1;
        
    
    while ( ~isequal(c_clockwise, p_counter_clockwise) )
        
        % Clockwise search
        if ( ~end_of_clockwise_search_found)
            if ( T(c_clockwise(1), c_clockwise(2)) == black_pixel )
                B_clockwise = [ B_clockwise, c_clockwise' ];
                p_clockwise = c_clockwise;
                c_clockwise = backtrack( p_clockwise, clockwise_search_direction );
                clockwise_second_last_pixel = B_clockwise(:,end-1)';
            else
                [c_clockwise, clockwise_search_direction] = getNextClockwisePixel( p_clockwise, c_clockwise );
            end
            
            if ( isequal(c_clockwise, clockwise_second_last_pixel)  )
                end_of_clockwise_search_found = true;
            end
        end
        
        % Counter clockwise
        if ( ~end_of_counter_clockwise_search_found)
            if ( T(c_counter_clockwise(1), c_counter_clockwise(2)) == black_pixel )
                B_counter_clockwise = [ B_counter_clockwise, c_counter_clockwise' ];
                p_counter_clockwise = c_counter_clockwise;
                c_counter_clockwise = backtrack( p_counter_clockwise, counter_clockwise_search_direction );
                counter_clockwise_second_last_pixel = B_counter_clockwise(:,end-1)';
            else
                [c_counter_clockwise, counter_clockwise_search_direction] = getNextCounterClockwisePixel( p_counter_clockwise, c_counter_clockwise );
            end
            
            if ( isequal(c_counter_clockwise, counter_clockwise_second_last_pixel) )
                end_of_counter_clockwise_search_found = true;
            end
        end
 
        % termination criterias
        if ( end_of_counter_clockwise_search_found && end_of_clockwise_search_found )
            warning('unclosed shape found');
            break;
        end
        counter = counter + 1;
        if ( counter == max_counter )
            error( 'Unable to find a contour sequence');
        end
    end
    
    B_clockwise = B_clockwise';
    B_counter_clockwise = B_counter_clockwise(:,2:end);  % remove starting point
    B_counter_clockwise = flipud( B_counter_clockwise' );
    
    B = [ B_counter_clockwise; B_clockwise ];
end

function starting_point = findStartingPoint( T )

    starting_point_found = false;
    starting_point = -1;
    
    global nr_of_rows;
    global nr_of_columns;
    global black_pixel;
    
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

    global search_dir_up;
    global search_dir_right;
    global search_dir_down;
    global search_dir_left;
    
    orientation = mat2str( boundary_pixel - current_pixel );
    c1 = current_pixel(1);
    c2 = current_pixel(2);
    switch(orientation)
        case '[1 1]'
            c = [c1, c2+1];
            search_direction = search_dir_right;
        case '[1 0]'
            c = [c1, c2+1];
            search_direction = search_dir_right;
        case '[1 -1]'
            c = [c1+1,c2];
            search_direction = search_dir_down;
        case '[0 1]'
            c = [c1-1,c2];
            search_direction = search_dir_up;
        case '[0 -1]'
            c = [c1+1,c2];
            search_direction = search_dir_down;
        case '[-1 1]'
            c = [c1-1,c2];
            search_direction = search_dir_up;
        case '[-1 0]'
            c = [c1,c2-1];
            search_direction = search_dir_left;
        case '[-1 -1]'
            c = [c1,c2-1];
            search_direction = search_dir_left;
    end

end

function [c, search_direction] = getNextCounterClockwisePixel( boundary_pixel, current_pixel )

    global search_dir_up;
    global search_dir_right;
    global search_dir_down;
    global search_dir_left;
    
    orientation = mat2str( boundary_pixel - current_pixel );
    c1 = current_pixel(1);
    c2 = current_pixel(2);
    switch(orientation)
        case '[1 1]'
            c = [c1+1, c2];
            search_direction = search_dir_down;
        case '[1 0]'
            c = [c1, c2-1];
            search_direction = search_dir_left;
        case '[1 -1]'
            c = [c1,c2-1];
            search_direction = search_dir_left;
        case '[0 1]'
            c = [c1+1,c2];
            search_direction = search_dir_down;
        case '[0 -1]'
            c = [c1-1,c2];
            search_direction = search_dir_up;
        case '[-1 1]'
            c = [c1,c2+1];
            search_direction = search_dir_right;
        case '[-1 0]'
            c = [c1,c2+1];
            search_direction = search_dir_right;
        case '[-1 -1]'
            c = [c1-1,c2];
            search_direction = search_dir_up;
    end
end