;; Title: DME010 Quest Reward Helper
;; Author: rozar.btc
;; Depends-On: rewards-trait
;; Synopsis:
;; A utility contract to streamline and simplify the quest reward claiming process for users.
;; Description:
;; The Quest Reward Helper is an intuitive bridge that aids users in seamlessly claiming their rewards upon quest completion. 

(impl-trait .extension-trait.extension-trait)

(define-constant err-not-found (err u2001))
(define-constant err-unauthorized (err u3100))
(define-constant err-not-completed (err u3101))
(define-constant err-rewards-locked (err u3102))

;; --- Authorization check

(define-public (is-completed-and-unlocked (quest-id uint))
	(begin
		(asserts! (try! (contract-call? .dme006-quest-completion is-complete tx-sender quest-id)) err-not-completed)
		(asserts! (not (unwrap! (contract-call? .dme009-charisma-rewards is-locked tx-sender quest-id) err-not-found)) err-rewards-locked)
		(ok true)
	)
)

;; --- Public functions

(define-public (claim-quest-reward (quest-id uint))
	(begin
		(try! (is-completed-and-unlocked quest-id))
		(try! (contract-call? .dme009-charisma-rewards claim quest-id))
		(try! (contract-call? .dme009-charisma-rewards set-locked tx-sender quest-id true))
		(contract-call? .dme006-quest-completion set-complete tx-sender quest-id true)
	)
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)