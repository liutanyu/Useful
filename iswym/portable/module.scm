;module.scm
;Module preprocessor for Scheme
;(c) Dorai Sitaram, dorai@cs.rice.edu, Oct. 1992, Rice U.

(provide 'property-list
  (lambda ()
    (load (string-append (program-vicinity) "proplist.scm"))))

;Define delete-file to be a dummy if not provided.

(define module:delete-file delete-file)
(define module:pretty-print write)

(define module:debug
  (lambda (bool)
    (if bool
	(begin
	  (set! module:delete-file (lambda (f) #f))
	  (provide 'pretty-print
	    (lambda ()
	      (load (string-append (program-vicinity) "pp.scm"))))
	  (set! module:pretty-print pretty-print))
	(begin
	  (set! module:delete-file delete-file)
	  (set! module:pretty-print write)))))

(module:debug 1)

(define module:defmacro-provided? 
  (memq 'defmacro *features*))
;else use r4rs high-level macros while expanding import-syntax

(define module:determine-locals-externs
  (lambda (e m pfx)
    (let loop ((e e))
      (if (pair? e)
	  (let ((a (car e)))
	    (cond ((not (symbol? a)) 'void)
		  ((eq? a 'extern)
		   (for-each (lambda (x) (put m x x))
		     (cdr e)))
		  ((eq? a 'local)
		   (for-each
		     (lambda (x)
		       (if (not (get m x))
			   (put m x
			     (string->symbol
			       (string-append pfx
				 (symbol->string x))))))
		     (cdr e)))
		  ((memq a '(define defmacro
			      define-syntax extend-syntax))
		   (let* ((x (cadr e))
			  (x (if (pair? x) (car x) x)))
		     (if (not (get m x))
			 (put m x
			   (string->symbol
			     (string-append pfx
			       (symbol->string x)))))))
		  ((memq a '(import import-syntax))
		   (let ((to-mdl (cadr e))
			 (xyxy (cdddr e)))
		     (if (or (eq? to-mdl #t) (eq? to-mdl m))
			 (for-each
			   (lambda (xy)
			     (let ((x (if (pair? xy) (car xy) xy)))
			       (put m x
				 (string->symbol
				   (string-append pfx
				     (symbol->string x))))))
			   xyxy))))
		  ((memq a '(begin if))
		   (for-each loop (cdr e)))
		  ((memq a '(let let* letrec rec fluid-let)) 
		   'void)
		  ((eq? a 'cond)
		   (for-each (lambda (clause) (for-each loop clause))
		     (cdr e)))
;		  ((macro? a) (loop (macroexpand-1 e)))
		  (else 'void)))))))

(define module:translate
  (lambda (e m)
    (letrec ((translate-loop
	       (lambda (e)
		 (cond ((pair? e)
			(let ((a (car e)))
			  (if (eq? a 'global$) (cadr e)
			    (cons (translate-loop a) 
			      (translate-loop (cdr e))))))
		       ((symbol? e) (get m e e))
		       (else e)))))
      (cond ((not m) e)
	    ((not (pair? e)) (translate-loop e))
	    (else
	      (let ((a (car e)))
		(cond ((memq a '(module local)) #f)
		      ((memq a '(import import-syntax))
		       (let* ((to-mdl (cadr e))
			      (fm-mdl (caddr e))
			      (to-mdl2
				(cond ((not to-mdl) "")
				      ((or (eq? to-mdl #t)
					 (eq? to-mdl m))
				       (symbol->string m))
				      (else
					(symbol->string to-mdl))))
			      (fm-mdl2
				(cond ((not fm-mdl) "")
				      ((or (eq? fm-mdl #t)
					 (eq? fm-mdl m))
				       (symbol->string m))
				      (else
					(symbol->string fm-mdl)))))
			 (if (eq? a 'import)
			     `(begin
				,@(map (lambda (xy)
					 (let ((x (if (pair? xy) (car xy)
						    xy))
					       (y (if (pair? xy) (cadr xy)
						    xy)))
					   `(define
					      ,(string->symbol
						 (string-append
						   to-mdl2
						   (symbol->string
						     x)))
					      ,(string->symbol
						 (string-append
						   fm-mdl2
						   (symbol->string
						     y))))))
				       (cdddr e)))
			     ;else this is import-syntax
			     (if module:defmacro-provided?
				 `(begin
				    ,@(map (lambda (xy)
					     (let ((x (if (pair? xy)
							  (car xy)
							  xy))
						   (y (if (pair? xy)
							  (cadr xy)
							  xy)))
					       `(defmacro
						  ,(string->symbol
						     (string-append
						       to-mdl2
						       (symbol->string
							 x)))
						  %%tmp
						  (cons 
						    ',(string->symbol
							(string-append
							  fm-mdl2
							  (symbol->string
							    y)))
						    %%tmp))))
					   (cdddr e)))
				 `(begin
				    ,@(map (lambda (xy)
					     (let* ((x (if (pair? xy)
							   (car xy) xy))
						    (y (if (pair? xy)
							   (cadr xy) xy))
						    (q:x
						      (string->symbol
							(string-append
							  to-mdl2
							  (symbol->string
							    x)))))
					       `(define-syntax ,q:x
						  (syntax-rules ()
						    ((,q:x . %%tmp)
						     (,(string->symbol
							 (string-append
							   fm-mdl2
							   (symbol->string
							     y))) 
						       . %%tmp))))))
					   (cdddr e)))))))
		      (else
			(cons (translate-loop a)
			  (translate-loop (cdr e)))))))))))

(define module:file-determine-locals-externs
  (lambda (f)
    (call-with-input-file f
      (lambda (inp)
	(let ((x (read inp)))
	  (if (not (and (pair? x) (eq? (car x) 'module))) #f
	    ;else do some preprocessing
	    (let* ((m (cadr x))
		   (pfx (symbol->string m)))
	      (let loop ()
		(let ((x (read inp)))
		  (if (not (eof-object? x))
		      (begin
			(module:determine-locals-externs
			  x m pfx)
			(loop)))))
	      #t)))))))

(define module:translate-file-to-port
  (lambda (f outp)
    (module:pretty-print `(set! *load-pathname* ,f) outp)
    (call-with-input-file f
      (lambda (inp)
	(let* ((x (read inp))
	       (m (and (pair? x) (eq? (car x) 'module)
		    (cadr x))))
	  (module:pretty-print (module:translate x m) outp)
	  (let loop ()
	    (let ((x (read inp)))
	      (if (not (eof-object? x))
		  (begin
		    (module:pretty-print (module:translate x m) outp)
		    (loop))))))))))

(define module:load
  (lambda ff
    (let ((translate-needed? #f))
      (for-each
	(lambda (f)
	  (if (module:file-determine-locals-externs f)
	      (set! translate-needed? #t)))
	ff)
      (if (not translate-needed?)
	  (for-each try-load ff)
	  (let ((tmpf (tmpnam)))
	    (call-with-output-file tmpf
	      (lambda (outp)
		(for-each
		  (lambda (f)
		    (module:translate-file-to-port f outp))
		  ff)))
	    (try-load tmpf)
	    (module:delete-file tmpf))))))

