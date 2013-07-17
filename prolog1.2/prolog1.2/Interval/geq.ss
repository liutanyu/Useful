
(define (geq i j)
					;;; i, j are intervals
	(let*	((i-lbt (lb-type@ i))
		(i-lb (lb@ i))
		(i-ub (ub@ i))
		(i-ubt (ub-type@ i))
		(j-lbt (lb-type@ j))
		(j-lb (lb@ j))
		(j-ub (ub@ j))
		(j-ubt (ub-type@ j))
		(i~ (intersect i (append (imax i-lbt i-lb j-lbt j-lb)
					(list i-ub i-ubt))))
					;;; bad access mechanism
					;;; use define-structure??
		(j~ (intersect j
			(append (list j-lbt j-lb)
				(reverse (imin j-ubt j-ub i-ubt i-ub))))))
		(list (geq-examine i~ j~))))

(define (geq-examine i j)
					;;; i, j are intervals
	(list	(cond	((or (empty? i) (empty? j))
				FAIL)
					;;; note departure from the paper!!##
			((>= (lb@ i) (ub@ j))
				COMPLETE-SUCCESS)
			(else	RETAIN))
		i j))

