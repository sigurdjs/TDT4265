function [Properties] = ObjectProperties( chaincode , coordinates,M)
% This function calculates important properties of B such as 
% contour length, enclosed area, ..  
    Properties(1).length = FindLength(chaincode);
    Properties(1).area = FindArea(chaincode);
    Properties(1).compactness = (Properties(1).length)/(4*pi*Properties(1).area);
    [Properties(1).comx ,Properties(1).comy] = CenterOfMass(chaincode,Properties(1).area);
    Properties(1).majoraxis = MajorAxis(coordinates);
    Properties(1).minoraxis = [0 -1; 1 0]*Properties(1).majoraxis;
    Properties(1).FilledRegion = FillRegion(M);
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
% B is a closed region described by chain-codes. 
    area = 0;   ypos = 0;
    for i = 1:length(B)
        %Right
        if B(i) == 2
            area = area - ypos;
        %Up
        elseif B(i) == 0
            ypos = ypos -1;
        %Left
        elseif B(i) == 6
            area = area + ypos;
        %Down
        elseif B(i) == 4
            ypos = ypos +1;
        %Right and up
        elseif B(i) == 1
            area = area - ypos;
            ypos = ypos -1;
        %Right and down
        elseif B(i) == 3
            area = area - ypos;
            ypos = ypos +1;
        %Left and down
        elseif B(i) == 5
            area = area + ypos;
            ypos = ypos +1;
        %Left and up
        elseif B(i) == 7
            area = area + ypos;
            ypos = ypos -1;
        else
            disp('Unknown chain-code detected. Cannot find area of region');
            break
        end
    end
    ContourArea = abs(area);
end

function [ x, y ] = CenterOfMass(B,area)
% Calculates center of mass (x,y) in pixels  0 for left, 1 for up, 2
% for right and 0 for down. Area output in pixels.


    % Calculation of COM.x
    sum = 0;   x = 0;   value = 0;
    for i = 1:length(B)
        %Right
        if B(i) == 2
            x = x + 1;
            value = value + (x -0.5);
        %Up
        elseif B(i) == 0
            sum = sum -value;
        %Left
        elseif B(i) == 6
            value = value - (x -0.5);
            x = x - 1;
        %Down
        elseif B(i) == 4
            sum = sum + value;
        %Right and up
        elseif B(i) == 1
            x = x + 1;
            value = value + (x -0.5);
            sum = sum -value;
        %Right and down
        elseif B(i) == 3
            x = x + 1;
            value = value + (x -0.5);
            sum = sum + value;
        %Left and down
        elseif B(i) == 5
            value = value - (x -0.5);
            x = x - 1;
            sum = sum + value;
        %Left and up
        elseif B(i) == 7
            value = value - (x -0.5);
            x = x - 1;
            sum = sum -value;
        else
            disp('Unknown chain-code detected. Cannot find area of region');
            break
        end
    end
    x = sum/area;
    
    % Calculation of COM.y
    sum = 0;   y = 0;   value = 0;
    for i = 1:length(B)
        %Right
        if B(i) == 0
            y = y + 1;
            value = value + (y -0.5);
        %Up
        elseif B(i) == 6
            sum = sum -value;
        %Left
        elseif B(i) == 4
            value = value - (y -0.5);
            y = y - 1;
        %Down
        elseif B(i) == 2
            sum = sum + value;
        %Right and up
        elseif B(i) == 7
            y = y + 1;
            value = value + (y -0.5);
            sum = sum -value;
        %Right and down
        elseif B(i) == 1
            y = y + 1;
            value = value + (y -0.5);
            sum = sum + value;
        %Left and down
        elseif B(i) == 3
            value = value - (y -0.5);
            y = y - 1;
            sum = sum + value;
        %Left and up
        elseif B(i) == 5
            value = value - (y -0.5);
            y = y - 1;
            sum = sum -value;
        else
            disp('Unknown chain-code detected. Cannot find area of region');
            break
        end
    end
    y = abs(sum/area);
end

function [ MajorAxis ] = MajorAxis( C )
    % Finds the maximal diameter and returns the points vector diavec which
    % describes the maximal diameter.
    maxdia = 0;   diavec = [];    dia = 0; 
    for i = 1:length(C)
        for j = 1:length(C)
            dia = sqrt((C(i,1) - C(j,1))^2 + (C(i,2) - C(j,2))^2);
            if  dia > maxdia
                maxdia = dia;
                diavec = [abs(C(i,1) - C(j,1)); abs(C(i,2) - C(j,2))];
                startingpoint = [C(i,1) C(i,2)];
            end
        end
    end
    MajorAxis = diavec;
end

function [ FilledMatrix ] = FillRegion ( M )
    %Fills the region described by the binary matrix M with 0 for space
    %outside the region and 1 for space inside. 
    [m,n] = size(M);
    FilledMatrix = zeros(m,n); 
    for i = 1:n
        TimesCrossed = 0; %Number of times crossing the boundary
        for j = 1:m
            if j > 1 && j < m
                if (M(j,i) == 0 && M(j-1,i) == 1) && M(j+1,i) == 1
                    FilledMatrix(j,i) = 1;
                    TimesCrossed = TimesCrossed + 1;
                elseif M(j,i) == 0 && M(j-1,i) == 1
                    FilledMatrix(j,i) = 1;
                    TimesCrossed = TimesCrossed + 1;
                elseif (M(j,i) == 0 && M(j+1,i) == 1) && M(j-1,i) ~= 0
                    FilledMatrix(j,i) = 1;
                    TimesCrossed = TimesCrossed + 1;
                elseif M(j,i) == 0 && M(j-1,i) == 0
                    FilledMatrix(j,i) = 1;
                elseif mod(TimesCrossed,2) == 1
                    FilledMatrix(j,i) = 1;
                end
            else
                if M(j,i) == 0
                    FilledMatrix(j,i) = 1;
                    TimesCrossed = TimesCrossed + 1;  
                end
            end
        end
    end
end
