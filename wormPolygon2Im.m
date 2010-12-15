function [x, y] =wormPolygon2Im(mcdf,W_GridSize,polygon)
%Convert the rectangle illumination specified in worm coordinates
%into a list of vertices in camera coordinates
%
% Polygon is two columns, the first with dorsal ventral coordinates
% the second column with anterior-posterior coordinates
% each row corresponds to a different vertex
% 
% Note these polygons can be what I call `sparse` polygons.. e.g. if they 
% rectangular in worm space, they can be defined by only 4 points, even
% though more than four points are necessary to define the polygon in image
% space. This function will caclulate the additional points required to
% define the polygon in camera space. 


BoundaryA=reshape(mcdf.BoundaryA,2,[])';
BoundaryB=reshape(mcdf.BoundaryB,2,[])';
C=reshape(mcdf.SegmentedCenterline,2,[])';

l=length(C);

%First find four vertices in Image space without interpolating
DV=1; %Dorsal Ventral Dimension
AP=2; %Anterior Posterior Dimension
xx=1;
yy=2;



%%Let's convert W_vertA to I_vertA
W_GridSize=[21,100];

%If we need to flip left/right in worm coordinate space
if mcdf.IllumFlipLR
    flipLR=[-1 0; 0 1];
else
    flipLR=[1 0; 0 1];
end





W_intV=interpDVvertices(polygon);

for k=1:length(W_intV)

    temp=wormpt2impt(W_intV(k,:),W_GridSize,BoundaryA,BoundaryB,C);
    x(k)=temp(1);
    y(k)=temp(2);
end



function Wpt_out=clipAnteriorPosterior(Wpt,MaxAP)
%This function truncate the worm points in the anterior-posterior
%dimension. For example, if the anterior-posterior dimension only has a gridsize 
% of 100 pts, and a point is given of 125 then this outputs 100
%
%

%Dorsal-Ventral value is the same
Wpt_out(1)=Wpt(1);
Wpt_out(2)=min(Wpt(2),MaxAP-1);



