(define-trait ft-trait
	(
		;; Transfer from the caller to a new principal
		(transfer (uint principal principal (optional (buff 34))) (response bool uint))
	)
)
