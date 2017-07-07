function bbox=get_square_bbox(bbox,crop_factor)

center=bbox(1,1:2)+bbox(1,3:4); %first element is width-center
center=center/2;
width_height=bbox(1,3:4)-bbox(1,1:2); %first element is width
square_size=int32(max(width_height)*crop_factor);
width=square_size;height=square_size;
left_top=int32(center-single(square_size)/2);
left_top(left_top<1)=1;
if left_top(1)+square_size>img_width
    width=img_width-left_top(1);
end
if left_top(2)+square_size>img_height
    height=img_height-left_top(2);
end
bbox(1:2)=left_top;
bbox(3)=width;
bbox(4)=height;
end
