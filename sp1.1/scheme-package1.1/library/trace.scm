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
;; Debugging
;;
;; Stephane Hillion - 1998/12/12
;;
(require 'util)
(provide 'trace)

(define trace '?)
  ;; (trace symb)
  ;; Traces the 'symb' function

(define untrace '?)
  ;; (untrace symb)
  ;; Untrace the 'symb' function


(let* ((*trace-depth* 0)
       (*trace-list* '())
       (display-enter-trace
	(lambda (name L)
	  (display (make-string *trace-depth* #\ ))
	  (print " >> " (cons name L))
	  (set! *trace-depth* (+ 1 *trace-depth*))))
       (display-leave-trace
	(lambda (name L)
	  (set! *trace-depth* (- *trace-depth* 1))
	  (display (make-string *trace-depth* #\ ))
	  (print " << " (cons name L)))))

  (set! trace
	(lambda (proc-name)
	  (let* ((proc (eval proc-name))
		 (np (lambda L
		       (let ((res '?))
			 (display-enter-trace proc-name L)
			 (set! res (apply proc L))
			 (display-leave-trace proc-name L)
			 res))))
	    (if (not (assoc proc-name *trace-list*))
		(begin
		  (set! *trace-list* (cons (cons proc-name proc) *trace-list*))
		  (eval `(apply define ',proc-name ,np '())))
		(print proc-name " already traced")))))

  (set! untrace
	(lambda (proc-name)
	  (let ((n.p (assoc proc-name *trace-list*)))
	    (if n.p
		(begin
		  (eval `(apply define ',proc-name ,(cdr n.p) '()))
		  (set! *trace-list* (remove n.p *trace-list*)))
		(print proc-name " not traced"))))))

