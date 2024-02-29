function y = maximize_with_limit(N, L, C, F, h, y_fixed)
    cvx_begin quiet
        variable y(N + 1, 1);
       
        total_len = 0;
        for i = 1:N
            total_len = total_len + norm([h; y(i + 1) - y(i)]);
        end
        total_len <= L;
        %sum( norm([h; y(2:end) - y(1:end-1)], 1)) <= L;
        abs((y(3:end) - 2 * y(2:end-1) + y(1:end-2)) / h^2) <= C;
        y(1) == 0;
        y(N + 1) == 0;
        y(F) == y_fixed(F);
       
        maximize( h * sum(y) );
    cvx_end
end