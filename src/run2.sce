clear
getd('functions');

b_max = 3;
b_min = -3;
itr= 30;
//M = 20;
tol = 0.05;
strict = 0;

N_i = 10;
N_f = 1000;
dn = 50;

N_f = N_f - modulo((N_f-N_i),dn);
Ns = N_i:dn:N_f;
NNs = size(Ns,2);

//pool = linspace(-2.4,2.35,M)';
//t_gen = pool(int((M-0.5)*rand(M,1))+1)

M=5;
t_gen = [-3; 1.2; 0.3; -1.2; 3];
//t_gen = [-1; 0.2; 0.5; -0.3; 1];

//et = zeros(NNs, 1);
et = zeros(1, itr);
et_all=[];

i = 0;
for N = N_i:dn:N_f
    i = i+1;
    for p=1:itr
        clc
        disp(p,'Iteration:',N,'No. of Questions:');
        b_gen = (b_max-b_min)*rand(N,1)+b_min;
        [U,b,t] = respGen(b_gen,t_gen,0);
        // testcalib(response, [tol file strict display])
        [A,b_out,t_out] = testCalib(U, tol, [0 strict 0]);
        et(p) = rms((t_out-t_gen)./t_gen)';
    end
    et_all = [et_all; et];
end

etmean = mean(et_all,2);
eterr = stdev(et_all,2)/sqrt(itr);
//disp([Ns' etmean]);
//fprintfMat('110-200.tsv',[Ns' etmean eterr],'%.3f');
clf;
plot(Ns',etmean,'bo');
xlabel('No. of Questions');
ylabel('Relative Error in Ability');
errbar(Ns', etmean, eterr, eterr);
