;;;; gsl-cffi.asd

(asdf:defsystem #:gsl-cffi
  :description "Describe gsl-cffi here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:alexandria
               #:iterate
               #:let-plus
	       #:cffi
	       #:trivial-garbage)
  :serial t
  :components ((:file "package")
	       (:file "library")
	       (:file "version")
	       (:file "error")
	       (:file "constants")
               (:file "gsl-cffi")))

