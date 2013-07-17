;prefixes.ss
;Iswym in Scheme
;(c) Dorai Sitaram, Dec. 1992, Rice U.
;Previous versions: Apr. 1991, Jan. 1992

;Find all the prefixes of a list.

;This file should be loaded in Iswym.

(define all-prefixes
  (lambda (l)
    (letrec ((loop (lambda (l)
		     (if (null? l) (fcontrol 'done)
		       (cons (car l)
			 (fcontrol (cdr l)))))))
      (% (loop l)
	(rec h
	  (lambda (r k)
	    (if (eq? r 'done) '()
	      (cons (k '())
		(% (k (loop r)) h)))))))))
