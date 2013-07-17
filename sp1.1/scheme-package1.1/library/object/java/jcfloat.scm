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
;; java.lang.Float
;;
;; Stephane Hillion - 1998/12/23
;;
(require 'jnumber)

(define <jcfloat> (<jnumber> create-java-class "java.lang.Float"))

(<jcfloat> define (init r)
	   ;; Initialization from a scheme real
	   (this set-object! (real->java-float r)))

;; float ----------------------------------------------------------

(define <jfloat> (<class> make <jobject> ()))

(define float.type   (java-field (<jcfloat> get *class*) "TYPE"))
(<jfloat> define *class* (java-field-get float.type *java-null*))

(<jfloat> define (init r)
	 ;; Initialization from a scheme real
	 (this set-object! (real->java-float r)))

(provide 'jcfloat)

;; methods -------------------------------------------------------
