;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Predicates:  implemented as vectors of the form #(when what how).
;;;              See compile.ss for details of these components.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-pred)
  (vector (make-dlist) (make-dlist) (make-dlist)))

(define (pred-when pred)
  (vector-ref pred 0))

(define (pred-when! pred wh)
  (vector-set! pred 0 wh))

(define (pred-what pred)
  (vector-ref pred 1))

(define (pred-what! pred what)
  (vector-set! pred 1 what))

(define (pred-how pred)
  (vector-ref pred 2))

(define (pred-how! pred how)
  (vector-set! pred 2 how))

(define (pred-how? pred)
	(not (null? (pred-how pred))))
