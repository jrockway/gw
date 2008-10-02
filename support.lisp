(in-package #:gw)

(defun get-current-time nil (gettimeofday))
(defparameter *current-time* 0
  "This is updated by (tick game-state) so that all objects see the same time
   for the same tick.")

(defclass has-time-alive nil
  ((creation-time :accessor creation-time :initform (get-current-time))
   (current-time :accessor current-time :initform 0)
   (last-tick :accessor last-tick :initform 0)))

(defgeneric time-alive (object))
(defmethod time-alive ((object has-time-alive))
  (- (current-time object) (creation-time object)))

(defgeneric time-since-last-tick (object))
(defmethod time-since-last-tick ((object has-time-alive))
  (- (current-time object) (last-tick object)))

(defgeneric tick (object))
(defmethod tick ((object has-time-alive))
  (setf (last-tick object) (current-time object))
  (setf (current-time object) *current-time*))

(defclass has-representation nil nil)
(defgeneric current-representation (state object))
(defmethod current-representation (state (object has-representation)) nil)

(defclass has-position nil
  ((x :accessor x :initform 0)
   (y :accessor y :initform 0)))

; this class is redefined later (in game.lisp)
(defclass game-state (has-time-alive) ())
