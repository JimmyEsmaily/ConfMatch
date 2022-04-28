clc;
clear;
close all;
%%
load Data_SFinal15.mat;
%%
uniqsubs = unique(Allinfo_S(:,end));
allsubs = Allinfo_S(:,end);
for si=1:length(uniqsubs)
    RejData_S(si) = 1-(length(find(allsubs==si))/400);
end