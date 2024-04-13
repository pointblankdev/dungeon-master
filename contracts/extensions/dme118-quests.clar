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

(define-read-only (read-quest (quest-id uint))
    (let (
        (metadata (map-get? quest-metadata quest-id))
    )
        (ok metadata)
    )
)

(define-public (update-quest (quest-id uint) (new-activation (optional uint)) (new-expiration (optional uint)))
    (let (
        (metadata-opt (map-get? quest-metadata quest-id))
    )
        (match metadata-opt
            metadata
                (let (
                    (new-metadata (merge metadata {
                        expiration: (default-to (get expiration metadata) new-expiration),
                        activation: (default-to (get activation metadata) new-activation)
                    }))
                )
                    (map-set quest-metadata quest-id new-metadata)
                    (ok true)
                )
            (err "Quest ID not found")
        )
    )
)



;; Extension Callback
(define-public (callback (sender principal) (memo (buff 34)))
    (ok true)
)
