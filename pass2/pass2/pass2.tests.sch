; Test data.

; MAKE-READABLE strips the referencing information
; and replaces (begin I) by I.

(define (make-readable exp)
  (case (car exp)
    ((quote)    exp)
    ((lambda)   `(lambda ,(lambda.args exp)
                         ,@(map (lambda (def)
                                  `(define ,(def.lhs def)
                                           ,(make-readable (def.rhs def))))
                                (lambda.defs exp))
                           ,(make-readable (lambda.body exp))))
    ((set!)     `(set! ,(assignment.lhs exp)
                       ,(make-readable (assignment.rhs exp))))
    ((if)       `(if ,(make-readable (if.test exp))
                     ,(make-readable (if.then exp))
                     ,(make-readable (if.else exp))))
    ((begin)    (if (variable? exp)
                    (variable.name exp)
                    `(begin ,@(map make-readable (begin.exprs exp)))))
    (else       `(,(make-readable (call.proc exp))
                  ,@(map make-readable (call.args exp))))))

; MAKE-UNREADABLE does the reverse.
; It assumes there are no internal definitions.

(define (make-unreadable exp)
  (cond ((symbol? exp) (list 'begin exp))
        ((pair? exp)
         (case (car exp)
           ((quote) exp)
           ((lambda) (list 'lambda
                           (cadr exp)
                           '(begin)
                           '(() ())
                           (make-unreadable (cons 'begin (cddr exp)))))
           ((set!) (list 'set! (cadr exp) (make-unreadable (caddr exp))))
           ((if) (list 'if
                       (make-unreadable (cadr exp))
                       (make-unreadable (caddr exp))
                       (if (= (length exp) 3)
                           (list 'quote #!unspecified)
                           (make-unreadable (cadddr exp)))))
           ((begin) (if (= (length exp) 2)
                        (make-unreadable (cadr exp))
                        (cons 'begin (map make-unreadable (cdr exp)))))
           (else (map make-unreadable exp))))
        (else (list 'quote exp))))

; ANNOTATE takes an expression in the format accepted by pass 2
; and returns a copy of the expression with freshly computed
; referencing and free variable information.

(define (annotate exp)
  
  ; (f x e np) returns a copy of the expression x, using the environment e
  ; to accumulate referencing information and the notepad np to accumulate
  ; free variable information.
  ;
  ; The environment e has the form
  ;     ((<identifier> <references> <assignments> <calls>) ...)
  ; so the operations on R-tables can be used on environments.
  
  (define (f x e np)
    (case (car x)
      ((quote)   (list 'quote (cadr x)))
      ((begin)   (if (variable? x)
                     (let* ((name (variable.name x))
                            (var (make-variable name))
                            (entry (R-entry e name)))
                       (notepad-var-add! np name)
                       (if entry
                           (R-entry.references-set!
                            entry
                            (cons var (R-entry.references entry))))
                       var)
                     (cons 'begin
                           (map (lambda (x) (f x e np))
                                (begin.exprs x)))))
      ((lambda)  (let* ((entries
                         (map (lambda (name) (make-R-entry name '() '() '()))
                              (append (map def.lhs (lambda.defs x))
                                      (make-null-terminated
                                       (lambda.args x)))))
                        (e2 (append entries e))
                        (newnotepad (make-notepad x))
                        (newdefs (map (lambda (def)
                                        (list 'define
                                              (def.lhs def)
                                              (f (def.rhs def) e2 newnotepad)))
                                      (lambda.defs x)))
                        (y (f (lambda.body x) e2 newnotepad)))
                   (list 'lambda
                         (copy (lambda.args x))
                         (cons 'begin newdefs)
                         (list 'quote
                               (list entries
                                     (union (notepad.vars newnotepad)
                                            (apply union
                                                   (map (lambda (formals free)
                                                          (difference free formals))
                                                        (map make-null-terminated
                                                             (map lambda.args
                                                                  (map def.rhs newdefs)))
                                                        (map lambda.F
                                                             (map def.rhs newdefs)))))))
                         y)))
      ((set!)    (let ((y (list 'set!
                                (assignment.lhs x)
                                (f (assignment.rhs x) e np)))
                       (entry (R-entry e (assignment.lhs x))))
                   (if entry
                       (R-entry.assignments-set! entry
                                                 (cons y (R-entry.assignments entry))))
                   y))
      ((if)      (list 'if
                       (f (if.test x) e np)
                       (f (if.then x) e np)
                       (f (if.else x) e np)))
      (else      (let ((proc (f (call.proc x) e np))
                       (args (map (lambda (y) (f y e np)) (call.args x))))
                   (let ((y (make-call proc args)))
                     (if (variable? proc)
                         (let ((entry (R-entry e (variable.name proc))))
                           (if entry
                               (R-entry.calls-set! entry
                                                   (cons y (R-entry.calls entry))))))
                     y)))))
  (f exp '() (make-notepad #f)))

; Copies a list structure, preserving sharing relationships.

(define (copy x)
  (define (copy x e k)
    (cond ((not (pair? x))
           (k x e))
          ((assq x e)
           (k (cdr (assq x e)) e))
          (else (let* ((p (cons '* '*))
                       (e2 (cons (cons x p) e)))
                  (copy (car x)
                        e2
                        (lambda (y e3)
                          (set-car! p y)
                          (copy (cdr x)
                                e3
                                (lambda (y e4)
                                  (set-cdr! p y)
                                  (k p e4)))))))))
  (copy x '() (lambda (x e) x)))

(define (f x)
  (pretty-print (make-readable x))
  (let ((y (pass2 x)))
    (pretty-print (make-readable y))
    (pretty-print y)))

; (define (loop n)
;   (if (zero? n)
;       'done
;       (loop (- n 2))))

(define (test0)
  (f (annotate
      (make-unreadable
       '(set! loop
              (lambda (z)
                ((lambda (loop)
                   (begin
                    (set! loop
                          (lambda (n)
                            (if (zero? n) 'done (loop (- n 1)))))
                    ((lambda () (loop z)))))
                 #!unspecified)))))))

; (define (loop n)
;   (set! n (+ n 1))
;   (if (zero? n)
;       'done
;       (loop (- n 2))))

(define (test1)
  (f (annotate
      (make-unreadable
       '(set! loop
              (lambda (z)
                ((lambda (loop)
                   (begin
                    (set! loop
                          (lambda (n)
                            (begin (set! n (1+ n))
                                   (if (zero? n) 'done (loop (- n 2))))))
                    ((lambda () (loop z)))))
                 #!unspecified)))))))

; (define (reverse x)
;   (define (loop x y)
;     (if (null? x)
;         y
;         (loop (cdr x) (cons (car x) y))))
;   (loop x '()))

(define (test2)
  (f (annotate
      (make-unreadable
       '(set! rev
              (lambda (z)
                ((lambda (reverse)
                   (begin
                    (set! reverse
                          (lambda (w)
                            ((lambda (loop)
                               (begin
                                (set! loop
                                      (lambda (x y)
                                        (if (null? x)
                                            y
                                            (loop (cdr x)
                                                  (cons (car x) y)))))
                                ((lambda ()
                                   (loop w '())))))
                             #!unspecified)))
                    ((lambda ()
                       (reverse z)))))
                 #!unspecified)))))))

(define (test3) #t)

; (define (length x)
;   (do ((x x (cdr x))
;        (n 0 (+ n 1)))
;       ((null? x) n)))

(define (test4)
  (f (annotate
      (make-unreadable
       '(set! len
              (lambda (z)
                ((lambda (length)
                   (begin
                    (set! length
                          (lambda (w)
                            ((lambda (DO18)
                               (begin
                                (set! DO18
                                      (lambda (x n)
                                        (if (null? x)
                                            n
                                            (DO18 (cdr x) (1+ n)))))
                                ((lambda ()
                                   (DO18 w 0)))))
                             #!unspecified)))
                    ((lambda ()
                       (length z)))))
                 #!unspecified)))))))

; (define (ip v1 v2)
;   (define (loop i sum)
;     (if (negative? i)
;         sum
;         (loop (- i 1)
;               (+ sum (* (vector-ref v1 i)
;                         (vector-ref v2 i))))))
;   (define n (vector-length v1))
;   (if (= n (vector-length v2))
;       (loop (- n 1) 0)
;       (error ...)))

(define (test5)
  (f (annotate
      (make-unreadable
       '(set! ip
              (lambda (z1 z2)
                ((lambda (ip)
                   (begin
                    (set! ip
                          (lambda (v1 v2)
                            ((lambda (loop n)
                               (begin
                                (set! loop
                                      (lambda (i sum)
                                        (if (> 0 i)
                                            sum
                                            (loop (- i 1)
                                                  (+ sum
                                                     (* (vector-ref v1 i)
                                                        (vector-ref v2
                                                                    i)))))))
                                (set! n (vector-length v1))
                                ((lambda ()
                                   (if (= n (vector-length v2))
                                       (loop (- n 1) 0)
                                       (error ...))))))
                             #!unspecified
                             #!unspecified)))
                    ((lambda ()
                       (ip z1 z2)))))
                 #!unspecified)))))))
