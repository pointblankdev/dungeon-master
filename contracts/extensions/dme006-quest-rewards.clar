;; Title: DME006 Quest Rewards
;; Author: Ross Ragsdale
;; Depends-On: DME001, DME-fungible-objects
;; Synopsis:
;; Quests are completed by transferring a NFT to a NPC.
;; Rewards are transferred from the NPC to the PC.
;; Description:
;; Quest rewards will function like a swap contract.


(define-public (claim (quest-id uint))
	(let
		(
			(sender tx-sender)
            (vault (map-get? quest-vault-map { address: tx-sender, quest-id: quest-id }))
			(balance (default-to u0 (get balance vault)))
		)
        (asserts! (> balance u0) err-zero-balance)
        (as-contract (contract-call? .dme000-governance-token dmg-mint balance sender))
	)
)

(define-public (deposit (address principal) (quest-id uint) (amount uint))
    (let
        (
            (vault (unwrap! (map-get? quest-vault-map { address: address, quest-id: quest-id } ) err-invalid-vault))
        )
        (ok
			(map-set 
				quest-vault-map
				{ address: address, quest-id: quest-id } 
				(merge vault {balance: (+ (get balance vault) amount)})
			)
        )
    )    
)