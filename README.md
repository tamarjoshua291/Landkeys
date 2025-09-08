# 🏞️ Landkeys - Access Rights Registry for Land

A Clarity smart contract that creates NFTs representing private and public land access rights on the Stacks blockchain.

## 🌟 Features

- 🗺️ **Land Registration**: Register land parcels with GPS coordinates and metadata
- 🔑 **Access Control**: Grant and revoke access permissions to land parcels  
- 🏪 **Marketplace**: List land NFTs for sale and purchase them
- 📋 **Access Requests**: Request access to private land with messaging
- 📊 **Usage Tracking**: Log land usage activities and maintain records
- 🔍 **Land Discovery**: Find land by coordinates or browse all registered parcels
- 🏠 **Land Rental System**: Create rental offers, accept rentals, and manage temporary access

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Stacks wallet for testing

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run Clarinet commands to test and deploy

```bash
clarinet check
```

```bash
clarinet test
```

```bash
clarinet deploy
```

## 📖 Usage

### Registering Land

Register a new land parcel as an NFT:

```clarity
(contract-call? .Landkeys register-land 
  40748817  ;; latitude (NYC coordinates * 1000000)
  -73985428 ;; longitude  
  1000      ;; size in square meters
  "private" ;; access type
  u"My backyard property")
```

### Granting Access

Land owners can grant access to other users:

```clarity
(contract-call? .Landkeys grant-access 
  u1                    ;; token-id
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM ;; user principal
  "visitor"             ;; permission type
  (some u144000))       ;; expires in ~1000 blocks
```

### Listing for Sale

Put your land NFT on the marketplace:

```clarity
(contract-call? .Landkeys list-for-sale u1 u1000000) ;; 1 STX
```

### Requesting Access

Users can request access to private land:

```clarity
(contract-call? .Landkeys request-access 
  u1 
  "hiking" 
  u"Would like to hike through your property this weekend")
```

### Checking Access

Verify if a user has access to land:

```clarity
(contract-call? .Landkeys check-access-permission u1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Land Rental System

#### Creating a Rental Offer

Land owners can offer their land for rent:

```clarity
(contract-call? .Landkeys create-rental-offer
  u1          ;; token-id
  u1000       ;; price per block (in microSTX)
  u100000     ;; start block
  u101440)    ;; end block (~1000 blocks duration)
```

#### Accepting a Rental

Users can rent land by accepting an offer and paying upfront:

```clarity
(contract-call? .Landkeys accept-rental u1) ;; token-id
```

#### Terminating a Rental

Either owner or renter can terminate early:

```clarity
(contract-call? .Landkeys terminate-rental u1) ;; token-id
```

#### Checking Rental Status

Check if land is currently rented:

```clarity
(contract-call? .Landkeys is-land-rented u1)
```

Get current renter:

```clarity
(contract-call? .Landkeys get-current-renter u1)
```

## 🔧 Contract Functions

### Public Functions

- `register-land` - Register new land parcel
- `transfer` - Transfer land NFT ownership  
- `grant-access` / `revoke-access` - Manage access permissions
- `list-for-sale` / `unlist-from-sale` / `buy-land` - Marketplace functions
- `request-access` / `respond-to-access-request` - Access request system
- `log-land-usage` - Record land usage activities
- `update-land-info` - Update land metadata
- `create-rental-offer` / `cancel-rental-offer` - Manage rental offers
- `accept-rental` / `terminate-rental` - Handle rental agreements

### Read-Only Functions

- `get-land-info` - Get land parcel details
- `get-land-by-coordinates` - Find land by GPS coordinates
- `get-access-permission` - Check user permissions
- `get-land-listing` - Get marketplace listing info
- `check-access-permission` - Verify access rights (includes rental access)
- `is-land-for-sale` - Check if land is for sale
- `get-rental-offer` / `get-active-rental` - Get rental information
- `is-land-rented` / `is-rental-expired` - Check rental status
- `get-current-renter` / `calculate-rental-cost` - Rental utilities

## 🏠 Land Rental System Details

The Land Rental System allows land owners to monetize their properties by offering temporary access rights to renters. Key features include:

- **Upfront Payment**: Renters pay the full rental amount when accepting an offer
- **Time-based Access**: Rental access is automatically managed based on block height
- **Flexible Duration**: Owners can set custom start and end blocks for rentals
- **Automatic Expiration**: Access permissions expire automatically when rentals end
- **Early Termination**: Both owners and renters can terminate rentals before expiry
- **Integrated Access Control**: Rental access integrates seamlessly with existing permission system

## 📄 License

MIT License - see LICENSE file for details.
