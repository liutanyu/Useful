;;; parser construction
;;; Using List-of-frames representation

;;; #include scan-lof.s

;;; ****************************************************************

;;;    make-lazy-stream : (() -> val * stream) -> stream
;;;    stream-get  : stream * (value -> (stream -> answer)) -> answer

(define make-lazy-stream 
  (lambda (th) th))

(define stream-get
  (lambda (stream rcvr)
    (let ((the-pair (stream)))
      (rcvr (car the-pair) (cdr the-pair)))))

;;; ****************************************************************

(define string->stream
  (lambda (str)
    (let ((length (string-length str)))
      (letrec 
        ((loop (lambda (i)
                 (make-lazy-stream
                   (lambda ()
                     (cons
                       (if (>= i length)
                         #\nul
                         (string-ref str i))
                       (loop (+ i 1))))))))
        (loop 0)))))

;; a better version of stream->list, parameterized on end-of-stream?
(define stream->list
  (lambda (end-of-stream? str)
    (stream-get str
      (lambda (val newstr)
        (if (end-of-stream? val) '()
          (cons val (stream->list end-of-stream? newstr)))))))

;;; ****************************************************************

;;; Scanner architecture

;;; Scanner = char-stream -> token-stream

;;; State = buf * char * char-stream -> token * char * char-stream

(define-record scanner-result (item char stream))

(define *trace-apply-automaton* #f)

(define apply-automaton
  (lambda (automaton state buf c str)
    (letrec 
      ((apply-state
         (lambda (state buf c str)
           (let ((opcode (car state))
                 (next-state (cadr state)))     
             (if *trace-apply-automaton*
               (printf "apply-state: opcode = ~s c = ~s~%" opcode c))
             (case opcode
               ((shift)
                (stream-get str
                  (lambda (c1 str1)
                    (apply-state next-state (cons c buf) c1 str1))))
               ((drop)
                (stream-get str
                  (lambda (c1 str1)
                    (apply-state next-state buf c1 str1))))
               ((emit)
                (let ((cooker (cadr state)))
                  (let ((item (apply-cooker cooker (reverse buf))))
                    '(printf "emitting item ~s~n" item)
                    (make-scanner-result item c str))))
               ((cond)
                (apply-state
                  (apply-scanner-cond (cdr state) c)
                  buf c str))
               ((goto)
                (apply-state
                  (scanner-label->state next-state automaton)
                  buf c str))
               ((fail)
                (let ((msg (cadr state)))
                  (error 'apply-automaton
                    "scanner failed in state ~s on input ~s"
                    msg c)))
               ((debug-state)
                (let ((msg (cadr state))
                      (next-state (caddr state)))
                  (printf "~s ~s ~s~%" msg buf c)
                  (apply-state next-state buf c str))))))))
      (apply-state state buf c str))))  

(define apply-scanner-cond
  (lambda (alternatives c)
    (if (null? alternatives)
      (error 'apply-state
        "couldn't match character ~s in state ~%~s"
        c alternatives)
      (let ((alternative1 (car alternatives)))
        '(printf "apply-scanner-cond: c = ~s alternative = ~s~%"
          c alternative1)
        (if (apply-tester (car alternative1) c)
          (cadr alternative1)
          (apply-scanner-cond (cdr alternatives) c))))))

(define scanner-label->state
  (lambda (label automaton)
    (cadr (assq label automaton))))

(define automaton->start-label caar)

