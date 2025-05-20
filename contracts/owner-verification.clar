;; Owner Verification Contract
;; Validates equipment holders

(define-data-var contract-owner principal tx-sender)

;; Map to store verified owners
(define-map verified-owners principal bool)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ALREADY-VERIFIED u101)
(define-constant ERR-NOT-VERIFIED u102)

;; Initialize contract owner
(define-public (initialize-contract)
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err ERR-NOT-AUTHORIZED))
    (ok true)))

;; Add a verified owner
(define-public (add-verified-owner (owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-none (map-get? verified-owners owner)) (err ERR-ALREADY-VERIFIED))
    (map-set verified-owners owner true)
    (ok true)))

;; Remove a verified owner
(define-public (remove-verified-owner (owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-some (map-get? verified-owners owner)) (err ERR-NOT-VERIFIED))
    (map-delete verified-owners owner)
    (ok true)))

;; Check if an owner is verified
(define-read-only (is-verified-owner (owner principal))
  (default-to false (map-get? verified-owners owner)))

;; Transfer contract ownership
(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err ERR-NOT-AUTHORIZED))
    (var-set contract-owner new-owner)
    (ok true)))
