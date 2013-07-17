;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Schedule:  maintain dlist of scheduled (woken) goals
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (schedule! goal)
	(if	debug?
		(begin	(display "in schedule!() with goal")
			(display (goal-id goal))
			(display ":")
			(display (term-instantiate (goal-term goal)))
			(display "queue:")
			(display (map (lambda (g) (goal-id g))
					(dlist->list SCHEDULED-GOALS)))
			(newline)))
	(if (memq goal (dlist->list SCHEDULED-GOALS))
		(if	debug?
			(begin
				(display "WARNING:  duplicate goal in schedule!()")
				(newline)))
		(dlist-insert-back! goal SCHEDULED-GOALS))
)

(define (reschedule! goal)
	(if	debug?
		(begin	(display "in reschedule!() with goal")
			(display (goal-id goal))
			(display ":")
			(display (term-instantiate (goal-term goal)))
			(display "queue:")
			(display (map (lambda (g) (goal-id g))
					(dlist->list SCHEDULED-GOALS)))
			(newline)))
	(dlist-insert-front! goal SCHEDULED-GOALS)
)

(define (unschedule! goal)
	(if	debug?
		(begin	(display "in unschedule!() with goal")
			(display (goal-id goal))
			(display ":")
			(display (term-instantiate (goal-term goal)))
			(display "queue:")
			(display (map (lambda (g) (goal-id g))
					(dlist->list SCHEDULED-GOALS)))
			(newline)))
	(dlist-delete! goal SCHEDULED-GOALS)
)

(define (unschedule-all!)
	(if	debug?
		(begin	(display "in unschedule-all!()")
			(newline)))
	(set! SCHEDULED-GOALS (make-dlist)))

(define SCHEDULED-GOALS (make-dlist))

(define (scheduler program s f)
	(if	debug?
		(begin	(display "in scheduler() with queue ")
			(display (map (lambda (g) (goal-id g))
					(dlist->list SCHEDULED-GOALS)))
			(newline)))
	(if (dlist-empty? SCHEDULED-GOALS)
		(s f)
		(let	((goal (dlist-delete-front! SCHEDULED-GOALS)))
			(and-branch goal program 
				(lambda (fail) (scheduler program s fail))
				(lambda ()
					(reschedule! goal)
					(f)))))
)
