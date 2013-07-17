;prod0.ss
;Iswym in Scheme
;(c) Dorai Sitaram, Dec. 1992, Rice U.
;Previous versions: Apr. 1991, Jan. 1992

;Find the product of a list of numbers -- return 0
;immediately on hitting a 0.

;This file should be loaded in Iswym

(define prod0
  (lambda (s)
    (% (let loop ((s s))
	 (if (null? s) 1
	     (let ((a (car s)))
	       (if (= a 0) (fcontrol 0)
		   (* a (loop (cdr s)))))))
       (lambda (r k) r))))