(define automaton->scanner
  (lambda (automaton)
    (letrec
      ((loop (lambda (char stream)
               (make-lazy-stream
                 (lambda ()
                   (record-case
                     (apply-automaton automaton 
                       (scanner-label->state
                         (automaton->start-label automaton) 
                         automaton)
                       '() char stream)
                     (scanner-result (token char stream)
                       (cons token
                             (loop char stream)))))))))
      (lambda (stream)
        (stream-get stream loop)))))
               
;;; driver-1:  from string to list of tokens
(define driver-1 
  (lambda (automaton string)
    (stream->list 
      (lambda (item)
	(record-case item
	  (token (class data) (eq? class 'end-marker))))
      ((automaton->scanner automaton)
       (string->stream string)))))

;;; ****************************************************************

;;; Standard cookers and testers

;;; Record definitions and cookers

(define-record token (class data))

(define cook-identifier
  (lambda (buffer)
    (let ((sym 
            (string->symbol
              (list->string buffer))))
      (if (memq sym **keywords-list**)
        (make-token sym #f)
        (make-token 'identifier sym)))))

(define cook-number
  (lambda (buffer)
    (make-token 'number
      (string->number (list->string buffer)))))

(define apply-cooker
  (lambda (cooker char-list)
    (case cooker
      ((cook-identifier) (cook-identifier char-list))
      ((cook-number) (cook-number char-list))
      (else
	(if (symbol? cooker)
	  (make-token cooker #f)
	  (else (error 'apply-cooker
		  "unknown cooker ~s" cooker)))))))

(define apply-tester
  (lambda (tester ch)
    (cond
      ((char? tester) (eq? tester ch))
      ((eq? tester 'else) #t)
      (else
	(case tester
	  ((whitespace) (char-whitespace? ch))
	  ((alphabetic) (char-alphabetic? ch))
	  ((numeric) (char-numeric? ch))
	  (else (error 'apply-tester "unknown tester ~s" tester)))))))


;;; ****************************************************************

(define automaton-1
  '((start-state 
      (cond
        (whitespace (drop (goto start-state)))
        (alphabetic (shift (goto identifier-state)))
        (numeric (shift (goto number-state)))
        (#\+ (drop (emit plus-sym)))
        (#\: (shift (goto assign-sym-state)))
        (#\% (drop (goto comment-state)))
        (#\; (drop (emit semicolon)))
        (#\( (drop (emit lparen)))
        (#\) (drop (emit rparen)))
        (#\^ (emit end-marker))
        (#\nul (emit end-marker))
        (else (fail start-state))))
    (identifier-state 
      (cond
        (alphabetic (shift (goto identifier-state)))
        (numeric (shift (goto identifier-state)))
        (else (emit cook-identifier))))
    (number-state 
      (cond
        (numeric (shift (goto number-state)))
        (else (emit cook-number))))
    (assign-sym-state
      (cond
        (#\= (shift (emit assign-sym)))
        (else (shift (goto identifier-state)))))
    (comment-state 
      (cond
        (#\newline (drop (goto start-state)))
        (#\^ (goto start-state))
        (#\nul (goto start-state))
        (else (drop (goto comment-state)))))))

(define **keywords-list** '(begin end if then else))

; > (driver-1 automaton-1 "abc
; def
; % comment
; xyz 13")
; emitting item (token identifier abc)
; emitting item (token identifier def)
; emitting item (token identifier xyz)
; emitting item (token number 13)
; emitting item (token end-marker ())
; ((token identifier abc)
;  (token identifier def)
;  (token identifier xyz)
;  (token number 13))


;;; ********* end of scan-ds.s **********************

(define token-stream-get stream-get)

;;; Parser architecture

;;; parser = (list tree) * item * item-stream -> tree * item * item-stream

;;; The item register can either contain an item or '() -- the latter
;;; signifying an empty buffer, to be filled when necessary.

(define-record parser-result (tree item stream))

;;; Grammar of actions:

;;; action :: = ((check/drop class) . action)
;;;             ((check/shift class) . action)
;;;             ((process/nt non-terminal) . action)
;;;             ((reduce prod-name))
;;;             ((emit-list))
;;;             ((goto non-terminal))
;;;             (cond (non-terminal action) ... (else non-terminal))
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
             ((fill-item-register
                (lambda (action)                            
                  ;; here action is internal -- always a function, not
                  ;; a representation
                  '(printf 
                    "starting to fill: buf = ~s item = ~s action = ~s~%"
                    buf item action)
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
             (if (eq? (car action) 'cond)
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
                       buf item stream))))
               ;; otherwise it's an ordinary instruction
               (let ((instruction (car action))
                     (action (cdr action))
                     (whole-action action))
                 (case (car instruction)
                   ((check/drop)
                    (let ((class (cadr instruction)))
                      (parser-check class
                        (lambda (buf item stream)
                          (apply-parser-action action buf '()
                            stream)))))
                   ((check/shift)
                    (let ((class (cadr instruction)))
                      (parser-check class 
                        (lambda (buf item stream)
                          (apply-parser-action action
                            (cons (token->data item) buf) '() stream)))))
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
                   ((process-nt)
                    (let ((non-terminal (cadr instruction)))
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
                   (else
                     (error 'apply-parser-action
                       "unknown action ~s~%" whole-action)))))))))
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

;;
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
          ((check/drop begin)
           (process-nt compound-command)
           (reduce compound-command)))
        (identifier
          ((check/shift identifier)
           (check/drop assign-sym)
           (process-nt expression)
           (reduce assignment)))
        (end
          ((check/drop end)
           (reduce end-marker-command)))
        (else
          ((fail command)))))
    (compound-command
      ((process-nt command)
       (parser-goto compound-command-loop)))
    (compound-command-loop
      (cond
        (semicolon
          ((check/drop semicolon)
           (process-nt command)
           (parser-goto compound-command-loop)))
        (end
          ((check/drop end)
           (emit-list)))
        (else
          ((fail compound-command-loop)))))
    (expression
      (cond
        (identifier
          ((check/shift identifier)
           (reduce var-expression)))
        (number
          ((check/shift number)
           (reduce const-expression)))
        (lparen
          ((check/drop lparen)
           (process-nt expression)
           (check/drop plus-sym)
           (process-nt expression)
           (check/drop rparen)
           (reduce addition-expression)))
        (else
          ((parser-fail expression)))))))

(define string->token-stream
  (lambda (automaton string)
    ((automaton->scanner automaton)
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

