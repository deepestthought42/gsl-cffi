;;;; package.lisp

(defpackage #:gsl-cffi
  (:use #:cl #:iterate #:let-plus)
  (:export
   #:version
   #:unsupported-gsl-version
   #:gsl-error)
  (:nicknames #:gsl))


