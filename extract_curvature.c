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
#define INPUT2  prhs[1]

/* Output Arguments */

#define	OUTPUT1	plhs[0]
#define OUTPUT2 plhs[1]


void extract_curvature(double *head_centerline, double *curv_buffer,
		               double *k_mean, double *curv_buffer_new,
		               mwSize n1, mwSize n2)
{
	 mwSize i;
	 double *x, *y, *diff_x, *diff_y, *theta, *k;
	 double sum_k;


	 y=head_centerline+n1;  /* y coordinate */
	 x=head_centerline;    /* x coordinate */


	 diff_x = (double *) calloc(n1-1, sizeof(double));  /* difference of adjacent x coordinate */
	 diff_y = (double *) calloc(n1-1, sizeof(double)); /* difference of adjacent y coordinate */
	 theta = (double *) calloc(n1-1, sizeof(double)); /* angle of the tangent vector */
	 k = (double *) calloc(n1-2, sizeof(double)); /* head curvature */



	 for (i=0;i<n1-1;i++){
		 *(diff_x+i) = *(x+i+1)-*(x+i);
		 *(diff_y+i) = *(y+i+1)-*(y+i);
		 *(theta+i) = atan2(-*(diff_y+i),*(diff_x+i)); /* calculate the angle of tangent vector */
		 }

	 sum_k=0;

	 for (i=0; i<n1-2; i++){
		 *(k+i)=*(theta+i+1)-*(theta+i); /* calculate the curvature */
		 sum_k+=*(k+i);
	 }

	 *k_mean=sum_k/(n1-2); /* mean head curvature */

	      
     for (i=0;i<n2-1;i++){
	 	 	*(curv_buffer_new+i)=*(curv_buffer+i+1); /* store new curvature queue */
	 }
	 *(curv_buffer_new+n2-1)=*k_mean;
     
     free (diff_x);
     free (diff_y);
     free (theta);
     free (k);

}

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
	double *head_centerline,*curv_buffer;
	double *k, *k_dot, *curv_buffer_new;
	mwSize m1,n1,m2,n2;


	if (nrhs != 2) {
		mexErrMsgTxt("Two input arguments required.");
	    }
	else if (nlhs !=2) {
		mexErrMsgTxt("Two output arguments required.");
	    }

	m1 = mxGetM(INPUT1);
	n1 = mxGetN(INPUT1);
	m2 = mxGetM(INPUT2);
	n2 = mxGetN(INPUT2);

	if (!mxIsDouble(INPUT1) || mxIsComplex(INPUT1) ||
		(n1 != 2)) {
		mexErrMsgTxt("centerline requires to be a 2 column real matrix");
	    }

	if (!mxIsDouble(INPUT2) || mxIsComplex(INPUT2) ||
	    (m2 != 1)) {
		mexErrMsgTxt("curvature buffer must be a one row real array");
		}


	head_centerline = mxGetPr(INPUT1);
	curv_buffer = mxGetPr(INPUT2);


	OUTPUT1=mxCreateDoubleMatrix(1, 1, mxREAL);
	OUTPUT2=mxCreateDoubleMatrix(1, n2, mxREAL);

	k=mxGetPr(OUTPUT1);
	curv_buffer_new=mxGetPr(OUTPUT2);

	extract_curvature(head_centerline,curv_buffer,k,curv_buffer_new,m1,n2);

	return;


}
