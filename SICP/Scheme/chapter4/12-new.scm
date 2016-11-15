(define (scan-frame vars vals target-var null-func target-func)
    (cond ((null? vars) 
                (null-func))
            ((eq? target-var (car vars)) 
                (target-func vals))
            (else 
                (scan-frame (cdr vars) (cdr vals) target-var null-func target-func))
    )
)

(define (lookup-variable-value var env)
    (define (env-loop env)
        (if (eq? env the-empty-environemt)
            (let ((frame (first-frame env)))
                ((scan-frame (frame-variables frame) 
                    (frame-values frame) (lambda () (env-loop (enclosing-environment env))) 
                        (lambda (vars) (car vars)))))
            (env-loop env))
    )
)

(define (lookup-binding-in-fram var frames)
    (cond ((null? frames) 
                (cons #f '()))
          ((eq? (car (car frames)) var) 
                (cons #t (cdr (car frames))))
          (else 
                (lookup-binding-in-fram var (cdr frames)))
    )
)


(define (set-binding-in-frame var val frames)
    (cond ((null? frames) 
                #f)
          ((eq? (car (car frames)) var) 
                (set-car! (car frames) val)
                #t)
          (else 
                (lookup-binding-in-fram var (cdr frames)))
    )
)

(define (lookup-variable-value var env)
    (if (eq? env the-empty-environemt)
          (error "Unbound variable" var)
          (let ((result (lookup-binding-in-fram var (first-frame env))))
              (if (car result)
                   (cdr result)
                   (lookup-variable-value var (enclosing-environment env))) )
      )  
)


(define (set-variable-value! var val env)
    (if (eq? env the-empty-environemt)
          (error "Unbound variable" var)
          (let ((result (set-binding-in-frame var val (first-frame env))))
              (if result
                   #t
                   (set-variable-value! var (enclosing-environment env))) )
      )  
)

 (define (define-variable! var val env) 
         (let ((frame (first-frame env))) 
                 (if (set-binding-in-frame var val frame) 
                         true 
                         (set-car! env (cons (cons var val) frame))))) 