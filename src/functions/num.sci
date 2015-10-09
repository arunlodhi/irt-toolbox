// number of examinees with raw scores r
function y = num(r, A)
    len = length(r);
    f = r*0;
    S = sum(A,2);
    for i = 1:len
        f(i) = length(find(S == r(i)));
    end
    y = f;
endfunction
