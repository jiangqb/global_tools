function write_5pt(path,bbox,points)

idx=strfind(path,'.');
path=path(1:idx(end));
fid=fopen([path '5pt'],'wt');
for i_pt=1:5
    fprintf(fid,'%f %f\n',points(i_pt,1),points(i_pt+5,1));
end
fprintf(fid,'%f %f %f %f\n',bbox(1,1),bbox(1,2),bbox(1,3)-bbox(1,1),bbox(1,4)-bbox(1,2));
fclose(fid);

end