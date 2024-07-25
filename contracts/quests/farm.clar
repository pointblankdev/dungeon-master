(define-constant err-unauthorized (err u401))

(define-constant farmers u1)
(define-data-var creature-type-bonus u2)
(define-data-var scaling-factor uint u1)

(define-data-var quest-uri (string-utf8 256) u"https://charisma.rocks/api/metadata/SP2ZNGJ85ENDY6QRHQ5P2D4FXKGZWCKTB2T0Z55KS.farm.json")

;; Authorization check
(define-private (is-dao-or-extension)
    (or (is-eq tx-sender 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dungeon-master) (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dungeon-master is-extension contract-caller))
)

(define-read-only (is-authorized)
    (ok (asserts! (is-dao-or-extension) err-unauthorized))
)

(define-public (harvest (creature-id uint))
    (let
        (
            (tapped-out (unwrap-panic (contract-call? .creatures-kit tap creature-id)))
            (ENERGY (get ENERGY tapped-out))
            (token-amount (* ENERGY (get-scaling-factor)))
            (TOKENS (if (is-eq creature-id farmers) (* token-amount (get-creature-type-bonus)) token-amount))
            (original-sender tx-sender)
        )
        (as-contract (contract-call? .fuji-apples transfer TOKENS tx-sender original-sender none))
    )
)

(define-read-only (get-claimable-amount (creature-id uint))
    (let
        (
            (untapped-energy (unwrap-panic (contract-call? .creatures-kit get-untapped-amount creature-id tx-sender)))
            (token-amount (* untapped-energy (get-scaling-factor)))
        )
        (if (is-eq creature-id farmers) (* token-amount (get-creature-type-bonus)) token-amount)
    )
)

;; Getters
(define-read-only (get-scaling-factor)
    (var-get scaling-factor)
)

(define-read-only (get-quest-uri)
  	(var-get quest-uri)
)

(define-read-only (get-creature-type-bonus)
    (var-get creature-type-bonus)
)

;; Setters
(define-public (set-factor (new-factor uint))
    (begin
        (try! (is-authorized))
        (ok (var-set factor new-factor))
    )
)

(define-public (set-creature-type-bonus (new-bonus uint))
    (begin
        (try! (is-authorized))
        (ok (var-set creature-type-bonus new-bonus))
    )
)

(define-public (set-quest-uri (new-uri (optional (string-utf8 256))))
	(begin
		(try! (is-authorized))
		(ok (var-set quest-uri new-uri))
	)
)

;; Initialization

(begin
    (map-set scaling-factor u1)
    (ok true)
)