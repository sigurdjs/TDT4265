function [ b_length, diameter, diameter_orientation ] = ObjectProperties( B )
%This function finds different shape properties of a closed boundary region B
%   Detailed explanation goes here
    b_length = length(B);
    [diameter, dia_orientation] = Find_Diameter(B);





end

function [ diameter, orientation ] = Find_Diameter( B )
%   This function finds the generalized diameter, sup |x-y|, where x and y are
%   boundary points.
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


