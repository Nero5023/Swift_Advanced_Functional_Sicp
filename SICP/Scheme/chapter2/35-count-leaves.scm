(define (accumulate op initial sequencce)
    (if (null? sequencce)
        initial
        (op (car sequencce) (accumulate op initial (cdr sequencce)))))

(define (count-leaves tree)
    (accumulate + 0
        (map (lambda (sub-tree) 
                (if (pair? sub-tree)
                    (count-leaves sub-tree)
                    1)
            ) tree) 
    )
)