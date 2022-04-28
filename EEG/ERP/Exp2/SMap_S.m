clc;
clear;
close all;
%%
load Data_SFinal15.mat;
load Locs64.mat;
%%
NN = [19, 12, 13, 18, 45, 46, 58];
NN = [12, 13, 18, 19];
EEGData = AllData_S * 10^5;
AllCoh = Allinfo_S(:,2);
ERP = mean((EEGData(:,:,:)),3);
figure;
time = -1500:4:2999;
AnTime = [200:4:499];
TimeBin = dsearchn(time',AnTime');

topoplot(mean(ERP(:,TimeBin),2),Locs,'plotrad',.66,'electrodes','off')

I=colorbar;
caxis([-12 12]);
set(gcf,'Color','w');
set(gca,'FontSize',30);

