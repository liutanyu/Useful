
(when (app ?L1 ?L2 ?L3) (nonvar ?L1) (nonvar ?L2))
(when (app ?L1 ?L2 ?L3) (nonvar ?L3))
(what (app () ?L ?L) )
(what (app (?H . ?T) ?L (?H . ?NT)) (app ?T ?L ?NT))

(when (unified ?X ?X))
(what (unified ?X ?X))

(when (nrev ?L1 ?L2) (nonvar ?L1))
(what (nrev () ()))
(what (nrev (?H . ?T) ?L) (nrev ?T ?S) (app ?S (?H) ?L))

(when (rev ?L1 ?L2) (nonvar ?L1))
(what (rev ?L1 ?L2) (rev3 ?L1 () ?L2))

(when (rev3 ?L1 ?L2 ?L3) (nonvar ?L1) (nonvar ?L2))
(what (rev3 (?X . ?L) ?L2 ?L3) (rev3 ?L (?X . ?L2) ?L3))
(what (rev3 () ?L ?L))

(when (half ?S ?X))
(what (half ?S ?X)
	(add ?X ?X ?S) (split ?X))

(when (root ?S ?R))
(what (root ?S ?R)
	(mult ?R ?R ?S) (split ?R))

;; poly:  Find solution to the equation X^3-6X^2-7X-6 = 0
(when (poly ?X))
(what (poly ?X)
	(add 6 ?A ?X) (mult ?X ?A ?B) (add 7 ?C ?B) (mult ?X ?C 6))

;; simult:  Solve simultaneous equations X+Y=1, X-Y=2.
(when (simult ?X ?Y))
(what (simult ?X ?Y)
	(add ?X ?Y 1) (add ?Y 2 ?X) (split ?X) (split ?Y))

(when (divisors ?X ?Y ?Z))
(what (divisors ?X ?Y ?Z)
	(mult ?X ?Y ?Z) (geq ?X 1) (neq ?X 1) (geq ?Y ?X)
	(int ?X) (int ?Y) (int ?Z)) 

(when (mod ?X ?Y ?Z))
(what (mod ?X ?Y ?Z)
	(int ?X) (int ?Y) (int ?Z)
	(geq ?Y 1) (add ?M ?Z ?X) (mult ?Y ?N ?M)
	(int ?N) (geq ?Z 0) (geq ?Y ?Z) (neq ?Y ?Z))
(what (mod ?X ?Y ?Z)
	(int ?X) (int ?Y) (int ?Z)
	(geq -1 ?Y) (add ?M ?Z ?X) (mult ?Y ?N ?M)
	(int ?N) (geq 0 ?Z) (geq ?Z ?Y) (neq ?Y ?Z))

(when (fact ?N ?R))
(what (fact 0 1))
(what (fact 1 1))
(what (fact ?N ?R)
	(int ?N) (geq ?N 2) (add ?M 1 ?N) (geq ?R ?N) (mult ?Z ?N ?R)
	(fact ?M ?Z))

(when (floun ?X))
(what (floun ?X)
	(app ?A ?B ?C))
