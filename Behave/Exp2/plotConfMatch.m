clc;
clear;
close all
%%
load Behave_IData.mat
load Behave_SData.mat;
%%
j=1;
NumSub = length(unique(SData(:, end)));

for i=1:NumSub
    C_Iso(i) = mean(IData(IData(:,6)==i, 1));
    TmpData = SData(SData(:,end)==i, :);
    figure(1);
    Lindx = find(TmpData(:,end-1)==2);
    Hindx = find(TmpData(:,end-1)==1);
    Indx = [Hindx, Lindx];
    for jj=1:2
        SubConf(j) = mean(TmpData(Indx(:, jj),1));
        AgentConf(j) = mean(abs(TmpData(Indx(:, jj),6)));
        figure(1),hold on;
        if jj==1
            P{1}=plot(SubConf(j),AgentConf(j),'.','Color',[1 0 1],'MarkerSize',35);
            hold on;
        end
        if jj==2
            P{2}=plot(SubConf(j),AgentConf(j),'.','Color',[1 0.5 0],'MarkerSize',35);
            hold on;
        end
        j=j+1;
    end
end
figure(1);
set(gcf,'color','w');
set(gca,'Box','off');
plot([1:.1:6],[1:.1:6],'k-.');
xlabel('Subject Confidence');
ylabel('Agent Confidence');
ylim([1 6]);
xlim([1 6]);
xtick = [1:6];
xticlable = {'1','2','3','4','5','6'};
set(gca,'XTick',xtick,'XTickLabel',xticlable);
ytick = [1:6];
yticlable = {'1','2','3','4','5','6'};
set(gca,'YTick',ytick,'YTickLabel',yticlable,'FontSize',12);
legend boxoff;
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
axis square;

fitlm(AgentConf',SubConf')
%%

figure
set(gcf,'color','w');
set(gca,'Box','off');
set(gca,'FontSize',12);
for i=1:size(AgentConf,2)
    DM(i) = abs(C_Iso(ceil(i/2))-AgentConf(i))-abs(AgentConf(i)-SubConf(i));
end
Myhist(DM);
Bin = -2:.01:3;
Ybin  = 0:.01:1;
pd = fitdist(DM','Normal');
hold on
plot(Bin,normpdf(Bin,pd.mu,pd.sigma),'Color',[0 .8 0],'LineWidth',2);
plot(pd.mu*ones(1,size(Ybin,2)),Ybin,'k-.','LineWidth',2);
xlabel('MeanConf Difference');
ylabel('p(\Deltam)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
xlim([-2 3]);
[~,Pval,aa,bb] = ttest2(DM',zeros(1,size(DM,2))');
PvalPerm = MyPerm(AgentConf,SubConf)
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
