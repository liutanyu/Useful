;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Clause declarations: implemented as lists of the form (type . clause)
;;;                      where type is one of 'when, 'what or 'how, and
;;;                      clause is an appropriate structure.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; returns type - one of what, when
(define clause-dec-type car)

(define clause-dec-clause cdr)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Programs: tables of predicates 
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (make-program) (make-table (make-assoc '!@$%^&* (make-pred))))

(define (clause-insert! clause-dec program)
  (let* ((type (clause-dec-type clause-dec))
         (clause (clause-dec-clause clause-dec))
         (functor/arity
          (term->functor/arity (clause-head clause)))
         (assoc (table-lookup functor/arity program))
         (pred (if assoc 
                   (assoc-value assoc)
                   (begin
                    (table-insert!
                     (make-assoc functor/arity (make-pred)) program)
                    (assoc-value (table-lookup functor/arity program))))))
    (case type
      ((when) (dlist-insert-back! clause (pred-when pred)))
      ((what) (dlist-insert-back! clause (pred-what pred)))
      ((how)  (dlist-insert-back! clause (pred-how pred)))
      (else (error 'clause "file ~s: clause ~s" file clause)))))
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Program-load: loads a prolog file
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (program-load file-name-list)
	(let	((program (make-program)))
		(for-each (lambda (file-name)
			(let	((file (open-input-file file-name)))
				(define (load-program!)
					(let	((clause-dec (read file)))
						(if	(eof-object? clause-dec)
							#t
							(begin
								(clause-insert!
								     clause-dec
									program)
							(load-program!)))))
				(load-program!)))
			file-name-list)
		program))


;;; load a program from files named in file-name-list and solve queries about it
(define (prolog . file-name-list)
	(let	((program (program-load file-name-list)))
		(compile-program! program)
		(newline)
		(display "Prolog 1.2 with ")
		(if intervals? (display "Logical Arithmetic and "))
		(display "Delays")
		(newline)
		(solve-queries program)))

(define (prompt) (display "?- ") (read))


(define (read-non-newline-char)
  (let ((ch (read-char)))
    (if (eq? ch #\newline)
	(read-non-newline-char)
	ch))
)

(define want-all-solutions? #f)

(define (want-more-solutions?)
  (if want-all-solutions?
      #t
      (begin
	(display "More? ") (flush-output-port)
	(let ((ch (read-non-newline-char)))
	  (cond ((eof-object? ch) #f)
		((eq? ch #\;) #t)
		((eq? ch #\.) #f)
		((eq? ch #\,) (set! want-all-solutions? #t) #t)
		(else
		 (display "Type one of the following:") (newline)
		 (display "  ;   display next solution") (newline)
		 (display "  ,   display all remaining solutions") (newline)
		 (display "  .   skip remaining solutions") (newline)
		 (want-more-solutions?))))
      )
  )
)

(define (solve-queries program)
	(let*	((in (prompt))
		 (query (if (or (eof-object? in) (eq? in 'q))
			    'q
			    ((compile-what-clause in)))))
		(if	(eq? query 'q)
			'bye
			(let	((t (cpu-time)))
				(set! want-all-solutions? #f)
				(unschedule-all!)
				(unflounder-all!)
				(if intervals? (init-arith-goal-lists!))
				(and-node query program
					(lambda (f)
						(display "Solution: ")
						(display
							(term-instantiate query))
						(newline)
						(display "Floundered goals:")
						(newline)
						(for-each (lambda (g)
							(display "  ")
							(display
							 (term-instantiate
							  (goal-term g)))
							(newline))
						     (dlist->list
							FLOUNDERED-GOALS))
						(if intervals?
							(display-goal-lists))
						(if (want-more-solutions?)
						    (f)))
					(lambda ()
						(display "no more solutions")
						(newline)))
				(let ((t2 (cpu-time)))
				  (if (< t t2)
				      (display (list "time in seconds: "
						     (/ (- t2 t) 1000.0)))))
				(newline)
				(solve-queries program)))))

