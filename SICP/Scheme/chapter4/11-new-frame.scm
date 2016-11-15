(define (make-frame variables value)
  (if (= (length variables) (length value))
      (map cons variables value)
      (error "length mismatch -- MARK-FRAME" variables value)))

(define (frame-variables frame)
  (map car variables))

(define (frame-values frame)
  (map cdr value))