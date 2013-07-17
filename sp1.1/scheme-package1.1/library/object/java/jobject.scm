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
;; Interface to java.lang.Object
;;
;; Stephane Hillion - 1998/12/22
;;
(require 'object)

(define <jobject> (<class> make <object> (.object)))

(<jobject> define *class* (java-class "java.lang.Object"))

;; <class> methods ----------------------------------------------------------

(<class> define (create-java-class name)
	 ;; Create a new java class child of the current class and that
	 ;; implements the classes in L
	 (assert "<class> create-java-class name" (or (this eq?       <jobject>)
						      (this child-of? <jobject>)))
	 (let ((res (<class> make this ())))
	   (res define *class* (java-class name))
	   res))

(<class> define (create-init . Largs)
	 ;; Creates an init method
	 ;; Largs is the list of the classes of the arguments
	 (assert "<class> create-init" (or (this eq?       <jobject>)
					   (this child-of? <jobject>)))
	 (let ((constr (delay (apply java-constructor (this get *class*)
				     (map (lambda (c)
					    (apply (<class> get get) c '*class* '()))
					  Largs)))))
	   (apply method 'L `(let ((mr (map (lambda (c) (c object)) L)))
			       (set! .object
				     (apply java-new-instance (force ,constr) mr)))
		  '())))

(<class> define (create-method result name . Largs)
	 ;; Creates a java method
	 ;; Largs is the list of the classes of the arguments
	 (assert "<class> create-method" (or (this eq?       <jobject>)
					     (this child-of? <jobject>)))
	 (let ((meth (delay (apply java-method (this get *class*) name
				   (map (lambda (c)
					  (apply (<class> get get) c '*class* '()))
					Largs)))))
	   (if (eq? result *java-null*)
	       (apply method 'L `(let ((mr (map (lambda (c) (c object)) L)))
				   (apply java-method-invoke
					  (force ,meth) .object mr)) '())
	       (apply method 'L `(let* ((mr (map (lambda (c) (c object)) L))
					(res (apply java-method-invoke
						    (force ,meth) .object mr))
					(obj (,result make)))
				   (obj set-object! res)
				   obj) '()))))

(<class> define (create-static-method result name . Largs)
	 ;; Creates a static java method
	 ;; Largs is the list of the classes of the arguments
	 (assert "<class> create-static-method" (or (this eq?       <jobject>)
						    (this child-of? <jobject>)))
	 (let ((meth (delay (apply java-method (this get *class*) name
				   (map (lambda (c)
					  (apply (<class> get get) c '*class* '()))
					Largs)))))
	   (if (eq? result *java-null*)
	       (apply lambda 'L `(let ((mr (map (lambda (c) (c object)) L)))
				   (apply java-method-invoke
					  (force ,meth) *java-null* mr)) '())
	       (apply lambda 'L `(let* ((mr (map (lambda (c) (c object)) L))
					(res (apply java-method-invoke
						    (force ,meth) *java-null* mr))
					(obj (,result make)))
				   (obj set-object! res)
				   obj) '()))))

(<class> define (create-final-static-field type name)
	 ;; Returns a getter method for the field 'name'
	 (assert "<class> create-final-static-field" (or (this eq?       <jobject>)
							 (this child-of? <jobject>)))
	 (let ((field (delay (java-field (this get *class*) name))))
	   (apply lambda '()
		  `(let ((res (,type make)))
		     (res set-object! (java-field-get (force ,field) *java-null*))
		     res) '())))

(<class> define (create-final-field type name)
	 ;; Returns a getter method for the field 'name'
	 (assert "<class> create-final-field" (or (this eq?       <jobject>)
						  (this child-of? <jobject>)))
	 (let ((field (delay (java-field (this get *class*) name))))
	   (apply method '()
		  `(let ((res (,type make)))
		     (res set-object! (java-field-get (force ,field) .object))
		     res) '())))

(<class> define (create-static-field type name)
	 ;; Returns in a pair a setter and a getter for the field 'name'
	 (assert "<class> create-static-field" (or (this eq?       <jobject>)
						   (this child-of? <jobject>)))
	 (let ((field (delay (java-field (this get *class*) name))))
	   (cons
	    (apply lambda '()
		   `(let ((res (,type make)))
		      (res set-object! (java-field-get (force ,field) *java-null*))
		      res) '())
	    (apply lambda '(obj)
		   `(java-field-set (force ,field) *java-null* obj) '()))))

(<class> define (create-field type name)
	 ;; Returns in a pair a setter and a getter for the field 'name'
	 (assert "<class> create-field" (or (this eq?       <jobject>)
					    (this child-of? <jobject>)))
	 (let ((field (delay (java-field (this get *class*) name))))
	   (cons
	    (apply method '()
		   `(let ((res (,type make)))
		      (res set-object! (java-field-get (force ,field) .object))
		      res) '())
	    (apply method '(obj)
		   `(java-field-set (force ,field) .object obj) '()))))

(provide 'jobject)
(require 'jcharacter)
(require 'jstring)
(require 'jcbyte)
(require 'jinteger)
(require 'jclong)
(require 'jboolean)
(require 'jcfloat)
(require 'jcdouble)

;; <jobject> methods --------------------------------------------------

(<jobject> define (init obj)
	   ;; Initialization
	   (set! .object obj))

(<jobject> define (object)
	   ;; Returns the java-object this object encapsulates
	   .object) 

(<jobject> define (set-object! obj)
	   ;; Sets the .object attribute
	   (set! .object obj))

(<jobject> define equals?
	   ;; Object.equals()
	   (<jobject> create-method <jbool> "equals" <jobject>))

(<jobject> define ->string
	   ;; Object.toString()
	   (<jobject> create-method <jstring> "toString"))

(<jobject> define hash-code
	   ;; Object.hashCode()
	   (<jobject> create-method <jint> "hashCode"))

(<jobject> define instance-of?
	   ;; Is this object an instance of the given class
	   (let ((mth (java-method (java-class "java.lang.Class")
				   "isInstance"
				   (<jobject> get *class*))))
		 (method (cl)
		   (or (this super instance-of? cl)
		       (java-boolean->boolean (java-method-invoke mth 
								  (cl get *class*)
								  (this object)))))))

(<jobject> define (print)
	   ;; Displays the object
	   (print ((this ->string) object)))
