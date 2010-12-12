%This will plot a worm



figure;

sign=-1;

startf=5000;
endf=6000;

for k=max(1,startf):min(endf,length(mcdf))
    
w=mcdf(k);
plot(w.Head(1),sign.*w.Head(2),'.')
hold on;
plot(w.Tail(1),sign.*w.Tail(2),'^')
BoundaryA=reshape(w.BoundaryA,2,[])';
plot(BoundaryA(:,1),sign.*BoundaryA(:,2))
BoundaryB=reshape(w.BoundaryB,2,[])';
plot(BoundaryB(:,1),sign.*BoundaryB(:,2))
C=reshape(w.SegmentedCenterline,2,[])';
plot(C(:,1),sign.*C(:,2),'r');

orig=w.IllumRectOrigin
C(orig(2),:)
plot(C(orig(2),1),sign.*C(orig(2),2),'o');


[x, y]=simpleIllumWorm2Im(w,[21,100])
plot(x,sign.*y,'ro')
hold off
xlim([0,1024])
ylim([-768,0])
pause
end