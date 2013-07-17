;;; parser construction

;;; Using List-of-frames representation

(load "scan.s")

;;; string->stream and stream->list are defined in scan.s

(define token-stream-get stream-get)

;;; ****************************************************************
;;; ****************************************************************

;;; Parser architecture

;;; parser = (list tree) * item * item-stream -> tree * item * item-stream

;;; The item register can either contain an item or '() -- the latter
;;; signifying an empty buffer, to be filled when necessary.

(define-record parser-result (tree item stream))

;;; Grammar of actions:

;;; action :: = (class . action)  [either shift or drop, depending on
;;;                                 data field]
;;;             (non-terminal . action)
;;;             (cond (non-terminal action) ... (else non-terminal))
;;;             ((reduce prod-name))
;;;             ((emit-list))
;;;             ((goto non-terminal))
;;; 
;;; parser ::= ((non-terminal action) ...)

(define *trace-apply-parser* #f)

(define apply-parser
  (lambda (parser action buf item stream)
    (letrec 
      ((apply-parser-action
         (lambda (action buf item stream)
           (if *trace-apply-parser*
             (printf 
               "apply-parser-action: action = ~s~% buf = ~s item = ~s~%"
               action buf item))
           (let*
             ((nonterminals (map car parser))
              (fill-item-register
                (lambda (action)                            
                  ;; here action is internal -- always a function, not
                  ;; a representation
                  (if (null? item)
                    (token-stream-get stream
                      (lambda (item stream)
                        (action buf item stream)))
                    (action buf item stream))))
              (parser-check
                (lambda (class action)
                  ;; action a procedure here too.
                  (fill-item-register 
                    (lambda (buf item stream)
                      '(printf
                         "checking:  looking for class ~s, look at item ~s~%"
                         class item)
                      (if (eq? class (token->class item))
                        (begin
                          '(printf "check succeeded: buf = ~s item = ~s~%"
                             buf item)
                          (action buf item stream))
                        (error 'check
                          "looking for ~s, found ~s"
                          class item)))))))
             (cond
               ((eq? (car action) 'cond)
               ;; it's a cond
                (let ((alternatives (cdr action)))
                  '(printf "it's a cond~%")
                  (fill-item-register 
                    (lambda (buf item stream)
                      '(printf "item filled~%")
                      '(printf "about to apply action ~s~%"
                         (apply-parser-cond alternatives item))
                      (apply-parser-action
                        (apply-parser-cond alternatives item)
                        buf item stream)))))
               ((memq (car action) nonterminals)
                ;; it's a non-terminal:  do process-nt
                (let ((non-terminal (car action))
                      (action (cdr action)))
                  (let ((next-result
                          (apply-parser-action 
                            (cadr (assq non-terminal parser))
                            '() item stream)))
                    (record-case next-result
                      (parser-result (tree item stream)
                        (apply-parser-action action (cons tree buf) item
                          stream))
                      (else (error 'process-nt
                              "bad parser-result ~s~%"
                              next-result))))))
               ((symbol? (car action))
                ;; it's a terminal: check it, then shift or drop
                (let ((class (car action))
                      (action (cdr action)))
                  (parser-check class
                    (lambda (buf item stream)
                      (apply-parser-action action
                        (if (token->data item) 
                          ;; #f is token, everything else is data
                          (cons item buf)
                          buf)
                        '() stream)))))
               (else
                 ;; it must an ordinary instruction
                 (let ((instruction (car action)))
                   (case (car instruction)
                     ((reduce)
                      (let ((prod-name (cadr instruction)))
                        '(printf "reducing ~s: buf = ~s~%" prod-name buf)
                        (make-parser-result
                          (apply (make-record-from-name prod-name)
                                 (reverse buf))
                          item
                          stream)))
                     ((emit-list)
                      '(printf "emit-list: emitting ~s~%" (reverse buf))
                      (make-parser-result
                        (reverse buf)
                        item
                        stream))
                     ((fail)
                      (let ((state (cadr instruction)))
                        (error 'parser
                          "couldn't match token ~s in state:~%~s"
                          item state)))
                     ((parser-goto goto)
                      (let ((non-terminal (cadr instruction)))
                        (apply-parser-action
                          (cadr (assq non-terminal parser))
                          buf item stream)))
                     (else
                       (error 'apply-parser-action
                         "unknown action ~s~%" action))))))))))
  (apply-parser-action action buf item stream))))

(define apply-parser-cond
  (lambda (alternatives item)
    '(printf "apply-parser-cond: alternatives = ~s item = ~s~%"
      alternatives item)
    (if (null? alternatives)
      (error 'apply-parser-cond
        "couldn't match token ~s~%" item)
      (let ((alternative-1 (car alternatives)))
        '(printf "apply-parser-cond: item = ~s alternative = ~s~%"
          item alternative-1)
        (if (or
              (eq? (car alternative-1) (token->class item))
              ;; "else" is always true if it's last alternative
              (and (eq? (car alternative-1) 'else)
                   (null? (cdr alternatives))))
          (cadr alternative-1)
          (apply-parser-cond (cdr alternatives) item))))))

;; new parse-top-level
;;
(define parse-top-level
  (lambda (parser token-stream)
    (let ((result 
            (apply-parser parser '((goto start-state)) '() '() token-stream)))
      '(printf "top-level parse returned.~%")
      '(pretty-print result)
      (record-case result
        (parser-result (tree item stream)
          (let ((item (if (null? item)
                        (token-stream-get stream (lambda (item stream) item))
                        item)))
            (if (eq? (token->class item) 'end-marker)
              tree
              (error 'parse-top-level
                "symbols left over: ~s..."
                item))))
        (else 
          (error 'parse-top-level
            "top-level-parse not a parser-result"))))))

;; a simpler driver
(define simple-parse-top-level
  (lambda (parser token-stream)
    (apply-parser '((goto start-state)) '() '() token-stream)))

;;; ****************************************************************

;;; constructors for example

(define-record compound-command (command-list))
(define-record while-command (exp cmd))
(define-record if-command (exp cmd1 cmd2))
(define-record assignment-command (var exp))
(define-record variable-expression (var))
(define-record sum-expression (exp1 exp2))
(define-record end-marker-command ())

(define **keywords-list** '(begin end))

(define parser-2
  '((start-state
      ((goto command)))
    (command
      (cond
        (begin
          (begin compound-command (reduce compound-command)))
        (identifier
          (identifier assign-sym expression (reduce assignment)))
        (end
          (end (reduce end-marker-command)))
        (else
          ((fail command)))))
    (compound-command
      (command (parser-goto compound-command-loop)))
    (compound-command-loop
      (cond
        (semicolon
          (semicolon command 
            (parser-goto compound-command-loop)))
        (end
          (end (emit-list)))
        (else
          ((fail compound-command-loop)))))
    (expression
      (cond
        (identifier
          (identifier (reduce var-expression)))
        (number
          (number 
            (reduce const-expression)))
        (lparen
          (lparen expression plus-sym expression rparen
            (reduce addition-expression)))
        (else
          ((parser-fail expression)))))))

(define string->token-stream
  (lambda (state string)
    ((state->scanner state)
     (string->stream string))))

(define test1
  (lambda (input-string)
    (parse-top-level parser-2
      (string->token-stream state-1 input-string))))


; > (test1 "x := y")
; (assignment
;    (token identifier x)
;    (var-expression (token identifier y)))
; > (test1 "begin x:=y; x := z end")
; (compound
;    (assignment
;       (token identifier x)
;       (var-expression (token identifier y)))
;    (assignment
;       (token identifier x)
;       (var-expression (token identifier z))))
; > 

;;; ****************************************************************

;;; now let's build read-parse-print loop                       

(define parser->stream-transducer
  (lambda (parser)
    (letrec
      ((loop (lambda (item token-stream)
               ;; don't actually do anything now!
               (make-lazy-stream
                 (lambda ()
                   (record-case
                     (apply-parser parser '((goto start-state))
                       '() item token-stream)
                     (parser-result (tree item token-stream)
                       (cons tree
                             (loop item token-stream)))
                     (else (error 'receiver "oops"))))))))
      (lambda (token-stream)
        ;; start it with the item register empty
        (loop '() token-stream)))))
                   
(define stream-for-each
  (lambda (proc stream end-marker?)
    (stream-get stream
      (lambda (item stream)
        (if (end-marker? item)
          #f
          (begin
            (proc item)
            (stream-for-each proc stream end-marker?)))))))

(define the-input-stream
  (lambda ()
    (make-lazy-stream
      (lambda ()
        (cons (read-char)
              (the-input-stream))))))

(define rpp-loop
  (lambda (parser scanner-state)
    (printf "rpp> ")                            ; starting prompt
    (stream-for-each
      (lambda (v) 
        (pretty-print v)                ; print the parse tree
        (printf "rpp> "))               ; prompt for more input
      ((parser->stream-transducer parser)
       ((state->scanner scanner-state)
        (the-input-stream)))
      end-marker-command?)))

(define test2
  (lambda ()
    (rpp-loop parser-2 state-1)))

; > (test2)
; rpp> x := y
; rpp: (assignment (token identifier x) (var-expression (token identifier y)))
; rpp> begin x:= y;
; u := (z + t) end
; rpp: (compound (assignment (token identifier x) (var-expression (token identifier y))) (assignment (token identifier u) (addition-expression (var-expression (token identifier z)) (var-expression (token identifier t)))))
; rpp> end
; #f


;; like grammar-1, but uses command := begin command {; command}* end
(define test3
  (lambda ()
    (rpp-loop grammar-2 state-1)))

