;grune.ss
;Iswym in Scheme
;(c) Dorai Sitaram, Dec. 1992, Rice U.
;Previous versions: Apr. 1991, Jan. 1992

;This file should be loaded in Iswym

;First load the file defining `coroutine'.

;(load "corou.ss")

(define-macro! pdelay (p)
  `(rec %proc%
     (lambda %args%
       (set! %proc% ,p)
       (apply %proc% %args%))))

(define tab "          ")

(define make-reader
  (lambda (o)
    (coroutine d
      (let loop ()
	(echo #f "=> ")
	(resume o (read))
	(loop)))))

(define make-writer
  (lambda (i)
    (coroutine d
      (let loop ()
        (let ((next (resume i 'next)))
	  (if (eq? next 'done) 'done
	    (begin (echo #f tab tab tab next eoln)
	      (loop))))))))

(define make-xx2y
  (lambda (x y i o)
    (coroutine d
      (let loop ()
        (let ((next (resume i 'next)))
	  (echo #f tab x x 2 y "<- " next eoln)
	  (if (eq? next x)
	      (let ((next+1 (resume i 'next)))
		(echo #f tab x x 2 y "<- " next+1 eoln)
		(if (eq? next+1 x) 
		    (begin
		      (echo #f tab x x 2 y "-> " y eoln)
		      (resume o y))
		    (begin
		      (echo #f tab x x 2 y "-> " next eoln)
		      (resume o next)
		      (echo #f tab x x 2 y "-> " next+1 eoln)
		      (resume o next+1))))
	      (begin
		(echo #f tab x x 2 y "-> " next eoln)
		(resume o next)))
	  (loop))))))

(define grune
  (lambda ()
    (letrec ((reader (make-reader (pdelay aa2b)))
	     (aa2b (make-xx2y 'a 'b (pdelay reader) (pdelay bb2c)))
	     (bb2c (make-xx2y 'b 'c (pdelay aa2b) (pdelay writer)))
	     (writer (make-writer (pdelay bb2c))))
       (writer 'start))))
