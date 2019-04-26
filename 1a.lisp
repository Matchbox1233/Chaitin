(defun fact(x)
(setq sum 1)
(loop while (> x 1)
    do (
        setq sum (* sum x)
        x (- x 1)
        )
    )
    sum
)

(setq f (read))

(format t "~D! ~D" f (fact f))