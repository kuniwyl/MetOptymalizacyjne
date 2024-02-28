function y = maximize_without_limit(N, L, C, F, h, y_fixed)
    cvx_begin quiet
        variable y(N + 1, 1);
       
        sum( norm([h; y(2:end) - y(1:end-1)])) <= L;
        % abs((y(3:end) - 2 * y(2:end-1) + y(1:end-2)) / h^2) <= C;
        y(1) == 0;
        y(N + 1) == 0;
        y(F) == y_fixed(F);
       
        maximize( h * sum(y) );
    cvx_end
end