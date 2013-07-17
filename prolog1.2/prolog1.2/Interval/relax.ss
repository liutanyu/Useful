;;; functions
(define (last-matching list1 list2)	;;; returns tail of list1 such that
					;;; tail's length equals list2's length
	(define (excise ls count)
		(if (> count 0)
			(excise (cdr ls) (- count 1))
			ls))
	(excise list1 (- (length list1) (length list2))))

(define (map-var-val goal binding)
					;;; binding is a binding including
					;;; nature
					;;; returns (<list of vars>
					;;; <their bindings>)
					;;; note: (term-deref ...) and
					;;; (term-instantiate ...) DIFFER
					;;; for composites, and in one level
					;;; of extra dereferencing
					;;; note: values of vars are intervals
	(define (func args bdgs vars var-bdgs)
		(if	(null? args)
			(list vars var-bdgs)
			(let	((bdg (car bdgs))
				(arg (term-deref (car args))))
				(cond	((number? arg)
						(if	(eq-int? bdg
								(approx arg))
							(func (cdr args)
								(cdr bdgs)
								vars var-bdgs)
							(error 'map-var-val
						"unequal constants ~d, ~d"
								bdg (approx
									arg))))
					((term-var? arg)
						(if	(memq arg vars)
							(func (cdr args)
								(cdr bdgs)
								vars var-bdgs)
							(func (cdr args)
								(cdr bdgs)
								(cons arg vars)
								(cons bdg
								    var-bdgs))))
					(else	(error 'map-var-val
							"unidentified term ~s"
							arg))))))

	(arith-debug "in map-var-val()")
	(let	((goal-args (comp-cdr (goal-term goal)))
		 (bdgs (cdr binding)))
		(func (last-matching goal-args bdgs) bdgs '() '() )))

