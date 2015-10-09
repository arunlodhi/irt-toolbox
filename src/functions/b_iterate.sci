function y = b_iterate(t, b, Ur)
    Nr = size(b,1);
    for i = 1:Nr
        sum1 = 0;
        sum2 = 0;
        for r = 1:Nr-1
            p = prob(b(i), t(r));
            n = num(r, Ur);
            sum1 = sum1 + n*p;
            sum2 = sum2 + n*p*(1-p);
        end
        b(i) = b(i) - ((S(i)-sum1)/sum2);
    end
    y = b;
endfunction
