;; Title: DME020 Woooooo! Token
;; Author: rozar.btc
;;
;; Synopsis:
;; The Woooooo! Token contract implements a fungible token on the Stacks blockchain, featuring strategic fee mechanisms for minting, 
;; burning, and transferring tokens. Designed to empower decentralized finance (DeFi) applications, it employs a game-theoretic fee 
;; distribution model that benefits early participants by increasing the intrinsic value of the tokens required for minting.
;;
;; Core Features:
;;
;; Game-Theory Fee Model: 
;; Token minting, burning, and transfers have a nominal fee applied which is deposted into the base token's liquidity pools. 
;; Early minters benefit significantly as fees contribute to a pool that enhances the value of the tokens used in the minting process. 
;; This increase in token value incentivizes early participation and rewards initial stakeholders; creating a compelling economic incentive for early adoption and engagement.
;;
;; Community Fly-Wheel: 
;; Collected fees are specifically directed to the liquidity pools of Liquid Staked Welsh and Liquid Staked Roo. 
;; These allocations boost the value of these pools, which in turn enhances the value of Woooooo! tokens by reinforcing the ecosystem's overall liquidity and financial stability.
;;
;; Memecoin Consolidation: 
;; The Woooooo! Token smart contract consolidates liquidity between memecoins, creating a flywheel effect to unite fractured liquidity. 
;; This consolidation helps enhance market efficiency and provides a more stable trading environment for all participants.
;;
;; Decentralized Administration: 
;; The protocol's parameters, including the token's name, symbol, URI, and decimals, are managed via DAO or authorized extensions. 
;; This ensures that changes to the token's properties are overseen by the community or designated authorities; aligning with decentralized governance practices.

(impl-trait .sip010-ft-trait.sip010-ft-trait)
(impl-trait .extension-trait.extension-trait)

(define-constant err-unauthorized (err u3000))
(define-constant err-not-token-owner (err u4))

(define-constant supply-weight-w u10000) ;; WELSH 10B total supply
(define-constant supply-weight-r u42) ;; ROO 42M total supply
(define-constant ONE_6 (pow u10 u6)) ;; 6 decimal places

(define-constant contract (as-contract tx-sender))

(define-fungible-token woooooo)

(define-data-var token-name (string-ascii 32) "Woooooo!")
(define-data-var token-symbol (string-ascii 10) "WOO")
(define-data-var token-uri (optional (string-utf8 256)) (some u"https://charisma.rocks/woooooo.json"))
(define-data-var token-decimals uint u4)

(define-data-var mint-fee-percent uint u1000) ;; 0.1%
(define-data-var burn-fee-percent uint u1000) ;; 0.1%
(define-data-var transfer-fee-percent uint u1000) ;; 0.1%
(define-data-var fee-target-a principal .liquid-staked-welsh)
(define-data-var fee-target-b principal .liquid-staked-roo)

;; --- Authorization check

(define-public (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; --- Internal DAO functions

(define-public (set-name (new-name (string-ascii 32)))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set token-name new-name))
	)
)

(define-public (set-symbol (new-symbol (string-ascii 10)))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set token-symbol new-symbol))
	)
)

(define-public (set-decimals (new-decimals uint))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set token-decimals new-decimals))
	)
)

(define-public (set-token-uri (new-uri (optional (string-utf8 256))))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set token-uri new-uri))
	)
)

(define-public (set-mint-fee-percent (new-mint-fee-percent uint))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set mint-fee-percent new-mint-fee-percent))
	)
)

(define-public (set-burn-fee-percent (new-burn-fee-percent uint))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set burn-fee-percent new-burn-fee-percent))
	)
)

(define-public (set-transfer-fee-percent (new-transfer-fee-percent uint))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set transfer-fee-percent new-transfer-fee-percent))
	)
)

(define-public (set-fee-target-a (new-fee-target-a principal))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set fee-target-a new-fee-target-a))
	)
)

(define-public (set-fee-target-b (new-fee-target-b principal))
	(begin
		(try! (is-dao-or-extension))
		(ok (var-set fee-target-b new-fee-target-b))
	)
)

