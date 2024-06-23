;; Title: Arbitrage v0
;; Author: rozar.btc

;; 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-router

(define-constant err-insufficient-funds (err u4001))

(define-public (strategy-a (amount-stx-in uint) (amount-welsh-in uint))
    (let (
        (sender tx-sender)
    )
        (asserts! (>= (stx-get-balance sender) amount-stx-in) err-insufficient-funds)
        (swap-stx-for-swelsh amount-stx-in u0)
        (try! (contract-call? .liquid-staked-welsh-v2 unstake (unwrap-panic (contract-call? .liquid-staked-welsh-v2 get-balance sender))))
        (swap-welsh-for-stx amount-welsh-in u0)
        (try! (contract-call? .liquid-staked-welsh-v2 stake (unwrap-panic (contract-call? 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token get-balance sender))))
        (ok true)
    )
)

(define-private (swap-stx-for-swelsh (amount-stx uint) (amt-out-min uint))
    (contract-call? .univ2-router swap-exact-tokens-for-tokens u26 .wstx .liquid-staked-welsh-v2 .wstx .liquid-staked-welsh-v2 .univ2-share-fee-to amount-stx amt-out-min)
)

(define-private (swap-swelsh-for-stx (amount-swelsh uint) (amt-out-min uint))
    (contract-call? .univ2-router swap-exact-tokens-for-tokens u26 .wstx .liquid-staked-welsh-v2 .liquid-staked-welsh-v2 .wstx .univ2-share-fee-to amount-swelsh amt-out-min)
)

(define-private (swap-welsh-for-stx (amount-welsh uint) (amt-out-min uint))
    (contract-call? .univ2-router swap-exact-tokens-for-tokens u27 .wstx 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token .wstx .univ2-share-fee-to amount-welsh amt-out-min)
)


;; (define-constant err-insufficient-funds (err u4001))

;; (define-public (strategy-a (amount-stx-in uint) (amount-welsh-in uint))
;;     (let (
;;         (sender tx-sender)
;;     )
;;         (asserts! (>= (stx-get-balance sender) amount-stx-in) err-insufficient-funds)
;;         (swap-stx-for-swelsh amount-stx-in u0)
;;         (try! (contract-call? .liquid-staked-welsh-v2 unstake (unwrap-panic (contract-call? .liquid-staked-welsh-v2 get-balance sender))))
;;         (swap-welsh-for-stx amount-welsh-in u0)
;;         (contract-call? .liquid-staked-welsh-v2 stake (unwrap-panic (contract-call? 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token get-balance sender)))
;;     )
;; )

;; (define-private (swap-stx-for-swelsh (amount-stx uint) (amt-out-min uint))
;;     (contract-call? 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-router swap-exact-tokens-for-tokens u26 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.wstx .liquid-staked-welsh-v2 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.wstx .liquid-staked-welsh-v2 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-share-fee-to amount-stx amt-out-min)
;; )

;; (define-private (swap-welsh-for-stx (amount-welsh uint) (amt-out-min uint))
;;     (contract-call? 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-router swap-exact-tokens-for-tokens u27 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.wstx 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.wstx 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-share-fee-to amount-welsh amt-out-min)
;; )
