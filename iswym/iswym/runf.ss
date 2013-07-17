;runf.ss
;Iswym in Scheme
;(c) Dorai Sitaram, Dec. 1992, Rice University
;Previous versions: Apr. 1991, Jan. 1992

(module iswym:)

(extern () run % fcontrol)

(define call/cc call-with-current-continuation)
(define run-stack '())
(define fcontrol-message "fcontrol-message")

(define system-run
  (lambda (th hdlr)
    (let* ((p 'void)
	   (v (call/cc
		(lambda (k)
		  (set! p k)
		  (set! run-stack
		    (cons (cons p '()) run-stack))
		    (th)))))
      (record-evcase v
	(fcontrol-message (fctl-rcr fun-cont)
	  (set! run-stack (cdr run-stack))
	  (hdlr fctl-rcr fun-cont))
	(else (let* ((frame2 (car run-stack))
	 	     (p2 (car frame2))
		     (substack2 (cdr frame2)))
		(cond ((not (eq? p p2))
		       (p2 v))
		      ((not (null? substack2))
		       (set-cdr! frame2 (cdr substack2))
		       ((car substack2) v))
		      (else (set! run-stack (cdr run-stack))
			v))))))))

(define system-fcontrol
  (lambda (r)
    (call/cc
      (lambda (fctl-cont)
	(if (null? run-stack) (lerror 'no-surrounding-run))
	(let* ((fctl-frame (car run-stack))
	       (fctl-p (car fctl-frame))
	       (fctl-substack (cdr fctl-frame)))
	   (set-cdr! fctl-frame '())
	   (fctl-p
	     (list fcontrol-message r
	       (lambda (v)
		 (call/cc
		   (lambda (invoke-cont)
		     (if (null? run-stack) (lerror 'no-surrounding-run))
		     (let* ((invoke-frame (car run-stack))
			    (invoke-substack (cdr invoke-frame)))
		        (set-cdr! invoke-frame
			  (append fctl-substack
			    (cons invoke-cont invoke-substack)))
			(fctl-cont v))))))))))))

(define flush-run-stack
  (lambda ()
    (set! run-stack '())))

(define identity (lambda (x) x))
(define compose (lambda (f g) (lambda (x) (f (g x)))))

(define run-tagged
  (lambda (tag th h)
    (system-run th
      (lambda (r k)
        (let ((tag2 (car r))
              (r2 (cadr r))
              (k2 (compose k (caddr r))))
           (if (eqv? tag2 tag) (h r2 k2)
               (system-fcontrol (list tag2 r2 k2))))))))

(define fcontrol-tagged
  (lambda (tag r)
    (system-fcontrol (list tag r identity))))

(define-macro! % (arg1 arg2 . rest)
  (if (null? rest)
      `(% #f ,arg1 ,arg2)
      `(run-tagged ,arg1 (lambda () ,arg2) ,(car rest))))

(define run 
  (lambda (x y . z)
    (if (null? z) (run-tagged #f x y)
        (run-tagged x y (car z)))))

(define fcontrol
  (lambda (x . z)
    (if (null? z) (fcontrol-tagged #f x)
        (fcontrol-tagged x (car z)))))
