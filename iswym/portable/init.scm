;init.scm
;From Aubrey Jaffer's scm initialization file init.scm
;copyright (c) 1991, 1992, 1993 Aubrey Jaffer
;load is modified to accept modules
;Dorai Sitaram, dorai@cs.rice.edu

;*features*

;provide

(define provide
  (lambda (f . how)
    (if (not (memq f *features*))
	(begin
	  (if (pair? how) ((car how)))
	  (if (not (memq f *features*))
	      (set! *features* (cons f *features*)))))))

;try-load

;*load-pathname*

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
    abort
    delay
    dynamic-wind
    eval
    getenv
    ieee-p1178
    logical
    multiarg-apply
    mutilarg/and-
    object-hash 
    rev4-optional-procedures
    rev4-report
    reverse!
    scm
    system
    transcript
    with-file 
    ))

;identifying the library

(define *library* (program-vicinity))

(define *software-type* (software-type))

(provide *software-type*)

;N.B.: MSDOS does return/newline translation if file is
;not opened in "b" mode.  So use "rb" to recognize
;returns.

(define open_read
  (if (eq? *software-type* 'msdos) "rb" "r"))

(define open_write
  (if (eq? *software-type* 'msdos) "wb" "w"))

(define could-not-open #f)

(define open-input-file
  (lambda (f)
    (or (open-file f OPEN_READ)
	(and (procedure? could-not-open) (could-not-open) #f)
	(error "open-input-file: couldn't find file " f))))

(define open-output-file 
  (lambda (f)
    (or (open-file f OPEN_WRITE)
      (and (procedure? could-not-open) (could-not-open) #f)
      (error "open-output-file: couldn't find file " f))))

(define close-input-port close-port)
(define close-output-port close-port)

(define call-with-input-file 
  (lambda (f proc)
    (let* ((inp (open-input-file f))
	   (ans (proc inp)))
      (close-input-port inp)
      ans)))

(define call-with-output-file
  (lambda (f proc)
    (let* ((outp (open-output-file f))
	   (ans (proc outp)))
      (close-output-port outp)
      ans)))

(define with-input-from-file
  (lambda (f th)
    (let* ((p (open-input-file f))
	   (swaports
	     (lambda ()
	       (set! p (set-current-input-port p))))
	   (ans (dynamic-wind swaports th swaports)))
      (close-port p)
      ans)))

(define with-output-to-file
  (lambda (f th)
    (let* ((p (open-output-file f))
	   (swaports
	     (lambda ()
	       (set! p (set-current-input-port p))))
	   (ans (dynamic-wind swaports th swaports)))
      (close-port p)
      ans)))

;Number procedures enhanced to include reals.  

(set! abs magnitude)

(define expt
  (let ((integer-expt integer-expt))
    (lambda (x y)
      (cond ((and (integer? y) (exact? y)) (integer-expt x y))
	    (else ($expt x y))))))

;Generic error routine.  Displays all its arguments and signals
;error.

(define error
  (lambda args
    (let ((cep (current-error-port)))
      (perror "ERROR")
      (errno 0)
      (display "Error: " cep)
      (for-each (lambda (x) (display x cep)) args)
      (newline cep)
      (abort))))

;file-exists?

(define file-exists?
  (lambda (f)
    (let ((p (open-file f OPEN_READ)))
      (if p (begin (close-port p) #t)
	  #f))))
 
;exit

(define exit quit)
      
;write-line.  Scm needs this to justify its claim to have
;'line-i/o.

(define write-line
  (lambda (s . p)
    (apply display s p)
    (apply newline p)))

;ipow-by-squaring.  Scm needs this to justify its claim to
;have 'logical.

(define ipow-by-squaring
  (lambda (x k acc proc)
    (cond ((= k 0) acc)
	  ((= k 1) (proc acc x))
	  (else (ipow-by-squaring (proc x x)
		  (quotient k 2)
		  (if (even? k) acc (proc acc x))
		  proc)))))

;reverse! 

(define reverse!
  (lambda (s)
    (let loop ((s s) (r '()))
      (if (null? s) r
	(let ((d (cdr s)))
	  (set-cdr! s r)
	  (loop d s))))))

;defmacro

(define macro:transformer
  (lambda (f)
    (procedure->memoizing-macro
      (lambda (e r)
	(apply f (cdr e))))))

(define *macros* '())

(define defmacro
  (let ((defmacro-transformer
	  (lambda (name parms . body)
	    `(define ,name
	       (let ((transformer (lambda ,parms ,@body)))
		 (set! *macros*
		   (cons (cons ',name transformer) *macros*))
		 (macro:transformer transformer))))))
    (set! *macros* (cons (cons 'defmacro defmacro-transformer)
		     *macros*))
    (macro:transformer defmacro-transformer)))

(define macro?
  (lambda (m)
    (assq m *macros*)))

(define macroexpand-1
  (lambda (e)
    (if (not (pair? e)) e
      (let ((a (car e)))
	(if (not (symbol? a)) e
	  (let ((m (assq a *macros*)))
	    (if (not m) e
	      (apply (cdr m) (cdr e)))))))))

;gentemp

(define gentemp
  (let ((n -1))
    (lambda ()
      ;generates an allegedly new symbol.
      ;This is a gross hack since there is no standardized way of
      ;determining if the symbol is already used.      
      (set! n (+ n 1))
      (string->symbol (string-append "t:" (number->string n))))))

;fluid-let

(defmacro fluid-let (let-pairs . body)
  ;ignores nonlocal jumps
  (let ((x-s (map car let-pairs))
	(i-s (map cadr let-pairs))
	(old-x-s (map (lambda (p) (gentemp)) let-pairs)))
    `(let ,(map (lambda (old-x x) `(,old-x ,x)) old-x-s x-s)
       ,@(map (lambda (x i) `(set! ,x ,i)) x-s i-s)
       (let ((%temp% (begin ,@body)))
	 ,@(map (lambda (x old-x) `(set! ,x ,old-x)) x-s old-x-s)
	 %temp%))))

;rec

(defmacro rec (name val)
  `(let ((,name 'void))
     (set! ,name ,val)
     ,name))

;Less noise.

(verbose #f)

(for-each load (cdr (program-arguments)))
