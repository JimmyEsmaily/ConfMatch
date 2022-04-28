clc;
clear;
close all;
%%
load Behave_SData.mat;
%%
Aindx = SData(:, end-1);
Lindx = find(mod(Aindx,2) == 0);
Hindx = find(mod(Aindx,2) == 1);
Cohs = [3.2, 6.4, 12.8, 25.6, 51.2];
NumSub = length(unique(SData(:, end)));

for i=1:NumSub
    TmpData = SData(SData(:,end) == i, :);
    for jj=1:4
        TTData = TmpData(TmpData(:,end-1)==jj,:);
        AllConf{i,jj}=abs(TTData(:,6))/6;
        Confss = TTData(:,6);  % agent Confidece (both direction and confidence)
        ANS = zeros(1,size(Confss,1))';
        ANS(Confss>0)=1;
        TmpDir = TTData(:,3);  % direction
        TmpDir(TmpDir==0)=1;
        TmpDir(TmpDir==180)=0;
        
        AllACC{i,jj}=1-abs(ANS-TmpDir);
    end
end
%% Conf
Name = {'HAHC','HALC','LAHC','LALC'};

for jj=1:4
    
    
    TmpConf = mean(cell2mat(AllConf(:,jj)),2);
    TmpAcc = mean(cell2mat(AllACC(:,jj)),2);
    SEM_ACC = std(TmpAcc)/sqrt(NumSub);
    SEM_Conf = std(TmpConf)/sqrt(NumSub);

    
    fig = figure;
    left_color = [1 0 0];
    right_color = [0 0 1];
    set(fig,'defaultAxesColorOrder',[left_color; right_color]);
    hold on;
    title(Name{jj});
    yyaxis 'right';
    I = bar(2,mean(TmpConf),.4);
    I.FaceColor = 'b';
    I.EdgeColor = 'k';
    I.LineWidth = 2;
    ylim([0 1]);
    MyErrorBar([2],[mean(TmpConf)],[SEM_Conf],'k');

    ylabel('Confidence');
    ax = gca;
    ax.XColor = [0 0 0];
    
    
    yyaxis 'left';
    I = bar(1,mean(TmpAcc),.4);
    I.FaceColor = 'r';
    I.EdgeColor = 'k';
    I.LineWidth = 2;
    ylim([.5 1]);
    ylabel('Accuracy')
    MyErrorBar([1],[mean(TmpAcc)],[SEM_ACC],'k');

    ax = gca;
    ax.XColor = [0 0 0];
    
    set(gcf,'color','w');
    set(gca,'Box','off');
    xtick = [1:2];
    xticklabel = {'ACC','Conf'};
    set(gca,'XTick',xtick,'XTickLabel',xticklabel);
    legend boxoff;
    set(gca,'TickDir','out');
    set(gca,'FontSize',20);
    set(gca,'linewidth',1.5);
    
end
