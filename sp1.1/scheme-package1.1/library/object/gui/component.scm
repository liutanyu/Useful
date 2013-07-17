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
;; This class represents a graphic component
;;
;; Stephane Hillion - 1998/01/05
;;
(require 'object)

(define <component> (<class> make <object> (.impl)))

(<component> define (init)
	     (error "Can't create a <component>"))

(provide 'component)

;; Methods -------------------------------------------

(<component> define (implementation)
	     ;; Returns the implementation of the component
	     .impl)
