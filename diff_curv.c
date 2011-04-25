/*
 * extract_curvature.c
 *
 *  Created on: Apr 21, 2011
 *      Author: Quan Wen
 */
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include "mex.h"


/* Input Arguments */

#define	INPUT1	prhs[0]


/* Output Arguments */

#define	OUTPUT1	plhs[0]



void diff_curv(double *curv_buffer, double *k_dot, mwSize n)
{
    mwSize i;
    double s_xx, s_xy, s_x, s_y, delta;
    
    s_y=0;
    s_xy=0;
    s_xx=0;
    s_x=n*(n-1)/2;
    
    for (i=0;i<n;i++){
        s_xx+=i*i;
        s_y+=*(curv_buffer+i);
        s_xy+=(*(curv_buffer+i))*i;
    }
        
    delta=n*s_xx-s_x*s_x;  
    *k_dot=(n*s_xy-s_x*s_y)/delta;  /*using linear fit to find the slope k_dot */
     
    
    
}

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
	double *curv_buffer;
	double *k_dot;
	mwSize m,n;


	if (nrhs != 1) {
		mexErrMsgTxt("One input arguments required.");
	    }
	else if (nlhs !=1) {
		mexErrMsgTxt("One output arguments required.");
	    }

	m = mxGetM(INPUT1);
	n = mxGetN(INPUT1);
	
	if (!mxIsDouble(INPUT1) || mxIsComplex(INPUT1) ||
		(m != 1)) {
		mexErrMsgTxt("the buffer should be a one row array");
	    }

	curv_buffer = mxGetPr(INPUT1);


	OUTPUT1=mxCreateDoubleMatrix(1, 1, mxREAL);
	
	k_dot=mxGetPr(OUTPUT1);
	
	diff_curv(curv_buffer,k_dot,n);

	return;


}
