;; Title: DME005 Token Faucet
;; Author: Ross Ragsdale
;; Depends-On: 
;; Synopsis:
;; 
;; Description:
;; 

(impl-trait .extension-trait.extension-trait)

(define-constant err-unauthorized (err u3100))
(define-constant err-insufficient-balance (err u3102))

(define-data-var drip-amount uint u1)
(define-data-var last-claim uint block-height)
(define-data-var total-issued uint u0)

;; --- Authorization check

(define-public (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; --- Internal DAO functions

(define-public (set-drip-amount (amount uint))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set drip-amount amount))
	)
)

;; --- Public functions

(define-public (claim)
	(let
		(
			(sender tx-sender)
            (tokens-available (* (var-get drip-amount) (- block-height (var-get last-claim))))
		)
        (asserts! (> tokens-available u0) err-insufficient-balance)
        (var-set last-claim block-height)
        (var-set total-issued (+ (var-get total-issued) tokens-available))		
        (as-contract (contract-call? .dme000-governance-token dmg-mint tokens-available sender))
	)
)

(define-read-only (get-drip-amount)
	(ok (var-get drip-amount))
)

(define-read-only (get-last-claim)
	(ok (var-get last-claim))
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)