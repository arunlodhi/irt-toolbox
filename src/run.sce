clear
exec('loadAll.sce', -1);

tmax = 1.5
tmin = -1.5
itr= 10;
N = 20

M_i = 10;
M_f = 50;

dn = 10;
M_f = M_f - modulo((M_f-M_i),dn);
//NMs = (M_f-M_i)/dn;
//M_f = M_i+dn*(NMs-1);

// NMs =  int((M_f-M_i)/dn) + 1
// Ms = linspace(M_i,M_f,NMs);
Ms = M_i:dn:M_f;
NMs = size(Ms,2);


b_gen = zeros(N,1);
pool = linspace(-2.4,2.35,20);
for j = 1:N
    b_gen(j) = pool(int(19.5*rand())+1);
end

N=3;
b_gen = [-1; 0.2; 0.5; -0.3; 1];


// B_gen = zeros(N, NMs);
// B_out = B_gen;
eb = zeros(NMs, 1);
eb_all=[];

for p=1:itr
    i = 0;
    for M = M_i:dn:M_f
        i = i+1;
        t_gen = (tmax-tmin)*rand(M,1)-(tmax-tmin)/2;
        [U,b,t] = respGen(b_gen,t_gen,'given');
        //[U,b_gen,t_gen] = respGen(M,N,'dimen');
        [A,b_out,t_out] = testCalib(U, 0.05);
        eb(i) = rms((b_out-b_gen)./b_gen);
        //B_gen(:,i) = b_gen;
        //B_out(:,i) = b_out;
        clc
        disp(M,'No. of Examinees:',p,'Iteration:');
    end
    eb_all = [eb_all eb];
    p = p+1;
end

ebmean = mean(eb_all,2);
eberr = stdev(eb_all,2)/sqrt(itr);
disp([Ms' ebmean]);
clf;

errbar(Ms', ebmean, -eberr, eberr)

//plot(Ms',mean(eb_all,2),'bo');
