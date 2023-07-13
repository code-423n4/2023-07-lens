# Lens Protocol V2 audit details

We want to proposal this structure for the prize pool (please remove this line if you are ok with it if not chat in discord)

- Total Prize Pool: $85,500 USDC
  - HM awards: $75,000 USDC
  - Analysis awards: $0 USDC
  - QA awards: $1,000 USDC
  - Bot Race awards: $0 USDC
  - Gas awards: $0 USDC
  - Judge awards: $9,000 USDC
  - Lookout awards: $0 USDC - manage by Lens
  - Scout awards: $500 USDC
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-07-lens-protocol-v2/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts July 17, 2023 20:00 UTC
- Ends July 31, 2023 20:00 UTC

**Please note that for this contest, gas optimizations are out of scope. The Lens Protocol team will not be awarding prize funds for gas-specific submissions.**

## Automated Findings / Publicly Known Issues

Below is a list of statements we wish to clear up, these are not bugs it as design but flagging so nobody raises them:

- You can link a `LensHandle` to a `Profile` and on transfer of that handle or profile the link will still be valid. The new owner will need to unlink for it to be removed.
- Referrals can be duplicated its down to the clients our referral is flexible and can be used in many ways.
- You can mirror and collect through your own mirror to earn referrals.

Automated findings output for the audit can be found [here](add link to report) within 24 hours of audit opening.

_Note for C4 wardens: Anything included in the automated findings output is considered a publicly known issue and is ineligible for awards._

[ ⭐️ SPONSORS ADD INFO HERE ]

# Overview

_Please provide some context about the code being audited, and identify any areas of specific concern in reviewing the code. (This is a good place to link to your docs, if you have them.)_

DOING TOMORROW

## Describe anything that adds any special logic that makes approaching unique

DOING TOMORROW

## Identify any areas of specific concern in reviewing the code

DOING TOMORROW

## What is Lens v2 and Lens in general?

DOING TOMORROW

## Defintion of words and terms in Lens codebase

DOING TOMORROW

## High-level overview of Lens protocol

DOING TOMORROW

# Scope