;; --- Public functions

(define-public (mint (amount uint) (recipient principal))
    (let
        (
            (amount-lsw (* amount supply-weight-w))
            (amount-lsr (* amount supply-weight-r))
            (mint-fee (/ (* amount (var-get mint-fee-percent)) ONE_6))
            (mint-fee-lsw (* mint-fee supply-weight-w))
            (mint-fee-lsr (* mint-fee supply-weight-r))
            (amount-after-fee (- amount mint-fee))
        )
        ;; if mint-fee is greater than 0 then send fees to the fee-targets
        (and (> mint-fee u0) 
            (begin
                (print {mint-fee: mint-fee})
                (try! (contract-call? .liquid-staked-welsh transfer mint-fee-lsw tx-sender (var-get fee-target-a) none))
                (try! (contract-call? .liquid-staked-roo transfer mint-fee-lsr tx-sender (var-get fee-target-b) none))
            )
        )
        (join amount-after-fee recipient)
    )
    
)

(define-public (burn (amount uint) (recipient principal))
    (let
        (
            (amount-lsw (* amount supply-weight-w))
            (amount-lsr (* amount supply-weight-r))
            (burn-fee (/ (* amount (var-get burn-fee-percent)) ONE_6))
            (amount-after-fee (- amount burn-fee))
        )
        ;; if burn-fee is greater than 0 then burn LP and send fees to the fee-targets
        (and (> burn-fee u0) 
            (begin
                (print {burn-fee: burn-fee})   
                (try! (split burn-fee (var-get fee-target-a) (var-get fee-target-b)))
            )
        )
        (split amount-after-fee recipient recipient)
    )
)

(define-read-only (get-mint-fee-percent)
	(ok (var-get mint-fee-percent))
)

(define-read-only (get-burn-fee-percent)
	(ok (var-get burn-fee-percent))
)

(define-read-only (get-transfer-fee-percent)
	(ok (var-get transfer-fee-percent))
)

(define-read-only (get-fee-target-a)
	(ok (var-get fee-target-a))
)

(define-read-only (get-fee-target-b)
	(ok (var-get fee-target-b))
)

;; sip010-ft-trait

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(let
        (
            (transfer-fee (/ (* amount (var-get transfer-fee-percent)) ONE_6))
            (amount-after-fee (- amount transfer-fee))
        )
		(asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) err-not-token-owner)
        ;; if transfer-fee is greater than 0 then transfer LP and send fees to the fee-targets
        (and (> transfer-fee u0)
            (begin
                (print {tx-fee: transfer-fee})   
                (try! (split transfer-fee (var-get fee-target-a) (var-get fee-target-b)))
            )
        )
		(ft-transfer? woooooo amount-after-fee sender recipient)
	)
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
	(ok (ft-get-balance woooooo who))
)

(define-read-only (get-total-supply)
	(ok (ft-get-supply woooooo))
)

(define-read-only (get-token-uri)
	(ok (var-get token-uri))
)

;; --- Utility functions

(define-private (join (amount uint) (recipient principal))
    (let
        (
            (amount-lsw (* amount supply-weight-w))
            (amount-lsr (* amount supply-weight-r))
            (sender tx-sender)
        )
        (try! (contract-call? .liquid-staked-welsh transfer amount-lsw sender contract none))
        (try! (contract-call? .liquid-staked-roo transfer amount-lsr sender contract none))
        (try! (ft-mint? woooooo amount recipient))
        (ok true)
    )
)

(define-private (split (amount uint) (recipient-a principal) (recipient-b principal))
    (let
        (
            (amount-lsw (* amount supply-weight-w))
            (amount-lsr (* amount supply-weight-r))
            (sender tx-sender)
        )
        (try! (ft-burn? woooooo amount sender))
        (try! (contract-call? .liquid-staked-welsh transfer amount-lsw contract recipient-a none))
        (try! (contract-call? .liquid-staked-roo transfer amount-lsr contract recipient-b none))
        (ok true)
    )
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)
