
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
(define-constant err-not-certified-appraiser (err u109))
(define-constant err-appraisal-not-found (err u110))
(define-constant err-invalid-valuation (err u111))
(define-constant err-appraisal-too-recent (err u112))
(define-constant err-insufficient-stake (err u113))
(define-constant err-subdivision-not-found (err u114))
(define-constant err-subdivision-already-approved (err u115))
(define-constant err-invalid-subdivision-area (err u116))
(define-constant err-subdivision-pending (err u117))
(define-constant err-too-many-subdivisions (err u118))
(define-constant err-minimum-parcel-size (err u119))
(define-constant err-not-land-owner (err u120))
(define-constant err-rental-offer-not-found (err u121))
(define-constant err-rental-offer-active (err u122))
(define-constant err-rental-not-found (err u123))
(define-constant err-not-authorized (err u124))
(define-constant err-invalid-rental-period (err u125))
(define-constant err-rental-already-taken (err u126))
(define-constant err-rental-not-started (err u128))
(define-constant err-rental-ended (err u129))

(define-data-var last-token-id uint u0)
(define-data-var contract-uri (optional (string-utf8 256)) none)
(define-data-var minimum-appraiser-stake uint u1000000)
(define-data-var appraisal-cooldown-period uint u144)
(define-data-var subdivision-counter uint u0)
(define-data-var minimum-parcel-size uint u100)

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

(define-map certified-appraisers
  principal
  {
    certification-date: uint,
    stake-amount: uint,
    total-appraisals: uint,
    reputation-score: uint,
    specialization: (string-ascii 50),
    active: bool
  }
)

(define-map land-valuations
  { token-id: uint, valuation-id: uint }
  {
    appraiser: principal,
    estimated-value: uint,
    valuation-date: uint,
    methodology: (string-ascii 30),
    confidence-level: uint,
    market-conditions: (string-ascii 50),
    comparable-sales: (list 5 uint),
    appreciation-rate: int,
    notes: (string-utf8 512)
  }
)

(define-map valuation-history
  uint
  {
    token-id: uint,
    historical-values: (list 20 uint),
    historical-dates: (list 20 uint),
    last-updated: uint,
    trend-direction: (string-ascii 12),
    volatility-score: uint
  }
)

(define-map land-characteristics
  uint
  {
    soil-quality: uint,
    water-access: bool,
    road-access: bool,
    utilities-available: (list 5 (string-ascii 20)),
    zoning-type: (string-ascii 30),
    flood-risk: uint,
    slope-percentage: uint,
    vegetation-type: (string-ascii 30),
    development-potential: uint
  }
)

(define-map market-analysis
  { region: (string-ascii 50), period: uint }
  {
    average-price-per-sqm: uint,
    total-transactions: uint,
    median-valuation: uint,
    price-trend: int,
    demand-level: uint,
    supply-level: uint,
    market-stability: uint,
    last-updated: uint
  }
)

(define-map valuation-disputes
  { token-id: uint, dispute-id: uint }
  {
    challenger: principal,
    original-valuation: uint,
    challenged-valuation: uint,
    dispute-reason: (string-utf8 256),
    filed-at: uint,
    resolution-status: (string-ascii 20),
    arbitrator: (optional principal),
    final-ruling: (optional uint)
  }
)

;; Subdivision management maps
(define-map subdivision-proposals
  uint
  {
    parent-token-id: uint,
    proposer: principal,
    total-parcels: uint,
    parcel-areas: (list 10 uint),
    parcel-descriptions: (list 10 (string-utf8 256)),
    subdivision-purpose: (string-utf8 256),
    proposed-at: uint,
    status: (string-ascii 20),
    approval-date: (optional uint),
    approved-by: (optional principal)
  }
)

