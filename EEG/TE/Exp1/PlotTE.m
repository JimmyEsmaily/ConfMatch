clc;
clear;
close all;
%%
load TE_Data.mat;
load Lap_SData.mat
%%
MeanI = squeeze(mean(I,1,'omitnan'));
%%
[MaxLag,MaxLagIndx] = max(mean(MeanI,2,'omitnan'));


%% Mean On Lag 
close all;
Bin = 80;
XBin = -199+Bin:600;

time = -200:1000;
AnTime = [-200:999];
TimeBin = dsearchn(time',AnTime');

XBin = time(TimeBin);
% 
AnTime = dsearchn(time',[-200:600]');
XBin = time(AnTime);
StimDuration = dsearchn(time',[0:500]');



MeanLagAll = squeeze(mean(I,2,'omitnan'));
High_Indx = find(mod(Allinfo_S(:,8), 2)==1);
Low_Indx = find(mod(Allinfo_S(:,8), 2)==0);

figure, hold on
I_H = nanmean(MeanLagAll(High_Indx,AnTime));
I_L = nanmean(MeanLagAll(Low_Indx,AnTime));

ERPCoeff = ones(1, Bin)/Bin;
I_H = filter(ERPCoeff, 1,I_H);
I_L = filter(ERPCoeff, 1,I_L);


P{1} = plot(XBin, I_H,'Color',[1 0 1],'LineWidth',4);
P{2}=plot(XBin, I_L,'Color',[1 .5 0],'LineWidth',4);


legend([P{1} P{2}],'HCA','LCA');
legend boxoff
xlim([-200, 600]);
set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Time (ms)');
ylabel('Transfer Entropy (Bits)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
%%%%%%%%%%%%%%%%%%%% Ranksum Test
HAll = MeanLagAll(High_Indx,:);
LAll = MeanLagAll(Low_Indx,:);
%% BarPlot
MeanH = mean(mean(HAll(:,StimDuration)));
MeanL = mean(mean(LAll(:,StimDuration)));
MeanSEMH = 1.96*std(mean(HAll(:,StimDuration),2))./sqrt(length(High_Indx));
MeanSEML = 1.96*std(mean(LAll(:,StimDuration),2))./sqrt(length(Low_Indx));
%%
figure, hold on;
b1 = bar(1,(MeanH),.4);
b1.EdgeColor = [0 0 0];
b1.FaceColor = [1 0 1];

b1.LineWidth = 2;

b2 = bar(2,(MeanL),.4);
b2.EdgeColor = [0 0 0];
b2.FaceColor = [1 .5 0];

b2.LineWidth = 2;

set(gca,'Box','off');
set(gcf,'Color','w');
hold on;
MyErrorBar(1,MeanH,MeanSEMH,'k');
MyErrorBar(2,MeanL,MeanSEML,'k');
plot([1,2],[0.23 0.23],'k-','LineWidth',2);
    text(1.3,0.25,'***','FontSize',30);
    
xtick = [1:2];
xticklabl = {'HCA','LCA'};
set(gca,'XTick',xtick,'XTickLabel',xticklabl);
set(gca,'Box','off');
set(gcf,'Color','w');
ylabel('TE (Bits)');
set(gca,'TickDir','out');
set(gca,'FontSize',35);
set(gca,'linewidth',1.5);
%%

Cohs = [Allinfo_S(High_Indx,2);Allinfo_S(Low_Indx,2)];
slopes = [mean(HAll(:,StimDuration),2);mean(LAll(:,StimDuration),2)];
Subs = [Allinfo_S(High_Indx,end);Allinfo_S(Low_Indx,end)];
Condition = 1*ones(length(Allinfo_S),1);
Condition(1:length(High_Indx)) = 2;
MyTable = table(Subs,Cohs,slopes,Condition);

glme = fitglme(MyTable,...
		'slopes ~ 1+Condition + Cohs + (1|Subs)',...
		'Distribution','Normal','Link','identity','FitMethod','MPL',...
		'DummyVarCoding','effects')

VarStat = [glme.Coefficients.Estimate(2:end),glme.Coefficients.SE(2:end),...
    glme.Coefficients.Lower(2:end),glme.Coefficients.Upper(2:end),...
    glme.Coefficients.tStat(2:end),glme.Coefficients.pValue(2:end)]