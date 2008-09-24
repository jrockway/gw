(in-package #:gw)

(defclass graphical-object nil nil)
(defgeneric draw (object))
(defmethod draw ((object null))) ; ignore NIL

(defclass debug-message (graphical-object)
  ((text :reader text :initarg :text)))

(defmethod draw ((msg debug-message))
  (format t "~A~%" (text msg)))

;; for now, we will use 2d since everything is on a plane with z=0
(defclass vertex (graphical-object)
  ((x :accessor x :initform 0.0f0 :type float :initarg :x)
   (y :accessor y :initform 0.0f0 :type float :initarg :y)
   (color :accessor color :initform cl-colors:+white+
          :type cl-colors:rgb :initarg :color)))

;; start at first point, draw line to second point, ...
(defclass open-path (graphical-object)
  ((points :reader points :initform nil :type list :initarg :points)
   (thickness :reader thickness :initform 0.01f0 :type float :initarg :thickness)))

;; open path but we draw a line from the last point back to the first
(defclass closed-path (open-path) nil)

(defmacro define-gl-object (gl-shape &rest body)
  `(progn
     (gl:load-identity)
     (gl:translate-f 0.0f0 0.0f0 0.0f0)
     (gl:begin ,gl-shape)
     ,@body
     (gl:end)))

;(declaim (inline double define-gl-vertex))
(defun double (number) (coerce number 'double-float))

(defun define-gl-vertex (vertex)
  (with-slots (color x y) vertex
    ;; set the color
    (let ((class (class-name (class-of color))))
      (cond ((eq class 'cl-colors:rgba)
             (gl:color-4d (double (cl-colors:red color))
                          (double (cl-colors:green color))
                          (double (cl-colors:blue color))
                          (double (cl-colors:alpha color))))
            (t
             (gl:color-3d (double (cl-colors:red color))
                          (double (cl-colors:green color))
                          (double (cl-colors:blue color))))))
    ;; set the vertex
    (gl:vertex-3d (double x) (double y) 0.0d0)))

(defun offset-vertex (vertex offset)
  "Adds the OFFSET (x . y) to VERTEX and returns a new vertex"
  (make-instance (class-of vertex)
                 :color (color vertex)
                 :x (+ (x vertex) (car offset))
                 :y (+ (y vertex) (cdr offset))))

(defun draw-gl-line (thickness start end)
  ;; XXX: we need to make all 4 sides of the quad perpendicular
  ;; i have the math for this in my notebook, but don't want to code it yet
  (define-gl-object
      gl:+quads+
    (define-gl-vertex start)
    (define-gl-vertex (offset-vertex start (cons 0.01 0.01)))
    (define-gl-vertex end)
    (define-gl-vertex (offset-vertex end (cons 0.01 0.01)))))

(defmethod draw ((path open-path))
  (let (pairs)
    (reduce
     (lambda (a b) (setf pairs (append pairs (list (cons a b)))) b)
     (points path))
    (loop
       for (start . end) in pairs
       do (draw-gl-line (thickness path) start end))))
