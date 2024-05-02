;; Title: Odin's Raven
;; Author: rozar.btc
;;
;; Synopsis:

(impl-trait .dao-traits-v1.extension-trait)
(impl-trait .dao-traits-v1.nft-trait)

(define-constant err-unauthorized (err u3000))
(define-constant err-not-token-owner (err u4))
(define-constant err-balance-not-found (err u404))

(define-constant ONE_6 (pow u10 u6)) ;; 6 decimal places

(define-non-fungible-token raven uint)

(define-data-var token-uri (optional (string-ascii 256)) (some "https://charisma.rocks/raven-nft.json"))
(define-data-var reward-payout-multiplier uint u0)

;; list of 100 NFTs
(define-data-var ids (list
    u0  u1  u2  u3  u4  u5  u6  u7  u8  u9
    u10 u11 u12 u13 u14 u15 u16 u17 u18 u19
    u20 u21 u22 u23 u24 u25 u26 u27 u28 u29
    u30 u31 u32 u33 u34 u35 u36 u37 u38 u39
    u40 u41 u42 u43 u44 u45 u46 u47 u48 u49
    u50 u51 u52 u53 u54 u55 u56 u57 u58 u59
    u60 u61 u62 u63 u64 u65 u66 u67 u68 u69
    u70 u71 u72 u73 u74 u75 u76 u77 u78 u79
    u80 u81 u82 u83 u84 u85 u86 u87 u88 u89
    u90 u91 u92 u93 u94 u95 u96 u97 u98 u99
))

;; --- Authorization check

(define-read-only (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; --- Rewards

(define-public (set-reward-payout-multiplier (new-reward-payout-multiplier uint))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set reward-payout-multiplier new-reward-payout-multiplier))
	)
)

(define-read-only (get-reward-payout-multiplier)
	(ok (var-get reward-payout-multiplier))
)

;; --- NFT Traits

(define-public (set-token-uri (new-uri (optional (string-ascii 256))))
	(begin
		(try! (is-dao-or-extension))
		(var-set token-uri new-uri)
		(ok 
			(print {
				notification: "token-metadata-update",
				payload: {
					token-class: "nft",
					contract-id: (as-contract tx-sender),
                    token-ids: (var-get ids)
				}
			})
		)
	)
)

(define-read-only (get-last-token-id)
    (ok u0)
)

(define-read-only (get-token-uri (id uint))
    (ok (var-get token-uri))
)

(define-read-only (get-owner (id uint))
    (ok (nft-get-owner? raven id))
)

(define-public (transfer (id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) err-not-token-owner)
        (nft-transfer? raven id sender recipient)
    )
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)

(nft-mint? raven)