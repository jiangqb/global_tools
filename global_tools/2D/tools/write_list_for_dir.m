function write_list_for_dir(txt_name,img_dir,filter,param)
%To get list for the directory as images, the output is a txt
%   which containing lines with name and label
%input:
%  img_dir    --the root dir for all image
%txt_name:
%  txt_name   --the output list name
%filter
%	      --file_filter as '*.jpg' and so on.
%param.out_format --the output format
%param.name_handle --a function taht get label from image name
%
%output:
%       the output should be [image_name(1:end-length(filter)+2) out_format]
%
%Jun Hu
%2017-4


fid=fopen(txt_name,'wt');


img_struct=dir([img_dir filesep filter]);
for i_s=1:length(img_struct)
    output_name=img_struct(i_s).name;
    label=i_s-1;
    if isfield(param,'name_handle')
        label=param.name_handle(output_name);
    end
    if isfield(param,'out_format')
        output_name=[output_name(1:end-length(filter)+2) param.out_format];
    end
    if label~=Inf
        fprintf(fid,'%s %d\n',output_name,label);
    end
end

fclose(fid);
end
