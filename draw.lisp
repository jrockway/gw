(in-package #:gw)

(defclass graphical-object nil nil)
(defgeneric draw (object))
(defmethod draw ((object null))) ; ignore NIL

(defclass debug-message (graphical-object)
  ((text :reader text :initarg :text)))

(defmethod draw ((msg debug-message))
  (format t "~A~%" (text msg)))

;; we need to push/pop the translation matrices before
;; drawing a GL object
(defclass gl-object (graphical-object) nil)

(defmethod draw :around ((object gl-object))
  (gl:push-matrix)
  (call-next-method)
  (gl:pop-matrix))

;; for now, we will use 2d since everything is on a plane with z=0
(defclass vertex (gl-object)
  ((x :accessor x :initform 0.0f0 :type float :initarg :x)
   (y :accessor y :initform 0.0f0 :type float :initarg :y)
   (color :accessor color :initform cl-colors:+white+
          :type cl-colors:rgb :initarg :color)))

(defmethod draw ((vertex vertex))
  (with-slots (color x y) vertex
    (gl-set-color color)
    (gl:vertex-3d (double x) (double y) 0.0d0)))

;; start at first point, draw line to second point, ...
(defclass open-path (gl-object)
  ((points :reader points :initform nil :type list :initarg :points)
   (thickness :reader thickness :initform 0.01f0 :type float :initarg :thickness)))

(defmethod draw ((path open-path))
  (define-gl-object gl:+line-strip+
      (loop for vertex in (points path) do (draw vertex))))

;; open path but we draw a line from the last point back to the first
(defclass closed-path (open-path) nil)

(defmethod draw ((path closed-path))
  (define-gl-object gl:+line-loop+
      (loop for vertex in (points path) do (draw vertex))))

;; some transforms
(defclass transform (gl-object)
  ((inner-object :initarg :inner-object :reader inner-object :initform NIL)))

(defmethod draw :after ((obj transform))
  (draw (inner-object obj)))

(defclass scale (transform)
  ((scale :initarg :scale :reader scale-factor :initform 1)))

(defmethod draw ((obj scale))
  (let ((f (double (scale-factor obj))))
    (gl:scale-d f f f)))

(defclass rotate (transform)
  ((angle :initarg :angle :reader rotate-factor :initform 0)))

(defmethod draw ((obj rotate))
  (gl:rotate-d (double (rotate-factor obj)) 0.0d0 0.0d0 1.0d0))

(defclass translate (transform)
  ((x :initarg :x :reader x-translation :initform 0 :type double-float)
   (y :initarg :y :reader y-translation :initform 0 :type double-float)))

(defmethod draw ((obj translate))
  (gl:translate-d
   (double (x-translation obj))
   (double (y-translation obj))
   0d0))
