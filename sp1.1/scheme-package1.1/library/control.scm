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
;; Control structures
;;
;; Stephane Hillion - 1998/12/21
;;
(require 'util)
(provide 'control)

(define-syntax (while c . L)
  ;; (while obj1 obj2 obj3 ...)
  ;; Evaluates obj2 obj3 ... until obj1 equals #f
  (if (local-eval c)
      (begin
	(apply begin L)
	(apply while c L))))

(define-syntax (when c . L)
  ;; (when obj1 obj2 obj3 ...)
  ;; Evaluates obj2 obj3 ... if obj1 is not #f
  (if (local-eval c)
      (apply begin L)))

(define-syntax (begin1 e1 . L)
  ;; (begin1 obj1 obj2 ...)
  ;; Evaluates obj1, obj2 ... in sequence and returns the result
  ;; of the evaluation of obj1.
  (let ((res (local-eval e1)))
    (apply begin L)
    res))
