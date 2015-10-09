function [Ur, B, T] = testCalib(resp, tol, options)
    // U => Response Matrix
    // B => Difficulty Parameters
    // T => Ability Parameters
    // resp => response Matrix
    // tol => tolerance
    // options => filemode, strict Convergence, display iterations
    
    if argn(2) == 2 then
        options = [0, 1, 0];
    end
    
    fileMode = options(1);
    strictMode = options(2);
    displayItr = options(3);
    
    
    if fileMode == 0 then
        U = resp;
    elseif fileMode == 1 then
        U = fscanfMat(resp);
    end
    
    // eliminate exceptional cases
    [Ur, t0, b0, T, B] = reduce(U);
    [Mr, Nr] = size(Ur);
    
    if ~isempty(Ur) then
        // continue calculation
        // calculate row and column marginals
        S = sum(Ur, 1);
        R = sum(Ur, 2);
        
        // initialize ability and difficulty vectors
        //t = zeros(Nr-1,1);
        //b = zeros(Nr,1);
        r = (1:Nr-1)';
        t = log(r./(Nr-r));
        b = log((Mr-S')./S');
        
        // rebase b
        b = b - mean(b);
        
        if strictMode == 1 then
            errMax = tol;
        elseif strictMode == 0 then
            errMax = Nr*tol;
        end
        
        err = 2*errMax;
        itr = 0;
        
        // run till convergence
        while err > errMax
            itr = itr + 1;
            b1 = b;
            
            //difficulty parameter iteration
            b = b_iterate(t, b, Ur);
            //centering on 0
            b = b - mean(b);
            //ability parameter iteration
            t = t_iterate(t, b);
            
            err = sum(abs(b-b1));
            //err = sum(abs((b-b1)./b1));
        end
        
        if displayItr == 1 then    
            disp(itr, "Iterations: ");
        end
        
        // final scaling and iteration
        b = b.*((Nr-1)/Nr);
        t = t_iterate(t,b);
        t = t.*((Nr-2)/(Nr-1));
        
        // populate ability matrix
        a = t(sum(Ur,2));
        
        // match values to the original indexes
        T(t0) = a;
        B(b0) = b;
        
        //rounding to 2 decimal places
        T = round(T*100)/100;
        B = round(B*100)/100;
        
    end
    
    //delete temporary variables
    clear b1 err itr i r a t0 b0 M N t b
    
    //disp(T, "Examinee Ability:");
    //disp(B, "Item Difficulty:");
    //fprintfMat('T.tsv',T);
    //fprintfMat('B.tsv',B);

endfunction
