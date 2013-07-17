;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Compile
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (program-var? term) ;was syntactic-var
  (if (symbol? term)
      (eq? #\? (string-ref (symbol->string term) 0))
      #f))

;;; assumes term-find-path never returns #f (ie variables in the body of the
;;;    clause always appear in the head)                               
(define (compile-when-clause clause)
  (cons
   'and 
   (map
    (lambda (body-term)
      (let ((function
             (case
                (car body-term)
                 ((nonvar) 'term-not-var?)
                 ((ground) 'term-ground?)
                (else 
                 (error 'when-clause "invalid constraint ~s" clause))))
	    (path (term-find-path (cadr body-term) (clause-head clause))))
        `(let ((rest-length/end
               (term-follow-path 
                goal-term
                ,path)))
          (if (zero? (car rest-length/end))
              (,function (cdr rest-length/end))
              #f))))
    (clause-body clause))))

;;; returns a procedure which takes a goal as an argument. The returned
;;; procedure returns true iff the goal is ready to run

(define (compile-when when-clause-list)
  (eval
   `(lambda (goal)
            (let ((goal-term (goal-term goal)))
            ,(cons 'or
                   (map compile-when-clause
                        when-clause-list))))))

(define (compile-what-clause clause)
  
  (define (make-vars/body-program term)
    ;;; sample call:
    ;;;   (make-vars/body-program 
    ;;;       '((append (?H . ?T) ?L (?H . ?NT)) (append ?T ?L ?NT)))
    ;;; =>
    ;;;   ((?H ?T ?L ?NT) .
    ;;;    (comp-cons
    ;;;     (comp-cons 'append
    ;;;        (comp-cons
    ;;;           (comp-cons ?H ?T)
    ;;;           (comp-cons ?L (comp-cons (comp-cons ?H ?NT) '()))))
    ;;;     (comp-cons
    ;;;        (comp-cons 'append
    ;;;           (comp-cons ?T (comp-cons ?L (comp-cons ?NT '()))))
    ;;;        '())))
    
    (define (vars-union vars1 vars2)   ; similar to no-dups
      (cond ((null? vars1) vars2)
            ((member (car vars1) vars2)
             (vars-union (cdr vars1) vars2))
            (else
             (cons (car vars1) (vars-union (cdr vars1) vars2)))))
    (cond ((program-var? term) (cons (list term) term))
          ((term-const? term) (cons '() `',term))
          ((term-comp? term)
           (let ((vars/body-program1
                  (make-vars/body-program (comp-car term)))
                 (vars/body-program2
                  (make-vars/body-program (comp-cdr term))))
             (cons
              (vars-union (car vars/body-program1)
                          (car vars/body-program2))
              `(comp-cons ,(cdr vars/body-program1)
                          ,(cdr vars/body-program2)))))))
  (define (make-bindings-program vars)
    (map (lambda (var) `(,var (make-var ',var))) vars))
  (let ((vars/body-program (make-vars/body-program clause)))
    (eval
     `(lambda ()
              (let ,(make-bindings-program (car vars/body-program))
                ,(cdr vars/body-program))))))

;;; 
(define (compile-what what-clause-list)
  (map compile-what-clause
       what-clause-list))

;;; assume a how clause list has only one element, which is a "clause" whose
;;; only "goal" in the body is a program which defines a procedure capable of
;;; solving an and-branch
(define (compile-how how-clause-list)
	(if	(null? how-clause-list)
		'()
		(eval (comp-car (clause-body (car how-clause-list))))))

(define (compile-program! program)
	(map	(lambda (assoc)
			(let	((pred (assoc-value assoc)))
				(pred-when! pred
					(compile-when
						(dlist->list (pred-when pred))))
				(pred-what! pred
					(compile-what
						(dlist->list (pred-what pred))))
				(pred-how! pred
					(compile-how
						(dlist->list (pred-how pred))))))
		program))

