(define (fold-left op init sequence)
    (define (iter result rest)
      (if (null? rest)
          result
          (iter (op result (car rest)) (cdr rest))))
    (iter init sequence)
)

(define (fold-right op init sequence)
  (accumulate op init sequence))

