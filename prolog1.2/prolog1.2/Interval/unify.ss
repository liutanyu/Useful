;;; predicates
(define	(arith-unify? term1 term2)
	(or (arith-var? term1) (arith-var? term2)))

(define (arith-var? x)			;;; x is any dereferenced term
	(and	(term-var? x)
		(var-inst? x)
		(arith-interval? (var-val x))))

;;; functions
(define (arith-unify term1 term2 program s f)
					;;; term1, term2 are dereferenced terms
	(arith-debug "in arith-unify() with term1:")
	(arith-debug (term-instantiate term1))
	(arith-debug "and term2:")
	(arith-debug (term-instantiate term2))
	(if	(arith-var? term1)
		(arith-u term1 term2 program s f)
		(arith-u term2 term1 program s f)))

(define (arith-u arith-var term program s f)
					;;; arith-var is an arithmetic var
					;;; term is any term
					;;; in all the following, no reference
					;;; is maintained to the unified!!##
	(arith-debug "in arith-u() with arith-var:")
	(arith-debug (term-instantiate arith-var))
	(arith-debug "and term:")
	(arith-debug (term-instantiate term))
	(cond	((and (term-var? term) (not (var-inst? term)))
					;;; term is uninstantiated variable?
			(var-instantiate! term arith-var program s f))
		((and (arith-var? term) (var=? arith-var term))
					;;; same variable?
			(s f))
		((arith-var? term)
					;;; term is a different and bound
					;;; arithmetic var?
			(aau arith-var term program s f))
		((number? term)		;;; constant term?
			(acu arith-var term program s f))
		(else	(f))))		;;; unification fails if term is bound
					;;; to anything else

(define	(acu avar c program s f)
					;;; avar is a var instantiated to an
					;;; interval
					;;; c is a number
	(let*	((avar-val (var-val avar))
		(c-val (approx c))
		(int-new (intersect avar-val c-val)))
		(cond	((empty? int-new)
				(f))
			((~<i? int-new avar-val)
					;;; (~<i? c-val avar-val) is same?
					;;; squeezing possible?
				(var-instantiate! avar int-new program s f))
			(else	(s f)))))

(define	(aau avar1 avar2 program s f)
					;;; avar1, avar2 are distinct vars
					;;; instantiated to intervals
	(let*	((avar1-val (var-val avar1))
		(avar2-val (var-val avar2))
		(int-new (intersect avar1-val avar2-val)))
		(if	(empty? int-new)
			(f)
			(if	(~<i? int-new avar2-val)
					;;; squeezable?
					;;; FIRST instantiate avar2 to int-new
					;;; AND make avar1 refer to avar2
					;;; note: constraints should be xferred
					;;; THEN wake any constraints
					;;; otherwise bindings may not get
					;;; successively narrower!!
				(let	((avar1-constraints
						(var-constraints avar1)))
					(xfer-all-delays! avar1-constraints
						avar2)
					(bind! '() (list avar1 avar2)
						(list avar2 int-new)
						(list avar1-val avar2-val)
						'() program s
						(lambda ()
							(restore-delay!
								avar1-constraints
								avar1
								(list avar2))
							(f))))
				(var-instantiate! avar1 avar2 program s f)))))

(define (xfer-all-delays! delay-dlist to-var)
	(let    ((delay-list (dlist->list delay-dlist)))
		(for-each
			(lambda (dlay)
				(var-add-constraint! dlay to-var 'REAR))
						;;; REAR to preserve order
			delay-list)))
 
(define (erase-delays! var) (vector-set! var 3 (make-dlist)))
                                                ;;; NON-PORTABLE
                                                ;;; *** test me ***
 
(define (fill-delays! var dlays) (vector-set! var 3 dlays))
                                                ;;; NON-PORTABLE
                                                ;;; *** test me ***

(define (transfer-delay! var var-set)
	(arith-debug "in transfer-delay!()")
	(let	((constraints (var-constraints var)))
						;;; note copying essential??##@@
						;;; but all vars get SAME copy?#
		(for-each
			(lambda (to-var)
				(xfer-all-delays! constraints to-var))
			var-set)
		(erase-delays! var)
		constraints))

(define (purge-delays! delay-dlist from-var)
	(let    ((delay-list (dlist->list delay-dlist)))
		(for-each
			(lambda (dlay)
				(var-del-constraint! dlay from-var))
			delay-list)))

(define (restore-delay! constraints var var-set)
	(arith-debug "in restore-delay!()")
	(fill-delays! var constraints)
	(for-each
		(lambda (from-var)
			(purge-delays! constraints from-var))
		var-set))

;;; avar is an arithmetic variable (instantiated to an interval).
;;; value is an arithmetic interval.
;;; _unifies_ value with avar; this is done to handle multiple occurrences
;;; of the same variable in a call to an arithmetic primitive.
(define	(unite! avar value)
	(let*	((avar-val (var-val avar))
		(int-new (intersect avar-val value)))
		(if	(<i? avar-val int-new)
			(error 'unite! "widening interval from ~s to ~s"
				avar-val int-new))
		(var-inst! avar int-new)))
