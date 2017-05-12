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


;;;; convenience functionality


(defmacro with-fdf-solver ((solver-name no-data-points no-fit-params
			    fn->fill-initial-gsl-vector f
			    &key (solver-type 'gsl-cffi:*gsl-multifit-fdfsolver-lmsder*)
				 (df '(cffi:null-pointer))
				 (fdf '(cffi:null-pointer))
				 (params '(cffi:null-pointer)))
			   &body body)
  (alexandria:once-only (no-data-points no-fit-params fn->fill-initial-gsl-vector)
    (alexandria:with-gensyms (initial-vector)
      `(let ((,solver-name (gsl-cffi:gsl-multifit-fdfsolver-alloc ,solver-type
								  ,no-data-points
								  ,no-fit-params))
	     (,initial-vector (gsl-cffi:gsl-vector-alloc ,no-fit-params)))
	 (unwind-protect
	      (cffi:with-foreign-objects ((/fdf/ '(:struct gsl-cffi:fdf-struct)))
		(cffi:with-foreign-slots ((gsl-cffi:f gsl-cffi:df gsl-cffi:fdf
						      gsl-cffi:n gsl-cffi:p
						      gsl-cffi:params)
					  /fdf/ (:struct gsl-cffi:fdf-struct))
		  (setf gsl-cffi:f ,f
			gsl-cffi:df ,df
			gsl-cffi:fdf ,fdf
			gsl-cffi:n ,no-data-points
			gsl-cffi:p ,no-fit-params
			gsl-cffi:params ,params))
		(gsl-cffi:gsl-multifit-fdfsolver-set ,solver-name /fdf/
						     (funcall ,fn->fill-initial-gsl-vector ,initial-vector))
		(progn ,@body))
	   (progn (gsl-cffi:gsl-multifit-fdfsolver-free ,solver-name)
		  (gsl-cffi:gsl-vector-free ,initial-vector)))))))
