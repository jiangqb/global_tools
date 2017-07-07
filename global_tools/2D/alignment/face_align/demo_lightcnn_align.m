clear;
%lighten_cnn's readme
%Data Pre-processing
%
% 1. Download face dataset such as  CASIA-WebFace, VGG-Face and MS-Celeb-1M.
% 2. All face images are converted to gray-scale images and normalized to 144x144 according to landmarks. 
% 3. According to the 5 facial points, we not only rotate two eye points horizontally but also set the distance between the midpoint of eyes and the midpoint of mouth(ec_mc_y), and the y axis of midpoint of eyes(ec_y).
%
%   Dataset     | size    |  ec_mc_y  | ec_y  
%  :----| :-----: | :----:    | :----: 
%  Training set | 144x144 |     48    | 48    
%  Testing set  | 128x128 |     48    | 40    
%end:lighten_cnn's readme
%
%notices: 1. the five points should be  left-eye,right-eye,nose,left,mouse,rightmouse  in order;
%        the format in pts should be left-eye-x left-eye-y \n      a   
%                                    right-eye-x right-eye-y \n
%                                    ...
%         2. the resized image must be square
%         3. the images should be stored as  root_dir/class/image
%Jun Hu
%2017-4
face_dir='F:/LFW/lfw_pts';
ffp_dir=face_dir;
save_dir='F:/LFW/lfw_face_align';
ec_mc_y=48;
ec_y=48;
img_size=114

;
% save_dir='/home/scw4750/github/IJCB2017/liangjie/croped/with_pts/enlarge_mulitpie_croped_by_liang_with_pts/gallery';
pts_format='5pt';
output_format='jpg';
filter='*.jpg';
is_continue=true; %when landmarks does not exist,choose whether to continue;
lightcnn_align(face_dir, ffp_dir, ec_mc_y, ec_y, img_size, save_dir,'*.jpg',output_format,pts_format,is_continue);


