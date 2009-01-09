(in-package #:gw)

(defconstant +joystick-max+ 32768)

(defclass has-position nil
  ((x :accessor x :initform 0 :initarg :x)
   (y :accessor y :initform 0 :initarg :y)))

(defclass standard-enemy
    (has-time-alive has-representation has-game-state has-position) nil)

(defclass colorful-triangle (standard-enemy) nil)

(defmethod tick :after ((self colorful-triangle))
  (let ((time (time-since-last-tick self))
        (x-speed (/ (x (left-joystick (game-state self))) +joystick-max+))
        (y-speed (/ (y (left-joystick (game-state self))) +joystick-max+))
        (max-speed 8d0))

    (incf (x self) (* x-speed max-speed time))
    (incf (y self) (* y-speed max-speed time))))

(defmethod current-representation ((state game-state) (self colorful-triangle))
  (make-instance 'translate :x (x self) :y (y self)
    :inner-object (make-instance 'rotate
      :angle (degrees (atan (y (right-joystick state))
                            (x (right-joystick state))))
      :inner-object (make-instance 'closed-path
        :points (list (make-instance 'vertex :x 0  :y 0 :color cl-colors:+red+)
                      (make-instance 'vertex :x 0  :y 1 :color cl-colors:+green+)
                      (make-instance 'vertex :x 1  :y 0 :color cl-colors:+blue+))))))

(defclass fps-monitor (has-time-alive has-representation)
  ((last-printed :accessor last-printed :initform 0)))

(defmethod current-representation ((state game-state) (object fps-monitor))
  (when (> (- (current-time object) (last-printed object)) 5)
    (setf (last-printed object) (current-time object))
    (make-instance 'debug-message
                   :text (format nil "current fps: ~d~%live object count: ~d~%"
                                 (coerce (current-fps state) 'float)
                                 (length (objects state))))))
