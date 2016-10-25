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


(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define (partical-sums stream)
    (cons-stream (stream-car stream) (add-streams (partical-sums stream) (stream-cdr stream)))
)

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (pi-summands n)
  (cons-stream (/ 1.0 n) (stream-map - (pi-summands (+ n 2)))))

(define pi-stream (scale-stream (partical-sums (pi-summands 1)) 4))



(define (euler-transform s)
    (let ((s0 (stream-ref s 0))
          (s1 (stream-ref s 1))
          (s2 (stream-ref s 2)))
          (cons-stream (- s2 (/ (square (- s2 s1)) (+ s0 (* -2 s1) s2)))
                        (euler-transform (stream-cdr s)))
    )  
)


(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

(display-stream (accelerated-sequence euler-transform pi-stream))