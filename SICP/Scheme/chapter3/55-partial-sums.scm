(define (partical-sums stream)
  (cons-stream (stream-car stream) (add-streams (partical-sums stream) (stream-cdr stream))))