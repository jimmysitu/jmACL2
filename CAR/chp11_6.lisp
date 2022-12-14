
(include-book "ac-example")

;;; Exercise 11.42
(encapsulate
 ((ac (x y) t))
 (local (defun ac (x y) (declare (ignore x y))
          nil))

 (defthm associativity-of-ac
   (equal (ac (ac x y) z)
          (ac x (ac y z))))

 (defthm commutativity-of-ac
   (equal (ac x y)
          (ac y x))))

;;; Exercise 11.43
(defun map-ac (lst)
  (cond ((endp lst) nil)
        ((endp (cdr lst)) (car lst))
        (t (ac (car lst) (map-ac (cdr lst))))))

(defun map-act-aux (lst a)
  (cond ((endp lst) a)
        (t (map-act-aux (cdr lst) (ac (car lst) a)))))

(defun map-act (lst)
  (cond ((endp lst) nil)
    (t (map-act-aux (cdr lst) (car lst)))))

; Proof helper
(commutativity-2 ac)
;Subgoal *1/3.2
;(IMPLIES (AND (CONSP LST)
;              (CONSP (CDR LST))
;              (CONSP (CDDR LST))
;              (EQUAL (MAP-ACT-AUX (CDDR LST) (CADR LST))
;                     (AC (CADR LST) (MAP-AC (CDDR LST)))))
;         (EQUAL (MAP-ACT-AUX (CDR LST) (CAR LST))
;                (AC (CAR LST)
;                    (MAP-ACT-AUX (CDDR LST) (CADR LST)))))
; [JM] Add theorm about map-act-aux and map-ac
(defthm map-act-aux-equal-map-ac
  (implies (consp lst)
           (equal (map-act-aux lst a)
                  (ac a (map-ac lst)))))

; Proof target
(defthm map-act-equal-map-ac
  (equal (map-act lst) (map-ac lst)))


;;; Exercise 11.44
(defun maxm (a b)
  (if (< a b)
    (fix b)
    (fix a)))

(defthm maxm-commutative
  (equal (maxm a b)
         (maxm b a)))

(defthm maxm-associative
  (equal (maxm (maxm a b) c)
         (maxm a (maxm b c))))

;;; Exercise 11.45
(defun map-maxm (lst)
  (cond ((endp lst) nil)
        ((endp (cdr lst)) (car lst))
        (t (maxm (car lst) (map-maxm (cdr lst))))))

(defun map-maxmt-aux (lst a)
  (cond ((endp lst) a)
        (t (map-maxmt-aux (cdr lst) (maxm (car lst) a)))))

(defun map-maxmt (lst)
  (cond ((endp lst) nil)
    (t (map-maxmt-aux (cdr lst) (car lst)))))

;;; Exercise 11.46
(defthm map-maxmt-equal-map-maxm
  (equal (map-maxmt lst)
         (map-maxm lst))
  :hints (("goal"
           :by (:functional-instance
                map-act-equal-map-ac
                (ac maxm)
                (map-ac map-maxm)
                (map-act-aux map-maxmt-aux)
                (map-act map-maxmt)))))#|ACL2s-ToDo-Line|#






