(define (partical-sums stream)
  (cons-stream (stream-car stream) (add-steams (partical-sums stream) (stream-cdr stream))))