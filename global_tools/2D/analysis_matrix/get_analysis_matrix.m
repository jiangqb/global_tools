function analysis=get_analysis_matrix(gallery,probe,matrix_param)
%compute rank_socre
%
%input:
%  gallery  -- a struct that has field fea(image's feature) and its label for gallery
%  probe    -- a struct that has field fea(image's feature) and its label for probe
%  matrix_param.distance_type --'cos' 'L2'
%output:
%  analysis
%
%
%Jun Hu
%2017-3
distance_type='cos';
if nargin<3
   matrix_param=[];
end
if isfield(matrix_param,'distance_type')
    distance_type=matrix_param.distance_type;
end
for i_p=1:length(probe)
    fprintf('get_analysis matrix i_p:%d\n',i_p);
    for i_g=1:length(gallery)
        if strcmp(distance_type,'cos')
            result(i_g).score=compute_cosine_score(gallery(i_g).fea,probe(i_p).fea);
        else
            result(i_g).score=pdist2(gallery(i_g).fea',probe(i_p).fea');
        end
        analysis.distance_matrix(i_p,i_g)=result(i_g).score;
        analysis.gallery_info(i_g).name=gallery(i_g).name;
        analysis.gallery_info(i_g).label=gallery(i_g).label;
        analysis.probe_info(i_p).name=probe(i_p).name;
        analysis.probe_info(i_p).label=probe(i_p).label;
    end
    
    if strcmp(distance_type,'cos')
        [sort_score,index]=sort([result.score],'descend');
    else
        [sort_score,index]=sort([result.score]);
    end
    analysis.sort_matrix(i_p,:)=index;
end

end
