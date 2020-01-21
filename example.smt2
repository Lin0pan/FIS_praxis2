(declare-sort Quadrupel 0)
(declare-fun numLengs (Quadrupel) Int)
(declare-const q1 Quadrupel)

;axiome:
(assert (forall ((q Quadrupel)) (= (numLengs q) 4)))    ;numLengs gibt immer 4 zurueck
(assert (= (numLengs q1) 5))                            ;numLengs gibt 5 zurueck --> unsat 
(check-sat)
