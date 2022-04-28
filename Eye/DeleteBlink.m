function [ZZ,NumBlink] = DeleteBlink(TmpPupil)
AllBadBin = find(TmpPupil<10);
AllBadBin(AllBadBin>length(TmpPupil)) = [];
NumBlink = 0;
if ~isempty(AllBadBin)>0
    NumBlink = length(find(diff(AllBadBin)>1))+1;
    IndxBadBinTmp = find(diff(AllBadBin)>1)+1;
    IndxBadBin = [AllBadBin(1),AllBadBin(IndxBadBinTmp)'];
    if NumBlink>1
        aa=1;
    end
    IndxBadBinTmp = diff([1,IndxBadBinTmp',length(AllBadBin)+1])-1;
    for bi = 1:NumBlink
        BadBin = IndxBadBin(bi):IndxBadBin(bi)+IndxBadBinTmp(bi);
        if ~isempty(AllBadBin)>0
            
            if BadBin(1)==1
                XX = ones(length(BadBin),1)*TmpPupil(BadBin(end)+1);
            elseif BadBin(end)==length(TmpPupil)
                XX = ones(length(BadBin),1)*TmpPupil(BadBin(1)-1);
            else
                TmpSlop = [TmpPupil(BadBin(end)+1)-TmpPupil(BadBin(1)-1)]...
                    /[BadBin(end)+1-BadBin(1)+1];
                XX = TmpPupil(BadBin(1)-1)+TmpSlop*(BadBin-BadBin(1));
            end
            ZZ = TmpPupil;
            ZZ(BadBin) = XX;
            TmpPupil = ZZ;
        end
    end
    
else
    ZZ = TmpPupil;
end