;; Title: DME005 Bitgear Genesis
;; Author: Ross Ragsdale
;; Depends-On: .bitgear-genesis
;; Synopsis:
;; WIP
;; Description:
;; WIP

(impl-trait .extension-trait.extension-trait)

(use-trait extension-trait .extension-trait.extension-trait)

(define-constant err-unauthorized (err u3000))

;; --- Authorization check

(define-public (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; --- Internal DAO functions

(define-public (transfer (extension <extension-trait>) (buff (buff 34)))
	(let (
		(memo (default-to 0x (as-max-len? buff u34)))
		;; (memo (to-consensus-buff? amount))
	)

		(try! (is-dao-or-extension))
		(try! (as-contract (contract-call? .dungeon-master request-extension-callback extension memo)))
		(ok true)
	)
)

;; --- Public functions

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
 (begin
		(try! (contract-call? .bitgear-genesis reward u5 sender))
		;; (try! (contract-call? .bitgear-genesis reward (buff-to-uint-be memo) sender))
		(ok true)
 )
)
