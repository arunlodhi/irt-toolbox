function [T, B, U] = testCalib(filename)
    // Read Response Matrix
    U = fscanfMat(filename);
    
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
            del1 = [];
            tmp1 = find(sum(A,2) == 0);
            T(t0(tmp1)) = -%inf;
            tmp2 = find(sum(A,2) == n);
            T(t0(tmp2)) = %inf;
            del1 = [tmp1 tmp2];
            
            // matrix to store exceptional questions
            del2 = [];
            tmp3 = find(sum(A,1) == 0);
            B(b0(tmp3)) = %inf;
            tmp4 = find(sum(A,1) == m);
            B(b0(tmp4)) = -%inf;
            del2 = [tmp3 tmp4];
            
            
            A_old = A;
            // deleting the corresponding rows & columns
            A(del1,:) = [];
            A(:,del2) = [];
            
            t0(del1) = [];
            b0(del2) = [];
        end
        
        // return reduced dataset
        y = A;
    endfunction
    
    // function to compact reduced matrix
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
    function y = num(r, A)
        f = find(sum(A,2) == r);
        y = size(f,2);
    endfunction
    
    
    function y = t_iterate(t, b)
        Nr = size(b,1);
        for r = 1:Nr-1
            sum1 = 0;
            sum2 = 0;
            for i = 1:Nr
                p = prob(t(r), b(i));
                sum1 = sum1 + p;
                sum2 = sum2 + p*(1-p);
            end
            t(r) = t(r) + ((r-sum1)/sum2);
        end
        y = t;
    endfunction
    
    
    function y = b_iterate(t, b)
        Nr = size(b,1);
        for i = 1:Nr
            sum1 = 0;
            sum2 = 0;
            for r = 1:Nr-1
                p = prob(t(r), b(i));
                sum1 = sum1 + num(r, Ur)*p;
                sum2 = sum2 + num(r, Ur)*p*(1-p);
            end
            b(i) = b(i) - ((S(i)-sum1)/sum2);
        end
        y = b;
    endfunction
    
    // eliminate exceptional cases
    [Ur, t0, b0, T, B] = reduce(U);
    
    [Mr, Nr] = size(Ur);
    
    // calculate row and column marginals
    S = sum(Ur, 1);
    R = sum(Ur, 2);
    
    // calculate frequency matrix
    //[R, scores] = compact(R);
    
    //number of examinees at a particular score
    //nr = rm./scores;
    
    // ability estimate associated with score of r
    t = zeros(Nr-1, 1);
    
    //difficulty estimate associated with item i
    b = zeros(Nr, 1);
    
    for r = 1:Nr-1
        t(r) = log(r/(Nr-r));
    end
    
    for i = 1:Nr
        b(i) = log((Mr-S(i))/S(i));
    end
    
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
    
    b = b.*((Nr-1)/Nr);
    
    disp(itr, "Iterations: ");
    
    t = t_iterate(t,b);
    t = t.*((Nr-2)/(Nr-1));
    
    // populate ability matrix
    for i = 1:Mr
        a(i) = t(sum(Ur(i,:),2));
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
    
    //disp(T, "Examinee Ability:");
    //disp(B, "Item Difficulty:");

endfunction
