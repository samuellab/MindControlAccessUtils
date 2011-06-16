


%This script  will take an unannotated video of an experiment that starts
%with YAML frame startf and ends with YAML frame endf. This script goes
%through and annotates the video with color annotations showing where the
%illumination pattern is at each frame.
%
% Why this whole kludgy setup? For speed and simplicity, the MindControl
% software works exclusive in grayscale. When you use MindControl it
% records two video transcripts of the experiments. One is the raw video of
% the worm. The other is annotated video. In the annotated video,
% the software draws on the worm where it is sending illumination. 
% This provides an immutable record and is very useful for debugging.
%
% If we want color video, we have to regenerate the illumination pattern
% from the YAML data files  and lay that on top of the raw video. This is
% kludgy. This is what is going on here. Ultimately you would only use this
% for aesthetics, for example to create figures that go in a
% publication  or presentation. 
%
% It is important to note that we are dealign with a number of different
% indexign schemes.
%
% The startf and endf frames are specified using the HUDS internal frame
% number, as soon on the _HUDS.avi video produced by MindControl.
% 
% There are certain assumptions made about the video spoecified at videoIn 
% as well. Specifically the startf frame should appear in the videoIn
% exactly nOffsetFrames into the video.
%

YAML='D:\Temp\20110218_1624_rig3ChR2_3.yaml'

startf=7500; %HUDS internal frame number (not nth frame)
endf=8200;


videoIn='D:\Temp\20110218_1624_rig3ChR2_3_repro.avi';

 %If the frame in startf is not the first frame in the video file specified
 %by videoIn, then we must specify the number of frames into the video that it
 %lies. In other words, the HUDS frame number "startf" is the
 %nOffsetFrames'nth frame in the video videoIn.
 
nOffsetFrames=5948;
GREEN=2;
BLUE=3;

COLOR=BLUE; %Green is 2. Blue is 3. (RGB)

CHANGE_BRIGHTNESS_WITH_LASER = 1; % change the brightness with the laser and turn off the colored curser 



DISPLAY=0 %Show a debugging display of whats going on
READINYAML=0 %Read in the YAML (required the first time) 
CREATE_HUDS=1 %Create the heads up display (frame number, DLP on display)

%whether we want to manually enter the illumination region or would rather
%use a protocl
manual=1; 

%Protocol Information
if (manual>0)
    manuallyEnteredProtocol %protocol is specified in this .m file
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run ..\SetupPaths.m

sign=-1;

obj=mmreader(videoIn);

if READINYAML
    %Read in YAML
    mcdf=Mcd_Frame;
    mcdf=mcdf.yaml2matlab(YAML);
else
    disp('Skipping reading in YAML... (are you sure thats a good idea?)');
end



if DISPLAY
    figure(1);
    figure(2);
end

disp('Generating output video..')

m=1+nOffsetFrames;
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
        
        w=mcdf(k); %current frame
        BoundaryA=reshape(w.BoundaryA,2,[])';
        BoundaryB=reshape(w.BoundaryB,2,[])';
        C=reshape(w.SegmentedCenterline,2,[])';
       
        
        
        
        if (DISPLAY)
            figure(1)
            plot(w.Head(1),sign.*w.Head(2),'.')
            hold on;
            plot(w.Tail(1),sign.*w.Tail(2),'^')
            plot(BoundaryA(:,1),sign.*BoundaryA(:,2))
            plot(BoundaryB(:,1),sign.*BoundaryB(:,2))
            plot(C(:,1),sign.*C(:,2),'r');
            orig=w.IllumRectOrigin;
            plot(C(1+orig(2),1),sign.*C(1+orig(2),2),'o');
        end
        
        if w.ProtocolIsOn==0
            [x, y]=simpleIllumWorm2Im(w,[21,100]);
        else
            if manual==0
                error('Help! The MindControl software used a protocol, but we do not seem to have access to that protocol. You must manually enter it using the manually entered protocol option.');
            end
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
        
        
        
        
        
        
        %If the DLP is on
        if (mcdf(k).DLPisOn)
            %how much of the other channels should shine through in the roi
            
            if CHANGE_BRIGHTNESS_WITH_LASER==1
                if COLOR==BLUE
                    factor=mcdf(k).BlueLaser / 100;
                elseif COLOR==GREEN
                    factor=mcdf(k).GreenLaser / 100;
                end
            else
            
                factor=1; %not much when the laser is on.. only the blue channel
            end
        else
            %The DLP is off
            if CHANGE_BRIGHTNESS_WITH_LASER==1
                 factor=0; %if the brightenss of the spot varies with the laser and the laser is off, then we shouldn't show anything
            else
                %if we are in curser mode than we should make a small
                %curosr to see where we are about to stimulate
                 factor=.2; %most of the other channels should shine through.. it should only be tinged blue
            end
            
        end
        
        
        %the other channels should be zero where the
        %laser is illuminated (the roi)
        merge(:,:,COLOR)=uint8( currentFrame(:,:,COLOR)+factor.*255.*uint8(mask) );
        %Set the other two colors
        merge(:,:,mod(COLOR,3)+1)=uint8( uint8(currentFrame(:,:,mod(COLOR+1,3)+1)-uint8(factor.*150).*uint8(mask) ) +factor.*50.*uint8(mask) );
        merge(:,:,mod(COLOR+1,3)+1)=uint8( uint8(currentFrame(:,:,mod(COLOR+2,3)+1)-uint8(factor.*150).*uint8(mask) )+factor.*50.*uint8(mask) );
        
        
        
        %insert frame stamp
        if CREATE_HUDS==1
            merge=insertText(merge,num2str(mcdf(k).FrameNumber),1);
        end
        if (mcdf(k).DLPisOn && CREATE_HUDS==1)
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
