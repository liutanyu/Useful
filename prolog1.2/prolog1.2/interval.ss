;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Interval:  interval arithmetic routines
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define arith-debug? #f)
(define (arith-debug arg)
	(if	arith-debug?
		(begin	(display arg)
			(newline))))

(define (load-interval-arith filename)
	(load (string-append interval-source-prefix filename)))

(load-interval-arith "precision.ss")
(load-interval-arith "prim.ss")
(load-interval-arith "add.ss")
(load-interval-arith "mult.ss")
(load-interval-arith "int.ss")
(load-interval-arith "geq.ss")
(load-interval-arith "gt.ss")
(load-interval-arith "neq.ss")
(load-interval-arith "split.ss")
(load-interval-arith "relax.ss")
(load-interval-arith "unify.ss")

(set! intervals? #t)
