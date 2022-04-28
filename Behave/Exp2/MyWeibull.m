clc;
%% 1- 1/2e-(c/a)^b
% figure;
coh = [3.2 6.4 12.8 25.6 51.2];
coh=log(coh)/log(2);
modelFun =  @(p,x) 1- 1/2*(exp(-(x./p(1)).^p(2)));
startingVals = [1 5];
coefEsts = nlinfit(coh(1:5), Means(2:6), modelFun, startingVals);
xgrid = linspace(1.6,10,100);
if color=='b'
    P{1}=plot(coh(1:5),Means(2:6),'.','Color',[1 0 1],'MarkerSize',25);
else
    P{2}=plot(coh(1:5),Means(2:6),'.','Color',[1 .5 0],'MarkerSize',25);
end

hold on;

if color=='b'
plot(xgrid,modelFun(coefEsts, xgrid),'-','Color',[1 0 1],'LineWidth',2);
MyErrorBar(coh(1:5),Means(2:6),Error_Bar_E(1,1:5),[1 0 1]);

else
    plot(xgrid,modelFun(coefEsts, xgrid),'-','Color',[1 .5 0],'LineWidth',2);
    MyErrorBar(coh(1:5),Means(2:6),Error_Bar_E(1,1:5),[1 .5 0]);

end
hold on;
ZeroCor = .6781;
Bin = [ZeroCor-.15,ZeroCor+.15];
xlim([0.8 max(coh)+0.2]);
ylim([0.5 1]);
xtick=[coh];
set(gca,'xtick',xtick);
xticklabel={'1.6%';'';'6.4%';'';'25.6%'};
set(gca,'xticklabel',xticklabel,'FontSize',12);
ylabel('Probability Correct','FontSize',12);
xlabel('Motion Strength (%Coh)','FontSize',12);
set(gca,'Box','off');
set(gcf,'color','w');


%%