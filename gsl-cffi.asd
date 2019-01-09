;;;; gsl-cffi.asd

(asdf:defsystem #:gsl-cffi
  :description "Random assortment of GSL functions I need in my own projects."
  :author "Renee Klawitter <klawitterrenee@gmail.com>"
  :license "Apache 2.0"
  :version "0.0.1"
  :depends-on (#:alexandria
               #:iterate
               #:let-plus
	       #:cffi
	       #:trivial-garbage)
  :serial t
  :components ((:file "package")
	       (:file "library")
	       (:file "version")
	       (:file "utils")
	       (:file "base-types")
	       (:file "error")
	       (:file "constants")
	       (:file "multifit")
               (:file "gsl-cffi")
	       (:file "numerical-integration")
	       (:file "random-numbers")))

