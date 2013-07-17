;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Prolog:  top-level file, which loads the rest of the system.
;;;          Interval arithmetic can be disabled.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The following three definitions specify the locations of the various
;; parts of the Prolog interpreter, and are prepended to the names of
;; system files loaded:
;;	prolog-source-prefix	the Prolog interpreter (*.ss)
;;	interval-source-prefix	interval arithmetic (*.ss)
;;	builtin-pred-prefix	built-in predicates (*.pro)

(define prolog-source-prefix "/home/srdg/dewar/prolog/scheme/R1.2/")

(define interval-source-prefix
	(string-append prolog-source-prefix "Interval/"))

(define builtin-pred-prefix prolog-source-prefix)

(define debug? #f)
(define user-debug? #f)
(define (user-debug arg)
	(if	user-debug?
		(begin	(display arg)
			(newline))))

(define (load-prolog filename)
	(load (string-append prolog-source-prefix filename)))

(load-prolog "compatibility.ss")
(load-prolog "tables.ss")
(load-prolog "clauses.ss")
(load-prolog "predicates.ss")
(load-prolog "goals.ss")
(load-prolog "dlists.ss")
(load-prolog "programs.ss")
(load-prolog "compile.ss")
(load-prolog "terms.ss")
(load-prolog "search.ss")
(load-prolog "schedule.ss")
(load-prolog "flounder.ss")

;; To disable interval arithmetic, set intervals? to #f and comment out
;; the load line for interval.ss.
(define intervals? #t)
(load-prolog "interval.ss")

(define (pro . file-name-list)
    (begin
      (newline)
      (display "A Prolog goal is an unquoted LIST of predicate calls.")
      (newline)
      (display "To toggle predicate tracing, type as a Prolog goal: ((debug))")
      (newline)
      (if intervals?
	  (eval (append
		    (list 'prolog
			  (string-append builtin-pred-prefix "builtin.pro")
			  (string-append builtin-pred-prefix "interval.pro"))
		    file-name-list))
	  (eval (append
		    (list 'prolog
			  (string-append builtin-pred-prefix "builtin.pro"))
		    file-name-list))
      )
    )
)

(define (greetings)
  (display "To start the Prolog interpreter, type:  (pro <file-names>...)")
  (newline)
)

(greetings)
