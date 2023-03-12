(define-trait gear-slots-trait
  (
    (get-gear-main-hand () (response (list 1357 uint) uint))
    (get-gear-off-hand () (response (list 1300 uint) uint))
    (get-gear-two-hand () (response (list 1115 uint) uint))
    (get-gear-head () (response (list 251 uint) uint))
    (get-gear-neck () (response (list 258 uint) uint))
    (get-gear-wrists () (response (list 241 uint) uint))
    (get-gear-finger () (response (list 269 uint) uint))
  )
)
