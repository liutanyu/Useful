
;;; functions
(define (split-abs prec i)
					;;; i is an interval
					;;; prec is a real number
	(do-split (cons 'abs prec) i))

(define (split-rel prec i)
					;;; i is an interval
					;;; prec is a real number
	(do-split (cons 'rel prec) i))

(define (split-machine i)
					;;; i is an interval
	(do-split (cons 'machine '()) i))

(define split split-machine)

(define (splitting-precision how)
	(let*	((int (cdr how))
		 (prec (ub@ int)))
		(cond	((empty? int)
				(error 'split "empty precision interval"))
			((not (number? prec))
				(error 'split "bad precision ~s" prec))
			((< prec FUZZ)
				(error 'split "bad precision ~s" prec))
			(else prec))))

(define (do-split how i)
					;;; i is an interval
    	(let*	((i-lbt (lb-type@ i))
		 (i-lb (lb@ i))
		 (i-ub (ub@ i))
		 (i-ubt (ub-type@ i))
		 (compare
			(case (car how)
				((abs) (lambda (x y)
					  (~_a x y (splitting-precision how))))
				((rel) (lambda (x y)
					  (~_r x y (splitting-precision how))))
				((machine) (lambda (x y) (~_m x y)))))
		 (examine (lambda (int) (split-examine int compare))))
(arith-debug "do-split interval:")
(arith-debug i)
		(cond	((empty? i)
				(list (examine EMPTY)))
			((point? i)
				(list (examine i)))
			((adj? i-lb i-ub compare)
					;;; note (not (empty? i))
				(cond	((and	(lb-open? i-lbt)
						(ub-open? i-ubt))
						(list (examine i)))
					((and	(lb-open? i-lbt)
						(ub-closed? i-ubt))
						(let	((i1 (list LB-OPEN i-lb
								i-ub UB-OPEN))
							(i2 (list LB-CLOSED i-ub
								i-ub UB-CLOSED)))
							(list	(examine i1)
								(examine i2))))
					;;; i-lbt == LB-CLOSED for sure
					((ub-open? i-ubt)
						(let	((i1 (list LB-CLOSED i-lb
								i-lb UB-CLOSED))
							(i2 (list LB-OPEN i-lb
								i-ub UB-OPEN)))
							(list	(examine i1)
								(examine i2))))
					;;; i-ubt == UB-CLOSED for sure too
					(else	(let	((i1 (list LB-CLOSED i-lb
								i-lb UB-CLOSED))
							(i2 (list LB-OPEN i-lb
								i-ub UB-OPEN))
							(i3 (list LB-CLOSED i-ub
								i-ub UB-CLOSED)))
							(list	(examine i1)
								(examine i2)
								(examine i3))))))
    			(else	(let*	((mid (avg i-lb i-ub))
    					(i1 (list i-lbt i-lb mid
    							UB-OPEN))
    					(i2 (list LB-CLOSED mid i-ub
    							i-ubt)))
(arith-debug "split thus:")
(arith-debug i1)
(arith-debug i2)
    					(list	(examine i1)
    						(examine i2)))))))

(define (split-examine i compare)
					;;; i is an interval
	(list	(cond	((point? i)
				COMPLETE-SUCCESS)
    			((empty? i)
				FAIL)
			(else	(let	((i-lbt (lb-type@ i))
					(i-lb (lb@ i))
					(i-ub (ub@ i))
					(i-ubt (ub-type@ i)))
					(cond	((and	(lb-open? i-lbt)
							(ub-open? i-ubt)
							(adj? i-lb i-ub compare))
							COMPLETE-SUCCESS)
						(else	RETAIN)))))
		i))

(define (adj? x y compare)		;;; INEXACT
					;;; x, y are internal reals
					;;; assumes that x <= y
    	(if	(or (isinf? x) (isinf? y) (is-inf? x) (is-inf? y))
    		#f
    		(compare x y)))

