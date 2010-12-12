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
I_orig=C(W_orig(2),:);

l=length(C);

%First find four vertices in Image space without interpolating
DV=1; %Dorsal Ventral Dimension
AP=2; %Anterior Posterior Dimension
xx=1;
yy=2;

W_vertA= W_orig+W_extent*[1 0;0 1]

%%Let's convert W_vertA to I_vertA
W_GridSize=[21,100]


I_vertA=wormpt2impt(W_vertA,W_GridSize,BoundaryA,BoundaryB,C);
x(1)=I_vertA(xx);
y(1)=I_vertA(yy);


W_vertB= W_orig+W_extent*[-1 0;0 1]
I_vertB=wormpt2impt(W_vertB,W_GridSize,BoundaryA,BoundaryB,C);
x(2)=I_vertB(xx);
y(2)=I_vertB(yy);



