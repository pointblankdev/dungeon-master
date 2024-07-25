(define-constant err-postconditions (err u20021))
(define-constant factor u100000000)
(define-constant contract (as-contract tx-sender))

(define-public
  (execute-strategy-a
   (amt-in uint))
    (let (
        (a (stx-get-balance contract))
        (x (/ (try! (contract-call? 'SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.amm-pool-v2-01 swap-helper 'SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.token-wstx-v2 'SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.token-wcorgi factor (* amt-in u100) u0)) u100))
        (y (try! (contract-call? 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-path2 do-swap x 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.wstx 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-share-fee-to)))
        (b (stx-get-balance contract))
        )
      (asserts!
        (> b a)
        err-postconditions)
      (ok
        {a: a,
        x: x,
        y: y,
        b: b})
    )
)

(define-public
  (execute-strategy-b
   (amt-in uint))
    (let (
        (a (stx-get-balance contract))
        (x (try! (contract-call? 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-path2 do-swap amt-in 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.wstx 'SP3NE50GEXFG9SZGTT51P40X2CKYSZ5CC4ZTZ7A2G.welshcorgicoin-token 'SP1Y5YSTAHZ88XYK1VPDH24GY0HPX5J4JECTMY4A1.univ2-share-fee-to)))
        (y (/ (try! (contract-call? 'SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.amm-pool-v2-01 swap-helper 'SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.token-wcorgi 'SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.token-wstx-v2 factor (* (get amt-out x) u100) u0)) u100))
        (b (stx-get-balance contract))
        )
      (asserts!
        (> b a)
        err-postconditions)
      (ok
        {a: a,
        x: x,
        y: y,
        b: b})
    )
)