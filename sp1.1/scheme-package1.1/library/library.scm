;; This file is free software,which comes along with the scheme package. This
;; software  is  distributed  in the hope that it will be useful, but WITHOUT 
;; ANY  WARRANTY;  without  even  the  implied warranty of MERCHANTABILITY or
;; FITNESS  FOR A PARTICULAR PURPOSE. You can modify it as you want, provided
;; this header is kept unaltered, and a notification of the changes is added.
;; You  are  allowed  to  redistribute  it and sell it, alone or as a part of 
;; another product.
;;          Copyright (C) 1998-99 Stephane HILLION - hillion@essi.fr
;;              http://www.essi.fr/~hillion/scheme-package
;;
;;
;; Initialization file for the library
;;
;; Stephane Hillion - 1998/12/20
;;

;; Unspecified value --------------------------------------------------------

(define unspecified
  ;; (unspecified)
  ;; Returns an unspecified value
  (let ((val (if #f #f)))
    (lambda ()
      val)))

;; Error procedure ----------------------------------------------------------

(define error
  ;; (error object ...)
  ;; Displays the arguments an calls the top level continuation
  (call/cc (lambda (cc)
	     (lambda L
	       (display "Library error: ")
	       (for-each display L)
	       (newline)
	       (cc (unspecified))))))

;; Features -----------------------------------------------------------------

(define require #f)
  ;; (require symbol)
  ;; If symbol is not a feature, loads the file "symbol.scm"

(define provide #f)
  ;; (provide symbol)
  ;; Registers symbol as a feature

(define feature? #f)
  ;; (feature? symbol)
  ;; Returns #t if symbol is a feature, #f otherwise

(define features #f)
  ;; (features)
  ;; Returns the list of loaded features

(define *load-path* '("" "library/"))
  ;; A list of strings. Each string is a directory where 'require' and 'load'
  ;; search for files

(define load
  ;; (load string)
  ;; A extended version of the standard 'load' procedure that search files in
  ;; the paths contained in '*load-path*'
  (let ((old-load  load))
    (lambda (name)
      (letrec ((file-path (lambda (lp)
			    (if (null? lp)
				#f
				(let ((path (string-append (car lp) name)))
				  (if (file-exists? path)
				      path
				      (file-path (cdr lp)))))))
	       (path (file-path *load-path*)))
	(if path
	    (old-load path)
	    (error "Can't load " name))))))

;; require, provide, feature? and features definitions 
;;
(let* ((*features* '())
       (dotted?   (lambda (str)
		    (member #\. (string->list str))))
       (file-name (lambda (symb)
		    (let ((str (symbol->string symb)))
		      (if (dotted? str)
			  str
			  (string-append str ".scm"))))))
  (set! require
	(lambda (symb . L)
	  (if (not (feature? symb))
	      (if (null? L)
		  (load (file-name symb))
		  (load (car L))))))

  (set! feature?
	(lambda (symb)
	  (if (member symb *features*)
	      #t
	      #f)))
  
  (set! provide
	(lambda (symb)
	  (set! *features* (cons symb *features*))))

  (set! features
	(lambda ()
	  *features*))
  )

(provide 'library)

;; Library paths --------------------------------------------------------

(set! *load-path* (cons "library/object/" *load-path*))
(set! *load-path* (cons "library/object/gui/" *load-path*))
(set! *load-path* (cons "library/object/java/" *load-path*))
(set! *load-path* (cons "library/object/java/generated/" *load-path*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
