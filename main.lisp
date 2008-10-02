(in-package #:gw)

(defun init-sdl-with-gl ()
  (sdl:init (logior sdl:+init-video+ sdl:+init-joystick+))
  (sdl:set-gl-attributes :red-size 4 :blue-size 4 :green-size 4
			 :doublebuffer 1 :depth-size 16)

  (let ((w 959)(h 1180))
    (sdl:set-video-mode w h 16
                        (logior sdl:+opengl+ sdl:+resizable+))
    (gl:matrix-mode gl:+projection+)
    (gl:load-identity)
    (gl:blend-func gl:+one+ gl:+one+)
    (gl:enable gl:+blend+)
    (gl:enable gl:+texture-2d+)
    (gl:viewport 0 0 w h))

  (sdl:joystick-open 0)
  (format t "got joystick ~A ~%"
          (sdl:joystick-name 0))

  (sdl:wm-set-caption "GW" nil))

(defun run-sdl-event-loop ()
  (let ((state (make-instance 'game-state)))
    (add-object state (make-instance 'colorful-triangle))
    (add-object state (make-instance 'fps-monitor))
    (sdl:event-loop
;;;     (:resize (w h) nil)
;;;              (gl:viewport 0 0 w h))

     (:key-down (key)
       (when (= key (char-code #\q))
         (return)))

     (:joy-axis-motion (joystick axis value)
       (with-slots (left-joystick right-joystick) state
         (with-slots ((left-x x) (left-y y)) left-joystick
           (with-slots ((right-x x) (right-y y)) right-joystick
             (cond ((eql axis 0) (setf left-x  value))
                   ((eql axis 1) (setf left-y  (- 0 value)))
                   ((eql axis 2) (setf right-x value))
                   ((eql axis 3) (setf right-y (- 0 value))))))))

     (:quit () (return))

     (:idle ()
       (progn
         (tick state)
         (gl:clear-color 0.0f0 0.0f0 0.0f0 1.0f0)
         (gl:clear gl:+color-buffer-bit+)
         (gl:load-identity)
         (gl:ortho -20.0d0 20.0d0 -20.0d0 20.0d0 -1.0d0 1.0d0)
         (loop for object in (objects state)
            do (draw (current-representation state object)))
         (sdl:gl-swap-buffers))))))

(defun start nil
  (init-sdl-with-gl)
  (run-sdl-event-loop))
