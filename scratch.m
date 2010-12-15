


%This script  will take an unannotated video of an experiment that starts
%with YAML frame startf and ends with YAML frame endf. This script goes
%through and annotates the video with color annotations showing where the
%illumination pattern is at each frame.

YAML='D:\WormIllum\100818\20100818_1631_myo3Halo_1.yaml'
videoIn='C:\Documents and Settings\andy\My Documents\Publication\RawSupplementaryVideo\20100818_1631_myo3Halo_1.avi';

COLOR=2; %Green is 2. Blue is 3. (RGB)

startf=6592;
endf=7337;


DISPLAY=0
READINYAML=1


%Protocol Information
manuallyEnteredProtocol



%%%%%%%%%%

sign=-1;

obj=mmreader(videoIn);

if READINYAML
    %Read in YAML
    mcdf=Mcd_Frame;
    mcdf=mcdf.yaml2matlab(YAML);
end



if DISPLAY
    figure(1);
    figure(2);
end


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
        
        if w.ProtocolIsOn==0
            [x, y]=simpleIllumWorm2Im(w,[21,100]);
        else
            [x,y]=wormPolygon2Im(w,protocolGridSize,protocol(:,:,w.ProtocolStep+1));
        end
            
        if (DISPLAY)
            plot(x,sign.*y,'ro')
            
            hold off
            xlim([0,1024])
            ylim([-768,0])
        end
        
        %Make a binary mask based on the polygon and resize it to be the size
        %of the frame that we are reading in
        mask = imresize(poly2mask(x, y, 768,1024), [obj.Height obj.Width]);
        
        if mcdf(k).IllumInvert
            %invert the mask
            mask=ones(size(mask))-mask;
        end
        
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
        merge(:,:,COLOR)=uint8( currentFrame(:,:,COLOR)+factor.*255.*uint8(mask) );
        %Set the other two colors
        merge(:,:,mod(COLOR,3)+1)=uint8( uint8(currentFrame(:,:,mod(COLOR+1,3)+1)-uint8(factor.*150).*uint8(mask) ) +factor.*50.*uint8(mask) );
        merge(:,:,mod(COLOR+1,3)+1)=uint8( uint8(currentFrame(:,:,mod(COLOR+2,3)+1)-uint8(factor.*150).*uint8(mask) )+factor.*50.*uint8(mask) );
        
        
        
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
