function centerloss_align(face_dir,ffp_dir,save_dir,file_filter,output_format,pts_format,is_continue)

imgSize = [112,112];

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
        img = imread(['F:/LFW/lfw' filesep subdir(i).name(1:end-3) 'jpg']);
        ffp_fn = [ffp_dir filesep subdir(i).name(1:end-3) pts_format];
        if is_continue
            if ~exist(ffp_fn, 'file')
                continue;
            end
        end
        assert(logical(exist(ffp_fn, 'file')),'landmarks should be provided\n');
        img_cropped=eccv_align_base(ffp_fn,img,imgSize);

        save_fn = [save_dir filesep subdir(i).name(1:end-3) output_format];
        imwrite(img_cropped, save_fn);
end
        
end
     
function img_cropped=eccv_align_base(ffp_fn,img,imgSize)  

        fid=fopen(ffp_fn,'rt');
        facial_point=textscan(fid,'%f');
        facial_point=facial_point{1};
        fclose(fid);
%         coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
%             51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
        coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
            51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
        coord5points(1,:) = coord5points(1,:) + 15.15;
        coord5points(2,:) = coord5points(2,:) + 25.85;
        facial5points(1,1:5)=facial_point(1:2:9);
        facial5points(2,1:5)=facial_point(2:2:10);
        Tfm =  cp2tform(facial5points', coord5points', 'similarity');
        img_cropped = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
            'YData', [1 imgSize(1)], 'Size', imgSize);

end
