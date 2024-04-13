;; Title: DME018 Quest Title
;; Author: rozar.btc
;; Depends-On: DME000

(impl-trait .extension-trait.extension-trait)

(define-constant err-not-found (err u2001))
(define-constant err-unauthorized (err u3100))

(define-map quest-title-map uint (optional (string-utf8 256)))

;; --- Authorization check

(define-public (is-dao-or-extension)
	(ok (asserts! (or (is-eq tx-sender .dungeon-master) (contract-call? .dungeon-master is-extension contract-caller)) err-unauthorized))
)

;; --- Internal DAO functions

(define-public (set-title (quest-id uint) (title (optional (string-utf8 256))))
	(begin
		(try! (is-dao-or-extension))
		(ok (map-set quest-title-map quest-id title))
	)
)

;; --- Public functions 

(define-read-only (get-title (quest-id uint))
	(ok (default-to (some u"") (map-get? quest-title-map quest-id)))
)

;; --- Extension callback

(define-public (callback (sender principal) (memo (buff 34)))
	(ok true)
)