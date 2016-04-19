function [Properties] = ObjectProperties( chaincode , coordinates,M)
% This function calculates important properties of B such as 
% contour length, enclosed area, ..  
    Properties(1).length = FindLength(chaincode);
    Properties(1).area = FindArea(chaincode);
    Properties(1).compactness = (Properties(1).length)^2/(4*pi*Properties(1).area);
    [Properties(1).comx ,Properties(1).comy] = CenterOfMass(chaincode,Properties(1).area);
%     Properties(1).majoraxis = MajorAxis(coordinates);
%     Properties(1).minoraxis = [0 -1; 1 0]*Properties(1).majoraxis;
%     Properties(1).FilledRegion = FillRegion(chaincode,coordinates,M);
%     Properties(1).LMOIangle = LeastMomentOfInertia(Properties(1).FilledRegion,Properties(1).comx,Properties(1).comy);
    [Properties(1).EncL,Properties(1).EncH,Properties(1).EncA,Properties(1).figure] = EnclosingRectangle(coordinates);
    Properties(1).NumOfEndpoints = findEndpoints(coordinates,chaincode);
    
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
% Calculates center of mass (x,y) in pixels  
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
        %Down and right
        elseif B(i) == 3
            sum = sum + value;
            x = x + 1;
            value = value + (x -0.5);
        %Left and down
        elseif B(i) == 5
            value = value - (x -0.5);
            x = x - 1;
            sum = sum + value;
        %Up and left
        elseif B(i) == 7
            sum = sum -value;
            value = value - (x -0.5);
            x = x - 1;
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

% function [ Filled ] = FillRegion ( B, C ,M)
%     %Fills the region described by the chain-codes C
%     [m,n] = size(M);
%     Filled = zeros(m,n);
%     x = 1;  y = 1;
%     len = length(B); 
%     for i = 1:len
%         if B(i) == 2
%             Filled(1:y,x) = 1;
%             x = x+1;
%         elseif B(i) == 6
%             Filled(1:y,x) = 0;
%             x = x-1;
%         elseif B(i) == 1
%             Filled(1:y,x) = 1;
%             x = x+1;    y =y+1;
%         elseif B(i) == 3
%             Filled(1:y,x) = 1;
%             x = x+1;    y =y-1;
%         elseif B(i) == 5
%             Filled(1:y,x) = 0;
%             x = x-1;    y =y-1;
%         elseif B(i) == 7
%             Filled(1:y,x) = 0;
%             x = x-1;    y =y+1;
%         elseif B(i) == 0
%             Filled(y,x) = 1;
%             y = y+1;
%         elseif B(i) == 4
%             Filled(y,x) = 1;
%             y = y-1;       
%         end
%     end
%     Filled(1:y,x) = 0;
% %     for i = 1:m
% %         if any()
% end
%         
% function [ Angle ] = LeastMomentOfInertia (Filled,COMx,COMy)
%     Filled = flipud(Filled);
%     mu_11 = 0;  mu_20 = 0;  mu_02 = 0;
%     [m,n] = size(Filled);
%     for i = 1:m
%         for j = 1:n
%             if Filled(i,j) == 1
%                 mu_11 = mu_11 + ((i-COMy)*(j-COMx));
%                 mu_20 = mu_20 + ((j-COMx)^2);
%                 mu_02 = mu_02 + ((i-COMy)^2);
%             end
%         end
%     end
%     Angle = 0.5*atan((2*mu_11)/(mu_20-mu_02));
% end

function [ Length, Height, Area , Figure] = EnclosingRectangle(C)
    Length = 0; Height = 0; MinArea = 1e+10;
    for theta = 0:1:90
        vectors = RotateVectors(C,theta);
        x = vectors(:,1) +(-1*(min(vectors(:,1)))) +1;
        y = vectors(:,2) +(-1*(min(vectors(:,2)))) +1;
        Matrix = sparse(round(y),round(x),1);
        Matrix = full(Matrix);
        [m,n] = size(Matrix);
        if m*n < MinArea
            MinMatr = Matrix;
            MinArea = m*n;
            Height = m;
            Length = n;
        end
    end
    Area = Length*Height;
    MinMatr(1,:) = 1;
    MinMatr(end,:) = 1;
    MinMatr(:,1) = 1;
    MinMatr(:,end) = 1;
    Figure = MinMatr;
end
   

% function [ Matrix ] = RemoveZeroRowAndCol( M )
% %   Removes a column or row from Matrix if it consists only of zeros
%     Matrix = M; rowsToDelete = [];  colsToDelete = [];
%     [row,col] = size(M);
%     for i = 1:row
%         if ~any(M(i,:))
%             rowsToDelete = [rowsToDelete i];
%         end
%     end
%     for j = 1:col
%         if ~any(M(:,j))
%             colsToDelete = [colsToDelete j];
%         end
%     end
%     Matrix(rowsToDelete,:) = [];
%     Matrix(:,colsToDelete) = [];
% end


function [ Vectors ] = RotateVectors(vecs,angle)
%   Rotate the x-y vectors in vec by the angle defined in deg
    angle = deg2rad(angle);
    R = [cos(angle) -sin(angle); sin(angle) cos(angle)];
    for i = 1:length(vecs(:,1))
        vecs(i,:) = vecs(i,:)*R;
    end
    Vectors = vecs;
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
