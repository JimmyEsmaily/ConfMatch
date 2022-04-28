clc;
clear;
close all;
%%
load SData.mat;
%%
uniqsubs = unique(Allinfo_S(:,end));
allsubs = Allinfo_S(:,end);
for si=1:length(uniqsubs)
    RejData_S(si) = 1-(length(find(allsubs==si))/800);
    
end