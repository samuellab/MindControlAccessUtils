%This will plot a worm

videoIn='C:\Documents and Settings\andy\My Documents\Publication\RawSupplementaryVideo\20100720_1735_egl6ChR_12.avi';

figure(1);
figure(2);
sign=-1;

startf=6762;
endf=9524;

obj=mmreader(videoIn);

DISPLAY=0;

m=1;
for k=1:length(mcdf)
    if (m>obj.NumberOfFrames)
        disp(['m=' num2str(m)])
        disp('m is larger than the number of frames in the video.. breaking..');
        break;
    end
    if (mcdf(k).FrameNumber <= endf ) && (mcdf(k).FrameNumber >= startf )
        if mod(mcdf(k).FrameNumber,100)==0
            disp(num2str(mcdf(k).FrameNumber))
        end
        
        w=mcdf(k);
        BoundaryA=reshape(w.BoundaryA,2,[])';
        BoundaryB=reshape(w.BoundaryB,2,[])';
        C=reshape(w.SegmentedCenterline,2,[])';
        orig=w.IllumRectOrigin;
        C(1+orig(2),:);
        
        
        
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
        currentFrame=obj.read(m);
        m=m+1; %increment frame
        
        
        
 
        
        
        %If the DLP is off
        if (mcdf(k).DLPisOn)
            %how much of the other channels should shine through in the roi
            factor=1; %not much when the laser is on.. only the blue channel
        else
            factor=.2; %most of the other channels should shine through.. it should only be tinged blue
            
        end
        
        
        %the other channels should be zero where the
        %laser is illuminated (the roi)
        merge(:,:,3)=uint8( currentFrame(:,:,3)+factor.*255.*uint8(mask) );
        merge(:,:,1)=uint8( uint8(currentFrame(:,:,1)-150.*uint8(mask) ) +factor.*50.*uint8(mask) );
        merge(:,:,2)=uint8( uint8(currentFrame(:,:,1)-150.*uint8(mask) )+factor.*50.*uint8(mask) );
        
        

        %insert frame stamp
       merge=insertText(merge,num2str(mcdf(k).FrameNumber),1);
       if (mcdf(k).DLPisOn) 
       merge=insertText(merge,'DLP On',0);
       end
        imwrite(merge,['vidOut/' num2str(k) '.jpg'],'Quality',100)
        
        if (DISPLAY)
            figure(2);
            imshow(merge);
            pause
        end
        
       
    end
end
aviobj = close(aviobj);