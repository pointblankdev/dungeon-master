# DungeonMaster

The one DAO to rule them all. DungeonMaster is designed to be completely modular and flexible, leveraging Clarity to the fullest extent. The core tenets of DungeonMaster that make this possible are:

1. Proposals are smart contracts.
2. The core executes, the extensions give form.
3. Ownership control happens via sending context.

This is an early release. More information, design specifics, and unit tests coming soon.

## 1. Proposals are smart contracts

The way a conventional company operates is defined in its constitution. Changes are made by means of resolutions put forward by its members, the process of which is described by that same constitution. Translating this into a DAO was one of the aims when designing DungeonMaster. Proposals are therefore expressed as smart contracts. Clarity is a beautifully expressive language. Instead of verbose "Legalese", we can describe the operation, duties, and members using concise logical statements. Proposals implement a specific trait and may be executed by the DAO when certain conditions are met. It makes DungeonMaster extremely flexible and powerful.

## 2. The core executes, the extensions give form

DungeonMaster initially consists of just one core contract. Its sole purpose is to execute proposals and to keep a list of authorized extensions. There are no other features: no token, no voting, no functions. The DAO is given form by means of so-called extension contracts. Extensions are contracts that can be enabled or disabled by proposals and add specific features to the DAO. They are allowed to assume the "sending context" of the DAO and can thus enact change. Since different groups and organisations have different needs, extensions are rather varied. Some example functionality that can be added to DungeonMaster via an extension include:

- The issuance and management of a governance token.
- The ability to submit proposals.
- The ability to vote on proposals.
- The creation and management of a treasury.
- Salary payouts to specific members.
- And more...

Since extensions become part of the DAO, they have privileged access to everything else included in the DAO. The trick that allows for extension interoperability is a common authorization check. Privileged access is granted when the sending context is equal to that of the DAO or if the contract caller is an enabled DAO extension. It allows for extensions that depend on other extensions to be designed. They can be disabled and replaced at any time making DungeonMaster fully polymorphic.

## 3. Ownership control happens via sending context

DungeonMaster follows a single-address ownership model. The core contract is the de facto owner of external ownable contracts. (An ownable contract is to be understood as a contract that stores one privileged principal that may change internal state.) External contracts thus do not need to implement a complicated access model, as any proposal or extension may act upon it. Any ownable contract, even the ones that were deployed before DungeonMaster came into use, can be owned and managed by the DAO. Proposals are executed in the sending context of the DAO and extensions can request it via a callback procedure.

## Reference extensions

The DungeonMaster code base comes with a few reference extension contracts. These are designated by a code that starts with "DME" followed by an incrementing number of three digits.

### DME000: Governance Token

Implements a SIP010 governance token with locking capabilities. The DAO has full control over the minting, burning, transferring, and locking.

### DME001: Proposal Voting

Allows governance token holders to vote on proposals. (Note: _vote_, not _propose_.) One token equals one vote. Tokens used for voting are locked for the duration of the vote. They can then be reclaimed and used again.

### DME002: Proposal Submission

Allows governance token holders that own at least 1% of the supply to submit a proposal to be voted on via DME001. Proposals that are made this way are subject to a delay of at least 144 blocks (~1 day) to 1004 blocks (~7 days) and run for 1440 blocks (~10 days). All these parameters can be changed by a proposal.

### DME003: Emergency Proposals

Manages a list of emergency team members that have the ability to submit emergency proposals to DME001. Such proposals are not subject to a start delay and run for only 144 blocks (~1 day). This extension is subject to a sunset period after which it deactivates. The members, parameters, and sunset period can be changed by a proposal.

### DME004: Emergency Execute

Manages a list of executive team members that have the ability to signal for the immediate execution of a proposal. This extension is subject to a sunset period after which it deactivates. The members, parameters, and sunset period can be changed by a proposal.

### DME005: Dev Fund

An extension that functions as a development fund. It can hold a governance token balance and manages monthly developer payouts. The developers that receive a payout as well as the amounts can be changed by a proposal.

## Reference proposals

DungeonMaster also comes with some reference and example proposals. These are designated by a code that starts with "DMP" followed by an incrementing number of three digits. The numbers do not to coincide with extension numbering.

### DMP000: Bootstrap

A bootstrapping proposal that is meant to be executed when the DungeonMaster is first deployed. It initialises boot extensions, sets various parameters on them, and mints initial governance tokens.

### DMP001: Dev Fund

Enables the DME005 Dev Fund extension, mints an amount of tokens for it equal to 30% of the current supply, and awards an allowance to two principals.

### EDO002: Kill Emergency Execute

Immediately disables DME004 Emergency Execute if it passes.

### DME003: Whitelist Escrow NFT

A simple example on how DungeonMaster can manage third-party smart contracts.

## Testing

Unit tests coming soon, for now you can try it out manually in a `clarinet console` session. Execute the bootstrap proposal and have at it:

```clarity
(contract-call? .dungeon-master construct .dmp000-bootstrap)
```

To propose `dmp001-dev-fund`, run the following commands one by one:

```clarity
;; Submit the proposal via extension DME002, starting
;; the voting process at block-height + 144.
(contract-call? .dme002-proposal-submission propose .dmp001-dev-fund (+ block-height u144))

;; Advance the chain 144 blocks.
::advance_chain_tip 144

;; Vote YES with 100 tokens.
(contract-call? .dme001-proposal-voting vote u100 true .dmp001-dev-fund)

;; (Optional) take a look at the current proposal data.
(contract-call? .dme001-proposal-voting get-proposal-data .dmp001-dev-fund)

;; Advance the chain tip until after the proposal concludes.
::advance_chain_tip 1440

;; Conclude the proposal vote, thus executing it.
(contract-call? .dme001-proposal-voting conclude .dmp001-dev-fund)

;; Check that the dme005-dev-fund contract now
;; indeed holds governance tokens.
::get_assets_maps

;; Reclaim tokens used for voting.
(contract-call? .dme001-proposal-voting reclaim-votes .dmp001-dev-fund .dme000-governance-token)
```

## Error space

DungeonMaster reserves different uint ranges for the main components.

- `1000-1999`: DungeonMaster errors.
- `2000-2999`: Proposal errors.
- `3000-3999`: Extension errors.

# License

MIT license, all good as long as the copyright and permission notice are included. Although I ask developers that adopt DungeonMaster in one way or another to make the adapter open source. (The client code that interfaces with the DAO.)
