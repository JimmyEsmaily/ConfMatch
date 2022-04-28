function Pval = MyPerm(X,Y)
Bin = -.3:.001:2;
Ybin = 0:.001:.005;
figure
for i=1:1000
    perm = randperm(size(X,2));
    perm1 = randperm(size(X,2));
    Dist(i) = mean(abs(X(perm)- Y(perm1)));
end
pd = fitdist(Dist','Normal');
plot(Bin,normpdf(Bin,pd.mu,pd.sigma)./1000,'k','LineWidth',2)
hold on;
plot(mean(abs(X-Y))*ones(1,size(Ybin,2)),Ybin,'r','LineWidth',2)
hold on;
plot(pd.mu*ones(1,size(Ybin,2)),Ybin,'k-.','LineWidth',2)
hold on;
xlim([0 3]);
set(gca,'FontSize',12);

set(gcf,'color','w');
set(gca,'Box','off');
xlabel('Confidence Matching');
legend('Null Distribution','Observed Conf Matching','Mean','0.96%');
legend boxoff
ylabel('Probabilty');
[~,Pval] =  ttest(mean(abs(X-Y))*ones(1,size(Dist,2)),Dist);
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
end