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
;; list
;;
;; Stephane Hillion - 1998/12/22
;;
(require 'object)

(define <list> (<class> make <object> (.head .size)))

(<list> define (init . L)
	;; This method accept 0 or more arguments
	;; If one, it must be a list, if more they become elements
	;; of the list
	(if (null? L)
	    (begin
	      (set! .head '())
	      (set! .size 0))
	    (if (null? (cdr L))
		(begin
		  (set! .head (car L))
		  (set! .size (length (car L))))
		(begin
		  (set! .head L)
		  (set! .size (length L))))))

(provide 'clist)
;; methods -------------------------------------------------

(<list> define (empty?)
	;; Is this list empty?
	(null? .head))

(<list> define (valid-index? i)
	;; Is i a valid index ?
	(and (>= i 0) (< i .size)))

(<list> define (add item)
	;; Adds an item at the beginning of the list
	(set! .head (cons item .head))
	(set! .size (+ 1 .size)))

(<list> define (remove . L)
	;; Removes the first occurence of (car L) if one
	;; argument is given, otherwise the first element
	(assert "<list> remove" (not (this empty?)))

	(if (null? L)
	    (set! .head (cdr .head))
	    (set! .head (remq-first (car L) .head)))
	(set! .size (- .size 1)))

(<list> define (first)
	;; Returns the first item in the list
	(assert "<list> first" (not (this empty?)))

	(car .head))

(<list> define (get i)
	;; Returns the item at i
	(assert "<list> get" (this valid-index? i))

	(list-ref .head i))

(<list> define (list)
	;; Returns the underlying scheme list
	.head)

(<list> define (length)
	;; Returns the length of the list
	.size)

(<list> define (remove* s)
	;; Removes all the occurences of s in the list
	(set! .head (remq s .head)))

(<list> define (sort p?)
	;; Sorts the list with the predicate p?
	;; Returns a new <list>
	(<list> create (list-sort p? .head)))

(<list> define (member s)
	;; The same as member function
	;; Returns a <list> or #f
	(let ((memb (memq s .head)))
	  (if memb
	      (<list> create memb)
	      #f)))

(require 'cset)

(<list> define (->set)
	;; Transforms the list in a set
	;; --> a <set>
	(<set> create (list->set .head)))

(<list> define (print)
	;; displays the representation of this object
	(print "<list>: " .head))
