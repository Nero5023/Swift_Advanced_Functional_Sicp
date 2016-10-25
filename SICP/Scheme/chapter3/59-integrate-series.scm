(define (div-streams s1 s2)
  (stream-map / s1 s2))

(define (integegrate-series stream)
  (mul-streams stream (div-streams one integers)))

(define sine-series (cons-stream 0 (integegrate-series cosine-series)))

(define cosine-series (cons-stream 1 (integegrate-series (scale-stream sine-series -1))))

