;; Asset Registration Contract
;; Records details of industrial machinery

(define-data-var contract-owner principal tx-sender)

;; Asset structure
(define-map assets
  { asset-id: uint }
  {
    owner: principal,
    name: (string-ascii 64),
    description: (string-ascii 256),
    location: (string-ascii 128),
    hourly-rate: uint,
    is-available: bool
  })

;; Asset counter
(define-data-var asset-counter uint u0)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ASSET-NOT-FOUND u101)
(define-constant ERR-NOT-OWNER u102)

;; Register a new asset
(define-public (register-asset
                (name (string-ascii 64))
                (description (string-ascii 256))
                (location (string-ascii 128))
                (hourly-rate uint))
  (let ((asset-id (var-get asset-counter)))
    (map-set assets
      { asset-id: asset-id }
      {
        owner: tx-sender,
        name: name,
        description: description,
        location: location,
        hourly-rate: hourly-rate,
        is-available: true
      })
    (var-set asset-counter (+ asset-id u1))
    (ok asset-id)))

;; Update asset details
(define-public (update-asset
                (asset-id uint)
                (name (string-ascii 64))
                (description (string-ascii 256))
                (location (string-ascii 128))
                (hourly-rate uint))
  (let ((asset (map-get? assets { asset-id: asset-id })))
    (asserts! (is-some asset) (err ERR-ASSET-NOT-FOUND))
    (asserts! (is-eq (get owner (unwrap-panic asset)) tx-sender) (err ERR-NOT-OWNER))
    (map-set assets
      { asset-id: asset-id }
      (merge (unwrap-panic asset)
        {
          name: name,
          description: description,
          location: location,
          hourly-rate: hourly-rate
        }))
    (ok true)))

;; Set asset availability
(define-public (set-availability (asset-id uint) (is-available bool))
  (let ((asset (map-get? assets { asset-id: asset-id })))
    (asserts! (is-some asset) (err ERR-ASSET-NOT-FOUND))
    (asserts! (is-eq (get owner (unwrap-panic asset)) tx-sender) (err ERR-NOT-OWNER))
    (map-set assets
      { asset-id: asset-id }
      (merge (unwrap-panic asset) { is-available: is-available }))
    (ok true)))

;; Get asset details
(define-read-only (get-asset (asset-id uint))
  (map-get? assets { asset-id: asset-id }))

;; Get asset count
(define-read-only (get-asset-count)
  (var-get asset-counter))
