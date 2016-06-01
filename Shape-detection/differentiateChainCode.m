function dc = differentiateChainCode(chain_code)
    chain_code = chain_code';
    s = circshift(chain_code, [0, -1]); 

    delta = s - chain_code;
    d = delta; 
    I = find(delta < 0); 
    d(I) = d(I) + 8;
    dc = d;


end

