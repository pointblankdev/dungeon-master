;; Title: DME021 Staked Welsh Pool
;; Author: rozar.btc
;; Synopsis:
;; This contract provides foundational data and functionalities for managing the Welsh token ecosystem, 
;; specifically focusing on computing exchange rates and tracking token supplies.
;; Description:
;; This contract serves as a foundational component for managing the Welsh token ecosystem, 
;; offering read-only functionalities to fetch the total supply of Liquid Staked Welsh (LSW), 
;; total Welsh tokens in the pool, and dynamic exchange rates. 
;; These functions support external interactions and serve other contracts that require 
;; these data points to operate, such as staking and unstaking functionalities.

(impl-trait .extension-trait.extension-trait)

(define-constant err-unauthorized (err u3000))

(define-constant ONE_6 (pow u10 u6)) ;; 6 decimal places

;; --- Authorization check

(define-public (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)
;; --- Public functions

(define-public (deposit (amount uint))
	(begin
		(try! (is-dao-or-extension))
		(ok true)
	)
)

(define-public (withdraw (amount uint))
	(begin
		(try! (is-dao-or-extension))
		(ok true)
	)
)

(define-read-only (get-total-supply-of-lsw)
	(ok (total-supply-of-lsw))
)

(define-read-only (get-total-welsh-in-pool)
	(ok (total-welsh-in-pool))
)

(define-read-only (get-exchange-rate)
	(ok (calculate-exchange-rate))
)

(define-read-only (get-inverse-rate)
	(ok (calculate-inverse-rate))
)

;; --- Private functions

(define-private (total-supply-of-lsw)
	(unwrap! (contract-call? .dme020-liquid-staked-welsh get-total-supply) u1)
)

(define-private (total-welsh-in-pool)
	(unwrap! (contract-call? .welshcorgicoin-token get-balance (as-contract tx-sender)) u1)
)

(define-private (calculate-exchange-rate)
	(/ (* (total-welsh-in-pool) ONE_6) (total-supply-of-lsw))
)

(define-private (calculate-inverse-rate)
	(/ (* (total-supply-of-lsw) ONE_6) (total-welsh-in-pool))
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)