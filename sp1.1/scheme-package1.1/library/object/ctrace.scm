;; This file is free software,which comes along with the scheme package. This
;; software  is  distributed  in the hope that it will be useful, but WITHOUT 
;; ANY  WARRANTY;  without  even  the  implied warranty of MERCHANTABILITY or
;; FITNESS  FOR A PARTICULAR PURPOSE. You can modify it as you want, provided
;; this header is kept unaltered, and a notification of the changes is added.
;; You  are  allowed  to  redistribute  it and sell it, alone or as a part of 
;; another product.
;;          Copyright (C) 1998-99 Stephane HILLION - hillion@essi.fr
;;              http://www.essi.fr/~hillion/scheme-package
;;
;;
;; Debugging of objects
;;
;; Stephane Hillion - 1998/12/22
;;
(require 'calist)
(provide 'ctrace)

(<class> define (trace name)
	 ;; Produces a trace of execution of the method
	 (let* ((meth (apply (<class> get get) this name '()))
		(nm (method L
			    (let ((res '?))
			      (<class> display-enter name L)
			      (set! res (apply meth this L))
			      (<class> display-leave name L)
			      res)))
		(tl (<class> get *trace-list*))
		(cl (tl assoc this)))
	   (if cl
	       (let ((n.m ((cdr cl) assoc name)))
		 (if (not n.m)
		     (begin
		       (cl add (cons name meth))
		       (apply (<class> get define) this name nm '()))
		     (print name " already traced")))
	       (begin
		 (let ((ncl (<alist> make)))
		   (ncl init)
		   (ncl add (cons name meth))
		   (tl add (cons this ncl))
		   (apply (<class> get define) this name nm '()))))))
		 
(<class> define (untrace name)
	 ;; Stop to trace the method
	 (let* ((tl (<class> get *trace-list*))
		(cl (tl assoc this)))
	   (if (not cl)
	       (print name " not traced")
	       (let ((n.m ((cdr cl) assoc name)))
		 (if n.m
		     (begin
		       ((cdr cl) remove (car n.m))
		       (if ((cdr cl) empty?)
			   (tl remove this))
		       (apply (<class> get define) this name (cdr n.m) '()))
		     (print name " not traced"))))))

;; private methods --------------------------------------------
		     
(<class> define (display-enter name L)
	 (let ((td (<class> get *trace-depth*)))
	   (print (make-string (* 2 td) #\ ) " >> " (cons name L))
	   (<class> define *trace-depth* (+ 1 td))))

(<class> define (display-leave name L)
	 (let ((td (<class> get *trace-depth*)))
	   (print (make-string (* 2 (- td 1)) #\ ) " << " (cons name L))
	   (<class> define *trace-depth* (- td 1))))

(<class> define *trace-depth* 0)
(<class> define *trace-list* (<alist> create))
