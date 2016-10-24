(define one (cons-stream 1 ones))

(define (add-stream s1 s2)
  (stream-map + s1 s2))

(define integers (cons-stream 1 (add-stream one integers)))

