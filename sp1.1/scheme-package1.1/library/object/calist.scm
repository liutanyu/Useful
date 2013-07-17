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
;; alist
;;
;; Stephane Hillion - 1998/12/22
;;
(require 'clist)

(define <alist> (<class> make <list> ()))

(provide 'calist)
;; methods ---------------------------------------

(<alist> define (assoc key)
	 ;; returns the member with the key 'key' or #f
	 (assoc key .head))

(<alist> define (add p)
	 ;; adds a pair to the list
	 (let ((ass (this assoc (car p))))
	   (if ass
	       (set-cdr! ass (cdr p))
	       (begin
		 (set! .head (cons p .head))
		 (set! .size (1+ .size))))))

(<alist> define (remove key)
	 ;; removes the pair which have the key 'key'
	 (letrec ((aux (lambda (L)
			 (if (null? L)
			     '()
			     (if (eq? key (caar L))
				 (begin
				   (set! .size (-1+ .size))
				   (aux (cdr L)))
				 (cons (car L) (aux (cdr L))))))))
	   (set! .head (aux .head))))

(<alist> define (print)
	 ;; displays the representation of this object
	 (print "<alist>: " .head))
