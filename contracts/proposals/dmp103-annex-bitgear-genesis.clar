;; Title: DMP103 Annex Bitgear Genesis
;; Author: Ross Ragsdale
;; Synopsis:
;; WIP
;; Description:
;; WIP

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
	(begin
		(try! (contract-call? .dungeon-master set-extension .dme005-genesis-stx-transfer true))
		;; (print "WIP")
		(ok true)
	)
)
