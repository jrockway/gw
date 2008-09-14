;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(defpackage #:gw-asd
  (:use :cl :asdf))

(in-package #:gw-asd)

(defsystem gw
  :name "gw"
  :depends-on (opengl sdl cffi)
  :components ((:file "gettimeofday")
               (:file "package" :depends-on ("gettimeofday"))
               (:file "game" :depends-on ("package"))
               (:file "main" :depends-on ("package" "game"))))
