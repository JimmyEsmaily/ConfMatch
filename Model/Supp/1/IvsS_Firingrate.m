clc;
clear;
close all;
%%
rng(1)
NumIter = 1000;
Cohs = ones(NumIter,1)*0.064;
Wx = 0.002;
[t,hist_S,choice_S,RT_S] = WangFriringRate(Wx,Cohs');
Wx = 0.0;
[t,hist_I,choice_I,RT_I] = WangFriringRate(Wx,Cohs');
%%
figure,hold on;
Bin = 1:5:3006;
plot(Bin,.4*ones(1,length(Bin)),'k-.','LineWidth',1);
p{1}= plot(Bin,squeeze(mean(hist_S(:,1,:),1)),'b','LineWidth',2);
p{2} =plot(Bin,squeeze(mean(hist_S(:,2,:),1)),'r','LineWidth',2);
p{3} = plot(Bin,squeeze(mean(hist_I(:,1,:),1)),'b--','LineWidth',2);
p{4} =plot(Bin,squeeze(mean(hist_I(:,2,:),1)),'r--','LineWidth',2);

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
hist(abs(squeeze(hist_I(:,1,100))-squeeze(hist_I(:,2,100))),10)
title('Isolated');
figure
hist(abs(squeeze(hist_S(:,1,100))-squeeze(hist_S(:,2,100))),10)
title('Social');

[a,b] = ttest2([squeeze(hist_I(:,1,100))-squeeze(hist_I(:,2,100))],...
    [squeeze(hist_S(:,1,100))-squeeze(hist_S(:,2,100))]);

Bintime = 1:100;

Mean_I = mean(abs([mean(squeeze(hist_I(:,1,Bintime)),2)-...
    mean(squeeze(hist_I(:,2,Bintime)),2)]));
    
Mean_S =mean(abs([mean(squeeze(hist_S(:,1,Bintime)),2)-...
    mean(squeeze(hist_S(:,2,Bintime)),2)]));

STD_I = var(abs([mean(squeeze(hist_I(:,1,Bintime)),2)-...
    mean(squeeze(hist_I(:,2,Bintime)),2)]));
    
STD_S = var(abs([mean(squeeze(hist_S(:,1,Bintime)),2)-...
    mean(squeeze(hist_S(:,2,Bintime)),2)]));

length(find(choice_I))
length(find(choice_S))
RankACC = ranksum(choice_I,choice_S);

%% BarPlots
%%% ACC
IACC = length(find(choice_I))/NumIter;
SACC = length(find(choice_S))/NumIter;
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
IACC = mean(abs([mean(squeeze(hist_I(:,1,Bintime)),2)-...
     mean(squeeze(hist_I(:,2,Bintime)),2)]));
SACC = mean(abs([mean(squeeze(hist_S(:,1,Bintime)),2)-...
     mean(squeeze(hist_S(:,2,Bintime)),2)]));
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
IACC = mean(RT_I);
SACC = mean(RT_S);
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








