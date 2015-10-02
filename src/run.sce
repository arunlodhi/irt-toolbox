clear
exec('loadAll.sce', -1);

itr= 25;
N = 20
M_i = 5;
M_f = 120;
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
// B_gen = zeros(N, NMs);
// B_out = B_gen;
eb = zeros(NMs, 1);
eb_all=[];

for p=1:itr
    i = 0;
    for M = M_i:dn:M_f
        i = i+1;
        t_gen = 6*rand(M,1)-3;
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

disp([Ms' mean(eb_all,2)]);
clf;
plot(Ms',mean(eb_all,2),'bo');
