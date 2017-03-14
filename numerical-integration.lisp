(in-package #:gsl-cffi)




;;;; gsl cquad integration

(cffi:defcfun ("gsl_integration_cquad_workspace_alloc" cquad-create-workspace)
    (:pointer :void)
  (no-intervals :unsigned-int))

(cffi:defcfun ("gsl_integration_cquad_workspace_free" cquad-free-workspace)
    :void
  (workspace (:pointer :void)))


(declaim (ftype (function (cffi:foreign-pointer
			   double-float double-float
			   double-float double-float
			   cffi:foreign-pointer
			   cffi:foreign-pointer
			   cffi:foreign-pointer
			   cffi:foreign-pointer)
			  integer)
		gsl-integration-cquad))

(cffi:defcfun ("gsl_integration_cquad" gsl-integration-cquad)
    :int
  (function :pointer)
  (a :double)
  (b :double)
  (epsabs :double)
  (epsrel :double)
  (workspace :pointer)
  (result (:pointer :double))
  (abserror (:pointer :double))
  (nevals (:pointer :unsigned-int)))


(declaim (ftype (function (cffi:foreign-pointer
			   double-float double-float
			   double-float double-float
			   cffi:foreign-pointer
			   cffi:foreign-pointer
			   cffi:foreign-pointer)
			  integer)
		gsl-integration-qng))

(cffi:defcfun ("gsl_integration_qng")
        :int
  (function :pointer)
  (a :double)
  (b :double)
  (epsabs :double)
  (epsrel :double)
  (result (:pointer :double))
  (abserror (:pointer :double))
  (nevals (:pointer :unsigned-int)))


(cffi:defcstruct gsl-function
  (cb :pointer)
  (params :pointer))

(defparameter *integrand* (constantly 0d0))

(cffi:defcallback integrand-function :double
    ((x :double) (params (:pointer :void)))
  (declare (ignore params)
	   (type (function (double-float) double-float) *integrand*))
  (funcall *integrand* x))

(defun create-integration-function (&key (eps-abs 1d-5)
					 (eps-rel 1d-5)
					 (workspace-size 5000))

  (let* ((F (cffi:foreign-alloc '(:struct gsl-function)))
	 (result (cffi:foreign-alloc :double))
	 (abserror (cffi:foreign-alloc :double))
	 (nevals  (cffi:foreign-alloc :unsigned-int))
	 (workspace (cquad-create-workspace workspace-size)))
    (cffi:with-foreign-slots ((cb) F (:struct gsl-function))
      (setf cb (cffi:callback integrand-function))
      (let* ((integration-fct
	       #'(lambda (integrand a b)
		   (let ((*integrand* integrand))
		     (declare (type double-float eps-abs eps-rel a b)
			      (type cffi:foreign-pointer F workspace result abserror nevals))
		     (gsl-check 
		      (gsl-integration-cquad F a b eps-abs eps-rel workspace
					   result abserror nevals)))
		   (cffi:mem-ref result :double)))
	     (finalizer #'(lambda ()
			    (free-all-ptrs F result abserror nevals)
			    (cquad-free-workspace workspace))))
	(trivial-garbage:finalize integration-fct finalizer)
	integration-fct))))
