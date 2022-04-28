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
TNum = 5; % 6 
FontSize = 30;
Tmp1 = squeeze(hist_H(TNum,1,FBin))+normrnd(0,.1,[FBin(end),1]);
ERPCoeff = ones(1, SBin)/SBin;
Tmp1 = filter(ERPCoeff, 1,Tmp1);
plot(Bin,Tmp1,'b','LineWidth',Linwsidth)

x2 = [(Bin),fliplr(Bin)];
inBetween = [(Tmp1)', fliplr(zeros(100,1)')];
P{2} = fill(x2,inBetween,[.7 .7 .7]);
P{2}.EdgeColor = [.7 .7 .7];

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
s=plot([-.0 1],[-0.0 1],'k-','linewidth',2);
TT = text(-10,.25,'AE (a.u.)','FontSize',FontSize);
TT.Rotation = 90;

set(gca,'XColor', 'none')
% axis off
s=plot([100 0],[-.01 -.01],'k-','linewidth',2);
TT = text(30,-.15,'Time (ms)','FontSize',FontSize);
set(gca,'FontSize',FontSize);
