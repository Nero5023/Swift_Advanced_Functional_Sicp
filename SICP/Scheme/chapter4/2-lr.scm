(define (eval exp env)
    (cond
        ((self-evaluating? exp)
            exp)
        (...)
        ((procedure-call? exp)                              ; <--
            (apply (eval (operator exp) env)                ;
                   (list-of-values (operands exp) env)))    ;
        (assignment? ...)
        ...))