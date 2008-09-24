(in-package #:gw)

(defun get-current-time nil (gettimeofday))

(defclass has-time-alive nil
  ((creation-time :accessor creation-time :initform (get-current-time))
   (current-time :accessor current-time :initform 0)))

(defgeneric time-alive (object))
(defmethod time-alive ((object has-time-alive))
  (- (current-time object) (creation-time object)))

(defgeneric tick (object &optional current-time))
(defmethod tick ((object has-time-alive) &optional current-time)
  (setf (current-time object) current-time))

(defclass has-representation nil nil)
(defgeneric current-representation (state object))
(defmethod current-representation (state (object has-representation)) nil)

(defclass has-position nil
  ((x :accessor x :initform 0)
   (y :accessor y :initform 0)))

; this class is redefined later (in game.lisp)
(defclass game-state (has-time-alive) ())
