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
;; Utility functions
;;
;; Stephane Hillion - 1998/12/20
;;
(provide 'util)

;; Syntax ----------------------------------------------------------

(define define-syntax
  ;; (define-syntax (symb symb ...) obj obj ...)
  ;; Creates and defines (in the global environment) a new syntax
  (syntax (p . L)
     (eval `(define ,(car p) (syntax ,(cdr p) ,@L)))))

;; Displaying -----------------------------------------------------

(define (print . L)
  ;; Displays all the given arguments and a newline
  (map display L)
  (newline))

;; Symbols -------------------------------------------------------

(define gensym
  ;; (gensym), (gensym string)
  ;; Returns a new symbol with prefix 'string' if given
  (let ((cpt 0))
    (lambda L
      (set! cpt (+ 1 cpt))
      (if (null? L)
	  (string->symbol (string-append "S" (number->string cpt)))
	  (string->symbol (string-append (car L) (number->string cpt)))))))

(define (symbol-append symb . L)
  ;; (symbol-append symb1 symb2 ...)
  ;; Returns a symbol which is the concatenation of all the given symbols
  (string->symbol (apply string-append (map symbol->string (cons symb L)))))

;; Numbers --------------------------------------------------------

(define (1+ n)
  ;; Returns (+ n 1)
  (+ n 1))

(define (-1+ n)
  ;; Returns (- n 1)
  (- n 1))

(define-syntax (inc! symb . L)
  ;; (inc! k)
  ;; (inc! k n)
  ;; Increments the value stored in symb by 1 or by n if specified.
  (if (null? L)
      (apply set! symb `(1+ ,(local-eval symb)) '())
      (apply set! symb `(+ ,(local-eval symb) ,(local-eval (car L))) '())))

(define-syntax (dec! symb . L)
   ;; (dec! k)
  ;; (dec! k n)
  ;; Decrements the value stored in symb by 1 or by n if specified.
 (if (null? L)
      (apply set! symb `(-1+ ,(local-eval symb)) '())
      (apply set! symb `(- ,(local-eval symb) ,(local-eval (car L))) '())))
