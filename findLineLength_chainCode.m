function lineLength = findLineLength_chainCode(chainCode, endpoints)
        temp_length = zeros(length(endpoints),1); 
        
        if length(endpoints) < 2
            lineLength = -1;
            return
        end
        temp_length(1) = endpoints(2);
        for index = 2:length(endpoints)- 1
            temp_length(index) = endpoints(index+1) - endpoints(index);
        end
        
        temp_length(index+ 1) = length(chainCode) - endpoints(index+ 1);
        lineLength = temp_length;
        return
end