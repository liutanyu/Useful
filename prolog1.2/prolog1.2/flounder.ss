;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Flounder:  maintain dlist of delayed goals
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (flounder! goal)
	(if	debug?
		(begin	(display "in flounder!() with goal:")
			(display (term-instantiate (goal-term goal)))
			(newline)))
	(dlist-delete! goal FLOUNDERED-GOALS)
	(dlist-insert-anywhere! goal FLOUNDERED-GOALS))

(define (unflounder! goal)
	(if	debug?
		(begin	(display "in unflounder!() with goal:")
			(display (term-instantiate (goal-term goal)))
			(newline)))
	(dlist-delete! goal FLOUNDERED-GOALS))

(define (unflounder-all!)
	(set! FLOUNDERED-GOALS (make-dlist)))

(define FLOUNDERED-GOALS (make-dlist))

