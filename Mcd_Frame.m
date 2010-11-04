classdef Mcd_Frame
    %mind control data
    properties
        FrameNumber %internal frame number, not nth recorded frame
        TimeElapsed %time since start of experiment (in s)
        Head %position in pixels on camera
        Tail %position in pixels on camera
        BoundaryA %2*N length vector xyxyxy position in pixels on camera
        BoundaryB %2*N length vector xyxyxy position in pixels on camera
        SegmentedCenterline %2*N length vector xyxyxy position in pixels on camera
        DLPisOn %bool whether DLP is active
        FloodLightIsOn %flood light overrides all other patterns and hits entire fov
        IllumInvert %whether pattern is inverted (invert has precedence over floodlight)
        IllumFlipLR %flips output left/right with respect to worm's body
        IllumRectOrigin %center of the freehand rectangular illumination in wormspace
        IllumRectRadius %xy value describing dimension of rectangle
        StageVelocity %velocity sent to stage in stage units/second
        ProtocolIsOn %bool whether you're using protocol
        ProtocolStep %what step within protocol is currently selected
    end
        
end
    