%This will plot a worm

videoIn='D:\WormIllum\100720\20100720_1735_egl6ChR_12_HUDS.avi';

figure(1);
figure(2);
sign=-1;

startf=2958;
endf=9914;

obj=mmreader(videoIn);

DISPLAY=0;


for k=1:length(mcdf)
    
    if (mcdf(k).FrameNumber <= endf ) && (mcdf(k).FrameNumber >= startf )
        
        w=mcdf(k);
        BoundaryA=reshape(w.BoundaryA,2,[])';
        BoundaryB=reshape(w.BoundaryB,2,[])';
        C=reshape(w.SegmentedCenterline,2,[])';
        orig=w.IllumRectOrigin
        C(1+orig(2),:)
        
        
        
        if (DISPLAY)
            figure(1)
            plot(w.Head(1),sign.*w.Head(2),'.')
            hold on;
            plot(w.Tail(1),sign.*w.Tail(2),'^')
            plot(BoundaryA(:,1),sign.*BoundaryA(:,2))
            plot(BoundaryB(:,1),sign.*BoundaryB(:,2))
            plot(C(:,1),sign.*C(:,2),'r');
            plot(C(1+orig(2),1),sign.*C(1+orig(2),2),'o');
        end
        
        [x, y]=simpleIllumWorm2Im(w,[21,100]);
        
        if (DISPLAY)
            plot(x,sign.*y,'ro')
            
            hold off
            xlim([0,1024])
            ylim([-768,0])
        end
        
        %Make a binary mask based on the polygon and resize it to be the size
        %of the frame that we are reading in
        mask = imresize(poly2mask(x, y, 768,1024), [obj.Height obj.Width]);
        
        %invert the mask
        invMask=ones(size(mask))-mask;
        
        
        %Read in the current frame
        currentFrame=obj.read(k);
        
        
        
        %Copy over the channel corresponding to the color we are interested in
        merge(:,:,3)=currentFrame(:,:,3);
        
        
        
        
        %If the DLP is off
        if (mcdf(k).DLPisOn)
            %how much of the other channels should shine through in the roi
            factor=0; %nothing whent he laser is on.. only the blue channel
        else
            factor=.7; %most of the other channels should shine through.. it should only be tinged blue
            
        end
        
        
        %the other channels should be zero where the
        %laser is illuminated (the roi)
        merge(:,:,1)=currentFrame(:,:,1).*uint8(invMask)+  uint8(factor.* (uint8(mask).*currentFrame(:,:,1))) ;
        merge(:,:,2)=currentFrame(:,:,2).*uint8(invMask)+  uint8(factor.* (uint8(mask).*currentFrame(:,:,2))) ;
        
        
        
        if (DISPLAY)
            figure(2);
            imshow(merge);
        end
        
        pause
    end
end