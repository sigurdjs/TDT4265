function [Properties] = ObjectProperties( B )
% This function calculates important properties of B such as 
% contour length, enclosed area, ..  
    Properties(1).length = length(B);
    Properties(1).area = FindArea(B);
    Properties(1).compactness = (Properties(1).length)/(4*pi*Properties(1).area);
    Properties(1).COM = CenterOfMass(B,pROPERTIES(1).area);
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

function [ COM ] = CenterOfMass(B,area)
% Calculates center of mass (x,y) in pixels    
    sum = 0;   x = 0;   value = 0;
    for i = 1:length(B)
        if B(i) == 0
            x = x + 1;
            value = value + (x -0.5);
        elseif B(i) == 1
            sum = sum -value;
        elseif B(i) = 2
            value = value - (x -0.5);
            x = x - 1;
        elseif B(i) = 3
            sum = sum + value;
        else
            disp('Unknown chain-code detected. Cannot find area of region');
            break
        end
    end
    COM(1).x = sum/area;
    sum = 0;   y = 0;   value = 0;
    for i = 1:length(B)
        if B(i) == 1
            y = y + 1;
            value = value + (y -0.5);
        elseif B(i) == 2
            sum = sum -value;
        elseif B(i) = 3
            value = value - (y -0.5);
            y = y - 1;
        elseif B(i) = 0
            sum = sum + value;
        else
            disp('Unknown chain-code detected. Cannot find area of region');
            break
        end
    end
    COM(1).y = sum/area;
end
        




