(define (mult i j k)
					;;; i, j, k are intervals
	(let	((i- (intersect i  -INFZERO>))
		 (i0 (intersect i  ZEROZERO ))
		 (i+ (intersect i <ZEROINF  ))
		 (j- (intersect j  -INFZERO>))
		 (j0 (intersect j  ZEROZERO ))
		 (j+ (intersect j <ZEROINF  ))
		 (k- (intersect k  -INFZERO>))
		 (k0 (intersect k  ZEROZERO ))
		 (k+ (intersect k <ZEROINF  )))
		(list	(mult--+ (uminus i-) (uminus j-)         k+ )
			(mult-+- (uminus i-)         j+  (uminus k-))
			(mult+--         i+  (uminus j-) (uminus k-))
			(mult+++         i+          j+          k+ )
			(mult-examine i- j0 k0)
			(mult-examine i+ j0 k0)
			(mult-examine i0 j- k0)
			(mult-examine i0 j+ k0)
			(mult-examine i0 j0 k0))))

(define (square i j)
					;;; i, j are intervals
	(let	((i- (intersect i  -INFZERO>))
		 (i0 (intersect i  ZEROZERO ))
		 (i+ (intersect i <ZEROINF  ))
		 (j0 (intersect j  ZEROZERO ))
		 (j+ (intersect j <ZEROINF  )))
		(list	(square- (uminus i-) j+)
			(square+         i+  j+)
			(square-examine i0 j0))))

(define (zero-one2 i j)
					;;; i, j are intervals
	(let	((i0 (intersect i ZEROZERO))
		 (j1 (intersect j ONEONE)))
		(list	(non-empty-examine2 i0 j)
			(non-empty-examine2 i j1))))

(define (zero-one1 i)
					;;; i is an interval
	(let	((i0 (intersect i ZEROZERO))
		 (i1 (intersect i ONEONE)))
		(list	(non-empty-examine1 i0)
			(non-empty-examine1 i1))))

(define (zero1 i)
					;;; i is an interval
	(let	((i0 (intersect i ZEROZERO)))
		(list	(non-empty-examine1 i0))))

(define (mult--+ i j k)
	(let*	((ijk (mult-squeeze i j k))
		 (i~ (car ijk))
		 (j~ (cadr ijk))
		 (k~ (caddr ijk)))
		(mult-examine (uminus i~) (uminus j~) k~)))

(define (mult-+- i j k)
	(let*	((ijk (mult-squeeze i j k))
		 (i~ (car ijk))
		 (j~ (cadr ijk))
		 (k~ (caddr ijk)))
		(mult-examine (uminus i~) j~ (uminus k~))))

(define (mult+-- i j k)
	(let*	((ijk (mult-squeeze i j k))
		 (i~ (car ijk))
		 (j~ (cadr ijk))
		 (k~ (caddr ijk)))
		(mult-examine i~ (uminus j~) (uminus k~))))

(define (mult+++ i j k)
	(let*	((ijk (mult-squeeze i j k))
		 (i~ (car ijk))
		 (j~ (cadr ijk))
		 (k~ (caddr ijk)))
		(mult-examine i~ j~ k~)))

(define (square- i j)
	(let*	((iij (mult-squeeze i i j))
		 (i~ (car iij))
		 (j~ (caddr iij)))
		(square-examine (uminus i~) j~)))

(define (square+ i j)
	(let*	((iij (mult-squeeze i i j))
		 (i~ (car iij))
		 (j~ (caddr iij)))
		(square-examine i~ j~)))

(define (mult-squeeze i j k)
	(list	(intersect i (mult-int k (inv j)))
		(intersect j (mult-int k (inv i)))
		(intersect k (mult-int i j))))

(define (mult-int i j)
					;;; i, j are positive intervals
	(if (or (empty?	i) (empty? j))
		EMPTY
		(let*	((i-tlb (lb-type@ i))
			 (i-lb (lb@ i))
			 (i-ub (ub@ i))
			 (i-tub (ub-type@ i))
			 (j-tlb (lb-type@ j))
			 (j-lb (lb@ j))
			 (j-ub (ub@ j))
			 (j-tub (ub-type@ j))
			 (lb (multb i-tlb i-lb j-tlb j-lb '-))
			 (ub (multb i-tub i-ub j-tub j-ub '+)))
			(append lb (reverse ub)))))

(define (multb bt-i b-i bt-j b-j round)
					;;; bt-i, bt-j are the bounding brackets
					;;; b-i, b-j are positive bound values
					;;; round is direction of rounding
	(let	((bt (mult-brack bt-i bt-j)))
		(if	(or (isinf? b-i) (isinf? b-j))
			(list bt INF)
			(list (open-bound bt) (fuzz*_ b-i b-j round)))))

(define (mult-brack ti tj)
					;;; ti, tj are brackets
	(lkup3@ ti tj MULT-BRACKET))

(define (fuzz*_ i j round)
	(fuzzy (*_ i j) round))

(define (inv i)
	(if (empty? i)
		EMPTY
		(let	((lbt (lb-type@ i))
			 (lb (lb@ i))
			 (ub (ub@ i))
			 (ubt (ub-type@ i)))
			(append (invb ubt ub '-) (reverse (invb lbt lb '+))))))

(define (invb bt b round)
					;;; bt is the bound bracket
					;;; b is the bound value
					;;; round is direction of rounding
	(let ((bt (lkup2@ bt UMIN-BRACKET)))
		(cond	((=_ b ZERO)	(list bt INF))
			((isinf? b)	(list bt ZERO))
			(else	(list (open-bound bt) (fuzz/_ ONE b round))))))

(define (fuzz/_ i j round)
	(fuzzy (/_ i j) round))

(define (mult-examine i j k)
					;;; i, j, k are intervals
	(list	(cond	((or (empty? i) (empty? j) (empty? k))
				FAIL)
			((and (point? i) (point? j) (point? k))
				COMPLETE-SUCCESS)
			((or (eq-int? i ZEROZERO) (eq-int? j ZEROZERO))
				COMPLETE-SUCCESS)
			(else	RETAIN))
		i j k))

(define (square-examine i j)
					;;; i, j are intervals
	(list	(cond	((or (empty? i) (empty? j))
				FAIL)
			((and (point? i) (point? j))
				COMPLETE-SUCCESS)
			((eq-int? i ZEROZERO)
				COMPLETE-SUCCESS)
			(else	RETAIN))
		i j))

(define (non-empty-examine2 i j)
	(list	(if	(or (empty? i) (empty? j))
			FAIL
			COMPLETE-SUCCESS)
		i j))

(define (non-empty-examine1 i)
	(list	(if	(empty? i)
			FAIL
			COMPLETE-SUCCESS)
		i))

;;; constants
(define MULT-BRACKET
	'(	(> > >) (> { <) (> } >) (> < <)
		({ > >) ({ { {) ({ } }) ({ < <)
		(} > >) (} { {) (} } }) (} < <)
		(< > >) (< { <) (< } >) (< < <)	))
