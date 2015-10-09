function y = t_iterate(t, b)
    Nr = size(b,1);
    for r = 1:Nr-1
        sum1 = 0;
        sum2 = 0;
        for i = 1:Nr
            p = prob(b(i), t(r));
            sum1 = sum1 + p;
            sum2 = sum2 + p*(1-p);
        end
        t(r) = t(r) + ((r-sum1)/sum2);
    end
    y = t;
endfunction
