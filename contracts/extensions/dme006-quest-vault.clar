;; Title: DME005 Quest Vault
;; Author: Ross Ragsdale
;; Depends-On: 
;; Synopsis:
;; Description:


(define-constant err-invalid-vault (err u2001))
(define-constant err-unauthorized (err u3100))
(define-constant err-zero-balance (err u3102))

(define-map quest-vault-map
  {
    address: principal,
    quest-id: uint,
  }
  {
    balance: uint,
  }
)

;; --- Authorization check

(define-public (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

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

(define-read-only (get-balance (address principal) (quest-id uint))
	(let
		(
			(vault (unwrap! (map-get? quest-vault-map { address: address, quest-id: quest-id } ) err-invalid-vault))
		)
		(ok (get balance vault))
	)
)


;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)