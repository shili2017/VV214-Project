INF = 99999;
DETAILS = 1;
BUSCAPACITY = 50;
BUSVOLUME = 3;


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

% --------------Before Bus Optimization (Above)-----------------

% --------------After  Bus Optimization (Below)-----------------

c_opt = zeros(numVertex);   % optimized traffic flow

f2 = fopen('common.txt', 'r');
readTmp = fscanf(f2, "%d");
fclose(f2);

numCommon = readTmp(1);
for i = 1 : numCommon
    tmpStart = readTmp(3*i-1);
    tmpEnd   = readTmp(3*i);
    tmpFlow  = readTmp(3*i+1);
    c_opt = recordPath(v,c_opt,path,tmpStart,tmpEnd,tmpFlow);
end

f3 = fopen('event.txt', 'r');
readTmp = fscanf(f3, "%d");
fclose(f3);

numEvent = readTmp(1);
busCount = 0;
for i = 1 : numEvent
    tmpStart = readTmp(3*i-1);
    tmpEnd   = readTmp(3*i);
    tmpFlow  = readTmp(3*i+1);
    if tmpFlow > BUSCAPACITY
        tmpFlow = fix(tmpFlow / BUSCAPACITY) * BUSVOLUME + rem(tmpFlow, BUSCAPACITY);
        busCount = busCount + 1;
        disp(['Shuttle bus ' num2str(busCount) ' from vertex ' num2str(tmpStart) ' to vertex ' num2str(tmpEnd)]);
    end
    c_opt = recordPath(v,c_opt,path,tmpStart,tmpEnd,tmpFlow);
end
disp('After Optimization');
showTraffic(c_opt,v,numVertex,DETAILS);

