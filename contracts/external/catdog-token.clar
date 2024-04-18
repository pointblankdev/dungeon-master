;; (impl-trait 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.sip010-ft-trait.sip010-ft-trait)
;; (impl-trait 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.ownable-trait.ownable-trait)
(impl-trait .sip010-ft-trait.sip010-ft-trait)
(impl-trait .ownable-trait.ownable-trait)


(define-constant err-unauthorized (err u3000))
(define-constant err-not-token-owner (err u4))

(define-fungible-token catdog)

(define-data-var token-name (string-ascii 32) "CatDog")
(define-data-var token-symbol (string-ascii 10) "CATDOG")
(define-data-var token-uri (optional (string-utf8 256)) (some u"https://charisma.rocks/catdog.json"))
(define-data-var token-decimals uint u6)
(define-data-var contract-owner principal tx-sender)

;; --- Public functions

(define-public (set-name (new-name (string-ascii 32)))
	(begin
		(try! (is-owner))
		(ok (var-set token-name new-name))
	)
)

(define-public (set-symbol (new-symbol (string-ascii 10)))
	(begin
		(try! (is-owner))
		(ok (var-set token-symbol new-symbol))
	)
)

(define-public (set-decimals (new-decimals uint))
	(begin
		(try! (is-owner))
		(ok (var-set token-decimals new-decimals))
	)
)

(define-public (set-token-uri (new-uri (optional (string-utf8 256))))
	(begin
		(try! (is-owner))
		(ok (var-set token-uri new-uri))
	)
)

(define-public (set-contract-owner (new-owner principal))
	(begin
		(try! (is-owner))
		(ok (var-set contract-owner new-owner))
	)
)

(define-public (mint (amount uint))
	(begin
		(let
			((sender tx-sender))
			;; (try! (contract-call? 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token transfer amount sender (as-contract tx-sender) none))
			;; (try! (contract-call? 'SP1AY6K3PQV5MRT6R4S671NWW2FRVPKM0BR162CT6.leo-token transfer amount sender (as-contract tx-sender) none))
			(try! (contract-call? .welshcorgicoin-token transfer amount sender (as-contract tx-sender) none))
			(try! (contract-call? .leo-token transfer amount sender (as-contract tx-sender) none))
			(try! (ft-mint? catdog amount sender))
		)
		(ok true)
	)
)

(define-public (burn (amount uint))
	(begin
		(let
			((sender tx-sender))
			;; (try! (as-contract (contract-call? 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token transfer amount tx-sender sender none)))
			;; (try! (as-contract (contract-call? 'SP1AY6K3PQV5MRT6R4S671NWW2FRVPKM0BR162CT6.leo-token transfer amount tx-sender sender none)))
			(try! (as-contract (contract-call? .welshcorgicoin-token transfer amount tx-sender sender none)))
			(try! (as-contract (contract-call? .leo-token transfer amount tx-sender sender none)))
			(try! (ft-burn? catdog amount sender))
		)
		(ok true)
	)
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(begin
		(asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) err-not-token-owner)
		(ft-transfer? catdog amount sender recipient)
	)
)

(define-public (send-many (recipients (list 200 { to: principal, amount: uint, memo: (optional (buff 34)) })))
  (fold check-err (map send-token recipients) (ok true))
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
	(ok (ft-get-balance catdog who))
)

(define-read-only (get-total-supply)
	(ok (ft-get-supply catdog))
)

(define-read-only (get-token-uri)
	(ok (var-get token-uri))
)

(define-read-only (get-contract-owner)
	(ok (var-get contract-owner))
)

;; --- Private functions

(define-private (is-owner)
	(ok (asserts! (is-eq (var-get contract-owner) tx-sender) err-unauthorized))
)

(define-private (check-err (result (response bool uint)) (prior (response bool uint)))
  (match prior ok-value result err-value (err err-value))
)

(define-private (send-token (recipient { to: principal, amount: uint, memo: (optional (buff 34)) }))
  (send-token-with-memo (get amount recipient) (get to recipient) (get memo recipient))
)

(define-private (send-token-with-memo (amount uint) (to principal) (memo (optional (buff 34))))
  (let ((transferOk (try! (transfer amount tx-sender to memo))))
    (ok transferOk)
  )
)