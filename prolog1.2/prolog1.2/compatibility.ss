;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Compatibility:  definitions which are not built in to your Scheme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define elk-compatibility #f)
; (define foo-compatibility #f)
; etc.; add your own compatibility definitions below, and enable any
;       appropriate ones above.

;;;; Definitions for Elk (Extension Language Kit, from Oliver Laumann)
(if elk-compatibility
	(define (cpu-time) 0))		; not essential, so fake it
(if elk-compatibility
	(define (list-copy x)
		(if (null? x)
		    '()
		    (cons (car x) (list-copy (cdr x))))))
