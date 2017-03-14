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
   #:create-integration-function))


