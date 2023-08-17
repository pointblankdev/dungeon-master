(use-trait collection-contract  .nft-trait.nft-trait)

(define-trait character-trait
  (
    (roll-character ((string-utf8 16) <collection-contract> uint) (response bool uint))

    (get-character (principal) 
      (response 
        (tuple 
          (name (string-utf8 16))
          (collection principal)
          (avatar uint) 
        )
        uint
      )
    )
  )
)