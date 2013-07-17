
;;; functions
(define (real x) x)
					;;; (exact->inexact ...) required?

(define (approx const)			;;; const is an integer/real constant
					;;; of "infinite" precision
	(mk-interval LB-CLOSED (real const) (real const) UB-CLOSED))
					;;; bring down the precision??##

(define (hack x)
					;;; x is an internal real
	(cond	((isinf? x)	INFMAX)
		((is-inf? x)	-INFMAX)
		(else		x)))

(define (avg x y)
					;;; x, y are internal reals
	(let	((x~ (hack x))
    		(y~ (hack y)))
		(/_ (+_ x~ y~) TWO)))

;;; low-level primitives
(define (<_ x y)
					;;; EXACT <
					;;; x, y are internal reals
	(cond	((equal? x y)			#f)
		((or (is-inf? x) (isinf? y))	#t)
		((or (isinf? x) (is-inf? y))	#f)
		(else				(< x y))))

(define (=_ x y)
					;;; EXACT =
					;;; x, y are internal reals
	(cond	((equal? x y)	#t)
		((or (isinf? x) (isinf? y) (is-inf? x) (is-inf? y))
			#f)
		(else	(= x y))))

(define (~<_ x y) (<_ x y))
					;;; INEXACT <
					;;; x, y are non-infinite reals

(define (~_a x y prec)
					;;; INEXACT = (absolute)
					;;; x, y are non-infinite reals
					;;; prec is a real >= 0
	(and	(<= (-_ x y) prec)
		(<= (-_ y x) prec)))

(define (~_r x y prec)
					;;; INEXACT = (relative)
					;;; x, y are non-infinite reals
	(let	((prec+ (+ 1 prec)) (prec- (- 1 prec)))
		(and	(<= x (*_ y (if (<_ y ZERO) prec- prec+)))
			(<= y (*_ x (if (<_ x ZERO) prec- prec+))))))

(define (~_m x y)
					;;; INEXACT = (machine relative)
					;;; x, y are non-infinite reals
	(and	(<= x (*_ y (if (<_ y ZERO) FUZZ- FUZZ+)))
		(<= y (*_ x (if (<_ x ZERO) FUZZ- FUZZ+)))))

;;; constants
(define INFMAX		(real 999999999999.999))
(define -INFMAX		(real (- 0.0 999999999999.999)))

(define (find-fuzz e)
	(let* ((x 1.0) (epsilon (/ e 2.0)) (y (* x (+ 1.0 epsilon))))
	      (if (equal? x y) e (find-fuzz epsilon))))
(define FUZZ	(find-fuzz 1.0))	;;; addend for fuzzing intervals
(define FUZZ+	(+ 1.0 FUZZ))		;;; multiplier for fuzzing intervals
(define FUZZ-	(- 1.0 FUZZ))		;;; multiplier for fuzzing intervals
