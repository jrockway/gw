;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(defpackage #:gw-asd
  (:use :cl :asdf))

(in-package #:gw-asd)

(defsystem gw
  :name "gw"
  :depends-on (opengl sdl cffi)
  :components ((:file "gettimeofday")
               (:file "package" :depends-on ("gettimeofday"))
               (:file "support" :depends-on ("package"))
               (:file "enemies" :depends-on ("package" "support"))
               (:file "spawn-patterns" :depends-on ("support"))
               (:file "game" :depends-on ("enemies" "spawn-patterns"))
               (:file "main" :depends-on ("game" ))))

