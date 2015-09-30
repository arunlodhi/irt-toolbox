clear all
clf

N = 20
M_i = 10 ;
M_f = 20;
dn = 2;
NMs =  int((M_f-M_i)/dn) + 1

Ms = linspace(M_i,M_f,NMs)
B_gen = zeros(N, NMs);
B_out = B_gen;
// eb = zeros(M_f-M_i+1, 1);
i = 0;
for M = M_i:dn:M_f
    i = i+1;
    [U,b_gen,t_gen] = respGen(M,N,'dimen');
    [A,b_out,t_out] = testCalib(U, 0.5);
    eb(i) = rms( (b_out-b_gen)./b_gen);
    B_gen(:,i) = b_gen;
    B_out(:,i) = b_out;
    clc
    disp(M,'No. of Examinees: ');
end

disp([Ms' eb])
plot(Ms',eb,'bo');
