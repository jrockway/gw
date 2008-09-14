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

(defclass game-state (timed-life)
  ((current-fps :accessor current-fps :initform 0)
   (objects :accessor objects :initform (list) :type list)))

(defmethod tick :around ((state game-state)
                         &optional (current-time (get-current-time)))
  (let ((old-time (current-time state)))
    (call-next-method state current-time)
    (loop for object in (objects state) do (tick object current-time))
    (setf (current-fps state)
          (handler-case (/ 1 (- current-time (or old-time 0)))
            (division-by-zero (e) 0)))))

(defclass drawable-object (timed-life) nil)

(defgeneric add-object (state object))
(defmethod add-object ((state game-state) (object drawable-object))
  (setf (creation-time object) (current-time state))
  (setf (objects state) (cons object (objects state))))

(defgeneric draw (state object))
(defmethod draw (state (object drawable-object)) nil)

(defclass colorful-triangle (drawable-object)
  ((spawned-p :accessor spawned-p :initform nil)
   (offset :accessor offset :type float :initform 0.5 :initarg :offset)))

(defmethod draw ((state game-state) (object colorful-triangle))
  (when (and
         (not (spawned-p object))
         (> (time-alive object) 0.003))
    (add-object state (make-instance 'colorful-triangle
                                     :offset (/ (random 1000) 1000)))
    (setf (spawned-p object) t))

  (let* ((theta (time-alive object))
         (offset (offset object))
         (pos-x (* offset (cos theta)))
         (pos-y (* offset (sin theta))))
    (gl:matrix-mode gl:+modelview+)
    (gl:load-identity)
    (gl:translate-f pos-x pos-y 0.0f0)
    (gl:begin gl:+triangles+)
    (gl:color-3f 0.0f0 1.0f0 0.0f0)
    (gl:vertex-2f -0.1f0 0.00f0)
    (gl:color-3f 1.0f0 0.0f0 0.0f0)
    (gl:vertex-2f  0.00f0 0.2f0)
    (gl:color-3f 0.0f0 0.0f0 1.0f0)
    (gl:vertex-2f  0.1f0 0.00f0)
    (gl:end)))

(defclass fps-monitor (drawable-object)
  ((last-printed :accessor last-printed :initform 0)))

(defmethod draw ((state game-state) (object fps-monitor))
  (when (> (- (current-time object) (last-printed object)) 5)
    (format t "current fps: ~d~%" (coerce (current-fps state) 'float))
    (format t "live object count: ~d~%" (length (objects state)))
    (setf (last-printed object) (current-time object))))
