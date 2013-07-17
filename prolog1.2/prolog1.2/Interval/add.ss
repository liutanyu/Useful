
;;; procedures
(define (add i j k)
					;;; i, j, k are intervals
	(let*	((i+j (sum-int i j))
		(knew (intersect k i+j))
		(jnew (intersect j (minus k i)))
		(inew (intersect i (minus k j))))
		(list (add-examine inew jnew knew))))

(define (sum-int i j)
					;;; i, j are intervals
	(append (addb (lb-type@ i) (lb@ i) (lb-type@ j) (lb@ j) '-)
		(reverse (addb (ub-type@ i) (ub@ i) (ub-type@ j) (ub@ j) '+))))

(define (addb bt-i b-i bt-j b-j round)
					;;; bt-i, bt-j are the bound types
					;;; and b-i, b-j are the bound values
					;;; round is direction of rounding
	(let ((bt (plust@ bt-i bt-j)))
		(cond	((or (is-inf? b-i) (is-inf? b-j));;; neg infinity + any
;;; (-w + any<0   =>  (-w
;;; (-w + any>=0  =>  (-w
;;; -w + w        =>  (round) +/-w
;;; etc.
				(list bt INF-))	;;; arguably wrong for -w + w
			((or (isinf? b-i) (isinf? b-j))	;;; pos infinity + any
				(list bt INF))
			((=_ b-i ZERO)			;;; 0 + any
				(list bt b-j))
			((=_ b-j ZERO)			;;; any + 0
				(list bt b-i))
			(else				;;; finite + finite
				(list	(open-bound bt)
					(fuzz+_ b-i b-j round))))))

(define (plust@ ti tj)
	(lkup3@ ti tj PLUST))

(define (fuzz+_ i j round)
	(+_ (fuzzy i round) (fuzzy j round)))

(define (fuzzy i round)
	(*_ i (if (eq? round '+)
		  (if (<_ i ZERO) FUZZ- FUZZ+)
		  (if (<_ i ZERO) FUZZ+ FUZZ-))))

(define (open-bound bt)
	(lkup2@ bt OPEN-BRACKET))

(define OPEN-BRACKET	'( (< <) ({ <) (} >) (> >) ))

;;(define (sum-int i j)
;;					;;; i, j are intervals
;;	(append (addb (lb-type@ i) (lb@ i) (lb-type@ j) (lb@ j))
;;		(reverse (addb (ub-type@ i) (ub@ i) (ub-type@ j) (ub@ j)))))
;;
;;(define (addb bt-i b-i bt-j b-j)
;;					;;; bt-i, bt-j are the bound types
;;					;;; and b-i, b-j are the bound values
;;	(list (plust@ bt-i bt-j) (plus@ b-i b-j)))
;;
;;(define (plust@ ti tj)
;;	(lkup3@ ti tj PLUST))
;;
;;(define (plus@ i j)
;;	(cond	((or (is-inf? i) (is-inf? j))
;;			INF-)
;;		((or (isinf? i) (isinf? j))
;;			INF)
;;		(else	(+_ i j))))

(define (minus i j)
					;;; i, j are intervals
	(sum-int i (uminus j)))

(define (add-examine i j k)
					;;; i, j, k are intervals
	(list	(cond	((or (empty? i) (empty? j) (empty? k))
				FAIL)
			((and (point? i) (point? j) (point? k))
				COMPLETE-SUCCESS)
			(else	RETAIN))
		i j k))

;;; constants
(define PLUST '((> > >)	(> } >)
		({ { {) ({ < <)
		(} > >) (} } })
		(< { <) (< < <)))

