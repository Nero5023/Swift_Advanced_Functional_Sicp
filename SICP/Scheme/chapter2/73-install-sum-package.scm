
(define (install-sum-package)
    (define (addend s)
      (car s))

    (define (augend s)
      (cadr s))

    (define (make-sum a1 a2)
        (cond ((=number? a1 0) a2)
              ((=number? a2 0) a1)
              ((and (number? a1) (number? a2))
                (+ a1 a2))
              (else 
                    (list '+ a1 a2))
        )
    )

    (put 'addend '+ addend)
    (put 'augend '+ augend)
    (put 'make-sum '+ make-sum)

    (put 'deriv '+ 
            (lambda (exp var) 
                (make-sum (deriv (addend exp) var))
                          (deriv (augend exp) var)))
'done)


(define (make-sum x y)
    ((get 'make-sum '+) x y))

(define (addend sum)
    ((get 'addend '+) (contents sum)))

(define (augend sum)
    ((get 'augend '+) (contents sum)))