function [Properties] = ObjectProperties( B )
% This function calculates important properties of B such as 
% contour length, enclosed area, ..  
    Properties(1).length = length(B);
    Properties(1).area = FindArea(B);
    Properties(1).compactness = (Properties(1).length)/(4*pi*Properties(1).area);
%   Properties(1).COM = CenterOfMass(B,pROPERTIES(1).area);
end

function [ ContourLength ] = FindLength( B )
    ContourLength = 0;
    for i = 1: length(B)
        if any(B(i)==[0 2 4 6])
            ContourLength = ContourLength + 1;
        elseif any(B(i)==[1 3 5 7])
            ContourLength = ContourLength + sqrt(2);
        else
            disp('Chain-code outside value range detected, terminating calculation');
            ContourLength = 0;
            break;
        end
    end
end


function [ ContourArea ] = FindArea(B)
% B is a closed region described by chain-codes. 0 for left, 1 for up, 2
% for right and 0 for down. Area output in pixels.
    area = 0;   ypos = 0;
    for i = 1:length(B)
        if B(i) == 6
            area = area - ypos;
        elseif B(i) == 0
            ypos = ypos -1;
        elseif B(i) == 2
            area = area + ypos;
        elseif B(i) == 4
            ypos = ypos +1;
        elseif B(i) == 1
            ypos = ypos -1;
            area = area + ypos;
        elseif B(i) == 3
            ypos = ypos +1;
            area = area + ypos;
        elseif B(i) == 5
            ypos = ypos +1;
            area = area - ypos;
        elseif B(i) == 7
            ypos = ypos -1;
            area = area - ypos;
        else
            disp('Unknown chain-code detected. Cannot find area of region');
            break
        end
    end
    ContourArea = abs(area);
end

% function [ COM ] = CenterOfMass(B,area)
% % Calculates center of mass (x,y) in pixels   
% 
%     % Calculation of COM.x
%     sum = 0;   x = 0;   value = 0;
%     for i = 1:length(B)
%         if B(i) == 0
%             x = x + 1;
%             value = value + (x -0.5);
%         elseif B(i) == 1
%             sum = sum -value;
%         elseif B(i) = 2
%             value = value - (x -0.5);
%             x = x - 1;
%         elseif B(i) = 3
%             sum = sum + value;
%         else
%             disp('Unknown chain-code detected. Cannot find area of region');
%             break
%         end
%     end
%     COM(1).x = sum/area;
%     
%     % Calculation of COM.y
%     sum = 0;   y = 0;   value = 0;
%     for i = 1:length(B)
%         if B(i) == 1
%             y = y + 1;
%             value = value + (y -0.5);
%         elseif B(i) == 2
%             sum = sum -value;
%         elseif B(i) = 3
%             value = value - (y -0.5);
%             y = y - 1;
%         elseif B(i) = 0
%             sum = sum + value;
%         else
%             disp('Unknown chain-code detected. Cannot find area of region');
%             break
%         end
%     end
%     COM(1).y = sum/area;
% end
        




