clear

//Nitems = input('enter no. of items: ');
//Nexaminees = input ('enter no. of examinees: ');

N = 10;
M = 16;

t = 6.*rand(M,1)-3;
a = ones(N,1);
b = 3.*rand(N,1)-1.5;
c = zeros(N,1);

resp = zeros(M,N);

for alpha=1:M
    Palpha = c + (1-c)./(1+exp(-a.*(t(alpha)-b)));
    for i=1:N
        //p = 1/(1+exp(-(t(alpha)-b(i))));
        r = rand();
        if r <= Palpha(i);
            resp(alpha,i)=1;
        end
    end
end

fprintfMat('T_gen.tsv',t);
fprintfMat('B_gen.tsv',b);
fprintfMat('resp.tsv',resp);
