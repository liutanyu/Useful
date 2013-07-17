(require 'frame)
(require 'menu-bar)

(define frame   (<frame> create "Titre"))

(define (exit-action ev)
  (exit))

(define (about-action ev)
  (exit))

(define menu-bar (<menu-bar> create
			     `(
			       (("File")
				("-")
				(("Exit") . ,exit-action)
				)
			       (("Help")
				("-")
				(("About") . ,about-action)
				)
			       )))

(frame set-menu-bar! menu-bar)
(frame set-size! 500 600)

(frame show)

(print (features))