| Contract                                                                                                                   | SLOC | Purpose                                        | Libraries used |
| -------------------------------------------------------------------------------------------------------------------------- | ---- | ---------------------------------------------- | -------------- |
| [contracts/misc/LensV2Migration.sol](contracts/misc/LensV2Migration.sol)                                                   |      | This is the migration script to update follows | -              |
| [contracts/misc/LegacyCollectNFT.sol](contracts/misc/LegacyCollectNFT.sol)                                                 |      |                                                | -              |
| [contracts/interfaces/IERC721MetaTx.sol](contracts/interfaces/IERC721MetaTx.sol)                                           |      |                                                | -              |
| [contracts/interfaces/IFollowNFT.sol](contracts/interfaces/IFollowNFT.sol)                                                 |      |                                                | -              |
| [contracts/base/HubRestricted.sol](contracts/base/HubRestricted.sol)                                                       |      |                                                | -              |
| [contracts/interfaces/ILensGovernable.sol](contracts/interfaces/ILensGovernable.sol)                                       |      |                                                | -              |
| [contracts/interfaces/ILegacyCollectNFT.sol](contracts/interfaces/ILegacyCollectNFT.sol)                                   |      |                                                | -              |
| [contracts/base/upgradeability/VersionedInitializable.sol](contracts/base/upgradeability/VersionedInitializable.sol)       |      |                                                | -              |
| [contracts/base/upgradeability/FollowNFTProxy.sol](contracts/base/upgradeability/FollowNFTProxy.sol)                       |      |                                                | -              |
| [contracts/interfaces/ICollectModule.sol](contracts/interfaces/ICollectModule.sol)                                         |      |                                                | -              |
| [contracts/interfaces/ILensHubEventHooks.sol](contracts/interfaces/ILensHubEventHooks.sol)                                 |      |                                                | -              |
| [contracts/interfaces/IReferenceModule.sol](contracts/interfaces/IReferenceModule.sol)                                     |      |                                                | -              |
| [contracts/interfaces/ILensProtocol.sol](contracts/interfaces/ILensProtocol.sol)                                           |      |                                                | -              |
| [contracts/interfaces/IERC721Burnable.sol](contracts/interfaces/IERC721Burnable.sol)                                       |      |                                                | -              |
| [contracts/interfaces/ILegacyReferenceModule.sol](contracts/interfaces/ILegacyReferenceModule.sol)                         |      |                                                | -              |
| [contracts/interfaces/ILegacyFollowModule.sol](contracts/interfaces/ILegacyFollowModule.sol)                               |      |                                                | -              |
| [contracts/interfaces/ITokenHandleRegistry.sol](contracts/interfaces/ITokenHandleRegistry.sol)                             |      |                                                | -              |
| [contracts/base/LensGovernable.sol](contracts/base/LensGovernable.sol)                                                     |      |                                                | -              |
| [contracts/base/LensImplGetters.sol](contracts/base/LensImplGetters.sol)                                                   |      |                                                | -              |
| [contracts/base/LensHubEventHooks.sol](contracts/base/LensHubEventHooks.sol)                                               |      |                                                | -              |
| [contracts/base/LensHubStorage.sol](contracts/base/LensHubStorage.sol)                                                     |      |                                                | -              |
| [contracts/base/LensBaseERC721.sol](contracts/base/LensBaseERC721.sol)                                                     |      |                                                | -              |
| [contracts/interfaces/ILensHandles.sol](contracts/interfaces/ILensHandles.sol)                                             |      |                                                | -              |
| [contracts/interfaces/IERC721Timestamped.sol](contracts/interfaces/IERC721Timestamped.sol)                                 |      |                                                | -              |
| [contracts/interfaces/ILensImplGetters.sol](contracts/interfaces/ILensImplGetters.sol)                                     |      |                                                | -              |
| [contracts/interfaces/ILensHubInitializable.sol](contracts/interfaces/ILensHubInitializable.sol)                           |      |                                                | -              |
| [contracts/interfaces/ILensERC721.sol](contracts/interfaces/ILensERC721.sol)                                               |      |                                                | -              |
| [contracts/interfaces/ILensHub.sol](contracts/interfaces/ILensHub.sol)                                                     |      |                                                | -              |
| [contracts/misc/UIDataProvider.sol](contracts/misc/UIDataProvider.sol)                                                     |      |                                                | -              |
| [contracts/interfaces/ICollectNFT.sol](contracts/interfaces/ICollectNFT.sol)                                               |      |                                                | -              |
| [contracts/misc/access/ControllableByContract.sol](contracts/misc/access/ControllableByContract.sol)                       |      |                                                | -              |
| [contracts/base/ERC2981CollectionRoyalties.sol](contracts/base/ERC2981CollectionRoyalties.sol)                             |      |                                                | -              |
| [contracts/interfaces/IFollowModule.sol](contracts/interfaces/IFollowModule.sol)                                           |      |                                                | -              |
| [contracts/misc/access/Governance.sol](contracts/misc/access/Governance.sol)                                               |      |                                                | -              |
| [contracts/base/LensProfiles.sol](contracts/base/LensProfiles.sol)                                                         |      |                                                | -              |
| [contracts/misc/access/ProxyAdmin.sol](contracts/misc/access/ProxyAdmin.sol)                                               |      |                                                | -              |
| [contracts/interfaces/ILegacyCollectModule.sol](contracts/interfaces/ILegacyCollectModule.sol)                             |      |                                                | -              |
| [contracts/interfaces/IModuleGlobals.sol](contracts/interfaces/IModuleGlobals.sol)                                         |      |                                                | -              |
| [contracts/misc/LensV2UpgradeContract.sol](contracts/misc/LensV2UpgradeContract.sol)                                       |      |                                                | -              |
| [contracts/misc/ImmutableOwnable.sol](contracts/misc/ImmutableOwnable.sol)                                                 |      |                                                | -              |
| [contracts/misc/ProfileCreationProxy.sol](contracts/misc/ProfileCreationProxy.sol)                                         |      |                                                | -              |
| [contracts/misc/LensHubInitializable.sol](contracts/misc/LensHubInitializable.sol)                                         |      |                                                | -              |
| [contracts/misc/ModuleGlobals.sol](contracts/misc/ModuleGlobals.sol)                                                       |      |                                                | -              |
| [contracts/FollowNFT.sol](contracts/FollowNFT.sol)                                                                         |      |                                                | -              |
| [contracts/CollectNFT.sol](contracts/CollectNFT.sol)                                                                       |      |                                                | -              |
| [contracts/LensHub.sol](contracts/LensHub.sol)                                                                             |      |                                                | -              |
| [contracts/namespaces/TokenHandleRegistry.sol](contracts/namespaces/TokenHandleRegistry.sol)                               |      |                                                | -              |
| [contracts/libraries/ActionLib.sol](contracts/libraries/ActionLib.sol)                                                     |      |                                                | -              |
| [contracts/libraries/PublicationLib.sol](contracts/libraries/PublicationLib.sol)                                           |      |                                                | -              |
| [contracts/libraries/FollowLib.sol](contracts/libraries/FollowLib.sol)                                                     |      |                                                | -              |
| [contracts/libraries/StorageLib.sol](contracts/libraries/StorageLib.sol)                                                   |      |                                                | -              |
| [contracts/libraries/ProfileLib.sol](contracts/libraries/ProfileLib.sol)                                                   |      |                                                | -              |
| [contracts/libraries/GovernanceLib.sol](contracts/libraries/GovernanceLib.sol)                                             |      |                                                | -              |
| [contracts/libraries/MetaTxLib.sol](contracts/libraries/MetaTxLib.sol)                                                     |      |                                                | -              |
| [contracts/libraries/LegacyCollectLib.sol](contracts/libraries/LegacyCollectLib.sol)                                       |      |                                                | -              |
| [contracts/libraries/ValidationLib.sol](contracts/libraries/ValidationLib.sol)                                             |      |                                                | -              |
| [contracts/namespaces/constants/Types.sol](contracts/namespaces/constants/Types.sol)                                       |      |                                                | -              |
| [contracts/namespaces/constants/Events.sol](contracts/namespaces/constants/Events.sol)                                     |      |                                                | -              |
| [contracts/namespaces/constants/Errors.sol](contracts/namespaces/constants/Errors.sol)                                     |      |                                                | -              |
| [contracts/libraries/constants/Types.sol](contracts/libraries/constants/Types.sol)                                         |      |                                                | -              |
| [contracts/libraries/constants/Events.sol](contracts/libraries/constants/Events.sol)                                       |      |                                                | -              |
| [contracts/libraries/constants/Typehash.sol](contracts/libraries/constants/Typehash.sol)                                   |      |                                                | -              |
| [contracts/libraries/constants/Errors.sol](contracts/libraries/constants/Errors.sol)                                       |      |                                                | -              |
| [contracts/libraries/token-uris/TokenURIMainFontLib.sol](contracts/libraries/token-uris/TokenURIMainFontLib.sol)           |      |                                                | -              |
| [contracts/libraries/token-uris/ProfileTokenURILib.sol](contracts/libraries/token-uris/ProfileTokenURILib.sol)             |      |                                                | -              |
| [contracts/libraries/token-uris/ProfileTokenURILib.sol](contracts/libraries/token-uris/ProfileTokenURILib.sol)             |      |                                                | -              |
| [contracts/libraries/token-uris/FollowTokenURILib.sol](contracts/libraries/token-uris/FollowTokenURILib.sol)               |      |                                                | -              |
| [contracts/libraries/token-uris/TokenURISecondaryFontLib.sol](contracts/libraries/token-uris/TokenURISecondaryFontLib.sol) |      |                                                | -              |

