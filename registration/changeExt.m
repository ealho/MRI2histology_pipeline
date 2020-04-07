%
% ex: ext = 'jpg'
%
function new_name = changeExt(name,ext)

    idx = strfind(name,'.');
    idx = idx(end);
    
    new_name = strcat(name(1:idx),ext);

end