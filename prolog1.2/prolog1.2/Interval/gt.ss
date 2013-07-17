
;;; i, j are arithmetic intervals
(define (gt i j)
	(let*	((i-lbt (lb-type@ i))
		(i-lb (lb@ i))
		(i-ub (ub@ i))
		(i-ubt (ub-type@ i))
		(j-lbt (lb-type@ j))
		(j-lb (lb@ j))
		(j-ub (ub@ j))
		(j-ubt (ub-type@ j))
		(i~ (append (shift-max i-lbt i-lb j-lbt j-lb)
				(list i-ub i-ubt)))
					;;; bad access mechanism
					;;; use define-structure??
		(j~ (append (list j-lbt j-lb)
			(reverse (shift-min i-ubt i-ub j-ubt j-ub)))))
		(list (geq-examine i~ j~))))

(define (gt-examine i j)
					;;; i, j are intervals
	(list	(cond	((or (empty? i) (empty? j))
				FAIL)
					;;; note departure from the paper!!##
			((> (lb@ i) (ub@ j))
				COMPLETE-SUCCESS)
			((and	(= (lb@ i) (ub@ j))
				(or (lb-open? (lb@ i)) (ub-open? (ub@ j))))
				COMPLETE-SUCCESS)
			(else	RETAIN))
		i j))

(define (shift-max i-lbt i-lb j-lbt j-lb)
	(let*	((m (imax i-lbt i-lb j-lbt j-lb))
		(mbt (car m))
		(mb (cadr m))
		(match? (and (equal? mbt j-lbt) (=_ mb j-lb))))
		(if	match?
			(list	(if	(lb-closed? j-lbt)
					LB-OPEN
					j-lbt)
				j-lb)
			m)))

(define (shift-min i-ubt i-ub j-ubt j-ub)
	(let*	((m (imin i-ubt i-ub j-ubt j-ub))
		(mbt (car m))
		(mb (cadr m))
		(match? (and (equal? mbt i-ubt) (=_ mb i-ub))))
		(if	match?
			(list	(if	(ub-closed? i-ubt)
					UB-OPEN
					i-ubt)
				i-ub)
			m)))

