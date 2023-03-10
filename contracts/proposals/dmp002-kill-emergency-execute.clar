;; Title: DMP002 Kill Emergency Execute
;; Author: Ross Ragsdale
;; Synopsis:
;; This proposal disables extension "DME004 Emergency Execute".
;; Description:
;; If this proposal passes, extension "DME004 Emergency Execute" is immediately
;; disabled.

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
	(contract-call? .dungeon-master set-extension .dme004-emergency-execute false)
)
