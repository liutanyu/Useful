;iswymrep.ss
;Iswym in Scheme
;(c) Dorai Sitaram, Dec. 1992, Rice University
;Previous versions: Apr. 1991, Jan. 1992

;following procs are necessary since the eval of
;an iswym-repl wraps its argument in a lambda, thereby 
;corrupting defines

(module iswym:)
(extern () iswym-repl)

(define append-map!
  (lambda (f s)
    (if (null? s) '()
        (append! (f (car s)) 
          (append-map! f (cdr s))))))

(define find-top-level-defines
  (lambda (e)
    (if (not (pair? e)) '()
        (let ((a (car e)))
          (cond ((eq? a 'define) (list (cadr e)))
          	((memq a '(if begin))
          	 (append-map! find-top-level-defines (cdr e)))
          	(else '()))))))

(define convert-top-level-defines
  (lambda (e)
    (if (not (pair? e)) e
        (let ((a (car e)))
          (cond ((eq? a 'define) `(set! ,@(cdr e)))
          	((memq a '(if begin))
          	 `(,a ,@(map convert-top-level-defines (cdr e))))
          	(else e))))))

(define expand
  (lambda (e)
    (let ((defines (find-top-level-defines e)))
       (if defines
           `(begin ,@(map (lambda (x) 
           		    `(if (not (defined? ,x)) (define ,x 'void)))
			  defines)
             	 (% ,(convert-top-level-defines e)
             	    (lambda (r k)
             	      (lerror "uncaught fcontrol"))))
             `(% ,e (lambda (r k)
              	       (lerror "uncaught fcontrol")))))))

(define iswym-repl
  (lambda ()
    (flush-run-stack)
    (let loop ()
      (echo #f "% ")
      (write (eval (expand (read))))
      (newline)
      (loop))))


