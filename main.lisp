(in-package #:gw)

(defun init-sdl ()
  (sdl:init (logior sdl:+init-video+ sdl:+init-joystick+))
  (sdl:set-gl-attributes :red-size 4 :blue-size 4 :green-size 4
			 :doublebuffer 1 :depth-size 16)
<<<<<<< Updated upstream:main.lisp
  (let*
      ((w 640)(h 480)
       (surface (sdl:set-video-mode
                 w h 16
                 (logior sdl:+opengl+ sdl:+resizable+))))
=======
  (let* ((w 1024)
         (h 768)
         (surface (sdl:set-video-mode
                   w h 16
                   (logior sdl:+opengl+)))) ;sdl:+resizable+))))
>>>>>>> Stashed changes:main.lisp
    (sdl:wm-set-caption "GW" nil)
    (gl:matrix-mode gl:+projection+)
    (gl:load-identity)
<<<<<<< Updated upstream:main.lisp
    ;(gl:ortho
    ; (coerce w 'double-float)
    ; (coerce h 'double-float)
    ; 0d0 0d0  -10d0 10d0) ; a great type system we have here.
    surface))
=======
    (gl:blend-func gl:+one+ gl:+one+)
    (gl:enable gl:+blend+)
    (gl:enable gl:+texture-2d+)
    (gl:ortho
     (coerce w 'double-float)
     (coerce h 'double-float)
     0d0 0d0 -0.5d0 0.5d0) ; a great type system we have here.
    surface)

  (let ((joystick (sdl:joystick-open 0)))
    (when (> (sdl:joystick-num-axes joystick) 4)
      (error "Your joystick doesn't have enough axes!"))))
>>>>>>> Stashed changes:main.lisp

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
                       (format t "joystick: ~w ~d ~d~%" joystick axis value))
     (:quit () (return))
     (:idle ()
            (progn (tick state)
                   (gl:clear-color 0.0f0 0.0f0 0.0f0 1.0f0)
                   (gl:clear gl:+color-buffer-bit+)
                   (loop for object in (objects state) do
                        (draw state object))
                   (sdl:gl-swap-buffers))))))

(defun start nil
  (init-sdl)
  (run-sdl-event-loop))
