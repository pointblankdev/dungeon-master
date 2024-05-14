;; Title: Raven Faucet
;; Author: rozar.btc

(impl-trait .dao-traits-v2.extension-trait)
(impl-trait .dao-traits-v2.proposal-trait)

(use-trait nft-trait .dao-traits-v2.nft-trait)

(define-constant err-unauthorized (err u3100))
(define-constant err-insufficient-balance (err u3102))
(define-constant err-not-raven-holder (err u4010))

(define-constant contract (as-contract tx-sender))

(define-data-var nft-contract principal .odins-raven)
(define-data-var drip-amount uint u0)
(define-data-var last-claim uint block-height)
(define-data-var total-issued uint u0)

;; --- Authorization check

(define-public (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dungeon-master) (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; --- Internal DAO functions

(define-public (set-drip-amount (amount uint))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set drip-amount amount))
	)
)

(define-public (set-nft-contract (new-nft-contract <nft-trait>))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set nft-contract (contract-of new-nft-contract)))
	)
)


;; --- Public functions

(define-public (claim (nft-gate <nft-trait>))
	(let
		(
			(sender tx-sender)
            (tokens-available (* (var-get drip-amount) (- block-height (var-get last-claim))))
			(holds-raven (check-for-raven sender nft-gate))
		)
		(asserts! holds-raven err-not-raven-holder)
        (asserts! (> tokens-available u0) err-insufficient-balance)
        (var-set last-claim block-height)
        (var-set total-issued (+ (var-get total-issued) tokens-available))		
        (as-contract (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dme000-governance-token dmg-mint tokens-available sender))
	)
)

(define-read-only (get-nft-contract)
	(ok (var-get nft-contract))
)

(define-read-only (get-drip-amount)
	(ok (var-get drip-amount))
)

(define-read-only (get-last-claim)
	(ok (var-get last-claim))
)

;; --- Utility functions

(define-private (get-raven-holder (nft-gate <nft-trait>))
	(begin
		(asserts! (is-eq (contract-of nft-gate) (var-get nft-contract)) err-unauthorized)
		(contract-call? nft-gate get-owner u0)
	)
)

(define-private (check-for-raven (user principal) (nft-gate <nft-trait>))
	(is-eq user (unwrap-panic (unwrap-panic (get-raven-holder nft-gate))))
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)

;; --- Proposal function

(define-public (execute (sender principal))
	(begin
		(try! (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dungeon-master set-extension contract true))
		(set-drip-amount u10000000)
        (ok true)
	)
)