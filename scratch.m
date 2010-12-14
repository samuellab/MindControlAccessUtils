%This will plot a worm



figure(1);
figure(2);
sign=-1;

startf=2958;
endf=9914;

for k=1:length(mcdf)
    
    if (mcdf(k).FrameNumber <= endf ) && (mcdf(k).FrameNumber >= startf )
    
    figure(1)
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
    C(1+orig(2),:)
    plot(C(1+orig(2),1),sign.*C(1+orig(2),2),'o');
    
    
    [x, y]=simpleIllumWorm2Im(w,[21,100])
    plot(x,sign.*y,'ro')
    
    
    
    hold off
    xlim([0,1024])
    ylim([-768,0])
    
    figure(2);
    imshow(poly2mask(x, y, 768,1024));
    
    
    
    pause
    end
end