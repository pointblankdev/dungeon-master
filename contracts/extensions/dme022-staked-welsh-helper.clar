;; Title: DME022 Staked Welsh Helper
;; Author: rozar.btc
;; Synopsis:
;; This contract extends the functionalities of the DME021 Staked Welsh Pool by 
;; enabling user interactions such as staking and unstaking Welsh tokens.
;; Description:
;; This contract provides user-level functionalities allowing for staking and unstaking Welsh tokens, 
;; leveraging the foundational exchange rate calculations provided by the DME021 Staked Welsh Pool. 
;; It handles the actual transfer of tokens and their conversion between Welsh tokens and LSW, 
;; facilitating user transactions based on the core data and functionalities managed by the DME021.

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
			(try! (contract-call? .welshcorgicoin-token transfer amount sender .dme021-staked-welsh-pool none))
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
			(try! (as-contract (contract-call? .welshcorgicoin-token transfer amount-welsh .dme021-staked-welsh-pool sender none)))
		)
		(ok true)
	)
)

;; --- Private functions

(define-private (calculate-exchange-rate)
	(unwrap! (contract-call? .dme021-staked-welsh-pool get-exchange-rate) ONE_6)
)

(define-private (calculate-inverse-rate)
	(unwrap! (contract-call? .dme021-staked-welsh-pool get-inverse-rate) ONE_6)
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)