;; Title: Crafting Helper
;; Author: rozar.btc

;; (impl-trait 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.extension-trait.extension-trait)
(impl-trait .extension-trait.extension-trait)

(use-trait liquid-ft-trait .dao-traits-v2.liquid-ft-trait)
(use-trait recipe-trait .dao-traits-v2.recipe-trait)

(define-constant err-bad-pool (err u4024))

;; --- Public functions

(define-public (craft (recipe <recipe-trait>) (amount uint) (lft-a <liquid-ft-trait>) (lft-b <liquid-ft-trait>))
    (let (
        (lsp-a (unwrap-panic (contract-call? .dme024-liquid-staking-pools get-liquid-staking-pool "WELSH")))
        (lsp-b (unwrap-panic (contract-call? .dme024-liquid-staking-pools get-liquid-staking-pool "ODIN")))
    )
        ;; assert that lft-a and lsp-a are the same
        (asserts! (is-eq (contract-of lft-a) lsp-a) err-bad-pool)
        (asserts! (is-eq (contract-of lft-b) lsp-b) err-bad-pool)
        (try! (contract-call? recipe craft amount tx-sender lft-a lft-b))
        (ok true)
    )
)

(define-public (salvage (recipe <recipe-trait>) (amount uint) (lft-a <liquid-ft-trait>) (lft-b <liquid-ft-trait>))
    (let (
        (lsp-a (unwrap-panic (contract-call? .dme024-liquid-staking-pools get-liquid-staking-pool "WELSH")))
        (lsp-b (unwrap-panic (contract-call? .dme024-liquid-staking-pools get-liquid-staking-pool "ODIN")))
    )
        ;; assert that lft-a and lsp-a are the same
        (asserts! (is-eq (contract-of lft-a) lsp-a) err-bad-pool)
        (asserts! (is-eq (contract-of lft-b) lsp-b) err-bad-pool)
        (try! (contract-call? recipe salvage amount tx-sender lft-a lft-b))
        (ok true)
    )
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)