(in-package #:gw)

(defun get-current-time nil (gettimeofday))

(defclass timed-life nil
  ; represents an object with a "time alive"
  ((creation-time :accessor creation-time :initform (get-current-time))
   (current-time :accessor current-time :initform 0)))

(defgeneric time-alive (object))
(defmethod time-alive ((object timed-life))
  (- (current-time object) (creation-time object)))

(defgeneric tick (object &optional current-time))
(defmethod tick ((object timed-life) &optional current-time)
  (setf (current-time object) current-time))

(defclass drawable-object (timed-life) nil)
(defgeneric draw (state object))
(defmethod draw (state (object drawable-object)) nil)

; this class is redefined later (in game.lisp)
(defclass game-state (timed-life) ())
