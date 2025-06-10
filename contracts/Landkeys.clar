
(define-non-fungible-token landkey uint)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-listing-not-found (err u102))
(define-constant err-not-for-sale (err u103))
(define-constant err-insufficient-payment (err u104))
(define-constant err-token-not-found (err u105))
(define-constant err-unauthorized-access (err u106))
(define-constant err-invalid-coordinates (err u107))
(define-constant err-land-already-registered (err u108))

(define-data-var last-token-id uint u0)
(define-data-var contract-uri (optional (string-utf8 256)) none)

(define-map land-registry
  uint
  {
    latitude: int,
    longitude: int,
    size-sqm: uint,
    access-type: (string-ascii 10),
    description: (string-utf8 256),
    created-at: uint,
    last-updated: uint
  }
)

(define-map land-coordinates
  { latitude: int, longitude: int }
  uint
)

(define-map access-permissions
  { token-id: uint, user: principal }
  {
    permission-type: (string-ascii 20),
    granted-at: uint,
    expires-at: (optional uint),
    granted-by: principal
  }
)

(define-map land-listings
  uint
  {
    price: uint,
    seller: principal,
    listed-at: uint,
    active: bool
  }
)

(define-map access-requests
  { token-id: uint, requester: principal }
  {
    request-type: (string-ascii 20),
    message: (string-utf8 256),
    requested-at: uint,
    status: (string-ascii 10)
  }
)

(define-map land-usage-log
  { token-id: uint, user: principal, timestamp: uint }
  {
    action: (string-ascii 50),
    duration: (optional uint),
    notes: (optional (string-utf8 256))
  }
)

(define-public (register-land (latitude int) (longitude int) (size-sqm uint) (access-type (string-ascii 10)) (description (string-utf8 256)))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
      (current-block stacks-block-height)
    )
    (asserts! (and (>= latitude -90000000) (<= latitude 90000000)) err-invalid-coordinates)
    (asserts! (and (>= longitude -180000000) (<= longitude 180000000)) err-invalid-coordinates)
    (asserts! (is-none (map-get? land-coordinates { latitude: latitude, longitude: longitude })) err-land-already-registered)
    
    (try! (nft-mint? landkey token-id tx-sender))
    (map-set land-registry token-id {
      latitude: latitude,
      longitude: longitude,
      size-sqm: size-sqm,
      access-type: access-type,
      description: description,
      created-at: current-block,
      last-updated: current-block
    })
    (map-set land-coordinates { latitude: latitude, longitude: longitude } token-id)
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (try! (nft-transfer? landkey token-id sender recipient))
    (map-delete land-listings token-id)
    (ok true)
  )
)

(define-public (grant-access (token-id uint) (user principal) (permission-type (string-ascii 20)) (expires-at (optional uint)))
  (let
    (
      (token-owner (unwrap! (nft-get-owner? landkey token-id) err-token-not-found))
    )
    (asserts! (is-eq tx-sender token-owner) err-not-token-owner)
    (map-set access-permissions { token-id: token-id, user: user } {
      permission-type: permission-type,
      granted-at: stacks-block-height,
      expires-at: expires-at,
      granted-by: tx-sender
    })
    (ok true)
  )
)

(define-public (revoke-access (token-id uint) (user principal))
  (let
    (
      (token-owner (unwrap! (nft-get-owner? landkey token-id) err-token-not-found))
    )
    (asserts! (is-eq tx-sender token-owner) err-not-token-owner)
    (map-delete access-permissions { token-id: token-id, user: user })
    (ok true)
  )
)

(define-public (list-for-sale (token-id uint) (price uint))
  (let
    (
      (token-owner (unwrap! (nft-get-owner? landkey token-id) err-token-not-found))
    )
    (asserts! (is-eq tx-sender token-owner) err-not-token-owner)
    (map-set land-listings token-id {
      price: price,
      seller: tx-sender,
      listed-at: stacks-block-height,
      active: true
    })
    (ok true)
  )
)

(define-public (unlist-from-sale (token-id uint))
  (let
    (
      (token-owner (unwrap! (nft-get-owner? landkey token-id) err-token-not-found))
    )
    (asserts! (is-eq tx-sender token-owner) err-not-token-owner)
    (map-delete land-listings token-id)
    (ok true)
  )
)

