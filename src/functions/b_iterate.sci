function y = b_iterate(b, t, Ur)
    Nr = length(b);
    S = (sum(Ur,1));
    
    r = 1:Nr-1;
    p = prob(b,t);
    n = num(r,Ur);
    sum1 = (sum((n*p),1));
    sum2 = (sum((n*(p.*(1-p))),1));
    
    y = b - ((S-sum1)./sum2)';

//    for i = 1:Nr
//        sum1 = 0;
//        sum2 = 0;
//        for r = 1:Nr-1
//            p = prob(b(i), t(r));
//            n = num(r, Ur);
//            sum1 = sum1 + n*p;
//            sum2 = sum2 + n*p*(1-p);
//        end
//        b(i) = b(i) - ((S(i)-sum1)/sum2);
//    end
//    y = b;

endfunction
