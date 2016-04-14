function [ c_length, diameter, dia_orientation , area] = ObjectProperties( B )
%This function finds different shape properties of a closed boundary region B
%   Detailed explanation goes here
    c_length = FindLength(B);
    [diameter, dia_orientation] = FindDiameter(B);
    area = FindArea(B);

end

function [ Contour_Length ] = FindLength ( B )
    Contour_Length = 0;
    for i = 2:length(B)
        Contour_Length = Contour_Length + sqrt((B(i,1) - B(i-1,1))^2 + (B(i,2) - B(i-1,2))^2);
    end
    Contour_Length = Contour_Length + sqrt((B(1,1) - B(length(B),1))^2 + (B(1,2) - B(length(B),2))^2);
end


function [ area ] = FindArea( B )
    area = 0;
    j = length(B)/2;
    for i = 1:length(B)/4
        area = area + (abs(B(i,1) - B(j,1)) + abs(B(i,2) - B(j,2)));
        j = j-1;
    end
    j = length(B)/2+1;
    for i = length(B):-1:((3*length(B))/4)+1
        area = area + (abs(B(i,1) - B(j,1)) + abs(B(i,2) - B(j,2)));
        j = j-1;
    end
end


function [ diameter, orientation ] = FindDiameter( B )
%   This function finds the generalized diameter, sup |x-y|, where x and y are
%   boundary points and diameter in pixels.
    maxdi = 0;
    maxindex = 0;
    for i = 1:length(B),
        for j = 1:length(B),
            di = sqrt((B(j,1) - B(i,1))^2  + (B(j,2) - B(i,2))^2);
            if di > maxdi,
                maxdi = di;
                maxindex = [i j];
            end
        end
    end
    diameter_vector = [abs(B(maxindex(2),1) - B(maxindex(1),1)) abs(B(maxindex(2),2) - B(maxindex(1),2))];
    orientation = acos(diameter_vector(1)/diameter_vector(2));
    diameter = maxdi;
end


