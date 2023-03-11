;; Title: DMP102 Whitelist Escrow NFT
;; Author: Ross Ragsdale
;; Synopsis:
;; An example proposal to illustrate how 
;; DungeonMaster can manage external ownable contracts.
;; Description:
;; DungeonMaster is well-equiped to manage external contracts feature have
;; some form of ownership. This proposal updates the whitelist of an
;; example escrow contract that is owned by the DungeonMaster contract.
;; Note that the DungeonMaster contract must be the owner of nft-escrow
;; for this proposal to be executed.

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
	(contract-call? .nft-escrow set-whitelisted .some-nft true)
)
