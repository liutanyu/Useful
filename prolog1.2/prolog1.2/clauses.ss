;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Clauses:  implemented as lists of the form (head . body)
;;;           where body is a list of terms.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define clause-head car)
(define clause-body cdr)
(define (clause-fact? clause) (null? (clause-body clause)))
