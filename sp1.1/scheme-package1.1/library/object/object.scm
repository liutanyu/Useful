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
;; Object system initialization
;;
;; Stephane Hillion - 1998/12/22
;;
(require 'util)
(provide 'object)

;; <class> -----------------------------------------------------------

(<class> define (child-of? class)
	 ;; (class1 child-of? class2)
	 ;; Returns #t if class1 is a child of class2
	 (letrec ((aux (lambda (cl)
			 (let ((p (cl get-parent)))
			   (cond ((p eq? cl) #f)
				 ((p eq? class) #t)
				 (else (aux p)))))))
	   (aux this)))

(<class> define (create . L)
	 ;; (class create obj ...)
	 ;; Creates a new object and call 'init'.
	 ;; Returns the new object
	 (let ((result (this make)))
	   (apply (this get init) result L)
	   result))

(<class> define define-syntax
	 ;; (class define-syntax (symb symb ...) obj obj ...)
	 ;; Defines a syntactic method
	 (syntax-method (p . L)
	   (eval `(,this define ,(car p) (syntax-method ,(cdr p) ,@L)))))

;; <object> ----------------------------------------------------------

(<object> define (init)
	  ;; This method is invoked by 'create'. It must be redefined
	  ;; by childs to allow automatic initialization
	  (unspecified))

(<object> define (eq? other)
	  ;; (obj1 eq? obj2)
	  ;; Returns #t if (eq? obj1 obj2)
	  (eq? this other))

(<object> define-syntax (class-field name)
	  ;; (obj class-field symb)
	  ;; Returns a field of this object's class
	  (apply (<class> get get) (this get-class) name '()))

(<object> define (instance-of? class)
	  ;; (obj intance-of? class)
	  ;; Is this object an instance of 'class'?
	  (let ((cl (this get-class)))
	    (or (cl eq? class)
		(cl child-of? class))))

(<object> define (print)
	  ;; (obj print)
	  ;; Prints this object
	  (print this))
