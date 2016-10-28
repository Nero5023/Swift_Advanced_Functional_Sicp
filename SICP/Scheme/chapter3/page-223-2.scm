(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))
(define (cons-stream a b)
    (cons a (delay b))
)

(define (memo-proc proc)
    (let ((alreay-run? #f) (result #f))
        (lambda () 
            (if (not alreay-run?)
                (begin (set! result (proc))
                       (set! alreay-run? #t)
                        result)
                result)
        )
    )
)

(define (delay <exp>)
    (memo-proc (lambda () <exp>))  
)

(define (force delayed-object)
  (delayed-object))


(define (stream-enumerate-interval low high)
    (if (> low high)
        the-empty-stream
        (cons-stream low (stream-enumerate-interval (+ low 1) high)))
)

(define (stream-filter pred stream)
    (cond ((pred (stream-car stream)) 
            (cons-stream (stream-car stream) (stream-filter pred (stream-cdr stream))))
          (else (stream-filter pred (stream-cdr stream))))
)

(stream-cdr (stream-cdr (stream-filter prime? (stream-enumerate-interval 100000 10000000))))

(define (displaystream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
(display x))