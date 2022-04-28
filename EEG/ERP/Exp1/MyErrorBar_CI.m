function MyErrorBar_CI(X,Y,Error1, Error2,ColorCode,Tikness)
if nargin<5
    Tikness=1;
end
for i=1:length(X)
    plot([X(i),X(i)],[(Error1(i)),(Error2(i))],...
        ColorCode,'LineWidth',Tikness)
end
end

% errorbar(1:i,LowConf,SEMConfLow,'r-','LineWidth',2);