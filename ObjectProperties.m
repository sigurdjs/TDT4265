function [Properties] = ObjectProperties( B )
% This function calculates important properties of B such as 
% contour length, enclosed area, ..  
    Properties(1).length = length(B);
    Properties(1).area = FindArea(B);
    Properties(1).compactness = (Properties(1).length)/(4*pi*Properties(1).area);
end

function [ ContourArea ] = FindArea(B)
% B is a closed region described by chain-codes. 0 for left, 1 for up, 2
% for right and 3 for down. Area output in pixels.
    area = 0;   ypos = 0;
    for i = 1:length(B)
        if B(i) == 0
            area = area - ypos;
        elseif B(i) == 1
            ypos = ypos -1;
        elseif B(i) = 2
            area = area + ypos;
        elseif B(i) = 3
            ypos = ypos +1;
        else
            disp('Unknown chain-code detected. Cannot find area of region');
            break
        end
    end
end
            
        




