clear;

minimum size of face
minsize=20;

path of toolbox
caffe_path='/home/scw4750/github/caffe/matlab';
pdollar_toolbox_path='/home/scw4750/github/MTCNN/toolbox-master'
caffe_model_path='/home/scw4750/github/MTCNN/code/codes/MTCNNv2/model'
addpath('/home/scw4750/github/MTCNN/code/codes/MTCNNv2');
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));

use cpu
caffe.set_mode_cpu();
gpu_id=0;
caffe.set_mode_gpu();
caffe.set_device(gpu_id);

three steps's threshold
threshold=[0.6 0.7 0.7];

scale factor
factor=0.709;

load caffe models
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

%%%%%%%%%%%%%%%%%%%
imglist=importdata('txt/detect_list_for_gallery.txt');
imglist=importdata('gallery.txt');
imglist=imglist.textdata;
img_dir='image';
output_root_dir='/home/scw4750/github/jiang/output';
crop_factor=1;
%%%%%%%%%%%%%%%%%%%
for i=1:length(imglist)
    i
    try
        img=imread([img_dir filesep imglist{i}]);
        img_height=size(img,1);
        img_width=size(img,2);
        if img_height*img_width > 1000000
            img=imresize(img,1000,1000);
        end
        img(:,:,2)=img(:,:,1);
        img(:,:,3)=img(:,:,1);
    catch
        error_img(length(error_img)+1).name=[img_dir filesep imglist{i}];
%         delete(imglist{i});
        continue;
    end
    we recommend you to set minsize as x * short side
    minl=min([size(img,1) size(img,2)]);
    minsize=fix(minl*0.1)
    tic
    [boudingboxes points]=detect_face(img,minsize,PNet,RNet,ONet,LNet,threshold,false,factor);
    toc
    bbox=boudingboxes;
    if size(boudingboxes,1)>=1
        center=bbox(1,1:2)+bbox(1,3:4); %first element is width-center
        center=center/2;
        width_height=bbox(1,3:4)-bbox(1,1:2); %first element is width
        square_size=int32(max(width_height)*crop_factor);
        width=square_size;height=square_size;
        left_top=int32(center-single(square_size)/2);
        r=rectangle('Position',[bbox(1,1:2) width_height],'Edgecolor','g','LineWidth',3);
        left_top(left_top<1)=1;
        if left_top(1)+square_size>img_width
            width=img_width-left_top(1);
        end
        if left_top(2)+square_size>img_height
            height=img_height-left_top(2);
        end
        if(height*width<2500)
%             delete(imglist{i});
            continue;
        end
        
        
%         imshow(img);hold on;
%         r=rectangle('Position',[left_top width height],'Edgecolor','g','LineWidth',3);
%         full_path=imglist{i};
%         idx=strfind(full_path,'/');
%         class_dir_name=full_path(idx(end-1)+1:idx(end)-1);
%         img_name=full_path(idx(end)+1:end);
%         if ~exist([output_root_dir filesep class_dir_name],'dir')
%             mkdir([output_root_dir filesep class_dir_name]);
%         end
%         imwrite(img(left_top(2):left_top(2)+height,left_top(1):left_top(1)+width,1:3),...
%             [output_root_dir filesep imglist{i}]);
%         
%         write landmarks
%         
        
        
        
%         fid=fopen([img_dir filesep imglist{i}(1:end-3) '5pt'],'wt');
%         for i_pt=1:5
%             fprintf(fid,'%f %f\n',points(i_pt,1),points(i_pt+5,1));
%         end
%         fprintf(fid,'%f %f %f %f\n',bbox(1,1),bbox(1,2),bbox(1,3)-bbox(1,1),bbox(1,4)-bbox(1,2));
%         fclose(fid);
%         
        
        
%         show landmarks
%         faces{i,1}={boudingboxes};
%         faces{i,2}={points'};
%         show detection result
%         numbox=size(boudingboxes,1);
%         imshow(img)
%         hold on;
%         for j=1:numbox
%             plot(points(1:5,j),points(6:10,j),'g.','MarkerSize',10);
%             r=rectangle('Position',[boudingboxes(j,1:2) boudingboxes(j,3:4)-boudingboxes(j,1:2)],'Edgecolor','g','LineWidth',3);
%         end
%         hold off;
    end
end
fprintf('error images number:%d\n',length(error_img));
caffe.reset_all();
save result box landmark

