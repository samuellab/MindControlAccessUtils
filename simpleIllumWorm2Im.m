function [x, y] =simpleIllumWorm2Im(mcdf,W_GridSize)
%Convert the rectangle illumination specified in worm coordinates
%into a list of vertices in camera coordinates

BoundaryA=reshape(mcdf.BoundaryA,2,[])';
BoundaryB=reshape(mcdf.BoundaryB,2,[])';
C=reshape(mcdf.SegmentedCenterline,2,[])';

%Origin and extent of illumination rectangle in worm space
W_orig=mcdf.IllumRectOrigin;
W_extent=mcdf.IllumRectRadius;

%Origin in Image space
I_orig=C(1+W_orig(2),:);

l=length(C);

%First find four vertices in Image space without interpolating
DV=1; %Dorsal Ventral Dimension
AP=2; %Anterior Posterior Dimension
xx=1;
yy=2;

W_vertA= W_orig+W_extent*[1 0;0 1];

%%Let's convert W_vertA to I_vertA
W_GridSize=[21,100];

%If we need to flip left/right in worm coordinate space
if mcdf.IllumFlipLR
    flipLR=[-1 0; 0 1];
else
    flipLR=[1 0; 0 1];
end


Vert(1,:)=clipAnteriorPosterior( W_orig+W_extent*[1 0;0 1], W_GridSize(AP))*flipLR;
Vert(2,:)=clipAnteriorPosterior( W_orig+W_extent*[-1 0;0 1], W_GridSize(AP))*flipLR;
Vert(3,:)=clipAnteriorPosterior( W_orig+W_extent*[-1 0;0 -1], W_GridSize(AP))*flipLR;
Vert(4,:)=clipAnteriorPosterior( W_orig+W_extent*[1 0;0 -1], W_GridSize(AP))*flipLR;


W_intV=interpDVvertices(Vert);

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


