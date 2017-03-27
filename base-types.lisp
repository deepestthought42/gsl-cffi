(in-package #:gsl-cffi)


(cffi:defctype size-t :unsigned-long)

(cffi:defctype gsl-vector :pointer)

(cffi:defcfun ("gsl_vector_get")
    :double
  (v gsl-vector)
  (i size-t))

(cffi:defcfun ("gsl_vector_set")
    :void
  (v gsl-vector)
  (i size-t)
  (x :double))


;;gsl_vector *gsl_vector_alloc (const size_t n);
(cffi:defcfun ("gsl_vector_alloc")
    gsl-vector
  (n size-t))

(cffi:defcfun ("gsl_vector_free")
    :void
  (v gsl-vector))




