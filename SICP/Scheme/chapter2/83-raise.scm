(define (raise x)
    (apply-generic 'raise x)
)

(put 'raise 'integer 
(lambda (x) (make-rational x 1)))

(put 'raise 'rational 
    (lambda (x) (make-real (/ (numer x) (denom 1)))))


; method 2
 (define (integer->rational integer) 
   (make-rational integer 1)) 
 (define (rational->real rational) 
   (define (integer->floating-point integer) 
     (* integer 1.0)) 
   (make-real (/ (integer->floating-point (numer rational)) 
                 (denom rational)))) 
 (define (real->complex real) 
   (make-complex-from-real-imag real 0)) 

 (put-coersion 'integer 'rational integer->rational) 
 (put-coersion 'rational 'real rational->real) 
 (put-coersion 'real 'complex real->complex) 
  
 (define (raise number) 
   (define tower '(integer rational real complex)) 
   (define (try tower) 
     (if (< (length tower) 2) 
         (error "Couldn't raise type" number) 
         (let ((current-type (car tower)) 
               (next-types (cdr tower)) 
               (next-type (car next-types))) 
           (if (eq? (type-tag number) current-type) 
               ((get-coersion current-type next-type) number) 
               (try next-types))))) 
   (try tower)) 
  