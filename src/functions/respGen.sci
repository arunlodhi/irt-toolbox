function [U,b,t] = respGen(x,y,options)
    
    bt_gen = options(1);
    
    if bt_gen == 0 then
        b = x;
        t = y;
        M = size(t,1);
        N = size(b,1);
    elseif bt_gen == 1 then
        //b_max = input("Max value of difficulty: ");
        //t_max = input("Max value of ability: ");
        b_max = 3;
        b_min = -3;
        t_max = 3;
        t_min = -3;
        M = x;
        N = y;
        t = (t_max-t_min)*rand(M,1)+t_min;
        b = (b_max-b_min)*rand(N,1)+b_min;
    end
    
    
    a = ones(N,1);
    c = zeros(N,1);
    
    resp = zeros(M,N);
    r = rand(M,N);
    p = prob(b,t);
    resp(find(r < p)) = 1;
    
    U = resp;
    
    //fprintfMat('T_gen.tsv',t);
    //fprintfMat('B_gen.tsv',b);
    //fprintfMat('resp.tsv',resp);

endfunction
