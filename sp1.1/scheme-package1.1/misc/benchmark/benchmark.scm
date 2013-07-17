(time (begin
         
	 ;; tak
	 ;; function-call-heavy; test of function call and recursion
         
         (define (tak x y z)
           (if (not (< y x))
               z
               (tak (tak (- x 1) y z)
                    (tak (- y 1) z x)
                    (tak (- z 1) x y))))
         
	 (display ";; 1 - (tak 18 12 6)")
	 (newline)
         (time (tak 18 12 6))
	 (newline)
         
         ;;-----------------------------------------------------
         ;; time : 38510 ms (JDK1.2,    Win95,  Pentium 100)
         ;; time : 57674 ms (JDK1.1.7A, linux2, Pentium 200 MMX)
         ;; time : 13049 ms (JDK1.2,    NT 4,   Pentium 200 MMX)
         ;;-----------------------------------------------------
         
	 ;; definition-heavy file; test of compile-load-and-go
         
	 (display ";; 2 - (load \"misc/benchmark/load-test.scm\")")
	 (newline)
         (time (load "misc/benchmark/load-test.scm"))
	 (newline)
         
         ;;-----------------------------------------------------
         ;; time : 49540 ms (JDK1.2,    Win95,  Pentium 100)
         ;; time : 11649 ms (JDK1.1.7A, linux2, Pentium 200 MMX)
         ;; time : 18136 ms (JDK1.2,    NT 4,   Pentium 200 MMX)
         ;;-----------------------------------------------------
         
	 ;; quicksort function; test of function recursion and lists
         
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
         
					; a list of 1000 numbers
					;
         (define L '(12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2
                        98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 16 30 36 72 49 71 91 81 32 36 74 27 56 94 0 1 6 4 51 59 32 15 18 14 13 12 11 67 89 4 25 64 82 47 12 45 32 65 5 2 98 56 4 31 21 53 75 86 97 60 53 21 23 45 67 89 43 32 21 32 47 38 29 10 43 84 28 95 38 29 10 43 84 28 95))
         
	 (display ";; 3 - (list-sort < L)")
	 (newline)
         (time (list-sort < L))
	 (newline)
         
         ;;-----------------------------------------------------
         ;; time : 30650 ms (JDK1.2,    Win95,  Pentium 100)
         ;; time : 47730 ms (JDK1.1.7A, linux2, Pentium 200 MMX)
         ;; time : 10756 ms (JDK1.2,    NT 4,   Pentium 200 MMX)
         ;;-----------------------------------------------------

	 ;; Prime: test of lists recursion and numbers
	 (define (iota n)
	   ;; --> (1 ... n)
	   (letrec ((aux (lambda (k)
			   (if (= n k)
			       (list n)
			       (cons k (aux (+ k 1)))))))
	     (aux 1)))
	 
	 (define (rem-kn L n)
	   (if (null? L)
	       '(() . #f)
	       (let ((res (rem-kn (cdr L) n)))
		 (cond ((= n (car L)) (cons (cons (car L) (car res))
					    (if (null? (cdr L))
						#f
						(cadr L))))
		       ((= 0 (remainder (car L) n))  res)
		       (else (cons (cons (car L) (car res)) (cdr res)))))))

	 (define (primes n)
	   ;; --> a list of prime numbers < n
	   (letrec ((L (iota n))
		    (aux (lambda (k)
			   (let ((L.a (rem-kn L k)))
			     (if (cdr L.a)
				 (begin
				   (set! L (car L.a))
				   (aux (cdr L.a)))
				 (car L.a))))))
	     (aux 2)))
         
	 (display ";; 4 - (primes 800)")
	 (newline)
         (time (primes 800))
	 (newline)
         
         ;;-----------------------------------------------------
         ;; time : 37850 ms (JDK1.2,    Win95,  Pentium 100)
         ;; time : 47730 ms (JDK1.1.7A, linux2, Pentium 200 MMX)
         ;; time : 12508 ms (JDK1.2,    NT 4,   Pentium 200 MMX)
         ;;-----------------------------------------------------

         (display ";;;;;; GLOBAL TIME ;;;;;;") ))

;; Global elapsed time
;;------------------------------------------------------
;; time : 156920 ms (JDK1.2,    Win95,  Pentium 100)
;; time : 117595 ms (JDK1.1.7A, linux2, Pentium 200 MMX)
;; time :  54468 ms (JDK1.2,    NT 4,   Pentium 200 MMX)
;;------------------------------------------------------

