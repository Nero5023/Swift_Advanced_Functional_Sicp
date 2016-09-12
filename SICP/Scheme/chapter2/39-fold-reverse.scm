(define (fold-left op init sequence)
    (define (iter result rest)
      (if (null? rest)
          result
          (iter (op result (car rest)) (cdr rest))))
    (iter init sequence)
)


(define (accumulate op initial sequencce)
    (if (null? sequencce)
        initial
        (op (car sequencce) (accumulate op initial (cdr sequencce)))))
(define (fold-right op init sequence)
  (accumulate op init sequence))


(define (reverse sequencee)
    (fold-right (lambda (item result) 
            (append result (list item))
        ) 
    '() sequencee)
)

(define (reverse2 sequencee)
    (fold-left (lambda (result item) 
            (append (list item) result)
        ) 
    '() sequencee)
)

