function [ shape ] = DetermineNoisyShape( Properties )
%DetermineNoisyShapes tries to find the shape of a noisy object.
    Rectangularity = Properties(1).area/Properties(1).EncA;
    
    if Rectangularity <= 1 &&  Rectangularity > 0.95
        if Properties(1).EncL == Properties(1).EncH
            disp('The shape is a square');
        else
            disp('The shape is a rectangle');
        end
    elseif Rectangularity < ((pi/4) + (pi/40)) && Rectangularity < ((pi/4) + (pi/40))
        if Properties(1).EncL == Properties(1).EncH
            disp('The shape is a circle');
        else
            disp('The shape is a ellipse');
        end
    else
        disp('The shape cannot be determined')
        



end

