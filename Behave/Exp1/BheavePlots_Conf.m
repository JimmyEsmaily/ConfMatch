clc;
clear;
close all;
%%
load Behave_SData.mat;
%%
Aindx = SData(:, end-1);
Lindx = find(mod(Aindx,2) == 0);
Hindx = find(mod(Aindx,2) == 1);
Cohs = [3.2, 6.4, 12.8, 25.6, 51.2];
NumSub = length(unique(SData(:, end)));


TmpData_Low = SData(Lindx, :);
for i=1:size(Cohs,2)
    cBin = find(TmpData_Low(:, 2) == Cohs(i));
    tmpdata = TmpData_Low(cBin,:);
    for si=1:NumSub
        sBin = find(tmpdata(:,end) == si);
        MeanVal_L(si,i) = mean(tmpdata(sBin, 1)/6);
    end
    SEMConfLow(i) = std(MeanVal_L(:,i))./sqrt(NumSub);
    LowConf(i) = mean(MeanVal_L(:,i));   
end


TmpData_High = SData(Hindx, :);
for i=1:size(Cohs,2)
    cBin = find(TmpData_High(:, 2) == Cohs(i));
    tmpdata = TmpData_High(cBin,:);
    for si=1:NumSub
        sBin = find(tmpdata(:,end) == si);
        MeanVal_H(si,i) = mean(tmpdata(sBin, 1)/6);
    end
    SEMConfHigh(i) = std(MeanVal_H(:,i))./sqrt(NumSub);
    HighConf(i) = mean(MeanVal_H(:,i));   
end


P{1} = plot(1:i,LowConf,'.-','Color',[1 .5 0],'MarkerSize',25,'LineWidth',2);
hold on;
MyErrorBar(1:i,LowConf,SEMConfLow,[1 .5 0]);

hold on;
P{2} = plot(1:i,HighConf,'.-','Color',[1 0 1],'MarkerSize',25,'LineWidth',2);
hold on;
MyErrorBar(1:i,HighConf,SEMConfHigh,[1 0 1]);

hold on;
set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Stimulus Strength (%coh)')
ylabel('Confidence');
lg.FontSize = 12;
xtick = [1:5];
xticklabe={'3.2%','','12.8%','','51.2%'};
set(gca,'XTick',xtick,'XTickLabel',xticklabe,'FontSize',12);
legend boxoff;
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
xlim([0 5.5]);
ylim([.2 1]);
%%
Cohs = SData(:,2);
Confs = SData(:,1);
Subs = SData(:,end);
Condition = SData(:,end-1);
Condition = mod(Condition,2);
MyTable = table(Subs,Cohs,Confs,Condition);

glme = fitglme(MyTable,...
    'Confs ~ 1+ Condition + Cohs + (1|Subs)',...
    'Distribution','Normal','Link','identity','FitMethod','MPL',...
    'DummyVarCoding','effects')
[glme.Coefficients.Estimate(2:end),glme.Coefficients.SE(2:end),...
    glme.Coefficients.Lower(2:end),glme.Coefficients.Upper(2:end),...
    glme.Coefficients.tStat(2:end),glme.Coefficients.pValue(2:end)]
