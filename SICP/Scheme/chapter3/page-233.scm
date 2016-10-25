(define (average x y)
  (/ (+ x y) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
    (define guess (cons-stream 1.0 (stream-map (lambda (guess) (sqrt-improve guess x)) guess)))
    guess
)

(define (display-x x)
    (newline)
    (display x)
)

(define (display-stream stream)
    (display-x (stream-car stream))
    (display-stream (stream-cdr stream))
)


(define (pi-summands n)
  (cons-stream (/ 1.0 n) (stream-map - (pi-summands (+ n 2)))))

(define pi-stream (scale-stream (partical-sums (pi-summands 1)) 4))


(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define (partical-sums stream)
    (cons-stream (stream-car stream) (add-streams (partical-sums stream) (stream-cdr stream)))
)

(define (add-streams s1 s2)
  (stream-map + s1 s2))