(in-package #:gw)

(defclass joystick-state nil
  ((y :accessor y :initform 0)
   (x :accessor x :initform 0)))

(defclass game-state (has-time-alive)
  ((current-fps :accessor current-fps :initform 0)
   (score :accessor score :initform 0 :type integer)
   (lives :accessor lives :initform 3 :type unsigned-byte)
   (active-shots :accessor active-shots :initform NIL :type  list)
   (active-spawn-strategies :accessor active-spawn-strategies :initform NIL
                            :type list)
   (active-enemies :accessor active-enemies :initform NIL :type list)
   (objects :accessor objects :initform NIL :type list)
   (left-joystick :accessor left-joystick :initform
                  (make-instance 'joystick-state))
   (right-joystick :accessor right-joystick :initform
                   (make-instance 'joystick-state))))

(defclass has-game-state nil
  ((game-state :accessor game-state :initform nil :type game-state)))

(defgeneric tick (state))
(defmethod tick ((state game-state))
  (setf *current-time* (get-current-time))
  (call-next-method) ; then tick us
  (loop for object in (objects state) do (tick object)) ; then tick our kids
  (setf (current-fps state)
        (handler-case (/ 1 (time-since-last-tick state))
          (division-by-zero (e) 0))))

(defgeneric add-object (state object))
(defmethod add-object ((state game-state) (object has-representation))
  (setf (creation-time object) (current-time state))
  (setf (objects state) (cons object (objects state))))

(defmethod add-object :after ((state game-state) (object has-game-state))
  (setf (game-state object) state))
