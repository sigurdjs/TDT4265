function nr_of_vertices = computeNrOfVertices( chain_code)

chain_code = [ chain_code(20:end); chain_code(1:19) ];
chain_code_degrees = convertChainCode2Degrees( chain_code );
subplot(1,3,1)
plot(chain_code_degrees)

angle_of_attack    = computeAngleOfAttack( chain_code_degrees );
subplot(1,3,2)
plot( angle_of_attack )

diff_aoa = diff(angle_of_attack);
subplot(1,3,3)
plot( diff_aoa )

nr_of_vertices = 0;
count = 100;
for i = 1:length(diff_aoa)
    if diff_aoa(i) ~= 0 && count > 20
       count = 0;
       nr_of_vertices = nr_of_vertices + 1; 
    end
    count = count + 1;
end
end

function angle_of_attack = computeAngleOfAttack( chain_code )

len = length( chain_code );
angle_of_attack = nan(len,1);

list = [];
start = 1;
for i = 1:len
    if ~ismember( chain_code(i), list )
       list = [ list chain_code(i) ]; 
    end
    
    if length(list) == 3
       list = [];
       j = i - 1;
       most_freq_value = mode( chain_code(start:j) );
       mean_value = sum( chain_code(start:j) )/length( chain_code(start:j));
       
       if ( mean_value < most_freq_value + 15) || ( mean_value < most_freq_value-15)
          angle_of_attack(start:j) = most_freq_value; 
       else
            angle_of_attack(start:j) = mean_value;
       end
       start = i;
    end
end

most_freq_value = mode( chain_code(start:end) );
mean_value = sum( chain_code(start:end))/length( chain_code(start:end));
       
if ( mean_value < most_freq_value + 15) || ( mean_value > most_freq_value-15)
    angle_of_attack(start:end) = most_freq_value; 
else
    angle_of_attack(start:end) = mean_value;
end
end

function chain_code_degrees = convertChainCode2Degrees( chain_code )

chain_code_degrees = nan( length(chain_code), 1);
for i = 1:length(chain_code)
   switch( chain_code(i) )
       case 0
           chain_code_degrees(i) = 90;
       case 1
           chain_code_degrees(i) = 45;
       case 2
           chain_code_degrees(i) = 0;
       case 3
           chain_code_degrees(i) = 315;
       case 4
           chain_code_degrees(i) = 270;
       case 5
           chain_code_degrees(i) = 225;
       case 6
           chain_code_degrees(i) = 180;
       case 7
           chain_code_degrees(i) = 135;
   end
end
end