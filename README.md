# Decentralized Manufacturing Equipment Sharing Platform

A blockchain-based platform for sharing industrial manufacturing equipment, built with Clarity smart contracts on the Stacks blockchain.

## Overview

This platform enables manufacturers to share their equipment with others in a decentralized, trustless manner. Equipment owners can register their machinery, set availability and pricing, while renters can browse, reserve, and pay for equipment usage without requiring intermediaries.

## Architecture

The platform consists of five core smart contracts that work together to create a complete equipment sharing ecosystem:

![Architecture Diagram](https://via.placeholder.com/800x500?text=Decentralized+Manufacturing+Equipment+Sharing+Architecture)

### Smart Contracts

1. **Owner Verification Contract** (`owner-verification.clar`)
    - Validates equipment holders through a verification system
    - Maintains a registry of verified equipment owners
    - Provides functions to add, remove, and check verification status
    - Includes ownership transfer functionality

2. **Asset Registration Contract** (`asset-registration.clar`)
    - Records details of industrial machinery (name, description, location, etc.)
    - Manages asset registration and information updates
    - Controls asset availability status
    - Links assets to their verified owners

3. **Reservation Contract** (`reservation.clar`)
    - Manages scheduling and availability of equipment
    - Handles reservation creation, confirmation, completion, and cancellation
    - Tracks reservation status throughout the lifecycle
    - Prevents scheduling conflicts

4. **Usage Tracking Contract** (`usage-tracking.clar`)
    - Monitors equipment utilization with precise timestamps
    - Records start and end times of equipment usage
    - Calculates usage duration for payment purposes
    - Provides usage history for reporting

5. **Payment Settlement Contract** (`payment-settlement.clar`)
    - Handles automated compensation between parties
    - Creates payment records linking reservations to usage
    - Processes payments and refunds
    - Ensures fair compensation based on actual usage

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity development environment
- Basic knowledge of [Clarity language](https://docs.stacks.co/clarity/introduction)
- [Node.js](https://nodejs.org/) (for running tests)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/decentralized-manufacturing-equipment-sharing.git
   cd decentralized-manufacturing-equipment-sharing
   
```markdown project="Decentralized Manufacturing Equipment Sharing" file="README.md"
...
```

2. Install dependencies:

```shellscript
npm install
```


3. Deploy contracts to a local Clarinet environment:

```shellscript
clarinet console
```




## Usage Flow

### For Equipment Owners

1. **Get Verified**

1. Owner submits verification request through the Owner Verification Contract
2. Once verified, the owner can register equipment



2. **Register Equipment**

1. Owner registers equipment with details (name, description, location, hourly rate)
2. Equipment is added to the available pool



3. **Manage Reservations**

1. Owner reviews and confirms/rejects reservation requests
2. Owner can update equipment availability as needed



4. **Track Usage**

1. Usage is automatically tracked when equipment is in use
2. Usage data determines payment amounts



5. **Receive Payments**

1. Payments are automatically processed based on usage
2. Funds are transferred to the owner's wallet





### For Equipment Renters

1. **Browse Equipment**

1. Renter browses available equipment in the marketplace



2. **Make Reservations**

1. Renter creates a reservation for desired equipment and timeframe
2. Reservation is pending until confirmed by owner



3. **Use Equipment**

1. Renter uses the equipment during the reserved time period
2. Usage is tracked for payment calculation



4. **Make Payments**

1. Payments are automatically processed based on actual usage
2. Payment records are stored on-chain for transparency





## Testing

The project includes comprehensive tests for all contracts using Vitest. Run the tests with:

```shellscript
npm test
```

## Contract Interaction Diagram

```plaintext
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│                 │      │                 │      │                 │
│ Owner           │      │ Asset           │      │ Reservation     │
│ Verification    │◄────►│ Registration    │◄────►│ Contract        │
│ Contract        │      │ Contract        │      │                 │
│                 │      │                 │      │                 │
└─────────────────┘      └────────┬────────┘      └────────┬────────┘
                                  │                        │
                                  │                        │
                                  ▼                        ▼
                         ┌─────────────────┐      ┌─────────────────┐
                         │                 │      │                 │
                         │ Usage           │◄────►│ Payment         │
                         │ Tracking        │      │ Settlement      │
                         │ Contract        │      │ Contract        │
                         │                 │      │                 │
                         └─────────────────┘      └─────────────────┘
```

## Future Enhancements

- Integration with IoT devices for automated usage tracking
- Reputation system for equipment owners and renters
- Dispute resolution mechanism
- Enhanced search and filtering capabilities
- Mobile application for on-the-go management
- Integration with DeFi protocols for lending against equipment
- Multi-signature approval for high-value equipment


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Stacks blockchain community
- Clarity language developers
- Contributors to the decentralized manufacturing ecosystem


```plaintext

This README provides a comprehensive overview of your Decentralized Manufacturing Equipment Sharing platform. It includes information about the architecture, smart contracts, installation instructions, usage flows, testing procedures, and future enhancements. The document is structured to be helpful for both users and developers who want to understand or contribute to the project.

<Actions>
  <Action name="Create PR details file" description="Generate a detailed PR description document" />
  <Action name="Add contract diagrams" description="Create detailed diagrams for each contract's functionality" />
  <Action name="Write deployment guide" description="Create a step-by-step deployment guide for mainnet" />
  <Action name="Create user documentation" description="Write detailed user documentation for equipment owners and renters" />
  <Action name="Add API documentation" description="Document the contract APIs for frontend integration" />
</Actions>


```
