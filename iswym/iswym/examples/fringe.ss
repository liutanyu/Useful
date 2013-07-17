;fringe.ss
;Iswym in Scheme
;(c) Dorai Sitaram, Dec. 1992, Rice U.
;Previous versions: Apr. 1991, Jan. 1992

;Tree-matching using run and fcontrol

;This file should be loaded in Iswym

;(same-fringe? tree1 tree2) tests if tree1 and tree2
;have the same fringe

(define make-fringe
  (lambda (tree)
    (lambda (dummy)
      (let loop ((tree tree))
	(cond ((pair? tree) (loop (car tree)) (loop (cdr tree)))
	      ((null? tree) 'skip)
	      (else (fcontrol tree))))
      (fcontrol '()))))

(define same-fringe?
  (lambda (t1 t2)
    (let loop ((f1 (make-fringe t1)) (f2 (make-fringe t2)))
      (% (f1 0)
	(lambda (r1 k1)
	  (% (f2 0)
	    (lambda (r2 k2)
	      (echo #f r1 " " r2 eoln)
	      (if (eqv? r1 r2)
	      	  (if (null? r1) #t
	      	      (loop k1 k2))
	      	  #f))))))))