(define-map land-subdivisions
  uint
  {
    parent-token-id: uint,
    child-token-ids: (list 10 uint),
    subdivision-date: uint,
    original-area: uint,
    remaining-area: uint,
    subdivision-type: (string-ascii 30),
    legal-description: (string-utf8 512),
    surveyor: (optional principal),
    subdivision-fees: uint
  }
)

(define-map parcel-relationships
  uint
  {
    parent-token-id: (optional uint),
    child-token-ids: (list 10 uint),
    subdivision-level: uint,
    original-root-id: uint,
    relationship-type: (string-ascii 20)
  }
)

(define-map subdivision-requirements
  (string-ascii 30)
  {
    minimum-area: uint,
    maximum-parcels: uint,
    approval-required: bool,
    fees-required: uint,
    documentation-needed: (list 5 (string-ascii 50)),
    restrictions: (string-utf8 256)
  }
)

;; Land Rental System Maps
(define-map rental-offers
  uint  ;; token-id
  {
    owner: principal,
    price-per-block: uint,
    start-block: uint,
    end-block: uint,
    renter: (optional principal)
  }
)

(define-map active-rentals
  uint  ;; token-id
  {
    renter: principal,
    rental-end-block: uint
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

(define-public (become-certified-appraiser (specialization (string-ascii 50)))
  (let
    (
      (stake-amount (var-get minimum-appraiser-stake))
      (current-block stacks-block-height)
    )
    (asserts! (is-none (map-get? certified-appraisers tx-sender)) err-land-already-registered)
    (try! (stx-transfer? stake-amount tx-sender (as-contract tx-sender)))
    (map-set certified-appraisers tx-sender {
      certification-date: current-block,
      stake-amount: stake-amount,
      total-appraisals: u0,
      reputation-score: u100,
      specialization: specialization,
      active: true
    })
    (ok true)
  )
)

(define-public (submit-land-valuation (token-id uint) (valuation-id uint) (estimated-value uint) (methodology (string-ascii 30)) (confidence-level uint) (market-conditions (string-ascii 50)) (comparable-sales (list 5 uint)) (appreciation-rate int) (notes (string-utf8 512)))
  (let
    (
      (appraiser-info (unwrap! (map-get? certified-appraisers tx-sender) err-not-certified-appraiser))
      (current-block stacks-block-height)
      (existing-valuation (map-get? land-valuations { token-id: token-id, valuation-id: valuation-id }))
      ;; (last-valuation-date (default-to u0 (get valuation-date (default-to { appraiser: tx-sender, estimated-value: u0, valuation-date: u0, methodology: "", confidence-level: u0, market-conditions: "", comparable-sales: (list), appreciation-rate: 0, notes: u"" } existing-valuation))))
    )
    (asserts! (is-some (nft-get-owner? landkey token-id)) err-token-not-found)
    (asserts! (get active appraiser-info) err-not-certified-appraiser)
    (asserts! (> estimated-value u0) err-invalid-valuation)
    (asserts! (<= confidence-level u100) err-invalid-valuation)
    ;; (asserts! (> (- current-block last-valuation-date) (var-get appraisal-cooldown-period)) err-appraisal-too-recent)
    
    (map-set land-valuations { token-id: token-id, valuation-id: valuation-id } {
      appraiser: tx-sender,
      estimated-value: estimated-value,
      valuation-date: current-block,
      methodology: methodology,
      confidence-level: confidence-level,
      market-conditions: market-conditions,
      comparable-sales: comparable-sales,
      appreciation-rate: appreciation-rate,
      notes: notes
    })
    
    (map-set certified-appraisers tx-sender
      (merge appraiser-info {
        total-appraisals: (+ (get total-appraisals appraiser-info) u1),
        reputation-score: (if (> (+ (get reputation-score appraiser-info) u5) u1000) u1000 (+ (get reputation-score appraiser-info) u5))
      })
    )
    
    (unwrap! (update-valuation-history token-id estimated-value current-block) err-invalid-valuation)
    (ok true)
  )
)

(define-public (set-land-characteristics (token-id uint) (soil-quality uint) (water-access bool) (road-access bool) (utilities (list 5 (string-ascii 20))) (zoning-type (string-ascii 30)) (flood-risk uint) (slope-percentage uint) (vegetation-type (string-ascii 30)) (development-potential uint))
  (let
    (
      (token-owner (unwrap! (nft-get-owner? landkey token-id) err-token-not-found))
    )
    (asserts! (is-eq tx-sender token-owner) err-not-token-owner)
    (asserts! (<= soil-quality u10) err-invalid-valuation)
    (asserts! (<= flood-risk u10) err-invalid-valuation)
    (asserts! (<= slope-percentage u100) err-invalid-valuation)
    (asserts! (<= development-potential u10) err-invalid-valuation)
    
    (map-set land-characteristics token-id {
      soil-quality: soil-quality,
      water-access: water-access,
      road-access: road-access,
      utilities-available: utilities,
      zoning-type: zoning-type,
      flood-risk: flood-risk,
      slope-percentage: slope-percentage,
      vegetation-type: vegetation-type,
      development-potential: development-potential
    })
    (ok true)
  )
)

(define-public (update-market-analysis (region (string-ascii 50)) (period uint) (avg-price-per-sqm uint) (total-transactions uint) (median-valuation uint) (price-trend int) (demand-level uint) (supply-level uint) (market-stability uint))
  (let
    (
      (current-block stacks-block-height)
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> avg-price-per-sqm u0) err-invalid-valuation)
    (asserts! (<= demand-level u10) err-invalid-valuation)
    (asserts! (<= supply-level u10) err-invalid-valuation)
    (asserts! (<= market-stability u10) err-invalid-valuation)
    
    (map-set market-analysis { region: region, period: period } {
      average-price-per-sqm: avg-price-per-sqm,
      total-transactions: total-transactions,
      median-valuation: median-valuation,
      price-trend: price-trend,
      demand-level: demand-level,
      supply-level: supply-level,
      market-stability: market-stability,
      last-updated: current-block
    })
    (ok true)
  )
)

(define-public (file-valuation-dispute (token-id uint) (dispute-id uint) (original-valuation uint) (challenged-valuation uint) (dispute-reason (string-utf8 256)))
  (let
    (
      (current-block stacks-block-height)
    )
    (asserts! (is-some (nft-get-owner? landkey token-id)) err-token-not-found)
    (asserts! (> challenged-valuation u0) err-invalid-valuation)
    (asserts! (is-none (map-get? valuation-disputes { token-id: token-id, dispute-id: dispute-id })) err-land-already-registered)
    
    (map-set valuation-disputes { token-id: token-id, dispute-id: dispute-id } {
      challenger: tx-sender,
      original-valuation: original-valuation,
      challenged-valuation: challenged-valuation,
      dispute-reason: dispute-reason,
      filed-at: current-block,
      resolution-status: "pending",
      arbitrator: none,
      final-ruling: none
    })
    (ok true)
  )
)

(define-public (resolve-valuation-dispute (token-id uint) (dispute-id uint) (final-ruling uint))
  (let
    (
      (dispute-info (unwrap! (map-get? valuation-disputes { token-id: token-id, dispute-id: dispute-id }) err-appraisal-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-eq (get resolution-status dispute-info) "pending") err-appraisal-not-found)
    (asserts! (> final-ruling u0) err-invalid-valuation)
    
    (map-set valuation-disputes { token-id: token-id, dispute-id: dispute-id }
      (merge dispute-info {
        resolution-status: "resolved",
        arbitrator: (some tx-sender),
        final-ruling: (some final-ruling)
      })
    )
    (ok true)
  )
)

(define-private (update-valuation-history (token-id uint) (new-value uint) (valuation-date uint))
  (let
    (
      (existing-history (map-get? valuation-history token-id))
      (current-history (default-to {
        token-id: token-id,
        historical-values: (list),
        historical-dates: (list),
        last-updated: u0,
        trend-direction: "stable",
        volatility-score: u0
      } existing-history))
      (values-list (get historical-values current-history))
      (dates-list (get historical-dates current-history))
      (updated-values (unwrap! (as-max-len? (append values-list new-value) u20) err-invalid-valuation))
      (updated-dates (unwrap! (as-max-len? (append dates-list valuation-date) u20) err-invalid-valuation))
      (trend (calculate-trend updated-values))
      (volatility (calculate-volatility updated-values))
    )
    (map-set valuation-history token-id {
      token-id: token-id,
      historical-values: updated-values,
      historical-dates: updated-dates,
      last-updated: valuation-date,
      trend-direction: trend,
      volatility-score: volatility
    })
    (ok true)
  )
)

(define-private (calculate-trend (values (list 20 uint)))
  (let
    (
      (values-len (len values))
    )
    (if (< values-len u2)
      "insufficient"
      (let
        (
          (recent-value (unwrap-panic (element-at values (- values-len u1))))
          (previous-value (unwrap-panic (element-at values (- values-len u2))))
        )
        (if (> recent-value previous-value)
          "increasing"
          (if (< recent-value previous-value)
            "decreasing"
            "stable"
          )
        )
      )
    )
  )
)

(define-private (calculate-volatility (values (list 20 uint)))
  (let
    (
      (values-len (len values))
    )
    (if (< values-len u3)
      u0
      (let
        (
          (max-val (fold max-value values u0))
          (min-val (fold min-value values u999999999))
          (range-val (- max-val min-val))
          (avg-val (/ (fold sum-values values u0) values-len))
        )
        (if (> avg-val u0)
          (let ((volatility-calc (/ (* range-val u100) avg-val)))
            (if (> volatility-calc u100) u100 volatility-calc)
          )
          u0
        )
      )
    )
  )
)

(define-private (max-value (current uint) (max-so-far uint))
  (if (> current max-so-far) current max-so-far)
)

(define-private (min-value (current uint) (min-so-far uint))
  (if (< current min-so-far) current min-so-far)
)

(define-private (sum-values (current uint) (sum-so-far uint))
  (+ current sum-so-far)
)

;; Subdivision Management Functions
(define-public (propose-land-subdivision (parent-token-id uint) (parcel-areas (list 10 uint)) (parcel-descriptions (list 10 (string-utf8 256))) (subdivision-purpose (string-utf8 256)) (subdivision-type (string-ascii 30)))
  (let
    (
      (proposal-id (+ (var-get subdivision-counter) u1))
      (token-owner (unwrap! (nft-get-owner? landkey parent-token-id) err-token-not-found))
      (land-info (unwrap! (map-get? land-registry parent-token-id) err-token-not-found))
      (total-proposed-area (fold calculate-total-area parcel-areas u0))
      (original-area (get size-sqm land-info))
      (min-size (var-get minimum-parcel-size))
      (requirements (map-get? subdivision-requirements subdivision-type))
    )
    ;; Validate ownership and basic requirements
    (asserts! (is-eq tx-sender token-owner) err-not-token-owner)
    (asserts! (<= total-proposed-area original-area) err-invalid-subdivision-area)
    (asserts! (<= (len parcel-areas) u10) err-too-many-subdivisions)
    (asserts! (check-minimum-parcel-sizes parcel-areas min-size) err-minimum-parcel-size)
    
    ;; Check subdivision type requirements if they exist
    (match requirements
      reqs (begin
        (asserts! (>= original-area (get minimum-area reqs)) err-invalid-subdivision-area)
        (asserts! (<= (len parcel-areas) (get maximum-parcels reqs)) err-too-many-subdivisions)
      )
      true
    )
    
    ;; Create subdivision proposal
    (map-set subdivision-proposals proposal-id {
      parent-token-id: parent-token-id,
      proposer: tx-sender,
      total-parcels: (len parcel-areas),
      parcel-areas: parcel-areas,
      parcel-descriptions: parcel-descriptions,
      subdivision-purpose: subdivision-purpose,
      proposed-at: stacks-block-height,
      status: "pending",
      approval-date: none,
      approved-by: none
    })
    
    (var-set subdivision-counter proposal-id)
    (ok proposal-id)
  )
)

(define-public (approve-subdivision-proposal (proposal-id uint))
  (let
    (
      (proposal (unwrap! (map-get? subdivision-proposals proposal-id) err-subdivision-not-found))
      (subdivision-type (get status proposal))
    )
    ;; Only contract owner can approve subdivisions
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-eq subdivision-type "pending") err-subdivision-already-approved)
    
    ;; Update proposal status
    (map-set subdivision-proposals proposal-id
      (merge proposal {
        status: "approved",
        approval-date: (some stacks-block-height),
        approved-by: (some tx-sender)
      })
    )
    (ok true)
  )
)

