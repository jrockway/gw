;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(defpackage #:gw-asd
  (:use :cl :asdf))

(in-package #:gw-asd)

(defsystem gw
  :name "gw"
  :depends-on (opengl sdl cffi cl-colors)
  :components ((:file "gettimeofday")
               (:file "package" :depends-on ("gettimeofday"))
               (:file "gl-extras" :depends-on ("package"))
               (:file "support" :depends-on ("package"))
               (:file "draw" :depends-on ("support" "gl-extras"))
               (:file "enemies" :depends-on ("draw"))
               (:file "spawn-patterns" :depends-on ("support"))
               (:file "game" :depends-on ("enemies" "spawn-patterns"))
               (:file "main" :depends-on ("game"))))
