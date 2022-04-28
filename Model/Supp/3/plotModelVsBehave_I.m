clc;
clear;
close all;
%% Globals
%% Weight Change

load Behave_IData.mat;
load IParams_15.mat;

j=1;
Cohs = [];
AAGConfs = [];
SubConf = [];
SubRT=  [];
SubACC = [];
Cohs = [1.6, 3.2, 6.4, 12.8, 25.6];
NumSub = length(unique(IData(:, end)));




for i=1:NumSub
    i
    sBin = find(IData(:,end)==i);
    SubConf = IData(sBin,1)./6;
    
    SubRT = IData(sBin,5);
    ACC = zeros(length(sBin),1);
    ACC((IData(sBin,3) - IData(sBin,4) == 0)) = 1;
    SubACC = ACC;
    Cohs = IData(sBin,2)';
    Cohs = repmat(Cohs,1,10)/100;
    Vars0 = [IParams(i,1:5)];
    ConfParams = IParams(i,6:end);
    [MErr,b,c,MConf,MAcc,MRT] = Imodel(Vars0,Cohs',ConfParams);
    Subject_RT(i) = mean(SubRT);
    Subject_Conf(i) = mean(SubConf);
    Subject_ACC(i) = mean(SubACC);
    Model_RT(i) = mean(MRT);
    Model_Conf(i) = mean(MConf);
    Model_ACC(i) = mean(MAcc);
    
end
%%
figure, hold on;
xbin = 0:0.1:1;
plot(xbin, xbin, 'k--', 'MarkerSize', 2);
plot(Subject_ACC, Model_ACC, 'k.', 'MarkerSize', 35);
plot(mean(Subject_ACC), mean(Model_ACC), 'r.', 'MarkerSize', 40);
PvalACC = ranksum(Subject_ACC, Model_ACC);
xlim([.5, 1])
ylim([.5, 1])
axis square;
xlabel('Participants Accuracy');
ylabel('Model Accuracy');
set(gca,'Box','off');
set(gcf,'Color','w');
set(gca, 'FontSize',20);
set(gca,'TickDir','out');
set(gca,'linewidth',1.5);
%%
figure, hold on;
xbin = 0:0.1:1;
plot(Subject_RT, Model_RT, 'k.', 'MarkerSize', 35);
plot(mean(Subject_RT), mean(Model_RT), 'r.', 'MarkerSize', 40);
PvalRT = ranksum(Subject_RT, Model_RT);

plot(xbin, xbin, 'k--', 'MarkerSize', 2);
xlim([.5, 1])
ylim([.5, 1])
axis square;
xlabel('Participants RT');
ylabel('Model RT');
set(gca,'Box','off');
set(gcf,'Color','w');
set(gca, 'FontSize',20);
set(gca,'TickDir','out');
set(gca,'linewidth',1.5);

%%
figure, hold on;
xbin = 0:0.1:1;
plot(xbin, xbin, 'k--', 'MarkerSize', 2);
plot(Subject_Conf, Model_Conf, 'k.', 'MarkerSize', 35);
plot(mean(Subject_Conf), mean(Model_Conf), 'r.', 'MarkerSize', 40);
PvalConf = ranksum(Subject_Conf, Model_Conf);

xlim([0, 1])
ylim([0, 1])
axis square;
xlabel('Participants Conf');
ylabel('Model Conf');
set(gca,'Box','off');
set(gcf,'Color','w');
set(gca, 'FontSize',20);
set(gca,'TickDir','out');
set(gca,'linewidth',1.5);
