(define (front-ptr queue)
    (car queue))

(define (rear-ptr queue)
  (cdr queue))

(define (set-front-ptr! queue item)
  (set-car! queue item))

(define (set-reat-ptr! queue item)
  (set-cdr! queue item))

(define (empty-queue? queue)
  (null? (front-ptr queue)))

(define (make-queue)
  (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "Front called with an empty queue" queue)
      (car (front-ptr queue))))

(define (intert-queue! queue item)
    (let ((new-pair (cons item '())))
          (cond ((empty-queue? queue) 
                    (set-front-ptr! queue new-pair)
                    (set-reat-ptr! queue new-pair)
                    queue)
                (else 
                    (set-cdr! (rear-ptr queue) new-pair)
                    (set-reat-ptr! queue new-pair)
                    queue)
          )
    )  
)

(define (delete-queue! queue)
    (cond ((empty-queue? queue) 
            (error "DELETE! called with an empaty queue" queue))
          (else 
             (set-front-ptr! queue (cdr (front-ptr queue)))
          queue)
    )
)

(define (print-queue queue)
  (front-ptr queue))

(define (make-queue)
    (let ((front-ptr '())
          (rear-ptr '()))
        
        (define (empty-queue?)
          (null? front-ptr))

        (define (intert-queue! item)
            (let ((new-pair (cons item '())))
                  (cond ((empty-queue?) 
                            (set! front-ptr new-pair)
                            (set! rear-ptr new-pair)
                            queue)
                        (else 
                            (set-cdr! rear-ptr new-pair)
                            (set! rear-ptr new-pair)
                            front-ptr)
                  )
            )
        )

        (define (delete-queue!)
            (cond ((empty-queue?) 
                    (error "DELETE! called with an empaty queue" queue))
                  (else
                    (set! front-ptr (cdr front-ptr))
                    front-ptr)
            )
        )

        (define (dispatch m)
            (cond ((eq? m 'intert-queue!) 
                        intert-queue!)
                  ((eq? m 'delete-queue!) 
                        delete-queue!)
                  (eq? m 'empty-queue?
                        empty-queue?)
                  (else
                        (error "Unknow operation -- DISPATCH" m))
            )
        )
        dispatch
    )
)