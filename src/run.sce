clear
getd('functions');

t_max = 3;
t_min = -3;
itr= 50;
N = 10;
tol = 0.05;

M_i = 10;
M_f = 5000;
dn = 50;

M_f = M_f - modulo((M_f-M_i),dn);
Ms = M_i:dn:M_f;
NMs = size(Ms,2);

//b_gen = zeros(N,1);
//pool = linspace(-2.4,2.35,N);
//for j = 1:N
//    b_gen(j) = pool(int((N-0.5)*rand())+1);
//end

N=5;
b_gen = [-3; 1.2; 0.3; -1.2; 3];
//b_gen = [-1; 0.2; 0.5; -0.3; 1];

eb = zeros(1, itr);
eb_all=[];


i = 0;
for M = M_i:dn:M_f
    i = i+1;
    for p=1:itr
        clc
        disp(p,'Iteration:', M, 'No. of Examinees:');
        t_gen = (t_max-t_min)*rand(M,1)+t_min;
        [U,b,t] = respGen(b_gen,t_gen,0);
        // testcalib(response, [tol file strict display])
        [A,b_out,t_out] = testCalib(U, tol, [0 1 0]);
        eb(p) = rms((b_out-b_gen)./b_gen);
    end
    eb_all = [eb_all;eb];
end

ebmean = mean(eb_all,2);
eberr = stdev(eb_all,2)/sqrt(itr);
//disp([Ms' ebmean], "Ms   ebmean");
clf;
plot(Ms',ebmean,'bo');
xlabel('No. of Examinees');
ylabel('Relative Error in Difficulty')
errbar(Ms', ebmean, eberr, eberr);
