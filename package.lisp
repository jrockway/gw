(require 'asdf)
(require 'sdl)
(require 'opengl)

(defpackage #:gw
  (:use #:common-lisp #:gettimeofday)
  (:export #:start))
