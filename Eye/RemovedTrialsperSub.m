clc;
clear;
close all;
%%
% load XYSocial_FinalITI.mat;
load XYSocial_FinalITI_Old.mat;

%%
AnalysisTime = 1:3000;
%%
fc = 6;
fs = 1000;
[b,a] = butter(2,fc/(fs/2));
ii = 1;
jj = 1;
BeforeBin = 1000;
for iii=1:size(SocialPupilXY,1)
    TmpITI = SocialPupilXY{iii,end};
    
    if TmpITI<3
        TmpPupil = SocialPupilXY{iii,1}((1500-BeforeBin):4500)+1;
%         TmpPupil = TmpPupil(1300:end);
        TmpPupil = DeleteBlink(TmpPupil);
        TmpPupil = [ones(200,1)*TmpPupil(1);TmpPupil];
        TmpPupil = filter(b,a,TmpPupil);
        TmpPupil(1:200) = []; 
        TmpPupil = zscore(TmpPupil);
        Pupils_S(ii,:) = TmpPupil(1:3000+BeforeBin);
        ii = ii+1;
    else
        SBadR(jj) = iii;
        jj = jj+1;
    end
    
end
%%

SubNums = [SocialPupilXY{:,end-1}];
UniqSubs = unique(SubNums);
Baddatasub = SubNums(SBadR);
for si=1:length(UniqSubs)
    SubReject(si) = length(find(Baddatasub == si))/800;
    
end