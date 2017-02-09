(in-package #:gsl-cffi)

;;;; this has been stolen from gsll

#+darwin
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun gsl-config (arg)
    "A wrapper for tool `gsl-config'."
    (with-input-from-string
        (s (with-output-to-string (asdf::*verbose-out*)
             (asdf:run-shell-command "gsl-config ~s" arg)))
      (read-line s)
      (read-line s)))
  (defparameter *gsl-libpath*
    (let ((gsl-config-libs (gsl-config "--libs")))
      (when (eql 2 (mismatch gsl-config-libs "-L" :test #'string=))
	(uiop:ensure-directory-pathname
	 (uiop:ensure-absolute-pathname
	  (pathname
	   (subseq gsl-config-libs 2 (position #\space gsl-config-libs)))))))
    "The path to the GSL libraries; gsl-config must return -L result first.")
  (defun gsl-config-pathname (pn)
    (namestring (uiop:merge-pathnames* pn *gsl-libpath*))))

#-darwin 				; unneeded other than macosx
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun gsl-config-pathname (pn) pn))

(cffi:define-foreign-library libgslcblas
  (:darwin #+ccl #.(ccl:native-translated-namestring
		    (gsl-config-pathname "libgslcblas.dylib"))
           #-ccl #.(gsl-config-pathname "libgslcblas.dylib"))
  (:windows (:or "libgslcblas-0.dll" "cyggslcblas-0.dll"))
  (:unix (:or "libgslcblas.so.0" "libgslcblas.so"))
  (t (:default "libgslcblas")))
   
(cffi:use-foreign-library libgslcblas)

;; When calling libgsl from emacs built for windows and slime, and
;; using clisp built for cygwin, we have to load lapack/cygblas.dll
;; before loading cyggsl-0.dll
#+(and clisp cygwin)
(cffi:load-foreign-library "/lib/lapack/cygblas.dll")

(cffi:define-foreign-library libgsl
  (:darwin #+ccl #.(ccl:native-translated-namestring
                     (gsl-config-pathname "libgsl.dylib"))
           #-ccl #.(gsl-config-pathname "libgsl.dylib"))
  (:windows (:or "libgsl-0.dll" "cyggsl-0.dll"))
  (:unix (:or "libgsl.so.0" "libgsl.so"))
  (t (:default "libgsl")))
   
(cffi:use-foreign-library libgsl)
