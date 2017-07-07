clear;

%minimum size of face
minsize=20;

%path of toolbox
caffe_path='D:/caffe/matlab';
pdollar_toolbox_path='E:/global_tool-master/2D/detection/mtcnn/toolbox-master';
caffe_model_path='E:/global_tool-master/2D/detection/mtcnn/MTCNNv2/model';
addpath('E:/global_tool-master/2D/detection/mtcnn/MTCNNv2');
fin=fopen('F:/LFW/lfw_faces.txt','w');
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));

%use cpu
%caffe.set_mode_cpu();
gpu_id=0;
caffe.set_mode_gpu();
caffe.set_device(gpu_id);

%three steps's threshold
threshold=[0.6 0.7 0.7];

%scale factor
factor=0.709;

%load caffe models
prototxt_dir =strcat(caffe_model_path,'/det1.prototxt');
model_dir = strcat(caffe_model_path,'/det1.caffemodel');
PNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det2.prototxt');
model_dir = strcat(caffe_model_path,'/det2.caffemodel');
RNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det3.prototxt');
model_dir = strcat(caffe_model_path,'/det3.caffemodel');
ONet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir =  strcat(caffe_model_path,'/det4.prototxt');
model_dir =  strcat(caffe_model_path,'/det4.caffemodel');
LNet=caffe.Net(prototxt_dir,model_dir,'test');
faces=cell(0);
error_img=[];

%%% parameters 
%%%%%%%%%%%%%%%%%%%%%%%
imglist=importdata('F:/LFW/lfw_gender.txt');
% output_root_dir='/home/scw4750/github/jiang/output';
is_square_bbox=0;
crop_factor=1;         
is_write_5pt=1;
is_use_relative_path=1;
img_dir='F:/LFW/lfw_pts';
%%%%%%%%%%%%%%%%%%%



% if is_use_relative_path
%     assert(exist(img_dir,'var'),'user should provide image directory');
%     assert(~isempty(img_dir),'user should provide image directory');
% end
for i=1:length(imglist)
    i
    try
        img=imread(['F:/LFW/lfw/' imglist{i}]);
        img_height=size(img,1);
        img_width=size(img,2);
%         if img_height*img_width > 1000000
%             if img_height>img_width
%               img=imresize(img,500/img_height);
%             else
%               img=imresize(img,500/img_height);
%             end
%         end
%         img_height=size(img,1);
%         img_width=size(img,2);
    catch
        error_img(length(error_img)+1).name=imglist{i};
%         delete(imglist{i});
        continue;
    end
%     we recommend you to set minsize as x * short side
    minl=min([size(img,1) size(img,2)]);
    minsize=fix(minl*0.1);
    tic
    [boudingboxes points]=detect_face(img,minsize,PNet,RNet,ONet,LNet,threshold,false,factor);
    toc
    bbox=boudingboxes;
    result_bbox{i,1}=imglist{i};
    if size(bbox,1)>=1
        result_bbox{i,2}=bbox;
        

        %% if get small bboxs, ignore them
        height=bbox(1,4)-bbox(1,2);
        width=bbox(1,3)-bbox(1,1);
        if(height*width<2500)
            continue;
        end
        %% end: if get small bboxs, ignore them
        
        
        
        %% get square bbox
        if is_square_bbox
            bbox=get_square_bbox(bbox,crop_factor);
        end
        %% end: get square bbox
        
        
        
        %% write landmarks to file(.5pt)
        if is_write_5pt
            if is_use_relative_path       
                write_5pt([img_dir filesep imglist{i}],bbox,points);
                fprintf(fin,'%s\n',imglist{i});
                
            else
                write_5pt(imglist{i},bbox,points);
                fprintf(fin,'%s\n',imglist{i});
            end
        end
        %% end: write landmarks to file(.5pt)
    end


                   
end
fprintf('error images number:%d\n',length(error_img));
caffe.reset_all();





% pre-process to get square bbox
% firstly, this algorithms get the center of the origin bbox
% then, set the center as new bbox's center and the
% max(height,width)*crop_factor as the size of bbox.
%
% notices: this algorithms may not get square bbox because the border
% problems (see the codes)
%
%input:
%    bbox          --the origin bbox
%    crop_factor   --


