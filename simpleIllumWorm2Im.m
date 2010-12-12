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

W_vertA= W_orig+W_extent*[1 0;0 1];

%%Let's convert W_vertA to I_vertA
W_GridSize=[21,100]

%Distance from centerline to boundary in dorsal/ventral plane in worm space
W_radDV=(W_GridSize(xx)-1)/2;

%Radius vector for this particular anterior/posterior point in image space
I_radDV=BoundaryA(W_vertA(AP),:)- C(W_vertA(AP),:);
I_vertA=C(W_vertA(AP),:)+ ( W_vertA(DV) / W_radDV ) .* I_radDV;

x=I_vertA(xx);
y=I_vertA(yy);

