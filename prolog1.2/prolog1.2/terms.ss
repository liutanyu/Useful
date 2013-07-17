;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Terms -- There are three classes of terms:
;;;          1. Variables:  vectors with a type, name and value in them
;;;          2. Constants:  symbol or atom or character or string
;;;          3. Composites: pairs of terms
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; returns true iff x is a term
(define (term? x) (or (term-var? x) (term-const? x) (term-comp? x)))

;;; returns true iff term is a variable
(define term-var? vector?)


(define (term-not-var? term)
  (not (term-var? term)))


;;; returns true iff term is a constant
(define (term-const? term)
  (or (symbol? term)
      (number? term)
      (char? term)
      (string? term)
      (boolean? term)
      (null? term)))

;;; returns true iff term is a composite term 
(define term-comp? pair?)

;;; returns true iff terms are equal
(define term=? equal?)

(define (term-ground? term)
  (cond ((term-var? term)
         (if (var-inst? term)
             (term-ground? (var-val term))
             #f))
        ((term-comp? term)
         (if (term-ground? (comp-car term))
             (term-ground? (comp-cdr term))
             #f))
        (else  ; term is a constant
         #t)))


;;; returns a pair - car indicates how many characters of the string were
;;;                  not followed   
;;;                - cdr is the subtree
;;;
;;; eg. (term-follow-path '(?a (?b ?c)) "ad")     => (0 ?b ?c)
;;;     (term-follow-path '(?a (?b ?c)) "ddaaad") => (3 . ?b)
;;;  
(define (term-follow-path term str)
  (define (term-follow-path-aux term i)
;    (display "term-follow-path-aux ") (display term) (display " ") (display i) (newline)
    (if (term-var? term)
        (if (var-inst? term)
            (term-follow-path-aux (var-val term) i)  ; dereference
            (cons (1+ i) term))
        (if (negative? i)
            (cons (1+ i) term)
            (if (term-comp? term)
                (term-follow-path-aux
                 (if (char=? (string-ref str i) '#\a) (car term) (cdr term))
                 (1- i))
                (cons (1+ i) term)))))
  (term-follow-path-aux term (1- (string-length str))))

;;; returns a path (represented by a string of a's and d's) to const in term 
;;; returns false if there is no such path
;;;
;;; eg   (term-find-path '?x '(append ?x ?y ?z)) => "ad"
(define (term-find-path const term)
  (define (term-find-path-aux term char-list)
    (if (term-const? term)
        (if (const=? const term)
            (list->string char-list)
            #f)
        (let ((res (term-find-path-aux
                    (comp-car term) (cons #\a char-list))))
          (if res
              res
              (term-find-path-aux (comp-cdr term) (cons #\d char-list))))))
  (term-find-path-aux term '()))  

;;; treat ALL variables as capable of multiple instantiations;
;;; therefore, instantiated vars are "equivalent" to ordinary vars.
;;; returns the set of the variables in term (no duplicates).
;;; should be rewritten to using ordered variable lists for efficiency.
(define (term-list-deref term)
	(define (collect term vars)
		(cond	((term-const? term)
				vars)
			((term-var? term)
				(if	(or	(not (var-inst? term))
						(term-shallow-ground? term))
					(if (memq term vars) vars
						(cons term vars))
					(collect (var-val term) vars)))
			((term-comp? term)
				(collect (comp-car term)
					(collect (comp-cdr term) vars)))
			(else	(error 'collect "illegal term ~s" term))))
	(collect term '()))

(define (term-recursive-const? term)
	(cond	((term-const? term)
			'#t)
		((term-comp? term)
			(and	(term-recursive-const? (comp-car term))
				(term-recursive-const? (comp-cdr term))))
		(else	'#f)))

(define (term-shallow-ground? term)
	(cond	((term-const? term)
			'#t)
		((term-var? term)
			(if	(var-inst? term)
				(term-recursive-const? (var-val term))
				'#f))
		((term-comp? term)
			(and	(term-shallow-ground? (comp-car term))
				(term-shallow-ground? (comp-cdr term))))
		(else	(error 'term-shallow-ground? "illegal term ~s" term))))

;;; returns the functor of term
;;; e.g. (TERM-FUNCTOR '(PLUS ?X ?Y ?Z)) => PLUS
;;;      (TERM-FUNCTOR '(P)) => P
;;;      (TERM-FUNCTOR 'X) => X
;;;      (TERM-FUNCTOR 1) => error
;;;      (TERM-FUNCTOR '?X) => !@$%^&*
(define (term-functor term)
  (cond ((term-var? term) '!@$%^&*)
        ((term-const? term) (const-functor term))
        ((term-comp? term) (comp-functor term))))

;;; returns the arity of term
;;; egs. (TERM-ARITY '(PLUS ?X ?Y ?Z)) => 3
;;;      (TERM-ARITY '(P)) => 0
;;;      (TERM-ARITY 'X) => 0
;;;      (TERM-ARITY 1) => error
;;;      (TERM-ARITY '?X) => error
(define (term-arity term)
  (cond ((term-var? term) 0)
        ((term-const? term) (const-arity term))
        ((term-comp? term) (comp-arity term))))

;;; returns a symbol which is of the form functor/arity
;;; egs. (TERM->FUNCTOR/ARITY '(PLUS ?X ?Y ?Z)) => PLUS/3
;;;      (TERM->FUNCTOR/ARITY '(P)) => P/0
;;;      (TERM->FUNCTOR/ARITY 'X) => X/0
;;;      (TERM->FUNCTOR/ARITY 1) => undefined
;;;      (TERM->FUNCTOR/ARITY '?X) => !@$%^&*/0
(define (term->functor/arity term)
  (string->symbol
   (string-append
    (symbol->string 
     (term-functor term)) "/" (number->string (term-arity term)))))

;;; returns term converted to a string
;;;  eg (term->string '(f ?x 1 ?y)) => "(F ?X 1 ?Y)"
;;; This won't work in most schemes, should be rewritten!
(define (term->string term) (format '() "~o" term))

;;; returns DEEPEST referred VARIABLES in term.
;;; dereferences term.
(define (term-deref term)
	(if	(and (term-var? term) (var-inst? term))
		(let	((val (var-val term)))
			(if	(term-var? val)
				(term-deref val)
				term))
		term))				;;; for composites and constants

;;; instantiates term by dereferencing all variables
;;; Note: this used to be called de-prolog
(define (term-instantiate term)
  (cond ((term-const? term) term)
        ((term-var? term)
         (if (var-inst? term)
             (term-instantiate (var-val term))
             (var-name term)))
        ((term-comp? term)
         (comp-cons (term-instantiate (comp-car term))
                    (term-instantiate (comp-cdr term))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Variable term stuff, call only with terms for which term-var? is true
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; constructor: renames name so it provides a unique key for the variable
;;;              so variables can be ordered
(define make-var 
  (let ((n 0))
    (lambda (name)
      (set! n (1+ n))
      (vector
       'uninst
       (string->symbol
        (string-append (symbol->string name) "#" (number->string n)))
       'no-val
       (make-dlist)))))

;;; accessors
(define (var-state var)
  (vector-ref var 0))

(define (var-name var)
  (vector-ref var 1))

;;; call only if var is instantiated!
(define (var-val var)
  (vector-ref var 2))

;;;
(define (var-constraints var)
  (vector-ref var 3))

(define (var-add-constraint! goal var where)
	(if	debug?
		(begin	(display "var-add-constraint! var: ")
			(display (var-name var))
			(display " goal")
			(display (goal-id goal))
			(display ": ")
			(display (term-instantiate (goal-term goal)))
			(display " existing constraints: ")
			(display (map (lambda (g) (goal-id g))
					(dlist->list (var-constraints var))))
			(newline)))
	(var-del-constraint! goal var)
	(case	where
		((FRONT ANY)
			(dlist-insert-front! goal (var-constraints var)))
		((REAR)	(dlist-insert-back! goal (var-constraints var)))
		(else	(error 'var-add-constraint! "illegal position"))))

(define (var-del-constraint! goal var)
  (if debug?
      (begin
	(display "var-del-constraint! var: ")
	(display (var-name var))
	(display " goal")
	(display (goal-id goal))
	(display ": ")
	(display (term-instantiate (goal-term goal)))
	(display " old constraints: ")
	(display (map (lambda (g) (goal-id g))
			(dlist->list (var-constraints var))))
	(newline)))
  (dlist-delete! goal (var-constraints var))
)

;;; true iff var is instantiated
(define (var-inst? var)
  (eq? (vector-ref var 0) 'inst))

;;; instantiates var to TERM itself!! and then tries to wake all goals delayed
;;; on var
(define (var-instantiate! var term program s f)
	(let	((prev-inst? (var-inst? var))
		(prev-val (var-val var)))	;;; abuse of (var-val ...)
		(var-inst! var term)
		(var-wake-constraints
			var
			program
			s
			(if	prev-inst?
				(lambda ()
					(var-inst! var prev-val)
					(f))
				(lambda ()
					(var-uninst! var)
					(f))))))

;;; instantiates var to val
(define (var-inst! var val)
  (if debug?
      (begin
       (display "var-inst! var: ")
       (display (var-name var))
       (display " val: ")
       (display (term-instantiate val))
       (newline)))
  (vector-set! var 0 'inst)
  (vector-set! var 2 val))

;;; uninstantiates var
(define (var-uninst! var)
  (if debug?
      (begin
       (display "var-uninst! var: ")
       (display (var-name var))
       (newline)))
  (vector-set! var 0 'uninst))

;;; try to wake all constraints delayed on variable
(define (var-wake-constraints var program s f)
  (define (wake-constraints goals s f)
    (if (null? goals)
	(begin
	 (user-debug (list "woke" (var-name var) (term-instantiate var)))
	 (s f))
        (goal-wake-try!
         (car goals)
         var
         (lambda (f)  ; run continuation
           (awaken-goal!
            (car goals)
            program
            (lambda (f)
              (wake-constraints (cdr goals) s f))
            f))
         (lambda (f) ; delay continuation
           (wake-constraints (cdr goals) s f))
         f)))

  (user-debug (list "wake-constraints" (var-name var) (term-instantiate var)))
  (map (lambda (g) (user-debug (list (goal-id g)
				     (term-instantiate (goal-term g)))))
	(dlist->list (var-constraints var)))
  (wake-constraints (dlist->list (var-constraints var)) s f))

;;; true iff vars are equal. Note that checking for "eq?"litiy is
;;;                          equivalent to checking for equality of name
;;;                          (but probably faster)
(define var=? eq?)

;;; true iff var1 is before var2 in variable ordering
(define (var<? var1 var2)
  (string<? (symbol->string (vector-ref var1 1))
            (symbol->string (vector-ref var2 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Constant term stuff, call only with terms for which term-const? is true
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; return true iff const1 and const2 are equal
(define (const=? const1 const2)
  (if (eqv? const1 const2)        ; symbols, numbers, characters, boolean, ()
      #t
      (if (and (string? const1) (string? const2))  ; strings
          (string=? const1 const2)  
          #f)))

;;; returns a symbol which is the functor of const
(define (const-functor const)
  (if (symbol? const)
      const
      (error 'const-functor "non-symbol argument ~s" const)))

;;; returns a number which is the arity of const
(define (const-arity const)
  (if (symbol? const)
      0
      (error 'const-arity "non-symbol argument ~s" const)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Composite term stuff -- they're just pairs
;;;           call only with terms for which term-comp? is true
;;;           Note: some of these functions assume the their arguments
;;;                 are proper lists, beware!
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; constructor for composite terms
(define comp-cons cons)

;;; accessors for composite terms (add as many as you like!)
(define comp-car car)
(define comp-cdr cdr)
(define comp-cadr cadr)
(define comp-caddr caddr)
(define comp-cadddr cadddr)
(define (comp-caddddr L) (cadr (cdddr L)))
(define (comp-cadddddr L) (caddr (cdddr L)))
(define comp-map map)
(define comp-ref list-ref)

(define (proper-list? l)
	(if	(null? l)
		'#t			;;; or #f ??##
		(and (pair? l) (null? (cdr (last-pair l))))))

;;; proper comp, makes sense to take length of these
(define comp-proper? proper-list?)


;;; length of composite term, should only be called for proper comps
(define comp-length length)

;;; returns a symbol which is the functor of comp
(define comp-functor comp-car)

;;; returns a number which is the arity of comp
(define (comp-arity comp)
  (if (comp-proper? comp)
      (comp-length (comp-cdr comp))
      -1))

;;; treats arithmetic variables as capable of multiple instantiations;
;;; therefore, instantiated vars are "equivalent" to ordinary vars.
;;; returns the set of the variables in term (no duplicates).
;;; should be rewritten to using ordered variable lists for efficiency
(define (term-var-set term)
  (define (collect-vars term vars)
    (cond ((term-var? term)
           (if (var-inst? term)
		(if	(arith-interval? (var-val term))
			(if (memq term vars) vars (cons term vars))
						;;; arith vars are eternally
						;;; vars!
						;;; the DEEPEST referred VARS
						;;; are being returned
			(collect-vars (var-val term) vars))
						;;; dereference
               (if (memq term vars) vars (cons term vars))))
          ((term-const? term) vars)
          ((term-comp? term)
           (collect-vars (comp-cdr term)
                         (collect-vars (comp-car term) vars)))))
  (collect-vars term '()))

