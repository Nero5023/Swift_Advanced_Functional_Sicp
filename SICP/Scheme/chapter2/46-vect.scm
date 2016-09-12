(define (make-vect xcor ycor)
  (list xcor ycor))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cadr v))

(define (add-vect vecta vectb)
    (make-vect (+ (xcor-vect vecta)  (xcor-vect vectb))
                (+ (ycor-vect vecta) (ycor-vect vectb))
    )
)