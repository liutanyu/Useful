;corou.ss
;Iswym in Scheme
;(c) Dorai Sitaram, Dec. 1992, Rice U.
;Previous versions: Apr. 1991, Jan. 1992

;Coroutines using run and fcontrol

;This file should be loaded in Iswym

(define-macro! coroutine (x . body)
  `(letrec ((local-control-state
	      (lambda (,x) ,@body))
	    (resume
	      (lambda (c v)
		(fcontrol 'coroutine (lambda () (c v)))))
	    (detach
	      (lambda (v)
		(fcontrol 'coroutine (lambda () v)))))
     (lambda (v)
       (% 'coroutine
	  (local-control-state v)
	  (lambda (r k)
	    (set! local-control-state k)
	    (r))))))
