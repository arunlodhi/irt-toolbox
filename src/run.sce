N = 10
M_i = 11;
M_f = 110;
B_gen = zeros(N, M_f-M_i+1);
B_out = B_gen;
eb = zeros(M_f-M_i+1, 1);
for M = M_i:M_f
    [U,b_gen,t_gen] = respGen(M,N,'dimen');
    [A,b_out,t_out] = testCalib(U, 0.5);
    eb(M-M_i+1) = rms(b_out-b_gen)./sum(b_gen);
    B_gen(:,M-M_i+1) = b_gen;
    B_out(:,M-M_i+1) = b_out;
    clc
    disp(M,'No. of Examinees: ');
end

plot([M_i:M_f]',eb);
