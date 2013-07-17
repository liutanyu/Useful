
;;; predicates
(define (is-inf? x) (equal? x INF- ))	;;; x is an internal real

(define (isinf? x) (equal? x INF))	;;; x is an internal real

(define (lb-open? type-lb) (equal? type-lb LB-OPEN))
					;;; type-lb is a lower bound bracket

(define (lb-closed? type-lb) (equal? type-lb LB-CLOSED))
					;;; type-lb is a lower bound bracket

(define (ub-open? type-ub) (equal? type-ub UB-OPEN))
					;;; type-ub is a lower bound bracket

(define (ub-closed? type-ub) (equal? type-ub UB-CLOSED))
					;;; type-ub is a lower bound bracket

(define (lb-type? x) (or (lb-open? x) (lb-closed? x)))
					;;; x could be anything!?

(define (ub-type? x) (or (ub-open? x) (ub-closed? x)))
					;;; x could be anything!?

(define (arith-interval? x)		;;; x could be anything!?
	(and	(proper-list? x)	;;; note (pair? '(a . b)) -> #t
		(= 4 (length x))
		(lb-type? (index@ x 1))
		(ub-type? (index@ x 4))))
					;;; sufficeth for now!##
					;;; needs to be stricter later

(define (~<b? ibt ib jbt jb)
					;;; INEXACT <
					;;; i, j are bounds on intervals
					;;; favours returning #f since it is
					;;; used to determine squeezability
					;;; note, =_ has to be EXACT
	(or	(~<_ ib jb)
		(and (=_ ib jb) (<t? ibt jbt))))

(define (<b? ibt ib jbt jb)
					;;; EXACT <
					;;; i, j are bounds on intervals
	(or	(<_ ib jb)
		(and (=_ ib jb) (<t? ibt jbt))))

(define (<t? x y) (< (where x BRACKETS) (where y BRACKETS)))
					;;; x, y are interval brackets

(define (<i? j k)			;;; EXACT <
					;;; j, k are intervals
					;;; necessarily overlapping??##
	(let	((j (transform j))
		(k (transform k)))
		(if	(eq-int? j k)
			#f
			(let	((j-lbt (lb-type@ j))
				(j-lb (lb@ j))
				(j-ub (ub@ j))
				(j-ubt (ub-type@ j))
				(k-lbt (lb-type@ k))
				(k-lb (lb@ k))
				(k-ub (ub@ k))
				(k-ubt (ub-type@ k)))
				(and	(not (<b? k-ubt k-ub j-ubt j-ub))
					(not (<b? j-lbt j-lb k-lbt k-lb))
					;;; to ensure overlap
					(or	(<b? k-lbt k-lb j-lbt j-lb)
						(<b? j-ubt j-ub k-ubt k-ub)))))))
					;;; if unreduced empty intervals??##

(define (~<i? j k)
					;;; INEXACT <
					;;; j, k are intervals
					;;; returns #t iff j is smaller beyond
					;;; the PRECISION than k
					;;; used to determine whether squeeze-
					;;; worthy! favours returning #f
	(let	((j (transform j))
		(k (transform k)))
		(if	(eq-int? j k)
			#f
			(let	((j-lbt (lb-type@ j))
				(j-lb (lb@ j))
				(j-ub (ub@ j))
				(j-ubt (ub-type@ j))
				(k-lbt (lb-type@ k))
				(k-lb (lb@ k))
				(k-ub (ub@ k))
				(k-ubt (ub-type@ k)))
				(and	(not (<b? k-ubt k-ub j-ubt j-ub))
					(not (<b? j-lbt j-lb k-lbt k-lb))
					;;; to ensure overlap
					(or	(~<b? k-lbt k-lb j-lbt j-lb)
						(~<b? j-ubt j-ub k-ubt k-ub)))))))
					;;; if unreduced empty intervals??##

(define (eq-int? i j)			;;; EXACT =
					;;; i, j are intervals
	(let	((i-lbt (lb-type@ i))
		(i-lb (lb@ i))
		(i-ub (ub@ i))
		(i-ubt (ub-type@ i))
		(j-lbt (lb-type@ j))
		(j-lb (lb@ j))
		(j-ub (ub@ j))
		(j-ubt (ub-type@ j)))
		(and	(=_ i-lb j-lb) (=_ i-ub j-ub)
			(equal? i-lbt j-lbt)
			(equal? i-ubt j-ubt))))
					;;; or should they be reducible to one
					;;; another?

(define (contiguous? j k)		;;; j, k are intervals
	(let	((j-lbt (lb-type@ j))
		(j-lb (lb@ j))
		(j-ub (ub@ j))
		(j-ubt (ub-type@ j))
		(k-lbt (lb-type@ k))
		(k-lb (lb@ k))
		(k-ub (ub@ k))
		(k-ubt (ub-type@ k)))
		(and	(not (empty? j))
			(not (empty? k))
			(=_ j-ub k-lb)
			(<t? j-ubt k-lbt))))

(define (empty? i)			;;; EXACT
					;;; i is an interval
	(let	((lbt (lb-type@ i))
		(lb (lb@ i))
		(ub (ub@ i))
		(ubt (ub-type@ i)))
		(<b? ubt ub lbt lb)))

(define (point? i)			;;; EXACT
					;;; i is an interval
	(and	(lb-closed? (lb-type@ i))
		(=_ (lb@ i) (ub@ i))
		(ub-closed? (ub-type@ i))))

(define (fail? ret) (equal? ret FAIL))
					;;; ret is result of examination of
					;;; squeezed intervals

(define (succ? ret) (equal? ret COMPLETE-SUCCESS))

(define (keep? ret) (equal? ret RETAIN))

;;; functions
(define (mk-interval type-lb val-lb val-ub type-ub)
	(list type-lb (real val-lb) (real val-ub) type-ub))

(define (lb@ i) (index@ i 2))

(define (ub@ i) (index@ i 3))

(define (lb-type@ i) (index@ i 1))

(define (ub-type@ i) (index@ i 4))

(define (index@ L i)
	(cond	((= i 1)	(car L))
		(else		(index@ (cdr L) (- i 1)))))

(define (lkup2@ i L)
	(cond	((null? L)
			#f)
		((equal? i (caar L))
			(cadar L))
		(else	(lkup2@ i (cdr L)))))

(define (lkup3@ i j L)
	(cond	((null? L)
			#f)
		((and (equal? i (caar L)) (equal? j (cadar L)))
			(caddar L))
		(else	(lkup3@ i j (cdr L)))))

(define (where x L)
	(let loop ((L L) (index 1))
		(cond	((null? L)	#f)
			((equal? x (car L))
				index)
			(else	(loop (cdr L) (+ index 1))))))

(define (imin bt-i b-i bt-j b-j)
					;;; bt-i, bt-j are the bound types
					;;; b-i, b-j are bound values
	(cond	((<b? bt-i b-i bt-j b-j)	(list bt-i b-i))
		(else				(list bt-j b-j))))

(define (imax bt-i b-i bt-j b-j)
					;;; bt-i, bt-j are the bound types
					;;; b-i, b-j are bound values
	(cond	((<b? bt-i b-i bt-j b-j)	(list bt-j b-j))
		(else				(list bt-i b-i))))

(define (transform x)
	(if	(arith-interval? x)
		x
		(approx x)))		;;; assumes that x is some number here

(define (union i j)
					;;; i, j are intervals
	(let	((i-lbt (lb-type@ i))
		(i-lb (lb@ i))
		(i-ub (ub@ i))
		(i-ubt (ub-type@ i))
		(j-lbt (lb-type@ j))
		(j-lb (lb@ j))
		(j-ub (ub@ j))
		(j-ubt (ub-type@ j))
		(no-overlap? (empty? (intersect i j))))
		(if	no-overlap?
			(cond	((empty? i)	(if	(empty? j)
							EMPTY
							j))
				((empty? j)	i)
				((contiguous? i j)
					(list i-lbt i-lb j-ub j-ubt))
				((contiguous? j i)
					(list j-lbt j-lb i-ub i-ubt))
				(else	(arith-debug
						"union(): no overlap in args")
					EMPTY))
			(append	(imin i-lbt i-lb j-lbt j-lb)
				(reverse (imax i-ubt i-ub j-ubt j-ub))))))

(define (intersect i j)
					;;; i, j are intervals
	(let*	((i-lbt (lb-type@ i))
		(i-lb (lb@ i))
		(i-ub (ub@ i))
		(i-ubt (ub-type@ i))
		(j-lbt (lb-type@ j))
		(j-lb (lb@ j))
		(j-ub (ub@ j))
		(j-ubt (ub-type@ j))
		(result (append (imax i-lbt i-lb j-lbt j-lb)
				(reverse (imin i-ubt i-ub j-ubt j-ub)))))
		(if	(empty? result)
			EMPTY
			result)))

(define (uminus i)
					;;; i is an interval
	(mk-interval	(lkup2@ (ub-type@ i) UMIN-BRACKET)
			(neg (ub@ i))
			(neg (lb@ i))
			(lkup2@ (lb-type@ i) UMIN-BRACKET)))

(define (neg x)
					;;; this is unary negation
	(cond	((isinf? x)	INF-)
		((is-inf? x)	INF)
		(else		(-_ ZERO x))))

;;; primitive real-arithmetic functions (low-level and hence the "_")
(define (*_ x y) (* x y))		;;; x, y are internal non-infinite reals
(define (/_ x y) (/ x y))		;;; x, y are internal non-infinite reals
(define (+_ x y) (+ x y))		;;; x, y are internal non-infinite reals
(define (-_ x y) (- x y))		;;; x, y are internal non-infinite reals

;;; constants
(define ZERO	(real 0.0))
(define ONE	(real 1.0))
(define TWO	(real 2.0))
(define BRACKETS '( > { } < ) )
(define LB-OPEN '< )
(define LB-CLOSED '{ )
(define UB-OPEN '> )
(define UB-CLOSED '} )
(define UMIN-BRACKET '( (< >) ({ }) (> <) (} {) ) )
(define INF	'w )
(define INF-	'-w )
(define -INFINF		(mk-interval '{ INF- INF '} ) )
(define EMPTY		(mk-interval '< 2.0 1.0 '> ) )
					;;; empty interval = (2,1)
(define ZEROZERO	(mk-interval '{ 0.0 0.0 '} ) )
					;;; (0,0)
(define ZEROINF		(mk-interval '{ 0.0 INF '} ))
					;;; (0,w)
(define <ZEROINF	(mk-interval '< 0.0 INF '} ))
					;;; (0,w)
(define -INFZERO>	(mk-interval '{ INF- 0.0 '> ))
					;;; (-w,0)
(define ONEONE		(mk-interval '{ 1.0 1.0 '} ) )
					;;; (1,1)
(define FAIL			'fail)
(define COMPLETE-SUCCESS	'succ)
(define RETAIN			'keep)