(define-public (execute-land-subdivision (proposal-id uint) (legal-description (string-utf8 512)) (surveyor (optional principal)))
  (let
    (
      (proposal (unwrap! (map-get? subdivision-proposals proposal-id) err-subdivision-not-found))
      (parent-token-id (get parent-token-id proposal))
      (token-owner (unwrap! (nft-get-owner? landkey parent-token-id) err-token-not-found))
      (land-info (unwrap! (map-get? land-registry parent-token-id) err-token-not-found))
      (parcel-areas (get parcel-areas proposal))
      (parcel-descriptions (get parcel-descriptions proposal))
      (current-block stacks-block-height)
    )
    ;; Validate permissions and status
    (asserts! (is-eq tx-sender (get proposer proposal)) err-not-token-owner)
    (asserts! (is-eq (get status proposal) "approved") err-subdivision-pending)
    
    ;; Execute the subdivision
    (let
      (
        (new-token-ids (create-subdivision-parcels parent-token-id parcel-areas parcel-descriptions (get latitude land-info) (get longitude land-info)))
        (total-subdivided-area (fold calculate-total-area parcel-areas u0))
        (remaining-area (- (get size-sqm land-info) total-subdivided-area))
      )
      ;; Record subdivision details
      (map-set land-subdivisions proposal-id {
        parent-token-id: parent-token-id,
        child-token-ids: new-token-ids,
        subdivision-date: current-block,
        original-area: (get size-sqm land-info),
        remaining-area: remaining-area,
        subdivision-type: "residential",
        legal-description: legal-description,
        surveyor: surveyor,
        subdivision-fees: u0
      })
      
      ;; Update parent land area
      (map-set land-registry parent-token-id
        (merge land-info {
          size-sqm: remaining-area,
          last-updated: current-block
        })
      )
      
      ;; Update parcel relationships
      (update-parcel-relationships parent-token-id new-token-ids)
      
      ;; Mark proposal as executed
      (map-set subdivision-proposals proposal-id
        (merge proposal { status: "executed" })
      )
      
      (ok new-token-ids)
    )
  )
)

