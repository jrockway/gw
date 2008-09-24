(in-package #:gw)

(defclass colorful-triangle (has-time-alive has-representation)
  ((spawned-p :accessor spawned-p :initform nil)
   (offset :accessor offset :type float :initform 0.5 :initarg :offset)))

(defmethod current-representation ((state game-state) (object colorful-triangle))
  (make-instance 'closed-path
      :points
      (list (make-instance 'vertex :x 0  :y 0 :color cl-colors:+red+)
            (make-instance 'vertex :x 0  :y 1 :color cl-colors:+green+)
            (make-instance 'vertex :x 1  :y 0 :color cl-colors:+blue+))))

(defclass fps-monitor (has-time-alive has-representation)
  ((last-printed :accessor last-printed :initform 0)))

(defmethod current-representation ((state game-state) (object fps-monitor))
  (when (> (- (current-time object) (last-printed object)) 5)
    (setf (last-printed object) (current-time object))
    (make-instance 'debug-message
                   :text (format nil "current fps: ~d~%live object count: ~d~%"
                                 (coerce (current-fps state) 'float)
                                 (length (objects state))))))
