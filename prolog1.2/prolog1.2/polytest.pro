;;This file will eventually contain procedures for solving general polynomials.
;;It uses the idea that moving the origin of a polynomial is the same as
;; applying the Krawchuk derivative.

(when (eq ?X ?Y))
(what (eq ?X ?X))

(when (poly ?X ?L ?Y) (nonvar ?L))
(what (poly ?X () 0.0))
(what (poly ?X (?H . ?L) ?Y)
;;    (monitor ?Y ("=Y" (?H . ?L) ?X))
;;    (monitor ?T0 ("=T0" (?H . ?L) ?X))
;;    (monitor ?T1 ("=T1" (?H . ?L) ?X))
      (poly ?X ?L ?T0) (mult ?X ?T0 ?T1) (add ?T1 ?H ?Y))

(when (test_poly ?Y))
(what (test_poly ?Y) (poly 2 (1 1 1) ?Y))
(what (test_poly ?Y) (poly 2 (0 0 1) ?Y))

;;X^2=C also use Z=X-1 (X=Z+1) so Z^2 + 2Z + 1 - C = 0
(when (sqrt2 ?C ?X))
(what (sqrt2 ?C ?X)  ;; ?X = sqrt(?C)
      (add ?Z 1 ?X)
      (mult ?X ?X ?C)
      (poly ?Z (1 2 1) ?C)
)

(when (test_sqrt2))
(what (test_sqrt2) (monitor ?X "?X") (sqrt2 2 ?X))

;;The old way of doing sqrt (just for comparison)
(when (split_poly ?X))
(what (split_poly ?X) (geq -1 ?X) (split ?X))
(what (split_poly ?X) (gt ?X -1) (geq 0 ?X) (split ?X))
(what (split_poly ?X) (gt ?X  0) (geq 1 ?X) (split ?X))
(what (split_poly ?X) (gt ?X  1) (split ?X))

(when (sqrt1 ?C ?X))
(what (sqrt1 ?C ?X) (mult ?X ?X ?C) (split_poly ?X))

(when (test_sqrt1))
(what (test_sqrt1) (monitor ?X "?X") (sqrt1 2 ?X))

;;Translate the origin of polynomial in ?X by ?A
;;that is, reformulate as polynomial in ?Z where ?Z = ?X - ?A
(when (poly_a ?A ?X ?L ?Y))
(what (poly_a ?A ?X ?L ?Y)
      (monitor ?Z ("=Z" ?A ?L ?M))
      (add ?Z ?A ?X)
      (pa ?A ?L ?M)
      (poly ?Z ?M ?Y)
)

;;compute coefficients of polynomial in ?Z
(when (pa ?A ?L ?M) (nonvar ?L))
(when (pa ?A ?L ?M) (nonvar ?M))
(what (pa ?A () ()))
(what (pa ?A (?H . ?L) ?M)
      (pa ?A ?L ?T0)
      (pmult ?A ?T0 ?T1)
      (padd (?H . ?T0) ?T1 ?M) ;;?M = ?A*?T0 + ?Z*?T0
)

;;multiply a list by a constant
(when (pmult ?C ?L ?M) (nonvar ?L))
(when (pmult ?C ?L ?M) (nonvar ?M))
(what (pmult ?C () ()))
(what (pmult ?C (?A . ?L) (?B . ?M))
      (mult ?C ?A ?B)
      (pmult ?C ?L ?M)
)

;;Add two lists (extend if necessary)
(when (padd ?L ?M ?N) (nonvar ?L) (nonvar ?M))
(when (padd ?L ?M ?N) (nonvar ?L) (nonvar ?N))
(when (padd ?L ?M ?N) (nonvar ?M) (nonvar ?N))
(what (padd ()  ?N  ?N)
      (not (eq () ?N))
)
(what (padd ?N  ()  ?N)
      (not (eq () ?N))
)
(what (padd ()  ()  ()))
(what (padd (?A . ?L) (?B . ?M) (?C . ?N))
      (add ?A ?B ?C)
      (padd ?L ?M ?N)
)

(when (test_pa ?L))
(what (test_pa ?L) (pa 0 (1 2 3) ?L)) ;;;?L = (1 2 3)
(what (test_pa ?L) (pa  1 (1 2 3) ?L)) ;;;?L = (6 8 3)
(what (test_pa ?L) (pa -1 (1 2 3) ?L)) ;;;?L = (2 -4 3)


(when (cube_rt ?A ?K))
(what (cube_rt ?A ?K)
	(monitor ?X " = X")
	(eq ?P  (0 0 0 1)) ;;X^3
	(ka ?K ?X ?P ?Z)
	(eq ?Z ?A) ;;don't fire constraints until all set up
)

;;;apply a list of Krawchuck constants against a polynomial
(when (ka ?K ?X ?P ?A) (nonvar ?K))
(what (ka () ?X ?P ?A))
(what (ka (?Ka . ?K) ?X ?P ?A)
	(poly_a ?Ka ?X ?P ?A)
	(ka ?K ?X ?P ?A)
)

(when (test_ka ?K ?P))
(what (test_ka ?K ?P)
	(monitor ?X "X = ")
	(monitor ?Y "Y = ")
	(ka ?K ?X ?P ?Y)
	(eq ?Y 0)
)

;;;experiments with cube root
(when (crt1))
(what (crt1)
	(cube_rt 1 (0))
)
(when (crt2))
(what (crt2)
	(cube_rt 1 (0 1))
)
