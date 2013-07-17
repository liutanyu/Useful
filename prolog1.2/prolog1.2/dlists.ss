;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; dlists:  difference lists implemented with pairs.
;;;          A pair is used as a header to point to the first and last
;;;          pair of the dlist.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; test
(define (dlist? x)
  (if (pair? x)
      (if (proper-list? (car x))
          (if (null? (car x))
              (null? (cdr x))
              (eq? (last-pair (car x)) (cdr x)))
          #f)
      #f))

;;; constructors
(define (make-dlist) (cons '() '()))
(define (dlist . l)
  (if (null? l)
      (cons '() '())
      (cons l (last-pair l))))

;;; conversion
(define (list->dlist list)
  (if (null? list)
      (cons '() '())
      (cons list (last-pair list))))
(define dlist->list car)

;;; empty dlist
(define (dlist-empty? dlist) (null? (car dlist)))

;;; add to front
(define (dlist-insert-front! x dlist)
  (if (null? (car dlist))
      (begin
       (set-car! dlist (cons x '()))
       (set-cdr! dlist (car dlist)))
      (set-car! dlist (cons x (car dlist)))))

;;; add to back
(define (dlist-insert-back! x dlist)
  (if (null? (car dlist))
      (begin
       (set-car! dlist (cons x '()))
       (set-cdr! dlist (car dlist)))
      (begin
       (set-cdr! (cdr dlist) (cons x '()))
       (set-cdr! dlist (cddr dlist)))))

;;; add anywhere
(define (dlist-insert-anywhere! x dlist)
	(dlist-insert-front! x dlist))

;;; assumes l is a proper list with at least 2 items in l
(define (list-2nd-last-pair l)
  (if (null? (cddr l)) 
             l
             (list-2nd-last-pair (cdr l))))

;;; delete from front
(define (dlist-delete-front! dlist)
	(cond	((dlist-empty? dlist)
			(error 'dlist-delete-front!
				"attempt to delete from empty list"))
		((null? (cdar dlist))		;;; lone pair in dlist?
			(let	((ret (caar dlist)))
				(set-car! dlist '())
				(set-cdr! dlist '())
				ret))
		(else	(let	((ret (caar dlist)))
				(set-car! dlist (cdar dlist))
				ret))))

;;; delete from back
(define (dlist-delete-back! dlist)
	(cond	((dlist-empty? dlist)
			(error 'dlist-delete-back!
				"attempt to delete from empty dlist"))
		((null? (cdar dlist))
					;;; 1 pair in dlist? return loner!
			(let	((ret (caar dlist)))
				(set-car! dlist '())
				(set-cdr! dlist '())
				ret))
		(else	(let	((ret (cadr dlist)))
				(set-cdr! dlist
					(list-2nd-last-pair (car dlist)))
				(set-cdr! (cdr dlist) '())
				ret))))

;;; deletes x from dlist
(define (dlist-delete! x dlist)
						;;; does not complain if x does
						;;; not exist in dlist
	(define (delete! p1 p2)
		(cond	((null? p2))
			((eq? x (car p2))
				(set-cdr! p1 (cdr p2))
				(if	(null? (cdr p1))
					(set-cdr! dlist p1)))
						;;; p2 pointed to last pair
			(else (delete! p2 (cdr p2)))))

	(cond	((dlist-empty? dlist))
		((null? (cdar dlist))
			(if	(eq? x (caar dlist))
				(begin		;;; delete only element
						;;; same as dlist-delete-front!
					(set-car! dlist '())
					(set-cdr! dlist '()))))
		(else	(if	(eq? x (caar dlist))
						;;; at this stage x cannot be
						;;; the last element in dlist
				(set-car! dlist (cdar dlist))
						;;; delete first element
				(delete! (car dlist) (cdar dlist))))))
						;;; search for x

;;; append two dlists
(define (dlist-append! dlist1 dlist2)
  (set-cdr! (cdr dlist1) (car dlist2))
  (set-cdr! dlist1 (cdr dlist2)))
