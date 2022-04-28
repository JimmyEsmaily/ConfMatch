function BAD = DeleteBadRecord(Data)
BadIndex = [];
for i=1:size(Data,2)
    BadIndex = [BadIndex;any(Data(:,i)<-200)];
    
end
BadIndex1 = [];
for i=1:size(Data,2)
    BadIndex1 = [BadIndex1;any(Data(:,i)>200)];
end
BAD = unique([find(BadIndex1);find(BadIndex)]);
end