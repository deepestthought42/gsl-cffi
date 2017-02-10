(in-package #:gsl-cffi)



(defmacro make-constants (checker-name
			  (success-name success-no)
			  &rest constants)
  (let ((b (iter (for (c no doc) in constants) (collect `(cons ,no ,doc)))))
    (alexandria:with-gensyms (bag no doc-string)
      `(let ((,bag (list ,@b)))
	 (defconstant ,success-name ,success-no)
	 (defun ,checker-name (,no)
	   (if (not (eql ,no ,success-no))
	       (let ((,doc-string (assoc ,no ,bag)))
		 (if ,doc-string
		     (error "Error: ~a" (cdr ,doc-string))
		     (error "Unknown error: ~a" ,no)))))
	 (defun docstring (,no)
	   (if (eql ,no ,success-no)
	       ',success-name
	       (let ((,doc-string (assoc ,no ,bag)))
		 (if ,doc-string
		     (cdr ,doc-string)
		     (error "Unknown error: ~a" ,no)))))
	 ,@(iter
	     (for (c no doc) in constants)
	     (collect `(defconstant ,c ,no ,doc)))))))



(eval-when (:compile-toplevel :load-toplevel)
  (make-constants check-gsl-status
      (+GSL_SUCCESS+ 0)
      (+GSL_FAILURE+ -1 "Unknown error")
      (+GSL_CONTINUE+ -2 "iteration has not converged")
      (+GSL_EDOM+ 1 "input domain error e.g sqrt(-1)")
      (+GSL_ERANGE+ 2 "output range error e.g. exp(1e100)")
      (+GSL_EFAULT+ 3 "invalid pointer")
      (+GSL_EINVAL+ 4 "invalid argument supplied by user")
      (+GSL_EFAILED+ 5 "generic failure")
      (+GSL_EFACTOR+ 6 "factorization failed")
      (+GSL_ESANITY+ 7 "sanity check failed - shouldn't happen")
      (+GSL_ENOMEM+ 8 "malloc failed")
      (+GSL_EBADFUNC+ 9 "problem with user-supplied function")
      (+GSL_ERUNAWAY+ 10 "iterative process is out of control")
      (+GSL_EMAXITER+ 11 "exceeded max number of iterations")
      (+GSL_EZERODIV+ 12 "tried to divide by zero")
      (+GSL_EBADTOL+ 13 "user specified an invalid tolerance")
      (+GSL_ETOL+ 14 "failed to reach the specified tolerance")
      (+GSL_EUNDRFLW+ 15 "underflow")
      (+GSL_EOVRFLW+ 16 "overflow ")
      (+GSL_ELOSS+ 17 "loss of accuracy")
      (+GSL_EROUND+ 18 "failed because of roundoff error")
      (+GSL_EBADLEN+ 19 "matrix vector lengths are not conformant")
      (+GSL_ENOTSQR+ 20 "matrix not square")
      (+GSL_ESING+ 21 "apparent singularity detected")
      (+GSL_EDIVERGE+ 22 "integral or series is divergent")
      (+GSL_EUNSUP+ 23 "requested feature is not supported by the hardware")
      (+GSL_EUNIMPL+ 24 "requested feature not (yet) implemented")
      (+GSL_ECACHE+ 25 "cache limit exceeded")
      (+GSL_ETABLE+ 26 "table limit exceeded")
      (+GSL_ENOPROG+ 27 "iteration is not making progress towards solution")
      (+GSL_ENOPROGJ+ 28 "jacobian evaluations are not improving the solution")
      (+GSL_ETOLF+ 29 "cannot reach the specified tolerance in F")
      (+GSL_ETOLX+ 30 "cannot reach the specified tolerance in X")
      (+GSL_ETOLG+ 31 "cannot reach the specified tolerance in gradient")
      (+GSL_EOF+ 32 "end of file")))

(defmacro gsl-check (no)
  `(if (not (eql +GSL_SUCCESS+ ,no))
       (check-gsl-status ,no)))
