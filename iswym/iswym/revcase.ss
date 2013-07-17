;revcase.ss
;Iswym in Scheme
;(c) Dorai Sitaram, Dec. 1992, Rice University
;Previous versions: Apr. 1991, Jan. 1992

;record-evcase

(define-macro! record-evcase (tag . clauses)
  (if (not (or (symbol? tag) (boolean? tag)))
    `(let ((%tmp% ,tag))
       (record-evcase %tmp% ,@clauses))
    (if (null? clauses) `'any
      (let* ((clause (car clauses)) (clauses (cdr clauses))
             (tag2 (car clause)))
        (if (and (null? clauses) (eq? tag2 'else))
          `(begin ,@(cdr clause))
          (if (and (pair? tag2) (eq? (car tag2) 'either))
            `(if (and (pair? ,tag)
                   (or ,@(map (lambda (tag3)
                                `(eqv? (car ,tag) ,tag3))
                            (cdr tag2))))
                (apply (lambda ,@(cdr clause)) (cdr ,tag))
                (record-evcase ,tag ,@clauses))
            `(if (and (pair? ,tag) (eqv? (car ,tag) ,tag2))
               (apply (lambda ,@(cdr clause)) (cdr ,tag))
               (record-evcase ,tag ,@clauses))))))))
