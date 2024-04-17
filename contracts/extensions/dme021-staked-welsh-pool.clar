;; Title: DME021 Staked Welsh Pool
;; Author: rozar.btc
;; Synopsis:
;; This contract implements a staked Welsh pool where users can stake and unstake their Welsh tokens. 
;; The pool maintains an exchange rate between Liquid Staked Welsh (LSW) and Welsh tokens, allowing users to convert between the two.
;; Description:
;; The exchange rates between LSW and Welsh tokens are dynamic and change based on the total supply of Welsh tokens in the pool. 
;; If Welsh tokens are added to the pool by means other than staking, the exchange rates will change. 
;; This makes it harder to acquire LSW and more valuable, as it can be redeemed for more Welsh tokens when unstaked.

(impl-trait .extension-trait.extension-trait)

(define-constant ONE_6 (pow u10 u6)) ;; 6 decimal places

;; --- Public functions

(define-public (stake (amount uint))
	(begin
		(let
			(
				(inverse-rate (calculate-inverse-rate))
				(amount-lsw (/ (* amount inverse-rate) ONE_6))
				(sender tx-sender)
			)
			(try! (contract-call? .welshcorgicoin-token transfer amount sender (as-contract tx-sender) none))
			(try! (contract-call? .dme020-liquid-staked-welsh mint amount-lsw sender))
		)
		(ok true)
	)
)

(define-public (unstake (amount uint))
	(begin
		(let
			(
				(exchange-rate (calculate-exchange-rate))
				(amount-welsh (/ (* amount exchange-rate) ONE_6))
				(sender tx-sender)
			)
			(try! (contract-call? .dme020-liquid-staked-welsh burn amount sender))
			(try! (as-contract (contract-call? .welshcorgicoin-token transfer amount-welsh tx-sender sender none)))
		)
		(ok true)
	)
)

(define-read-only (get-exchange-rate)
	(ok (calculate-exchange-rate))
)

(define-read-only (get-inverse-rate)
	(ok (calculate-inverse-rate))
)

(define-read-only (get-total-supply-in-pool)
	(ok (get-total-welsh-in-pool))
)

;; --- Private functions

(define-private (get-total-supply-of-lsw)
	(unwrap! (contract-call? .dme020-liquid-staked-welsh get-total-supply) u1)
)

(define-private (get-total-welsh-in-pool)
	(unwrap! (contract-call? .welshcorgicoin-token get-balance (as-contract tx-sender)) u1)
)

(define-private (calculate-exchange-rate)
	(/ (* (get-total-welsh-in-pool) ONE_6) (get-total-supply-of-lsw))
)

(define-private (calculate-inverse-rate)
	(/ (* (get-total-supply-of-lsw) ONE_6) (get-total-welsh-in-pool))
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)