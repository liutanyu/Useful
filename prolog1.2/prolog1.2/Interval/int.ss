
(define (int i)
				;;; i is an interval
	(let*	((i-lbt (lb-type@ i))
		(i-lb (lb@ i))
		(i-ub (ub@ i))
		(i-ubt (ub-type@ i))
		(result	(append (int-ceiling i-lbt i-lb)
				(int-floor i-ubt i-ub))))
		(list (int-examine result))))

(define (int-examine i)
				;;; i is an interval
	(list	(let	((i-lb (lb@ i)))
			(cond	((empty? i)
					FAIL)
				((and (point? i) (is-integer? i-lb))
					COMPLETE-SUCCESS)
				(else	RETAIN)))
		i))
				;;; can make this stricter by checking whether
				;;; an integer can occur in the interval!?

(define (is-integer? x)
				;;; x is an internal real
	(or	(isinf? x)
		(is-inf? x)
		(= x (real (ceiling x)))))

(define (int-ceiling bt b)
	(cond	((or (isinf? b) (is-inf? b))
			(list LB-CLOSED b))
		(else	(let	((result (real (ceiling b))))
				(list	LB-CLOSED
					(cond	((and	(= result b)
							(<t? LB-CLOSED bt))
							(+_ result ONE))
						(else	result)))))))

(define (int-floor bt b)
					;;; 2.3 > -> 2.0 }
					;;; 2.0 > -> 1.0 }
					;;; 2.0 } -> 2.0 }
	(cond	((or (isinf? b) (is-inf? b))
			(list b UB-CLOSED))
		(else	(let	((result (real (floor b))))
				(list	(cond	((and	(= result b)
							(<t? bt UB-CLOSED))
							(-_ result ONE))
						(else	result))
					UB-CLOSED)))))

