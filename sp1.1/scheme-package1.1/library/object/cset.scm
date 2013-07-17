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
;; set
;;
;; Stephane Hillion -- 1998/12/12
;;
(require 'clist)

(define <set> (<class> make <list> ()))

(provide 'cset)
;; methods ------------------------------------------------

(<set> define (union s)
       ;; Computes the union of this with s
       ;; --> a <set>
       (<set> create (set-union .head (s list))))

(<set> define (intersection s)
       ;; Computes the intersection of this and s
       ;; --> a <set>
       (<set> create (set-intersection .head (s list))))

(<set> define (difference s)
       ;; Computes the difference of this and s
       ;; --> a <set>
       (<set> create (set-difference .head (s list))))

(<set> define (print)
	;; displays the representation of this object
	(print "<set>: " .head))
