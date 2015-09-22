clear
// Read Response Matrix
U = fscanfMat("resp.tsv");
// function for reducing the matrix
function [y, t0, b0, T, B] = reduce(A)
    
    [M0,N0] = size(A);
    // indexes for storing candidate and question numbers
    t0 = 1:M0;
    b0 = 1:N0;
    // final matrix to store candidate and question parameters
    T = zeros(M0,1);
    B = zeros(N0,1);
    
    A_old = [];
    while A_old ~= A
        [m,n] = size(A);
        // matrix to store exceptional examinees
        tmp1 = [];
        for i = 1:m
            if sum(A(i,:)) == 0 then
                tmp1 = [tmp1 i];
                T(t0(i)) = -%inf;
            elseif sum(A(i,:)) == n then
                tmp1 = [tmp1 i];
                T(t0(i)) = %inf;
            end
        end
        
        // matrix to store exceptional questions
        tmp2 = [];
        for j = 1:n
            if sum(A(:,j)) == 0 then
                tmp2 = [tmp2 j];
                B(b0(j)) = %inf;
            elseif sum(A(:,j)) == m then
                tmp2 = [tmp2 j];
                B(b0(j)) = -%inf;
            end
        end
        
        A_old = A;
        // deleting the corresponding rows & columns
        A(tmp1,:) = [];
        A(:,tmp2) = [];
        
        t0(tmp1) = [];
        b0(tmp2) = [];
    end
    
    // return reduced dataset
    y = A;
endfunction

// function to calculate frequency matrix
function [y, s] = compact(A)
    [m,n] = size(A);
    resp = [];
    scores = [];
    for i = 0:n
        f = find(sum(A,2) == i);
        if ~isempty(f) then
            resp = [resp; sum(A(f,:),1)];
            scores = [scores; i];
        end
    end
    y = resp;
    s = scores;
endfunction

// Rasch Model
function y = prob(t, b)
    y = 1/(1+exp(-(t-b)));
endfunction

// number of examinees at a raw score r
function y = num(r)
    f = find(sum(U,2) == r);
    y = size(f,2);
endfunction

// ability parameter iteration
function y = t_iterate(t, b)
    for r = 1:N-1
        sum1 = 0;
        sum2 = 0;
        for i = 1:N
            p = prob(t(r), b(i));
            sum1 = sum1 + p;
            sum2 = sum2 + p*(1-p);
        end
        t(r) = t(r) + ((r-sum1)/sum2);
    end
    y = t;
endfunction

// difficulty parameter iteration
function y = b_iterate(t, b)
    for i = 1:N
        sum1 = 0;
        sum2 = 0;
        for r = 1:N-1
            p = prob(t(r), b(i));
            sum1 = sum1 + num(r)*p;
            sum2 = sum2 + num(r)*p*(1-p);
        end
        b(i) = b(i) - ((S(i)-sum1)/sum2);
    end
    y = b;
endfunction

// eliminate exceptional cases
[U, t0, b0, T, B] = reduce(U);

[M, N] = size(U);

// calculate row and column marginals
S = sum(U, 1);
R = sum(U, 2);

// calculate frequency matrix
//[R, scores] = compact(R);

//number of examinees at a particular score
//nr = rm./scores;

// ability estimate associated with score of r
t = zeros(N-1, 1);

//difficulty estimate associated with item i
b = zeros(N, 1);

//for r = 1:N-1
//    t(r) = log(r/(N-r));
//end

//for i = 1:N
//    b(i) = log((M-S(i))/S(i));
//end

b = b - mean(b);

err = 1;
itr = 0;

// run till convergence
while err > 0.01
    itr = itr + 1;
    b1 = b;
    
    //difficulty parameter iteration
    b = b_iterate(t, b);
    
    //centering on 0
    b = b - mean(b);
    
    //ability parameter iteration
    t = t_iterate(t, b);
    
    err = sum(abs(b1-b));
end

b = b.*((N-1)/N);

disp(itr, "Iterations: ");

t = t_iterate(t,b);
t = t.*((N-2)/(N-1));

// populate ability matrix
for i = 1:M
    a(i) = t(sum(U(i,:),2));
end

// matching values to the proper indexes
for i = 1:size(a,1)
    T(t0(i))= a(i);
end

for i = 1:size(b,1)
    B(b0(i))= b(i);
end

//rounding to 2 decimal places
T = round(T*100)/100;
B = round(B*100)/100;

//delete temporary variables
clear b1 err itr i r a t0 b0 M N t b

fprintfMat('T.tsv',T);
fprintfMat('B.tsv',B);

//disp(T, "Examinee Ability:");
//disp(B, "Item Difficulty:");