(define (init-arith! var-set)
					;;; returns a list of variables which
					;;; have to be uninstantiated on
					;;; backtracking and more ...
	(define (func vars uninst-vars inst-vars old-bdgs)
		(if	(null? vars)
			(list uninst-vars inst-vars old-bdgs)
			(let*	((var (car vars))
				(val (var-val var)))
					;;; abuse of (var-val ...)
				(cond	((not (var-inst? var))
						(var-inst! var -INFINF)
						(func (cdr vars)
							(cons var uninst-vars)
							inst-vars old-bdgs))
					((number? val)
						(var-inst! var (approx val))
						(func (cdr vars) uninst-vars
							(cons var inst-vars)
							(cons val old-bdgs)))
					((arith-interval? val)
						(func (cdr vars) uninst-vars
							inst-vars old-bdgs))
					(else	(error 'init-arith!
						"illegal var ~s" var))))))

	(arith-debug "in init-arith!()")
	(func var-set '() '() '() ))

(define (extract-args g-term)
					;;; g-term is (goal-term goal)
					;;; extracts args from g-term
					;;; and makes ready for execution
	(let	((args (comp-cdr (term-instantiate g-term))))
					;;; still need to replace numeric
					;;; constants by intervals
		(map	(lambda (arg)
				(cond	((number? arg)
						(approx arg))
					(else	arg)))
			args)))

(define (extract-arg-vars g-term)
					;;; g-term is (goal-term goal)
					;;; extracts (var) args from g-term
					;;; used in detecting duplicated vars
	(let	((args (comp-cdr g-term)))
		(map	(lambda (arg)
				(term-deref arg))
			args)))

(define (restore-var-set state var-set bindings)
	(arith-debug "in restore-var-set() with state:")
	(arith-debug state)
	(arith-debug "and bindings:")
	(arith-debug (term-instantiate bindings))
	(cond	((eq? state 'uninst)	;;; restore to uninstantiated state?
			(map	(lambda (var) (var-uninst! var))
				var-set))
		((eq? state 'inst)
			(do	((var-set var-set (cdr var-set))
				(bindings bindings (cdr bindings)))
				((null? var-set))
				(var-inst! (car var-set) (car bindings))))
		(else	(error 'restore-var-set "illegal state passed as arg"))))

(define (transform-goal goal program)
	(let*	((g-term (goal-term goal))
		 (name (term-functor g-term))
		 (args (extract-arg-vars g-term))
		 (tgoal (apply	(name->transform-func name)
				(list args goal program))))
		(if (not (eq? goal tgoal))
		    (begin (arith-debug "transforming goal:")
			   (arith-debug (term-instantiate (goal-term tgoal)))))
		tgoal))

(define (transform-add args goal program)
	(cond	((eq? (car args) (caddr args))	;;; x + y = x --> y = 0
			(make-goal
				(list 'zero1 (cadr args))
				program))
		((eq? (cadr args) (caddr args))	;;; x + y = y --> x = 0
			(make-goal
				(list 'zero1 (car args))
				program))
		((eq? (car args) (cadr args))	;;; x + x = y --> 2 * x = y
			(make-goal
				(list 'mult 2 (car args) (caddr args))
				program))
		(else goal)))			;;; x + y = z

(define (transform-mult args goal program)
	(cond	((and	(eq? (car args) (cadr args))
			(eq? (cadr args) (caddr args)))
						;;; x * x = x --> x = 0|1
			(make-goal
				(list 'zero-one1 (car args))
				program))
		((eq? (car args) (caddr args))	;;; x * y = x --> x = 0 | y = 1
			(make-goal
				(list 'zero-one2 (car args) (cadr args))
				program))
		((eq? (cadr args) (caddr args))	;;; x * y = y --> y = 0 | x = 1
			(make-goal
				(list 'zero-one2 (cadr args) (car args))
				program))
		((eq? (car args) (cadr args))	;;; x * x = y --> x^2 = y
			(make-goal
				(list 'square (car args) (caddr args))
				program))
		(else goal)))			;;; x * y = z

(define (transform-square args goal program)
	(if (eq? (car args) (cadr args))	;;; x^2 = x --> x = 0 | x = 1
		(make-goal
			(list 'zero-one1 (car args))
			program)
		goal))				;;; x^2 = y

(define (transform-geq args goal program)
	(if (eq? (car args) (cadr args))	;;; x >= x --> true
		(make-goal '(true) program)
		goal))				;;; x >= y

(define (transform-gt args goal program)
	(if (eq? (car args) (cadr args))	;;; x > x --> fail
		(make-goal '(fail) program)
		goal))				;;; x > y

(define (transform-neq args goal program)
	(if (eq? (car args) (cadr args))	;;; x =/= x --> fail
		(make-goal '(fail) program)
		goal))				;;; x =/= y

(define (transform-int args goal program) goal)	;;; int(x)

(define (transform-zero-one2 args goal program)
	(if (eq? (car args) (cadr args))	;;; x = 0 | x = 1 --> x = 0|1
		(make-goal
			(list 'zero-one1 (car args))
			program)
		goal))				;;; x = 0 | y = 1

(define (transform-zero-one1 args goal program) goal)	;;; x = 0|1

(define (transform-zero1 args goal program) goal)	;;; x = 0

(define (relax-squeeze goal program s f)
	(arith-debug "in relax-squeeze() with goal:")
	(arith-debug (term-instantiate (goal-term goal)))
	(let*	((tgoal (transform-goal goal program))	;;; no duplicated vars
		 (g-term (goal-term tgoal))
		 (name (term-functor g-term))
					;;; collect all variables in goal
		 (var-set (term-var-set g-term)))
		(if	(not (arith-primitive? name))
			(error 'relax-squeeze "non-arith goal in goal list"))
					;;; initialize any uninitialized vars
		(let*	((ret (init-arith! var-set))
			(uninst-var-set (car ret))
			(undo-var-set (cadr ret))
			(undo-bindings (caddr ret))
			(args (extract-args g-term))
			(result (useful-bdgs (apply (name->func name) args))))
					;;; apply instantiated transformed goal
			(try-bdg result tgoal program s
				(lambda ()
					(restore-var-set 'uninst
						uninst-var-set '())
					(restore-var-set 'inst undo-var-set
						undo-bindings)
					(f))))))

(define (undelay! goal var-set)
	(map	(lambda (v)
			(var-del-constraint! goal v))
		var-set))

(define (try-bdg result goal program s f)
					;;; *** test me for loops ***
	(define (delay! goal var-set where)
					;;; note that whenever an arithmetic
					;;; primitive is awakened,
					;;; it is excised from the constraint-
					;;; lists of all its vars before
					;;; execution
					;;; but, the sequence of variable
					;;; instantiation DOES NOT guarantee
					;;; this!!
		(for-each
			(lambda (v)
				(var-add-constraint! goal v where))
			var-set))

	(arith-debug "in try-bdg() with binding list:")
	(arith-debug result)
	(if	(null? result)
		(f)			;;; exit to Prolog on goal failure
		(let*			;;; try another squeezed binding
			((ret (map-var-val goal (car result)))
			 (var-set (car ret))
			 (bdg (cadr ret))
			 (return-val (isolate-squeezed var-set bdg))
			 (squeezed-vars (car return-val))
			 (new-bindings (cadr return-val))
			 (old-bindings (caddr return-val))
			 (did-squeeze? (not (null? squeezed-vars)))
			 (delay-more? (keep? (caar result))))
			(cond	((and delay-more? did-squeeze?)
					(arith-debug "DELAY & BIND")
					(bind! var-set squeezed-vars new-bindings
						old-bindings goal program
						(lambda (fail)
							(scheduler program
								s fail))
						(lambda ()
							(try-bdg (cdr result)
								goal program
								s f))))
				(delay-more?
					;;; and (not did-squeeze?)
					(arith-debug "DELAY ONLY")
					;;; actually delaying on all is NOT
					;;; essential!
					(delay! goal var-set 'ANY)
					(flounder! goal)
					(s (lambda ()
						(unflounder! goal)
						(undelay! goal var-set)
						(try-bdg (cdr result) goal
							program s f))))
				(did-squeeze?
					;;; and (not delay-more?)
					(arith-debug "BIND ONLY")
					(bind! '() squeezed-vars new-bindings
						old-bindings goal program
						(lambda (fail)
							(scheduler program
								s fail))
						(lambda ()
							(try-bdg (cdr result)
								goal program
								s f))))
				(else	(arith-debug "CONTINUE")
					(s f))))))

;;; Note:  any routine which invokes bind! is responsible for ensuring that
;;; scheduler will be invoked at some point in the success continuation.
(define (bind! delay-vars squeezed-vars new-bindings old-bindings
		goal program s f)
					;;; assumes that new-bindings consists
					;;; of only intervals or like-values; ie
					;;; constraints need not be transferred.
					;;; instantiates all the squeezed vars
					;;; FIRST, then wakes constraints on
					;;; each of them by turn
	(define (wake-constraints-all var-set program s f)
					;;; WASTEFUL; this could be optimized
					;;; to awaken only the sleepy ones.
					;;; wakes constraints on all the vars
					;;; by turn
		(if	(null? var-set)
			(s f)
			(var-wake-constraints (car var-set) program
				(lambda (fail)
					(wake-constraints-all (cdr var-set)
						program s fail))
				f)))

	(arith-debug "in bind!() with new-bindings:")
	(arith-debug new-bindings)
	(if	(null? squeezed-vars)
		(s f)
		(begin	(map	(lambda (var bdg)
					(unite! var bdg))
				squeezed-vars new-bindings)
			(if	(not (null? delay-vars))
				(flounder! goal))
			(wake-constraints-all squeezed-vars program
				(if	(not (null? delay-vars))
					(lambda (fail)
						(map (lambda (var)
							(var-add-constraint!
							 goal var 'REAR))
						     delay-vars)
						(s fail))
					s)
				(if	(not (null? delay-vars))
					(lambda ()
						(unflounder! goal)
						(undelay! goal delay-vars)
						(restore-var-set 'inst
							squeezed-vars
							old-bindings)
						(f))
					(lambda ()
						(restore-var-set 'inst
							squeezed-vars
							old-bindings)
						(f)))))))

(define (isolate-squeezed var-set binding)
					;;; binding is a list of bindings sans
					;;; nature
	(define (f vars bdgs squeezed-vars new-bdgs old-bdgs)
		(if	(null? vars)
			(list squeezed-vars new-bdgs old-bdgs)
			(let*	((var (car vars))
				(new-val (car bdgs))
				(old-val (var-val var)))
				(if	(~<i? new-val old-val)
					;;; actually squeezed?
					(f (cdr vars) (cdr bdgs)
						(cons var squeezed-vars)
						(cons new-val new-bdgs)
						(cons old-val old-bdgs))
					(f (cdr vars) (cdr bdgs) squeezed-vars
						new-bdgs old-bdgs)))))

	(arith-debug "in isolate-squeezed() with var-set:")
	(arith-debug (term-instantiate var-set))
	(arith-debug "and binding:")
	(arith-debug binding)
	(f var-set binding '() '() '()))

(define (relax-split program s f)
	(arith-debug "in relax-split()")
	(if	(dlist-empty? SPLITTING-GOALS)
		(s f)			;;; exit to Prolog via success
		(let*	((old-split-list (backup-split-list))
			(goal (dlist-delete-front! SPLITTING-GOALS))
			(g-term (goal-term goal))
			(name (term-functor g-term))
			(var-set (term-var-set g-term)))
			(if	(not (arith-split-prim? name))
				(error 'relax-split
					"illegal goal in SPLITTING-GOALS"))
			(user-debug "executing system predicate:")
			(user-debug (term-instantiate g-term))
			(unflounder! goal)
			(let*	((ret (init-arith! var-set))
				(uninst-var-set (car ret))
				(undo-var-set (cadr ret))
				(undo-bindings (caddr ret))
				(args (extract-args g-term))
				(result (useful-bdgs (apply (name->func name)
								args))))
					;;; apply instantiated goal, i.e., split
					;;; perform bindings
				(bind-split! result goal program s
					(lambda ()
						(flounder! goal)
						(restore-var-set 'uninst
							uninst-var-set '())
						(restore-var-set 'inst
							undo-var-set
							undo-bindings)
						(restore-split-list!
							old-split-list)
						(f)))))))

(define (useful-bdgs L)			;;; L is a list of bindings
	(cond	((null? L)
			'())
		((not (fail? (caar L)))
			(cons (car L) (useful-bdgs (cdr L))))
		(else	(useful-bdgs (cdr L)))))

(define (bind-split! bindings goal program s f)
					;;; note split takes one arg only
	(arith-debug "in bind-split!() with bindings:")
	(arith-debug bindings)
	(if	(null? bindings)	;;; exhausted splitting alternatives?
		(f)			;;; note this has not been a successful
					;;; path of execution!
		(let*	((old-split-list (backup-split-list))
			 (ret (map-var-val goal (car bindings)))
			 (var-set (car ret))
			 (var-bdg (cadr ret))
			 (return-val (isolate-squeezed var-set var-bdg))
			 (squeezed-vars (car return-val))
			 (new-bindings (cadr return-val))
			 (old-bindings (caddr return-val))
			 (did-squeeze? (not (null? squeezed-vars)))
			 (delay-more? (keep? (caar bindings)))
					;;; note (caar bindings) is the nature
			 (success (lambda (fail)
					(user-debug "continuing after:")
					(user-debug (term-instantiate
							(goal-term goal)))
					(relax-split program s fail)))
					;;; more splitting on success!
			 (fail	(lambda ()
					(user-debug "backtracking to:")
					(user-debug (term-instantiate
							(goal-term goal)))
					(unflounder! goal)
					(restore-split-list! old-split-list)
					(bind-split! (cdr bindings) goal
						program s f))))
					;;; note (f) not explicitly required as
					;;; (bind-split! ...) does it!

			(if	delay-more?
				(begin	(flounder! goal)
					(dlist-insert-back! goal
						SPLITTING-GOALS)))
			(bind! '() squeezed-vars new-bindings old-bindings
				goal program
				(lambda (fail)
					(scheduler program success fail))
				fail))))

(define (name->func name)
	(case	name
		((add)		add)
		((mult)		mult)
		((square)	square)
		((geq)		geq)
		((gt)		gt)
		((neq)		neq)
		((int)		int)
		((zero-one2)	zero-one2)
		((zero-one1)	zero-one1)
		((zero1)	zero1)
		((split-abs)	split-abs)
		((split-rel)	split-rel)
		((split-machine) split-machine)
		((split)	split)
		(else		(error 'name->func "bad arith primitive ~s"
					name))))

(define (name->transform-func name)
	(case	name
		((add)		transform-add)
		((mult)		transform-mult)
		((square)	transform-square)
		((geq)		transform-geq)
		((gt)		transform-gt)
		((neq)		transform-neq)
		((int)		transform-int)
		((zero-one2)	transform-zero-one2)
		((zero-one1)	transform-zero-one1)
		((zero1)	transform-zero1)
		(else		(error 'name->func "bad arith primitive ~s"
					name))))

(define (arith-primitive? name)
	(case	name
		((add mult square geq gt neq int zero-one2 zero-one1 zero1
		  split-abs split-rel split-machine split)
			#t)
		(else	#f)))

(define (arith-split-prim? name)
	(case	name
		((split-abs split-rel split-machine split)	#t)
		(else	#f)))

(define (init-arith-goal-lists!)
	(set! SPLITTING-GOALS (make-dlist)))

(define (backup-split-list)
	(arith-debug "in backup-split-list()")
					;;; note freshly allocated copy is
					;;; of the essence
	(list-copy SPLITTING-GOALS))

(define (restore-split-list! old-list)
	(arith-debug "in restore-split-list!()")
	(set! SPLITTING-GOALS old-list))

(define (display-goal-lists)
	(display "Splitting goals:")
	(newline)
	(for-each
		(lambda (goal)
			(display "  ")
			(display (term-instantiate (goal-term goal)))
			(newline))
		(dlist->list SPLITTING-GOALS)))

(define (show-goal-lists)
	(arith-debug "SPLITTING-GOALS:")
	(for-each
		(lambda (goal)
			(arith-debug (term-instantiate (goal-term goal))))
		(dlist->list SPLITTING-GOALS)))

;;; global list
(define SPLITTING-GOALS (make-dlist))
