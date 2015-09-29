function [U,b,t] = respGen(x,y,opmode)

if opmode == 'dimen' then
    //b_max = input("Max value of difficulty: ");
    //t_max = input("Max value of ability: ");
    b_max = 3;
    t_max = 3;
    M = x;
    N = y;
    t = 2*t_max*rand(M,1)-t_max;
    b = 2*b_max*rand(N,1)-b_max;
elseif opmode == 'given' then
    b = x;
    t = y;
    M = size(t,1);
    N = size(b,1);
end


a = ones(N,1);
c = zeros(N,1);

resp = zeros(M,N);
r = rand(M,N);
Prob = prob(b,t);
resp(find(r<Prob)) = 1;

U = resp;

//fprintfMat('T_gen.tsv',t);
//fprintfMat('B_gen.tsv',b);
//fprintfMat('resp.tsv',resp);

endfunction
