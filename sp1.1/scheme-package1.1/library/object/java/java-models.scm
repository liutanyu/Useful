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
;; Class models for automatic generation of Java files
;;
;; Stephane Hillion - 1998/12/23
;;
(provide 'java-models)

(define (awt-models) 
  '(
    (<jpoint2d> "java.awt.geom.Point2D" <jobject>
		()
		()
		())

    (<jpoint> "java.awt.Point" <jpoint2d>
	      ;; Constructor
	      (()
	       (<jpoint>)
	       (<jint> <jint>))
	      ;; Fields
	      ((x <jint> "x")
	       (y <jint> "y"))
	      ;; Methods
	      ((move      "move"      ( () <jint> <jint>))
	       (translate "translate" ( () <jint> <jint>))))

    (<jdimension2d> "java.awt.geom.Dimension2D" <jobject>
		  ()
		  ()
		  ())

    (<jdimension> "java.awt.Dimension" <jdimension2D>
		  ;; Constructor
		  (()
		   (<jdimension>)
		   (<jint> <jint>))
		  ;; Fields
		  ((width  <jint> "width")
		   (height <jint> "height"))
		  ;;Methods
		  ((set-size "setSize" ( () <jint> <jint>))))

    (<jrectangle> "java.awt.Rectangle" <jobject> ;; To do Rectangle2D
		  ;; Constructor
		  (()
		   (<jrectangle>)
		   (<jint> <jint>)
		   (<jint> <jint> <jint> <jint>)
		   (<jpoint>)
		   (<jdimension>)
		   (<jpoint> <jdimension>))
		  ;; Fields
		  ((x      <jint> "x")
		   (y      <jint> "y")
		   (width  <jint> "width")
		   (height <jint> "height"))
		  ;; Methods
		  ((set-bounds "setBounds" ( () <jrectangle>)
			                   ( () <jint> <jint> <jint> <jint>))))

    (<jcomponent> "java.awt.Component" <jobject>
		  ()
		  ;; Fields
		  ((top-alignment    final static <jfloat> "TOP_ALIGNMENT")
		   (center-alignment final static <jfloat> "CENTER_ALIGNMENT")
		   (left-alignment   final static <jfloat> "LEFT_ALIGNMENT")
		   (right-alignment  final static <jfloat> "RIGHT_ALIGNMENT")
		   (bottom-alignment final static <jfloat> "BOTTOM_ALIGNMENT"))
		  ;; Methods
		  ((get-bounds
		    "getBounds" ( (<jrectangle>) ))
		   (get-location
		    "getLocation" ( (<jpoint>) ))
		   (get-location-on-screen 
		    "getLocationOnScreen" ( (<jpoint>) ))
		   (get-name
		    "getName" ( (<jstring>) ))
		   (get-parent
		    "getParent" ( (<jcontainer>) ))
		   (get-size
		    "getSize" ( (<jdimension>) ))
		   (enabled?
		    "isEnabled" ( (<jbool>) ))
		   (showing?
		    "isShowing" ( (<jbool>) ))
		   (visible?
		    "isVisible" ( (<jbool>) ))
		   (set-bounds!
		    "setBounds" ( () <jrectangle>)
		                ( () <jint> <jint> <jint> <jint>))
		   (set-enabled!
		    "setEnabled" ( () <jstring>))
		   (set-location!
		    "setLocation" ( () <jint> <jint>)
		                  ( () <jpoint>))
		   (set-name!
		    "setName" ( () <jstring>))
		   (set-size!
		    "setSize" ( () <jint> <jint>)
		              ( () <jdimension>))
		   (set-visible!
		    "setVisible" ( () <jbool>))))

    (<jcontainer> "java.awt.Container" <jcomponent>
		  (())
		  ()
		  ((add
		    "add" ( () <jcomponent>)
		          ( (<jcomponent>) <jstring> <jcomponent>)
			  ( (<jcomponent>) <jcomponent> <jint>)
			  ( () <jcomponent> <jobject>)
			  ( () <jcomponent> <jobject> <jint>))
		   (remove
		    "remove" ( () <jint>)
		             ( () <jcomponent>))
		   (remove-all
		    "removeAll" ( () ))))

    (<jwindow> "java.awt.Window" <jcontainer>
	       ((<jframe>)
		(<jwindow>))
	       ()
	       ())

    (<jframe> "java.awt.Frame" <jwindow>
	      ((<jstring>))
	      ()
	      ((show "show" ( () ))))
    (<jaction-listener> "java.awt.event.ActionListener" <jobject> ()
			()
			()
			())
    ))

(define (io-models)
  '(
    ))

(define (net-models)
  '(
    ))

(define (util-models)
  '(
    ))

(define (swing-models prefix)
  (let ((swing (lambda (str)
		 (string-append prefix str))))
    `(
      (<jjcomponent> ,(swing "JComponent") <jcontainer>
		     ()
		     ()
		     ())

      (<jjfile-chooser> ,(swing "JFileChooser") <jjcomponent>
			(())
			()
			((show-open-dialog "showOpenDialog" ( (<jint>) <jcomponent>))
			 ))

      (<jjroot-pane> ,(swing "JRootPane") <jjcomponent>
		     ()
		     ()
		     ())

      (<jabstract-button> ,(swing "AbstractButton") <jjcomponent>
		     ()
		     ()
		     ((add-action-listener "addActionListener" ( () <jaction-listener>))
		      ))

      (<jjmenu-item> ,(swing "JMenuItem") <jabstract-button>
		     ;; Constructor
		     (()
		      (<jstring>))
		     ()
		     ())

      (<jjmenu> ,(swing "JMenu") <jjmenu-item>
		;; Constructor
		(()
		 (<jstring>)
		 (<jbool>))
		()
		;; Methods
		((add-separator "addSeparator" ( () ))
		 ))

      (<jjmenu-bar> ,(swing "JMenuBar") <jjcomponent>
		    ;; Constructor
		    (())
		    ()
		    ())

      (<jjframe> ,(swing "JFrame") <jframe>
		 ;; Constructor
		 (()
		  (<jstring>))
		 ()
		 ;; Methods
		 ((get-content-pane "getContentPane" ( (<jcontainer>) ))
		  (get-root-pane    "getRootPane"    ( (<jjroot-pane>) ))
		  (set-jmenu-bar!   "setJMenuBar"    ( () <jjmenu-bar>))
		  ))

      (<jjoption-pane> ,(swing "JOptionPane") <jjcomponent>
		       ()
		       ()
		       ;; Methods
		       ((show-message-dialog "showMessageDialog"
					     (static () <jcomponent> <jobject>))
			))
      )))

(define (scheme-models)
  '(
    (<jscm-action-listener>
     "scheme.java.ScmActionListener" <jobject>
			    ;; Constructor
			    ((<jobject> <jobject>))
			    ()
			    ())
    ))
