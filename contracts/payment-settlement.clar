;; Payment Settlement Contract
;; Handles automated compensation

(define-data-var contract-owner principal tx-sender)

;; Payment record structure
(define-map payment-records
  { payment-id: uint }
  {
    reservation-id: uint,
    usage-record-id: uint,
    asset-id: uint,
    renter: principal,
    owner: principal,
    amount: uint,
    status: (string-ascii 20) ;; "pending", "completed", "refunded"
  })

;; Payment counter
(define-data-var payment-counter uint u0)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-PAYMENT-NOT-FOUND u101)
(define-constant ERR-INSUFFICIENT-FUNDS u102)
(define-constant ERR-TRANSFER-FAILED u103)

;; Create a payment record
(define-public (create-payment
                (reservation-id uint)
                (usage-record-id uint)
                (asset-id uint)
                (owner principal)
                (amount uint))
  (let ((payment-id (var-get payment-counter)))
    (map-set payment-records
      { payment-id: payment-id }
      {
        reservation-id: reservation-id,
        usage-record-id: usage-record-id,
        asset-id: asset-id,
        renter: tx-sender,
        owner: owner,
        amount: amount,
        status: "pending"
      })
    (var-set payment-counter (+ payment-id u1))
    (ok payment-id)))

;; Process payment (simplified - in a real implementation, this would handle STX transfers)
(define-public (process-payment (payment-id uint))
  (let ((payment (map-get? payment-records { payment-id: payment-id })))
    (asserts! (is-some payment) (err ERR-PAYMENT-NOT-FOUND))
    (let ((unwrapped-payment (unwrap-panic payment)))
      ;; In a real implementation, we would transfer STX here
      ;; (stx-transfer? (get amount unwrapped-payment) tx-sender (get owner unwrapped-payment))
      (map-set payment-records
        { payment-id: payment-id }
        (merge unwrapped-payment { status: "completed" }))
      (ok true))))

;; Refund payment (simplified)
(define-public (refund-payment (payment-id uint))
  (let ((payment (map-get? payment-records { payment-id: payment-id })))
    (asserts! (is-some payment) (err ERR-PAYMENT-NOT-FOUND))
    (let ((unwrapped-payment (unwrap-panic payment)))
      (asserts! (is-eq (get owner unwrapped-payment) tx-sender) (err ERR-NOT-AUTHORIZED))
      ;; In a real implementation, we would transfer STX back here
      (map-set payment-records
        { payment-id: payment-id }
        (merge unwrapped-payment { status: "refunded" }))
      (ok true))))

;; Get payment record
(define-read-only (get-payment-record (payment-id uint))
  (map-get? payment-records { payment-id: payment-id }))

;; Get payment count
(define-read-only (get-payment-count)
  (var-get payment-counter))
