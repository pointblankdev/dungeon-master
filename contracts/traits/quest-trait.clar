(define-trait quest-trait
	(
		;; an optional URI that represents metadata of this quest
		(get-quest-uri () (response (optional (string-utf8 256)) uint))
	)
)
