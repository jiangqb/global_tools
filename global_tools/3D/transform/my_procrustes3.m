function [transM,New_shape] = my_procrustes3(s1_lm2,s2_lm2,s2_shape)

%    s2 Ïò s1 ¶ÔÆë
%  Input:
%  s1_lm2, s2_lm2    N*3
%  s2_shape   N*3
%  Output:
%  New_shape  N*3
%  transM  2*4

[d AlignS tform] = procrustes(s1_lm2,s2_lm2);   %c ¡ª Translation component; T ¡ª Orthogonal rotation and reflection component;  b ¡ª Scale component
Translate = -1/tform.b*tform.c*tform.T';
Translate = Translate(1, :);
transM = [1/tform.b*tform.T Translate'];

ss = [s2_shape'; ones(1, size(s2_shape,1))];

newS = [transM ; [0 0 0 1]]\ss;
newS(4,:) = [];
New_shape = newS;