(define-public (set-subdivision-requirements (subdivision-type (string-ascii 30)) (min-area uint) (max-parcels uint) (approval-required bool) (fees uint) (docs (list 5 (string-ascii 50))) (restrictions (string-utf8 256)))
  (begin
    ;; Only contract owner can set requirements
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set subdivision-requirements subdivision-type {
      minimum-area: min-area,
      maximum-parcels: max-parcels,
      approval-required: approval-required,
      fees-required: fees,
      documentation-needed: docs,
      restrictions: restrictions
    })
    (ok true)
  )
)

;; Helper functions for subdivision management
(define-private (create-subdivision-parcels (parent-id uint) (areas (list 10 uint)) (descriptions (list 10 (string-utf8 256))) (base-lat int) (base-lng int))
  (let
    (
      (new-ids (map create-single-parcel (zip areas descriptions)))
    )
    new-ids
  )
)

(define-private (create-single-parcel (area-desc {area: uint, description: (string-utf8 256)}))
  (let
    (
      (new-token-id (+ (var-get last-token-id) u1))
      (area (get area area-desc))
      (description (get description area-desc))
    )
    ;; Create new NFT for subdivided parcel
    (unwrap-panic (nft-mint? landkey new-token-id tx-sender))
    
    ;; Register new land parcel
    (map-set land-registry new-token-id {
      latitude: 0, ;; Would be calculated based on subdivision layout
      longitude: 0,
      size-sqm: area,
      access-type: "private",
      description: description,
      created-at: stacks-block-height,
      last-updated: stacks-block-height
    })
    
    (var-set last-token-id new-token-id)
    new-token-id
  )
)

