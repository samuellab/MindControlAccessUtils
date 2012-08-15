
function newvals=dropCorrespondingVals(Mcd_Frame, vals, dropFrames)
% Often one has a list of values, say the velocity of the worm at each
% frame, v, and one wishes to toss out all points corresponding to
% instances wehre the segmentation failed. Given a list of HUD
% frames to be omitted, dropFrames, this function will inspect the
% Mcd_Frame object, find the frames to be omitted and drop the corresonding
% points from the values v and output a new list of values.
%
% Mcd_Frame the mindcontrol data format object
% vals  a vector of values with same length as Mcd_Frame
% dropFrames a vector of HUD frames to be dropped 
%
%(recall HUD is the frame number that shows up inside the _HUDS video. 
% This is distinct from the n'th frame rocorded)
%
% Andrew Leifer
% leifer@post.harvard.edu
% 15 August 2012


assert(length(Mcd_Frame)==length(vals),'vals and the Mcd_Frame object appear to have different length');
assert(ndims(vals)<3,'vals should be a vector, not a matrix')
assert(ndims(dropFrames)<3,'dropFrames should be a vector, not a matrix')

%Find all dropFrames inside the mcdf object
[d,~,ind]=intersect(dropFrames,[Mcd_Frame.FrameNumber]);

    if isempty(d)
       newvals=vals;
    else
        vals(ind)=[];
        newvals=vals;
    end
end