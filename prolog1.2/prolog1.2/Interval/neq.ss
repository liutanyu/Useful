
(define (neq i j)
					;;; i, j are intervals
	(cond	((and (point? i) (not (point? j)))
			(let*	((i-lb (lb@ i))
				(j-split (neq-split j i-lb))
				(j-left (car j-split))
				(j-right (cadr j-split)))
				(list	(neq-examine i j-left)
					(neq-examine i j-right))))
		((and (point? j) (not (point? i)))
			(let*	((j-lb (lb@ j))
				(i-split (neq-split i j-lb))
				(i-left (car i-split))
				(i-right (cadr i-split)))
				(list	(neq-examine i-left j)
					(neq-examine i-right j))))
		(else	(list (neq-examine i j)))))
					;;; neither is a point interval?

(define (neq-examine i j)
					;;; i, j are intervals
					;;; (probably squeezed)
	(list	(cond	((or (empty? i) (empty? j))
				FAIL)
			((not (or (point? i) (point? j)))
					;;; neither is a point?
				RETAIN)
			(else	(cond	((eq-int? i j)	FAIL)
					(else		COMPLETE-SUCCESS))))
		i j))

(define (neq-split i wrt)
					;;; i is an interval
					;;; wrt is an internal real
	(let	((i-lbt (lb-type@ i))
		(i-lb (lb@ i))
		(i-ub (ub@ i))
		(i-ubt (ub-type@ i)))
		(list	(list i-lbt i-lb wrt UB-OPEN)
			(list LB-OPEN wrt i-ub i-ubt))))
					;;; bad access mechanism??

