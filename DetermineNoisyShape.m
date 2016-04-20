function [ shape ] = DetermineNoisyShape( Properties )
%DetermineNoisyShapes tries to find the shape of a noisy object.
    Rectangularity = Properties(1).area/Properties(1).EncA;
    disp(Rectangularity)
    
    if Rectangularity <= 1 &&  Rectangularity > 0.9
        if Properties(1).EncL == Properties(1).EncH
            disp('The shape is a square');
        else
            disp('The shape is a rectangle');
        end
    elseif (Rectangularity >= 0.49 && Rectangularity <= 0.51)
        disp('The shape is a triangle');
    elseif Rectangularity < ((pi/4) + (pi/300)) && Rectangularity > ((pi/4) - (pi/300))
        if Properties(1).EncL >= Properties(1).EncH-20 && Properties(1).EncL <= Properties(1).EncH+20
            disp('The shape is a circle');
        elseif Properties(1).EncH >= Properties(1).EncL-20 && Properties(1).EncH <= Properties(1).EncL+20
            disp('The shape is a circle');
        else
            disp('The shape is a ellipse');
        end
%         elseif Rectangularity > (pi/4) && Rectangularity < 0.95 
%             disp('The shape is a ellipse');
        else
            disp('The shape cannot be determined');
    end
end

