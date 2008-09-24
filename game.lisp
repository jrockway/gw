(in-package #:gw)

(defclass game-state (timed-life)
  ((current-fps :accessor current-fps :initform 0)
   (score :accessor score :initform 0 :type integer)
   (lives :accessor lives :initform 3 :type unsigned-byte)
   (active-shots :accessor active-shots :initform NIL :type  list)
   (active-spawn-strategies :accessor active-spawn-strategies :initform NIL
                            :type list)
   (active-enemies :accessor active-enemies :initform NIL :type list)
   (objects :accessor objects :initform NIL :type list)))

(defmethod tick :around ((state game-state)
                         &optional (current-time (get-current-time)))
  (let ((old-time (current-time state)))
    (call-next-method state current-time)
    (loop for object in (objects state) do (tick object current-time))
    (setf (current-fps state)
          (handler-case (/ 1 (- current-time (or old-time 0)))
            (division-by-zero (e) 0)))))

(defgeneric add-object (state object))
(defmethod add-object ((state game-state) (object drawable-object))
  (setf (creation-time object) (current-time state))
  (setf (objects state) (cons object (objects state))))
<<<<<<< Updated upstream:game.lisp
=======

(defgeneric draw (state object))
(defmethod draw (state (object drawable-object)) nil)

(defclass colorful-triangle (drawable-object)
  ((spawned-p :accessor spawned-p :initform nil)
   (offset :accessor offset :type float :initform 0.5 :initarg :offset)))

(defmethod draw ((state game-state) (object colorful-triangle))
  (when (and
         (not (spawned-p object))
         (> (time-alive object) 1))
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
    (gl:color-4f 0.0f0 1.0f0 0.0f0 0.01f0)
    (gl:vertex-2f -0.05f0 0.00f0)
    (gl:color-4f 1.0f0 0.0f0 0.0f0 0.01f0)
    (gl:vertex-2f  0.00f0 0.1f0)
    (gl:color-4f 0.0f0 0.0f0 1.0f0 0.01f0)
    (gl:vertex-2f  0.05f0 0.00f0)
    (gl:end)))

(defclass fps-monitor (drawable-object)
  ((last-printed :accessor last-printed :initform 0)))

(defmethod draw ((state game-state) (object fps-monitor))
  ; draw to the console
  (when (> (- (current-time object) (last-printed object)) 5)
    (format t "current fps: ~d~%" (coerce (current-fps state) 'float))
    (format t "live object count: ~d~%" (length (objects state)))
    (setf (last-printed object) (current-time object)))
  ; draw to GL
  (render-text "OH HAI" (load-font 12) 255 0 255 0f0 0f0))
>>>>>>> Stashed changes:game.lisp
