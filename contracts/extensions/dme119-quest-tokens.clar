(impl-trait .extension-trait.extension-trait)

;; Traits
(use-trait ft-trait .ft-trait.ft-trait)

;; Constants
(define-constant err-unauthorized (err u3100))
(define-constant err-not-owner (err u3101))
(define-constant err-quest-not-complete (err u3102))


;; Quest Definition
(define-non-fungible-token quest uint)
(define-data-var next-quest-id uint u0)
(define-map quest-metadata uint
    {
        expiration: uint,
        activation: uint,
    }
)

;; Quest Token Definition
(define-non-fungible-token quest-token uint)
(define-data-var next-quest-token-id uint u0)
(define-map quest-token-metadata uint
    {
        quest-id: uint,
        completed: bool,
		ft-reward: {contract: principal, amount: uint}
    }
)


;; Authorization and Check Functions
(define-public (is-dao-or-extension)
    (ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; Quest Functions
(define-public (create-quest)
    (let (
        (quest-id (var-get next-quest-id))
    )
        (try! (nft-mint? quest quest-id tx-sender))
        (var-set next-quest-id (+ quest-id u1))
        (ok quest-id)
    )
)

;; Quest Token Functions
(define-public (create-quest-token (quest-id uint) (contract <ft-trait>) (amount uint))
    (let (
        (quest-token-id (var-get next-quest-token-id))
    )
        (try! (nft-mint? quest-token quest-token-id tx-sender))
        (map-set quest-token-metadata quest-token-id {
            quest-id: quest-id,
            completed: false,
            ft-reward: { contract: (contract-of contract), amount: amount }
        })
        (var-set next-quest-token-id (+ quest-token-id u1))
        (ok quest-token-id)
    )
)

(define-private (traits-to-principals (traits (list 1 <ft-trait>)))
    (map trait-to-principal traits)
)

(define-private (trait-to-principal (trait <ft-trait>))
    (contract-of trait)
)

;; Reward Functions
(define-public (claim-rewards (quest-token-id uint))
    (begin
        (asserts! (unwrap! (get completed (map-get? quest-token-metadata quest-token-id)) err-unauthorized) err-quest-not-complete)
        (nft-burn? quest-token quest-token-id tx-sender)
    )
)

(define-read-only (get-quest-token (quest-token-id uint))
    (map-get? quest-token-metadata quest-token-id)
)

;; Extension Callback
(define-public (callback (sender principal) (memo (buff 34)))
    (ok true)
)
