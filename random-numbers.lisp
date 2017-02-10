(in-package #:gsl-cffi)




;; Function: gsl_rng * gsl_rng_alloc (const gsl_rng_type * T)

;;     This function returns a pointer to a newly-created instance of
;;     a random number generator of type T. For example, the following
;;     code creates an instance of the Tausworthe generator,

;;     gsl_rng * r = gsl_rng_alloc (gsl_rng_taus);

;;     If there is insufficient memory to create the generator then
;;     the function returns a null pointer and the error handler is
;;     invoked with an error code of GSL_ENOMEM.

;;     The generator is automatically initialized with the default
;;     seed, gsl_rng_default_seed. This is zero by default but can be
;;     changed either directly or by using the environment variable
;;     GSL_RNG_SEED (see Random number environment variables).

;;     The details of the available generator types are described
;;     later in this chapter.

(cffi:defcfun "gsl_rng_alloc"
    :pointer
  (type :pointer))


;; Function: void gsl_rng_free (gsl_rng * r)

;;    This function frees all the memory associated with the generator r. 
(cffi:defcfun "gsl_rng_free"
    :void
  (rng :pointer))


(cffi:defcfun "gsl_rng_set"
    :void
  (rng :pointer)
  (s :unsigned-long))


(eval-when (:load-toplevel :compile-toplevel)
  (defmacro define-rng-types (&rest types)
    (let+ ((c-names (mapcar #'(lambda (n)
				(concatenate 'string "gsl_rng_" n))
			    types))
	   (lisp-names (mapcar #'(lambda (n)
				   (alexandria:symbolicate '*
							   (read-from-string n)
							   '*))
			       types)))
      `(progn
	 ,@(iter
	     (for c in c-names)
	     (for l in lisp-names)
	     (collect `(cffi:defcvar (,c ,l) :pointer)))))))


(define-rng-types
    "borosh13"
  "coveyou"
  "cmrg"
  "fishman18"
  "fishman20"
  "fishman2x"
  "gfsr4"
  "knuthran"
  "knuthran2"
  "knuthran2002"
  "lecuyer21"
  "minstd"
  "mrg"
  "mt19937"
  "mt19937_1999"
  "mt19937_1998"
  "r250"
  "ran0"
  "ran1"
  "ran2"
  "ran3"
  "rand"
  "rand48"
  "random128_bsd"
  "random128_glibc2"
  "random128_libc5"
  "random256_bsd"
  "random256_glibc2"
  "random256_libc5"
  "random32_bsd"
  "random32_glibc2"
  "random32_libc5"
  "random64_bsd"
  "random64_glibc2"
  "random64_libc5"
  "random8_bsd"
  "random8_glibc2"
  "random8_libc5"
  "random_bsd"
  "random_glibc2"
  "random_libc5"
  "randu"
  "ranf"
  "ranlux"
  "ranlux389"
  "ranlxd1"
  "ranlxd2"
  "ranlxs0"
  "ranlxs1"
  "ranlxs2"
  "ranmar"
  "slatec"
  "taus"
  "taus2"
  "taus113"
  "transputer"
  "tt800"
  "uni"
  "uni32"
  "vax"
  "waterman14"
  "zuf")

(cffi:defcfun "gsl_ran_gaussian"
    :double
  (rng :pointer)
  (sigma :double))

(cffi:defcfun "gsl_rng_uniform"
    :double
  (rng :pointer))

 

(defstruct rng pointer seed)

(defun get-random-number-generator (type &optional seed)
  "Return an object of type RNG that acts as a thin layer for
automatic garbage collection. Use with random- functions."
  (let ((rng (make-rng :pointer
		     (gsl-rng-alloc type))))
    (trivial-garbage:finalize rng #'(lambda ()
				    (gsl-rng-free (rng-pointer rng))))
    (if seed
	(progn
	  (setf (rng-seed rng) seed)
	  (gsl-rng-set (rng-pointer rng) seed)))
    rng))


(defun random-gaussian (rng sigma)
  (gsl-ran-gaussian (rng-pointer rng) sigma))


(defun random-uniform (rng)
  "Given a rng object in RNG, this function returns a double precision
floating point number uniformly distributed in the range [0,1). The
range includes 0.0 but excludes 1.0. The value is typically obtained
by dividing the result of gsl_rng_get(r) by gsl_rng_max(r) + 1.0 in
double precision. Some generators compute this ratio internally so
that they can provide floating point numbers with more than 32 bits of
randomness (the maximum number of bits that can be portably
represented in a single unsigned long int). "
  (gsl-rng-uniform (rng-pointer rng)))



(defun get-array-random-uniform (len &key (rng (get-random-number-generator *mt19937_1999*)))
  "Returns an array of length LEN filled with uniform random variables
[0,1) generated with RNG."
  (if (not (<= 0 len (1- #.(expt 2 32))))
      (error "You really want an array that is bigger than 16GB (or
      smaller than 0)?"))
  (iter
    (with ret-val = (make-array len :element-type 'double-float))
    (for i from 1 to len)
    (declare (optimize (speed 3))
	     (type (simple-array double-float))
	     (type (integer 0 #.(expt 2 32)) i len))
    (setf (aref ret-val (1- i)) (gsl-rng-uniform (rng-pointer rng)))
    (finally (return ret-val))))



