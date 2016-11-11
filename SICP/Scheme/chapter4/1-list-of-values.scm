(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((left (eval (first-operand exps) env)))
          (cons left (list-of-values (rest-operands exps) env))))
)

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((right (list-of-values (first-operand exps) env)))
          (cons left (list-of-values (rest-operands exps) env))))
)

