// function for reducing the matrix
function [y, tr, br, T, B] = reduce(A)
    
    [M0,N0] = size(A);
    // indexes for storing candidate and question numbers
    tr = 1:M0;
    br = 1:N0;
    // final matrix to store candidate and question parameters
    T = zeros(M0,1);
    B = zeros(N0,1);
    
    A_old = [];
    while A_old ~= A
        [m,n] = size(A);
        
        // matrix to store exceptional examinees
        del1 = [];
        tmp1 = find(sum(A,2) == 0);
        T(tr(tmp1)) = -%inf;
        tmp2 = find(sum(A,2) == n);
        T(tr(tmp2)) = %inf;
        del1 = [tmp1 tmp2];
        
        // matrix to store exceptional questions
        del2 = [];
        tmp3 = find(sum(A,1) == 0);
        B(br(tmp3)) = %inf;
        tmp4 = find(sum(A,1) == m);
        B(br(tmp4)) = -%inf;
        del2 = [tmp3 tmp4];
        
        
        A_old = A;
        // deleting the corresponding rows & columns
        A(del1,:) = [];
        A(:,del2) = [];
        // deleing corresponding indices
        tr(del1) = [];
        br(del2) = [];
    end
    
    // return reduced dataset
    y = A;
endfunction
