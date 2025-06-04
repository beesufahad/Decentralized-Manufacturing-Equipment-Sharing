;; Reservation Contract
;; Manages scheduling and availability

(define-data-var contract-owner principal tx-sender)

;; Reservation structure
(define-map reservations
  { reservation-id: uint }
  {
    asset-id: uint,
    renter: principal,
    start-time: uint,
    end-time: uint,
    status: (string-ascii 20) ;; "pending", "confirmed", "completed", "cancelled"
  })

;; Reservation counter
(define-data-var reservation-counter uint u0)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-RESERVATION-NOT-FOUND u101)
(define-constant ERR-NOT-RENTER u102)
(define-constant ERR-INVALID-TIMEFRAME u103)
(define-constant ERR-ALREADY-RESERVED u104)

;; Create a reservation
(define-public (create-reservation
                (asset-id uint)
                (start-time uint)
                (end-time uint))
  (let ((reservation-id (var-get reservation-counter)))
    (asserts! (> end-time start-time) (err ERR-INVALID-TIMEFRAME))
    ;; In a real implementation, we would check for conflicts here
    (map-set reservations
      { reservation-id: reservation-id }
      {
        asset-id: asset-id,
        renter: tx-sender,
        start-time: start-time,
        end-time: end-time,
        status: "pending"
      })
    (var-set reservation-counter (+ reservation-id u1))
    (ok reservation-id)))

;; Confirm a reservation (would be called by asset owner)
(define-public (confirm-reservation (reservation-id uint))
  (let ((reservation (map-get? reservations { reservation-id: reservation-id })))
    (asserts! (is-some reservation) (err ERR-RESERVATION-NOT-FOUND))
    ;; In a real implementation, we would verify the caller is the asset owner
    (map-set reservations
      { reservation-id: reservation-id }
      (merge (unwrap-panic reservation) { status: "confirmed" }))
    (ok true)))

;; Complete a reservation
(define-public (complete-reservation (reservation-id uint))
  (let ((reservation (map-get? reservations { reservation-id: reservation-id })))
    (asserts! (is-some reservation) (err ERR-RESERVATION-NOT-FOUND))
    ;; In a real implementation, we would verify the caller is authorized
    (map-set reservations
      { reservation-id: reservation-id }
      (merge (unwrap-panic reservation) { status: "completed" }))
    (ok true)))

;; Cancel a reservation
(define-public (cancel-reservation (reservation-id uint))
  (let ((reservation (map-get? reservations { reservation-id: reservation-id })))
    (asserts! (is-some reservation) (err ERR-RESERVATION-NOT-FOUND))
    (asserts! (is-eq (get renter (unwrap-panic reservation)) tx-sender) (err ERR-NOT-RENTER))
    (map-set reservations
      { reservation-id: reservation-id }
      (merge (unwrap-panic reservation) { status: "cancelled" }))
    (ok true)))

;; Get reservation details
(define-read-only (get-reservation (reservation-id uint))
  (map-get? reservations { reservation-id: reservation-id }))

;; Get reservation count
(define-read-only (get-reservation-count)
  (var-get reservation-counter))
