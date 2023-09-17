;; Title: DME015 Quest Reward Helper
;; Author: rozar.btc
;; Depends-On: rewards-trait
;; Synopsis:
;; A utility contract to streamline and simplify the quest reward claiming process for users.
;; Description:
;; The Quest Reward Helper is an intuitive bridge that aids users in seamlessly claiming their rewards upon quest completion. 

(impl-trait .extension-trait.extension-trait)

(define-constant err-not-completed (err u3101))
(define-constant err-rewards-locked (err u3102))
(define-constant err-expired (err u3103))
(define-constant err-unactivated (err u3104))

;; --- Authorization check

(define-public (is-completed-and-unlocked (quest-id uint))
	(begin
		(asserts! (try! (contract-call? .dme006-quest-completion is-complete tx-sender quest-id)) err-not-completed)
		(asserts! (not (unwrap! (contract-call? .dme009-charisma-rewards is-locked tx-sender quest-id) err-not-found)) err-rewards-locked)
		(ok true)
	)
)

(define-public (is-activated-and-unexpired (quest-id uint))
	(begin
		(asserts! (>= (contract-call? .dme011-quest-expiration get-expiration quest-id) block-height) err-expired)
		(asserts! (<= (contract-call? .dme012-quest-activation get-activation quest-id) block-height) err-unactivated)
		(ok true)
	)
)

;; --- Public functions

(define-public (claim-quest-reward (quest-id uint))
    (begin
        ;; Check if the quest is completed, unlocked, activated, and hasn't expired
        (try! (is-completed-and-unlocked quest-id))
        (try! (is-activated-and-unexpired quest-id))

        ;; Extract and lock the quest rewards
        (let
            (
                (charisma-rewards (try! (contract-call? .dme009-charisma-rewards get-rewards quest-id)))
                (stx-rewards (try! (contract-call? .dme014-stx-rewards get-rewards quest-id)))
            )
            ;; Claim charisma rewards if they exist
            (if (> charisma-rewards u0)
                (try! (contract-call? .dme009-charisma-rewards claim quest-id))
                (ok true)
            )
            
            ;; Claim STX rewards if they exist
            (if (> stx-rewards u0)
                (try! (contract-call? .dme014-stx-rewards claim quest-id))
                (ok true)
            )
            
            ;; Lock the quest rewards
			(contract-call? .dme009-charisma-rewards set-locked tx-sender quest-id true)
        )
    )
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)