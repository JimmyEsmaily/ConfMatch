clc;
clear;
close all;
%%
load Data_I.mat;
%%

NN = [18, 57, 45, 46];

time = -1500:4:1000;
AnTime = [-200:4:600];
TimeBin = dsearchn(time',AnTime');

BLine = dsearchn(time',[-100:4:0]');  %% 50
BLine1 = dsearchn(TimeBin,BLine);

XBin = time(TimeBin);

Bin = 20;
Data_I = squeeze(mean(AllData_I(NN,TimeBin,:),1)) *(10^5);

Data_I = bsxfun(@minus,Data_I, mean(Data_I(BLine1,:)));

BadRecords = DeleteBadRecord(Data_I);
Allinfo_I(BadRecords,:) = [];
Data_I(:,BadRecords) = [];


%%
Coh5_Indx = find(Allinfo_I(:,2)==25.6);
Coh4_Indx = find(Allinfo_I(:,2)==12.8);
Coh3_Indx = find(Allinfo_I(:,2)==6.4);
Coh2_Indx = find(Allinfo_I(:,2)==3.2);
Coh1_Indx = find(Allinfo_I(:,2)==1.6);

Data5 = Data_I(:,Coh5_Indx);
Data4 = Data_I(:,Coh4_Indx);
Data3 = Data_I(:,Coh3_Indx);
Data2 = Data_I(:,Coh2_Indx);
Data1 = Data_I(:,Coh1_Indx);
% Coh
Mean5 = mean(Data5,2);
Mean4 = mean(Data4,2);
Mean3 = mean(Data3,2);
Mean2 = mean(Data2,2);
Mean1 = mean(Data1,2);

SEM5 = std(Data5')/sqrt(size(Data5,2));
SEM4 = std(Data4')/sqrt(size(Data4,2));
SEM3 = std(Data3')/sqrt(size(Data3,2));
SEM2 = std(Data2')/sqrt(size(Data2,2));
SEM1 = std(Data1')/sqrt(size(Data1,2));

ERPCoeff = ones(1, Bin)/Bin;

Mean5 = conv(Mean5,ERPCoeff, 'same');
Mean4 = conv(Mean4,ERPCoeff, 'same');
Mean3 = conv(Mean3,ERPCoeff,'same');
Mean2 = conv(Mean2,ERPCoeff, 'same');
Mean1 = conv(Mean1,ERPCoeff, 'same');

figure, hold on;
P{1} = plot(XBin,Mean5,'Color',flip([1 0 0]),'LineWidth',3);
P{2} = plot(XBin,Mean4,'Color',flip([.75 0 0.25]),'LineWidth',3);
P{3} = plot(XBin,Mean3,'Color',flip([.5 0 0.5]),'LineWidth',3);
P{4} = plot(XBin,Mean2,'Color',flip([.25 0 .75]),'LineWidth',3);
P{5} = plot(XBin,Mean1,'Color',flip([0 0 1]),'LineWidth',3);


legend([P{1} P{2} P{3} P{4} P{5}],'25.6','12.8','6.4','3.2', '1.6');
legend boxoff;
h = area([200 500],[-5 20.5;-5 20.5],-5);
set(h,'FaceColor',[.1 .1 .1]);
set(h,'EdgeColor','none');

alpha(0.2)

set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Time (ms)');
title('Isolated');
ylabel('Amplitude(\muV)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
xlim([-100,550]);
ylim([-2 12]);
