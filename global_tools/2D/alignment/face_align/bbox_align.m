function eccv_align(face_dir,ffp_dir,save_dir,file_filter,output_format,pts_format,is_continue)

imgSize = [112, 96];

subdir = dir(face_dir);
subdir = subdir(3:end);
for i=1: length(subdir)
%     if ~ subdir(i).isdir
%         continue;
%     end
    fprintf('[%.2f%%] %s\n', 100*i/length(subdir), subdir(i).name);
%     pathstr = [save_dir filesep subdir(i).name];
%     if exist(pathstr, 'dir')  == 0
%         fprintf('create %s\n', pathstr);
%         mkdir(pathstr);
%     end
    
%     img_fns = dir([face_dir filesep subdir(i).name filesep file_filter]);
%     for k=1: length(img_fns)
%         img = imread([face_dir filesep subdir(i).name filesep img_fns(k).name]);
%         ffp_fn = [ffp_dir filesep subdir(i).name filesep img_fns(k).name(1:end-3) pts_format];
        img = imread(['F:/LFW/lfw' filesep subdir(i).name(1:end-4) '.jpg']);
        ffp_fn = [ffp_dir filesep subdir(i).name(1:end-3) pts_format];
        if is_continue
            if ~exist(ffp_fn, 'file')
                continue;
            end
        end
        assert(logical(exist(ffp_fn, 'file')),'landmarks should be provided\n');
  
        fid=fopen(ffp_fn,'rt');
        facial_point=textscan(fid,'%f');
        facial_point=facial_point{1};
        if is_continue
            if length(facial_point)<14
                continue;
            end
        end
        assert(length(facial_point)>=14,'bbox should be provide\n');
        fclose(fid);
        
        bbox=facial_point(11:14);
        [aligned_img]=bbox_alignment(img,bbox,1);

%         save_fn = [save_dir filesep subdir(i).name filesep img_fns(k).name(1:end-3) output_format];
        save_fn = [save_dir filesep subdir(i).name(1:end-3) output_format];
        imwrite(aligned_img, save_fn);
end
     
function [aligned_img]=bbox_alignment(img,bbox,padding_factor)

img_width=size(img,2);
img_height=size(img,1);
center=bbox(1:2)+bbox(3:4)/2;
width_height=bbox(3:4); %first element is width
square_size=int32(max(width_height)*padding_factor);
width=square_size;height=square_size;
left_top=int32(center-single(square_size)/2);
%         r=rectangle('Position',[bbox(1,1:2) width_height],'Edgecolor','g','LineWidth',3);
left_top(left_top<1)=1;
if left_top(1)+square_size>img_width
    width=img_width-left_top(1);
end
if left_top(2)+square_size>img_height
    height=img_height-left_top(2);
end
assert(width>0,'bbox is wrong');
assert(height>0,'bbox is wrong');

aligned_img=img(left_top(2):left_top(2)+height,left_top(1):left_top(1)+width,:);

end
end
        