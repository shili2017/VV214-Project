function opt = optimize(c,v,numVertex,g,threshold)
    tmp = [];
    for i = 1 : numVertex
        for j = 1 : numVertex
            flag = false;
            for k = 1 : size(g)
                if i == g(k) || j == g(k)
                    flag = true;
                end
            end
            if flag 
                continue;
            end
            if c(i,j) > v(i,j) && v(i,j) > 0 && c(i,j) > threshold*c(j,i)
                tmp = [tmp ; [i j]];
            end
        end
    end    
    opt = tmp;
end