(define-private (update-parcel-relationships (parent-id uint) (child-ids (list 10 uint)))
  (begin
    ;; Update parent relationship
    (map-set parcel-relationships parent-id {
      parent-token-id: none,
      child-token-ids: child-ids,
      subdivision-level: u1,
      original-root-id: parent-id,
      relationship-type: "parent"
    })
    
    ;; Set relationships for each child
    (map set-child-relationship child-ids)
    true
  )
)

(define-private (set-child-relationship (child-id uint))
  (map-set parcel-relationships child-id {
    parent-token-id: none,
    child-token-ids: (list),
    subdivision-level: u1,
    original-root-id: child-id,
    relationship-type: "child"
  })
)



(define-private (calculate-total-area (area uint) (total uint))
  (+ area total)
)

(define-private (check-minimum-parcel-sizes (areas (list 10 uint)) (min-size uint))
  (fold check-single-area areas true)
)

(define-private (check-single-area (area uint) (valid bool))
  (and valid (>= area (var-get minimum-parcel-size)))
)

(define-private (zip (areas (list 10 uint)) (descriptions (list 10 (string-utf8 256))))
  (map create-area-desc-pair areas)
)

(define-private (create-area-desc-pair (area uint))
  { area: area, description: u"Subdivided parcel" }
)

