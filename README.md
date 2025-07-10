# 🏞️ Landkeys - Access Rights Registry for Land

A Clarity smart contract that creates NFTs representing private and public land access rights on the Stacks blockchain.

## 🌟 Features

- 🗺️ **Land Registration**: Register land parcels with GPS coordinates and metadata
- 🔑 **Access Control**: Grant and revoke access permissions to land parcels  
- 🏪 **Marketplace**: List land NFTs for sale and purchase them
- 📋 **Access Requests**: Request access to private land with messaging
- 📊 **Usage Tracking**: Log land usage activities and maintain records
- 🔍 **Land Discovery**: Find land by coordinates or browse all registered parcels

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

## 🔧 Contract Functions

### Public Functions

- `register-land` - Register new land parcel
- `transfer` - Transfer land NFT ownership  
- `grant-access` / `revoke-access` - Manage access permissions
- `list-for-sale` / `unlist-from-sale` / `buy-land` - Marketplace functions
- `request-access` / `respond-to-access-request` - Access request system
- `log-land-usage` - Record land usage activities
- `update-land-info` - Update land metadata

### Read-Only Functions

- `get-land-info` - Get land parcel details
- `get-land-by-coordinates` - Find land by GPS coordinates
- `get-access-permission` - Check user permissions
- `get-land-listing` - Get marketplace listing info
- `check-access-permission` - Verify access rights
- `is-land-for-sale` - Check if