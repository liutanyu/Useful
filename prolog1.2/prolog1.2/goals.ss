;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Goals:  implemented as vectors of the form #(id term pred) where
;;;         id is a retry count for the goal,
;;;         term is the term (see terms.ss),
;;;         pred is the predicate (see pred.ss) in the form #(when what how).
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define make-goal
  (let ((n 0))
    (lambda (term program)
      (set! n (1+ n))
      (vector   ; should check to see if table-lookup returns #f
       n
       term
       (assoc-value (table-lookup (term->functor/arity term) program))))))

(define (goal-id goal)
  (vector-ref goal 0))

(define (goal-term goal)
  (vector-ref goal 1))

(define (goal-pred goal)
  (vector-ref goal 2))

;;; Try to run goal for the first time.
(define (goal-first-try! goal s-run s-delay f)
	(if	debug?
		(begin	(display "goal-first-try! ")
			(display (term-instantiate (goal-term goal)))))
	(if	((pred-when (goal-pred goal)) goal)
		(begin	(if debug? (begin (display " ...running") (newline)))
			(s-run f))
		(let	((var-set (term-var-set (goal-term goal))))
			(if debug?
				(begin	(display " ...delaying")
					(newline)))
			(for-each
						;;; delay on all variables
				(lambda (var)
					(var-add-constraint! goal var
						'FRONT))
				var-set)
			(flounder! goal)
			(s-delay
				(lambda ()
					(unflounder! goal)
					(for-each
						;;; undelay on all variables
						(lambda (var)
							(var-del-constraint!
								goal var))
						var-set)
					(f))))))

;;; Try to wake up goal given that ivar was just instantiated.
(define (goal-wake-try! goal ivar s-run s-delay f)
	(if	debug?
		(begin	(display "goal-wake-try! ")
			(display (term-instantiate (goal-term goal)))))
	(if	((pred-when (goal-pred goal)) goal)
		(let	((var-set (term-var-set (goal-term goal))))
			(if debug? (begin (display " ...waking") (newline)))
			(for-each
						;;; undelay on all variables
				(lambda (var)
					(var-del-constraint! goal var))
				var-set)
			(unflounder! goal)
			(s-run (lambda ()
				(if debug?
				    (begin
					(display "failing out of awakened...")
					(newline)))
				(flounder! goal)
				(for-each
						;;; redelay on all variables
					(lambda (var)
						(var-add-constraint! goal var
							'FRONT))
					var-set)
				(if debug?
				    (begin
					(display "failed out of awakened.")
					(newline)))
				(f))))
		(let	((var-set (term-var-set ivar)))
			(if debug? (begin (display " ...still delaying")
				(newline)))
						;;; but constraints are not
						;;; erased from ivar!!??##@@$$
			(for-each
						;;; delay on all variables
				(lambda (var)
					(var-add-constraint! goal var 'FRONT))
				var-set)
			(s-delay
				(lambda ()
						;;; undelay on all variables
					(for-each
						(lambda (var)
							(var-del-constraint!
								goal var))
						var-set)
					(f))))))

;;; Execute newly-woken goal immediately.
(define (awaken-goal-immediately! goal program s f)
	(and-branch goal program s f))

;;; Prepare to execute newly-woken goal some time soon.
(define (awaken-goal-soon! goal program s f)
	(schedule! goal)
	(s (lambda ()
		(unschedule! goal)
		(f))))

(define awaken-goal! awaken-goal-soon!)
