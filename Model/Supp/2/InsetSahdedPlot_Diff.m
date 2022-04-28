clc;
clear;
close all;
%%
load PlotData.mat;
%%
TextInsetSize = 50;
figure,hold on;
Bin = 1:100;
FBin = 1:100;
Linwsidth = 8;
SBin = 10;
TNum = 5; % 5 
FontSize = 30;
Tmp1 = squeeze(hist_H(TNum,1,FBin))+normrnd(0,.1,[FBin(end),1]);
ERPCoeff = ones(1, SBin)/SBin;
Tmp1 = filter(ERPCoeff, 1,Tmp1);
TT= find(Tmp1>.39);
DT1 = TT(1);
plot(Bin,Tmp1,'b','LineWidth',Linwsidth)
Tmp2 = squeeze(hist_H(TNum,2,FBin))+normrnd(0,.05,[FBin(end),1]);
ERPCoeff = ones(1, SBin)/SBin;
Tmp2 = filter(ERPCoeff, 1,Tmp2);

plot(Bin,Tmp2,'r','LineWidth',Linwsidth)

x2 = [(Bin),fliplr(Bin)];
inBetween = [(Tmp1)', fliplr(Tmp2')];
P{1} = fill(x2,inBetween, [.7 .7 .7]);
P{1}.EdgeColor = [.7 .7 .7];

plot(Bin,.4*ones(1,length(Bin)),'k-.','LineWidth',1);



set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Time (ms)')
ylabel('S');
set(gca,'TickDir','out');
set(gca,'linewidth',1.5);
xlim([0 100]);
ylim([-.03 1]);
legend boxoff
set(gca,'YColor', 'none')
% axis off
s=plot([-.03 1],[-0.03 1],'k-','linewidth',2);
TT = text(-10,.25,'AE (a.u.)','FontSize',FontSize);
TT.Rotation = 90;

set(gca,'XColor', 'none')
s=plot([100 0],[-.03 -.03],'k-','linewidth',2);
TT = text(30,-.15,'Time (ms)','FontSize',FontSize);

set(gca,'FontSize',FontSize);
