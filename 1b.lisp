(defun factorial(x)
    (if (= x 1)
        (setq a 1)
    )
    (if (> x 1)
        (setq a (* x (factorial (- x 1))))
    )
    
    a
)

(format t "~D! is ~D" 5 (factorial 5))