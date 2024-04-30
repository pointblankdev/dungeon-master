;; Title: DMP020 Woooooo!
;; Author: rozar.btc
;; Synopsis:
;; Enable a new extention called Woooooo! (WOO) that is backed by staked sWELSH and sROO tokens.

(impl-trait .dao-traits-v0.proposal-trait)

(define-public (execute (sender principal))
	(begin
		(try! (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dungeon-master set-extension 'SP1VGCMHKXYGZ4Y0DWZR6449M0EJY3PZV2XX61EMH.dme020-woooooo-token true))
        (print "Woooooo!")
        (ok true)
	)
)
