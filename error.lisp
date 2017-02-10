(in-package #:gsl-cffi)


(define-condition gsl-error (serious-condition)
  ((reason :accessor reason :initarg :reason :initform "")
   (file :accessor file :initarg :file :initform "")
   (line :accessor line :initarg :line :initform 0)
   (error-number :accessor error-number :initarg :error-number :initform 0)))


(cffi:defcallback gsl-error-handler
    :void
    ((reason :string)
     (file :string)
     (line :int)
     (gsl-errno :int))
  (error 'gsl-error
	 :reason reason
	 :file file
	 :line line
	 :error-number gsl-errno))


(cffi:defcfun ("gsl_set_error_handler")
    :pointer
  (handler :pointer))



(defun set-error-handler (&optional (error-callback (cffi:callback gsl-error-handler)))
  (gsl-set-error-handler error-callback))
