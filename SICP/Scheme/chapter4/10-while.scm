(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))

(define (while? exp)
  (tagged-list? exp 'while))

(define (while-condition exp)
  (cadr exp))

(define (while-body exp)
  (caddr exp))


(define (while->combination exp)
    (sequence->exp (list (list 'define (list 'while-iter')
        (make-if (while-condition exp) (sequence->exp (list (while-body exp)
            (list 'while-iter))) 'true)) (list 'while-iter)))
)

(define (while exp)
  (sequence->exp (list (list 'define (list 'while-iter) 
        (make-if (while-condition exp) (sequence->exp (list (while-body exp) (list 'while-iter))) 'true')) (list 'while-iter))))
