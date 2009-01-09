(in-package #:gw)

(defparameter *window-width* 959)
(defparameter *window-height* 1180)

(defun init-sdl-with-gl ()
  (sdl:init (logior sdl:+init-video+ sdl:+init-joystick+))
  (sdl:set-gl-attributes :red-size 4 :blue-size 4 :green-size 4
			 :doublebuffer 1 :depth-size 16)

  (sdl:set-video-mode *window-width* *window-height* 16
                      (logior sdl:+opengl+ sdl:+resizable+))
  (gl:matrix-mode gl:+modelview+)
  (gl:load-identity)
  (gl:blend-func gl:+one+ gl:+one+)
  (gl:enable gl:+blend+)
  (gl:enable gl:+texture-2d+)
  (gl:viewport 0 0 *window-width* *window-height*)

  (sdl:joystick-open 0)
  (format t "got joystick ~A ~%"
          (sdl:joystick-name 0))

  (sdl:wm-set-caption "GW" nil))

(defun run-sdl-event-loop ()
  (let ((state (make-instance 'game-state)))
    (add-object state (make-instance 'colorful-triangle))
    (add-object state (make-instance 'fps-monitor))
    (sdl:event-loop
     (:resize (width height)
       (progn
         (setf *window-height* height)
         (setf *window-width*  width)))

     (:key-down (key)
       (when (= key (char-code #\q))
         (return)))

     (:joy-axis-motion (joystick axis value)
       (with-slots (left-joystick right-joystick) state
         (with-slots (x y) left-joystick
           (cond ((= axis 0) (setf x value))
                 ((= axis 1) (setf y (- 0 value)))))
         (with-slots (x y) right-joystick
           (cond ((= axis 2) (setf x value))
                 ((= axis 3) (setf y (- 0 value)))))))

     (:quit () (return))

     (:idle ()
       (progn
         (tick state)
         (gl:viewport 0 0 *window-width* *window-height*)
         (gl:clear-color 0.0f0 0.0f0 0.0f0 1.0f0)
         (gl:clear gl:+color-buffer-bit+)
         (gl:load-identity)
         (let* ((ratio (/ *window-height* *window-width*))
                (width (double 40))
                (height (* width ratio)))
           (gl:ortho (- 0 width) width (- 0 height) height -1.0d0 1.0d0))
         (loop for object in (objects state)
            do (draw (current-representation state object)))
         (sdl:gl-swap-buffers))))))

(defun start nil
  (init-sdl-with-gl)
  (run-sdl-event-loop))
