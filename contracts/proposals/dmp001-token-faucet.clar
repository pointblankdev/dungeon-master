;; Title: DMP001 Token Faucet
;; Author: Ross Ragsdale
;; Synopsis:
;; 
;; Description:
;; 

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
	(begin
		(try! (contract-call? .dungeon-master set-extension .dme005-token-faucet true))
		(try! (contract-call? .dme000-governance-token set-decimals u0))
        (print "We're setting the stage for a new era of economic revolution, and you're part of it.")
        (ok true)
	)
)
