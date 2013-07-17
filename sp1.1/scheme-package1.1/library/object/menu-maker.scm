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
;; menu generator
;;
;; Stephane Hillion - 1999/01/03
;;
(require 'jjmenu-bar)
(require 'jjmenu)
(require 'jscm-action-listener)

(define <menu-maker> (<class> make <object>
			      (.L         ;; The menu specification
			       )))

(<menu-maker> define (create-jmenu-bar L)
	      ;; Create a new <jjmenu-bar>
	      ;; L must have the following form:
	      ;;    (menu ...)
	      ;;
	      ;; menu:
	      ;;    ("name" menu-item ...)
	      ;;
	      ;; menu-item
	      ;;    ("name" . procedure)
	      ;; or ("name" menu-item ...)
	      ;;
	      (set! .L L)

	      (this jjmenu-bar)
	      )

(<menu-maker> define (jjmenu-bar)
	      ;; create-jmenu-bar auxiliary method
	      (let ((mb (<jjmenu-bar> create)))
		(for-each (lambda (menu)
			    (mb add (this jjmenu menu)))
			  .L)
		mb))

(<menu-maker> define (jjmenu L)
	      ;; Create a jjmenu
	      (let ((menu (<jjmenu> create (<jstring> create (caar L)))))
		(for-each (lambda (Lst)
			    (if (or (eq? Lst 'separator)
				    (equal? Lst '("-")))
				(menu add-separator)
				(menu add (this jjmenu-item Lst))))
			  (cdr L))
		menu))

(<menu-maker> define (jjmenu-item L)
	      ;; Creates a jjmenu-item
	      (if (procedure? (cdr L))
		  (let ((mi (<jjmenu-item> create (<jstring> create (caar L))))
			(al (<jscm-action-listener> 
			     create
			     (<jobject> create *java-kernel*)
			     (<jobject> create (java-object (cdr L))))))
		    (mi add-action-listener al)
		    mi)
		  (this jjmenu L)))
