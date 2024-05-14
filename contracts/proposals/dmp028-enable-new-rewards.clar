;; Title: DMP028 - Enable New Rewards
;; Author: rozar.btc
;; Synopsis:
;; 

(impl-trait .dao-traits-v2.proposal-trait)

(define-public (execute (sender principal))
	(begin
		;; Enable champions faucet - a reward for holding the champion's title belt
		(try! (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dungeon-master set-extension .champions-faucet true))
		(try! (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.champions-faucet set-drip-amount u1000000))
		;; Enable the green room - a reward for supporting me and the project early on
		(try! (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.dungeon-master set-extension .the-green-room true))
		(try! (contract-call? 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ.the-green-room set-drip-amount u5000000))
        (ok true)
	)
)
