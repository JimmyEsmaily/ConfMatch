clc;
clear;
close all;
%%
load ACCConf_15.mat; % Final


%%
NumIter = 100;
SmoothBin = 500;
Cohs = [0:.5:25]/100;
AllCoh = repmat(Cohs,NumIter,1);
AllW = [-.0:0.0005:0.005];
cc=1:size(AllCoh,2);
coh = AllCoh(:,cc);
ww=1:size(AllW,2);
figure,
contourf(cc,AllW,Decision',SmoothBin,'linecolor','none')

colorbar
colormap('jet')
set(gcf,'Color','w');
set(gca,'TickDir','out');
set(gca,'FontSize',30);
set(gca,'linewidth',1.5);
set(gca,'Box','off');
title('Probability Correct');
ylabel('W_X');
xlabel('Stimulus Strength (%coh)')
set(gca,'clim',[.4 1])
ax = gca;
ax.YAxis.Exponent = 0;

figure,
contourf(cc,AllW,Allconf',SmoothBin,'linecolor','none')
colorbar
colormap('jet')
set(gcf,'Color','w');
set(gca,'TickDir','out');
set(gca,'FontSize',30);
set(gca,'linewidth',1.5);
set(gca,'Box','off');
title('Confidence');
ylabel('W_X');
xlabel('Stimulus Strength (%coh)')

ax = gca;
ax.YAxis.Exponent = 0;



figure,
contourf(cc,AllW,AllRT'+.27,SmoothBin,'linecolor','none') % + ND time
colorbar
colormap('jet')
set(gcf,'Color','w');
set(gca,'TickDir','out');
set(gca,'FontSize',30);
set(gca,'linewidth',1.5);
set(gca,'Box','off');
title('RT');
ylabel('W_X');
xlabel('Stimulus Strength (%coh)')

ax = gca;
ax.YAxis.Exponent = 0;
