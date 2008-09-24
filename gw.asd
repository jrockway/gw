;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(defpackage #:gw-asd
  (:use :cl :asdf))

(in-package #:gw-asd)

(defsystem gw
  :name "gw"
  :depends-on (opengl sdl cffi sdl-ttf)
  :components ((:file "gettimeofday")
               (:file "package" :depends-on ("gettimeofday"))
<<<<<<< Updated upstream:gw.asd
               (:file "support" :depends-on ("package"))
               (:file "enemies" :depends-on ("package" "support"))
               (:file "spawn-patterns" :depends-on ("support"))
               (:file "game" :depends-on ("enemies" "spawn-patterns"))
               (:file "main" :depends-on ("game" ))))

=======
               (:file "drawing-utils" :depends-on ("package"))
               (:file "game" :depends-on ("package" "drawing-utils"))
               (:file "main" :depends-on ("package" "game"))))
>>>>>>> Stashed changes:gw.asd
