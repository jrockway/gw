(in-package :cl-user)
(require :asdf)
(asdf:operate 'asdf:load-op :gw)

(defun resume-from-saved nil
  (gw:start)
  (quit))

(save-lisp-and-die #P"gw.exe" :toplevel #'resume-from-saved :executable t)
