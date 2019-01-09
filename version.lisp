(in-package #:gsl-cffi)



(eval-when (:compile-toplevel :load-toplevel)
  (define-condition unsupported-gsl-version (serious-condition)
    ((message :accessor message :initarg :message
	      :initform "current gsl version is not supported by gsl-cffi.")))

  (defparameter *supported-versions* '(("1.16" gsl-v1-16) ("2.1" gsl-v2-1) ("2.4" gsl-v2-4)))
  (cffi:defcvar "gsl_version" :string)
  (defun version () *gsl-version*))



(let ((gsl-version (find (version) *supported-versions*
			 :key #'first :test #'string=)))
  (if (not gsl-version)
      (error 'unsupported-gsl-version
	     :message
	     (format nil "gsl version: ~a is not supported by gsl-cffi."
		     (version)))
      (pushnew (alexandria:make-keyword (second gsl-version))
	       *features*)))









