Welcome to MindControl AccessUtils
==================================

This is a series of scripts in MATLAB to import data from YAML files created by the [MindControl][1] software. This is different from the [MindControl-analysis][2] suite in that it is simple, compact and lacks a GUI. 

  [1]: http://github.com/samuellab/mindcontrol
  [2]: http://github.com/samuellab/mindcontrol-analysis

Quick Start
===========


setupPaths; %Add the appropriate paths.
YAML=C:\Path\To\YAML\File\mydata.yaml; %YAML data file generated  by MindControl software
mcdf=Mcd_Frame; %create MindControl data frame object
mcdf=mcdf.yaml2matlab(YAML); %Import YAML into mcdf data object
 


Authors
-------
MindControl AccessUtils is written by Andrew Leifer with help from Marc Gershow.

Requirements
-----------
MindControl Access Utils was tested on MATLAB v.7.8.0.347 (R2009a). 

License
-------
MindControl Access Utils is released under the GNU Public License. This means you are free to copy, modify and redistribute this software. 

Contact
=======
Please contact Andrew Leifer, leifer (at) fas (dot) harvard.edu with questions or feedback.


