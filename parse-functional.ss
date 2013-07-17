;;; parser construction

;;; functional parsers

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

(define apply-parser-action
  (lambda (action buf item stream)
    (action buf item stream)))

;;; is the item register empty?  if so, fill it by reading a token
;;; from the stream.
;;;
(define fill-item-register
  (lambda (action)
    (lambda (buf item stream)
      (if (null? item)
        (token-stream-get stream
          (lambda (item stream)
            (apply-parser-action action buf item stream)))
        (apply-parser-action action buf item stream)))))

;;; fill the item register and check that its class matches the
;;; specified class.  If not, raise an error, else continue with
;;; action. 
;;;
(define parser-check
  (lambda (class action)
    (fill-item-register
      (lambda (buf item stream)
        '(printf "checking:  looking for class ~s, look at item ~s~%"
           class item)
        (if (eq? class (token->class item))
          (begin
            '(printf "check succeeded: buf = ~s item = ~s~%"
               buf item)
            (apply-parser-action action buf item stream))
          (error 'check
            "looking for ~s, found ~s"
            class item))))))

;; if the next item matches, then drop it, leaving the item register
;; empty. 
;;
(define check/drop
  (lambda (class action)
    (parser-check class
      (lambda (buf item stream)
        (apply-parser-action action buf '() stream)))))

;; if the next item matches, then shift it onto the buffer, again
;; leaving the item register empty.
;;
(define check/shift
  (lambda (class action)
    (parser-check class 
      (lambda (buf item stream)
        (apply-parser-action action (cons item buf) '() stream)))))

(define reduce
  (lambda (prod-name)
    (lambda (buf item stream)
      '(printf "reducing ~s: buf = ~s~%" prod-name buf)
      (make-parser-result
        (apply (make-record-from-name prod-name)
               (reverse buf))
        item
        stream))))

(define emit-list
  (lambda ()
    (lambda (buf item stream)
      '(printf "emit-list: emitting ~s~%" (reverse buf))
      (make-parser-result
        (reverse buf)
        item
        stream))))


(define parser-if
  (lambda (class true-action false-action)
    (fill-item-register
      (lambda (buf item stream)
        (if (eq? class (token->class item))
          (apply-parser-action true-action buf item stream)
          (apply-parser-action false-action buf item stream))))))

(define parser-fail
  (lambda (state)
    (lambda (buf item stream)
      (error 'parser
        "couldn't match token ~s in state:~%~s"
        item state))))

(define parser-goto
  (lambda (action-thunk)
    (lambda (buf item stream)
      (apply-parser-action (action-thunk) buf item stream))))

(define process-nt
  (lambda (action-thunk action)
    (lambda (buf item stream)
      (let ((next-result
              (apply-parser-action (action-thunk)
                '() item stream)))
        (record-case next-result
          (parser-result (tree item stream)
            (apply-parser-action action (cons tree buf) item
              stream))
          (else (error 'process-nt
                  "bad parser-result ~s~%" next-result)))))))

;; get a single parse tree from the token-stream
;;
(define parse-top-level
  (lambda (action token-stream)
    (let ((result 
            (apply-parser-action action '() '() token-stream)))
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
  (lambda (action token-stream)
    (token-stream-get token-stream
      (lambda (item stream)
        (apply-parser-action action
          '() item stream)))))

;;; ****************************************************************

;;; constructors for example

(define-record compound-command (cmd1 cmd2))
(define-record while-command (exp cmd))
(define-record if-command (exp cmd1 cmd2))
(define-record assignment-command (var exp))
(define-record variable-expression (var))
(define-record sum-expression (exp1 exp2))
(define-record end-marker-command ())

(define grammar-1
  (letrec
    ((start-state
       (lambda () (parser-goto command)))
    (command
      (lambda ()
        (parser-if 'begin
          (check/drop 'begin
            (process-nt command
              (check/drop 'semicolon
                (process-nt command
                  (check/drop 'end
                    (reduce 'compound))))))
          (parser-if 'identifier
            (check/shift 'identifier
              (check/drop 'assign-sym  
                (process-nt expression
                  (reduce 'assignment))))
            (parser-if 'end
              (check/drop 'end
                (reduce 'end-marker-command))
              (parser-fail 'command))))))
    (expression
      (lambda ()
        (parser-if 'identifier
          (check/shift 'identifier
            (reduce 'var-expression))
          (parser-if 'number
            (check/shift 'number
              (reduce 'const-expression))
            (parser-if 'lparen
              (check/drop 'lparen
                (process-nt expression
                  (check/drop 'plus-sym
                    (process-nt expression
                      (check/drop 'rparen
                        (reduce 'addition-expression))))))
              (parser-fail 'expression)))))))
    (parser-goto start-state)))


(define **keywords-list** '(begin end))

(define string->token-stream
  (lambda (state string)
    ((state->scanner state)
     (string->stream string))))

(define test1
  (lambda (input-string)
    (parse-top-level grammar-1
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

(define parser-action->stream-transducer
  (lambda (action)
    (letrec
      ((loop (lambda (item token-stream)
               ;; don't actually do anything now!
               (make-lazy-stream
                 (lambda ()
                   (record-case
                     (apply-parser-action action '() item token-stream)
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
  (lambda (parser-action scanner-state)
    (printf "rpp> ")                            ; starting prompt
    (stream-for-each
      (lambda (v) 
        (pretty-print v)                ; print the parse tree
        (printf "rpp> "))               ; prompt for more input
      ((parser-action->stream-transducer parser-action)
       ((state->scanner scanner-state)
        (the-input-stream)))
      end-marker-command?)))

(define test2
  (lambda ()
    (rpp-loop grammar-1 state-1)))

; > (test2)
; rpp> x := y
; rpp: (assignment (token identifier x) (var-expression (token identifier y)))
; rpp> begin x:= y;
; u := (z + t) end
; rpp: (compound (assignment (token identifier x) (var-expression (token identifier y))) (assignment (token identifier u) (addition-expression (var-expression (token identifier z)) (var-expression (token identifier t)))))
; rpp> end
; #f


;; like grammar-1, but uses command := begin command {; command}* end
(define grammar-2
  (letrec
    ((start-state
       (lambda () (parser-goto command)))
    (command
      (lambda ()
        (parser-if 'begin
          (check/drop 'begin
            (process-nt compound-command
              (reduce 'compound-command)))
          (parser-if 'identifier
            (check/shift 'identifier
              (check/drop 'assign-sym  
                (process-nt expression
                  (reduce 'assignment))))
            (parser-if 'end
              (check/drop 'end
                (reduce 'end-marker-command))
              (parser-fail 'command))))))
    (compound-command
      (lambda ()
        ;; put the first command in the buffer, then go to the loop to
        ;; collect more.
        (process-nt command
          (parser-goto compound-command-loop))))
    (compound-command-loop
      (lambda ()
        (parser-if 'semicolon
          (check/drop 'semicolon
            (process-nt command
              (parser-goto compound-command-loop)))
          (check/drop 'end
              (emit-list)))))
    (expression
      (lambda ()
        (parser-if 'identifier
          (check/shift 'identifier
            (reduce 'var-expression))
          (parser-if 'number
            (check/shift 'number
              (reduce 'const-expression))
            (parser-if 'lparen
              (check/drop 'lparen
                (process-nt expression
                  (check/drop 'plus-sym
                    (process-nt expression
                      (check/drop 'rparen
                        (reduce 'addition-expression))))))
              (parser-fail 'expression)))))))
    (parser-goto start-state)))

(define test3
  (lambda ()
    (rpp-loop grammar-2 state-1)))