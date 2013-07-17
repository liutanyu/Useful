;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Search
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (unify term1 term2 program s f)
	(unify-quick term1 term2 program
		(lambda (fail)
			(scheduler program s fail))
		f))

;;; unify-quick takes care of all aspects of unification with the exception
;;; of invocation of the scheduler upon completion.  It is used as the
;;; recursive portion of the unification algorithm in order to avoid
;;; invoking the scheduler each time a variable becomes bound.  This
;;; necessary step is performed by unify after the unification is complete,
;;; in order to deal with any delayed goals which should possibly be woken
;;; due to bindings performed during unification.

(define (unify-quick term1 term2 program s f)
	(define (u term1 term2 s f)
		(if debug?
			(begin
				(display "u: ")
				(display (term-instantiate term1))
				(display (term-instantiate term2))
				(newline)))
		(cond	((and intervals? (arith-unify? term1 term2))
				(arith-unify term1 term2 program s f))
			((term-var? term1)
				(cond	((var=? term1 term2)
						;;; same variable?
						(s f))
					((not (var-inst? term1))
						(var-instantiate! term1 term2
							program s f))
					((not (term-var? term2))
						;;; const? or comp? term2
						(unify-quick (var-val term1)
							term2
							program s f))
					((not (var-inst? term2))
						(var-instantiate! term2 term1
							program s f))
					(else	;;; both are instantiated?
						(unify-quick (var-val term1)
							(var-val term2)
							program s f))))
			((term-var? term2)
				(cond	((var-inst? term2)
						(unify-quick term1
							(var-val term2)
							program s f))
					(else	(var-instantiate! term2 term1
							program s f))))
			((term-const? term1)
						;;; neither term is a variable
				(if	(term-const? term2)
					(if (const=? term1 term2) (s f) (f))
					(f)))
			((term-const? term2)
				(f))
			(else			;;; both must be term-comp?
				(unify-quick (comp-car term1)
					(comp-car term2)
					program
					(lambda (f)
						(unify-quick (comp-cdr term1)
							(comp-cdr term2)
							program
							s f))
					f))))
	(u (term-deref term1) (term-deref term2) s f))


(define (or-branch clause goal program s f)
  (if debug?
      (begin
	(display "or-branch clause: ")
	(display (term-instantiate clause))
	(display " goal: ")
	(display (term-instantiate (goal-term goal)))
	(newline)))
  (unify
   (clause-head clause)
   (goal-term goal)
   program
   (lambda (f) (and-node (clause-body clause) program s f))
   f))

(define (or-node clause-makers goal program s f)
	(if	debug?
		(begin	(display "or-node goal: ")
			(display (term-instantiate (goal-term goal)))
			(display " clause-makers: ")
			(display clause-makers)
			(newline)))
	(if	(null? clause-makers)
		(f)
		(or-branch
			((car clause-makers))
			goal
			program
			s (lambda ()
				(or-node (cdr clause-makers) goal
					program s f)))))

(define (and-branch goal program s f)
	(define (success fail)
		(user-debug (list "continuing after" (goal-id goal) ":"))
		(user-debug (term-instantiate (goal-term goal)))
		(s fail))
	(define (fail)
		(user-debug (list "backtracking to" (goal-id goal) ":"))
		(user-debug (term-instantiate (goal-term goal)))
		(f))

	(let	((pred (goal-pred goal))
		 (instantiated-goal (term-instantiate (goal-term goal))))
		(if	debug?
			(begin	(display "and-branch goal: ")
				(display instantiated-goal)
				(newline)))
		(user-debug
			(list	(if (pred-how? pred)	;;; system predicate?
					"executing system predicate"
					"executing user-defined predicate")
				(goal-id goal)
				":"))
		(user-debug instantiated-goal)
		(if	(pred-how? pred)	;;; system predicate?
			((pred-how pred) goal program success fail)
			(or-node (pred-what pred) goal program success fail))))

(define (and-node terms program s f)
    (if debug?
        (begin (display "and-node terms: ")
               (display (term-instantiate terms))
               (newline)))
    (if (null? terms)
					;;; end of normal Prolog execution?
	(if intervals?
	    (relax-split program s f)	;;; relaxation followed by (s f)
					;;; which is done within
					;;; (relax-split ...)
	    (s f))
        (let ((goal (make-goal (car terms) program)))
              (goal-first-try!
                  goal
                  (lambda (f)		;;; run continuation
                      (and-branch 
                          goal
                          program
                          (lambda (f) (and-node (cdr terms) program s f))
                          f))
                  (lambda (f)		;;; delay continuation
                      (and-node (cdr terms) program s f))
                  f))))

(define (all-solutions vars-template goal-term program)
	(if debug? (begin (display "in all-solutions()") (newline)))
	(and-branch (make-goal goal-term program) program
		(lambda (fail)
			(let	((soln (term-instantiate vars-template)))
				(cons soln (fail))))
		(lambda () '())))
