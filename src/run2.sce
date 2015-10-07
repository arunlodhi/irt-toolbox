clear
exec('loadAll.sce', -1);

bmax = 1.5
bmin = -1.5
itr= 50;
M = 20

N_i = 10;
N_f = 100;

dn = 10;
N_f = N_f - modulo((N_f-N_i),dn);
//NMs = (M_f-M_i)/dn;
//M_f = M_i+dn*(NMs-1);

// NMs =  int((M_f-M_i)/dn) + 1
// Ms = linspace(M_i,M_f,NMs);
Ns = N_i:dn:N_f;
NNs = size(Ns,2);


t_gen = zeros(M,1);
pool = linspace(-2.4,2.35,20);
for j = 1:M
    t_gen(j) = pool(int(19.5*rand())+1);
end

M=5;
t_gen = [-1; 0.2; 0.5; -0.3; 1];


// B_gen = zeros(N, NMs);
// B_out = B_gen;
eb = zeros(NNs, 1);
eb_all=[];

for p=1:itr
    i = 0;
    for N = N_i:dn:N_f
        i = i+1;
        b_gen = (bmax-bmin)*rand(N,1)-(bmax-bmin)/2;
        [U,b,t] = respGen(b_gen,t_gen,'given');
        //[U,b_gen,t_gen] = respGen(M,N,'dimen');
        [A,b_out,t_out] = testCalib(U, 0.05);
        eb(i) = rms((t_out-t_gen)./t_gen);
        //B_gen(:,i) = b_gen;
        //B_out(:,i) = b_out;
        clc
        disp(N,'No. of Questions:',p,'Iteration:');
    end
    eb_all = [eb_all eb];
    //p = p+1;
end

ebmean = mean(eb_all,2);
eberr = stdev(eb_all,2)/sqrt(itr);
disp([Ns' ebmean]);
clf;

plot(Ns',ebmean,'bo');
xlabel('No. of Questions');
ylabel('Relative Error in Ability');
errbar(Ms', ebmean, eberr, eberr);

