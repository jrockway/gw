(in-package #:gw)

(defun init-sdl-with-gl ()
  (sdl:init sdl:+init-video+)
  (sdl:set-gl-attributes :red-size 4 :blue-size 4 :green-size 4
			 :doublebuffer 1 :depth-size 16)
  (let*
      ((w 640)(h 480)
       (surface (sdl:set-video-mode
                 w h 16
                 (logior sdl:+opengl+ sdl:+resizable+))))
    (sdl:wm-set-caption "GW" nil)
    (gl:matrix-mode gl:+projection+)
    (gl:load-identity)
    ;(gl:ortho
    ; (coerce w 'double-float)
    ; (coerce h 'double-float)
    ; 0d0 0d0  -10d0 10d0) ; a great type system we have here.
    surface))

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

     (:quit () (return))
     (:idle ()
            (progn (tick state)
                   (gl:clear-color 0.0f0 0.0f0 0.0f0 1.0f0)
                   (gl:clear gl:+color-buffer-bit+)
                   (loop for object in (objects state) do
                        (current-representation state object))
                   (sdl:gl-swap-buffers))))))

(defun start nil
  (init-sdl-with-gl)
  (run-sdl-event-loop))
