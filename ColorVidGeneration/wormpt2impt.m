function imPt=wormpt2impt(WormPt,GridSize,BoundaryA,BoundaryB,Centerline)

DV=1; %Dorsal Ventral Dimension
AP=2; %Anterior Posterior Dimension
xx=1;
yy=2;

%Distance from centerline to boundary in dorsal/ventral plane in worm space
W_radDV=(GridSize(xx)-1)/2;

if WormPt(DV)>0
    Boundary=BoundaryA;
    sign=1;
else
    Boundary=BoundaryB;
    sign=-1;
end
I_radDV=Boundary(max(1,1+WormPt(AP)),:)- Centerline(max(1,(1+WormPt(AP))),:);
imPt=round(Centerline(max(1,1+WormPt(AP)),:)+ ( WormPt(DV) / W_radDV ).*sign .* I_radDV);
