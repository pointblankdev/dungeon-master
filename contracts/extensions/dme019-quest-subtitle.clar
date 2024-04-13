;; Title: DME019 Quest Subtitle
;; Author: rozar.btc
;; Depends-On: DME000

(impl-trait .extension-trait.extension-trait)

(define-constant err-not-found (err u2001))
(define-constant err-unauthorized (err u3100))

(define-map quest-subtitle-map uint (optional (string-utf8 256)))

;; --- Authorization check

(define-public (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; --- Internal DAO functions

(define-public (set-subtitle (quest-id uint) (subtitle (optional (string-utf8 256))))
	(begin
		(try! (is-dao-or-extension))
		(ok (map-set quest-subtitle-map quest-id subtitle))
	)
)

;; --- Public functions 

(define-read-only (get-subtitle (quest-id uint))
	(ok (default-to (some u"") (map-get? quest-subtitle-map quest-id)))
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)