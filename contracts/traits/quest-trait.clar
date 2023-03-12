;; Quests have a URI that links to somewhere quest storyline is provided.
;; Quests can also be completed.

(define-trait quest-trait
	(
		;; an optional URI that represents metadata of this quest
		(get-quest-uri () (response (optional (string-utf8 256)) uint))

		;; check if the character has completed the quest
		(get-completed (principal) (response bool uint))
	)
)
