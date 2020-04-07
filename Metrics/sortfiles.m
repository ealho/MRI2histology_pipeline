function files = sortfiles(blockfiles)

nFiles = length(blockfiles);

aux = zeros(nFiles,1);

for i=1:nFiles
   str = blockfiles(i).name;
   
   ind1 = strfind(str,'_');
   if isempty(ind1)
    ind1 = 0;
   else
    ind1 = ind1(end);   
   end
   
   ind2 = strfind(str,'.');
   ind2 = ind2(end);   
   num = str2num(str(ind1+1:ind2-1));
   aux(i) = num;
end

[s sidx] = sort(aux);

files = blockfiles(sidx);