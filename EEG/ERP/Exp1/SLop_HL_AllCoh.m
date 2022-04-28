clc;
clear;
close all;
%%
load SData.mat;

%%


NN = [13:16];

time = -200:1000;
AnTime = [-200:600];
TimeBin = dsearchn(time',AnTime');

XBin = AnTime;
TimeStep = 5;
TimeWin = 100;
BLine = dsearchn(time',[-100:0]');
BLine1 = dsearchn(TimeBin,BLine);
Data_S = squeeze(mean(AllData_S(NN,TimeBin,:),1));
Data_S = bsxfun(@minus,Data_S, mean(Data_S(BLine1,:)));

Bin = 20;
ERPCoeff = ones(1, Bin)/Bin;

for i=1:size(Data_S,2)
        Data_S(:,i) = filter(ERPCoeff, 1,Data_S(:,i));

end


BadRecords = DeleteBadRecord(Data_S);
Allinfo_S(BadRecords,:) = [];
Data_S(:,BadRecords) = [];

allsub_I = Allinfo_S(:,end);
CohData_I = Allinfo_S(:,2);
TBin = dsearchn(AnTime',[0:4:500]');
for ti = 1:size(Data_S,2)
        tfit = fitlm(TBin',zscore(Data_S(TBin,ti)));
        Slope_S(ti) = tfit.Coefficients.Estimate(2)*1000;
    
end


High_Indx = find(mod(Allinfo_S(:,8), 2)==1);
Low_Indx = find(mod(Allinfo_S(:,8), 2)==0);

Slope_H = Slope_S(High_Indx);
Slope_L = Slope_S(Low_Indx);

Slops = [mean(Slope_H),mean(Slope_L)];
SEM = [std(Slope_H)/sqrt(length(Slope_L)),...
    std(Slope_H)/sqrt(length(Slope_L))];
%%
figure, hold on;
PP = bar(1,mean(Slope_H),.4);
PP.FaceColor = [1 0 1];
PP.LineWidth = 2;

PP = bar(2,mean(Slope_L),.4);
PP.FaceColor = [1 .5 0];
PP.LineWidth = 2;
MyErrorBar(1,mean(Slope_H),1.96*std(Slope_H)/sqrt(length(Slope_H)),'k-');
MyErrorBar(2,mean(Slope_L),1.96*std(Slope_H)/sqrt(length(Slope_H)),'k-');

plot([1, 2], [4.8, 4.8], 'k-','LineWidth', 2);
text(1.4, 5, '**', 'FontSize', 30);
xtick = [1:2];
xticklabl = {'HCA', 'LCA'};
set(gca,'XTick',xtick,'XTickLabel',xticklabl);
set(gca,'Box','off');
set(gcf,'Color','w');
ylabel('Norm. Slope(\muV/s)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
%
Cohs = [3.2,6.4,12.8,25.6, 51.2];
CohArray_L = Allinfo_S(Low_Indx,2);
for i=1:size(Cohs,2)
    TData = Slope_L(CohArray_L==Cohs(i));
    SlopCoh_L(i) = mean(TData);
    SEM_L(i) = std(TData)/sqrt(size(find(CohArray_L==Cohs(i)),1));
end
%
CohArray_H = Allinfo_S(High_Indx,2);
for i=1:size(Cohs,2)
    TData = Slope_H(CohArray_H==Cohs(i));
    SlopCoh_H(i) = mean(TData);
    SEM_H(i) = std(TData)/sqrt(size(find(CohArray_H==Cohs(i)),1));
end
%
close all;
figure, hold on;
for i=1:5
    TmpMean = [SlopCoh_L(i),SlopCoh_H(i)];
    TmpSEM = [SEM_L(i),SEM_H(i)];
    PP = bar([i],TmpMean(1),.3);
    PP.FaceColor = [1 .5 0];
    PP.LineWidth = 2;

    P=bar([i+.3],TmpMean(2),.3);
    P.FaceColor = [1 0 1];
    P.LineWidth = 2;
    
    MyErrorBar([i],TmpMean(1),TmpSEM(1),'k-');
    MyErrorBar([i+.3],TmpMean(2),TmpSEM(2),'k-');
    
    
    
end
legend([PP,P],{'LCA','HCA'});
legend boxoff;
xtick = [1:5];
xticklabl = {'3.2','6.4','12.8','25.6','51.2'};
set(gca,'XTick',xtick,'XTickLabel',xticklabl);
set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Motion Strength (%)');
ylabel('Slope(\muV/s)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
%% GLMM

Cohs = zscore([Allinfo_S(High_Indx,2);Allinfo_S(Low_Indx,2)]);
slopes = [Slope_H';Slope_L'];
Subs = [Allinfo_S(High_Indx,end);Allinfo_S(Low_Indx,end)];
Condition = 1*ones(length(Allinfo_S),1);
Condition(1:length(High_Indx)) = 2;

Condition = Condition./max(Condition);
Cohs = Cohs./max(Cohs);
MyTable = table(Subs,Cohs,slopes,Condition);

glme = fitglme(MyTable,...
		'slopes ~ 1 + Condition + Cohs + (1|Subs)',...
		'Distribution','Normal','Link','identity','FitMethod','MPL',...
		'DummyVarCoding','effects')

Stat = [glme.Coefficients.Estimate(2:end),glme.Coefficients.SE(2:end),...
    glme.Coefficients.Lower(2:end),glme.Coefficients.Upper(2:end),...
    glme.Coefficients.tStat(2:end),glme.Coefficients.pValue(2:end)]



%
figure, hold on;


PP = bar(1,glme.Coefficients.Estimate(2),.3);
PP.FaceColor = [0 .5 1];
PP.LineWidth = 2;

P=bar(2,glme.Coefficients.Estimate(3),.3);
P.FaceColor = [0 .5 1];
P.LineWidth = 2;

MyErrorBar_CI(1,glme.Coefficients.Estimate(2), glme.Coefficients.Lower(2),glme.Coefficients.Upper(2),'k-', 1);
MyErrorBar_CI(2,glme.Coefficients.Estimate(3), glme.Coefficients.Lower(3),glme.Coefficients.Upper(3),'k-', 1);
    

xtick = [1:2];
xticklabl = {'Coherence', 'Condition'};
set(gca,'XTick',xtick,'XTickLabel',xticklabl);
set(gca,'Box','off');
set(gcf,'Color','w');

ylabel('\beta Values (a.u.)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);