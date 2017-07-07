function show_pc(input,color)
if nargin<2
 color='.g';
end
plot3(input(1,:),input(2,:),input(3,:),color);
xlabel('x');
ylabel('y');
zlabel('z');
end
