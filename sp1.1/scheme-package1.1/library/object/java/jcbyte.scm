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
;; java.lang.Byte
;;
;; Stephane Hillion - 1998/01/05
;;
(require 'jnumber)

(define <jcbyte> (<jnumber> create-java-class "java.lang.Byte"))

(<jcbyte> define (init r)
	   ;; Initialization from a scheme real
	   (this set-object! (real->java-byte r)))

;; byte ----------------------------------------------------------

(define <jbyte> (<class> make <jobject> ()))

(define byte.type   (java-field (<jcbyte> get *class*) "TYPE"))
(<jbyte> define *class* (java-field-get byte.type *java-null*))

(<jbyte> define (init r)
	 ;; Initialization from a scheme real
	 (this set-object! (real->java-byte r)))

(provide 'jcbyte)

;; methods -------------------------------------------------------
