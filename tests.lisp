(asdf:operate 'asdf:load-op :gw)
(asdf:operate 'asdf:load-op :fiveam)

(in-package #:gw)

(5am:def-suite basic-suite :description "Foo")
(5am:in-suite basic-suite)

(defun foo nil t)

(5am:test some-tests
  (loop for i from 1 to 1000 do
       (5am:is (= 4 (+ 2 2))))
  (5am:is (foo))
  (5am:finishes (+ 2 2))
  (5am:signals error (error "it worked"))
  (5am:pass)
  (if nil (5am:fail) (5am:pass)))

(5am:run!)