## Out of scope

| Contract                                    |
| ------------------------------------------- |
| [contracts/modules](code/contracts/modules) |

# Additional Context

N/A (optional)

_Sponsor, please confirm/edit the information below._

## Scoping Details

```
- If you have a public code repo, please share it here: https://github.com/lens-protocol/core
- How many contracts are in scope?: 70
- Total SLoC for these contracts?: 4333
- How many external imports are there?: 0
- How many separate interfaces and struct definitions are there for the contracts within scope?: 33 Files = Interface files (25) + Error definition files (3) + Struct definition files (2) + Event definition files (2) + Constant definition files (1)
- Does most of your code generally use composition or inheritance?:  Inheritance
- How many external calls?: 0
- What is the overall line coverage percentage provided by your tests?: 84%
- Is this an upgrade of an existing system? Yes. We do in-place upgrades using different proxy patterns depending on the contract. LensHub (most core contract) is upgraded (transparent proxy), Follow NFT (beacon proxy).
- Does it use a timelock function?: Yes
- Is it an NFT?: Yes
- Does the token conform to the ERC20 standard?: Yes
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?: Yes.
- Please describe required context:  Most of the system you do not need to know about Lens v1 but its important to note this is upgrading lens v1 which has been live for a year, this includes migrating state. So any focus on upgrade and migration process will need some knowledge of lens v1.
- Does it use an oracle?:  No
- Are there any novel or unique curve logic or mathematical models?: No
- Is it a fork of a popular project?:   No
- Does it use a side-chain?: Yes. It is EVM-compatible.

```

# Tests

You must clone the repo using SSH:

```bash
git clone git@github.com:code-423n4/2023-07-lens.git
```

## Setup

1. Install Foundry by following the instructions from [their repository](https://book.getfoundry.sh/getting-started/installation).
   - curl -L https://foundry.paradigm.xyz | bash
   - foundryup
   - done
2. open terminal in `code` where the contracts are located
3. Install the dependencies by running : `npm i && forge install`

You can now build it using:

```bash
npm run build
```

## Testing

You can run unit tests using

```bash
npm run test
```

## Coverage

You can run coverage using

```bash
npm run coverage
```

You can go to our [docs](https://docs.lens.xyz/docs) to learn more about Lens Protocol.
