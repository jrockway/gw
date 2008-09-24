(in-package #:gw)

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
