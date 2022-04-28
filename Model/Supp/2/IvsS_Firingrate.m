clc;
clear;
close all;
%%
load Behave_SData.mat;
%%
rng(1)
NumIter = 1;
Cohs = [1.6, 3.2,6.4,12.8,25.6]/100;
hindx = find(SData(:,end-1)==1);
lindx = find(SData(:,end-1)==2);
Wx = 0.003;

Cohs_H = repmat(Cohs, [1, NumIter*length(hindx)/length(Cohs)]);
AA = repmat(abs(SData(hindx, 6))/6, [NumIter, 1]);
[t,hist_H,choice_H,RT_H] = WangFriringRate(Wx,Cohs_H', AA);

Cohs_L = repmat(Cohs, [1, NumIter*length(lindx)/length(Cohs)]);
AA = repmat(abs(SData(lindx, 6))/6, [NumIter, 1]);
[t,hist_L,choice_L,RT_L] = WangFriringRate(Wx,Cohs_L', AA);
%%
figure,hold on;
Bin = 1:5:3006;
plot(Bin,.4*ones(1,length(Bin)),'k-.','LineWidth',1);
p{1}= plot(Bin,squeeze(mean(hist_H(:,1,:),1)),'b','LineWidth',2);
p{2} =plot(Bin,squeeze(mean(hist_H(:,2,:),1)),'r','LineWidth',2);
p{3} = plot(Bin,squeeze(mean(hist_L(:,1,:),1)),'b--','LineWidth',2);
p{4} =plot(Bin,squeeze(mean(hist_L(:,2,:),1)),'r--','LineWidth',2);

set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Time (ms)')
ylabel('S');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
legend([p{1} p{2} p{3} p{4}],'In','Out');
xlim([0 500]);
legend boxoff
%%
figure
hist(abs(squeeze(hist_L(:,1,100))-squeeze(hist_L(:,2,100))),10)
title('Isolated');

figure
hist(abs(squeeze(hist_H(:,1,100))-squeeze(hist_H(:,2,100))),10)
title('Social');
[a,b] = ttest2([squeeze(hist_L(:,1,100))-squeeze(hist_L(:,2,100))],...
    [squeeze(hist_H(:,1,100))-squeeze(hist_H(:,2,100))]);

Bintime = 1:100;

Mean_I = mean(abs([mean(squeeze(hist_L(:,1,Bintime)),2)-...
    mean(squeeze(hist_L(:,2,Bintime)),2)]));
    
Mean_S =mean(abs([mean(squeeze(hist_H(:,1,Bintime)),2)-...
    mean(squeeze(hist_H(:,2,Bintime)),2)]));

STD_I = var(abs([mean(squeeze(hist_L(:,1,Bintime)),2)-...
    mean(squeeze(hist_L(:,2,Bintime)),2)]));
    
STD_S = var(abs([mean(squeeze(hist_H(:,1,Bintime)),2)-...
    mean(squeeze(hist_H(:,2,Bintime)),2)]));

length(find(choice_L))
length(find(choice_H))
RankACC = ranksum(choice_L,choice_H);

%% BarPlots
%%% ACC
IACC = length(find(choice_L))/NumIter;
SACC = length(find(choice_H))/NumIter;
figure, hold on;
I = bar(1,IACC,.4);
I.EdgeColor='k';
I.FaceColor='w';
I.LineWidth=2;
I.LineStyle='--';
S = bar(2,SACC,.4);
S.FaceColor='k';
set(gca,'Box','off');
set(gcf,'Color','w');
ylabel('ACC');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
axis off;

%%% Conf
IACC = mean(abs([mean(squeeze(hist_L(:,1,Bintime)),2)-...
     mean(squeeze(hist_L(:,2,Bintime)),2)]));
SACC = mean(abs([mean(squeeze(hist_H(:,1,Bintime)),2)-...
     mean(squeeze(hist_H(:,2,Bintime)),2)]));
figure, hold on;
I = bar(1,IACC,.4);
I.EdgeColor='k';
I.FaceColor='w';
I.LineWidth=2;
I.LineStyle='--';

S = bar(2,SACC,.4);
S.FaceColor='k';
set(gca,'Box','off');
set(gcf,'Color','w');
ylabel('Conf');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);

%%%% RT
IACC = mean(RT_L);
SACC = mean(RT_H);
figure, hold on;
I = bar(1,IACC,.4);
I.EdgeColor='k';
I.FaceColor='w';
I.LineStyle='--';
I.LineWidth=2;
S = bar(2,SACC,.4);
S.FaceColor='k';
set(gca,'Box','off');
set(gcf,'Color','w');
ylabel('RT (s)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);








