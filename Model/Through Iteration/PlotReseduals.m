clc;
clear;
close all;
%%
rng(1)
load Cohs.mat;
% load FinalMatch_15.mat;
load FinalZero_15.mat;

%%

for i=1:50
    Conf = [Allconf1(i,:)]';
    Coh = [Cohs]';
    tb = table(Conf,Coh);
    fit=fitlm(tb,'Conf ~ Coh');
    Allconf1(i,:) = fit.Coefficients.Estimate(1)+[fit.Residuals.Raw]';
    
    Conf = [Allconf2(i,:)]';
    Coh = [Cohs]';
    tb = table(Conf,Coh);
    fit=fitlm(tb,'Conf ~ Coh');
    Allconf2(i,:) = fit.Coefficients.Estimate(1)+[fit.Residuals.Raw]';
    
    
end

%%
Bin=10;
ERPCoeff = ones(1, Bin)/Bin;
tmpconf1 = mean(Allconf1/6,1);
tmpconf1 = [tmpconf1(1)*ones(1,Bin),tmpconf1];
tmpconf2 = mean(Allconf2/6,1);
tmpconf2 = [tmpconf2(1)*ones(1,Bin),tmpconf2];
meansig1 = filter(ERPCoeff, 1,tmpconf1);
meansig2 = filter(ERPCoeff, 1,tmpconf2);
figure,hold on;
tmpdata1 = meansig1(Bin+1:end);
tmpdata2 = meansig2(Bin+1:end);
P{1} = plot(1:200,tmpdata1,'-','Color',[1 0 1],'LineWidth',5);
hold on;
P{2} = plot(1:200,tmpdata2,'-','Color',[1 .5 0],'LineWidth',5);
Bin = 30;
ERPCoeff = ones(1, Bin)/Bin;
SEM1 = 1.96*std(Allconf1/6)/sqrt(size(Allconf1,1));
SEM2 = 1.96*std(Allconf2/6)/sqrt(size(Allconf2,1));

SEM1 = filter(ERPCoeff, 1,SEM1);
SEM2 = filter(ERPCoeff, 1,SEM2);
SEM1(1:Bin) = SEM1(Bin+1);
SEM2(1:Bin) = SEM2(Bin+1);
plotshaded(1:size(SEM1,2),[tmpdata1;tmpdata1-SEM1],[1 0 1]);
plotshaded(1:size(SEM1,2),[tmpdata1;tmpdata1+SEM1],[1 0 1]);
plotshaded(1:size(SEM2,2),[tmpdata2;tmpdata2-SEM2],[1 .5 0]);
plotshaded(1:size(SEM2,2),[tmpdata2;tmpdata2+SEM2],[1 .5 0]);

set(gcf,'color','w');
set(gca,'Box','off');
xlabel('Trial');
ylabel('Confidence (Residual)');
legend('Subject 1','Subject 2');
legend boxoff;
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);