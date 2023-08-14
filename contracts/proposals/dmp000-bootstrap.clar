;; Title: DMP000 Bootstrap
;; Author: Ross Ragsdale
;; Synopsis:
;; Boot proposal that sets the governance token, DAO parameters, 
;; extensions, and mints the initial governance tokens.
;; Description:
;; Mints the initial supply of governance tokens and enables the the following 
;; extensions: "DME000 Governance Token", "DME001 Proposal Voting",
;; "DME002 Proposal Submission", "DME003 Emergency Proposals",
;; "DME004 Emergency Execute".

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
	(begin
		;; Enable genesis extensions.
		(try! (contract-call? .dungeon-master set-extensions
			(list
				;; {extension: .dme000-governance-token, enabled: true}
				;; {extension: .dme001-proposal-voting, enabled: true}
				;; {extension: .dme002-proposal-submission, enabled: true}
				;; {extension: .dme003-emergency-proposals, enabled: true}
				;; {extension: .dme004-emergency-execute, enabled: true}
				;; dev debug
				{extension: .dme006-quest-completion, enabled: true}
				{extension: .dme007-quest-completion-oracle, enabled: true}
			)
		))

		;; ;; Set emergency team members.
		;; (try! (contract-call? .dme003-emergency-proposals set-emergency-team-member 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ true))
		;; ;; (try! (contract-call? .dme003-emergency-proposals set-emergency-team-member 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 true))

		;; ;; Set executive team members.
		;; (try! (contract-call? .dme004-emergency-execute set-executive-team-member 'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ true))
		;; ;; (try! (contract-call? .dme004-emergency-execute set-executive-team-member 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 true))
		;; ;; (try! (contract-call? .dme004-emergency-execute set-executive-team-member 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG true))
		;; ;; (try! (contract-call? .dme004-emergency-execute set-executive-team-member 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC true))
		;; ;; (try! (contract-call? .dme004-emergency-execute set-signals-required u3)) ;; signal from 3 out of 4 team members requied.

		;; ;; Mint initial token supply.
		;; (try! (contract-call? .dme000-governance-token dmg-mint-many
		;; 	(list
		;; 		{amount: u2000, recipient: sender}
		;; 		{amount: u1000, recipient: 'SP3TW60M88XFKRT9E5QXKA3RW7YZCH2G93NJ8EDAK}
		;; 		{amount: u1000, recipient: 'SP2T424HFWWMSYMWRZV6J3PJ2K36X3HWZ7S0KTXZ3}
		;; 		;; {amount: u1000, recipient: 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC}
		;; 		;; {amount: u1000, recipient: 'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND}
		;; 		;; {amount: u1000, recipient: 'ST2REHHS5J3CERCRBEPMGH7921Q6PYKAADT7JP2VB}
		;; 		;; {amount: u1000, recipient: 'ST3AM1A56AK2C1XAFJ4115ZSV26EB49BVQ10MGCS0}
		;; 		;; {amount: u1000, recipient: 'ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP}
		;; 		;; {amount: u1000, recipient: 'ST3PF13W7Z0RRM42A8VZRVFQ75SV1K26RXEP8YGKJ}
		;; 		;; {amount: u1000, recipient: 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6}
		;; 	)
		;; ))

		(print "You are not entering this world in the usual manner, for you are setting forth to be a Dungeon Master. Certainly there are stout fighters, mighty magic-users, wily thieves, and courageous clerics who will make their mark in the magical lands of bitgear adventure. You however, are above even the greatest of these, for as DM you are to become the Shaper of the Cosmos. It is you who will give form and content to the all the universe. You will breathe life into the stillness, giving meaning and purpose to all the actions which are to follow.")
		(ok true)
	)
)
