;proplist.scm
;dorai@cs.rice.edu

;property lists

(define *properties* '())

(define get
  (lambda (x p . default)
    (let ((default (if (pair? default) (car default) #f))
	  (c (memq x *properties*)))
      (if (not c) default
	(let ((d (memq p (cadr c))))
	  (if (not d) default
	    (cadr d)))))))

(define put
  (lambda (x p v)
    (let ((c (memq x *properties*)))
      (if (not c)
	  (set! *properties*
	    (cons x (cons (list p v) *properties*)))
	  (let* ((cdr-c (cdr c))
		 (cadr-c (car cdr-c))
		 (d (memq p cadr-c)))
	    (if (not d)
		(set-car! cdr-c (cons p (cons v cadr-c)))
		(set-car! (cdr d) v)))))))
