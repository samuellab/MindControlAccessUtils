function interpVert=interpDVvertices(vert)
%Given a list of vertices defining a polygon (with > 4 vertices)
% with  vert(j,1) the dorsal-ventral dimension and vert(j,2) the 
% anterior-posterior dimension, this function will
% interpolate and fill in the dorsal-ventral points for every anterior-posterior point that 
% the edges that define the polygon traverses. 

DV=1;
AP=2;

numVert=size(vert,1);
if numVert<4
    error('There are not enough vertices defined here.')
end

interpVert=[];
for k=1:numVert
    newAPpts=walk(vert(k,AP),vert(1+mod(k,numVert),AP));
    interpVert(end+1:end+length(newAPpts),1:2)= [ones(length(newAPpts),1).*vert(k,DV) newAPpts'];
    
    %If the vertices weren't the same, then subtract one off. 
    if length(newAPpts)>1
        interpVert(end,:)=[]; 
    end
end