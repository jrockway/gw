(in-package #:gw)

(defmacro define-gl-object (gl-shape &rest body)
  `(progn
     (gl:begin ,gl-shape)
     ,@body
     (gl:end)))

;(declaim (inline double define-gl-vertex))
(defun double (number) (coerce number 'double-float))

;; gl:color-*f but with a cl-color instead of 3 or 4 numbers
;; need to move this into the GL namespace.
(defgeneric gl-set-color1 (color))
(defgeneric gl-set-color (color))

(defmethod gl-set-color1 ((color cl-colors:rgb))
  (list (cl-colors:red color)
        (cl-colors:green color)
        (cl-colors:blue color)))

(defmethod gl-set-color1 ((color cl-colors:rgba))
  (append (call-next-method) (list (cl-colors:alpha color))))

(defmethod gl-set-color ((color cl-colors:rgb))
  (apply #'gl:color-3d (gl-set-color1 color)))

(defmethod gl-set-color ((color cl-colors:rgba))
  (apply #'gl:color-4d (gl-set-color1 color)))