;; Land Rental System Functions

;; Create a rental offer for a land NFT
(define-public (create-rental-offer (token-id uint) (price-per-block uint) (start-block uint) (end-block uint))
  (let (
        (owner (unwrap! (nft-get-owner? landkey token-id) err-not-land-owner)))
    (begin
      (asserts! (is-eq tx-sender owner) err-not-land-owner)
      (asserts! (> end-block start-block) err-invalid-rental-period)
      (asserts! (is-none (map-get? rental-offers token-id)) err-rental-offer-active)
      (map-set rental-offers token-id {
        owner: owner,
        price-per-block: price-per-block,
        start-block: start-block,
        end-block: end-block,
        renter: none
      })
      (ok true)
    )))

;; Cancel an existing rental offer (only if not rented)
(define-public (cancel-rental-offer (token-id uint))
  (let (
        (offer (unwrap! (map-get? rental-offers token-id) err-rental-offer-not-found)))
    (begin
      (asserts! (is-eq tx-sender (get owner offer)) err-not-land-owner)
      (asserts! (is-none (get renter offer)) err-rental-offer-active)
      (map-delete rental-offers token-id)
      (ok true)
    )))

;; Accept rental offer and pay rent upfront
(define-public (accept-rental (token-id uint))
  (let (
        (offer (unwrap! (map-get? rental-offers token-id) err-rental-offer-not-found))
        (owner (get owner offer))
        (price-per-block (get price-per-block offer))
        (start-block (get start-block offer))
        (end-block (get end-block offer))
        (current-block stacks-block-height)
        (renter tx-sender)
        (rental-duration (- end-block start-block))
        (total-rent (* price-per-block rental-duration))
       )
    (begin
      (asserts! (is-none (get renter offer)) err-rental-already-taken)
      (asserts! (>= current-block start-block) err-rental-not-started)
      (asserts! (<= current-block end-block) err-rental-ended)
      (try! (stx-transfer? total-rent renter owner))
      ;; Update rental offer with renter info
      (map-set rental-offers token-id (merge offer { renter: (some renter) }))
      ;; Grant access permission to renter for rental duration
      (map-set access-permissions { token-id: token-id, user: renter } {
        permission-type: "rental",
        granted-at: current-block,
        expires-at: (some end-block),
        granted-by: owner
      })
      ;; Record active rental
      (map-set active-rentals token-id {
        renter: renter,
        rental-end-block: end-block
      })
      (ok true)
    )))

