;;; psyntax.pp
;;; automatically generated from psyntax.ss
;;; Tue May 13 16:56:05 EST 2003
;;; see copyright notice in psyntax.ss

((lambda ()
   (letrec ((noexpand62 '"noexpand")
            (make-syntax-object63
             (lambda (expression930 wrap929)
               (vector 'syntax-object expression930 wrap929)))
            (syntax-object?64
             (lambda (x2039)
               (if (vector? x2039)
                   (if (= (vector-length x2039) '3)
                       (eq? (vector-ref x2039 '0) 'syntax-object)
                       '#f)
                   '#f)))
            (syntax-object-expression65
             (lambda (x931) (vector-ref x931 '1)))
            (syntax-object-wrap66
             (lambda (x2038) (vector-ref x2038 '2)))
            (set-syntax-object-expression!67
             (lambda (x933 update932) (vector-set! x933 '1 update932)))
            (set-syntax-object-wrap!68
             (lambda (x2037 update2036)
               (vector-set! x2037 '2 update2036)))
            (annotation?132 (lambda (x934) '#f))
            (top-level-eval-hook133
             (lambda (x2035) (eval (list noexpand62 x2035))))
            (local-eval-hook134
             (lambda (x935) (eval (list noexpand62 x935))))
            (error-hook135
             (lambda (who2034 why2032 what2033)
               (error who2034 '"~a ~s" why2032 what2033)))
            (put-cte-hook140
             (lambda (symbol937 val936)
               ($sc-put-cte symbol937 val936 '*top*)))
            (get-global-definition-hook141
             (lambda (symbol2031) (getprop symbol2031 '*sc-expander*)))
            (put-global-definition-hook142
             (lambda (symbol939 x938)
               (if (not x938)
                   (remprop symbol939 '*sc-expander*)
                   (putprop symbol939 '*sc-expander* x938))))
            (read-only-binding?143 (lambda (symbol2030) '#f))
            (get-import-binding144
             (lambda (symbol941 token940) (getprop symbol941 token940)))
            (put-import-binding145
             (lambda (symbol2029 token2027 x2028)
               (if (not x2028)
                   (remprop symbol2029 token2027)
                   (putprop symbol2029 token2027 x2028))))
            (generate-id146
             ((lambda (digits942)
                ((lambda (base944 session-key943)
                   (letrec ((make-digit945
                             (lambda (x955) (string-ref digits942 x955)))
                            (fmt946
                             (lambda (n949)
                               ((letrec ((fmt950
                                          (lambda (n952 a951)
                                            (if (< n952 base944)
                                                (list->string
                                                  (cons (make-digit945
                                                          n952)
                                                        a951))
                                                ((lambda (r954 rest953)
                                                   (fmt950
                                                     rest953
                                                     (cons (make-digit945
                                                             r954)
                                                           a951)))
                                                 (modulo n952 base944)
                                                 (quotient
                                                   n952
                                                   base944))))))
                                  fmt950)
                                n949
                                '()))))
                     ((lambda (n947)
                        (lambda (name948)
                          (begin (set! n947 (+ n947 '1))
                                 (string->symbol
                                   (string-append
                                     session-key943
                                     (fmt946 n947))))))
                      '-1)))
                 (string-length digits942)
                 '"_"))
              '"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&*/:<=>?~_^.+-"))
            (built-lambda?229
             (lambda (x2026)
               (if (pair? x2026) (eq? (car x2026) 'lambda) '#f)))
            (build-sequence247
             (lambda (ae957 exps956)
               ((letrec ((loop958
                          (lambda (exps959)
                            (if (null? (cdr exps959))
                                (car exps959)
                                (if (equal? (car exps959) '(void))
                                    (loop958 (cdr exps959))
                                    (cons 'begin exps959))))))
                  loop958)
                exps956)))
            (build-letrec248
             (lambda (ae2025 vars2022 val-exps2024 body-exp2023)
               (if (null? vars2022)
                   body-exp2023
                   (list 'letrec
                         (map list vars2022 val-exps2024)
                         body-exp2023))))
            (build-body249
             (lambda (ae963 vars960 val-exps962 body-exp961)
               (build-letrec248 ae963 vars960 val-exps962 body-exp961)))
            (binding-type291 car)
            (binding-value292 cdr)
            (set-binding-type!293 set-car!)
            (set-binding-value!294 set-cdr!)
            (binding?295
             (lambda (x2021)
               (if (pair? x2021) (symbol? (car x2021)) '#f)))
            (extend-env305
             (lambda (label966 binding964 r965)
               (cons (cons label966 binding964) r965)))
            (extend-env*306
             (lambda (labels2020 bindings2018 r2019)
               (if (null? labels2020)
                   r2019
                   (extend-env*306
                     (cdr labels2020)
                     (cdr bindings2018)
                     (extend-env305
                       (car labels2020)
                       (car bindings2018)
                       r2019)))))
            (extend-var-env*307
             (lambda (labels969 vars967 r968)
               (if (null? labels969)
                   r968
                   (extend-var-env*307
                     (cdr labels969)
                     (cdr vars967)
                     (extend-env305
                       (car labels969)
                       (cons 'lexical (car vars967))
                       r968)))))
            (transformer-env308
             (lambda (r2016)
               (if (null? r2016)
                   '()
                   ((lambda (a2017)
                      (if (memq (cadr a2017) '(lexical syntax))
                          (transformer-env308 (cdr r2016))
                          (cons a2017 (transformer-env308 (cdr r2016)))))
                    (car r2016)))))
            (displaced-lexical?309
             (lambda (id971 r970)
               ((lambda (n972)
                  (if n972
                      ((lambda (b973)
                         (eq? (binding-type291 b973) 'displaced-lexical))
                       (lookup313 n972 r970))
                      '#f))
                (id-var-name431 id971 '(())))))
            (displaced-lexical-error310
             (lambda (id2015)
               (syntax-error
                 id2015
                 (if (id-var-name431 id2015 '(()))
                     '"identifier out of context"
                     '"identifier not visible"))))
            (lookup*311
             (lambda (x975 r974)
               ((lambda (t976)
                  (if t976
                      (cdr t976)
                      (if (symbol? x975)
                          ((lambda (t977)
                             (if t977 t977 (cons 'global x975)))
                           (get-global-definition-hook141 x975))
                          '(displaced-lexical . #f))))
                (assq x975 r974))))
            (sanitize-binding312
             (lambda (b2013)
               (if (procedure? b2013)
                   (cons 'macro b2013)
                   (if (binding?295 b2013)
                       ((lambda (t2014)
                          (if (memv t2014 '(core macro macro!))
                              (if (procedure? (binding-value292 b2013))
                                  b2013
                                  '#f)
                              (if (memv t2014 '($module))
                                  (if (interface?449
                                        (binding-value292 b2013))
                                      b2013
                                      '#f)
                                  b2013)))
                        (binding-type291 b2013))
                       '#f))))
            (lookup313
             (lambda (x979 r978)
               (letrec ((whack-binding!980
                         (lambda (b983 *b982)
                           (begin (set-binding-type!293
                                    b983
                                    (binding-type291 *b982))
                                  (set-binding-value!294
                                    b983
                                    (binding-value292 *b982))))))
                 ((lambda (b981)
                    (begin (if (eq? (binding-type291 b981) 'deferred)
                               (whack-binding!980
                                 b981
                                 (make-transformer-binding314
                                   (binding-value292 b981)))
                               (void))
                           b981))
                  (lookup*311 x979 r978)))))
            (make-transformer-binding314
             (lambda (x2010)
               ((lambda (b2011)
                  ((lambda (t2012)
                     (if t2012
                         t2012
                         (syntax-error b2011 '"invalid transformer")))
                   (sanitize-binding312 b2011)))
                (local-eval-hook134 x2010))))
            (defer-or-eval-transformer315
             (lambda (x984)
               (if (built-lambda?229 x984)
                   (cons 'deferred x984)
                   (make-transformer-binding314 x984))))
            (global-extend316
             (lambda (type2009 sym2007 val2008)
               (put-cte-hook140 sym2007 (cons type2009 val2008))))
            (nonsymbol-id?317
             (lambda (x985)
               (if (syntax-object?64 x985)
                   (symbol?
                     ((lambda (e986)
                        (if (annotation?132 e986)
                            (annotation-expression e986)
                            e986))
                      (syntax-object-expression65 x985)))
                   '#f)))
            (id?318
             (lambda (x2005)
               (if (symbol? x2005)
                   '#t
                   (if (syntax-object?64 x2005)
                       (symbol?
                         ((lambda (e2006)
                            (if (annotation?132 e2006)
                                (annotation-expression e2006)
                                e2006))
                          (syntax-object-expression65 x2005)))
                       (if (annotation?132 x2005)
                           (symbol? (annotation-expression x2005))
                           '#f)))))
            (id-sym-name&marks324
             (lambda (x988 w987)
               (if (syntax-object?64 x988)
                   (values
                     ((lambda (e989)
                        (if (annotation?132 e989)
                            (annotation-expression e989)
                            e989))
                      (syntax-object-expression65 x988))
                     (join-marks421
                       (wrap-marks326 w987)
                       (wrap-marks326 (syntax-object-wrap66 x988))))
                   (values
                     ((lambda (e990)
                        (if (annotation?132 e990)
                            (annotation-expression e990)
                            e990))
                      x988)
                     (wrap-marks326 w987)))))
            (make-wrap325 cons)
            (wrap-marks326 car)
            (wrap-subst327 cdr)
            (set-indirect-label!362
             (lambda (x992 v991)
               (set-indirect-label-label!359 x992 v991)))
            (get-indirect-label361
             (lambda (x2004) (indirect-label-label358 x2004)))
            (gen-indirect-label360
             (lambda () (make-indirect-label356 (gen-label363))))
            (set-indirect-label-label!359
             (lambda (x2003 update2002)
               (vector-set! x2003 '1 update2002)))
            (indirect-label-label358
             (lambda (x993) (vector-ref x993 '1)))
            (indirect-label?357
             (lambda (x2001)
               (if (vector? x2001)
                   (if (= (vector-length x2001) '2)
                       (eq? (vector-ref x2001 '0) 'indirect-label)
                       '#f)
                   '#f)))
            (make-indirect-label356
             (lambda (label994) (vector 'indirect-label label994)))
            (gen-label363 (lambda () (string '#\i)))
            (label?364
             (lambda (x995)
               ((lambda (t996)
                  (if t996
                      t996
                      ((lambda (t997)
                         (if t997 t997 (indirect-label?357 x995)))
                       (symbol? x995))))
                (string? x995))))
            (gen-labels365
             (lambda (ls2000)
               (if (null? ls2000)
                   '()
                   (cons (gen-label363) (gen-labels365 (cdr ls2000))))))
            (make-ribcage366
             (lambda (symnames1000 marks998 labels999)
               (vector 'ribcage symnames1000 marks998 labels999)))
            (ribcage?367
             (lambda (x1999)
               (if (vector? x1999)
                   (if (= (vector-length x1999) '4)
                       (eq? (vector-ref x1999 '0) 'ribcage)
                       '#f)
                   '#f)))
            (ribcage-symnames368 (lambda (x1001) (vector-ref x1001 '1)))
            (ribcage-marks369 (lambda (x1998) (vector-ref x1998 '2)))
            (ribcage-labels370 (lambda (x1002) (vector-ref x1002 '3)))
            (set-ribcage-symnames!371
             (lambda (x1997 update1996)
               (vector-set! x1997 '1 update1996)))
            (set-ribcage-marks!372
             (lambda (x1004 update1003)
               (vector-set! x1004 '2 update1003)))
            (set-ribcage-labels!373
             (lambda (x1995 update1994)
               (vector-set! x1995 '3 update1994)))
            (make-top-ribcage374
             (lambda (key1006 mutable?1005)
               (vector 'top-ribcage key1006 mutable?1005)))
            (top-ribcage?375
             (lambda (x1993)
               (if (vector? x1993)
                   (if (= (vector-length x1993) '3)
                       (eq? (vector-ref x1993 '0) 'top-ribcage)
                       '#f)
                   '#f)))
            (top-ribcage-key376 (lambda (x1007) (vector-ref x1007 '1)))
            (top-ribcage-mutable?377
             (lambda (x1992) (vector-ref x1992 '2)))
            (set-top-ribcage-key!378
             (lambda (x1009 update1008)
               (vector-set! x1009 '1 update1008)))
            (set-top-ribcage-mutable?!379
             (lambda (x1991 update1990)
               (vector-set! x1991 '2 update1990)))
            (make-import-token380
             (lambda (key1010) (vector 'import-token key1010)))
            (import-token?381
             (lambda (x1989)
               (if (vector? x1989)
                   (if (= (vector-length x1989) '2)
                       (eq? (vector-ref x1989 '0) 'import-token)
                       '#f)
                   '#f)))
            (import-token-key382 (lambda (x1011) (vector-ref x1011 '1)))
            (set-import-token-key!383
             (lambda (x1988 update1987)
               (vector-set! x1988 '1 update1987)))
            (make-env384
             (lambda (top-ribcage1013 wrap1012)
               (vector 'env top-ribcage1013 wrap1012)))
            (env?385
             (lambda (x1986)
               (if (vector? x1986)
                   (if (= (vector-length x1986) '3)
                       (eq? (vector-ref x1986 '0) 'env)
                       '#f)
                   '#f)))
            (env-top-ribcage386 (lambda (x1014) (vector-ref x1014 '1)))
            (env-wrap387 (lambda (x1985) (vector-ref x1985 '2)))
            (set-env-top-ribcage!388
             (lambda (x1016 update1015)
               (vector-set! x1016 '1 update1015)))
            (set-env-wrap!389
             (lambda (x1984 update1983)
               (vector-set! x1984 '2 update1983)))
            (anti-mark399
             (lambda (w1017)
               (make-wrap325
                 (cons '#f (wrap-marks326 w1017))
                 (cons 'shift (wrap-subst327 w1017)))))
            (barrier-marker404 '#f)
            (extend-ribcage!409
             (lambda (ribcage1020 id1018 label1019)
               (begin (set-ribcage-symnames!371
                        ribcage1020
                        (cons ((lambda (e1021)
                                 (if (annotation?132 e1021)
                                     (annotation-expression e1021)
                                     e1021))
                               (syntax-object-expression65 id1018))
                              (ribcage-symnames368 ribcage1020)))
                      (set-ribcage-marks!372
                        ribcage1020
                        (cons (wrap-marks326 (syntax-object-wrap66 id1018))
                              (ribcage-marks369 ribcage1020)))
                      (set-ribcage-labels!373
                        ribcage1020
                        (cons label1019
                              (ribcage-labels370 ribcage1020))))))
            (extend-ribcage-barrier!410
             (lambda (ribcage1982 killer-id1981)
               (extend-ribcage-barrier-help!411
                 ribcage1982
                 (syntax-object-wrap66 killer-id1981))))
            (extend-ribcage-barrier-help!411
             (lambda (ribcage1023 wrap1022)
               (begin (set-ribcage-symnames!371
                        ribcage1023
                        (cons barrier-marker404
                              (ribcage-symnames368 ribcage1023)))
                      (set-ribcage-marks!372
                        ribcage1023
                        (cons (wrap-marks326 wrap1022)
                              (ribcage-marks369 ribcage1023))))))
            (extend-ribcage-subst!412
             (lambda (ribcage1980 token1979)
               (set-ribcage-symnames!371
                 ribcage1980
                 (cons (make-import-token380 token1979)
                       (ribcage-symnames368 ribcage1980)))))
            (lookup-import-binding-name413
             (lambda (sym1026 token1024 marks1025)
               ((lambda (new1027)
                  (if new1027
                      ((letrec ((f1028
                                 (lambda (new1029)
                                   (if (pair? new1029)
                                       ((lambda (t1030)
                                          (if t1030
                                              t1030
                                              (f1028 (cdr new1029))))
                                        (f1028 (car new1029)))
                                       (if (symbol? new1029)
                                           (if (same-marks?423
                                                 marks1025
                                                 (wrap-marks326 '((top))))
                                               new1029
                                               '#f)
                                           (if (same-marks?423
                                                 marks1025
                                                 (wrap-marks326
                                                   (syntax-object-wrap66
                                                     new1029)))
                                               new1029
                                               '#f))))))
                         f1028)
                       new1027)
                      '#f))
                (get-import-binding144 sym1026 token1024))))
            (store-import-binding414
             (lambda (id1965 token1964)
               (letrec ((id-marks1966
                         (lambda (id1978)
                           (if (symbol? id1978)
                               (wrap-marks326 '((top)))
                               (wrap-marks326
                                 (syntax-object-wrap66 id1978)))))
                        (cons-id1967
                         (lambda (id1975 x1974)
                           (if (not x1974) id1975 (cons id1975 x1974))))
                        (weed1968
                         (lambda (marks1977 x1976)
                           (if (pair? x1976)
                               (if (same-marks?423
                                     (id-marks1966 (car x1976))
                                     marks1977)
                                   (weed1968 marks1977 (cdr x1976))
                                   (cons-id1967
                                     (car x1976)
                                     (weed1968 marks1977 (cdr x1976))))
                               (if x1976
                                   (if (not (same-marks?423
                                              (id-marks1966 x1976)
                                              marks1977))
                                       x1976
                                       '#f)
                                   '#f)))))
                 ((lambda (sym1970 marks1969)
                    ((lambda (x1971)
                       (put-import-binding145
                         sym1970
                         token1964
                         (if (eq? id1965 sym1970)
                             x1971
                             (cons-id1967
                               (if (same-marks?423
                                     marks1969
                                     (wrap-marks326 '((top))))
                                   (resolved-id-var-name418 id1965)
                                   id1965)
                               x1971))))
                     (weed1968
                       marks1969
                       (get-import-binding144 sym1970 token1964))))
                  ((lambda (x1972)
                     ((lambda (e1973)
                        (if (annotation?132 e1973)
                            (annotation-expression e1973)
                            e1973))
                      (if (syntax-object?64 x1972)
                          (syntax-object-expression65 x1972)
                          x1972)))
                   id1965)
                  (id-marks1966 id1965)))))
            (make-binding-wrap415
             (lambda (ids1033 labels1031 w1032)
               (if (null? ids1033)
                   w1032
                   (make-wrap325
                     (wrap-marks326 w1032)
                     (cons ((lambda (labelvec1034)
                              ((lambda (n1035)
                                 ((lambda (symnamevec1037 marksvec1036)
                                    (begin ((letrec ((f1038
                                                      (lambda (ids1040
                                                               i1039)
                                                        (if (not (null?
                                                                   ids1040))
                                                            (call-with-values
                                                              (lambda ()
                                                                (id-sym-name&marks324
                                                                  (car ids1040)
                                                                  w1032))
                                                              (lambda (symname1042
                                                                       marks1041)
                                                                (begin (vector-set!
                                                                         symnamevec1037
                                                                         i1039
                                                                         symname1042)
                                                                       (vector-set!
                                                                         marksvec1036
                                                                         i1039
                                                                         marks1041)
                                                                       (f1038
                                                                         (cdr ids1040)
                                                                         (+ i1039
                                                                            '1)))))
                                                            (void)))))
                                              f1038)
                                            ids1033
                                            '0)
                                           (make-ribcage366
                                             symnamevec1037
                                             marksvec1036
                                             labelvec1034)))
                                  (make-vector n1035)
                                  (make-vector n1035)))
                               (vector-length labelvec1034)))
                            (list->vector labels1031))
                           (wrap-subst327 w1032))))))
            (make-resolved-id416
             (lambda (fromsym1963 marks1961 tosym1962)
               (make-syntax-object63
                 fromsym1963
                 (make-wrap325
                   marks1961
                   (list (make-ribcage366
                           (vector fromsym1963)
                           (vector marks1961)
                           (vector tosym1962)))))))
            (id->resolved-id417
             (lambda (id1043)
               (call-with-values
                 (lambda () (id-var-name&marks429 id1043 '(())))
                 (lambda (tosym1045 marks1044)
                   (begin (if (not tosym1045)
                              (syntax-error
                                id1043
                                '"identifier not visible for export")
                              (void))
                          (make-resolved-id416
                            ((lambda (x1046)
                               ((lambda (e1047)
                                  (if (annotation?132 e1047)
                                      (annotation-expression e1047)
                                      e1047))
                                (if (syntax-object?64 x1046)
                                    (syntax-object-expression65 x1046)
                                    x1046)))
                             id1043)
                            marks1044
                            tosym1045))))))
            (resolved-id-var-name418
             (lambda (id1960)
               (vector-ref
                 (ribcage-labels370
                   (car (wrap-subst327 (syntax-object-wrap66 id1960))))
                 '0)))
            (smart-append419
             (lambda (m11049 m21048)
               (if (null? m21048) m11049 (append m11049 m21048))))
            (join-wraps420
             (lambda (w11957 w21956)
               ((lambda (m11959 s11958)
                  (if (null? m11959)
                      (if (null? s11958)
                          w21956
                          (make-wrap325
                            (wrap-marks326 w21956)
                            (join-subst422 s11958 (wrap-subst327 w21956))))
                      (make-wrap325
                        (join-marks421 m11959 (wrap-marks326 w21956))
                        (join-subst422 s11958 (wrap-subst327 w21956)))))
                (wrap-marks326 w11957)
                (wrap-subst327 w11957))))
            (join-marks421
             (lambda (m11051 m21050) (smart-append419 m11051 m21050)))
            (join-subst422
             (lambda (s11955 s21954) (smart-append419 s11955 s21954)))
            (same-marks?423
             (lambda (x1053 y1052)
               ((lambda (t1054)
                  (if t1054
                      t1054
                      (if (not (null? x1053))
                          (if (not (null? y1052))
                              (if (eq? (car x1053) (car y1052))
                                  (same-marks?423 (cdr x1053) (cdr y1052))
                                  '#f)
                              '#f)
                          '#f)))
                (eq? x1053 y1052))))
            (top-id-free-var-name427
             (lambda (sym1949 marks1947 top-ribcage1948)
               ((lambda (token1950)
                  ((lambda (t1951)
                     (if t1951
                         ((lambda (id1952)
                            (if (symbol? id1952)
                                id1952
                                (resolved-id-var-name418 id1952)))
                          t1951)
                         (if (if (top-ribcage-mutable?377 top-ribcage1948)
                                 (same-marks?423
                                   marks1947
                                   (wrap-marks326 '((top))))
                                 '#f)
                             (if (leave-implicit?424 token1950)
                                 sym1949
                                 ((lambda (g1953)
                                    (begin (store-import-binding414
                                             (make-resolved-id416
                                               sym1949
                                               (wrap-marks326 '((top)))
                                               g1953)
                                             token1950)
                                           g1953))
                                  (generate-id146 sym1949)))
                             '#f)))
                   (lookup-import-binding-name413
                     sym1949
                     token1950
                     marks1947)))
                (top-ribcage-key376 top-ribcage1948))))
            (top-id-bound-var-name426
             (lambda (sym1057 marks1055 top-ribcage1056)
               ((lambda (token1058)
                  ((lambda (t1059)
                     (if t1059
                         ((lambda (id1060)
                            (call-with-values
                              (lambda ()
                                (if (symbol? id1060)
                                    (values
                                      id1060
                                      (make-resolved-id416
                                        sym1057
                                        marks1055
                                        id1060))
                                    (values
                                      (resolved-id-var-name418 id1060)
                                      id1060)))
                              (lambda (valsym1062 id1061)
                                (if (if (read-only-binding?143 valsym1062)
                                        (same-marks?423
                                          marks1055
                                          (wrap-marks326 '((top))))
                                        '#f)
                                    (new-binding425
                                      sym1057
                                      marks1055
                                      token1058)
                                    (values valsym1062 id1061)))))
                          t1059)
                         (if (if (leave-implicit?424 token1058)
                                 (if (same-marks?423
                                       marks1055
                                       (wrap-marks326 '((top))))
                                     (not (read-only-binding?143 sym1057))
                                     '#f)
                                 '#f)
                             (values sym1057 sym1057)
                             (new-binding425
                               sym1057
                               marks1055
                               token1058))))
                   (lookup-import-binding-name413
                     sym1057
                     token1058
                     marks1055)))
                (top-ribcage-key376 top-ribcage1056))))
            (new-binding425
             (lambda (sym1944 marks1942 token1943)
               ((lambda (g1945)
                  ((lambda (id1946)
                     (begin (store-import-binding414 id1946 token1943)
                            (values g1945 id1946)))
                   (make-resolved-id416 sym1944 marks1942 g1945)))
                (generate-id146 sym1944))))
            (leave-implicit?424
             (lambda (token1063) (eq? token1063 '*top*)))
            (id-var-name-loc&marks428
             (lambda (id1907 w1906)
               (letrec ((search1908
                         (lambda (sym1937 subst1935 marks1936)
                           (if (null? subst1935)
                               (values '#f marks1936)
                               ((lambda (fst1938)
                                  (if (eq? fst1938 'shift)
                                      (search1908
                                        sym1937
                                        (cdr subst1935)
                                        (cdr marks1936))
                                      (if (ribcage?367 fst1938)
                                          ((lambda (symnames1939)
                                             (if (vector? symnames1939)
                                                 (search-vector-rib1910
                                                   sym1937
                                                   subst1935
                                                   marks1936
                                                   symnames1939
                                                   fst1938)
                                                 (search-list-rib1909
                                                   sym1937
                                                   subst1935
                                                   marks1936
                                                   symnames1939
                                                   fst1938)))
                                           (ribcage-symnames368 fst1938))
                                          (if (top-ribcage?375 fst1938)
                                              ((lambda (t1940)
                                                 (if t1940
                                                     ((lambda (var-name1941)
                                                        (values
                                                          var-name1941
                                                          marks1936))
                                                      t1940)
                                                     (search1908
                                                       sym1937
                                                       (cdr subst1935)
                                                       marks1936)))
                                               (top-id-free-var-name427
                                                 sym1937
                                                 marks1936
                                                 fst1938))
                                              (error 'sc-expand
                                                '"internal error in id-var-name-loc&marks: improper subst ~s"
                                                subst1935)))))
                                (car subst1935)))))
                        (search-list-rib1909
                         (lambda (sym1921
                                  subst1917
                                  marks1920
                                  symnames1918
                                  ribcage1919)
                           ((letrec ((f1922
                                      (lambda (symnames1924 i1923)
                                        (if (null? symnames1924)
                                            (search1908
                                              sym1921
                                              (cdr subst1917)
                                              marks1920)
                                            (if (if (eq? (car symnames1924)
                                                         sym1921)
                                                    (same-marks?423
                                                      marks1920
                                                      (list-ref
                                                        (ribcage-marks369
                                                          ribcage1919)
                                                        i1923))
                                                    '#f)
                                                (values
                                                  (list-ref
                                                    (ribcage-labels370
                                                      ribcage1919)
                                                    i1923)
                                                  marks1920)
                                                (if (import-token?381
                                                      (car symnames1924))
                                                    ((lambda (t1925)
                                                       (if t1925
                                                           ((lambda (id1926)
                                                              (values
                                                                (if (symbol?
                                                                      id1926)
                                                                    id1926
                                                                    (resolved-id-var-name418
                                                                      id1926))
                                                                marks1920))
                                                            t1925)
                                                           (f1922
                                                             (cdr symnames1924)
                                                             i1923)))
                                                     (lookup-import-binding-name413
                                                       sym1921
                                                       (import-token-key382
                                                         (car symnames1924))
                                                       marks1920))
                                                    (if (if (eq? (car symnames1924)
                                                                 barrier-marker404)
                                                            (same-marks?423
                                                              marks1920
                                                              (list-ref
                                                                (ribcage-marks369
                                                                  ribcage1919)
                                                                i1923))
                                                            '#f)
                                                        (values
                                                          '#f
                                                          marks1920)
                                                        (f1922
                                                          (cdr symnames1924)
                                                          (+ i1923
                                                             '1)))))))))
                              f1922)
                            symnames1918
                            '0)))
                        (search-vector-rib1910
                         (lambda (sym1931
                                  subst1927
                                  marks1930
                                  symnames1928
                                  ribcage1929)
                           ((lambda (n1932)
                              ((letrec ((f1933
                                         (lambda (i1934)
                                           (if (= i1934 n1932)
                                               (search1908
                                                 sym1931
                                                 (cdr subst1927)
                                                 marks1930)
                                               (if (if (eq? (vector-ref
                                                              symnames1928
                                                              i1934)
                                                            sym1931)
                                                       (same-marks?423
                                                         marks1930
                                                         (vector-ref
                                                           (ribcage-marks369
                                                             ribcage1929)
                                                           i1934))
                                                       '#f)
                                                   (values
                                                     (vector-ref
                                                       (ribcage-labels370
                                                         ribcage1929)
                                                       i1934)
                                                     marks1930)
                                                   (f1933 (+ i1934 '1)))))))
                                 f1933)
                               '0))
                            (vector-length symnames1928)))))
                 (if (symbol? id1907)
                     (search1908
                       id1907
                       (wrap-subst327 w1906)
                       (wrap-marks326 w1906))
                     (if (syntax-object?64 id1907)
                         ((lambda (sym1912 w11911)
                            (call-with-values
                              (lambda ()
                                (search1908
                                  sym1912
                                  (wrap-subst327 w1906)
                                  (join-marks421
                                    (wrap-marks326 w1906)
                                    (wrap-marks326 w11911))))
                              (lambda (name1914 marks1913)
                                (if name1914
                                    (values name1914 marks1913)
                                    (search1908
                                      sym1912
                                      (wrap-subst327 w11911)
                                      marks1913)))))
                          ((lambda (e1915)
                             (if (annotation?132 e1915)
                                 (annotation-expression e1915)
                                 e1915))
                           (syntax-object-expression65 id1907))
                          (syntax-object-wrap66 id1907))
                         (if (annotation?132 id1907)
                             (search1908
                               ((lambda (e1916)
                                  (if (annotation?132 e1916)
                                      (annotation-expression e1916)
                                      e1916))
                                id1907)
                               (wrap-subst327 w1906)
                               (wrap-marks326 w1906))
                             (error-hook135
                               'id-var-name
                               '"invalid id"
                               id1907)))))))
            (id-var-name&marks429
             (lambda (id1065 w1064)
               (call-with-values
                 (lambda () (id-var-name-loc&marks428 id1065 w1064))
                 (lambda (label1067 marks1066)
                   (values
                     (if (indirect-label?357 label1067)
                         (get-indirect-label361 label1067)
                         label1067)
                     marks1066)))))
            (id-var-name-loc430
             (lambda (id1903 w1902)
               (call-with-values
                 (lambda () (id-var-name-loc&marks428 id1903 w1902))
                 (lambda (label1905 marks1904) label1905))))
            (id-var-name431
             (lambda (id1069 w1068)
               (call-with-values
                 (lambda () (id-var-name-loc&marks428 id1069 w1068))
                 (lambda (label1071 marks1070)
                   (if (indirect-label?357 label1071)
                       (get-indirect-label361 label1071)
                       label1071)))))
            (free-id=?432
             (lambda (i1897 j1896)
               (if (eq? ((lambda (x1900)
                           ((lambda (e1901)
                              (if (annotation?132 e1901)
                                  (annotation-expression e1901)
                                  e1901))
                            (if (syntax-object?64 x1900)
                                (syntax-object-expression65 x1900)
                                x1900)))
                         i1897)
                        ((lambda (x1898)
                           ((lambda (e1899)
                              (if (annotation?132 e1899)
                                  (annotation-expression e1899)
                                  e1899))
                            (if (syntax-object?64 x1898)
                                (syntax-object-expression65 x1898)
                                x1898)))
                         j1896))
                   (eq? (id-var-name431 i1897 '(()))
                        (id-var-name431 j1896 '(())))
                   '#f)))
            (literal-id=?433
             (lambda (id1073 literal1072)
               (if (eq? ((lambda (x1076)
                           ((lambda (e1077)
                              (if (annotation?132 e1077)
                                  (annotation-expression e1077)
                                  e1077))
                            (if (syntax-object?64 x1076)
                                (syntax-object-expression65 x1076)
                                x1076)))
                         id1073)
                        ((lambda (x1074)
                           ((lambda (e1075)
                              (if (annotation?132 e1075)
                                  (annotation-expression e1075)
                                  e1075))
                            (if (syntax-object?64 x1074)
                                (syntax-object-expression65 x1074)
                                x1074)))
                         literal1072))
                   ((lambda (n-id1079 n-literal1078)
                      ((lambda (t1080)
                         (if t1080
                             t1080
                             (if ((lambda (t1081)
                                    (if t1081 t1081 (symbol? n-id1079)))
                                  (not n-id1079))
                                 ((lambda (t1082)
                                    (if t1082
                                        t1082
                                        (symbol? n-literal1078)))
                                  (not n-literal1078))
                                 '#f)))
                       (eq? n-id1079 n-literal1078)))
                    (id-var-name431 id1073 '(()))
                    (id-var-name431 literal1072 '(())))
                   '#f)))
            (bound-id=?434
             (lambda (i1891 j1890)
               (if (if (syntax-object?64 i1891)
                       (syntax-object?64 j1890)
                       '#f)
                   (if (eq? ((lambda (e1893)
                               (if (annotation?132 e1893)
                                   (annotation-expression e1893)
                                   e1893))
                             (syntax-object-expression65 i1891))
                            ((lambda (e1892)
                               (if (annotation?132 e1892)
                                   (annotation-expression e1892)
                                   e1892))
                             (syntax-object-expression65 j1890)))
                       (same-marks?423
                         (wrap-marks326 (syntax-object-wrap66 i1891))
                         (wrap-marks326 (syntax-object-wrap66 j1890)))
                       '#f)
                   (eq? ((lambda (e1895)
                           (if (annotation?132 e1895)
                               (annotation-expression e1895)
                               e1895))
                         i1891)
                        ((lambda (e1894)
                           (if (annotation?132 e1894)
                               (annotation-expression e1894)
                               e1894))
                         j1890)))))
            (valid-bound-ids?435
             (lambda (ids1083)
               (if ((letrec ((all-ids?1084
                              (lambda (ids1085)
                                ((lambda (t1086)
                                   (if t1086
                                       t1086
                                       (if (id?318 (car ids1085))
                                           (all-ids?1084 (cdr ids1085))
                                           '#f)))
                                 (null? ids1085)))))
                      all-ids?1084)
                    ids1083)
                   (distinct-bound-ids?436 ids1083)
                   '#f)))
            (distinct-bound-ids?436
             (lambda (ids1886)
               ((letrec ((distinct?1887
                          (lambda (ids1888)
                            ((lambda (t1889)
                               (if t1889
                                   t1889
                                   (if (not (bound-id-member?438
                                              (car ids1888)
                                              (cdr ids1888)))
                                       (distinct?1887 (cdr ids1888))
                                       '#f)))
                             (null? ids1888)))))
                  distinct?1887)
                ids1886)))
            (invalid-ids-error437
             (lambda (ids1089 exp1087 class1088)
               ((letrec ((find1090
                          (lambda (ids1092 gooduns1091)
                            (if (null? ids1092)
                                (syntax-error exp1087)
                                (if (id?318 (car ids1092))
                                    (if (bound-id-member?438
                                          (car ids1092)
                                          gooduns1091)
                                        (syntax-error
                                          (car ids1092)
                                          '"duplicate "
                                          class1088)
                                        (find1090
                                          (cdr ids1092)
                                          (cons (car ids1092)
                                                gooduns1091)))
                                    (syntax-error
                                      (car ids1092)
                                      '"invalid "
                                      class1088))))))
                  find1090)
                ids1089
                '())))
            (bound-id-member?438
             (lambda (x1884 list1883)
               (if (not (null? list1883))
                   ((lambda (t1885)
                      (if t1885
                          t1885
                          (bound-id-member?438 x1884 (cdr list1883))))
                    (bound-id=?434 x1884 (car list1883)))
                   '#f)))
            (wrap439
             (lambda (x1094 w1093)
               (if (if (null? (wrap-marks326 w1093))
                       (null? (wrap-subst327 w1093))
                       '#f)
                   x1094
                   (if (syntax-object?64 x1094)
                       (make-syntax-object63
                         (syntax-object-expression65 x1094)
                         (join-wraps420
                           w1093
                           (syntax-object-wrap66 x1094)))
                       (if (null? x1094)
                           x1094
                           (make-syntax-object63 x1094 w1093))))))
            (source-wrap440
             (lambda (x1882 w1880 ae1881)
               (wrap439
                 (if (annotation?132 ae1881)
                     (begin (if (not (eq? (annotation-expression ae1881)
                                          x1882))
                                (error 'sc-expand
                                  '"internal error in source-wrap: ae/x mismatch")
                                (void))
                            ae1881)
                     x1882)
                 w1880)))
            (chi-sequence441
             (lambda (body1098 r1095 w1097 ae1096)
               (build-sequence247
                 ae1096
                 ((letrec ((dobody1099
                            (lambda (body1102 r1100 w1101)
                              (if (null? body1102)
                                  '()
                                  ((lambda (first1103)
                                     (cons first1103
                                           (dobody1099
                                             (cdr body1102)
                                             r1100
                                             w1101)))
                                   (chi481 (car body1102) r1100 w1101))))))
                    dobody1099)
                  body1098
                  r1095
                  w1097))))
            (chi-top-sequence442
             (lambda (body1872
                      r1866
                      w1871
                      ae1867
                      ctem1870
                      rtem1868
                      ribcage1869)
               (build-sequence247
                 ae1867
                 ((letrec ((dobody1873
                            (lambda (body1878
                                     r1874
                                     w1877
                                     ctem1875
                                     rtem1876)
                              (if (null? body1878)
                                  '()
                                  ((lambda (first1879)
                                     (cons first1879
                                           (dobody1873
                                             (cdr body1878)
                                             r1874
                                             w1877
                                             ctem1875
                                             rtem1876)))
                                   (chi-top446
                                     (car body1878)
                                     r1874
                                     w1877
                                     ctem1875
                                     rtem1876
                                     ribcage1869))))))
                    dobody1873)
                  body1872
                  r1866
                  w1871
                  ctem1870
                  rtem1868))))
            (chi-when-list443
             (lambda (when-list1105 w1104)
               (map (lambda (x1106)
                      (if (literal-id=?433
                            x1106
                            '#(syntax-object compile ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                          'compile
                          (if (literal-id=?433
                                x1106
                                '#(syntax-object load ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                              'load
                              (if (literal-id=?433
                                    x1106
                                    '#(syntax-object visit ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                  'visit
                                  (if (literal-id=?433
                                        x1106
                                        '#(syntax-object revisit ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                      'revisit
                                      (if (literal-id=?433
                                            x1106
                                            '#(syntax-object eval ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                          'eval
                                          (syntax-error
                                            (wrap439 x1106 w1104)
                                            '"invalid eval-when situation")))))))
                    when-list1105)))
            (syntax-type444
             (lambda (e1851 r1847 w1850 ae1848 rib1849)
               (if (symbol? e1851)
                   ((lambda (n1852)
                      ((lambda (b1853)
                         ((lambda (type1854)
                            ((lambda ()
                               ((lambda (t1855)
                                  (if (memv t1855 '(lexical))
                                      (values
                                        type1854
                                        (binding-value292 b1853)
                                        e1851
                                        w1850
                                        ae1848)
                                      (if (memv t1855 '(global))
                                          (values
                                            type1854
                                            (binding-value292 b1853)
                                            e1851
                                            w1850
                                            ae1848)
                                          (if (memv t1855 '(macro macro!))
                                              (syntax-type444
                                                (chi-macro485
                                                  (binding-value292 b1853)
                                                  e1851
                                                  r1847
                                                  w1850
                                                  ae1848
                                                  rib1849)
                                                r1847
                                                '(())
                                                '#f
                                                rib1849)
                                              (values
                                                type1854
                                                (binding-value292 b1853)
                                                e1851
                                                w1850
                                                ae1848)))))
                                type1854))))
                          (binding-type291 b1853)))
                       (lookup313 n1852 r1847)))
                    (id-var-name431 e1851 w1850))
                   (if (pair? e1851)
                       ((lambda (first1856)
                          (if (id?318 first1856)
                              ((lambda (n1857)
                                 ((lambda (b1858)
                                    ((lambda (type1859)
                                       ((lambda ()
                                          ((lambda (t1860)
                                             (if (memv t1860 '(lexical))
                                                 (values
                                                   'lexical-call
                                                   (binding-value292 b1858)
                                                   e1851
                                                   w1850
                                                   ae1848)
                                                 (if (memv t1860
                                                           '(macro macro!))
                                                     (syntax-type444
                                                       (chi-macro485
                                                         (binding-value292
                                                           b1858)
                                                         e1851
                                                         r1847
                                                         w1850
                                                         ae1848
                                                         rib1849)
                                                       r1847
                                                       '(())
                                                       '#f
                                                       rib1849)
                                                     (if (memv t1860
                                                               '(core))
                                                         (values
                                                           type1859
                                                           (binding-value292
                                                             b1858)
                                                           e1851
                                                           w1850
                                                           ae1848)
                                                         (if (memv t1860
                                                                   '(local-syntax))
                                                             (values
                                                               'local-syntax-form
                                                               (binding-value292
                                                                 b1858)
                                                               e1851
                                                               w1850
                                                               ae1848)
                                                             (if (memv t1860
                                                                       '(begin))
                                                                 (values
                                                                   'begin-form
                                                                   '#f
                                                                   e1851
                                                                   w1850
                                                                   ae1848)
                                                                 (if (memv t1860
                                                                           '(eval-when))
                                                                     (values
                                                                       'eval-when-form
                                                                       '#f
                                                                       e1851
                                                                       w1850
                                                                       ae1848)
                                                                     (if (memv t1860
                                                                               '(define))
                                                                         (values
                                                                           'define-form
                                                                           '#f
                                                                           e1851
                                                                           w1850
                                                                           ae1848)
                                                                         (if (memv t1860
                                                                                   '(define-syntax))
                                                                             (values
                                                                               'define-syntax-form
                                                                               '#f
                                                                               e1851
                                                                               w1850
                                                                               ae1848)
                                                                             (if (memv t1860
                                                                                       '($module-key))
                                                                                 (values
                                                                                   '$module-form
                                                                                   '#f
                                                                                   e1851
                                                                                   w1850
                                                                                   ae1848)
                                                                                 (if (memv t1860
                                                                                           '($import))
                                                                                     (values
                                                                                       '$import-form
                                                                                       (binding-value292
                                                                                         b1858)
                                                                                       e1851
                                                                                       w1850
                                                                                       ae1848)
                                                                                     (if (memv t1860
                                                                                               '(set!))
                                                                                         (chi-set!484
                                                                                           e1851
                                                                                           r1847
                                                                                           w1850
                                                                                           ae1848
                                                                                           rib1849)
                                                                                         (values
                                                                                           'call
                                                                                           '#f
                                                                                           e1851
                                                                                           w1850
                                                                                           ae1848)))))))))))))
                                           type1859))))
                                     (binding-type291 b1858)))
                                  (lookup313 n1857 r1847)))
                               (id-var-name431 first1856 w1850))
                              (values 'call '#f e1851 w1850 ae1848)))
                        (car e1851))
                       (if (syntax-object?64 e1851)
                           (syntax-type444
                             (syntax-object-expression65 e1851)
                             r1847
                             (join-wraps420
                               w1850
                               (syntax-object-wrap66 e1851))
                             '#f
                             rib1849)
                           (if (annotation?132 e1851)
                               (syntax-type444
                                 (annotation-expression e1851)
                                 r1847
                                 w1850
                                 e1851
                                 rib1849)
                               (if ((lambda (x1861)
                                      ((lambda (t1862)
                                         (if t1862
                                             t1862
                                             ((lambda (t1863)
                                                (if t1863
                                                    t1863
                                                    ((lambda (t1864)
                                                       (if t1864
                                                           t1864
                                                           ((lambda (t1865)
                                                              (if t1865
                                                                  t1865
                                                                  (null?
                                                                    x1861)))
                                                            (char?
                                                              x1861))))
                                                     (string? x1861))))
                                              (number? x1861))))
                                       (boolean? x1861)))
                                    e1851)
                                   (values
                                     'constant
                                     '#f
                                     e1851
                                     w1850
                                     ae1848)
                                   (values
                                     'other
                                     '#f
                                     e1851
                                     w1850
                                     ae1848))))))))
            (chi-top-expr445
             (lambda (e1110 r1107 w1109 top-ribcage1108)
               (call-with-values
                 (lambda ()
                   (syntax-type444 e1110 r1107 w1109 '#f top-ribcage1108))
                 (lambda (type1115 value1111 e1114 w1112 ae1113)
                   (chi-expr482
                     type1115
                     value1111
                     e1114
                     r1107
                     w1112
                     ae1113)))))
            (chi-top446
             (lambda (e1788
                      r1783
                      w1787
                      ctem1784
                      rtem1786
                      top-ribcage1785)
               (call-with-values
                 (lambda ()
                   (syntax-type444 e1788 r1783 w1787 '#f top-ribcage1785))
                 (lambda (type1793 value1789 e1792 w1790 ae1791)
                   ((lambda (t1794)
                      (if (memv t1794 '(begin-form))
                          ((lambda (tmp1795)
                             ((lambda (tmp1796)
                                (if tmp1796
                                    (apply
                                      (lambda (_1797) (chi-void495))
                                      tmp1796)
                                    ((lambda (tmp1798)
                                       (if tmp1798
                                           (apply
                                             (lambda (_1801 e11799 e21800)
                                               (chi-top-sequence442
                                                 (cons e11799 e21800)
                                                 r1783
                                                 w1790
                                                 ae1791
                                                 ctem1784
                                                 rtem1786
                                                 top-ribcage1785))
                                             tmp1798)
                                           (syntax-error tmp1795)))
                                     ($syntax-dispatch
                                       tmp1795
                                       '(any any . each-any)))))
                              ($syntax-dispatch tmp1795 '(any))))
                           e1792)
                          (if (memv t1794 '(local-syntax-form))
                              (chi-local-syntax494
                                value1789
                                e1792
                                r1783
                                w1790
                                ae1791
                                (lambda (body1806 r1803 w1805 ae1804)
                                  (chi-top-sequence442
                                    body1806
                                    r1803
                                    w1805
                                    ae1804
                                    ctem1784
                                    rtem1786
                                    top-ribcage1785)))
                              (if (memv t1794 '(eval-when-form))
                                  ((lambda (tmp1807)
                                     ((lambda (tmp1808)
                                        (if tmp1808
                                            (apply
                                              (lambda (_1812
                                                       x1809
                                                       e11811
                                                       e21810)
                                                ((lambda (when-list1814
                                                          body1813)
                                                   ((lambda (ctem1816
                                                             rtem1815)
                                                      (if (if (null?
                                                                ctem1816)
                                                              (null?
                                                                rtem1815)
                                                              '#f)
                                                          (chi-void495)
                                                          (chi-top-sequence442
                                                            body1813
                                                            r1783
                                                            w1790
                                                            ae1791
                                                            ctem1816
                                                            rtem1815
                                                            top-ribcage1785)))
                                                    (update-mode-set477
                                                      when-list1814
                                                      ctem1784)
                                                    (update-mode-set477
                                                      when-list1814
                                                      rtem1786)))
                                                 (chi-when-list443
                                                   x1809
                                                   w1790)
                                                 (cons e11811 e21810)))
                                              tmp1808)
                                            (syntax-error tmp1807)))
                                      ($syntax-dispatch
                                        tmp1807
                                        '(any each-any any . each-any))))
                                   e1792)
                                  (if (memv t1794 '(define-syntax-form))
                                      (parse-define-syntax492
                                        e1792
                                        w1790
                                        ae1791
                                        (lambda (id1821 rhs1819 w1820)
                                          ((lambda (id1822)
                                             (begin (if (displaced-lexical?309
                                                          id1822
                                                          r1783)
                                                        (displaced-lexical-error310
                                                          id1822)
                                                        (void))
                                                    (if (not (top-ribcage-mutable?377
                                                               top-ribcage1785))
                                                        (syntax-error
                                                          (source-wrap440
                                                            e1792
                                                            w1820
                                                            ae1791)
                                                          '"invalid definition in read-only environment")
                                                        (void))
                                                    ((lambda (sym1823)
                                                       (call-with-values
                                                         (lambda ()
                                                           (top-id-bound-var-name426
                                                             sym1823
                                                             (wrap-marks326
                                                               (syntax-object-wrap66
                                                                 id1822))
                                                             top-ribcage1785))
                                                         (lambda (valsym1825
                                                                  bound-id1824)
                                                           (begin (if (not (eq? (id-var-name431
                                                                                  id1822
                                                                                  '(()))
                                                                                valsym1825))
                                                                      (syntax-error
                                                                        (source-wrap440
                                                                          e1792
                                                                          w1820
                                                                          ae1791)
                                                                        '"definition not permitted")
                                                                      (void))
                                                                  (if (read-only-binding?143
                                                                        valsym1825)
                                                                      (syntax-error
                                                                        (source-wrap440
                                                                          e1792
                                                                          w1820
                                                                          ae1791)
                                                                        '"invalid definition of read-only identifier")
                                                                      (void))
                                                                  (ct-eval/residualize480
                                                                    ctem1784
                                                                    (lambda ()
                                                                      (list '$sc-put-cte
                                                                            (list 'quote
                                                                                  bound-id1824)
                                                                            (chi481
                                                                              rhs1819
                                                                              (transformer-env308
                                                                                r1783)
                                                                              w1820)
                                                                            (list 'quote
                                                                                  (top-ribcage-key376
                                                                                    top-ribcage1785)))))))))
                                                     ((lambda (x1826)
                                                        ((lambda (e1827)
                                                           (if (annotation?132
                                                                 e1827)
                                                               (annotation-expression
                                                                 e1827)
                                                               e1827))
                                                         (if (syntax-object?64
                                                               x1826)
                                                             (syntax-object-expression65
                                                               x1826)
                                                             x1826)))
                                                      id1822))))
                                           (wrap439 id1821 w1820))))
                                      (if (memv t1794 '(define-form))
                                          (parse-define491
                                            e1792
                                            w1790
                                            ae1791
                                            (lambda (id1830 rhs1828 w1829)
                                              ((lambda (id1831)
                                                 (begin (if (displaced-lexical?309
                                                              id1831
                                                              r1783)
                                                            (displaced-lexical-error310
                                                              id1831)
                                                            (void))
                                                        (if (not (top-ribcage-mutable?377
                                                                   top-ribcage1785))
                                                            (syntax-error
                                                              (source-wrap440
                                                                e1792
                                                                w1829
                                                                ae1791)
                                                              '"invalid definition in read-only environment")
                                                            (void))
                                                        ((lambda (sym1832)
                                                           (call-with-values
                                                             (lambda ()
                                                               (top-id-bound-var-name426
                                                                 sym1832
                                                                 (wrap-marks326
                                                                   (syntax-object-wrap66
                                                                     id1831))
                                                                 top-ribcage1785))
                                                             (lambda (valsym1834
                                                                      bound-id1833)
                                                               (begin (if (not (eq? (id-var-name431
                                                                                      id1831
                                                                                      '(()))
                                                                                    valsym1834))
                                                                          (syntax-error
                                                                            (source-wrap440
                                                                              e1792
                                                                              w1829
                                                                              ae1791)
                                                                            '"definition not permitted")
                                                                          (void))
                                                                      (if (read-only-binding?143
                                                                            valsym1834)
                                                                          (syntax-error
                                                                            (source-wrap440
                                                                              e1792
                                                                              w1829
                                                                              ae1791)
                                                                            '"invalid definition of read-only identifier")
                                                                          (void))
                                                                      (build-sequence247
                                                                        '#f
                                                                        (list (ct-eval/residualize480
                                                                                ctem1784
                                                                                (lambda ()
                                                                                  (list '$sc-put-cte
                                                                                        (list 'quote
                                                                                              bound-id1833)
                                                                                        (list 'quote
                                                                                              (cons 'global
                                                                                                    valsym1834))
                                                                                        (list 'quote
                                                                                              (top-ribcage-key376
                                                                                                top-ribcage1785)))))
                                                                              (rt-eval/residualize479
                                                                                rtem1786
                                                                                (lambda ()
                                                                                  (list 'define
                                                                                        valsym1834
                                                                                        (chi481
                                                                                          rhs1828
                                                                                          r1783
                                                                                          w1829))))))))))
                                                         ((lambda (x1835)
                                                            ((lambda (e1836)
                                                               (if (annotation?132
                                                                     e1836)
                                                                   (annotation-expression
                                                                     e1836)
                                                                   e1836))
                                                             (if (syntax-object?64
                                                                   x1835)
                                                                 (syntax-object-expression65
                                                                   x1835)
                                                                 x1835)))
                                                          id1831))))
                                               (wrap439 id1830 w1829))))
                                          (if (memv t1794 '($module-form))
                                              ((lambda (r1838 ribcage1837)
                                                 (parse-module489
                                                   e1792
                                                   w1790
                                                   ae1791
                                                   (make-wrap325
                                                     (wrap-marks326 w1790)
                                                     (cons ribcage1837
                                                           (wrap-subst327
                                                             w1790)))
                                                   (lambda (orig1842
                                                            id1839
                                                            exports1841
                                                            forms1840)
                                                     (begin (if (displaced-lexical?309
                                                                  id1839
                                                                  r1838)
                                                                (displaced-lexical-error310
                                                                  (wrap439
                                                                    id1839
                                                                    w1790))
                                                                (void))
                                                            (if (not (top-ribcage-mutable?377
                                                                       top-ribcage1785))
                                                                (syntax-error
                                                                  orig1842
                                                                  '"invalid definition in read-only environment")
                                                                (void))
                                                            (chi-top-module468
                                                              orig1842
                                                              r1838
                                                              top-ribcage1785
                                                              ribcage1837
                                                              ctem1784
                                                              rtem1786
                                                              id1839
                                                              exports1841
                                                              forms1840)))))
                                               (cons '("top-level module placeholder"
                                                        placeholder)
                                                     r1783)
                                               (make-ribcage366
                                                 '()
                                                 '()
                                                 '()))
                                              (if (memv t1794
                                                        '($import-form))
                                                  (parse-import490
                                                    e1792
                                                    w1790
                                                    ae1791
                                                    (lambda (orig1844
                                                             mid1843)
                                                      (begin (if (not (top-ribcage-mutable?377
                                                                        top-ribcage1785))
                                                                 (syntax-error
                                                                   orig1844
                                                                   '"invalid definition in read-only environment")
                                                                 (void))
                                                             (ct-eval/residualize480
                                                               ctem1784
                                                               (lambda ()
                                                                 ((lambda (binding1845)
                                                                    ((lambda (t1846)
                                                                       (if (memv t1846
                                                                                 '($module))
                                                                           (do-top-import476
                                                                             value1789
                                                                             top-ribcage1785
                                                                             mid1843
                                                                             (interface-token451
                                                                               (binding-value292
                                                                                 binding1845)))
                                                                           (if (memv t1846
                                                                                     '(displaced-lexical))
                                                                               (displaced-lexical-error310
                                                                                 mid1843)
                                                                               (syntax-error
                                                                                 mid1843
                                                                                 '"import from unknown module"))))
                                                                     (binding-type291
                                                                       binding1845)))
                                                                  (lookup313
                                                                    (id-var-name431
                                                                      mid1843
                                                                      '(()))
                                                                    '())))))))
                                                  (rt-eval/residualize479
                                                    rtem1786
                                                    (lambda ()
                                                      (chi-expr482
                                                        type1793
                                                        value1789
                                                        e1792
                                                        r1783
                                                        w1790
                                                        ae1791)))))))))))
                    type1793)))))
            (flatten-exports447
             (lambda (exports1116)
               ((letrec ((loop1117
                          (lambda (exports1119 ls1118)
                            (if (null? exports1119)
                                ls1118
                                (loop1117
                                  (cdr exports1119)
                                  (if (pair? (car exports1119))
                                      (loop1117 (car exports1119) ls1118)
                                      (cons (car exports1119) ls1118)))))))
                  loop1117)
                exports1116
                '())))
            (make-interface448
             (lambda (exports1782 token1781)
               (vector 'interface exports1782 token1781)))
            (interface?449
             (lambda (x1120)
               (if (vector? x1120)
                   (if (= (vector-length x1120) '3)
                       (eq? (vector-ref x1120 '0) 'interface)
                       '#f)
                   '#f)))
            (interface-exports450
             (lambda (x1780) (vector-ref x1780 '1)))
            (interface-token451 (lambda (x1121) (vector-ref x1121 '2)))
            (set-interface-exports!452
             (lambda (x1779 update1778)
               (vector-set! x1779 '1 update1778)))
            (set-interface-token!453
             (lambda (x1123 update1122)
               (vector-set! x1123 '2 update1122)))
            (make-trimmed-interface454
             (lambda (exports1776)
               (make-interface448
                 (list->vector
                   (map (lambda (x1777)
                          (if (pair? x1777) (car x1777) x1777))
                        exports1776))
                 '#f)))
            (make-resolved-interface455
             (lambda (exports1125 import-token1124)
               (make-interface448
                 (list->vector
                   (map (lambda (x1126)
                          (id->resolved-id417
                            (if (pair? x1126) (car x1126) x1126)))
                        exports1125))
                 import-token1124)))
            (make-module-binding456
             (lambda (type1775 id1771 label1774 imps1772 val1773)
               (vector
                 'module-binding
                 type1775
                 id1771
                 label1774
                 imps1772
                 val1773)))
            (module-binding?457
             (lambda (x1127)
               (if (vector? x1127)
                   (if (= (vector-length x1127) '6)
                       (eq? (vector-ref x1127 '0) 'module-binding)
                       '#f)
                   '#f)))
            (module-binding-type458
             (lambda (x1770) (vector-ref x1770 '1)))
            (module-binding-id459
             (lambda (x1128) (vector-ref x1128 '2)))
            (module-binding-label460
             (lambda (x1769) (vector-ref x1769 '3)))
            (module-binding-imps461
             (lambda (x1129) (vector-ref x1129 '4)))
            (module-binding-val462
             (lambda (x1768) (vector-ref x1768 '5)))
            (set-module-binding-type!463
             (lambda (x1131 update1130)
               (vector-set! x1131 '1 update1130)))
            (set-module-binding-id!464
             (lambda (x1767 update1766)
               (vector-set! x1767 '2 update1766)))
            (set-module-binding-label!465
             (lambda (x1133 update1132)
               (vector-set! x1133 '3 update1132)))
            (set-module-binding-imps!466
             (lambda (x1765 update1764)
               (vector-set! x1765 '4 update1764)))
            (set-module-binding-val!467
             (lambda (x1135 update1134)
               (vector-set! x1135 '5 update1134)))
            (chi-top-module468
             (lambda (orig1699
                      r1691
                      top-ribcage1698
                      ribcage1692
                      ctem1697
                      rtem1693
                      id1696
                      exports1694
                      forms1695)
               ((lambda (fexports1700)
                  (chi-external473
                    ribcage1692
                    orig1699
                    (map (lambda (d1763) (cons r1691 d1763)) forms1695)
                    r1691
                    exports1694
                    fexports1700
                    ctem1697
                    (lambda (bindings1702 inits1701)
                      ((letrec ((partition1703
                                 (lambda (fexports1708
                                          bs1704
                                          svs1707
                                          ses1705
                                          ctdefs1706)
                                   (if (null? fexports1708)
                                       ((letrec ((partition1709
                                                  (lambda (bs1712
                                                           dvs1710
                                                           des1711)
                                                    (if (null? bs1712)
                                                        ((lambda (ses1715
                                                                  des1713
                                                                  inits1714)
                                                           (begin (for-each
                                                                    (lambda (x1731)
                                                                      (apply
                                                                        (lambda (t1735
                                                                                 label1732
                                                                                 sym1734
                                                                                 val1733)
                                                                          (if label1732
                                                                              (set-indirect-label!362
                                                                                label1732
                                                                                sym1734)
                                                                              (void)))
                                                                        x1731))
                                                                    ctdefs1706)
                                                                  (build-sequence247
                                                                    '#f
                                                                    (list (ct-eval/residualize480
                                                                            ctem1697
                                                                            (lambda ()
                                                                              (if (null?
                                                                                    ctdefs1706)
                                                                                  (chi-void495)
                                                                                  (build-sequence247
                                                                                    '#f
                                                                                    (map (lambda (x1726)
                                                                                           (apply
                                                                                             (lambda (t1730
                                                                                                      label1727
                                                                                                      sym1729
                                                                                                      val1728)
                                                                                               (cons '$sc-put-cte
                                                                                                     (cons (list 'quote
                                                                                                                 sym1729)
                                                                                                           (cons (if (eq? t1730
                                                                                                                          'define-syntax-form)
                                                                                                                     val1728
                                                                                                                     (list 'quote
                                                                                                                           (cons '$module
                                                                                                                                 (make-resolved-interface455
                                                                                                                                   val1728
                                                                                                                                   sym1729))))
                                                                                                                 '('*top*)))))
                                                                                             x1726))
                                                                                         ctdefs1706)))))
                                                                          (ct-eval/residualize480
                                                                            ctem1697
                                                                            (lambda ()
                                                                              ((lambda (sym1716)
                                                                                 ((lambda (token1717)
                                                                                    ((lambda (b1718)
                                                                                       ((lambda ()
                                                                                          (call-with-values
                                                                                            (lambda ()
                                                                                              (top-id-bound-var-name426
                                                                                                sym1716
                                                                                                (wrap-marks326
                                                                                                  (syntax-object-wrap66
                                                                                                    id1696))
                                                                                                top-ribcage1698))
                                                                                            (lambda (valsym1720
                                                                                                     bound-id1719)
                                                                                              (begin (if (not (eq? (id-var-name431
                                                                                                                     id1696
                                                                                                                     '(()))
                                                                                                                   valsym1720))
                                                                                                         (syntax-error
                                                                                                           orig1699
                                                                                                           '"definition not permitted")
                                                                                                         (void))
                                                                                                     (if (read-only-binding?143
                                                                                                           valsym1720)
                                                                                                         (syntax-error
                                                                                                           orig1699
                                                                                                           '"invalid definition of read-only identifier")
                                                                                                         (void))
                                                                                                     (list '$sc-put-cte
                                                                                                           (list 'quote
                                                                                                                 bound-id1719)
                                                                                                           b1718
                                                                                                           (list 'quote
                                                                                                                 (top-ribcage-key376
                                                                                                                   top-ribcage1698)))))))))
                                                                                     (list 'quote
                                                                                           (cons '$module
                                                                                                 (make-resolved-interface455
                                                                                                   exports1694
                                                                                                   token1717)))))
                                                                                  (generate-id146
                                                                                    sym1716)))
                                                                               ((lambda (x1721)
                                                                                  ((lambda (e1722)
                                                                                     (if (annotation?132
                                                                                           e1722)
                                                                                         (annotation-expression
                                                                                           e1722)
                                                                                         e1722))
                                                                                   (if (syntax-object?64
                                                                                         x1721)
                                                                                       (syntax-object-expression65
                                                                                         x1721)
                                                                                       x1721)))
                                                                                id1696))))
                                                                          (if (null?
                                                                                svs1707)
                                                                              (chi-void495)
                                                                              (build-sequence247
                                                                                '#f
                                                                                (map (lambda (v1725)
                                                                                       (list 'define
                                                                                             v1725
                                                                                             (chi-void495)))
                                                                                     svs1707)))
                                                                          (rt-eval/residualize479
                                                                            rtem1693
                                                                            (lambda ()
                                                                              (build-body249
                                                                                '#f
                                                                                dvs1710
                                                                                des1713
                                                                                (build-sequence247
                                                                                  '#f
                                                                                  (list (if (null?
                                                                                              svs1707)
                                                                                            (chi-void495)
                                                                                            (build-sequence247
                                                                                              '#f
                                                                                              (map (lambda (v1724
                                                                                                            e1723)
                                                                                                     (list 'set!
                                                                                                           v1724
                                                                                                           e1723))
                                                                                                   svs1707
                                                                                                   ses1715)))
                                                                                        (if (null?
                                                                                              inits1714)
                                                                                            (chi-void495)
                                                                                            (build-sequence247
                                                                                              '#f
                                                                                              inits1714)))))))
                                                                          (chi-void495)))))
                                                         (map (lambda (x1738)
                                                                (chi481
                                                                  (cdr x1738)
                                                                  (car x1738)
                                                                  '(())))
                                                              ses1705)
                                                         (map (lambda (x1736)
                                                                (chi481
                                                                  (cdr x1736)
                                                                  (car x1736)
                                                                  '(())))
                                                              des1711)
                                                         (map (lambda (x1737)
                                                                (chi481
                                                                  (cdr x1737)
                                                                  (car x1737)
                                                                  '(())))
                                                              inits1701))
                                                        ((lambda (b1739)
                                                           ((lambda (t1740)
                                                              (if (memv t1740
                                                                        '(define-form))
                                                                  ((lambda (var1741)
                                                                     (begin (extend-store!470
                                                                              r1691
                                                                              (get-indirect-label361
                                                                                (module-binding-label460
                                                                                  b1739))
                                                                              (cons 'lexical
                                                                                    var1741))
                                                                            (partition1709
                                                                              (cdr bs1712)
                                                                              (cons var1741
                                                                                    dvs1710)
                                                                              (cons (module-binding-val462
                                                                                      b1739)
                                                                                    des1711))))
                                                                   (gen-var500
                                                                     (module-binding-id459
                                                                       b1739)))
                                                                  (if (memv t1740
                                                                            '(define-syntax-form
                                                                               $module-form))
                                                                      (partition1709
                                                                        (cdr bs1712)
                                                                        dvs1710
                                                                        des1711)
                                                                      (error 'sc-expand-internal
                                                                        '"unexpected module binding type"))))
                                                            (module-binding-type458
                                                              b1739)))
                                                         (car bs1712))))))
                                          partition1709)
                                        bs1704
                                        '()
                                        '())
                                       ((lambda (id1743 fexports1742)
                                          (letrec ((pluck-binding1744
                                                    (lambda (id1759
                                                             bs1756
                                                             succ1758
                                                             fail1757)
                                                      ((letrec ((loop1760
                                                                 (lambda (bs1762
                                                                          new-bs1761)
                                                                   (if (null?
                                                                         bs1762)
                                                                       (fail1757)
                                                                       (if (free-id=?432
                                                                             (module-binding-id459
                                                                               (car bs1762))
                                                                             id1759)
                                                                           (succ1758
                                                                             (car bs1762)
                                                                             (smart-append419
                                                                               (reverse
                                                                                 new-bs1761)
                                                                               (cdr bs1762)))
                                                                           (loop1760
                                                                             (cdr bs1762)
                                                                             (cons (car bs1762)
                                                                                   new-bs1761)))))))
                                                         loop1760)
                                                       bs1756
                                                       '()))))
                                            (pluck-binding1744
                                              id1743
                                              bs1704
                                              (lambda (b1746 bs1745)
                                                ((lambda (t1749
                                                          label1747
                                                          imps1748)
                                                   ((lambda (fexports1751
                                                             sym1750)
                                                      ((lambda (t1752)
                                                         (if (memv t1752
                                                                   '(define-form))
                                                             (begin (set-indirect-label!362
                                                                      label1747
                                                                      sym1750)
                                                                    (partition1703
                                                                      fexports1751
                                                                      bs1745
                                                                      (cons sym1750
                                                                            svs1707)
                                                                      (cons (module-binding-val462
                                                                              b1746)
                                                                            ses1705)
                                                                      ctdefs1706))
                                                             (if (memv t1752
                                                                       '(define-syntax-form))
                                                                 (partition1703
                                                                   fexports1751
                                                                   bs1745
                                                                   svs1707
                                                                   ses1705
                                                                   (cons (list t1749
                                                                               label1747
                                                                               sym1750
                                                                               (module-binding-val462
                                                                                 b1746))
                                                                         ctdefs1706))
                                                                 (if (memv t1752
                                                                           '($module-form))
                                                                     ((lambda (exports1753)
                                                                        (partition1703
                                                                          (append
                                                                            (flatten-exports447
                                                                              exports1753)
                                                                            fexports1751)
                                                                          bs1745
                                                                          svs1707
                                                                          ses1705
                                                                          (cons (list t1749
                                                                                      label1747
                                                                                      sym1750
                                                                                      exports1753)
                                                                                ctdefs1706)))
                                                                      (module-binding-val462
                                                                        b1746))
                                                                     (error 'sc-expand-internal
                                                                       '"unexpected module binding type")))))
                                                       t1749))
                                                    (append
                                                      imps1748
                                                      fexports1742)
                                                    (generate-id146
                                                      ((lambda (x1754)
                                                         ((lambda (e1755)
                                                            (if (annotation?132
                                                                  e1755)
                                                                (annotation-expression
                                                                  e1755)
                                                                e1755))
                                                          (if (syntax-object?64
                                                                x1754)
                                                              (syntax-object-expression65
                                                                x1754)
                                                              x1754)))
                                                       id1743))))
                                                 (module-binding-type458
                                                   b1746)
                                                 (module-binding-label460
                                                   b1746)
                                                 (module-binding-imps461
                                                   b1746)))
                                              (lambda ()
                                                (partition1703
                                                  fexports1742
                                                  bs1704
                                                  svs1707
                                                  ses1705
                                                  ctdefs1706)))))
                                        (car fexports1708)
                                        (cdr fexports1708))))))
                         partition1703)
                       fexports1700
                       bindings1702
                       '()
                       '()
                       '()))))
                (flatten-exports447 exports1694))))
            (id-set-diff469
             (lambda (exports1137 defs1136)
               (if (null? exports1137)
                   '()
                   (if (bound-id-member?438 (car exports1137) defs1136)
                       (id-set-diff469 (cdr exports1137) defs1136)
                       (cons (car exports1137)
                             (id-set-diff469
                               (cdr exports1137)
                               defs1136))))))
            (extend-store!470
             (lambda (r1690 label1688 binding1689)
               (set-cdr!
                 r1690
                 (extend-env305 label1688 binding1689 (cdr r1690)))))
            (check-module-exports471
             (lambda (source-exp1140 fexports1138 ids1139)
               (letrec ((defined?1141
                         (lambda (e1148 ids1147)
                           (ormap
                             (lambda (x1149)
                               (if (interface?449 x1149)
                                   ((lambda (token1150)
                                      (if token1150
                                          (lookup-import-binding-name413
                                            ((lambda (x1151)
                                               ((lambda (e1152)
                                                  (if (annotation?132
                                                        e1152)
                                                      (annotation-expression
                                                        e1152)
                                                      e1152))
                                                (if (syntax-object?64
                                                      x1151)
                                                    (syntax-object-expression65
                                                      x1151)
                                                    x1151)))
                                             e1148)
                                            token1150
                                            (wrap-marks326
                                              (syntax-object-wrap66
                                                e1148)))
                                          ((lambda (v1153)
                                             ((letrec ((lp1154
                                                        (lambda (i1155)
                                                          (if (>= i1155 '0)
                                                              ((lambda (t1156)
                                                                 (if t1156
                                                                     t1156
                                                                     (lp1154
                                                                       (- i1155
                                                                          '1))))
                                                               (bound-id=?434
                                                                 e1148
                                                                 (vector-ref
                                                                   v1153
                                                                   i1155)))
                                                              '#f))))
                                                lp1154)
                                              (- (vector-length v1153)
                                                 '1)))
                                           (interface-exports450 x1149))))
                                    (interface-token451 x1149))
                                   (bound-id=?434 e1148 x1149)))
                             ids1147))))
                 ((letrec ((loop1142
                            (lambda (fexports1144 missing1143)
                              (if (null? fexports1144)
                                  (if (not (null? missing1143))
                                      (syntax-error
                                        missing1143
                                        '"missing definition for export(s)")
                                      (void))
                                  ((lambda (e1146 fexports1145)
                                     (if (defined?1141 e1146 ids1139)
                                         (loop1142
                                           fexports1145
                                           missing1143)
                                         (loop1142
                                           fexports1145
                                           (cons e1146 missing1143))))
                                   (car fexports1144)
                                   (cdr fexports1144))))))
                    loop1142)
                  fexports1138
                  '()))))
            (check-defined-ids472
             (lambda (source-exp1645 ls1644)
               (letrec ((b-i=?1646
                         (lambda (x1683 y1682)
                           (if (symbol? x1683)
                               (if (symbol? y1682)
                                   (eq? x1683 y1682)
                                   (if (eq? x1683
                                            ((lambda (x1684)
                                               ((lambda (e1685)
                                                  (if (annotation?132
                                                        e1685)
                                                      (annotation-expression
                                                        e1685)
                                                      e1685))
                                                (if (syntax-object?64
                                                      x1684)
                                                    (syntax-object-expression65
                                                      x1684)
                                                    x1684)))
                                             y1682))
                                       (same-marks?423
                                         (wrap-marks326
                                           (syntax-object-wrap66 y1682))
                                         (wrap-marks326 '((top))))
                                       '#f))
                               (if (symbol? y1682)
                                   (if (eq? y1682
                                            ((lambda (x1686)
                                               ((lambda (e1687)
                                                  (if (annotation?132
                                                        e1687)
                                                      (annotation-expression
                                                        e1687)
                                                      e1687))
                                                (if (syntax-object?64
                                                      x1686)
                                                    (syntax-object-expression65
                                                      x1686)
                                                    x1686)))
                                             x1683))
                                       (same-marks?423
                                         (wrap-marks326
                                           (syntax-object-wrap66 x1683))
                                         (wrap-marks326 '((top))))
                                       '#f)
                                   (bound-id=?434 x1683 y1682)))))
                        (vfold1647
                         (lambda (v1660 p1658 cls1659)
                           ((lambda (len1661)
                              ((letrec ((lp1662
                                         (lambda (i1664 cls1663)
                                           (if (= i1664 len1661)
                                               cls1663
                                               (lp1662
                                                 (+ i1664 '1)
                                                 (p1658
                                                   (vector-ref v1660 i1664)
                                                   cls1663))))))
                                 lp1662)
                               '0
                               cls1659))
                            (vector-length v1660))))
                        (conflicts1648
                         (lambda (x1675 y1673 cls1674)
                           (if (interface?449 x1675)
                               (if (interface?449 y1673)
                                   (call-with-values
                                     (lambda ()
                                       ((lambda (xe1681 ye1680)
                                          (if (> (vector-length xe1681)
                                                 (vector-length ye1680))
                                              (values x1675 ye1680)
                                              (values y1673 xe1681)))
                                        (interface-exports450 x1675)
                                        (interface-exports450 y1673)))
                                     (lambda (iface1677 exports1676)
                                       (vfold1647
                                         exports1676
                                         (lambda (id1679 cls1678)
                                           (id-iface-conflicts1649
                                             id1679
                                             iface1677
                                             cls1678))
                                         cls1674)))
                                   (id-iface-conflicts1649
                                     y1673
                                     x1675
                                     cls1674))
                               (if (interface?449 y1673)
                                   (id-iface-conflicts1649
                                     x1675
                                     y1673
                                     cls1674)
                                   (if (b-i=?1646 x1675 y1673)
                                       (cons x1675 cls1674)
                                       cls1674)))))
                        (id-iface-conflicts1649
                         (lambda (id1667 iface1665 cls1666)
                           ((lambda (token1668)
                              (if token1668
                                  (if (lookup-import-binding-name413
                                        ((lambda (x1669)
                                           ((lambda (e1670)
                                              (if (annotation?132 e1670)
                                                  (annotation-expression
                                                    e1670)
                                                  e1670))
                                            (if (syntax-object?64 x1669)
                                                (syntax-object-expression65
                                                  x1669)
                                                x1669)))
                                         id1667)
                                        token1668
                                        (if (symbol? id1667)
                                            (wrap-marks326 '((top)))
                                            (wrap-marks326
                                              (syntax-object-wrap66
                                                id1667))))
                                      (cons id1667 cls1666)
                                      cls1666)
                                  (vfold1647
                                    (interface-exports450 iface1665)
                                    (lambda (*id1672 cls1671)
                                      (if (b-i=?1646 *id1672 id1667)
                                          (cons *id1672 cls1671)
                                          cls1671))
                                    cls1666)))
                            (interface-token451 iface1665)))))
                 (if (not (null? ls1644))
                     ((letrec ((lp1650
                                (lambda (x1653 ls1651 cls1652)
                                  (if (null? ls1651)
                                      (if (not (null? cls1652))
                                          ((lambda (cls1654)
                                             (syntax-error
                                               source-exp1645
                                               '"duplicate definition for "
                                               (symbol->string
                                                 (car cls1654))
                                               '" in"))
                                           (syntax-object->datum cls1652))
                                          (void))
                                      ((letrec ((lp21655
                                                 (lambda (ls21657 cls1656)
                                                   (if (null? ls21657)
                                                       (lp1650
                                                         (car ls1651)
                                                         (cdr ls1651)
                                                         cls1656)
                                                       (lp21655
                                                         (cdr ls21657)
                                                         (conflicts1648
                                                           x1653
                                                           (car ls21657)
                                                           cls1656))))))
                                         lp21655)
                                       ls1651
                                       cls1652)))))
                        lp1650)
                      (car ls1644)
                      (cdr ls1644)
                      '())
                     (void)))))
            (chi-external473
             (lambda (ribcage1164
                      source-exp1157
                      body1163
                      r1158
                      exports1162
                      fexports1159
                      ctem1161
                      k1160)
               (letrec ((return1165
                         (lambda (bindings1247 ids1245 inits1246)
                           (begin (check-defined-ids472
                                    source-exp1157
                                    ids1245)
                                  (check-module-exports471
                                    source-exp1157
                                    fexports1159
                                    ids1245)
                                  (k1160 bindings1247 inits1246))))
                        (get-implicit-exports1166
                         (lambda (id1236)
                           ((letrec ((f1237
                                      (lambda (exports1238)
                                        (if (null? exports1238)
                                            '()
                                            (if (if (pair?
                                                      (car exports1238))
                                                    (bound-id=?434
                                                      id1236
                                                      (caar exports1238))
                                                    '#f)
                                                (flatten-exports447
                                                  (cdar exports1238))
                                                (f1237
                                                  (cdr exports1238)))))))
                              f1237)
                            exports1162)))
                        (update-imp-exports1167
                         (lambda (bindings1240 exports1239)
                           ((lambda (exports1241)
                              (map (lambda (b1242)
                                     ((lambda (id1243)
                                        (if (not (bound-id-member?438
                                                   id1243
                                                   exports1241))
                                            b1242
                                            (make-module-binding456
                                              (module-binding-type458
                                                b1242)
                                              id1243
                                              (module-binding-label460
                                                b1242)
                                              (append
                                                (get-implicit-exports1166
                                                  id1243)
                                                (module-binding-imps461
                                                  b1242))
                                              (module-binding-val462
                                                b1242))))
                                      (module-binding-id459 b1242)))
                                   bindings1240))
                            (map (lambda (x1244)
                                   (if (pair? x1244) (car x1244) x1244))
                                 exports1239)))))
                 ((letrec ((parse1168
                            (lambda (body1172
                                     ids1169
                                     bindings1171
                                     inits1170)
                              (if (null? body1172)
                                  (return1165
                                    bindings1171
                                    ids1169
                                    inits1170)
                                  ((lambda (e1174 er1173)
                                     (call-with-values
                                       (lambda ()
                                         (syntax-type444
                                           e1174
                                           er1173
                                           '(())
                                           '#f
                                           ribcage1164))
                                       (lambda (type1179
                                                value1175
                                                e1178
                                                w1176
                                                ae1177)
                                         ((lambda (t1180)
                                            (if (memv t1180 '(define-form))
                                                (parse-define491
                                                  e1178
                                                  w1176
                                                  ae1177
                                                  (lambda (id1183
                                                           rhs1181
                                                           w1182)
                                                    ((lambda (id1184)
                                                       ((lambda (label1185)
                                                          ((lambda (imps1186)
                                                             ((lambda ()
                                                                (begin (extend-ribcage!409
                                                                         ribcage1164
                                                                         id1184
                                                                         label1185)
                                                                       (parse1168
                                                                         (cdr body1172)
                                                                         (cons id1184
                                                                               ids1169)
                                                                         (cons (make-module-binding456
                                                                                 type1179
                                                                                 id1184
                                                                                 label1185
                                                                                 imps1186
                                                                                 (cons er1173
                                                                                       (wrap439
                                                                                         rhs1181
                                                                                         w1182)))
                                                                               bindings1171)
                                                                         inits1170)))))
                                                           (get-implicit-exports1166
                                                             id1184)))
                                                        (gen-indirect-label360)))
                                                     (wrap439
                                                       id1183
                                                       w1182))))
                                                (if (memv t1180
                                                          '(define-syntax-form))
                                                    (parse-define-syntax492
                                                      e1178
                                                      w1176
                                                      ae1177
                                                      (lambda (id1189
                                                               rhs1187
                                                               w1188)
                                                        ((lambda (id1190)
                                                           ((lambda (label1191)
                                                              ((lambda (imps1192)
                                                                 ((lambda (exp1193)
                                                                    ((lambda ()
                                                                       (begin (extend-store!470
                                                                                r1158
                                                                                (get-indirect-label361
                                                                                  label1191)
                                                                                (defer-or-eval-transformer315
                                                                                  exp1193))
                                                                              (extend-ribcage!409
                                                                                ribcage1164
                                                                                id1190
                                                                                label1191)
                                                                              (parse1168
                                                                                (cdr body1172)
                                                                                (cons id1190
                                                                                      ids1169)
                                                                                (cons (make-module-binding456
                                                                                        type1179
                                                                                        id1190
                                                                                        label1191
                                                                                        imps1192
                                                                                        exp1193)
                                                                                      bindings1171)
                                                                                inits1170)))))
                                                                  (chi481
                                                                    rhs1187
                                                                    (transformer-env308
                                                                      er1173)
                                                                    w1188)))
                                                               (get-implicit-exports1166
                                                                 id1190)))
                                                            (gen-indirect-label360)))
                                                         (wrap439
                                                           id1189
                                                           w1188))))
                                                    (if (memv t1180
                                                              '($module-form))
                                                        ((lambda (*ribcage1194)
                                                           ((lambda (*w1195)
                                                              ((lambda ()
                                                                 (parse-module489
                                                                   e1178
                                                                   w1176
                                                                   ae1177
                                                                   *w1195
                                                                   (lambda (orig1199
                                                                            id1196
                                                                            *exports1198
                                                                            forms1197)
                                                                     (chi-external473
                                                                       *ribcage1194
                                                                       orig1199
                                                                       (map (lambda (d1207)
                                                                              (cons er1173
                                                                                    d1207))
                                                                            forms1197)
                                                                       r1158
                                                                       *exports1198
                                                                       (flatten-exports447
                                                                         *exports1198)
                                                                       ctem1161
                                                                       (lambda (*bindings1201
                                                                                *inits1200)
                                                                         ((lambda (iface1202)
                                                                            ((lambda (bindings1203)
                                                                               ((lambda (inits1204)
                                                                                  ((lambda ()
                                                                                     ((lambda (label1206
                                                                                               imps1205)
                                                                                        (begin (extend-store!470
                                                                                                 r1158
                                                                                                 (get-indirect-label361
                                                                                                   label1206)
                                                                                                 (cons '$module
                                                                                                       iface1202))
                                                                                               (extend-ribcage!409
                                                                                                 ribcage1164
                                                                                                 id1196
                                                                                                 label1206)
                                                                                               (parse1168
                                                                                                 (cdr body1172)
                                                                                                 (cons id1196
                                                                                                       ids1169)
                                                                                                 (cons (make-module-binding456
                                                                                                         type1179
                                                                                                         id1196
                                                                                                         label1206
                                                                                                         imps1205
                                                                                                         *exports1198)
                                                                                                       bindings1203)
                                                                                                 inits1204)))
                                                                                      (gen-indirect-label360)
                                                                                      (get-implicit-exports1166
                                                                                        id1196)))))
                                                                                (append
                                                                                  inits1170
                                                                                  *inits1200)))
                                                                             (append
                                                                               *bindings1201
                                                                               bindings1171)))
                                                                          (make-trimmed-interface454
                                                                            *exports1198)))))))))
                                                            (make-wrap325
                                                              (wrap-marks326
                                                                w1176)
                                                              (cons *ribcage1194
                                                                    (wrap-subst327
                                                                      w1176)))))
                                                         (make-ribcage366
                                                           '()
                                                           '()
                                                           '()))
                                                        (if (memv t1180
                                                                  '($import-form))
                                                            (parse-import490
                                                              e1178
                                                              w1176
                                                              ae1177
                                                              (lambda (orig1209
                                                                       mid1208)
                                                                ((lambda (mlabel1210)
                                                                   ((lambda (binding1211)
                                                                      ((lambda (t1212)
                                                                         (if (memv t1212
                                                                                   '($module))
                                                                             ((lambda (iface1213)
                                                                                (begin (if value1175
                                                                                           (extend-ribcage-barrier!410
                                                                                             ribcage1164
                                                                                             mid1208)
                                                                                           (void))
                                                                                       (do-import!488
                                                                                         iface1213
                                                                                         ribcage1164)
                                                                                       (parse1168
                                                                                         (cdr body1172)
                                                                                         (cons iface1213
                                                                                               ids1169)
                                                                                         (update-imp-exports1167
                                                                                           bindings1171
                                                                                           (vector->list
                                                                                             (interface-exports450
                                                                                               iface1213)))
                                                                                         inits1170)))
                                                                              (binding-value292
                                                                                binding1211))
                                                                             (if (memv t1212
                                                                                       '(displaced-lexical))
                                                                                 (displaced-lexical-error310
                                                                                   mid1208)
                                                                                 (syntax-error
                                                                                   mid1208
                                                                                   '"import from unknown module"))))
                                                                       (binding-type291
                                                                         binding1211)))
                                                                    (lookup313
                                                                      mlabel1210
                                                                      r1158)))
                                                                 (id-var-name431
                                                                   mid1208
                                                                   '(())))))
                                                            (if (memv t1180
                                                                      '(begin-form))
                                                                ((lambda (tmp1214)
                                                                   ((lambda (tmp1215)
                                                                      (if tmp1215
                                                                          (apply
                                                                            (lambda (_1217
                                                                                     e11216)
                                                                              (parse1168
                                                                                ((letrec ((f1218
                                                                                           (lambda (forms1219)
                                                                                             (if (null?
                                                                                                   forms1219)
                                                                                                 (cdr body1172)
                                                                                                 (cons (cons er1173
                                                                                                             (wrap439
                                                                                                               (car forms1219)
                                                                                                               w1176))
                                                                                                       (f1218
                                                                                                         (cdr forms1219)))))))
                                                                                   f1218)
                                                                                 e11216)
                                                                                ids1169
                                                                                bindings1171
                                                                                inits1170))
                                                                            tmp1215)
                                                                          (syntax-error
                                                                            tmp1214)))
                                                                    ($syntax-dispatch
                                                                      tmp1214
                                                                      '(any .
                                                                            each-any))))
                                                                 e1178)
                                                                (if (memv t1180
                                                                          '(eval-when-form))
                                                                    ((lambda (tmp1221)
                                                                       ((lambda (tmp1222)
                                                                          (if tmp1222
                                                                              (apply
                                                                                (lambda (_1225
                                                                                         x1223
                                                                                         e11224)
                                                                                  (parse1168
                                                                                    (if (memq 'eval
                                                                                              (chi-when-list443
                                                                                                x1223
                                                                                                w1176))
                                                                                        ((letrec ((f1227
                                                                                                   (lambda (forms1228)
                                                                                                     (if (null?
                                                                                                           forms1228)
                                                                                                         (cdr body1172)
                                                                                                         (cons (cons er1173
                                                                                                                     (wrap439
                                                                                                                       (car forms1228)
                                                                                                                       w1176))
                                                                                                               (f1227
                                                                                                                 (cdr forms1228)))))))
                                                                                           f1227)
                                                                                         e11224)
                                                                                        (cdr body1172))
                                                                                    ids1169
                                                                                    bindings1171
                                                                                    inits1170))
                                                                                tmp1222)
                                                                              (syntax-error
                                                                                tmp1221)))
                                                                        ($syntax-dispatch
                                                                          tmp1221
                                                                          '(any each-any
                                                                                .
                                                                                each-any))))
                                                                     e1178)
                                                                    (if (memv t1180
                                                                              '(local-syntax-form))
                                                                        (chi-local-syntax494
                                                                          value1175
                                                                          e1178
                                                                          er1173
                                                                          w1176
                                                                          ae1177
                                                                          (lambda (forms1233
                                                                                   er1230
                                                                                   w1232
                                                                                   ae1231)
                                                                            (parse1168
                                                                              ((letrec ((f1234
                                                                                         (lambda (forms1235)
                                                                                           (if (null?
                                                                                                 forms1235)
                                                                                               (cdr body1172)
                                                                                               (cons (cons er1230
                                                                                                           (wrap439
                                                                                                             (car forms1235)
                                                                                                             w1232))
                                                                                                     (f1234
                                                                                                       (cdr forms1235)))))))
                                                                                 f1234)
                                                                               forms1233)
                                                                              ids1169
                                                                              bindings1171
                                                                              inits1170)))
                                                                        (return1165
                                                                          bindings1171
                                                                          ids1169
                                                                          (append
                                                                            inits1170
                                                                            (cons (cons er1173
                                                                                        (source-wrap440
                                                                                          e1178
                                                                                          w1176
                                                                                          ae1177))
                                                                                  (cdr body1172))))))))))))
                                          type1179))))
                                   (cdar body1172)
                                   (caar body1172))))))
                    parse1168)
                  body1163
                  '()
                  '()
                  '()))))
            (vmap474
             (lambda (fn1640 v1639)
               ((letrec ((doloop1641
                          (lambda (i1643 ls1642)
                            (if (< i1643 '0)
                                ls1642
                                (doloop1641
                                  (- i1643 '1)
                                  (cons (fn1640 (vector-ref v1639 i1643))
                                        ls1642))))))
                  doloop1641)
                (- (vector-length v1639) '1)
                '())))
            (vfor-each475
             (lambda (fn1249 v1248)
               ((lambda (len1250)
                  ((letrec ((doloop1251
                             (lambda (i1252)
                               (if (not (= i1252 len1250))
                                   (begin (fn1249 (vector-ref v1248 i1252))
                                          (doloop1251 (+ i1252 '1)))
                                   (void)))))
                     doloop1251)
                   '0))
                (vector-length v1248))))
            (do-top-import476
             (lambda (import-only?1638 top-ribcage1635 mid1637 token1636)
               (list '$sc-put-cte
                     (list 'quote mid1637)
                     (list 'quote
                           (cons 'do-import
                                 (cons import-only?1638 token1636)))
                     (list 'quote (top-ribcage-key376 top-ribcage1635)))))
            (update-mode-set477
             ((lambda (table1253)
                (lambda (when-list1255 mode-set1254)
                  (remq '-
                        (apply
                          append
                          (map (lambda (m1256)
                                 ((lambda (row1257)
                                    (map (lambda (s1258)
                                           (cdr (assq s1258 row1257)))
                                         when-list1255))
                                  (cdr (assq m1256 table1253))))
                               mode-set1254)))))
              '((l (load . l)
                   (compile . c)
                   (visit . v)
                   (revisit . r)
                   (eval . -))
                (c (load . -)
                   (compile . -)
                   (visit . -)
                   (revisit . -)
                   (eval . c))
                (v (load . v)
                   (compile . c)
                   (visit . v)
                   (revisit . -)
                   (eval . -))
                (r (load . r)
                   (compile . c)
                   (visit . -)
                   (revisit . r)
                   (eval . -))
                (e (load . -)
                   (compile . -)
                   (visit . -)
                   (revisit . -)
                   (eval . e)))))
            (initial-mode-set478
             (lambda (when-list1631 compiling-a-file1630)
               (apply
                 append
                 (map (lambda (s1632)
                        (if compiling-a-file1630
                            ((lambda (t1633)
                               (if (memv t1633 '(compile))
                                   '(c)
                                   (if (memv t1633 '(load))
                                       '(l)
                                       (if (memv t1633 '(visit))
                                           '(v)
                                           (if (memv t1633 '(revisit))
                                               '(r)
                                               '())))))
                             s1632)
                            ((lambda (t1634)
                               (if (memv t1634 '(eval)) '(e) '()))
                             s1632)))
                      when-list1631))))
            (rt-eval/residualize479
             (lambda (rtem1260 thunk1259)
               (if (memq 'e rtem1260)
                   (thunk1259)
                   ((lambda (thunk1261)
                      (if (memq 'v rtem1260)
                          (if ((lambda (t1262)
                                 (if t1262 t1262 (memq 'r rtem1260)))
                               (memq 'l rtem1260))
                              (thunk1261)
                              (thunk1261))
                          (if ((lambda (t1263)
                                 (if t1263 t1263 (memq 'r rtem1260)))
                               (memq 'l rtem1260))
                              (thunk1261)
                              (chi-void495))))
                    (if (memq 'c rtem1260)
                        ((lambda (x1264)
                           (begin (top-level-eval-hook133 x1264)
                                  (lambda () x1264)))
                         (thunk1259))
                        thunk1259)))))
            (ct-eval/residualize480
             (lambda (ctem1625 thunk1624)
               (if (memq 'e ctem1625)
                   (begin (top-level-eval-hook133 (thunk1624))
                          (chi-void495))
                   ((lambda (thunk1626)
                      (if (memq 'r ctem1625)
                          (if ((lambda (t1627)
                                 (if t1627 t1627 (memq 'v ctem1625)))
                               (memq 'l ctem1625))
                              (thunk1626)
                              (thunk1626))
                          (if ((lambda (t1628)
                                 (if t1628 t1628 (memq 'v ctem1625)))
                               (memq 'l ctem1625))
                              (thunk1626)
                              (chi-void495))))
                    (if (memq 'c ctem1625)
                        ((lambda (x1629)
                           (begin (top-level-eval-hook133 x1629)
                                  (lambda () x1629)))
                         (thunk1624))
                        thunk1624)))))
            (chi481
             (lambda (e1267 r1265 w1266)
               (call-with-values
                 (lambda () (syntax-type444 e1267 r1265 w1266 '#f '#f))
                 (lambda (type1272 value1268 e1271 w1269 ae1270)
                   (chi-expr482
                     type1272
                     value1268
                     e1271
                     r1265
                     w1269
                     ae1270)))))
            (chi-expr482
             (lambda (type1608 value1603 e1607 r1604 w1606 ae1605)
               ((lambda (t1609)
                  (if (memv t1609 '(lexical))
                      value1603
                      (if (memv t1609 '(core))
                          (value1603 e1607 r1604 w1606 ae1605)
                          (if (memv t1609 '(lexical-call))
                              (chi-application483
                                value1603
                                e1607
                                r1604
                                w1606
                                ae1605)
                              (if (memv t1609 '(constant))
                                  (list 'quote
                                        (strip499
                                          (source-wrap440
                                            e1607
                                            w1606
                                            ae1605)
                                          '(())))
                                  (if (memv t1609 '(global))
                                      value1603
                                      (if (memv t1609 '(call))
                                          (chi-application483
                                            (chi481
                                              (car e1607)
                                              r1604
                                              w1606)
                                            e1607
                                            r1604
                                            w1606
                                            ae1605)
                                          (if (memv t1609 '(begin-form))
                                              ((lambda (tmp1610)
                                                 ((lambda (tmp1611)
                                                    (if tmp1611
                                                        (apply
                                                          (lambda (_1614
                                                                   e11612
                                                                   e21613)
                                                            (chi-sequence441
                                                              (cons e11612
                                                                    e21613)
                                                              r1604
                                                              w1606
                                                              ae1605))
                                                          tmp1611)
                                                        (syntax-error
                                                          tmp1610)))
                                                  ($syntax-dispatch
                                                    tmp1610
                                                    '(any any
                                                          .
                                                          each-any))))
                                               e1607)
                                              (if (memv t1609
                                                        '(local-syntax-form))
                                                  (chi-local-syntax494
                                                    value1603
                                                    e1607
                                                    r1604
                                                    w1606
                                                    ae1605
                                                    chi-sequence441)
                                                  (if (memv t1609
                                                            '(eval-when-form))
                                                      ((lambda (tmp1616)
                                                         ((lambda (tmp1617)
                                                            (if tmp1617
                                                                (apply
                                                                  (lambda (_1621
                                                                           x1618
                                                                           e11620
                                                                           e21619)
                                                                    (if (memq 'eval
                                                                              (chi-when-list443
                                                                                x1618
                                                                                w1606))
                                                                        (chi-sequence441
                                                                          (cons e11620
                                                                                e21619)
                                                                          r1604
                                                                          w1606
                                                                          ae1605)
                                                                        (chi-void495)))
                                                                  tmp1617)
                                                                (syntax-error
                                                                  tmp1616)))
                                                          ($syntax-dispatch
                                                            tmp1616
                                                            '(any each-any
                                                                  any
                                                                  .
                                                                  each-any))))
                                                       e1607)
                                                      (if (memv t1609
                                                                '(define-form
                                                                   define-syntax-form
                                                                   $module-form
                                                                   $import-form))
                                                          (syntax-error
                                                            (source-wrap440
                                                              e1607
                                                              w1606
                                                              ae1605)
                                                            '"invalid context for definition")
                                                          (if (memv t1609
                                                                    '(syntax))
                                                              (syntax-error
                                                                (source-wrap440
                                                                  e1607
                                                                  w1606
                                                                  ae1605)
                                                                '"reference to pattern variable outside syntax form")
                                                              (if (memv t1609
                                                                        '(displaced-lexical))
                                                                  (displaced-lexical-error310
                                                                    (source-wrap440
                                                                      e1607
                                                                      w1606
                                                                      ae1605))
                                                                  (syntax-error
                                                                    (source-wrap440
                                                                      e1607
                                                                      w1606
                                                                      ae1605)))))))))))))))
                type1608)))
            (chi-application483
             (lambda (x1277 e1273 r1276 w1274 ae1275)
               ((lambda (tmp1278)
                  ((lambda (tmp1279)
                     (if tmp1279
                         (apply
                           (lambda (e01281 e11280)
                             (cons x1277
                                   (map (lambda (e1283)
                                          (chi481 e1283 r1276 w1274))
                                        e11280)))
                           tmp1279)
                         ((lambda (_1284)
                            (syntax-error
                              (source-wrap440 e1273 w1274 ae1275)))
                          tmp1278)))
                   ($syntax-dispatch tmp1278 '(any . each-any))))
                e1273)))
            (chi-set!484
             (lambda (e1579 r1575 w1578 ae1576 rib1577)
               ((lambda (tmp1580)
                  ((lambda (tmp1581)
                     (if (if tmp1581
                             (apply
                               (lambda (_1584 id1582 val1583)
                                 (id?318 id1582))
                               tmp1581)
                             '#f)
                         (apply
                           (lambda (_1587 id1585 val1586)
                             ((lambda (n1588)
                                ((lambda (b1589)
                                   ((lambda (t1590)
                                      (if (memv t1590 '(macro!))
                                          ((lambda (id1592 val1591)
                                             (syntax-type444
                                               (chi-macro485
                                                 (binding-value292 b1589)
                                                 (list '#(syntax-object set! ((top) #(ribcage () () ()) #(ribcage #(id val) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(t) #(("m" top)) #("i")) #(ribcage () () ()) #(ribcage #(b) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(n) #((top)) #("i")) #(ribcage #(_ id val) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(e r w ae rib) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                       id1592
                                                       val1591)
                                                 r1575
                                                 '(())
                                                 '#f
                                                 rib1577)
                                               r1575
                                               '(())
                                               '#f
                                               rib1577))
                                           (wrap439 id1585 w1578)
                                           (wrap439 val1586 w1578))
                                          (values
                                            'core
                                            (lambda (e1596
                                                     r1593
                                                     w1595
                                                     ae1594)
                                              ((lambda (val1598 n1597)
                                                 ((lambda (b1599)
                                                    ((lambda (t1600)
                                                       (if (memv t1600
                                                                 '(lexical))
                                                           (list 'set!
                                                                 (binding-value292
                                                                   b1599)
                                                                 val1598)
                                                           (if (memv t1600
                                                                     '(global))
                                                               ((lambda (sym1601)
                                                                  (begin (if (read-only-binding?143
                                                                               n1597)
                                                                             (syntax-error
                                                                               (source-wrap440
                                                                                 e1596
                                                                                 w1595
                                                                                 ae1594)
                                                                               '"invalid assignment to read-only variable")
                                                                             (void))
                                                                         (list 'set!
                                                                               sym1601
                                                                               val1598)))
                                                                (binding-value292
                                                                  b1599))
                                                               (if (memv t1600
                                                                         '(displaced-lexical))
                                                                   (syntax-error
                                                                     (wrap439
                                                                       id1585
                                                                       w1595)
                                                                     '"identifier out of context")
                                                                   (syntax-error
                                                                     (source-wrap440
                                                                       e1596
                                                                       w1595
                                                                       ae1594))))))
                                                     (binding-type291
                                                       b1599)))
                                                  (lookup313 n1597 r1593)))
                                               (chi481 val1586 r1593 w1595)
                                               (id-var-name431
                                                 id1585
                                                 w1595)))
                                            e1579
                                            w1578
                                            ae1576)))
                                    (binding-type291 b1589)))
                                 (lookup313 n1588 r1575)))
                              (id-var-name431 id1585 w1578)))
                           tmp1581)
                         ((lambda (_1602)
                            (syntax-error
                              (source-wrap440 e1579 w1578 ae1576)))
                          tmp1580)))
                   ($syntax-dispatch tmp1580 '(any any any))))
                e1579)))
            (chi-macro485
             (lambda (p1290 e1285 r1289 w1286 ae1288 rib1287)
               (letrec ((rebuild-macro-output1291
                         (lambda (x1295 m1294)
                           (if (pair? x1295)
                               (cons (rebuild-macro-output1291
                                       (car x1295)
                                       m1294)
                                     (rebuild-macro-output1291
                                       (cdr x1295)
                                       m1294))
                               (if (syntax-object?64 x1295)
                                   ((lambda (w1296)
                                      ((lambda (ms1298 s1297)
                                         (make-syntax-object63
                                           (syntax-object-expression65
                                             x1295)
                                           (if (if (pair? ms1298)
                                                   (eq? (car ms1298) '#f)
                                                   '#f)
                                               (make-wrap325
                                                 (cdr ms1298)
                                                 (cdr s1297))
                                               (make-wrap325
                                                 (cons m1294 ms1298)
                                                 (if rib1287
                                                     (cons rib1287
                                                           (cons 'shift
                                                                 s1297))
                                                     (cons 'shift
                                                           s1297))))))
                                       (wrap-marks326 w1296)
                                       (wrap-subst327 w1296)))
                                    (syntax-object-wrap66 x1295))
                                   (if (vector? x1295)
                                       ((lambda (n1299)
                                          ((lambda (v1300)
                                             ((lambda ()
                                                ((letrec ((doloop1301
                                                           (lambda (i1302)
                                                             (if (= i1302
                                                                    n1299)
                                                                 v1300
                                                                 (begin (vector-set!
                                                                          v1300
                                                                          i1302
                                                                          (rebuild-macro-output1291
                                                                            (vector-ref
                                                                              x1295
                                                                              i1302)
                                                                            m1294))
                                                                        (doloop1301
                                                                          (+ i1302
                                                                             '1)))))))
                                                   doloop1301)
                                                 '0))))
                                           (make-vector n1299)))
                                        (vector-length x1295))
                                       (if (symbol? x1295)
                                           (syntax-error
                                             (source-wrap440
                                               e1285
                                               w1286
                                               ae1288)
                                             '"encountered raw symbol "
                                             (format '"~s" x1295)
                                             '" in output of macro")
                                           x1295)))))))
                 (rebuild-macro-output1291
                   ((lambda (out1292)
                      (if (procedure? out1292)
                          (out1292
                            (lambda (id1293)
                              (begin (if (not (identifier? id1293))
                                         (syntax-error
                                           id1293
                                           '"environment argument is not an identifier")
                                         (void))
                                     (lookup313
                                       (id-var-name431 id1293 '(()))
                                       r1289))))
                          out1292))
                    (p1290
                      (source-wrap440 e1285 (anti-mark399 w1286) ae1288)))
                   (string '#\m)))))
            (chi-body486
             (lambda (body1562 outer-form1559 r1561 w1560)
               ((lambda (r1563)
                  ((lambda (ribcage1564)
                     ((lambda (w1565)
                        ((lambda (body1566)
                           ((lambda ()
                              (chi-internal487
                                ribcage1564
                                outer-form1559
                                body1566
                                r1563
                                (lambda (exprs1571
                                         ids1567
                                         vars1570
                                         vals1568
                                         inits1569)
                                  (begin (if (null? exprs1571)
                                             (syntax-error
                                               outer-form1559
                                               '"no expressions in body")
                                             (void))
                                         (build-body249
                                           '#f
                                           vars1570
                                           (map (lambda (x1573)
                                                  (chi481
                                                    (cdr x1573)
                                                    (car x1573)
                                                    '(())))
                                                vals1568)
                                           (build-sequence247
                                             '#f
                                             (map (lambda (x1572)
                                                    (chi481
                                                      (cdr x1572)
                                                      (car x1572)
                                                      '(())))
                                                  (append
                                                    inits1569
                                                    exprs1571))))))))))
                         (map (lambda (x1574)
                                (cons r1563 (wrap439 x1574 w1565)))
                              body1562)))
                      (make-wrap325
                        (wrap-marks326 w1560)
                        (cons ribcage1564 (wrap-subst327 w1560)))))
                   (make-ribcage366 '() '() '())))
                (cons '("placeholder" placeholder) r1561))))
            (chi-internal487
             (lambda (ribcage1307 source-exp1303 body1306 r1304 k1305)
               (letrec ((return1308
                         (lambda (exprs1384
                                  ids1380
                                  vars1383
                                  vals1381
                                  inits1382)
                           (begin (check-defined-ids472
                                    source-exp1303
                                    ids1380)
                                  (k1305
                                    exprs1384
                                    ids1380
                                    (reverse vars1383)
                                    (reverse vals1381)
                                    inits1382)))))
                 ((letrec ((parse1309
                            (lambda (body1314
                                     ids1310
                                     vars1313
                                     vals1311
                                     inits1312)
                              (if (null? body1314)
                                  (return1308
                                    body1314
                                    ids1310
                                    vars1313
                                    vals1311
                                    inits1312)
                                  ((lambda (e1316 er1315)
                                     (call-with-values
                                       (lambda ()
                                         (syntax-type444
                                           e1316
                                           er1315
                                           '(())
                                           '#f
                                           ribcage1307))
                                       (lambda (type1321
                                                value1317
                                                e1320
                                                w1318
                                                ae1319)
                                         ((lambda (t1322)
                                            (if (memv t1322 '(define-form))
                                                (parse-define491
                                                  e1320
                                                  w1318
                                                  ae1319
                                                  (lambda (id1325
                                                           rhs1323
                                                           w1324)
                                                    ((lambda (id1327
                                                              label1326)
                                                       ((lambda (var1328)
                                                          (begin (extend-ribcage!409
                                                                   ribcage1307
                                                                   id1327
                                                                   label1326)
                                                                 (extend-store!470
                                                                   r1304
                                                                   label1326
                                                                   (cons 'lexical
                                                                         var1328))
                                                                 (parse1309
                                                                   (cdr body1314)
                                                                   (cons id1327
                                                                         ids1310)
                                                                   (cons var1328
                                                                         vars1313)
                                                                   (cons (cons er1315
                                                                               (wrap439
                                                                                 rhs1323
                                                                                 w1324))
                                                                         vals1311)
                                                                   inits1312)))
                                                        (gen-var500
                                                          id1327)))
                                                     (wrap439 id1325 w1324)
                                                     (gen-label363))))
                                                (if (memv t1322
                                                          '(define-syntax-form))
                                                    (parse-define-syntax492
                                                      e1320
                                                      w1318
                                                      ae1319
                                                      (lambda (id1331
                                                               rhs1329
                                                               w1330)
                                                        ((lambda (id1334
                                                                  label1332
                                                                  exp1333)
                                                           (begin (extend-ribcage!409
                                                                    ribcage1307
                                                                    id1334
                                                                    label1332)
                                                                  (extend-store!470
                                                                    r1304
                                                                    label1332
                                                                    (defer-or-eval-transformer315
                                                                      exp1333))
                                                                  (parse1309
                                                                    (cdr body1314)
                                                                    (cons id1334
                                                                          ids1310)
                                                                    vars1313
                                                                    vals1311
                                                                    inits1312)))
                                                         (wrap439
                                                           id1331
                                                           w1330)
                                                         (gen-label363)
                                                         (chi481
                                                           rhs1329
                                                           (transformer-env308
                                                             er1315)
                                                           w1330))))
                                                    (if (memv t1322
                                                              '($module-form))
                                                        ((lambda (*ribcage1335)
                                                           ((lambda (*w1336)
                                                              ((lambda ()
                                                                 (parse-module489
                                                                   e1320
                                                                   w1318
                                                                   ae1319
                                                                   *w1336
                                                                   (lambda (orig1340
                                                                            id1337
                                                                            exports1339
                                                                            forms1338)
                                                                     (chi-internal487
                                                                       *ribcage1335
                                                                       orig1340
                                                                       (map (lambda (d1351)
                                                                              (cons er1315
                                                                                    d1351))
                                                                            forms1338)
                                                                       r1304
                                                                       (lambda (*body1345
                                                                                *ids1341
                                                                                *vars1344
                                                                                *vals1342
                                                                                *inits1343)
                                                                         (begin (check-module-exports471
                                                                                  source-exp1303
                                                                                  (flatten-exports447
                                                                                    exports1339)
                                                                                  *ids1341)
                                                                                ((lambda (iface1349
                                                                                          vars1346
                                                                                          vals1348
                                                                                          inits1347)
                                                                                   ((lambda (label1350)
                                                                                      (begin (extend-ribcage!409
                                                                                               ribcage1307
                                                                                               id1337
                                                                                               label1350)
                                                                                             (extend-store!470
                                                                                               r1304
                                                                                               label1350
                                                                                               (cons '$module
                                                                                                     iface1349))
                                                                                             (parse1309
                                                                                               (cdr body1314)
                                                                                               (cons id1337
                                                                                                     ids1310)
                                                                                               vars1346
                                                                                               vals1348
                                                                                               inits1347)))
                                                                                    (gen-label363)))
                                                                                 (make-trimmed-interface454
                                                                                   exports1339)
                                                                                 (append
                                                                                   *vars1344
                                                                                   vars1313)
                                                                                 (append
                                                                                   *vals1342
                                                                                   vals1311)
                                                                                 (append
                                                                                   inits1312
                                                                                   *inits1343
                                                                                   *body1345))))))))))
                                                            (make-wrap325
                                                              (wrap-marks326
                                                                w1318)
                                                              (cons *ribcage1335
                                                                    (wrap-subst327
                                                                      w1318)))))
                                                         (make-ribcage366
                                                           '()
                                                           '()
                                                           '()))
                                                        (if (memv t1322
                                                                  '($import-form))
                                                            (parse-import490
                                                              e1320
                                                              w1318
                                                              ae1319
                                                              (lambda (orig1353
                                                                       mid1352)
                                                                ((lambda (mlabel1354)
                                                                   ((lambda (binding1355)
                                                                      ((lambda (t1356)
                                                                         (if (memv t1356
                                                                                   '($module))
                                                                             ((lambda (iface1357)
                                                                                (begin (if value1317
                                                                                           (extend-ribcage-barrier!410
                                                                                             ribcage1307
                                                                                             mid1352)
                                                                                           (void))
                                                                                       (do-import!488
                                                                                         iface1357
                                                                                         ribcage1307)
                                                                                       (parse1309
                                                                                         (cdr body1314)
                                                                                         (cons iface1357
                                                                                               ids1310)
                                                                                         vars1313
                                                                                         vals1311
                                                                                         inits1312)))
                                                                              (cdr binding1355))
                                                                             (if (memv t1356
                                                                                       '(displaced-lexical))
                                                                                 (displaced-lexical-error310
                                                                                   mid1352)
                                                                                 (syntax-error
                                                                                   mid1352
                                                                                   '"import from unknown module"))))
                                                                       (car binding1355)))
                                                                    (lookup313
                                                                      mlabel1354
                                                                      r1304)))
                                                                 (id-var-name431
                                                                   mid1352
                                                                   '(())))))
                                                            (if (memv t1322
                                                                      '(begin-form))
                                                                ((lambda (tmp1358)
                                                                   ((lambda (tmp1359)
                                                                      (if tmp1359
                                                                          (apply
                                                                            (lambda (_1361
                                                                                     e11360)
                                                                              (parse1309
                                                                                ((letrec ((f1362
                                                                                           (lambda (forms1363)
                                                                                             (if (null?
                                                                                                   forms1363)
                                                                                                 (cdr body1314)
                                                                                                 (cons (cons er1315
                                                                                                             (wrap439
                                                                                                               (car forms1363)
                                                                                                               w1318))
                                                                                                       (f1362
                                                                                                         (cdr forms1363)))))))
                                                                                   f1362)
                                                                                 e11360)
                                                                                ids1310
                                                                                vars1313
                                                                                vals1311
                                                                                inits1312))
                                                                            tmp1359)
                                                                          (syntax-error
                                                                            tmp1358)))
                                                                    ($syntax-dispatch
                                                                      tmp1358
                                                                      '(any .
                                                                            each-any))))
                                                                 e1320)
                                                                (if (memv t1322
                                                                          '(eval-when-form))
                                                                    ((lambda (tmp1365)
                                                                       ((lambda (tmp1366)
                                                                          (if tmp1366
                                                                              (apply
                                                                                (lambda (_1369
                                                                                         x1367
                                                                                         e11368)
                                                                                  (parse1309
                                                                                    (if (memq 'eval
                                                                                              (chi-when-list443
                                                                                                x1367
                                                                                                w1318))
                                                                                        ((letrec ((f1371
                                                                                                   (lambda (forms1372)
                                                                                                     (if (null?
                                                                                                           forms1372)
                                                                                                         (cdr body1314)
                                                                                                         (cons (cons er1315
                                                                                                                     (wrap439
                                                                                                                       (car forms1372)
                                                                                                                       w1318))
                                                                                                               (f1371
                                                                                                                 (cdr forms1372)))))))
                                                                                           f1371)
                                                                                         e11368)
                                                                                        (cdr body1314))
                                                                                    ids1310
                                                                                    vars1313
                                                                                    vals1311
                                                                                    inits1312))
                                                                                tmp1366)
                                                                              (syntax-error
                                                                                tmp1365)))
                                                                        ($syntax-dispatch
                                                                          tmp1365
                                                                          '(any each-any
                                                                                .
                                                                                each-any))))
                                                                     e1320)
                                                                    (if (memv t1322
                                                                              '(local-syntax-form))
                                                                        (chi-local-syntax494
                                                                          value1317
                                                                          e1320
                                                                          er1315
                                                                          w1318
                                                                          ae1319
                                                                          (lambda (forms1377
                                                                                   er1374
                                                                                   w1376
                                                                                   ae1375)
                                                                            (parse1309
                                                                              ((letrec ((f1378
                                                                                         (lambda (forms1379)
                                                                                           (if (null?
                                                                                                 forms1379)
                                                                                               (cdr body1314)
                                                                                               (cons (cons er1374
                                                                                                           (wrap439
                                                                                                             (car forms1379)
                                                                                                             w1376))
                                                                                                     (f1378
                                                                                                       (cdr forms1379)))))))
                                                                                 f1378)
                                                                               forms1377)
                                                                              ids1310
                                                                              vars1313
                                                                              vals1311
                                                                              inits1312)))
                                                                        (return1308
                                                                          (cons (cons er1315
                                                                                      (source-wrap440
                                                                                        e1320
                                                                                        w1318
                                                                                        ae1319))
                                                                                (cdr body1314))
                                                                          ids1310
                                                                          vars1313
                                                                          vals1311
                                                                          inits1312)))))))))
                                          type1321))))
                                   (cdar body1314)
                                   (caar body1314))))))
                    parse1309)
                  body1306
                  '()
                  '()
                  '()
                  '()))))
            (do-import!488
             (lambda (interface1555 ribcage1554)
               ((lambda (token1556)
                  (if token1556
                      (extend-ribcage-subst!412 ribcage1554 token1556)
                      (vfor-each475
                        (lambda (id1557)
                          ((lambda (label11558)
                             (begin (if (not label11558)
                                        (syntax-error
                                          id1557
                                          '"exported identifier not visible")
                                        (void))
                                    (extend-ribcage!409
                                      ribcage1554
                                      id1557
                                      label11558)))
                           (id-var-name-loc430 id1557 '(()))))
                        (interface-exports450 interface1555))))
                (interface-token451 interface1555))))
            (parse-module489
             (lambda (e1389 w1385 ae1388 *w1386 k1387)
               (letrec ((listify1390
                         (lambda (exports1407)
                           (if (null? exports1407)
                               '()
                               (cons ((lambda (tmp1408)
                                        ((lambda (tmp1409)
                                           (if tmp1409
                                               (apply
                                                 (lambda (ex1410)
                                                   (listify1390 ex1410))
                                                 tmp1409)
                                               ((lambda (x1412)
                                                  (if (id?318 x1412)
                                                      (wrap439
                                                        x1412
                                                        *w1386)
                                                      (syntax-error
                                                        (source-wrap440
                                                          e1389
                                                          w1385
                                                          ae1388)
                                                        '"invalid exports list in")))
                                                tmp1408)))
                                         ($syntax-dispatch
                                           tmp1408
                                           'each-any)))
                                      (car exports1407))
                                     (listify1390 (cdr exports1407)))))))
                 ((lambda (tmp1391)
                    ((lambda (tmp1392)
                       (if (if tmp1392
                               (apply
                                 (lambda (_1397
                                          orig1393
                                          mid1396
                                          ex1394
                                          form1395)
                                   (id?318 mid1396))
                                 tmp1392)
                               '#f)
                           (apply
                             (lambda (_1402
                                      orig1398
                                      mid1401
                                      ex1399
                                      form1400)
                               (k1387
                                 orig1398
                                 (wrap439 mid1401 w1385)
                                 (listify1390 ex1399)
                                 (map (lambda (x1404)
                                        (wrap439 x1404 *w1386))
                                      form1400)))
                             tmp1392)
                           ((lambda (_1406)
                              (syntax-error
                                (source-wrap440 e1389 w1385 ae1388)))
                            tmp1391)))
                     ($syntax-dispatch
                       tmp1391
                       '(any any any each-any . each-any))))
                  e1389))))
            (parse-import490
             (lambda (e1544 w1541 ae1543 k1542)
               ((lambda (tmp1545)
                  ((lambda (tmp1546)
                     (if (if tmp1546
                             (apply
                               (lambda (_1549 orig1547 mid1548)
                                 (id?318 mid1548))
                               tmp1546)
                             '#f)
                         (apply
                           (lambda (_1552 orig1550 mid1551)
                             (k1542 orig1550 (wrap439 mid1551 w1541)))
                           tmp1546)
                         ((lambda (_1553)
                            (syntax-error
                              (source-wrap440 e1544 w1541 ae1543)))
                          tmp1545)))
                   ($syntax-dispatch tmp1545 '(any any any))))
                e1544)))
            (parse-define491
             (lambda (e1416 w1413 ae1415 k1414)
               ((lambda (tmp1417)
                  ((lambda (tmp1418)
                     (if (if tmp1418
                             (apply
                               (lambda (_1421 name1419 val1420)
                                 (id?318 name1419))
                               tmp1418)
                             '#f)
                         (apply
                           (lambda (_1424 name1422 val1423)
                             (k1414 name1422 val1423 w1413))
                           tmp1418)
                         ((lambda (tmp1425)
                            (if (if tmp1425
                                    (apply
                                      (lambda (_1430
                                               name1426
                                               args1429
                                               e11427
                                               e21428)
                                        (if (id?318 name1426)
                                            (valid-bound-ids?435
                                              (lambda-var-list501
                                                args1429))
                                            '#f))
                                      tmp1425)
                                    '#f)
                                (apply
                                  (lambda (_1435
                                           name1431
                                           args1434
                                           e11432
                                           e21433)
                                    (k1414
                                      (wrap439 name1431 w1413)
                                      (cons '#(syntax-object lambda ((top) #(ribcage #(_ name args e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(e w ae k) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                            (wrap439
                                              (cons args1434
                                                    (cons e11432 e21433))
                                              w1413))
                                      '(())))
                                  tmp1425)
                                ((lambda (tmp1437)
                                   (if (if tmp1437
                                           (apply
                                             (lambda (_1439 name1438)
                                               (id?318 name1438))
                                             tmp1437)
                                           '#f)
                                       (apply
                                         (lambda (_1441 name1440)
                                           (k1414
                                             (wrap439 name1440 w1413)
                                             '#(syntax-object (void) ((top) #(ribcage #(_ name) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(e w ae k) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                             '(())))
                                         tmp1437)
                                       ((lambda (_1442)
                                          (syntax-error
                                            (source-wrap440
                                              e1416
                                              w1413
                                              ae1415)))
                                        tmp1417)))
                                 ($syntax-dispatch tmp1417 '(any any)))))
                          ($syntax-dispatch
                            tmp1417
                            '(any (any . any) any . each-any)))))
                   ($syntax-dispatch tmp1417 '(any any any))))
                e1416)))
            (parse-define-syntax492
             (lambda (e1519 w1516 ae1518 k1517)
               ((lambda (tmp1520)
                  ((lambda (tmp1521)
                     (if (if tmp1521
                             (apply
                               (lambda (_1526
                                        name1522
                                        id1525
                                        e11523
                                        e21524)
                                 (if (id?318 name1522)
                                     (id?318 id1525)
                                     '#f))
                               tmp1521)
                             '#f)
                         (apply
                           (lambda (_1531 name1527 id1530 e11528 e21529)
                             (k1517
                               (wrap439 name1527 w1516)
                               (list*
                                 '#(syntax-object lambda ((top) #(ribcage #(_ name id e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(e w ae k) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                 (wrap439 (list id1530) w1516)
                                 (wrap439 (cons e11528 e21529) w1516))
                               '(())))
                           tmp1521)
                         ((lambda (tmp1533)
                            (if (if tmp1533
                                    (apply
                                      (lambda (_1536 name1534 val1535)
                                        (id?318 name1534))
                                      tmp1533)
                                    '#f)
                                (apply
                                  (lambda (_1539 name1537 val1538)
                                    (k1517 name1537 val1538 w1516))
                                  tmp1533)
                                ((lambda (_1540)
                                   (syntax-error
                                     (source-wrap440 e1519 w1516 ae1518)))
                                 tmp1520)))
                          ($syntax-dispatch tmp1520 '(any any any)))))
                   ($syntax-dispatch
                     tmp1520
                     '(any (any any) any . each-any))))
                e1519)))
            (chi-lambda-clause493
             (lambda (e1447 c1443 r1446 w1444 k1445)
               ((lambda (tmp1448)
                  ((lambda (tmp1449)
                     (if tmp1449
                         (apply
                           (lambda (id1452 e11450 e21451)
                             ((lambda (ids1453)
                                (if (not (valid-bound-ids?435 ids1453))
                                    (syntax-error
                                      e1447
                                      '"invalid parameter list in")
                                    ((lambda (labels1455 new-vars1454)
                                       (k1445
                                         new-vars1454
                                         (chi-body486
                                           (cons e11450 e21451)
                                           e1447
                                           (extend-var-env*307
                                             labels1455
                                             new-vars1454
                                             r1446)
                                           (make-binding-wrap415
                                             ids1453
                                             labels1455
                                             w1444))))
                                     (gen-labels365 ids1453)
                                     (map gen-var500 ids1453))))
                              id1452))
                           tmp1449)
                         ((lambda (tmp1458)
                            (if tmp1458
                                (apply
                                  (lambda (ids1461 e11459 e21460)
                                    ((lambda (old-ids1462)
                                       (if (not (valid-bound-ids?435
                                                  old-ids1462))
                                           (syntax-error
                                             e1447
                                             '"invalid parameter list in")
                                           ((lambda (labels1464
                                                     new-vars1463)
                                              (k1445
                                                ((letrec ((f1466
                                                           (lambda (ls11468
                                                                    ls21467)
                                                             (if (null?
                                                                   ls11468)
                                                                 ls21467
                                                                 (f1466
                                                                   (cdr ls11468)
                                                                   (cons (car ls11468)
                                                                         ls21467))))))
                                                   f1466)
                                                 (cdr new-vars1463)
                                                 (car new-vars1463))
                                                (chi-body486
                                                  (cons e11459 e21460)
                                                  e1447
                                                  (extend-var-env*307
                                                    labels1464
                                                    new-vars1463
                                                    r1446)
                                                  (make-binding-wrap415
                                                    old-ids1462
                                                    labels1464
                                                    w1444))))
                                            (gen-labels365 old-ids1462)
                                            (map gen-var500 old-ids1462))))
                                     (lambda-var-list501 ids1461)))
                                  tmp1458)
                                ((lambda (_1469) (syntax-error e1447))
                                 tmp1448)))
                          ($syntax-dispatch
                            tmp1448
                            '(any any . each-any)))))
                   ($syntax-dispatch tmp1448 '(each-any any . each-any))))
                c1443)))
            (chi-local-syntax494
             (lambda (rec?1497 e1492 r1496 w1493 ae1495 k1494)
               ((lambda (tmp1498)
                  ((lambda (tmp1499)
                     (if tmp1499
                         (apply
                           (lambda (_1504 id1500 val1503 e11501 e21502)
                             ((lambda (ids1505)
                                (if (not (valid-bound-ids?435 ids1505))
                                    (invalid-ids-error437
                                      (map (lambda (x1506)
                                             (wrap439 x1506 w1493))
                                           ids1505)
                                      (source-wrap440 e1492 w1493 ae1495)
                                      '"keyword")
                                    ((lambda (labels1507)
                                       ((lambda (new-w1508)
                                          (k1494
                                            (cons e11501 e21502)
                                            (extend-env*306
                                              labels1507
                                              ((lambda (w1510 trans-r1509)
                                                 (map (lambda (x1512)
                                                        (defer-or-eval-transformer315
                                                          (chi481
                                                            x1512
                                                            trans-r1509
                                                            w1510)))
                                                      val1503))
                                               (if rec?1497
                                                   new-w1508
                                                   w1493)
                                               (transformer-env308 r1496))
                                              r1496)
                                            new-w1508
                                            ae1495))
                                        (make-binding-wrap415
                                          ids1505
                                          labels1507
                                          w1493)))
                                     (gen-labels365 ids1505))))
                              id1500))
                           tmp1499)
                         ((lambda (_1515)
                            (syntax-error
                              (source-wrap440 e1492 w1493 ae1495)))
                          tmp1498)))
                   ($syntax-dispatch
                     tmp1498
                     '(any #(each (any any)) any . each-any))))
                e1492)))
            (chi-void495 (lambda () (list 'void)))
            (ellipsis?496
             (lambda (x1491)
               (if (nonsymbol-id?317 x1491)
                   (literal-id=?433
                     x1491
                     '#(syntax-object ... ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup sanitize-binding lookup* displaced-lexical-error displaced-lexical? transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check no-source unannotate self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                   '#f)))
            (strip-annotation497
             (lambda (x1470)
               (if (pair? x1470)
                   (cons (strip-annotation497 (car x1470))
                         (strip-annotation497 (cdr x1470)))
                   (if (annotation?132 x1470)
                       (annotation-stripped x1470)
                       x1470))))
            (strip*498
             (lambda (x1484 w1482 fn1483)
               (if (memq 'top (wrap-marks326 w1482))
                   (fn1483 x1484)
                   ((letrec ((f1485
                              (lambda (x1486)
                                (if (syntax-object?64 x1486)
                                    (strip*498
                                      (syntax-object-expression65 x1486)
                                      (syntax-object-wrap66 x1486)
                                      fn1483)
                                    (if (pair? x1486)
                                        ((lambda (a1488 d1487)
                                           (if (if (eq? a1488 (car x1486))
                                                   (eq? d1487 (cdr x1486))
                                                   '#f)
                                               x1486
                                               (cons a1488 d1487)))
                                         (f1485 (car x1486))
                                         (f1485 (cdr x1486)))
                                        (if (vector? x1486)
                                            ((lambda (old1489)
                                               ((lambda (new1490)
                                                  (if (andmap
                                                        eq?
                                                        old1489
                                                        new1490)
                                                      x1486
                                                      (list->vector
                                                        new1490)))
                                                (map f1485 old1489)))
                                             (vector->list x1486))
                                            x1486))))))
                      f1485)
                    x1484))))
            (strip499
             (lambda (x1472 w1471)
               (strip*498
                 x1472
                 w1471
                 (lambda (x1473)
                   (if ((lambda (t1474)
                          (if t1474
                              t1474
                              (if (pair? x1473)
                                  (annotation?132 (car x1473))
                                  '#f)))
                        (annotation?132 x1473))
                       (strip-annotation497 x1473)
                       x1473)))))
            (gen-var500
             (lambda (id1480)
               ((lambda (id1481)
                  (if (annotation?132 id1481) (gensym) (gensym)))
                (if (syntax-object?64 id1480)
                    (syntax-object-expression65 id1480)
                    id1480))))
            (lambda-var-list501
             (lambda (vars1475)
               ((letrec ((lvl1476
                          (lambda (vars1479 ls1477 w1478)
                            (if (pair? vars1479)
                                (lvl1476
                                  (cdr vars1479)
                                  (cons (wrap439 (car vars1479) w1478)
                                        ls1477)
                                  w1478)
                                (if (id?318 vars1479)
                                    (cons (wrap439 vars1479 w1478) ls1477)
                                    (if (null? vars1479)
                                        ls1477
                                        (if (syntax-object?64 vars1479)
                                            (lvl1476
                                              (syntax-object-expression65
                                                vars1479)
                                              ls1477
                                              (join-wraps420
                                                w1478
                                                (syntax-object-wrap66
                                                  vars1479)))
                                            (if (annotation?132 vars1479)
                                                (lvl1476
                                                  (annotation-expression
                                                    vars1479)
                                                  ls1477
                                                  w1478)
                                                (cons vars1479
                                                      ls1477)))))))))
                  lvl1476)
                vars1475
                '()
                '(())))))
     (begin (set! $sc-put-cte
              (lambda (id909 b907 top-token908)
                (letrec ((sc-put-module910
                          (lambda (exports927 token926)
                            (vfor-each475
                              (lambda (id928)
                                (store-import-binding414 id928 token926))
                              exports927)))
                         (put-cte911
                          (lambda (id924 binding922 token923)
                            ((lambda (sym925)
                               (put-global-definition-hook142
                                 sym925
                                 (if (if (eq? (binding-type291 binding922)
                                              'global)
                                         (eq? (binding-value292 binding922)
                                              sym925)
                                         '#f)
                                     '#f
                                     binding922)))
                             (if (symbol? id924)
                                 id924
                                 (id-var-name431 id924 '(())))))))
                  ((lambda (binding912)
                     ((lambda (t913)
                        (if (memv t913 '($module))
                            (begin ((lambda (iface914)
                                      (sc-put-module910
                                        (interface-exports450 iface914)
                                        (interface-token451 iface914)))
                                    (binding-value292 binding912))
                                   (put-cte911
                                     id909
                                     binding912
                                     top-token908))
                            (if (memv t913 '(do-import))
                                ((lambda (import-only?916 token915)
                                   ((lambda (b917)
                                      ((lambda (t918)
                                         (if (memv t918 '($module))
                                             ((lambda (iface919)
                                                ((lambda (exports920)
                                                   ((lambda ()
                                                      (begin (if (not (eq? (interface-token451
                                                                             iface919)
                                                                           token915))
                                                                 (syntax-error
                                                                   id909
                                                                   '"import mismatch for module")
                                                                 (void))
                                                             (sc-put-module910
                                                               exports920
                                                               top-token908)))))
                                                 (interface-exports450
                                                   iface919)))
                                              (binding-value292 b917))
                                             (syntax-error
                                               id909
                                               '"import from unknown module")))
                                       (binding-type291 b917)))
                                    (lookup313
                                      (id-var-name431 id909 '(()))
                                      '())))
                                 (car (binding-value292 b907))
                                 (cdr (binding-value292 b907)))
                                (put-cte911
                                  id909
                                  binding912
                                  top-token908))))
                      (binding-type291 binding912)))
                   ((lambda (t921)
                      (if t921
                          t921
                          (error 'define-syntax
                            '"invalid transformer ~s"
                            b907)))
                    (sanitize-binding312 b907))))))
            (global-extend316 'local-syntax 'letrec-syntax '#t)
            (global-extend316 'local-syntax 'let-syntax '#f)
            (global-extend316
              'core
              'fluid-let-syntax
              (lambda (e505 r502 w504 ae503)
                ((lambda (tmp506)
                   ((lambda (tmp507)
                      (if (if tmp507
                              (apply
                                (lambda (_512 var508 val511 e1509 e2510)
                                  (valid-bound-ids?435 var508))
                                tmp507)
                              '#f)
                          (apply
                            (lambda (_518 var514 val517 e1515 e2516)
                              ((lambda (names519)
                                 (begin (for-each
                                          (lambda (id526 n525)
                                            ((lambda (t527)
                                               (if (memv t527
                                                         '(displaced-lexical))
                                                   (displaced-lexical-error310
                                                     (wrap439 id526 w504))
                                                   (void)))
                                             (binding-type291
                                               (lookup313 n525 r502))))
                                          var514
                                          names519)
                                        (chi-body486
                                          (cons e1515 e2516)
                                          (source-wrap440 e505 w504 ae503)
                                          (extend-env*306
                                            names519
                                            ((lambda (trans-r520)
                                               (map (lambda (x522)
                                                      (cons 'deferred
                                                            (chi481
                                                              x522
                                                              trans-r520
                                                              w504)))
                                                    val517))
                                             (transformer-env308 r502))
                                            r502)
                                          w504)))
                               (map (lambda (x529)
                                      (id-var-name431 x529 w504))
                                    var514)))
                            tmp507)
                          ((lambda (_530)
                             (syntax-error
                               (source-wrap440 e505 w504 ae503)))
                           tmp506)))
                    ($syntax-dispatch
                      tmp506
                      '(any #(each (any any)) any . each-any))))
                 e505)))
            (global-extend316
              'core
              'quote
              (lambda (e901 r898 w900 ae899)
                ((lambda (tmp902)
                   ((lambda (tmp903)
                      (if tmp903
                          (apply
                            (lambda (_905 e904)
                              (list 'quote (strip499 e904 w900)))
                            tmp903)
                          ((lambda (_906)
                             (syntax-error
                               (source-wrap440 e901 w900 ae899)))
                           tmp902)))
                    ($syntax-dispatch tmp902 '(any any))))
                 e901)))
            (global-extend316
              'core
              'syntax
              ((lambda ()
                 (letrec ((gen-syntax531
                           (lambda (src589 e585 r588 maps586 ellipsis?587)
                             (if (id?318 e585)
                                 ((lambda (label590)
                                    ((lambda (b591)
                                       (if (eq? (binding-type291 b591)
                                                'syntax)
                                           (call-with-values
                                             (lambda ()
                                               ((lambda (var.lev594)
                                                  (gen-ref532
                                                    src589
                                                    (car var.lev594)
                                                    (cdr var.lev594)
                                                    maps586))
                                                (binding-value292 b591)))
                                             (lambda (var593 maps592)
                                               (values
                                                 (list 'ref var593)
                                                 maps592)))
                                           (if (ellipsis?587 e585)
                                               (syntax-error
                                                 src589
                                                 '"misplaced ellipsis in syntax form")
                                               (values
                                                 (list 'quote e585)
                                                 maps586))))
                                     (lookup313 label590 r588)))
                                  (id-var-name431 e585 '(())))
                                 ((lambda (tmp595)
                                    ((lambda (tmp596)
                                       (if (if tmp596
                                               (apply
                                                 (lambda (dots598 e597)
                                                   (ellipsis?587 dots598))
                                                 tmp596)
                                               '#f)
                                           (apply
                                             (lambda (dots600 e599)
                                               (gen-syntax531
                                                 src589
                                                 e599
                                                 r588
                                                 maps586
                                                 (lambda (x601) '#f)))
                                             tmp596)
                                           ((lambda (tmp602)
                                              (if (if tmp602
                                                      (apply
                                                        (lambda (x605
                                                                 dots603
                                                                 y604)
                                                          (ellipsis?587
                                                            dots603))
                                                        tmp602)
                                                      '#f)
                                                  (apply
                                                    (lambda (x608
                                                             dots606
                                                             y607)
                                                      ((letrec ((f609
                                                                 (lambda (y611
                                                                          k610)
                                                                   ((lambda (tmp612)
                                                                      ((lambda (tmp613)
                                                                         (if (if tmp613
                                                                                 (apply
                                                                                   (lambda (dots615
                                                                                            y614)
                                                                                     (ellipsis?587
                                                                                       dots615))
                                                                                   tmp613)
                                                                                 '#f)
                                                                             (apply
                                                                               (lambda (dots617
                                                                                        y616)
                                                                                 (f609 y616
                                                                                       (lambda (maps618)
                                                                                         (call-with-values
                                                                                           (lambda ()
                                                                                             (k610 (cons '()
                                                                                                         maps618)))
                                                                                           (lambda (x620
                                                                                                    maps619)
                                                                                             (if (null?
                                                                                                   (car maps619))
                                                                                                 (syntax-error
                                                                                                   src589
                                                                                                   '"extra ellipsis in syntax form")
                                                                                                 (values
                                                                                                   (gen-mappend534
                                                                                                     x620
                                                                                                     (car maps619))
                                                                                                   (cdr maps619))))))))
                                                                               tmp613)
                                                                             ((lambda (_621)
                                                                                (call-with-values
                                                                                  (lambda ()
                                                                                    (gen-syntax531
                                                                                      src589
                                                                                      y611
                                                                                      r588
                                                                                      maps586
                                                                                      ellipsis?587))
                                                                                  (lambda (y623
                                                                                           maps622)
                                                                                    (call-with-values
                                                                                      (lambda ()
                                                                                        (k610 maps622))
                                                                                      (lambda (x625
                                                                                               maps624)
                                                                                        (values
                                                                                          (gen-append533
                                                                                            x625
                                                                                            y623)
                                                                                          maps624))))))
                                                                              tmp612)))
                                                                       ($syntax-dispatch
                                                                         tmp612
                                                                         '(any .
                                                                               any))))
                                                                    y611))))
                                                         f609)
                                                       y607
                                                       (lambda (maps626)
                                                         (call-with-values
                                                           (lambda ()
                                                             (gen-syntax531
                                                               src589
                                                               x608
                                                               r588
                                                               (cons '()
                                                                     maps626)
                                                               ellipsis?587))
                                                           (lambda (x628
                                                                    maps627)
                                                             (if (null?
                                                                   (car maps627))
                                                                 (syntax-error
                                                                   src589
                                                                   '"extra ellipsis in syntax form")
                                                                 (values
                                                                   (gen-map535
                                                                     x628
                                                                     (car maps627))
                                                                   (cdr maps627))))))))
                                                    tmp602)
                                                  ((lambda (tmp629)
                                                     (if tmp629
                                                         (apply
                                                           (lambda (x631
                                                                    y630)
                                                             (call-with-values
                                                               (lambda ()
                                                                 (gen-syntax531
                                                                   src589
                                                                   x631
                                                                   r588
                                                                   maps586
                                                                   ellipsis?587))
                                                               (lambda (xnew633
                                                                        maps632)
                                                                 (call-with-values
                                                                   (lambda ()
                                                                     (gen-syntax531
                                                                       src589
                                                                       y630
                                                                       r588
                                                                       maps632
                                                                       ellipsis?587))
                                                                   (lambda (ynew635
                                                                            maps634)
                                                                     (values
                                                                       (gen-cons536
                                                                         e585
                                                                         x631
                                                                         y630
                                                                         xnew633
                                                                         ynew635)
                                                                       maps634))))))
                                                           tmp629)
                                                         ((lambda (tmp636)
                                                            (if tmp636
                                                                (apply
                                                                  (lambda (x1638
                                                                           x2637)
                                                                    ((lambda (ls639)
                                                                       (call-with-values
                                                                         (lambda ()
                                                                           (gen-syntax531
                                                                             src589
                                                                             ls639
                                                                             r588
                                                                             maps586
                                                                             ellipsis?587))
                                                                         (lambda (lsnew641
                                                                                  maps640)
                                                                           (values
                                                                             (gen-vector537
                                                                               e585
                                                                               ls639
                                                                               lsnew641)
                                                                             maps640))))
                                                                     (cons x1638
                                                                           x2637)))
                                                                  tmp636)
                                                                ((lambda (_643)
                                                                   (values
                                                                     (list 'quote
                                                                           e585)
                                                                     maps586))
                                                                 tmp595)))
                                                          ($syntax-dispatch
                                                            tmp595
                                                            '#(vector
                                                               (any .
                                                                    each-any))))))
                                                   ($syntax-dispatch
                                                     tmp595
                                                     '(any . any)))))
                                            ($syntax-dispatch
                                              tmp595
                                              '(any any . any)))))
                                     ($syntax-dispatch tmp595 '(any any))))
                                  e585))))
                          (gen-ref532
                           (lambda (src554 var551 level553 maps552)
                             (if (= level553 '0)
                                 (values var551 maps552)
                                 (if (null? maps552)
                                     (syntax-error
                                       src554
                                       '"missing ellipsis in syntax form")
                                     (call-with-values
                                       (lambda ()
                                         (gen-ref532
                                           src554
                                           var551
                                           (- level553 '1)
                                           (cdr maps552)))
                                       (lambda (outer-var556 outer-maps555)
                                         ((lambda (b557)
                                            (if b557
                                                (values (cdr b557) maps552)
                                                ((lambda (inner-var558)
                                                   (values
                                                     inner-var558
                                                     (cons (cons (cons outer-var556
                                                                       inner-var558)
                                                                 (car maps552))
                                                           outer-maps555)))
                                                 (gen-var500 'tmp))))
                                          (assq outer-var556
                                                (car maps552)))))))))
                          (gen-append533
                           (lambda (x584 y583)
                             (if (equal? y583 ''())
                                 x584
                                 (list 'append x584 y583))))
                          (gen-mappend534
                           (lambda (e560 map-env559)
                             (list 'apply
                                   '(primitive append)
                                   (gen-map535 e560 map-env559))))
                          (gen-map535
                           (lambda (e576 map-env575)
                             ((lambda (formals578 actuals577)
                                (if (eq? (car e576) 'ref)
                                    (car actuals577)
                                    (if (andmap
                                          (lambda (x579)
                                            (if (eq? (car x579) 'ref)
                                                (memq (cadr x579)
                                                      formals578)
                                                '#f))
                                          (cdr e576))
                                        (cons 'map
                                              (cons (list 'primitive
                                                          (car e576))
                                                    (map ((lambda (r580)
                                                            (lambda (x581)
                                                              (cdr (assq (cadr x581)
                                                                         r580))))
                                                          (map cons
                                                               formals578
                                                               actuals577))
                                                         (cdr e576))))
                                        (cons 'map
                                              (cons (list 'lambda
                                                          formals578
                                                          e576)
                                                    actuals577)))))
                              (map cdr map-env575)
                              (map (lambda (x582) (list 'ref (car x582)))
                                   map-env575))))
                          (gen-cons536
                           (lambda (e565 x561 y564 xnew562 ynew563)
                             ((lambda (t566)
                                (if (memv t566 '(quote))
                                    (if (eq? (car xnew562) 'quote)
                                        ((lambda (xnew568 ynew567)
                                           (if (if (eq? xnew568 x561)
                                                   (eq? ynew567 y564)
                                                   '#f)
                                               (list 'quote e565)
                                               (list 'quote
                                                     (cons xnew568
                                                           ynew567))))
                                         (cadr xnew562)
                                         (cadr ynew563))
                                        (if (eq? (cadr ynew563) '())
                                            (list 'list xnew562)
                                            (list 'cons xnew562 ynew563)))
                                    (if (memv t566 '(list))
                                        (cons 'list
                                              (cons xnew562 (cdr ynew563)))
                                        (list 'cons xnew562 ynew563))))
                              (car ynew563))))
                          (gen-vector537
                           (lambda (e574 ls572 lsnew573)
                             (if (eq? (car lsnew573) 'quote)
                                 (if (eq? (cadr lsnew573) ls572)
                                     (list 'quote e574)
                                     (list 'quote
                                           (list->vector (cadr lsnew573))))
                                 (if (eq? (car lsnew573) 'list)
                                     (cons 'vector (cdr lsnew573))
                                     (list 'list->vector lsnew573)))))
                          (regen538
                           (lambda (x569)
                             ((lambda (t570)
                                (if (memv t570 '(ref))
                                    (cadr x569)
                                    (if (memv t570 '(primitive))
                                        (cadr x569)
                                        (if (memv t570 '(quote))
                                            (list 'quote (cadr x569))
                                            (if (memv t570 '(lambda))
                                                (list 'lambda
                                                      (cadr x569)
                                                      (regen538
                                                        (caddr x569)))
                                                (if (memv t570 '(map))
                                                    ((lambda (ls571)
                                                       (cons (if (= (length
                                                                      ls571)
                                                                    '2)
                                                                 'map
                                                                 'map)
                                                             ls571))
                                                     (map regen538
                                                          (cdr x569)))
                                                    (cons (car x569)
                                                          (map regen538
                                                               (cdr x569)))))))))
                              (car x569)))))
                   (lambda (e542 r539 w541 ae540)
                     ((lambda (e543)
                        ((lambda (tmp544)
                           ((lambda (tmp545)
                              (if tmp545
                                  (apply
                                    (lambda (_547 x546)
                                      (call-with-values
                                        (lambda ()
                                          (gen-syntax531
                                            e543
                                            x546
                                            r539
                                            '()
                                            ellipsis?496))
                                        (lambda (e549 maps548)
                                          (regen538 e549))))
                                    tmp545)
                                  ((lambda (_550) (syntax-error e543))
                                   tmp544)))
                            ($syntax-dispatch tmp544 '(any any))))
                         e543))
                      (source-wrap440 e542 w541 ae540)))))))
            (global-extend316
              'core
              'lambda
              (lambda (e891 r888 w890 ae889)
                ((lambda (tmp892)
                   ((lambda (tmp893)
                      (if tmp893
                          (apply
                            (lambda (_895 c894)
                              (chi-lambda-clause493
                                (source-wrap440 e891 w890 ae889)
                                c894
                                r888
                                w890
                                (lambda (vars897 body896)
                                  (list 'lambda vars897 body896))))
                            tmp893)
                          (syntax-error tmp892)))
                    ($syntax-dispatch tmp892 '(any . any))))
                 e891)))
            (global-extend316
              'core
              'letrec
              (lambda (e647 r644 w646 ae645)
                ((lambda (tmp648)
                   ((lambda (tmp649)
                      (if tmp649
                          (apply
                            (lambda (_654 id650 val653 e1651 e2652)
                              ((lambda (ids655)
                                 (if (not (valid-bound-ids?435 ids655))
                                     (invalid-ids-error437
                                       (map (lambda (x656)
                                              (wrap439 x656 w646))
                                            ids655)
                                       (source-wrap440 e647 w646 ae645)
                                       '"bound variable")
                                     ((lambda (labels658 new-vars657)
                                        ((lambda (w660 r659)
                                           (build-letrec248
                                             ae645
                                             new-vars657
                                             (map (lambda (x663)
                                                    (chi481
                                                      x663
                                                      r659
                                                      w660))
                                                  val653)
                                             (chi-body486
                                               (cons e1651 e2652)
                                               (source-wrap440
                                                 e647
                                                 w660
                                                 ae645)
                                               r659
                                               w660)))
                                         (make-binding-wrap415
                                           ids655
                                           labels658
                                           w646)
                                         (extend-var-env*307
                                           labels658
                                           new-vars657
                                           r644)))
                                      (gen-labels365 ids655)
                                      (map gen-var500 ids655))))
                               id650))
                            tmp649)
                          ((lambda (_665)
                             (syntax-error
                               (source-wrap440 e647 w646 ae645)))
                           tmp648)))
                    ($syntax-dispatch
                      tmp648
                      '(any #(each (any any)) any . each-any))))
                 e647)))
            (global-extend316
              'core
              'if
              (lambda (e876 r873 w875 ae874)
                ((lambda (tmp877)
                   ((lambda (tmp878)
                      (if tmp878
                          (apply
                            (lambda (_881 test879 then880)
                              (list 'if
                                    (chi481 test879 r873 w875)
                                    (chi481 then880 r873 w875)
                                    (chi-void495)))
                            tmp878)
                          ((lambda (tmp882)
                             (if tmp882
                                 (apply
                                   (lambda (_886 test883 then885 else884)
                                     (list 'if
                                           (chi481 test883 r873 w875)
                                           (chi481 then885 r873 w875)
                                           (chi481 else884 r873 w875)))
                                   tmp882)
                                 ((lambda (_887)
                                    (syntax-error
                                      (source-wrap440 e876 w875 ae874)))
                                  tmp877)))
                           ($syntax-dispatch tmp877 '(any any any any)))))
                    ($syntax-dispatch tmp877 '(any any any))))
                 e876)))
            (global-extend316 'set! 'set! '())
            (global-extend316 'begin 'begin '())
            (global-extend316 '$module-key '$module '())
            (global-extend316 '$import '$import '#f)
            (global-extend316 '$import '$import-only '#t)
            (global-extend316 'define 'define '())
            (global-extend316 'define-syntax 'define-syntax '())
            (global-extend316 'eval-when 'eval-when '())
            (global-extend316
              'core
              'syntax-case
              ((lambda ()
                 (letrec ((convert-pattern666
                           (lambda (pattern735 keys734)
                             (letrec ((cvt*736
                                       (lambda (p*781 n779 ids780)
                                         (if (null? p*781)
                                             (values '() ids780)
                                             (call-with-values
                                               (lambda ()
                                                 (cvt*736
                                                   (cdr p*781)
                                                   n779
                                                   ids780))
                                               (lambda (y783 ids782)
                                                 (call-with-values
                                                   (lambda ()
                                                     (cvt737
                                                       (car p*781)
                                                       n779
                                                       ids782))
                                                   (lambda (x785 ids784)
                                                     (values
                                                       (cons x785 y783)
                                                       ids784))))))))
                                      (cvt737
                                       (lambda (p740 n738 ids739)
                                         (if (id?318 p740)
                                             (if (bound-id-member?438
                                                   p740
                                                   keys734)
                                                 (values
                                                   (vector 'free-id p740)
                                                   ids739)
                                                 (values
                                                   'any
                                                   (cons (cons p740 n738)
                                                         ids739)))
                                             ((lambda (tmp741)
                                                ((lambda (tmp742)
                                                   (if (if tmp742
                                                           (apply
                                                             (lambda (x744
                                                                      dots743)
                                                               (ellipsis?496
                                                                 dots743))
                                                             tmp742)
                                                           '#f)
                                                       (apply
                                                         (lambda (x746
                                                                  dots745)
                                                           (call-with-values
                                                             (lambda ()
                                                               (cvt737
                                                                 x746
                                                                 (+ n738
                                                                    '1)
                                                                 ids739))
                                                             (lambda (p748
                                                                      ids747)
                                                               (values
                                                                 (if (eq? p748
                                                                          'any)
                                                                     'each-any
                                                                     (vector
                                                                       'each
                                                                       p748))
                                                                 ids747))))
                                                         tmp742)
                                                       ((lambda (tmp749)
                                                          (if (if tmp749
                                                                  (apply
                                                                    (lambda (x753
                                                                             dots750
                                                                             y752
                                                                             z751)
                                                                      (ellipsis?496
                                                                        dots750))
                                                                    tmp749)
                                                                  '#f)
                                                              (apply
                                                                (lambda (x757
                                                                         dots754
                                                                         y756
                                                                         z755)
                                                                  (call-with-values
                                                                    (lambda ()
                                                                      (cvt737
                                                                        z755
                                                                        n738
                                                                        ids739))
                                                                    (lambda (z759
                                                                             ids758)
                                                                      (call-with-values
                                                                        (lambda ()
                                                                          (cvt*736
                                                                            y756
                                                                            n738
                                                                            ids758))
                                                                        (lambda (y761
                                                                                 ids760)
                                                                          (call-with-values
                                                                            (lambda ()
                                                                              (cvt737
                                                                                x757
                                                                                (+ n738
                                                                                   '1)
                                                                                ids760))
                                                                            (lambda (x763
                                                                                     ids762)
                                                                              (values
                                                                                (vector
                                                                                  'each+
                                                                                  x763
                                                                                  (reverse
                                                                                    y761)
                                                                                  z759)
                                                                                ids762))))))))
                                                                tmp749)
                                                              ((lambda (tmp765)
                                                                 (if tmp765
                                                                     (apply
                                                                       (lambda (x767
                                                                                y766)
                                                                         (call-with-values
                                                                           (lambda ()
                                                                             (cvt737
                                                                               y766
                                                                               n738
                                                                               ids739))
                                                                           (lambda (y769
                                                                                    ids768)
                                                                             (call-with-values
                                                                               (lambda ()
                                                                                 (cvt737
                                                                                   x767
                                                                                   n738
                                                                                   ids768))
                                                                               (lambda (x771
                                                                                        ids770)
                                                                                 (values
                                                                                   (cons x771
                                                                                         y769)
                                                                                   ids770))))))
                                                                       tmp765)
                                                                     ((lambda (tmp772)
                                                                        (if tmp772
                                                                            (apply
                                                                              (lambda ()
                                                                                (values
                                                                                  '()
                                                                                  ids739))
                                                                              tmp772)
                                                                            ((lambda (tmp773)
                                                                               (if tmp773
                                                                                   (apply
                                                                                     (lambda (x774)
                                                                                       (call-with-values
                                                                                         (lambda ()
                                                                                           (cvt737
                                                                                             x774
                                                                                             n738
                                                                                             ids739))
                                                                                         (lambda (p776
                                                                                                  ids775)
                                                                                           (values
                                                                                             (vector
                                                                                               'vector
                                                                                               p776)
                                                                                             ids775))))
                                                                                     tmp773)
                                                                                   ((lambda (x778)
                                                                                      (values
                                                                                        (vector
                                                                                          'atom
                                                                                          (strip499
                                                                                            p740
                                                                                            '(())))
                                                                                        ids739))
                                                                                    tmp741)))
                                                                             ($syntax-dispatch
                                                                               tmp741
                                                                               '#(vector
                                                                                  each-any)))))
                                                                      ($syntax-dispatch
                                                                        tmp741
                                                                        '()))))
                                                               ($syntax-dispatch
                                                                 tmp741
                                                                 '(any .
                                                                       any)))))
                                                        ($syntax-dispatch
                                                          tmp741
                                                          '(any any
                                                                .
                                                                #(each+
                                                                  any
                                                                  ()
                                                                  any))))))
                                                 ($syntax-dispatch
                                                   tmp741
                                                   '(any any))))
                                              p740)))))
                               (cvt737 pattern735 '0 '()))))
                          (build-dispatch-call667
                           (lambda (pvars689 exp686 y688 r687)
                             ((lambda (ids691 levels690)
                                ((lambda (labels693 new-vars692)
                                   (list 'apply
                                         (list 'lambda
                                               new-vars692
                                               (chi481
                                                 exp686
                                                 (extend-env*306
                                                   labels693
                                                   (map (lambda (var695
                                                                 level694)
                                                          (cons 'syntax
                                                                (cons var695
                                                                      level694)))
                                                        new-vars692
                                                        (map cdr pvars689))
                                                   r687)
                                                 (make-binding-wrap415
                                                   ids691
                                                   labels693
                                                   '(()))))
                                         y688))
                                 (gen-labels365 ids691)
                                 (map gen-var500 ids691)))
                              (map car pvars689)
                              (map cdr pvars689))))
                          (gen-clause668
                           (lambda (x717
                                    keys711
                                    clauses716
                                    r712
                                    pat715
                                    fender713
                                    exp714)
                             (call-with-values
                               (lambda ()
                                 (convert-pattern666 pat715 keys711))
                               (lambda (p719 pvars718)
                                 (if (not (distinct-bound-ids?436
                                            (map car pvars718)))
                                     (invalid-ids-error437
                                       (map car pvars718)
                                       pat715
                                       '"pattern variable")
                                     (if (not (andmap
                                                (lambda (x720)
                                                  (not (ellipsis?496
                                                         (car x720))))
                                                pvars718))
                                         (syntax-error
                                           pat715
                                           '"misplaced ellipsis in syntax-case pattern")
                                         ((lambda (y721)
                                            (list (list 'lambda
                                                        (list y721)
                                                        (list 'if
                                                              ((lambda (tmp731)
                                                                 ((lambda (tmp732)
                                                                    (if tmp732
                                                                        (apply
                                                                          (lambda ()
                                                                            y721)
                                                                          tmp732)
                                                                        ((lambda (_733)
                                                                           (list 'if
                                                                                 y721
                                                                                 (build-dispatch-call667
                                                                                   pvars718
                                                                                   fender713
                                                                                   y721
                                                                                   r712)
                                                                                 (list 'quote
                                                                                       '#f)))
                                                                         tmp731)))
                                                                  ($syntax-dispatch
                                                                    tmp731
                                                                    '#(atom
                                                                       #t))))
                                                               fender713)
                                                              (build-dispatch-call667
                                                                pvars718
                                                                exp714
                                                                y721
                                                                r712)
                                                              (gen-syntax-case669
                                                                x717
                                                                keys711
                                                                clauses716
                                                                r712)))
                                                  (if (eq? p719 'any)
                                                      (list 'list x717)
                                                      (list '$syntax-dispatch
                                                            x717
                                                            (list 'quote
                                                                  p719)))))
                                          (gen-var500 'tmp))))))))
                          (gen-syntax-case669
                           (lambda (x699 keys696 clauses698 r697)
                             (if (null? clauses698)
                                 (list 'syntax-error x699)
                                 ((lambda (tmp700)
                                    ((lambda (tmp701)
                                       (if tmp701
                                           (apply
                                             (lambda (pat703 exp702)
                                               (if (if (id?318 pat703)
                                                       (if (not (bound-id-member?438
                                                                  pat703
                                                                  keys696))
                                                           (not (ellipsis?496
                                                                  pat703))
                                                           '#f)
                                                       '#f)
                                                   ((lambda (label705
                                                             var704)
                                                      (list (list 'lambda
                                                                  (list var704)
                                                                  (chi481
                                                                    exp702
                                                                    (extend-env305
                                                                      label705
                                                                      (cons 'syntax
                                                                            (cons var704
                                                                                  '0))
                                                                      r697)
                                                                    (make-binding-wrap415
                                                                      (list pat703)
                                                                      (list label705)
                                                                      '(()))))
                                                            x699))
                                                    (gen-label363)
                                                    (gen-var500 pat703))
                                                   (gen-clause668
                                                     x699
                                                     keys696
                                                     (cdr clauses698)
                                                     r697
                                                     pat703
                                                     '#t
                                                     exp702)))
                                             tmp701)
                                           ((lambda (tmp706)
                                              (if tmp706
                                                  (apply
                                                    (lambda (pat709
                                                             fender707
                                                             exp708)
                                                      (gen-clause668
                                                        x699
                                                        keys696
                                                        (cdr clauses698)
                                                        r697
                                                        pat709
                                                        fender707
                                                        exp708))
                                                    tmp706)
                                                  ((lambda (_710)
                                                     (syntax-error
                                                       (car clauses698)
                                                       '"invalid syntax-case clause"))
                                                   tmp700)))
                                            ($syntax-dispatch
                                              tmp700
                                              '(any any any)))))
                                     ($syntax-dispatch tmp700 '(any any))))
                                  (car clauses698))))))
                   (lambda (e673 r670 w672 ae671)
                     ((lambda (e674)
                        ((lambda (tmp675)
                           ((lambda (tmp676)
                              (if tmp676
                                  (apply
                                    (lambda (_680 val677 key679 m678)
                                      (if (andmap
                                            (lambda (x682)
                                              (if (id?318 x682)
                                                  (not (ellipsis?496 x682))
                                                  '#f))
                                            key679)
                                          ((lambda (x683)
                                             (list (list 'lambda
                                                         (list x683)
                                                         (gen-syntax-case669
                                                           x683
                                                           key679
                                                           m678
                                                           r670))
                                                   (chi481
                                                     val677
                                                     r670
                                                     '(()))))
                                           (gen-var500 'tmp))
                                          (syntax-error
                                            e674
                                            '"invalid literals list in")))
                                    tmp676)
                                  (syntax-error tmp675)))
                            ($syntax-dispatch
                              tmp675
                              '(any any each-any . each-any))))
                         e674))
                      (source-wrap440 e673 w672 ae671)))))))
            (set! sc-expand
              ((lambda (ctem870 rtem869)
                 (lambda (x871)
                   ((lambda (env872)
                      (if (if (pair? x871)
                              (equal? (car x871) noexpand62)
                              '#f)
                          (cadr x871)
                          (chi-top446
                            x871
                            '()
                            (env-wrap387 env872)
                            ctem870
                            rtem869
                            (env-top-ribcage386 env872))))
                    (interaction-environment))))
               '(e)
               '(e)))
            (set! $make-environment
              (lambda (token787 mutable?786)
                ((lambda (top-ribcage788)
                   (make-env384
                     top-ribcage788
                     (make-wrap325
                       (wrap-marks326 '((top)))
                       (cons top-ribcage788 (wrap-subst327 '((top)))))))
                 (make-top-ribcage374 token787 mutable?786))))
            (set! interaction-environment
              ((lambda (r868) (lambda () r868))
               ($make-environment '*top* '#t)))
            (set! environment? (lambda (x789) (env?385 x789)))
            (set! identifier? (lambda (x867) (nonsymbol-id?317 x867)))
            (set! datum->syntax-object
              (lambda (id791 datum790)
                (begin ((lambda (x792)
                          (if (not (nonsymbol-id?317 x792))
                              (error-hook135
                                'datum->syntax-object
                                '"invalid argument"
                                x792)
                              (void)))
                        id791)
                       (make-syntax-object63
                         datum790
                         (syntax-object-wrap66 id791)))))
            (set! syntax-object->datum
              (lambda (x866) (strip499 x866 '(()))))
            (set! generate-temporaries
              (lambda (ls793)
                (begin ((lambda (x795)
                          (if (not (list? x795))
                              (error-hook135
                                'generate-temporaries
                                '"invalid argument"
                                x795)
                              (void)))
                        ls793)
                       (map (lambda (x794) (wrap439 (gensym) '((top))))
                            ls793))))
            (set! free-identifier=?
              (lambda (x863 y862)
                (begin ((lambda (x865)
                          (if (not (nonsymbol-id?317 x865))
                              (error-hook135
                                'free-identifier=?
                                '"invalid argument"
                                x865)
                              (void)))
                        x863)
                       ((lambda (x864)
                          (if (not (nonsymbol-id?317 x864))
                              (error-hook135
                                'free-identifier=?
                                '"invalid argument"
                                x864)
                              (void)))
                        y862)
                       (free-id=?432 x863 y862))))
            (set! bound-identifier=?
              (lambda (x797 y796)
                (begin ((lambda (x799)
                          (if (not (nonsymbol-id?317 x799))
                              (error-hook135
                                'bound-identifier=?
                                '"invalid argument"
                                x799)
                              (void)))
                        x797)
                       ((lambda (x798)
                          (if (not (nonsymbol-id?317 x798))
                              (error-hook135
                                'bound-identifier=?
                                '"invalid argument"
                                x798)
                              (void)))
                        y796)
                       (bound-id=?434 x797 y796))))
            (set! literal-identifier=?
              (lambda (x859 y858)
                (begin ((lambda (x861)
                          (if (not (nonsymbol-id?317 x861))
                              (error-hook135
                                'literal-identifier=?
                                '"invalid argument"
                                x861)
                              (void)))
                        x859)
                       ((lambda (x860)
                          (if (not (nonsymbol-id?317 x860))
                              (error-hook135
                                'literal-identifier=?
                                '"invalid argument"
                                x860)
                              (void)))
                        y858)
                       (literal-id=?433 x859 y858))))
            (set! syntax-error
              (lambda (object800 . messages801)
                (begin (for-each
                         (lambda (x803)
                           ((lambda (x804)
                              (if (not (string? x804))
                                  (error-hook135
                                    'syntax-error
                                    '"invalid argument"
                                    x804)
                                  (void)))
                            x803))
                         messages801)
                       ((lambda (message802)
                          (error-hook135
                            '#f
                            message802
                            (strip499 object800 '(()))))
                        (if (null? messages801)
                            '"invalid syntax"
                            (apply string-append messages801))))))
            ((lambda ()
               (letrec ((match-each805
                         (lambda (e855 p853 w854)
                           (if (annotation?132 e855)
                               (match-each805
                                 (annotation-expression e855)
                                 p853
                                 w854)
                               (if (pair? e855)
                                   ((lambda (first856)
                                      (if first856
                                          ((lambda (rest857)
                                             (if rest857
                                                 (cons first856 rest857)
                                                 '#f))
                                           (match-each805
                                             (cdr e855)
                                             p853
                                             w854))
                                          '#f))
                                    (match811 (car e855) p853 w854 '()))
                                   (if (null? e855)
                                       '()
                                       (if (syntax-object?64 e855)
                                           (match-each805
                                             (syntax-object-expression65
                                               e855)
                                             p853
                                             (join-wraps420
                                               w854
                                               (syntax-object-wrap66
                                                 e855)))
                                           '#f))))))
                        (match-each+806
                         (lambda (e821
                                  x-pat816
                                  y-pat820
                                  z-pat817
                                  w819
                                  r818)
                           ((letrec ((f822
                                      (lambda (e824 w823)
                                        (if (pair? e824)
                                            (call-with-values
                                              (lambda ()
                                                (f822 (cdr e824) w823))
                                              (lambda (xr*827
                                                       y-pat825
                                                       r826)
                                                (if r826
                                                    (if (null? y-pat825)
                                                        ((lambda (xr828)
                                                           (if xr828
                                                               (values
                                                                 (cons xr828
                                                                       xr*827)
                                                                 y-pat825
                                                                 r826)
                                                               (values
                                                                 '#f
                                                                 '#f
                                                                 '#f)))
                                                         (match811
                                                           (car e824)
                                                           x-pat816
                                                           w823
                                                           '()))
                                                        (values
                                                          '()
                                                          (cdr y-pat825)
                                                          (match811
                                                            (car e824)
                                                            (car y-pat825)
                                                            w823
                                                            r826)))
                                                    (values '#f '#f '#f))))
                                            (if (annotation?132 e824)
                                                (f822 (annotation-expression
                                                        e824)
                                                      w823)
                                                (if (syntax-object?64 e824)
                                                    (f822 (syntax-object-expression65
                                                            e824)
                                                          (join-wraps420
                                                            w823
                                                            (syntax-object-wrap66
                                                              e824)))
                                                    (values
                                                      '()
                                                      y-pat820
                                                      (match811
                                                        e824
                                                        z-pat817
                                                        w823
                                                        r818))))))))
                              f822)
                            e821
                            w819)))
                        (match-each-any807
                         (lambda (e851 w850)
                           (if (annotation?132 e851)
                               (match-each-any807
                                 (annotation-expression e851)
                                 w850)
                               (if (pair? e851)
                                   ((lambda (l852)
                                      (if l852
                                          (cons (wrap439 (car e851) w850)
                                                l852)
                                          '#f))
                                    (match-each-any807 (cdr e851) w850))
                                   (if (null? e851)
                                       '()
                                       (if (syntax-object?64 e851)
                                           (match-each-any807
                                             (syntax-object-expression65
                                               e851)
                                             (join-wraps420
                                               w850
                                               (syntax-object-wrap66
                                                 e851)))
                                           '#f))))))
                        (match-empty808
                         (lambda (p830 r829)
                           (if (null? p830)
                               r829
                               (if (eq? p830 'any)
                                   (cons '() r829)
                                   (if (pair? p830)
                                       (match-empty808
                                         (car p830)
                                         (match-empty808 (cdr p830) r829))
                                       (if (eq? p830 'each-any)
                                           (cons '() r829)
                                           ((lambda (t831)
                                              (if (memv t831 '(each))
                                                  (match-empty808
                                                    (vector-ref p830 '1)
                                                    r829)
                                                  (if (memv t831 '(each+))
                                                      (match-empty808
                                                        (vector-ref
                                                          p830
                                                          '1)
                                                        (match-empty808
                                                          (reverse
                                                            (vector-ref
                                                              p830
                                                              '2))
                                                          (match-empty808
                                                            (vector-ref
                                                              p830
                                                              '3)
                                                            r829)))
                                                      (if (memv t831
                                                                '(free-id
                                                                   atom))
                                                          r829
                                                          (if (memv t831
                                                                    '(vector))
                                                              (match-empty808
                                                                (vector-ref
                                                                  p830
                                                                  '1)
                                                                r829)
                                                              (void))))))
                                            (vector-ref p830 '0))))))))
                        (combine809
                         (lambda (r*849 r848)
                           (if (null? (car r*849))
                               r848
                               (cons (map car r*849)
                                     (combine809 (map cdr r*849) r848)))))
                        (match*810
                         (lambda (e835 p832 w834 r833)
                           (if (null? p832)
                               (if (null? e835) r833 '#f)
                               (if (pair? p832)
                                   (if (pair? e835)
                                       (match811
                                         (car e835)
                                         (car p832)
                                         w834
                                         (match811
                                           (cdr e835)
                                           (cdr p832)
                                           w834
                                           r833))
                                       '#f)
                                   (if (eq? p832 'each-any)
                                       ((lambda (l836)
                                          (if l836 (cons l836 r833) '#f))
                                        (match-each-any807 e835 w834))
                                       ((lambda (t837)
                                          (if (memv t837 '(each))
                                              (if (null? e835)
                                                  (match-empty808
                                                    (vector-ref p832 '1)
                                                    r833)
                                                  ((lambda (r*838)
                                                     (if r*838
                                                         (combine809
                                                           r*838
                                                           r833)
                                                         '#f))
                                                   (match-each805
                                                     e835
                                                     (vector-ref p832 '1)
                                                     w834)))
                                              (if (memv t837 '(free-id))
                                                  (if (id?318 e835)
                                                      (if (literal-id=?433
                                                            (wrap439
                                                              e835
                                                              w834)
                                                            (vector-ref
                                                              p832
                                                              '1))
                                                          r833
                                                          '#f)
                                                      '#f)
                                                  (if (memv t837 '(each+))
                                                      (call-with-values
                                                        (lambda ()
                                                          (match-each+806
                                                            e835
                                                            (vector-ref
                                                              p832
                                                              '1)
                                                            (vector-ref
                                                              p832
                                                              '2)
                                                            (vector-ref
                                                              p832
                                                              '3)
                                                            w834
                                                            r833))
                                                        (lambda (xr*841
                                                                 y-pat839
                                                                 r840)
                                                          (if r840
                                                              (if (null?
                                                                    y-pat839)
                                                                  (if (null?
                                                                        xr*841)
                                                                      (match-empty808
                                                                        (vector-ref
                                                                          p832
                                                                          '1)
                                                                        r840)
                                                                      (combine809
                                                                        xr*841
                                                                        r840))
                                                                  '#f)
                                                              '#f)))
                                                      (if (memv t837
                                                                '(atom))
                                                          (if (equal?
                                                                (vector-ref
                                                                  p832
                                                                  '1)
                                                                (strip499
                                                                  e835
                                                                  w834))
                                                              r833
                                                              '#f)
                                                          (if (memv t837
                                                                    '(vector))
                                                              (if (vector?
                                                                    e835)
                                                                  (match811
                                                                    (vector->list
                                                                      e835)
                                                                    (vector-ref
                                                                      p832
                                                                      '1)
                                                                    w834
                                                                    r833)
                                                                  '#f)
                                                              (void)))))))
                                        (vector-ref p832 '0)))))))
                        (match811
                         (lambda (e845 p842 w844 r843)
                           (if (not r843)
                               '#f
                               (if (eq? p842 'any)
                                   (cons (wrap439 e845 w844) r843)
                                   (if (syntax-object?64 e845)
                                       (match*810
                                         ((lambda (e846)
                                            (if (annotation?132 e846)
                                                (annotation-expression
                                                  e846)
                                                e846))
                                          (syntax-object-expression65
                                            e845))
                                         p842
                                         (join-wraps420
                                           w844
                                           (syntax-object-wrap66 e845))
                                         r843)
                                       (match*810
                                         ((lambda (e847)
                                            (if (annotation?132 e847)
                                                (annotation-expression
                                                  e847)
                                                e847))
                                          e845)
                                         p842
                                         w844
                                         r843)))))))
                 (set! $syntax-dispatch
                   (lambda (e813 p812)
                     (if (eq? p812 'any)
                         (list e813)
                         (if (syntax-object?64 e813)
                             (match*810
                               ((lambda (e814)
                                  (if (annotation?132 e814)
                                      (annotation-expression e814)
                                      e814))
                                (syntax-object-expression65 e813))
                               p812
                               (syntax-object-wrap66 e813)
                               '())
                             (match*810
                               ((lambda (e815)
                                  (if (annotation?132 e815)
                                      (annotation-expression e815)
                                      e815))
                                e813)
                               p812
                               '(())
                               '()))))))))))))
($sc-put-cte
  'module
  (lambda (x2040)
    (letrec ((proper-export?2041
              (lambda (e2064)
                ((lambda (tmp2065)
                   ((lambda (tmp2066)
                      (if tmp2066
                          (apply
                            (lambda (id2068 e2067)
                              (if (identifier? id2068)
                                  (andmap proper-export?2041 e2067)
                                  '#f))
                            tmp2066)
                          ((lambda (id2070) (identifier? id2070))
                           tmp2065)))
                    ($syntax-dispatch tmp2065 '(any . each-any))))
                 e2064))))
      ((lambda (tmp2042)
         ((lambda (orig2043)
            ((lambda (tmp2044)
               ((lambda (tmp2045)
                  (if tmp2045
                      (apply
                        (lambda (_2048 e2046 d2047)
                          (if (andmap proper-export?2041 e2046)
                              (list '#(syntax-object begin ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                    (cons '#(syntax-object $module ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          (cons orig2043
                                                (cons '#(syntax-object anon ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                      (cons e2046 d2047))))
                                    (cons '#(syntax-object $import ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          (cons orig2043
                                                '#(syntax-object (anon) ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))))
                              (syntax-error
                                x2040
                                '"invalid exports list in")))
                        tmp2045)
                      ((lambda (tmp2052)
                         (if (if tmp2052
                                 (apply
                                   (lambda (_2056 m2053 e2055 d2054)
                                     (identifier? m2053))
                                   tmp2052)
                                 '#f)
                             (apply
                               (lambda (_2060 m2057 e2059 d2058)
                                 (if (andmap proper-export?2041 e2059)
                                     (cons '#(syntax-object $module ((top) #(ribcage #(_ m e d) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           (cons orig2043
                                                 (cons m2057
                                                       (cons e2059
                                                             d2058))))
                                     (syntax-error
                                       x2040
                                       '"invalid exports list in")))
                               tmp2052)
                             (syntax-error tmp2044)))
                       ($syntax-dispatch
                         tmp2044
                         '(any any each-any . each-any)))))
                ($syntax-dispatch tmp2044 '(any each-any . each-any))))
             x2040))
          tmp2042))
       x2040)))
  '*top*)
($sc-put-cte
  'import
  (lambda (x2071)
    ((lambda (tmp2072)
       ((lambda (orig2073)
          ((lambda (tmp2074)
             ((lambda (tmp2075)
                (if (if tmp2075
                        (apply
                          (lambda (_2077 m2076) (identifier? m2076))
                          tmp2075)
                        '#f)
                    (apply
                      (lambda (_2079 m2078)
                        (lambda (r2080)
                          (begin ((lambda (b2081)
                                    (if (not (if (pair? b2081)
                                                 (eq? (car b2081) '$module)
                                                 '#f))
                                        (syntax-error
                                          m2078
                                          '"import from unknown module")
                                        (void)))
                                  (r2080 m2078))
                                 (list '#(syntax-object $import ((top) #(ribcage () () ()) #(ribcage #(r) #((top)) #("i")) #(ribcage #(_ m) #((top) (top)) #("i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                       orig2073
                                       m2078))))
                      tmp2075)
                    (syntax-error tmp2074)))
              ($syntax-dispatch tmp2074 '(any any))))
           x2071))
        tmp2072))
     x2071))
  '*top*)
($sc-put-cte
  'import-only
  (lambda (x2082)
    ((lambda (tmp2083)
       ((lambda (orig2084)
          ((lambda (tmp2085)
             ((lambda (tmp2086)
                (if (if tmp2086
                        (apply
                          (lambda (_2088 m2087) (identifier? m2087))
                          tmp2086)
                        '#f)
                    (apply
                      (lambda (_2090 m2089)
                        (lambda (r2091)
                          (begin ((lambda (b2092)
                                    (if (not (if (pair? b2092)
                                                 (eq? (car b2092) '$module)
                                                 '#f))
                                        (syntax-error
                                          m2089
                                          '"import from unknown module")
                                        (void)))
                                  (r2091 m2089))
                                 (list '#(syntax-object $import-only ((top) #(ribcage () () ()) #(ribcage #(r) #((top)) #("i")) #(ribcage #(_ m) #((top) (top)) #("i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                       orig2084
                                       m2089))))
                      tmp2086)
                    (syntax-error tmp2085)))
              ($syntax-dispatch tmp2085 '(any any))))
           x2082))
        tmp2083))
     x2082))
  '*top*)
($sc-put-cte
  'with-syntax
  (lambda (x2093)
    ((lambda (tmp2094)
       ((lambda (tmp2095)
          (if tmp2095
              (apply
                (lambda (_2098 e12096 e22097)
                  (cons '#(syntax-object begin ((top) #(ribcage #(_ e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        (cons e12096 e22097)))
                tmp2095)
              ((lambda (tmp2100)
                 (if tmp2100
                     (apply
                       (lambda (_2105 out2101 in2104 e12102 e22103)
                         (list '#(syntax-object syntax-case ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                               in2104
                               '()
                               (list out2101
                                     (cons '#(syntax-object begin ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           (cons e12102 e22103)))))
                       tmp2100)
                     ((lambda (tmp2107)
                        (if tmp2107
                            (apply
                              (lambda (_2112 out2108 in2111 e12109 e22110)
                                (list '#(syntax-object syntax-case ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                      (cons '#(syntax-object list ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                            in2111)
                                      '()
                                      (list out2108
                                            (cons '#(syntax-object begin ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                  (cons e12109 e22110)))))
                              tmp2107)
                            (syntax-error tmp2094)))
                      ($syntax-dispatch
                        tmp2094
                        '(any #(each (any any)) any . each-any)))))
               ($syntax-dispatch
                 tmp2094
                 '(any ((any any)) any . each-any)))))
        ($syntax-dispatch tmp2094 '(any () any . each-any))))
     x2093))
  '*top*)
($sc-put-cte
  'syntax-rules
  (lambda (x2116)
    ((lambda (tmp2117)
       ((lambda (tmp2118)
          (if tmp2118
              (apply
                (lambda (_2123 k2119 keyword2122 pattern2120 template2121)
                  (list '#(syntax-object lambda ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        '#(syntax-object (x) ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        (cons '#(syntax-object syntax-case ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              (cons '#(syntax-object x ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                    (cons k2119
                                          (map (lambda (tmp2126 tmp2125)
                                                 (list (cons '#(syntax-object dummy ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                             tmp2125)
                                                       (list '#(syntax-object syntax ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                             tmp2126)))
                                               template2121
                                               pattern2120))))))
                tmp2118)
              (syntax-error tmp2117)))
        ($syntax-dispatch
          tmp2117
          '(any each-any . #(each ((any . any) any))))))
     x2116))
  '*top*)
($sc-put-cte
  'or
  (lambda (x2127)
    ((lambda (tmp2128)
       ((lambda (tmp2129)
          (if tmp2129
              (apply
                (lambda (_2130)
                  '#(syntax-object #f ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                tmp2129)
              ((lambda (tmp2131)
                 (if tmp2131
                     (apply (lambda (_2133 e2132) e2132) tmp2131)
                     ((lambda (tmp2134)
                        (if tmp2134
                            (apply
                              (lambda (_2138 e12135 e22137 e32136)
                                (list '#(syntax-object let ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                      (list (list '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                  e12135))
                                      (list '#(syntax-object if ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                            '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                            '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                            (cons '#(syntax-object or ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                  (cons e22137 e32136)))))
                              tmp2134)
                            (syntax-error tmp2128)))
                      ($syntax-dispatch
                        tmp2128
                        '(any any any . each-any)))))
               ($syntax-dispatch tmp2128 '(any any)))))
        ($syntax-dispatch tmp2128 '(any))))
     x2127))
  '*top*)
($sc-put-cte
  'and
  (lambda (x2140)
    ((lambda (tmp2141)
       ((lambda (tmp2142)
          (if tmp2142
              (apply
                (lambda (_2146 e12143 e22145 e32144)
                  (cons '#(syntax-object if ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        (cons e12143
                              (cons (cons '#(syntax-object and ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          (cons e22145 e32144))
                                    '#(syntax-object (#f) ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))))
                tmp2142)
              ((lambda (tmp2148)
                 (if tmp2148
                     (apply (lambda (_2150 e2149) e2149) tmp2148)
                     ((lambda (tmp2151)
                        (if tmp2151
                            (apply
                              (lambda (_2152)
                                '#(syntax-object #t ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                              tmp2151)
                            (syntax-error tmp2141)))
                      ($syntax-dispatch tmp2141 '(any)))))
               ($syntax-dispatch tmp2141 '(any any)))))
        ($syntax-dispatch tmp2141 '(any any any . each-any))))
     x2140))
  '*top*)
($sc-put-cte
  'let
  (lambda (x2153)
    ((lambda (tmp2154)
       ((lambda (tmp2155)
          (if (if tmp2155
                  (apply
                    (lambda (_2160 x2156 v2159 e12157 e22158)
                      (andmap identifier? x2156))
                    tmp2155)
                  '#f)
              (apply
                (lambda (_2166 x2162 v2165 e12163 e22164)
                  (cons (cons '#(syntax-object lambda ((top) #(ribcage #(_ x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              (cons x2162 (cons e12163 e22164)))
                        v2165))
                tmp2155)
              ((lambda (tmp2170)
                 (if (if tmp2170
                         (apply
                           (lambda (_2176 f2171 x2175 v2172 e12174 e22173)
                             (andmap identifier? (cons f2171 x2175)))
                           tmp2170)
                         '#f)
                     (apply
                       (lambda (_2183 f2178 x2182 v2179 e12181 e22180)
                         (cons (list '#(syntax-object letrec ((top) #(ribcage #(_ f x v e1 e2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                     (list (list f2178
                                                 (cons '#(syntax-object lambda ((top) #(ribcage #(_ f x v e1 e2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (cons x2182
                                                             (cons e12181
                                                                   e22180)))))
                                     f2178)
                               v2179))
                       tmp2170)
                     (syntax-error tmp2154)))
               ($syntax-dispatch
                 tmp2154
                 '(any any #(each (any any)) any . each-any)))))
        ($syntax-dispatch
          tmp2154
          '(any #(each (any any)) any . each-any))))
     x2153))
  '*top*)
($sc-put-cte
  'let*
  (lambda (x2187)
    ((lambda (tmp2188)
       ((lambda (tmp2189)
          (if (if tmp2189
                  (apply
                    (lambda (let*2194 x2190 v2193 e12191 e22192)
                      (andmap identifier? x2190))
                    tmp2189)
                  '#f)
              (apply
                (lambda (let*2200 x2196 v2199 e12197 e22198)
                  ((letrec ((f2201
                             (lambda (bindings2202)
                               (if (null? bindings2202)
                                   (cons '#(syntax-object let ((top) #(ribcage () () ()) #(ribcage #(bindings) #((top)) #("i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(let* x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                         (cons '() (cons e12197 e22198)))
                                   ((lambda (tmp2204)
                                      ((lambda (tmp2205)
                                         (if tmp2205
                                             (apply
                                               (lambda (body2207
                                                        binding2206)
                                                 (list '#(syntax-object let ((top) #(ribcage #(body binding) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(bindings) #((top)) #("i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(let* x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (list binding2206)
                                                       body2207))
                                               tmp2205)
                                             (syntax-error tmp2204)))
                                       ($syntax-dispatch
                                         tmp2204
                                         '(any any))))
                                    (list (f2201 (cdr bindings2202))
                                          (car bindings2202)))))))
                     f2201)
                   (map list x2196 v2199)))
                tmp2189)
              (syntax-error tmp2188)))
        ($syntax-dispatch
          tmp2188
          '(any #(each (any any)) any . each-any))))
     x2187))
  '*top*)
($sc-put-cte
  'cond
  (lambda (x2210)
    ((lambda (tmp2211)
       ((lambda (tmp2212)
          (if tmp2212
              (apply
                (lambda (_2215 m12213 m22214)
                  ((letrec ((f2216
                             (lambda (clause2218 clauses2217)
                               (if (null? clauses2217)
                                   ((lambda (tmp2219)
                                      ((lambda (tmp2220)
                                         (if tmp2220
                                             (apply
                                               (lambda (e12222 e22221)
                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (cons e12222
                                                             e22221)))
                                               tmp2220)
                                             ((lambda (tmp2224)
                                                (if tmp2224
                                                    (apply
                                                      (lambda (e02225)
                                                        (cons '#(syntax-object let ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                              (cons (list (list '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                e02225))
                                                                    '#(syntax-object ((if t t)) ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))))
                                                      tmp2224)
                                                    ((lambda (tmp2226)
                                                       (if tmp2226
                                                           (apply
                                                             (lambda (e02228
                                                                      e12227)
                                                               (list '#(syntax-object let ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                     (list (list '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                 e02228))
                                                                     (list '#(syntax-object if ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                           '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                           (cons e12227
                                                                                 '#(syntax-object (t) ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))))
                                                             tmp2226)
                                                           ((lambda (tmp2229)
                                                              (if tmp2229
                                                                  (apply
                                                                    (lambda (e02232
                                                                             e12230
                                                                             e22231)
                                                                      (list '#(syntax-object if ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                            e02232
                                                                            (cons '#(syntax-object begin ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                  (cons e12230
                                                                                        e22231))))
                                                                    tmp2229)
                                                                  ((lambda (_2234)
                                                                     (syntax-error
                                                                       x2210))
                                                                   tmp2219)))
                                                            ($syntax-dispatch
                                                              tmp2219
                                                              '(any any
                                                                    .
                                                                    each-any)))))
                                                     ($syntax-dispatch
                                                       tmp2219
                                                       '(any #(free-id
                                                               #(syntax-object => ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                                             any)))))
                                              ($syntax-dispatch
                                                tmp2219
                                                '(any)))))
                                       ($syntax-dispatch
                                         tmp2219
                                         '(#(free-id
                                             #(syntax-object else ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                            any
                                            .
                                            each-any))))
                                    clause2218)
                                   ((lambda (tmp2235)
                                      ((lambda (rest2236)
                                         ((lambda (tmp2237)
                                            ((lambda (tmp2238)
                                               (if tmp2238
                                                   (apply
                                                     (lambda (e02239)
                                                       (list '#(syntax-object let ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                             (list (list '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                         e02239))
                                                             (list '#(syntax-object if ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                   '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                   '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                   rest2236)))
                                                     tmp2238)
                                                   ((lambda (tmp2240)
                                                      (if tmp2240
                                                          (apply
                                                            (lambda (e02242
                                                                     e12241)
                                                              (list '#(syntax-object let ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                    (list (list '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                e02242))
                                                                    (list '#(syntax-object if ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                          '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                          (cons e12241
                                                                                '#(syntax-object (t) ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                                                          rest2236)))
                                                            tmp2240)
                                                          ((lambda (tmp2243)
                                                             (if tmp2243
                                                                 (apply
                                                                   (lambda (e02246
                                                                            e12244
                                                                            e22245)
                                                                     (list '#(syntax-object if ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                           e02246
                                                                           (cons '#(syntax-object begin ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                 (cons e12244
                                                                                       e22245))
                                                                           rest2236))
                                                                   tmp2243)
                                                                 ((lambda (_2248)
                                                                    (syntax-error
                                                                      x2210))
                                                                  tmp2237)))
                                                           ($syntax-dispatch
                                                             tmp2237
                                                             '(any any
                                                                   .
                                                                   each-any)))))
                                                    ($syntax-dispatch
                                                      tmp2237
                                                      '(any #(free-id
                                                              #(syntax-object => ((top) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                                            any)))))
                                             ($syntax-dispatch
                                               tmp2237
                                               '(any))))
                                          clause2218))
                                       tmp2235))
                                    (f2216
                                      (car clauses2217)
                                      (cdr clauses2217)))))))
                     f2216)
                   m12213
                   m22214))
                tmp2212)
              (syntax-error tmp2211)))
        ($syntax-dispatch tmp2211 '(any any . each-any))))
     x2210))
  '*top*)
($sc-put-cte
  'do
  (lambda (orig-x2250)
    ((lambda (tmp2251)
       ((lambda (tmp2252)
          (if tmp2252
              (apply
                (lambda (_2259
                         var2253
                         init2258
                         step2254
                         e02257
                         e12255
                         c2256)
                  ((lambda (tmp2260)
                     ((lambda (tmp2270)
                        (if tmp2270
                            (apply
                              (lambda (step2271)
                                ((lambda (tmp2272)
                                   ((lambda (tmp2274)
                                      (if tmp2274
                                          (apply
                                            (lambda ()
                                              (list '#(syntax-object let ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                    '#(syntax-object doloop ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                    (map list
                                                         var2253
                                                         init2258)
                                                    (list '#(syntax-object if ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                          (list '#(syntax-object not ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                e02257)
                                                          (cons '#(syntax-object begin ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                (append
                                                                  c2256
                                                                  (list (cons '#(syntax-object doloop ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                              step2271)))))))
                                            tmp2274)
                                          ((lambda (tmp2279)
                                             (if tmp2279
                                                 (apply
                                                   (lambda (e12281 e22280)
                                                     (list '#(syntax-object let ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                           '#(syntax-object doloop ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                           (map list
                                                                var2253
                                                                init2258)
                                                           (list '#(syntax-object if ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                 e02257
                                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                       (cons e12281
                                                                             e22280))
                                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                       (append
                                                                         c2256
                                                                         (list (cons '#(syntax-object doloop ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                     step2271)))))))
                                                   tmp2279)
                                                 (syntax-error tmp2272)))
                                           ($syntax-dispatch
                                             tmp2272
                                             '(any . each-any)))))
                                    ($syntax-dispatch tmp2272 '())))
                                 e12255))
                              tmp2270)
                            (syntax-error tmp2260)))
                      ($syntax-dispatch tmp2260 'each-any)))
                   (map (lambda (v2264 s2263)
                          ((lambda (tmp2265)
                             ((lambda (tmp2266)
                                (if tmp2266
                                    (apply (lambda () v2264) tmp2266)
                                    ((lambda (tmp2267)
                                       (if tmp2267
                                           (apply
                                             (lambda (e2268) e2268)
                                             tmp2267)
                                           ((lambda (_2269)
                                              (syntax-error orig-x2250))
                                            tmp2265)))
                                     ($syntax-dispatch tmp2265 '(any)))))
                              ($syntax-dispatch tmp2265 '())))
                           s2263))
                        var2253
                        step2254)))
                tmp2252)
              (syntax-error tmp2251)))
        ($syntax-dispatch
          tmp2251
          '(any #(each (any any . any))
                (any . each-any)
                .
                each-any))))
     orig-x2250))
  '*top*)
($sc-put-cte
  'quasiquote
  (letrec ((isquote?2295
            (lambda (x2407)
              (if (identifier? x2407)
                  (free-identifier=?
                    x2407
                    '#(syntax-object quote ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                  '#f)))
           (islist?2287
            (lambda (x2301)
              (if (identifier? x2301)
                  (free-identifier=?
                    x2301
                    '#(syntax-object list ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                  '#f)))
           (iscons?2294
            (lambda (x2406)
              (if (identifier? x2406)
                  (free-identifier=?
                    x2406
                    '#(syntax-object cons ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                  '#f)))
           (quote-nil?2288
            (lambda (x2302)
              ((lambda (tmp2303)
                 ((lambda (tmp2304)
                    (if tmp2304
                        (apply
                          (lambda (quote?2305) (isquote?2295 quote?2305))
                          tmp2304)
                        ((lambda (_2306) '#f) tmp2303)))
                  ($syntax-dispatch tmp2303 '(any ()))))
               x2302)))
           (quasilist*2293
            (lambda (x2403 y2402)
              ((letrec ((f2404
                         (lambda (x2405)
                           (if (null? x2405)
                               y2402
                               (quasicons2289
                                 (car x2405)
                                 (f2404 (cdr x2405)))))))
                 f2404)
               x2403)))
           (quasicons2289
            (lambda (x2308 y2307)
              ((lambda (tmp2309)
                 ((lambda (tmp2310)
                    (if tmp2310
                        (apply
                          (lambda (x2312 y2311)
                            ((lambda (tmp2313)
                               ((lambda (tmp2314)
                                  (if (if tmp2314
                                          (apply
                                            (lambda (quote?2316 dy2315)
                                              (isquote?2295 quote?2316))
                                            tmp2314)
                                          '#f)
                                      (apply
                                        (lambda (quote?2318 dy2317)
                                          ((lambda (tmp2319)
                                             ((lambda (tmp2320)
                                                (if (if tmp2320
                                                        (apply
                                                          (lambda (quote?2322
                                                                   dx2321)
                                                            (isquote?2295
                                                              quote?2322))
                                                          tmp2320)
                                                        '#f)
                                                    (apply
                                                      (lambda (quote?2324
                                                               dx2323)
                                                        (list '#(syntax-object quote ((top) #(ribcage #(quote? dx) #((top) (top)) #("i" "i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                              (cons dx2323
                                                                    dy2317)))
                                                      tmp2320)
                                                    ((lambda (_2325)
                                                       (if (null? dy2317)
                                                           (list '#(syntax-object list ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                 x2312)
                                                           (list '#(syntax-object cons ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                 x2312
                                                                 y2311)))
                                                     tmp2319)))
                                              ($syntax-dispatch
                                                tmp2319
                                                '(any any))))
                                           x2312))
                                        tmp2314)
                                      ((lambda (tmp2326)
                                         (if (if tmp2326
                                                 (apply
                                                   (lambda (listp2328
                                                            stuff2327)
                                                     (islist?2287
                                                       listp2328))
                                                   tmp2326)
                                                 '#f)
                                             (apply
                                               (lambda (listp2330
                                                        stuff2329)
                                                 (cons '#(syntax-object list ((top) #(ribcage #(listp stuff) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                       (cons x2312
                                                             stuff2329)))
                                               tmp2326)
                                             ((lambda (else2331)
                                                (list '#(syntax-object cons ((top) #(ribcage #(else) #((top)) #("i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                      x2312
                                                      y2311))
                                              tmp2313)))
                                       ($syntax-dispatch
                                         tmp2313
                                         '(any . any)))))
                                ($syntax-dispatch tmp2313 '(any any))))
                             y2311))
                          tmp2310)
                        (syntax-error tmp2309)))
                  ($syntax-dispatch tmp2309 '(any any))))
               (list x2308 y2307))))
           (quasiappend2292
            (lambda (x2394 y2393)
              ((lambda (ls2395)
                 (if (null? ls2395)
                     '#(syntax-object (quote ()) ((top) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                     (if (null? (cdr ls2395))
                         (car ls2395)
                         ((lambda (tmp2396)
                            ((lambda (tmp2397)
                               (if tmp2397
                                   (apply
                                     (lambda (p2398)
                                       (cons '#(syntax-object append ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                             p2398))
                                     tmp2397)
                                   (syntax-error tmp2396)))
                             ($syntax-dispatch tmp2396 'each-any)))
                          ls2395))))
               ((letrec ((f2400
                          (lambda (x2401)
                            (if (null? x2401)
                                (if (quote-nil?2288 y2393)
                                    '()
                                    (list y2393))
                                (if (quote-nil?2288 (car x2401))
                                    (f2400 (cdr x2401))
                                    (cons (car x2401)
                                          (f2400 (cdr x2401))))))))
                  f2400)
                x2394))))
           (quasivector2290
            (lambda (x2332)
              ((lambda (tmp2333)
                 ((lambda (pat-x2334)
                    ((lambda (tmp2335)
                       ((lambda (tmp2336)
                          (if (if tmp2336
                                  (apply
                                    (lambda (quote?2338 x2337)
                                      (isquote?2295 quote?2338))
                                    tmp2336)
                                  '#f)
                              (apply
                                (lambda (quote?2340 x2339)
                                  (list '#(syntax-object quote ((top) #(ribcage #(quote? x) #((top) (top)) #("i" "i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                        (list->vector x2339)))
                                tmp2336)
                              ((lambda (_2342)
                                 ((letrec ((f2343
                                            (lambda (x2345 k2344)
                                              ((lambda (tmp2346)
                                                 ((lambda (tmp2347)
                                                    (if (if tmp2347
                                                            (apply
                                                              (lambda (quote?2349
                                                                       x2348)
                                                                (isquote?2295
                                                                  quote?2349))
                                                              tmp2347)
                                                            '#f)
                                                        (apply
                                                          (lambda (quote?2351
                                                                   x2350)
                                                            (k2344
                                                              (map (lambda (tmp2352)
                                                                     (list '#(syntax-object quote ((top) #(ribcage #(quote? x) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x k) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                           tmp2352))
                                                                   x2350)))
                                                          tmp2347)
                                                        ((lambda (tmp2353)
                                                           (if (if tmp2353
                                                                   (apply
                                                                     (lambda (listp2355
                                                                              x2354)
                                                                       (islist?2287
                                                                         listp2355))
                                                                     tmp2353)
                                                                   '#f)
                                                               (apply
                                                                 (lambda (listp2357
                                                                          x2356)
                                                                   (k2344
                                                                     x2356))
                                                                 tmp2353)
                                                               ((lambda (tmp2359)
                                                                  (if (if tmp2359
                                                                          (apply
                                                                            (lambda (cons?2362
                                                                                     x2360
                                                                                     y2361)
                                                                              (iscons?2294
                                                                                cons?2362))
                                                                            tmp2359)
                                                                          '#f)
                                                                      (apply
                                                                        (lambda (cons?2365
                                                                                 x2363
                                                                                 y2364)
                                                                          (f2343
                                                                            y2364
                                                                            (lambda (ls2366)
                                                                              (k2344
                                                                                (cons x2363
                                                                                      ls2366)))))
                                                                        tmp2359)
                                                                      ((lambda (else2367)
                                                                         (list '#(syntax-object list->vector ((top) #(ribcage #(else) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x k) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                               pat-x2334))
                                                                       tmp2346)))
                                                                ($syntax-dispatch
                                                                  tmp2346
                                                                  '(any any
                                                                        any)))))
                                                         ($syntax-dispatch
                                                           tmp2346
                                                           '(any .
                                                                 each-any)))))
                                                  ($syntax-dispatch
                                                    tmp2346
                                                    '(any each-any))))
                                               x2345))))
                                    f2343)
                                  x2332
                                  (lambda (ls2368)
                                    (cons '#(syntax-object vector ((top) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                          ls2368))))
                               tmp2335)))
                        ($syntax-dispatch tmp2335 '(any each-any))))
                     pat-x2334))
                  tmp2333))
               x2332)))
           (quasi2291
            (lambda (p2370 lev2369)
              ((lambda (tmp2371)
                 ((lambda (tmp2372)
                    (if tmp2372
                        (apply
                          (lambda (p2373)
                            (if (= lev2369 '0)
                                p2373
                                (quasicons2289
                                  '#(syntax-object (quote unquote) ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                  (quasi2291
                                    (list p2373)
                                    (- lev2369 '1)))))
                          tmp2372)
                        ((lambda (tmp2374)
                           (if tmp2374
                               (apply
                                 (lambda (p2376 q2375)
                                   (if (= lev2369 '0)
                                       (quasilist*2293
                                         p2376
                                         (quasi2291 q2375 lev2369))
                                       (quasicons2289
                                         (quasicons2289
                                           '#(syntax-object (quote unquote) ((top) #(ribcage #(p q) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                           (quasi2291
                                             p2376
                                             (- lev2369 '1)))
                                         (quasi2291 q2375 lev2369))))
                                 tmp2374)
                               ((lambda (tmp2379)
                                  (if tmp2379
                                      (apply
                                        (lambda (p2381 q2380)
                                          (if (= lev2369 '0)
                                              (quasiappend2292
                                                p2381
                                                (quasi2291 q2380 lev2369))
                                              (quasicons2289
                                                (quasicons2289
                                                  '#(syntax-object (quote unquote-splicing) ((top) #(ribcage #(p q) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                  (quasi2291
                                                    p2381
                                                    (- lev2369 '1)))
                                                (quasi2291
                                                  q2380
                                                  lev2369))))
                                        tmp2379)
                                      ((lambda (tmp2384)
                                         (if tmp2384
                                             (apply
                                               (lambda (p2385)
                                                 (quasicons2289
                                                   '#(syntax-object (quote quasiquote) ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                   (quasi2291
                                                     (list p2385)
                                                     (+ lev2369 '1))))
                                               tmp2384)
                                             ((lambda (tmp2386)
                                                (if tmp2386
                                                    (apply
                                                      (lambda (p2388 q2387)
                                                        (quasicons2289
                                                          (quasi2291
                                                            p2388
                                                            lev2369)
                                                          (quasi2291
                                                            q2387
                                                            lev2369)))
                                                      tmp2386)
                                                    ((lambda (tmp2389)
                                                       (if tmp2389
                                                           (apply
                                                             (lambda (x2390)
                                                               (quasivector2290
                                                                 (quasi2291
                                                                   x2390
                                                                   lev2369)))
                                                             tmp2389)
                                                           ((lambda (p2392)
                                                              (list '#(syntax-object quote ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                    p2392))
                                                            tmp2371)))
                                                     ($syntax-dispatch
                                                       tmp2371
                                                       '#(vector
                                                          each-any)))))
                                              ($syntax-dispatch
                                                tmp2371
                                                '(any . any)))))
                                       ($syntax-dispatch
                                         tmp2371
                                         '(#(free-id
                                             #(syntax-object quasiquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                            any)))))
                                ($syntax-dispatch
                                  tmp2371
                                  '((#(free-id
                                       #(syntax-object unquote-splicing ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                      .
                                      each-any)
                                    .
                                    any)))))
                         ($syntax-dispatch
                           tmp2371
                           '((#(free-id
                                #(syntax-object unquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                               .
                               each-any)
                             .
                             any)))))
                  ($syntax-dispatch
                    tmp2371
                    '(#(free-id
                        #(syntax-object unquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                       any))))
               p2370))))
    (lambda (x2296)
      ((lambda (tmp2297)
         ((lambda (tmp2298)
            (if tmp2298
                (apply (lambda (_2300 e2299) (quasi2291 e2299 '0)) tmp2298)
                (syntax-error tmp2297)))
          ($syntax-dispatch tmp2297 '(any any))))
       x2296)))
  '*top*)
($sc-put-cte
  'include
  (lambda (x2408)
    (letrec ((read-file2409
              (lambda (fn2420 k2419)
                ((lambda (p2421)
                   ((letrec ((f2422
                              (lambda ()
                                ((lambda (x2423)
                                   (if (eof-object? x2423)
                                       (begin (close-input-port p2421) '())
                                       (cons (datum->syntax-object
                                               k2419
                                               x2423)
                                             (f2422))))
                                 (read p2421)))))
                      f2422)))
                 (open-input-file fn2420)))))
      ((lambda (tmp2410)
         ((lambda (tmp2411)
            (if tmp2411
                (apply
                  (lambda (k2413 filename2412)
                    ((lambda (fn2414)
                       ((lambda (tmp2415)
                          ((lambda (tmp2416)
                             (if tmp2416
                                 (apply
                                   (lambda (exp2417)
                                     (cons '#(syntax-object begin ((top) #(ribcage #(exp) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(fn) #((top)) #("i")) #(ribcage #(k filename) #((top) (top)) #("i" "i")) #(ribcage (read-file) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           exp2417))
                                   tmp2416)
                                 (syntax-error tmp2415)))
                           ($syntax-dispatch tmp2415 'each-any)))
                        (read-file2409 fn2414 k2413)))
                     (syntax-object->datum filename2412)))
                  tmp2411)
                (syntax-error tmp2410)))
          ($syntax-dispatch tmp2410 '(any any))))
       x2408)))
  '*top*)
($sc-put-cte
  'unquote
  (lambda (x2424)
    ((lambda (tmp2425)
       ((lambda (tmp2426)
          (if tmp2426
              (apply
                (lambda (_2428 e2427)
                  (syntax-error
                    x2424
                    '"expression not valid outside of quasiquote"))
                tmp2426)
              (syntax-error tmp2425)))
        ($syntax-dispatch tmp2425 '(any . each-any))))
     x2424))
  '*top*)
($sc-put-cte
  'unquote-splicing
  (lambda (x2429)
    ((lambda (tmp2430)
       ((lambda (tmp2431)
          (if tmp2431
              (apply
                (lambda (_2433 e2432)
                  (syntax-error
                    x2429
                    '"expression not valid outside of quasiquote"))
                tmp2431)
              (syntax-error tmp2430)))
        ($syntax-dispatch tmp2430 '(any . each-any))))
     x2429))
  '*top*)
($sc-put-cte
  'case
  (lambda (x2434)
    ((lambda (tmp2435)
       ((lambda (tmp2436)
          (if tmp2436
              (apply
                (lambda (_2440 e2437 m12439 m22438)
                  ((lambda (tmp2441)
                     ((lambda (body2468)
                        (list '#(syntax-object let ((top) #(ribcage #(body) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              (list (list '#(syntax-object t ((top) #(ribcage #(body) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          e2437))
                              body2468))
                      tmp2441))
                   ((letrec ((f2442
                              (lambda (clause2444 clauses2443)
                                (if (null? clauses2443)
                                    ((lambda (tmp2445)
                                       ((lambda (tmp2446)
                                          (if tmp2446
                                              (apply
                                                (lambda (e12448 e22447)
                                                  (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                        (cons e12448
                                                              e22447)))
                                                tmp2446)
                                              ((lambda (tmp2450)
                                                 (if tmp2450
                                                     (apply
                                                       (lambda (k2453
                                                                e12451
                                                                e22452)
                                                         (list '#(syntax-object if ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                               (list '#(syntax-object memv ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                     '#(syntax-object t ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                     (list '#(syntax-object quote ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                           k2453))
                                                               (cons '#(syntax-object begin ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                     (cons e12451
                                                                           e22452))))
                                                       tmp2450)
                                                     ((lambda (_2456)
                                                        (syntax-error
                                                          x2434))
                                                      tmp2445)))
                                               ($syntax-dispatch
                                                 tmp2445
                                                 '(each-any
                                                    any
                                                    .
                                                    each-any)))))
                                        ($syntax-dispatch
                                          tmp2445
                                          '(#(free-id
                                              #(syntax-object else ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                             any
                                             .
                                             each-any))))
                                     clause2444)
                                    ((lambda (tmp2457)
                                       ((lambda (rest2458)
                                          ((lambda (tmp2459)
                                             ((lambda (tmp2460)
                                                (if tmp2460
                                                    (apply
                                                      (lambda (k2463
                                                               e12461
                                                               e22462)
                                                        (list '#(syntax-object if ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                              (list '#(syntax-object memv ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                    '#(syntax-object t ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                    (list '#(syntax-object quote ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                          k2463))
                                                              (cons '#(syntax-object begin ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                    (cons e12461
                                                                          e22462))
                                                              rest2458))
                                                      tmp2460)
                                                    ((lambda (_2466)
                                                       (syntax-error
                                                         x2434))
                                                     tmp2459)))
                                              ($syntax-dispatch
                                                tmp2459
                                                '(each-any
                                                   any
                                                   .
                                                   each-any))))
                                           clause2444))
                                        tmp2457))
                                     (f2442
                                       (car clauses2443)
                                       (cdr clauses2443)))))))
                      f2442)
                    m12439
                    m22438)))
                tmp2436)
              (syntax-error tmp2435)))
        ($syntax-dispatch tmp2435 '(any any any . each-any))))
     x2434))
  '*top*)
($sc-put-cte
  'identifier-syntax
  (lambda (x2469)
    ((lambda (tmp2470)
       ((lambda (tmp2471)
          (if tmp2471
              (apply
                (lambda (_2473 e2472)
                  (list '#(syntax-object lambda ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        '#(syntax-object (x) ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        (list '#(syntax-object syntax-case ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              '#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              '()
                              (list '#(syntax-object id ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                    '#(syntax-object (identifier? (syntax id)) ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                    (list '#(syntax-object syntax ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          e2472))
                              (list (cons _2473
                                          '(#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                             #(syntax-object ... ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))
                                    (list '#(syntax-object syntax ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          (cons e2472
                                                '(#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                   #(syntax-object ... ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))))))))
                tmp2471)
              ((lambda (tmp2474)
                 (if (if tmp2474
                         (apply
                           (lambda (_2480
                                    id2475
                                    exp12479
                                    var2476
                                    val2478
                                    exp22477)
                             (if (identifier? id2475)
                                 (identifier? var2476)
                                 '#f))
                           tmp2474)
                         '#f)
                     (apply
                       (lambda (_2486
                                id2481
                                exp12485
                                var2482
                                val2484
                                exp22483)
                         (list '#(syntax-object cons ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                               '#(syntax-object (quote macro!) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                               (list '#(syntax-object lambda ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                     '#(syntax-object (x) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                     (list '#(syntax-object syntax-case ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           '#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           '#(syntax-object (set!) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           (list (list '#(syntax-object set! ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       var2482
                                                       val2484)
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       exp22483))
                                           (list (cons id2481
                                                       '(#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                          #(syntax-object ... ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (cons exp12485
                                                             '(#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                #(syntax-object ... ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))))
                                           (list id2481
                                                 (list '#(syntax-object identifier? ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                             id2481))
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       exp12485))))))
                       tmp2474)
                     (syntax-error tmp2470)))
               ($syntax-dispatch
                 tmp2470
                 '(any (any any)
                       ((#(free-id
                           #(syntax-object set! ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                          any
                          any)
                        any))))))
        ($syntax-dispatch tmp2470 '(any any))))
     x2469))
  '*top*)
