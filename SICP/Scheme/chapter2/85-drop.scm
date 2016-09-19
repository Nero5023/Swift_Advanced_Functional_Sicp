(put 'project 'complex 
    (lambda (x) (make-real (real-part x)))
)

(define (drop x)
    (let ((project-proc (get 'project (type-tag x))))
        (if project-proc
            (let ((porjected (project-proc (contents x))))
                (if (eq? x (raise porjected))
                    porjected
                    x))
            x))
)