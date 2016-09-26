(define (pairs x memo-list)
    (if (and (pair? x)
              (false? (memq x memo-list)))
        (pairs (car x) (pairs (cdr x) (cons x memo-list)))
        memo-list)
)

(define (pairs-count x)
  (length (pairs x '())))