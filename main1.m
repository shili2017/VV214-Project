INF = 99999;
DETAILS = 0;
THRESHOLD = 3;

f0 = fopen('gate.txt', 'r');
readTmp = fscanf(f0, "%d");
fclose(f0);
numGate = readTmp(1);
g = readTmp(2 : numGate + 1);

f1 = fopen('road.txt', 'r');
readTmp = fscanf(f1, "%d");
fclose(f1);
numVertex = readTmp(1);
numEdge = readTmp(2);
l = zeros(numVertex);       % length of roads
w = zeros(numVertex);       % width of roads
for i = 1 : numEdge
    l(readTmp(4*i-1),readTmp(4*i)) = readTmp(4*i+1);
    l(readTmp(4*i),readTmp(4*i-1)) = readTmp(4*i+1);
    w(readTmp(4*i-1),readTmp(4*i)) = readTmp(4*i+2);
    w(readTmp(4*i),readTmp(4*i-1)) = readTmp(4*i+2);
end
t = l;                      % same as l, but 0 -> INF
for i = 1 : numVertex
    for j = 1 : numVertex
        if t(i,j) == 0
            t(i,j) = INF;
        end
    end
end
v = l .* w;                 % volumn or capacity of roads
c = zeros(numVertex);       % current traffic flow

% floyd algorithm
path = zeros(numVertex);    % shortest path
dist = t;                   % shortest distance between two vertices
for k = 1 : numVertex
    for i = 1 : numVertex
        for j = 1 : numVertex
            if dist(i,k) + dist(k,j) < dist(i,j)
                dist(i,j) = dist(i,k) + dist(k,j);
                path(i,j) = k;
            end
        end
    end
end

f2 = fopen('common.txt', 'r');
readTmp = fscanf(f2, "%d");
fclose(f2);

numCommon = readTmp(1);
for i = 1 : numCommon
    tmpStart = readTmp(3*i-1);
    tmpEnd   = readTmp(3*i);
    tmpFlow  = readTmp(3*i+1);
    c = recordPath(v,c,path,tmpStart,tmpEnd,tmpFlow);
end

f3 = fopen('event.txt', 'r');
readTmp = fscanf(f3, "%d");
fclose(f3);

numEvent = readTmp(1);
for i = 1 : numEvent
    tmpStart = readTmp(3*i-1);
    tmpEnd   = readTmp(3*i);
    tmpFlow  = readTmp(3*i+1);
    c = recordPath(v,c,path,tmpStart,tmpEnd,tmpFlow);
end

clc;
disp('Before Optimization');
showTraffic(c,v,numVertex,DETAILS);

% --------------Before One-way Optimization (Above)-----------------

% --------------After  One-way Optimization (Below)-----------------

opt = optimize(c,v,numVertex,g,THRESHOLD);
numOpt = size(opt,1);
t_opt = t;
v_opt = l;
for i = 1 : numOpt
    t_opt(opt(i,2),opt(i,1)) = INF;
    v_opt(opt(i,1),opt(i,2)) = v(opt(i,1),opt(i,2)) * 2;
    v_opt(opt(i,2),opt(i,1)) = 0;
end
c_opt = zeros(numVertex);   % optimized traffic flow

% floyd algorithm applied to optimized network
path_opt = zeros(numVertex);    % shortest path
dist_opt = t_opt;               % shortest distance between two vertices
for k = 1 : numVertex
    for i = 1 : numVertex
        for j = 1 : numVertex
            if dist_opt(i,k) + dist_opt(k,j) < dist_opt(i,j)
                dist_opt(i,j) = dist_opt(i,k) + dist_opt(k,j);
                path_opt(i,j) = k;
            end
        end
    end
end

f2 = fopen('common.txt', 'r');
readTmp = fscanf(f2, "%d");
fclose(f2);

numCommon = readTmp(1);
for i = 1 : numCommon
    tmpStart = readTmp(3*i-1);
    tmpEnd   = readTmp(3*i);
    tmpFlow  = readTmp(3*i+1);
    c_opt = recordPath(v_opt,c_opt,path_opt,tmpStart,tmpEnd,tmpFlow);
end

f3 = fopen('event.txt', 'r');
readTmp = fscanf(f3, "%d");
fclose(f3);

numEvent = readTmp(1);
for i = 1 : numEvent
    tmpStart = readTmp(3*i-1);
    tmpEnd   = readTmp(3*i);
    tmpFlow  = readTmp(3*i+1);
    c_opt = recordPath(v_opt,c_opt,path_opt,tmpStart,tmpEnd,tmpFlow);
end
disp('After Optimization');
showTraffic(c_opt,v_opt,numVertex,DETAILS);

