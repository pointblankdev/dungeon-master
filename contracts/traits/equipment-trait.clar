(use-trait collection-contract  .nft-trait.nft-trait)
(use-trait gear-contract        .nft-trait.nft-trait)

(define-trait equipment-trait
  (
    (initialize-equipment () (response bool uint))

    (equip-gear-main-hand (<character-trait> <gear-contract> uint <gear-slots-trait>) (response bool uint))
    (equip-gear-off-hand (<character-trait> <gear-contract> uint <gear-slots-trait>) (response bool uint))
    (equip-gear-two-hand (<character-trait> <gear-contract> uint <gear-slots-trait>) (response bool uint))
    (equip-gear-head (<character-trait> <gear-contract> uint <gear-slots-trait>) (response bool uint))
    (equip-gear-neck (<character-trait> <gear-contract> uint <gear-slots-trait>) (response bool uint))
    (equip-gear-wrists (<character-trait> <gear-contract> uint <gear-slots-trait>) (response bool uint))
    (equip-gear-right-ring-finger (<character-trait> <gear-contract> uint <gear-slots-trait>) (response bool uint))
    (equip-gear-left-ring-finger (<character-trait> <gear-contract> uint <gear-slots-trait>) (response bool uint))

    (get-equipment (principal) 
      (response 
        (tuple 
          (main-hand (optional uint)) 
          (off-hand (optional uint)) 
          (two-hand (optional uint)) 
          (head (optional uint)) 
          (neck (optional uint)) 
          (wrists (optional uint)) 
          (right-ring-finger (optional uint)) 
          (left-ring-finger (optional uint))
        )
        uint
      )
    )
  )
)