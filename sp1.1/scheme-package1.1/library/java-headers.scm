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
;; Automatic generation of java header files
;;
;; Stephane Hillion - 1998/12/25
;;
(require 'java-models)
(require 'java-maker)

;; Customizable variable
;(define swing-path "javax.swing.")
(define swing-path "com.sun.java.swing.")

;; Generation of the files
(define maker (<java-maker> create "library/object/java/generated/"))
(define (create-class d)
  (maker create-class d))

(map create-class
     (awt-models))

(map create-class
     (io-models))

(map create-class
     (net-models))

(map create-class
     (util-models))

(map create-class
     (swing-models swing-path))

(map create-class
     (scheme-models))
