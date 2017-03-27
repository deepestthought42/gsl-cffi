(in-package #:gsl-cffi)


(cffi:defcvar ("gsl_multifit_fdfsolver_lmsder" :read-only t) :pointer)



(cffi:defctype fsolver :pointer)

(cffi:defcstruct fdf-struct
  (f :pointer)
  (df :pointer)
  (fdf :pointer)
  (n size-t)
  (p size-t)
  (params :pointer))


;; typedef struct
;;   {
;;     const gsl_multifit_fdfsolver_type * type;
;;     gsl_multifit_function_fdf * fdf ;
;;     gsl_vector * x;
;;     gsl_vector * f;
;;     gsl_matrix * J;
;;     gsl_vector * dx;
;;     void *state;
;;   }
;; gsl_multifit_fdfsolver;


(cffi:defcstruct fdf-solver
  (type :pointer)
  (fdf :pointer)
  (x gsl-vector)
  (f gsl-vector)
  (J :pointer)
  (dx gsl-vector)
  (state (:pointer :void)))

(defparameter *cb-fit-lambda*
  #'(lambda (x ldata f)
      (declare (ignore x ldata f))
      (error "Did you forget to register a callback for the fit function ?")
      +GSL_FAILURE+))

(cffi:defcallback cb-fit-function
    :int
    ((x gsl-vector)
     (ldata :pointer)
     (f gsl-vector))
  ;; call thread local variable
  (funcall *cb-fit-lambda* x ldata f))


(cffi:defcfun ("gsl_multifit_fdfsolver_alloc")
    fsolver
  (solver-type :pointer)
  (data-count size-t)
  (no-params size-t))

(cffi:defcfun ("gsl_multifit_fdfsolver_free")
    :void
  (solver-type :pointer))

(cffi:defcfun ("gsl_multifit_fdfsolver_set")
    :int
  (solver fsolver)
  (f (:pointer (:struct fdf-struct)))
  (params gsl-vector))

(cffi:defcfun ("gsl_multifit_test_delta")
    :int
  (dx gsl-vector)
  (x gsl-vector)
  (eps-abs :double)
  (eps-rel :double))


(cffi:defcfun ("gsl_multifit_fdfsolver_iterate")
    :int
  (s fsolver))



;; void handler (const char * reason, 
;;               const char * file, 
;;               int line, 
;;               int gsl_errno)


(cffi:defcallback gsl-error-handler
    :void
    ((reason :string)
     (file :string)
     (line :int)
     (gsl-errno :int))
  (error "GSL signalled error ~a in ~a:~a | ~a"
	 gsl-errno file line reason))

;; gsl_error_handler_t * gsl_set_error_handler (gsl_error_handler_t * new_handler)
(cffi:defcfun ("gsl_set_error_handler")
    :pointer
  (handler :pointer))


(cffi:defctype matrix :pointer)

(cffi:defcfun ("gsl_matrix_alloc")
    matrix
  (m size-t)
  (n size-t))

(cffi:defcfun ("gsl_matrix_get")
    :double
  (matrix matrix)
  (row size-t)
  (column size-t))

(cffi:defcfun ("gsl_matrix_free")
    :void
  (m matrix))

(cffi:defcfun ("gsl_blas_dnrm2")
    :double
  (vec gsl-vector))

;int gsl_multifit_covar (const gsl_matrix * J, double epsrel, gsl_matrix * covar)
(cffi:defcfun ("gsl_multifit_covar")
    :int
  (J matrix)
  (eps-rel :double)
  (covar matrix))


