function showTraffic(c,v,numVertex,DETAILS)
    disp('****************************************');
    countWarning = 0;
    countError = 0;
    for i = 1 : numVertex
        for j = 1 : numVertex
            if c(i,j) >= 0.5 * v(i,j) && c(i,j) <= v(i,j) && v(i,j) > 0
                if DETAILS == 1
                    disp(['Warning: ' num2str(i) ' ' num2str(j) ' ' num2str(c(i,j)) '/' num2str(v(i,j))]);
                end
                countWarning = countWarning + 1;
            elseif c(i,j) > v(i,j) && v(i,j) > 0
                if DETAILS == 1
                    disp(['Error: ' num2str(i) ' ' num2str(j) ' ' num2str(c(i,j)) '/' num2str(v(i,j))]);
                end
                countError = countError + 1;
            end
        end
    end
    disp(['#Warning: ', num2str(countWarning), ' #Error: ', num2str(countError)]);
    disp('****************************************');
end