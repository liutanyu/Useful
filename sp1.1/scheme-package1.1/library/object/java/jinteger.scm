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
;; java.lang.Integer
;;
;; Stephane Hillion - 1998/12/22
;;
(require 'jnumber)

(define <jinteger> (<jnumber> create-java-class "java.lang.Integer"))

(<jinteger> define (init i)
	    ;; Initialization from a scheme integer
	    (this set-object! (integer->java-int i)))

;; int --------------------------------------------------------------

(define <jint> (<class> make <jobject> ()))

(define integer.type   (java-field (<jinteger> get *class*) "TYPE"))
(<jint> define *class* (java-field-get integer.type *java-null*))

(<jint> define (init i)
       ;; int initialization from a scheme integer
       (this set-object! (integer->java-int i)))

(provide 'jinteger)

;; methods -------------------------------------------------------
