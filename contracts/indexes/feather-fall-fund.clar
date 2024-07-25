;; Title: Feather Fall Fund
;; Author: rozar.btc

(impl-trait .dao-traits-v2.sip010-ft-trait)
(impl-trait .dao-traits-v2.extension-trait)

(define-constant err-unauthorized (err u3000))
(define-constant err-not-token-owner (err u4))

(define-constant contract (as-contract tx-sender))

(define-fungible-token fff)

(define-data-var token-name (string-ascii 32) "Feather Fall Fund")
(define-data-var token-symbol (string-ascii 10) "FFF")
(define-data-var token-uri (optional (string-utf8 256)) (some u"https://charisma.rocks/feather-fall-fund.json"))
(define-data-var token-decimals uint u6)

(define-data-var token-a-ratio uint u1)
(define-data-var token-b-ratio uint u1)

;; --- Authorization check

(define-read-only (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; --- Internal DAO functions

(define-public (set-name (new-name (string-ascii 32)))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set token-name new-name))
	)
)

(define-public (set-symbol (new-symbol (string-ascii 10)))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set token-symbol new-symbol))
	)
)

(define-public (set-decimals (new-decimals uint))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set token-decimals new-decimals))
	)
)

(define-public (set-token-uri (new-uri (optional (string-utf8 256))))
	(begin
		(try! (is-dao-or-extension))
		(var-set token-uri new-uri)
		(ok 
			(print {
				notification: "token-metadata-update",
				payload: {
					token-class: "ft",
					contract-id: contract
				}
			})
		)
	)
)

;; --- Index token functions

(define-public (add-liquidity (amount uint))
    (let
        (
			(amount-a (* amount (var-get token-a-ratio)))
			(amount-b (* amount (var-get token-b-ratio)))
        )
        (try! (contract-call? .token-aeusdc transfer amount tx-sender contract none))
        (try! (contract-call? .liquid-staked-charisma transfer amount tx-sender contract none))
        (try! (ft-mint? fff amount tx-sender))
        (ok true)
    )
)

(define-public (remove-liquidity (amount uint))
    (let
        (
			(sender tx-sender)
			(amount-a (* amount (var-get token-a-ratio)))
			(amount-b (* amount (var-get token-b-ratio)))
        )
        (try! (ft-burn? fff amount tx-sender))
        (try! (as-contract (contract-call? .token-aeusdc transfer amount contract sender none)))
        (try! (as-contract (contract-call? .liquid-staked-charisma transfer amount contract sender none)))
        (ok true)
    )
)

;; --- SIP-010 FT Trait

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(begin
		(asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) err-not-token-owner)
		(ft-transfer? fff amount sender recipient)
	)
)

(define-read-only (get-name)
	(ok (var-get token-name))
)

(define-read-only (get-symbol)
	(ok (var-get token-symbol))
)

(define-read-only (get-decimals)
	(ok (var-get token-decimals))
)

(define-read-only (get-balance (who principal))
	(ok (ft-get-balance fff who))
)

(define-read-only (get-total-supply)
	(ok (ft-get-supply fff))
)

(define-read-only (get-token-uri)
	(ok (var-get token-uri))
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)

;; --- Init

(print {
    notification: "token-metadata-update",
    payload: {
        token-class: "ft",
        contract-id: contract
    }
})