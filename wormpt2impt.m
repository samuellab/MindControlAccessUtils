function imPt=wormpt2impt(WormPt,GridSize,BoundaryA,BoundaryB,Centerline)

DV=1; %Dorsal Ventral Dimension
AP=2; %Anterior Posterior Dimension
xx=1;
yy=2;

%Distance from centerline to boundary in dorsal/ventral plane in worm space
W_radDV=(GridSize(xx)-1)/2;
I_radDV=BoundaryA(WormPt(AP),:)- C(WormPt(AP),:);
imPt=C(WormPt(AP),:)+ ( WormPt(DV) / W_radDV ) .* I_radDV;