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
;; java.lang.Character
;;
;; Stephane Hillion - 1998/01/05
;;
(require 'jobject)

(define <jcharacter> (<jobject> create-java-class "java.lang.Character"))

(<jcharacter> define (init i)
	    ;; Initialization from a scheme character
	    (this set-object! (char->java-char i)))

;; char --------------------------------------------------------------

(define <jchar> (<class> make <jobject> ()))

(define character.type   (java-field (<jcharacter> get *class*) "TYPE"))
(<jchar> define *class* (java-field-get character.type *java-null*))

(<jchar> define (init i)
       ;; char initialization from a scheme character
       (this set-object! (char->java-char i)))

(provide 'jcharacter)

;; methods -------------------------------------------------------
