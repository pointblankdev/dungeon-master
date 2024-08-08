(define-fungible-token lp-token)
(define-non-fungible-token vault uint)

(define-map vto-tvl { vault-id: uint, token-id: uint, owner: principal } uint)
(define-map vt-tvl { vault-id: uint, token-id: uint } uint)
(define-map v-tvl uint uint)

(define-map asset-contract-ids principal uint)
(define-map asset-contract-prices principal uint)
(define-map asset-contract-whitelist principal bool)

(define-data-var asset-contract-id-nonce uint u0)

(define-constant err-unauthorized (err u100))
(define-constant err-not-whitelisted (err u101))
(define-constant err-invalid-price (err u102))
(define-constant err-max-single-asset (err u103))
(define-constant err-insufficient-balance (err u1))
(define-constant err-invalid-sender (err u4))

(define-trait sip010-transferable-trait
	(
		(transfer (uint principal principal (optional (buff 34))) (response bool uint))
	)
)

;; authorization
;; 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ

(define-read-only (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; manage tvl for a single vault-token-user 

(define-private (set-vto-tvl (vault-id uint) (token-id uint) (owner principal) (value uint))
  (map-set vto-tvl { vault-id: vault-id, token-id: token-id, owner: owner } value)
)

(define-private (get-vto-tvl-uint (vault-id uint) (token-id uint) (owner principal))
  (default-to u0 (map-get? vto-tvl { vault-id: vault-id, token-id: token-id, owner: owner }))
)

(define-read-only (get-vto-tvl (vault-id uint) (token-id uint) (owner principal))
  (ok (get-vto-tvl-uint vault-id token-id owner))
)

;; manage tvl for a single vault-token 

(define-private (set-vt-tvl (vault-id uint) (token-id uint) (value uint))
  (map-set vt-tvl { vault-id: vault-id, token-id: token-id } value)
)

(define-private (get-vt-tvl-uint (vault-id uint) (token-id uint))
  (default-to u0 (map-get? vt-tvl { vault-id: vault-id, token-id: token-id }))
)

(define-read-only (get-vt-tvl (vault-id uint) (token-id uint))
  (ok (get-vt-tvl-uint vault-id token-id))
)

;; manage tvl for a single vault 

(define-private (set-v-tvl (vault-id uint) (value uint))
  (map-set v-tvl { vault-id: vault-id } value)
)

(define-private (get-v-tvl-uint (vault-id uint))
  (default-to u0 (map-get? v-tvl vault-id))
)

(define-read-only (get-v-tvl (vault-id uint))
	(ok (get-v-tvl-uint vault-id))
)

;; add/remove liquidity

(define-private (add-liquidity (vault-id uint) (token-id uint) (owner principal) (value uint) )
  (let
		(
			(current-vto-tvl (get-vto-tvl-uint vault-id token-id owner))
			(current-vt-tvl (get-vt-tvl-uint vault-id token-id))
			(current-v-tvl (get-v-tvl-uint vault-id))
			(new-vto-tvl (+ current-vto-tvl value))
			(new-vt-tvl (+ current-vt-tvl value))
			(new-v-tvl (+ current-v-tvl value))
		)
		(try! (set-vto-tvl vault-id token-id owner new-vto-tvl))
		(try! (set-vt-tvl vault-id token-id new-vt-tvl))
		(try! (set-v-tvl vault-id new-v-tvl))
		(ok {
			vault-id: vault-id,
			token-id: token-id,
			owner: owner
			vto-tvl: new-vto-tvl,
			vt-tvl: new-vt-tvl,
			v-tvl: new-v-tvl
		})
	)
)

(define-private (remove-liquidity (vault-id uint) (token-id uint) (owner principal) (value uint) )
  (let
		(
			(current-vto-tvl (get-vto-tvl-uint vault-id token-id owner))
			(current-vt-tvl (get-vt-tvl-uint vault-id token-id))
			(current-v-tvl (get-v-tvl-uint vault-id))
			(new-vto-tvl (- current-vto-tvl value))
			(new-vt-tvl (- current-vt-tvl value))
			(new-v-tvl (- current-v-tvl value))
		)
		(try! (set-vto-tvl vault-id token-id owner new-vto-tvl))
		(try! (set-vt-tvl vault-id token-id new-vt-tvl))
		(try! (set-v-tvl vault-id new-v-tvl))
		(ok {
			vault-id: vault-id,
			token-id: token-id,
			owner: owner
			vto-tvl: new-vto-tvl,
			vt-tvl: new-vt-tvl,
			v-tvl: new-v-tvl
		})
	)
)

;; total lp tokens for all vaults

(define-read-only (get-overall-supply)
	(ok (ft-get-supply lp-token))
)

;; wallet integration and metadata

(define-read-only (get-decimals)
	(ok u0)
)

(define-read-only (get-token-uri (vault-id uint))
	(ok none)
)

(define-read-only (get-owner (vault-id uint))
    (ok (nft-get-owner? vault vault-id))
)

(define-public (transfer (vault-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) err-invalid-sender)
        (nft-transfer? vault vault-id sender recipient)
    )
)

;; Wrapping and unwrapping logic

(define-read-only (get-asset-token-id (asset-contract principal))
	(map-get? asset-contract-ids asset-contract)
)

(define-public (get-or-create-asset-token-id (asset-contract principal))
	(match (get-asset-token-id asset-contract)
		token-id (ok token-id)
		(let
			(
				(token-id (+ (var-get asset-contract-id-nonce) u1))
			)
			(asserts! (is-whitelisted asset-contract) err-not-whitelisted)
			(map-set asset-contract-ids asset-contract token-id)
			(var-set asset-contract-id-nonce token-id)
			(ok token-id)
		)
	)
)

(define-read-only (is-whitelisted (asset-contract principal))
	(default-to false (map-get? asset-contract-whitelist asset-contract))
)

(define-public (set-whitelisted (asset-contract principal) (whitelisted bool) (initial-price uint))
	(begin
    (try! (is-dao-or-extension))
		(asserts! (> initial-price u0) err-invalid-price)
		(map-set asset-contract-prices asset-contract initial-price)
		(ok (map-set asset-contract-whitelist asset-contract whitelisted))
	)
)

(define-public (wrap (vault-id uint) (sip010-asset <sip010-transferable-trait>) (amount uint))
    (let
        (
            (token-id (try! (get-or-create-asset-token-id (contract-of sip010-asset))))
            (current-pool-supply (get-v-tvl-uint token-id vault-id))
            (total-lp-token (unwrap-panic (get-total-supply lp-token-id vault-id)))
            (asset-price (unwrap! (map-get? asset-contract-prices (contract-of sip010-asset)) err-invalid-price))
            (value-added (* amount asset-price))
            (current-pool-value (* current-supply asset-price))
            (lp-token-to-mint (if (is-eq total-lp-token u0)
                value-added
                (/ (* value-added total-lp-token) current-pool-value)))
        )
        (asserts! (> asset-price u0) err-invalid-price)
        (try! (contract-call? sip010-asset transfer amount tx-sender (as-contract tx-sender) none))
        (try! (ft-mint? lp-token lp-token-to-mint tx-sender))
        
        ;; Update user's balance in this specific vault
        (set-balance vault-id token-id 
                     (+ (get-balance-uint vault-id token-id tx-sender) amount) 
                     tx-sender)
        
        ;; If sharing is enabled, update shared liquidity contributions
        (if (default-to false (map-get? vault-liquidity-sharing vault-id))
            (map-set shared-liquidity-contributions {vault-id: vault-id, token-id: token-id} 
                     (+ amount (default-to u0 (map-get? shared-liquidity-contributions {vault-id: vault-id, token-id: token-id}))))
            true
        )
        
        (ok lp-token-to-mint)
    )
)

(define-public (unwrap (lp-token-amount uint) (sip010-asset <sip010-transferable-trait>))
    (let
        (
            (token-id (try! (get-or-create-asset-token-id (contract-of sip010-asset))))
            (current-supply (unwrap-panic (get-total-supply token-id)))
            (total-lp-token (ft-get-supply lp-token))
            (asset-price (unwrap! (map-get? asset-contract-prices (contract-of sip010-asset)) err-invalid-price))
            (current-pool-value (* current-supply asset-price))
            (value-to-withdraw (/ (* lp-token-amount current-pool-value) total-lp-token))
            (asset-amount (/ value-to-withdraw asset-price))
        )
        (asserts! (> asset-price u0) err-invalid-price)
        (asserts! (<= lp-token-amount (ft-get-balance lp-token tx-sender)) err-insufficient-balance)
        (try! (ft-burn? lp-token lp-token-amount tx-sender))
        (try! (as-contract (contract-call? sip010-asset transfer asset-amount tx-sender tx-sender none)))
        (map-set token-supplies token-id (- current-supply asset-amount))
        (ok asset-amount)
    )
)

;; dex functionality

(define-public (virtual-swap (token-a principal) (token-b principal) (amount-in uint))
    (let
        (
            (token-a-id (try! (get-or-create-asset-token-id token-a)))
            (token-b-id (try! (get-or-create-asset-token-id token-b)))
            (balance-a (unwrap-panic (get-total-supply token-a-id)))
            (balance-b (unwrap-panic (get-total-supply token-b-id)))
            (constant-product (* balance-a balance-b))
            (new-balance-a (+ balance-a amount-in))
            (new-balance-b (/ constant-product new-balance-a))
            (amount-out (- balance-b new-balance-b))
        )
        ;; Asserts and checks
        (asserts! (>= (get-balance-uint token-a-id tx-sender) amount-in) err-insufficient-balance)
        
        ;; Update total supplies
        (map-set token-supplies token-a-id new-balance-a)
        (map-set token-supplies token-b-id new-balance-b)
        
        ;; Update user balances
        (set-balance token-a-id (- (get-balance-uint token-a-id tx-sender) amount-in) tx-sender)
        (set-balance token-b-id (+ (get-balance-uint token-b-id tx-sender) amount-out) tx-sender)
        
        ;; Update prices
        (map-set asset-contract-prices token-a (/ new-balance-b new-balance-a))
        (map-set asset-contract-prices token-b (/ new-balance-a new-balance-b))
        
        ;; Return the amount out
        (ok amount-out)
    )
)