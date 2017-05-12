;;;; package.lisp

(defpackage #:gsl-cffi
  (:use #:cl #:iterate #:let-plus)
  (:export
   #:version
   #:unsupported-gsl-version
   #:gsl-error
   #:get-array-random-uniform
   #:random-uniform
   #:random-gaussian
   #:get-random-number-generator
   #:create-integration-function
   #:set-error-handler
   #:gsl-error-handler
   #:gsl-multifit-fdfsolver-alloc
   #:*gsl-multifit-fdfsolver-lmsder*
   #:gsl-vector-alloc
   #:fdf-struct
   #:f
   #:df
   #:fdf
   #:n
   #:p
   #:params
   #:gsl-multifit-fdfsolver-set
   #:gsl-multifit-fdfsolver-iterate
   #:+GSL_SUCCESS+
   #:type
   #:x
   #:J
   #:dx
   #:state
   #:fdf-solver
   #:gsl-multifit-test-delta
   #:*cb-fit-lambda*
   #:gsl-multifit-fdfsolver-free
   #:gsl-vector-free
   #:gsl-vector-get
   #:gsl-vector-set
   #:gsl-multifit-covar
   #:gsl-blas-dnrm2
   #:gsl-matrix-get
   #:gsl-matrix-alloc
   #:gsl-matrix-free
   #:gsl-vector
   #:with-fdf-solver))


