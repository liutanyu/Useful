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
;; This class represents a top level window
;;
;; Stephane Hillion - 1998/01/05
;;
(require 'jjframe)
(require 'component)

(define <frame> (<class> make <component> ()))

(<frame> define (init . L)
	 ;; Initialization of the frame
	 ;; The argument, if one, must be a string
	 (if (null? L)
	     (set! .impl (<jjframe> create))
	     (set! .impl (<jjframe> create (<jstring> create (car L))))))

(provide 'frame)

;; methods

(<frame> define (set-menu-bar! mb)
	 ;; Sets the menu-bar of the frame
	 (.impl set-jmenu-bar! (mb implementation)))

(<frame> define (set-size! w h)
	 ;; Sets the size of the frame
	 (.impl set-size! (<jint> create w) (<jint> create h)))

(<frame> define (show)
	 ;; Shows the frame and its children
	 (.impl show))
