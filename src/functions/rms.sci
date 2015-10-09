function y = rms(A)
    A = A.*A;
    y = sqrt((sum(A))/(size(A,1)*size(A,2)));
endfunction
