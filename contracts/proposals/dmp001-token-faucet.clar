;; Title: DMP001 Token Faucet
;; Author: Ross Ragsdale
;; Synopsis:
;; This contract serves as a proposal to configure a new extension 
;; and set the decimal places for a governance token as part of a decentralized governance system.
;; Description:
;; The Clarity smart contract is part of a system of contracts designed to enable decentralized governance. 
;; This contract represents a proposal to adjust the setup of a governance token and enable the v0 token faucet.



(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
	(begin
		(try! (contract-call? .dungeon-master set-extension .dme005-token-faucet true))
		(try! (contract-call? .dme000-governance-token set-decimals u0))
        (print "We're setting the stage for a new era of economic revolution, and you're part of it.")
        (ok true)
	)
)
