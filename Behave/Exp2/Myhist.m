function Myhist(X)
Bin = -.3:0.01:.5;
index = ones(1,size(Bin,2));
Ybin = 0.1;
for i=1:size(X,2)
    hold on;
    plot(X(i),index(i)*Ybin,'k.','MarkerSize',30);
    
end

end