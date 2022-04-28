clc;
clear;
close all;
%%
load SData.mat;
load Locs.mat;
%%


EEGData = AllData_S;
AllCoh = Allinfo_S(:,2);
ERP = mean((EEGData(:,:,:)),3);
figure;
time = -200:1000;
AnTime = [200:499];
TimeBin = dsearchn(time',AnTime');

topoplot(mean(ERP(:,TimeBin),2),Locs,'plotrad',.66,'electrodes','off')

I=colorbar;
caxis([-2 4.5]);
set(gcf,'Color','w');
set(gca,'FontSize',30);