;; Terminate rental before expiry (by owner or renter)
(define-public (terminate-rental (token-id uint))
  (let (
        (rental (unwrap! (map-get? active-rentals token-id) err-rental-not-found))
        (offer (unwrap! (map-get? rental-offers token-id) err-rental-offer-not-found))
        (owner (get owner offer))
        (renter (get renter rental))
        (caller tx-sender)
       )
    (begin
      (asserts! (or (is-eq caller owner) (is-eq caller renter)) err-not-authorized)
      ;; Remove renter from offer
      (map-set rental-offers token-id (merge offer { renter: none }))
      ;; Delete active rental record
      (map-delete active-rentals token-id)
      ;; Revoke rental permission
      (map-delete access-permissions { token-id: token-id, user: renter })
      (ok true)
    )))

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
      (rental (map-get? active-rentals token-id))
    )
    (if (is-eq (some user) token-owner)
      true
      (match rental
        rented (if (and (is-eq (get renter rented) user)
                        (<= current-block (get rental-end-block rented)))
                   true
                   (match permission
                     perm (match (get expires-at perm)
                            expiry (< current-block expiry)
                            true
                           )
                     false))
        (match permission
               perm (match (get expires-at perm)
                      expiry (< current-block expiry)
                      true
                     )
               false)))
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

(define-read-only (get-appraiser-info (appraiser principal))
  (map-get? certified-appraisers appraiser)
)

(define-read-only (get-land-valuation (token-id uint) (valuation-id uint))
  (map-get? land-valuations { token-id: token-id, valuation-id: valuation-id })
)

(define-read-only (get-valuation-history (token-id uint))
  (map-get? valuation-history token-id)
)

(define-read-only (get-land-characteristics (token-id uint))
  (map-get? land-characteristics token-id)
)

(define-read-only (get-market-analysis (region (string-ascii 50)) (period uint))
  (map-get? market-analysis { region: region, period: period })
)

(define-read-only (get-valuation-dispute (token-id uint) (dispute-id uint))
  (map-get? valuation-disputes { token-id: token-id, dispute-id: dispute-id })
)

(define-read-only (get-current-valuation (token-id uint))
  (let
    (
      (history (map-get? valuation-history token-id))
    )
    (match history
      hist (let
        (
          (values-list (get historical-values hist))
          (values-len (len values-list))
        )
        (if (> values-len u0)
          (element-at values-list (- values-len u1))
          none
        )
      )
      none
    )
  )
)

(define-read-only (get-valuation-trend (token-id uint))
  (let
    (
      (history (map-get? valuation-history token-id))
    )
    (match history
      hist (some (get trend-direction hist))
      none
    )
  )
)

(define-read-only (calculate-property-score (token-id uint))
  (let
    (
      (characteristics (map-get? land-characteristics token-id))
      (land-info (map-get? land-registry token-id))
    )
    (match characteristics
      chars (let
        (
          (soil-score (* (get soil-quality chars) u10))
          (access-score (+ (if (get water-access chars) u25 u0) (if (get road-access chars) u25 u0)))
          (risk-score (- u100 (* (get flood-risk chars) u10)))
          (development-score (* (get development-potential chars) u10))
          (utilities-score (* (len (get utilities-available chars)) u10))
        )
        (let ((total-score (+ soil-score access-score risk-score development-score utilities-score)))
          (if (> total-score u1000) u1000 total-score)
        )
      )
      u0
    )
  )
)

