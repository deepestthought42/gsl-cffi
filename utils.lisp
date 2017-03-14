(in-package #:gsl-cffi)



(defmacro free-all-ptrs (&rest ptrs)
  `(progn
     ,@(iter (for p in ptrs) (collect `(cffi:foreign-free ,p)))))
