;geninitf.ss
;generates an initfile for the lang/system defined in geninitf.dat
;(c) Dorai Sitaram, Dec. 1992, Rice U.

(define *dialect* 'forward)
(define *op-sys* 'forward)
(define *tmpfile-prefix* 'forward)
(define *initfile* 'forward)

(call-with-input-file "geninitf.dat"
  (lambda (ip)
    (set! *dialect* (read ip))
    (set! *op-sys* (read ip))
    (set! *tmpfile-prefix* (read ip))
    (set! *initfile* (read ip))))

(if (not (memq *dialect*
	       '(chez cscheme elk schemetoc scmj umbscheme)))
    (set! *dialect* 'other))

(if (not (memq *op-sys*
	       '(dos unix)))
    (set! *dialect* 'other))

(define eoln "eoln")

(define echo
  (lambda (op . z)
    (let ((op (if op op (current-output-port))))
      (for-each
	(lambda (x)
	  (if (eq? x eoln) (newline op)
	    (display x op)))
	z))))

(define generate-initfile
  (lambda (compatibility-info)
    (cond ((memq *dialect* '(chez cscheme scmj))
	   (if (file-exists? *initfile*)
	       (delete-file *initfile*)))
	  (else
	    (echo #f "If your Scheme complains that " *initfile*
	      " is" eoln
	      "already present, exit Scheme, delete " *initfile*
	      "," eoln
	      "and try again" eoln)))
    (call-with-output-file *initfile*
      (lambda (op)
	(echo op ";" *initfile* eoln)
	(echo op ";compatibility file for " *dialect*
	  " on " *op-sys* eoln)
	(echo op ";(c) Dorai Sitaram, Dec. 1992, Rice U." eoln eoln)
	(display `(define *op-sys* ',*op-sys*) op)
	(newline op)
	(write `(define *tmpfile-prefix* ,*tmpfile-prefix*) op)
	(newline op)
	(for-each
	  (lambda (e)
	    (if (and (pair? e)
		     (memq (car e)
			   '(extract-if extract-if-not)))
		(let ((a (car e))
		      (b (cadr e))
		      (c `(begin ,@(cddr e))))
		  (if (eq? a 'extract-if)
		      (if (memq *dialect* b)
			  (begin (write c op)
			    (newline op)))
		      (if (not (memq *dialect* b))
			  (begin (write c op)
			    (newline op)))))
		(begin (write e op)
		  (newline op))))
	  compatibility-info)))))

(generate-initfile
  '(
;error

    (extract-if (chez elk schemetoc)
      (define lerror
	(lambda z
	  (display "Error: ")
	  (for-each display z)
	  (error #f ""))))

    (extract-if-not (chez elk schemetoc)
      (define lerror
	(lambda z
	  (display "Error: ")
	  (for-each display z)
	  (error ""))))

;exit

    (extract-if (cscheme)
      (define exit %exit))

    (extract-if (other)
      (define exit
	(lambda z
	  (display "You may exit Scheme now!")
	  (newline)
	  (display "(Ignore error message)")
	  (newline)
	  (lerror))))

;eoln

    (define eoln 
      (if (eq? *op-sys* 'dos)
	  (string (integer->char 13) #\newline)
	  (string #\newline)))

;force-output

    (extract-if (cscheme)
      (define force-output
	(if (eq? *op-sys* 'dos) flush-output
	  (lambda z 'assume-output-forced))))

    (extract-if (elk)
      (define force-output flush-output-port))

    (extract-if (chez)
      (define force-output flush-output))

    (extract-if-not (chez cscheme elk scmj)
      (define force-output (lambda z 'assume-output-forced)))

;echo

    (define echo
      (lambda (p . z)
    ;displays each form in z on port p;
    ;if p is false, the console output is chosen
	(if p (for-each (lambda (x) (display x p)) z)
	    (begin (for-each display z) (force-output)))))

;reverse!

    (extract-if-not (chez cscheme elk)
      (define reverse!
	(lambda (s)
	  (let loop ((s s) (r '()))
	    (if (null? s) r
	      (let ((d (cdr s)))
		(set-cdr! s r)
		(loop d s)))))))

;list-set!

    (define list-set!
      (lambda (l i v)
	(set-car! (list-tail l i) v)))

;define-macro!

    (extract-if (scmj)
      (define macro:transformer
	(lambda (f)
	  (procedure->macro
	    (lambda (exp env)
	      (let ((res (apply f (cdr exp))))
		(if (pair? res)
		    (begin (set-car! exp (car res))
		      (set-cdr! exp (cdr res))
		      exp)
		    res))))))
      (define define-macro!
	(macro:transformer
	  (lambda (name parms . body)
	    `(define ,name
	       (let ((tfmr (lambda ,parms ,@body)))
	     ;should probably store tfmr someplace
	     ;so you can define macro:expand
		 (macro:transformer tfmr))))))
      )

    (extract-if (cscheme)
      (syntax-table-define system-global-syntax-table
	'define-macro!
	(macro defmacargs
	  (let ((macname (car defmacargs)) (macargs (cadr defmacargs))
		(macbdy (cddr defmacargs)))
	    `(syntax-table-define system-global-syntax-table
	       ',macname
	       (macro ,macargs ,@macbdy))))))

    (extract-if (elk)
      (define-macro (define-macro! key pat . bdy)
	`(define-macro ,(cons key pat) ,@bdy)))

    (extract-if (schemetoc)
      (define-macro define-macro!
	(lambda (f e)
	  (let ((key (cadr f)) (pat (caddr f)) (bdy (cdddr f)))
	    (e `(define-macro ,key 
		  (lambda (%form% %expr%)
		    (%expr% (apply (lambda ,pat ,@bdy) (cdr %form%)) %expr%)))
	       e)))))

    (extract-if (umbscheme)
      (macro define-macro!
	(lambda (f)
	  (let ((key (cadr f)) (pat (caddr f)) (bdy (cdddr f)))
	    `(macro ,key (lambda (%temp%)
			   (apply (lambda ,pat ,@bdy) (cdr %temp%))))))))

;rec

    (extract-if-not (chez)
      (define-macro! rec (name val)
	`(let ((,name 'void))
	   (set! ,name ,val)
	   ,name)))

;gensym

    (extract-if-not (chez)
      (define gensym
	(let ((n -1))
	  (lambda ()
      ;generates an allegedly new symbol;
      ;this is a gross hack since there is no standardized way of
      ;getting uninterned symbols
	    (set! n (+ n 1))
	    (string->symbol (string-append "g:" (number->string n)))))))

;fluid-let

    (extract-if-not (chez cscheme elk)
      (define-macro! fluid-let (let-pairs . body)
	(let ((x-s (map car let-pairs))
	      (i-s (map cadr let-pairs))
	      (old-x-s (map (lambda (p) (gensym)) let-pairs)))
	  `(let ,(map (lambda (old-x x) `(,old-x ,x)) old-x-s x-s)
	     ,@(map (lambda (x i) `(set! ,x ,i)) x-s i-s)
	     (let ((%temp% (begin ,@body)))
	       ,@(map (lambda (x old-x) `(set! ,x ,old-x)) x-s old-x-s)
	       %temp%)))))

;delete-file

    (extract-if (schemetoc umbscheme)
      (define delete-file
	(lambda (f)
	  (call-with-output-file f
	    (lambda (p) 'file-deleted)))))

    (extract-if-not (chez cscheme schemetoc scmj umbscheme)
      (define delete-file (lambda (f) 'assume-file-deleted)))

;file-exists?

    (extract-if-not (chez cscheme elk scmj)
      (define file-exists? (lambda (f) #t)))

;tmpnam

    (extract-if-not (scmj)
      (define tmpnam
	(let ((n -1))
	  (lambda ()
      ;generates a new temporary filename
	    (let loop ()
	      (set! n (+ n 1))
	      (let ((f (string-append *tmpfile-prefix*
			 (number->string n))))
		(if (file-exists? f)
		    (loop)
		    f)))))))

;eval

    (extract-if-not (scmj chez)
  ;this trick is due to Aubrey Jaffer (slib)
      (define eval:place-holder 'void)
      (define eval
	(lambda (e)
	  (let ((f (tmpnam)))
	    (call-with-output-file f
	      (lambda (op)
		(write `(set! eval:place-holder ,e) op)))
	    (load f)
	    (delete-file f)
	    eval:place-holder)))
      )

;module, extern

    (define *module* 
  ;current module is initially '()
      '())

    (define module:table (list (cons '() '())))

    (define module:goto
      (lambda (m)
	(let* ((m (reverse m))
	       (c (assoc m module:table)))
	  (if (not c)
	      (set! module:table
		(cons (cons m '()) module:table)))
	  (set! *module* m))))

    (define module:update
      (lambda (e)
	(if (pair? e)
	    (let ((a (car e)))
	      (cond ((eq? a 'module)
		     (module:goto (cdr e)))
		    ((eq? a 'define)
		     (let ((b (cadr e)))
		       (module:alist-update *module*
			 *module* (if (pair? b) (car b) b))))
		    ((memq a '(define-macro! define-syntax))
		     (module:alist-update *module* *module*
		       (cadr e)))
		    ((eq? a 'extend-syntax)
		     (module:alist-update *module* *module*
		       (caadr e)))
		    ((eq? a 'extern)
		     (let ((ext-module (cadr e)))
		       (for-each
			 (lambda (x)
			   (module:alist-update *module* 
			     ext-module x))
			 (cddr e))))
		    ((memq a '(begin if))
		     (for-each module:update (cdr e)))
		    ((eq? a 'cond)
		     (for-each
		       (lambda (clause)
			 (for-each module:update clause))
		       (cdr e)))
		    (else #f))))))
	  
    (define module:alist-update
      (lambda (curr-module ext-module x)
	(let ((curr-alist (assoc curr-module module:table)))
	  (if (not (assq x (cdr curr-alist)))
	      (set-cdr! curr-alist
		(cons (cons x
			(string->symbol
			  (string-append
			    (apply string-append
				   (reverse!
				     (map symbol->string ext-module)))
			    (symbol->string x))))
		  (cdr curr-alist)))))))

    (define module:translate
      (lambda (e)
	(cond ((pair? e)
	       (let ((a (car e)))
		 (cond ((eq? a 'module)
			(module:goto (cdr e))
			#f)
		       ((eq? a 'extern) #f)
		       (else
			 (cons (module:translate (car e))
			   (module:translate (cdr e)))))))
	      ((symbol? e)
	       (module:symbol-fullname e *module*))
	      (else e))))

    (define module:symbol-fullname
      (lambda (x mdl)
	(let loop ((mdl mdl))
	  (let ((c (assq x (cdr (assoc mdl module:table)))))
	    (cond (c (cdr c))
		  ((null? mdl) x)
		  (else (loop (cdr mdl))))))))    

    (define call-on-file
      (lambda (file proc)
	(call-with-input-file file
	  (lambda (inp)
	    (let loop ()
	      (let ((e (read inp)))
		(if (not (eof-object? e))
		    (begin (proc e) (loop)))))))))

;mload

    (define scheme:load load)

    (define mload
      (lambda files
	(let loop ((files files))
	  (if (not (null? files))
	      (begin
		(fluid-let ((*module* '()))
		  (call-on-file (car files) module:update))
		(loop (cdr files)))))
	(let ((tmpfile (tmpnam)))
	  (let loop ((files files))
	    (if (not (null? files))
		(begin
		  (call-with-output-file tmpfile
		    (lambda (op)
		      (fluid-let ((*module* '()))
			(call-on-file (car files)
			  (lambda (e)
			    (write (module:translate e) op))))))
		  (scheme:load tmpfile)
		  (delete-file tmpfile)
		  (loop (cdr files))))))))
    ))


(echo #f eoln *initfile* " has been generated" eoln)
(echo #f "You may exit Scheme now!" eoln)