(define-public (buy-land (token-id uint))
  (let
    (
      (listing (unwrap! (map-get? land-listings token-id) err-listing-not-found))
      (price (get price listing))
      (seller (get seller listing))
    )
    (asserts! (get active listing) err-not-for-sale)
    (try! (stx-transfer? price tx-sender seller))
    (try! (nft-transfer? landkey token-id seller tx-sender))
    (map-delete land-listings token-id)
    (ok true)
  )
)

(define-public (request-access (token-id uint) (request-type (string-ascii 20)) (message (string-utf8 256)))
  (begin
    (asserts! (is-some (nft-get-owner? landkey token-id)) err-token-not-found)
    (map-set access-requests { token-id: token-id, requester: tx-sender } {
      request-type: request-type,
      message: message,
      requested-at: stacks-block-height,
      status: "pending"
    })
    (ok true)
  )
)

(define-public (respond-to-access-request (token-id uint) (requester principal) (status (string-ascii 10)))
  (let
    (
      (token-owner (unwrap! (nft-get-owner? landkey token-id) err-token-not-found))
      (request (unwrap! (map-get? access-requests { token-id: token-id, requester: requester }) err-listing-not-found))
    )
    (asserts! (is-eq tx-sender token-owner) err-not-token-owner)
    (map-set access-requests { token-id: token-id, requester: requester }
      (merge request { status: status })
    )
    (ok true)
  )
)

(define-public (log-land-usage (token-id uint) (action (string-ascii 50)) (duration (optional uint)) (notes (optional (string-utf8 256))))
  (let
    (
      (current-block stacks-block-height)
      (has-access (check-access-permission token-id tx-sender))
    )
    (asserts! has-access err-unauthorized-access)
    (map-set land-usage-log { token-id: token-id, user: tx-sender, timestamp: current-block } {
      action: action,
      duration: duration,
      notes: notes
    })
    (ok true)
  )
)

(define-public (update-land-info (token-id uint) (description (string-utf8 256)) (access-type (string-ascii 10)))
  (let
    (
      (token-owner (unwrap! (nft-get-owner? landkey token-id) err-token-not-found))
      (land-info (unwrap! (map-get? land-registry token-id) err-token-not-found))
    )
    (asserts! (is-eq tx-sender token-owner) err-not-token-owner)
    (map-set land-registry token-id
      (merge land-info {
        description: description,
        access-type: access-type,
        last-updated: stacks-block-height
      })
    )
    (ok true)
  )
)

(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
  (ok (var-get contract-uri))
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? landkey token-id))
)

(define-read-only (get-land-info (token-id uint))
  (map-get? land-registry token-id)
)

(define-read-only (get-land-by-coordinates (latitude int) (longitude int))
  (map-get? land-coordinates { latitude: latitude, longitude: longitude })
)

(define-read-only (get-access-permission (token-id uint) (user principal))
  (map-get? access-permissions { token-id: token-id, user: user })
)

(define-read-only (get-land-listing (token-id uint))
  (map-get? land-listings token-id)
)

(define-read-only (get-access-request (token-id uint) (requester principal))
  (map-get? access-requests { token-id: token-id, requester: requester })
)

(define-read-only (get-usage-log (token-id uint) (user principal) (timestamp uint))
  (map-get? land-usage-log { token-id: token-id, user: user, timestamp: timestamp })
)

(define-read-only (check-access-permission (token-id uint) (user principal))
  (let
    (
      (token-owner (nft-get-owner? landkey token-id))
      (permission (map-get? access-permissions { token-id: token-id, user: user }))
      (current-block stacks-block-height)
    )
    (if (is-eq (some user) token-owner)
      true
      (match permission
        perm (match (get expires-at perm)
          expiry (< current-block expiry)
          true
        )
        false
      )
    )
  )
)

(define-read-only (is-land-for-sale (token-id uint))
  (match (map-get? land-listings token-id)
    listing (get active listing)
    false
  )
)

(define-read-only (get-lands-count)
  (var-get last-token-id)
)