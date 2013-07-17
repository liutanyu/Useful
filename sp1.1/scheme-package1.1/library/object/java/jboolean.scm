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
;; java.lang.Boolean
;;
;; Stephane Hillion - 1998/12/22
;;
(require 'jobject)

(define <jboolean> (<jobject> create-java-class "java.lang.Boolean"))

(<jboolean> define (init b)
	    ;; Initialization from a scheme boolean
	    (this set-object! (boolean->java-boolean b)))

;; boolean ----------------------------------------------------------

(define <jbool> (<class> make <jobject> ()))

(define boolean.type   (java-field (<jboolean> get *class*) "TYPE"))
(<jbool> define *class* (java-field-get boolean.type *java-null*))

(<jbool> define (init b)
	 ;; Initialization from a scheme boolean
	 (this set-object! (boolean->java-boolean b)))

(provide 'jboolean)

;; methods -------------------------------------------------------