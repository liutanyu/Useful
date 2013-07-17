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
;; Functions and syntaxes that applies to lists
;;
;; Stephane Hillion - 1998/12/21
;;
(require 'util)
(provide 'list)

(define (make-list n obj)
  ;; (make-list n obj)
  ;; Returns a list of length n initialized with obj
  (if (zero? n)
      '()
      (cons obj (make-list (- n 1) obj))))

(define-syntax (pop! symb)
  ;; (pop! symbol)
  ;; Removes and returns the first element of the list stored at 'symbol'
  (let ((s (gensym)))
    (local-eval
     `(let ((,s ,symb))
	(begin
	  (set! ,symb (cdr ,s))
	  (car ,s))))))

(define-syntax (push! symb obj)
  ;; (push! symbol object)
  ;; Adds 'object' at the front of the list stored at 'symbol'
  (local-eval `(set! ,symb (cons ,obj ,symb))))

(define (list:make-rem p?)
  ;; Creates a remove-like function with the equality predicate p?
  (lambda (obj L)
    (cond ((null? L) '())
	  ((p? obj (car L)) (remove obj (cdr L)))
	  (else (cons (car L) (remove obj (cdr L)))))))

(define remove
  ;; (remove obj L)
  ;; Removes all objects equal? to obj in L
  (list:make-rem equal?))

(define remq
  ;; (remq obj L)
  ;; Removes all objects eq? to obj in L
  (list:make-rem eq?))

(define remv
  ;; (remv obj L)
  ;; Removes all objects eqv? to obj in L
  (list:make-rem eqv?))

(define (list:make-rem-first p?)
  ;; Creates a remove-like function with the equality predicate p?
  (lambda (obj L)
    (cond ((null? L) '())
	  ((p? obj (car L)) (cdr L))
	  (else (cons (car L) (remove obj (cdr L)))))))

(define remove-first
  ;; (remove-first obj L)
  ;; Removes all objects equal? to obj in L
  (list:make-rem-first equal?))

(define remq-first
  ;; (remq-first obj L)
  ;; Removes all objects eq? to obj in L
  (list:make-rem-first eq?))

(define remv-first
  ;; (remv-first obj L)
  ;; Removes all objects eqv? to obj in L
  (list:make-rem-first eqv?))

(define (last-pair L)
  ;; Returns the last pair of L
  (if (null? (cdr L))
      L
      (last-pair (cdr L))))

(define (append! . L)
  ;; (append! ...)
  ;; Destructive append
  (if (null? L)
      L
      (begin
	(set-cdr! (last-pair (car L))
		  (apply append! (cdr L)))
	(car L))))

(define (reverse! L)
  ;; Destructive reverse
  (if (null? L)
      '()
      (do ((lst  L       curs)
	   (curs (cdr L) (if (null? curs) '() (cdr curs)))
	   (res  '()     lst))
	  ((null? lst) res)
	(set-cdr! lst res))))

(define (copy-tree L)
  ;; Recursive list-copy
  (cond ((or (not (pair? L)) (null? L)) L)
	((pair? (car L)) (cons (copy-tree (car L)) (copy-tree (cdr L))))
	(else            (cons (car L) (copy-tree (cdr L))))))

(define (list->set l)
  ;; Transforms l in a set with eq? predicate
  (letrec 
      ((rem-dupl 
	(lambda (l res)
	  (cond
	   ((null? l)          res)
	   ((memq (car l) res) (rem-dupl (cdr l) res))
	   (else               (rem-dupl (cdr l) (cons (car l) res)))))))
    (rem-dupl l '())))

(define (set-union l1 l2)
  ;; The union of two sets with eq? predicate
  (list->set (append l1 l2)))

(define (set-intersection l1 l2)
  ;; The intersection of two sets with eq? predicate
  ;;
  (cond ((null? l1)         l1)
        ((null? l2)         l2)
        ((memq (car l1) l2) (cons (car l1) (set-intersection (cdr l1) l2)))
        (else               (set-intersection (cdr l1) l2))))

(define (set-difference l1 l2)
  ;; The difference of two sets with eq? predicate
  (cond ((null? l1)          l1)
        ((memq (car l1) l2)  (set-difference (cdr l1) l2))
        (else                (cons (car l1) (set-difference (cdr l1) l2)))))
(define (list-sort p? L)
  ;; sort the list given
  ;; p? is the predicate used to order the list
  (cond ((null? L) '())
	((null? (cdr L)) L)
	(else
	 (letrec ((split
		   (lambda (obj Lx)
		     (if (null? Lx)
			 '(() . ())
			 (let ((res (split obj (cdr Lx))))
			   (if (p? (car Lx) obj)
			       (cons (cons (car Lx) (car res)) (cdr res))
			       (cons (car res) (cons (car Lx) (cdr res))))))))
		  (low.high (split (car L) (cdr L)))
		  (low (car low.high))
		  (high (cdr low.high)))
	   (cond ((null? low)
		  (cons (car L) (list-sort p? high)))
		 ((null? high)
		  (append (list-sort p? low) (list (car L))))
		 (else 
		  (append (list-sort p? low)
			  (list (car L))
			  (list-sort p? high))))))))
