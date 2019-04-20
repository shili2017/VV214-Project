function c = recordPath(v,c,path,tmpStart,tmpEnd,tmpFlow)
    if v(tmpStart,tmpEnd) > 0
        c(tmpStart,tmpEnd) = c(tmpStart,tmpEnd) + tmpFlow;
    else
        mid = path(tmpStart,tmpEnd);
        c = recordPath(v,c,path,tmpStart,mid,tmpFlow);
        c = recordPath(v,c,path,mid,tmpEnd,tmpFlow);
    end
end