(impl-trait .dao-traits-v1.sip010-ft-trait)
(define-constant ERR-UNAUTHORIZED (err u401))
(define-fungible-token odin)
(define-data-var token-uri (optional (string-utf8 256)) (some u"https://token-metadat.s3.eu-central-1.amazonaws.com/asset.json"))
(define-constant contract-creator tx-sender)


;; SIP-010 Standard
(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
    (begin
        (asserts! (is-eq from tx-sender) ERR-UNAUTHORIZED)
        (ft-transfer? odin amount from to)
    )
)

(define-read-only (get-name)
    (ok "Odin")
)

(define-read-only (get-symbol)
    (ok "ODIN")
)

(define-read-only (get-decimals)
    (ok u6)
)

(define-read-only (get-balance (user principal))
    (ok (ft-get-balance odin user)
    )
)

(define-read-only (get-total-supply)
    (ok (ft-get-supply odin)
    )
)

(define-public (set-token-uri (value (string-utf8 256)))
    (begin
        (asserts! (is-eq tx-sender contract-creator) ERR-UNAUTHORIZED)
        (var-set token-uri (some value))
        (ok (print {
              notification: "token-metadata-update",
              payload: {
                contract-id: (as-contract tx-sender),
                token-class: "ft"
              }
            })
        )
    )
)

(define-read-only (get-token-uri)
    (ok (var-get token-uri)
    )
)

;; ---------------------------------------------------------
;; Utility Functions
;; ---------------------------------------------------------
(define-public (send-many (recipients (list 200 { to: principal, amount: uint, memo: (optional (buff 34)) })))
  (fold check-err (map send-token recipients) (ok true))
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


(begin
  (try! (ft-mint? odin u21000000000000000 contract-creator))
)