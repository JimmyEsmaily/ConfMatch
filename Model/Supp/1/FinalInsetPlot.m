clc;
clear;
close all;
%%
load PlotData.mat;
%%
Bintime = 1:100;
TextInsetSize = 50;
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
set(gca,'YColor', 'none')
% axis off
s=plot([.8 .8],[0 .8],'k-','linewidth',2);
TT = text(-50,0,'Decision Variable (a.u.)','FontSize',20);
TT.Rotation = 90;
alpha(1);


%% BarPlots
%%% ACC
IACC = length(find(choice_I))/NumIter;
SACC = length(find(choice_S))/NumIter;
ranksum(double(choice_I),double(choice_S))
figure, hold on;
I = bar(1,IACC,.3);
I.EdgeColor='k';
I.FaceColor='w';
I.LineWidth=2;
I.LineStyle='--';
S = bar(1.4,SACC,.3);
S.FaceColor='k';
set(gca,'Box','off');
set(gcf,'Color','w');
ylabel('ACC');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);

axis off
plot([.7 .7],[0 .7],'k-','linewidth',2);
text(.35,.35,'0.7','FontSize',TextInsetSize);
text(1,1.1,'ACC','FontSize',TextInsetSize);

plot([1 1.4],[.8 .8],'k-','linewidth',2);
text(1.1,.9,'n.s.','FontSize',TextInsetSize);
ylim([0 1.1]);



%%% Conf
IACC = mean(abs([mean(squeeze(hist_I(:,1,Bintime)),2)-...
     mean(squeeze(hist_I(:,2,Bintime)),2)]));
SACC = mean(abs([mean(squeeze(hist_S(:,1,Bintime)),2)-...
     mean(squeeze(hist_S(:,2,Bintime)),2)]));
 ranksum(abs([mean(squeeze(hist_I(:,1,Bintime)),2)-...
     mean(squeeze(hist_I(:,2,Bintime)),2)]),...
     abs((mean(squeeze(hist_S(:,1,Bintime)),2)-...
     mean(squeeze(hist_S(:,2,Bintime)),2))))

figure, hold on;
I = bar(1,IACC,.3);
I.EdgeColor='k';
I.FaceColor='w';
I.LineWidth=2;
I.LineStyle='--';

S = bar(1.4,SACC,.3);
S.FaceColor='k';
set(gca,'Box','off');
set(gcf,'Color','w');
% xlabel('Time (ms)')
ylabel('Conf');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);

axis off
plot([.7 .7],[0 .1],'k-','linewidth',2);
text(.24,.08,'0.1','FontSize',TextInsetSize);
TT = text(.9,.22,'In-Out','FontSize',TextInsetSize);
% TT.Rotation = 90;

plot([1 1.5],[.13 .13],'k-','linewidth',2);
text(1.1,.165,'***','FontSize',TextInsetSize);
ylim([0 .25]);


%%%% RT
IACC = mean(RT_I);
SACC = mean(RT_S);
ranksum(RT_I,RT_S)
figure, hold on;
I = bar(1,IACC,.3);
I.EdgeColor='k';
I.FaceColor='w';
I.LineStyle='--';
I.LineWidth=2;
S = bar(1.4,SACC,.3);
S.FaceColor='k';
set(gca,'Box','off');
set(gcf,'Color','w');
% xlabel('Time (ms)')
ylabel('RT (s)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);

axis off
plot([.7 .7],[0 .5],'k-','linewidth',2);
text(.35,.2,'0.5','FontSize',TextInsetSize);
text(.75,.73,'Dec. Time','FontSize',TextInsetSize);

plot([1 1.5],[.55 .55],'k-','linewidth',2);
text(1.16,.58,'***','FontSize',TextInsetSize);
ylim([0 .8]);




