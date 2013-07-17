;chezinit.scm
;Init file for Chez Scheme
;This is Aubrey Jaffer's Slib's feature-oriented
;init file style, massaged to exploit Chez/Unix features.
;Dorai Sitaram, dorai@cs.rice.edu, Feb. 1993

(if (bound? '*features*)
    (begin
      (display "loading init file twice! -- resetting")
      (newline)
      (reset)))

;*features*

(define *features* '())

;provide

(define provide
  (lambda (f . how)
    (if (not (memq f *features*))
	(begin
	  (if (pair? how) ((car how)))
	  (if (not (memq f *features*))
	      (set! *features* (cons f *features*)))))))

;try-load

(define system:load load)
(define try-load
  (lambda (f)
    (if (file-exists? f)
	(let ((old-load-pathname *load-pathname*))
	  (set! *load-pathname* f)
	  (system:load f)
	  (set! *load-pathname* old-load-pathname)
	  #t)
	#f)))

;*load-pathname*

(define *load-pathname* #f)
		
;program-vicinity

(define program-vicinity
  (lambda ()
    (if (not *load-pathname*) ""
      (let loop ((i (- (string-length *load-pathname*) 1)))
	(cond ((< i 0) "")
	      ((memv (string-ref *load-pathname* i) '(#\/ #\\))
	       (substring *load-pathname* 0 (+ i 1)))
	      (else (loop (- i 1))))))))

;load, redefined to recognize modules

(define load
  (letrec 
    ((load
       (lambda (f)
	 (if (call-with-input-file f
	       (lambda (inp)
		 (let ((x (read inp)))
		   (and (pair? x) (eq? (car x) 'module)))))
	     (begin
	       (provide 'module
		 (lambda ()
		   (or (try-load
			 (string-append *library*
			   "module.scm"))
		     (error "couldn't find module.scm"))))
	       (set! load module:load)
	       (module:load f))
	     (or (try-load f)
	       (error "couldn't find file " f))))))
  (lambda (f)
    (load f))))

;features in the dialect

;numerical features

(if (inexact? (string->number "0.0")) (provide 'inexact))
(if (rational? (string->number "1/19")) (provide 'rational))
(if (real? (string->number "0.0")) (provide 'real))
(if (complex? (string->number "1+i")) (provide 'complex))
(if (exact? (string->number "9999999999999999999999999999999"))
    (provide 'bignum))

(for-each provide
  '(
    chez
    defmacro
    delay
    dynamic-wind
    eval
    fluid-let
    getenv
    ieee-p1178
    macro
    multiarg-apply
    multiarg/and-
    pretty-print
    property-list
    random
    random-inexact
    rec
    rev3-procedures
    rev4-optional-procedures
    rev4-report
    reverse!
    system
    transcendental
    transcript
    unix
    with-file
    ))
     
;defmacro

(define-macro! defmacro z `(define-macro! ,@z))

(define macro?
  (lambda (m)
    (get m '*expander*)))

(define macroexpand-1 expand-once)

;error

(define error
  (lambda z
    (display "Error: ")
    (for-each display z)
    ((error-handler) #f "")))

;force-output

(define force-output flush-output)

;macro

(extend-syntax (define-syntax syntax-rules)
  ((define-syntax m (syntax-rules kk . cc))
   (extend-syntax (m . kk) . cc)))

;getenv

(provide-foreign-entries '("getenv"))

(define getenv
  (foreign-procedure "getenv" (string) string))

;tmpnam

(define tmpnam
  (let ((user-name (or (getenv "USER") ""))
	(n -1))
    (lambda ()
      (set! n (+ n 1))
      (let ((f (string-append "/tmp/_"
		 (number->string n) user-name)))
	(if (file-exists? f)
	    (tmpnam)
	    f)))))

;gentemp

(define gentemp
  (let ((n -1))
    (lambda ()
      (set! n (+ n 1))
      (string->symbol
	(string-append "t:" (number->string n))))))

;compile-file, redefined to recognize modules

(define system:compile-file compile-file)
(define compile-file
  (letrec ((compile-file
	     (lambda (inf outf)
	       (if (call-with-input-file inf
		     (lambda (inp)
		       (let ((x (read inp)))
			 (and (pair? x) (eq? (car x) 'module)))))
		   (begin
		     (provide 'module
		       (lambda ()
			 (or (try-load
			       (string-append *library*
				 "module.scm"))
			   (error "couldn't find module.scm"))))
		     (let ((tmpf (tmpnam)))
		       (call-with-output-file tmpf
			 (lambda (outp)
			   (module:translate-file-to-port inf outp)))
		       (system:compile-file tmpf outf)))
		   (system:compile-file inf outf)))))
    (lambda (inf outf)
      (compile-file inf outf))))

;identifying the library

(define *library*
  (let ((p (getenv "SCHEME_LIBRARY_PATH")))
    (if (not p)
	(begin
	  (display "Set environment variable SCHEME_LIBRARY_PATH to pathname")
	  (newline)
	  (display " of library.  For this session, I'll pretend")
	  (newline)
	  (display " current directory is library")
	  (newline)
	  "")
	p)))
