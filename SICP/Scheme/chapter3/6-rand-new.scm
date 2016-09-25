(define rand
    (let ((x random-init))
        (lambda () 
            (set! x (rand-update x))
            x
        )
    )
)

(define rand
    (let ((state random-init))
        (lambda (mode) 
            (cond ((eq? mode 'generate) 
                        (set! state (rand-update state))
                        state
                    )
                  ((eq? mode 'reset) 
                        (lambda (new-value) 
                            (set! state new-value))
                  )
            )
        )
    )
)