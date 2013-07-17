;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Tables:  implemented with association lists and dlists.
;;;          They associate predicate names with lists of clauses.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define make-assoc cons)
(define assoc-key car)
(define assoc-key! set-car!)
(define assoc-value cdr)
(define assoc-value! set-cdr!)

;;; let user set up intial assoc
(define (make-table assoc) (cons assoc '()))

;;; push another association on
(define (table-insert! assoc tab)
  (set-cdr! tab (cons (car tab) (cdr tab)))
  (set-car! tab assoc))

(define table-lookup assq)