(define-read-only (get-minimum-appraiser-stake)
  (var-get minimum-appraiser-stake)
)

(define-read-only (get-appraisal-cooldown-period)
  (var-get appraisal-cooldown-period)
)

;; Subdivision read-only functions
(define-read-only (get-subdivision-proposal (proposal-id uint))
  (map-get? subdivision-proposals proposal-id)
)

(define-read-only (get-land-subdivision (subdivision-id uint))
  (map-get? land-subdivisions subdivision-id)
)

(define-read-only (get-parcel-relationships (token-id uint))
  (map-get? parcel-relationships token-id)
)

(define-read-only (get-subdivision-requirements (subdivision-type (string-ascii 30)))
  (map-get? subdivision-requirements subdivision-type)
)

(define-read-only (get-subdivision-counter)
  (var-get subdivision-counter)
)

(define-read-only (get-minimum-parcel-size)
  (var-get minimum-parcel-size)
)

(define-read-only (is-subdivided-land (token-id uint))
  (let
    (
      (relationships (map-get? parcel-relationships token-id))
    )
    (match relationships
      rel (> (len (get child-token-ids rel)) u0)
      false
    )
  )
)

(define-read-only (get-parent-land (token-id uint))
  (let
    (
      (relationships (map-get? parcel-relationships token-id))
    )
    (match relationships
      rel (get parent-token-id rel)
      none
    )
  )
)

(define-read-only (get-child-parcels (token-id uint))
  (let
    (
      (relationships (map-get? parcel-relationships token-id))
    )
    (match relationships
      rel (some (get child-token-ids rel))
      none
    )
  )
)

(define-read-only (calculate-subdivision-fees (token-id uint) (num-parcels uint))
  (let
    (
      (land-info (map-get? land-registry token-id))
      (base-fee u50000)
      (per-parcel-fee u10000)
    )
    (match land-info
      info (let
        (
          (area-fee (/ (get size-sqm info) u100))
          (total-fee (+ base-fee (* per-parcel-fee num-parcels) area-fee))
        )
        (some total-fee)
      )
      none
    )
  )
)

;; Rental System Read-only Functions

;; Read-only function to get rental offer
(define-read-only (get-rental-offer (token-id uint))
  (map-get? rental-offers token-id))

;; Read-only function to get active rental
(define-read-only (get-active-rental (token-id uint))
  (map-get? active-rentals token-id))

;; Check if a land is currently rented
(define-read-only (is-land-rented (token-id uint))
  (let (
        (rental (map-get? active-rentals token-id))
        (current-block stacks-block-height)
       )
    (match rental
      active-rental (< current-block (get rental-end-block active-rental))
      false)))

;; Check if a rental has expired
(define-read-only (is-rental-expired (token-id uint))
  (let (
        (rental (map-get? active-rentals token-id))
        (current-block stacks-block-height)
       )
    (match rental
      active-rental (>= current-block (get rental-end-block active-rental))
      true)))

;; Get current renter for a land
(define-read-only (get-current-renter (token-id uint))
  (let (
        (rental (map-get? active-rentals token-id))
        (current-block stacks-block-height)
       )
    (match rental
      active-rental (if (< current-block (get rental-end-block active-rental))
                       (some (get renter active-rental))
                       none)
      none)))

;; Calculate total rent for a rental offer
(define-read-only (calculate-rental-cost (token-id uint))
  (let (
        (offer (map-get? rental-offers token-id))
       )
    (match offer
      rental-offer (let (
                     (duration (- (get end-block rental-offer) (get start-block rental-offer)))
                     (price-per-block (get price-per-block rental-offer))
                    )
                    (some (* duration price-per-block)))
      none)))




