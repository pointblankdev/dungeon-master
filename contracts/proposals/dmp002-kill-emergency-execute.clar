;; Title: EDP002 Kill Emergency Execute
;; Author: Marvin Janssen
;; Synopsis:
;; This proposal disables extension "EDE004 Emergency Execute".
;; Description:
;; If this proposal passes, extension "EDE004 Emergency Execute" is immediately
;; disabled.

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
	(contract-call? .dungeon-master set-extension .dme004-emergency-execute false)
)
