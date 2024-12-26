function indexRx = Decisore_MinDist(r, Cost)
M = length(Cost(:,1));

d_min = norm(r - Cost(1,:));
indexRx = 1;
for zz=2:M
    d_tmp = norm(r - Cost(zz,:));
    if(d_tmp < d_min)
        d_min = d_tmp;
        indexRx = zz;
    end           
end  