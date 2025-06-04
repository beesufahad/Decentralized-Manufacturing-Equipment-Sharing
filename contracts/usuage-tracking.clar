;; Usage Tracking Contract
;; Monitors equipment utilization

(define-data-var contract-owner principal tx-sender)

;; Usage record structure
(define-map usage-records
  { record-id: uint }
  {
    reservation-id: uint,
    asset-id: uint,
    renter: principal,
    start-timestamp: uint,
    end-timestamp: uint,
    duration: uint,
    status: (string-ascii 20) ;; "active", "completed"
  })

;; Usage record counter
(define-data-var record-counter uint u0)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-RECORD-NOT-FOUND u101)
(define-constant ERR-INVALID-TIMEFRAME u102)

;; Start usage tracking
(define-public (start-usage
                (reservation-id uint)
                (asset-id uint))
  (let ((record-id (var-get record-counter))
        (current-time (unwrap-panic (get-block-info? time u0))))
    (map-set usage-records
      { record-id: record-id }
      {
        reservation-id: reservation-id,
        asset-id: asset-id,
        renter: tx-sender,
        start-timestamp: current-time,
        end-timestamp: u0,
        duration: u0,
        status: "active"
      })
    (var-set record-counter (+ record-id u1))
    (ok record-id)))

;; End usage tracking
(define-public (end-usage (record-id uint))
  (let ((record (map-get? usage-records { record-id: record-id }))
        (current-time (unwrap-panic (get-block-info? time u0))))
    (asserts! (is-some record) (err ERR-RECORD-NOT-FOUND))
    (let ((unwrapped-record (unwrap-panic record))
          (duration (- current-time (get start-timestamp (unwrap-panic record)))))
      (map-set usage-records
        { record-id: record-id }
        (merge unwrapped-record
          {
            end-timestamp: current-time,
            duration: duration,
            status: "completed"
          }))
      (ok duration))))

;; Get usage record
(define-read-only (get-usage-record (record-id uint))
  (map-get? usage-records { record-id: record-id }))

;; Get usage record count
(define-read-only (get-record-count)
  (var-get record-counter))
