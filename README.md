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

<!-- TODO: By July 14th -->

## Describe anything that adds any special logic that makes approaching unique

<!-- TODO: By July 14th -->

## Identify any areas of specific concern in reviewing the code

<!-- TODO: By July 14th -->

## What is Lens v2 and Lens in general?

<!-- TODO: By July 14th -->

## Defintion of words and terms in Lens codebase

<!-- TODO: By July 14th -->

## High-level overview of Lens protocol

<!-- TODO: By July 14th -->

# Scope

| Contract                                                                                               | SLOC | Purpose                                                                                                                  | Libraries used                                                                                           |
| ------------------------------------------------------------------------------------------------------ | ---- | ------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- |
| [contracts/LensHub.sol](contracts/LensHub.sol)                                                         | 263  | Main contract. Entry point for all social operations (like publishing, follow, etc) and events. Profile NFT collection.  | ActionLib, LegacyCollectLib, FollowLib, MetaTxLib, ProfileLib, PublicationLib, StorageLib, ValidationLib |
| [contracts/FollowNFT.sol](contracts/FollowNFT.sol)                                                     | 357  | Follow NFT collection implementation, that is pointed by a Beacon proxy pattern by all Follow NFTs of all Lens Profiles. | @openzeppelin/\*, StorageLib, FollowTokenURILib                                                          |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/libraries/ActionLib.sol](contracts/libraries/ActionLib.sol)                                 | 52   | Library containing logic of Publication Actions.                                                                         | StorageLib, ValidationLib                                                                                |
| [contracts/libraries/FollowLib.sol](contracts/libraries/FollowLib.sol)                                 | 97   | Library containing logic of Follow operations.                                                                           | StorageLib, ValidationLib                                                                                |
| [contracts/libraries/GovernanceLib.sol](contracts/libraries/GovernanceLib.sol)                         | 70   | Library containing logic of Governance operations.                                                                       | StorageLib                                                                                               |
| [contracts/libraries/LegacyCollectLib.sol](contracts/libraries/LegacyCollectLib.sol)                   | 89   | Library containing logic of Legacy Lens V1 Collect operations.                                                           | StorageLib, ValidationLib, @openzeppelin/\*                                                              |
| [contracts/libraries/MetaTxLib.sol](contracts/libraries/MetaTxLib.sol)                                 | 365  | Library containing logic of everything related to Meta-Transactions.                                                     | StorageLib, Typehash                                                                                     |
| [contracts/libraries/MigrationLib.sol](contracts/libraries/MigrationLib.sol)                           | 109  | Library that will be used to migrate and adjust some state after Lens V1 to Lens V2 upgrade.                             | StorageLib                                                                                               |
| [contracts/libraries/ProfileLib.sol](contracts/libraries/ProfileLib.sol)                               | 199  | Library containing logic of Profile operations.                                                                          | StorageLib, ValidationLib                                                                                |
| [contracts/libraries/PublicationLib.sol](contracts/libraries/PublicationLib.sol)                       | 385  | Library for everything related to Publication (Posts/Comments/Quotes/Mirrors).                                           | StorageLib, ValidationLib                                                                                |
| [contracts/libraries/StorageLib.sol](contracts/libraries/StorageLib.sol)                               | 154  | Library handling the storage operations and helpers for getting and setting storage slots.                               | -                                                                                                        |
| [contracts/libraries/ValidationLib.sol](contracts/libraries/ValidationLib.sol)                         | 150  | Library containing logic of Validation.                                                                                  | StorageLib, ProfileLib, PublicationLib                                                                   |
| [contracts/libraries/constants/Errors.sol](contracts/libraries/constants/Errors.sol)                   | 40   | Library containing main custom error definitions.                                                                        | -                                                                                                        |
| [contracts/libraries/constants/Events.sol](contracts/libraries/constants/Events.sol)                   | 136  | Library containing main Events.                                                                                          | -                                                                                                        |
| [contracts/libraries/constants/Typehash.sol](contracts/libraries/constants/Typehash.sol)               | 18   | Library containing the Typehash constants for Meta-Transactions.                                                         | -                                                                                                        |
| [contracts/libraries/constants/Types.sol](contracts/libraries/constants/Types.sol)                     | 193  | Library containing custom types, enums and structs.                                                                      | -                                                                                                        |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/base/ERC2981CollectionRoyalties.sol](contracts/base/ERC2981CollectionRoyalties.sol)         | 42   | Base contract containing a generic implementation of ERC-2981.                                                           | -                                                                                                        |
| [contracts/base/HubRestricted.sol](contracts/base/HubRestricted.sol)                                   | 14   | Base contract containing logic to restrict functions to be only called by the LensHub.                                   | -                                                                                                        |
| [contracts/base/LensBaseERC721.sol](contracts/base/LensBaseERC721.sol)                                 | 220  | Base contract implementing ERC-721. Used by Lens Profiles (LensHub), Follow, and Collect NFTs.                           | MetaTxLib, @openzeppelin/\*                                                                              |
| [contracts/base/LensGovernable.sol](contracts/base/LensGovernable.sol)                                 | 51   | Base contract implementing governance operations. Part of the LensHub.                                                   | StorageLib, ValidationLib, GovernanceLib                                                                 |
| [contracts/base/LensHubEventHooks.sol](contracts/base/LensHubEventHooks.sol)                           | 21   | Base contract implementing logic to hook events into the LensHub. Part of the LensHub.                                   | StorageLib                                                                                               |
| [contracts/base/LensHubStorage.sol](contracts/base/LensHubStorage.sol)                                 | 24   | Base contract containing the last part of LensHub storage layout. Part of the LensHub.                                   | -                                                                                                        |
| [contracts/base/LensImplGetters.sol](contracts/base/LensImplGetters.sol)                               | 16   | Base contract implementing getters for Follow and Legacy Collect NFT implementations. Part of the LensHub.               | -                                                                                                        |
| [contracts/base/LensProfiles.sol](contracts/base/LensProfiles.sol)                                     | 118  | Base contract implementing Lens Profiles collection. Part of the LensHub.                                                | StorageLib, ValidationLib, ProfileLib, ProfileTokenURILib, @openzeppelin/\*                              |
| [contracts/base/upgradeability/FollowNFTProxy.sol](contracts/base/upgradeability/FollowNFTProxy.sol)   | 13   | Proxy implementing Beacon pattern to be used by each Follow NFT.                                                         | @openzeppelin/\*                                                                                         |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/misc/ImmutableOwnable.sol](contracts/misc/ImmutableOwnable.sol)                             | 23   | An Ownable contract to be inherited instead of OZ Ownable if the owner shall be immutable.                               | -                                                                                                        |
| [contracts/misc/LegacyCollectNFT.sol](contracts/misc/LegacyCollectNFT.sol)                             | 69   | Legacy Collect NFT for Lens V1 support.                                                                                  | @openzeppelin/\*                                                                                         |
| [contracts/misc/LensV2Migration.sol](contracts/misc/LensV2Migration.sol)                               | 38   | Lens V1 to V2 Migration functions.                                                                                       | MigrationLib                                                                                             |
| [contracts/misc/LensV2UpgradeContract.sol](contracts/misc/LensV2UpgradeContract.sol)                   | 111  | Contract handling the V1 to V2 upgrade procedure.                                                                        | -                                                                                                        |
| [contracts/misc/ModuleGlobals.sol](contracts/misc/ModuleGlobals.sol)                                   | 75   | Contract containing global Module-related values (fee, governance, etc).                                                 | -                                                                                                        |
| [contracts/misc/ProfileCreationProxy.sol](contracts/misc/ProfileCreationProxy.sol)                     | 35   | A trusted whitelisted Proxy for Profile creation.                                                                        | -                                                                                                        |
| [contracts/misc/access/ControllableByContract.sol](contracts/misc/access/ControllableByContract.sol)   | 24   | An additional Ownable layer that has an owner and a manager.                                                             | @openzeppelin/\*                                                                                         |
| [contracts/misc/access/Governance.sol](contracts/misc/access/Governance.sol)                           | 44   | A contract helper for safer Governance during upgrades, operated by Governance MultiSig.                                 | -                                                                                                        |
| [contracts/misc/access/ProxyAdmin.sol](contracts/misc/access/ProxyAdmin.sol)                           | 34   | A contract helper for safer upgrades, operated by ProxyAdmin Multisig.                                                   | @openzeppelin/\*                                                                                         |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/namespaces/LensHandles.sol](contracts/namespaces/LensHandles.sol)                           | 196  | Default namespace contract (".lens" Handles).                                                                            | HandleTokenURILib, @openzeppelin/\*                                                                      |
| [contracts/namespaces/TokenHandleRegistry.sol](contracts/namespaces/TokenHandleRegistry.sol)           | 120  | Registry that links Tokens (so far, Lens Profiles) with Handles.                                                         | @openzeppelin/\*                                                                                         |
| [contracts/namespaces/constants/Errors.sol](contracts/namespaces/constants/Errors.sol)                 | 22   | Namespaces Errors.                                                                                                       | -                                                                                                        |
| [contracts/namespaces/constants/Events.sol](contracts/namespaces/constants/Events.sol)                 | 15   | Namespaces Events.                                                                                                       | -                                                                                                        |
| [contracts/namespaces/constants/Types.sol](contracts/namespaces/constants/Types.sol)                   | 11   | Namespaces Types.                                                                                                        | -                                                                                                        |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ICollectModule.sol](contracts/interfaces/ICollectModule.sol)                     | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ICollectNFT.sol](contracts/interfaces/ICollectNFT.sol)                           | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IERC721Burnable.sol](contracts/interfaces/IERC721Burnable.sol)                   | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IERC721MetaTx.sol](contracts/interfaces/IERC721MetaTx.sol)                       | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IERC721Timestamped.sol](contracts/interfaces/IERC721Timestamped.sol)             | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IFollowModule.sol](contracts/interfaces/IFollowModule.sol)                       | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IFollowNFT.sol](contracts/interfaces/IFollowNFT.sol)                             | 10   |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILegacyCollectModule.sol](contracts/interfaces/ILegacyCollectModule.sol)         | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILegacyCollectNFT.sol](contracts/interfaces/ILegacyCollectNFT.sol)               | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILegacyFollowModule.sol](contracts/interfaces/ILegacyFollowModule.sol)           | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILegacyReferenceModule.sol](contracts/interfaces/ILegacyReferenceModule.sol)     | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensERC721.sol](contracts/interfaces/ILensERC721.sol)                           | 7    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensGovernable.sol](contracts/interfaces/ILensGovernable.sol)                   | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensHandles.sol](contracts/interfaces/ILensHandles.sol)                         | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensHub.sol](contracts/interfaces/ILensHub.sol)                                 | 7    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensHubEventHooks.sol](contracts/interfaces/ILensHubEventHooks.sol)             | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensHubInitializable.sol](contracts/interfaces/ILensHubInitializable.sol)       | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensImplGetters.sol](contracts/interfaces/ILensImplGetters.sol)                 | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensProfiles.sol](contracts/interfaces/ILensProfiles.sol)                       | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensProtocol.sol](contracts/interfaces/ILensProtocol.sol)                       | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IModuleGlobals.sol](contracts/interfaces/IModuleGlobals.sol)                     | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IPublicationActionModule.sol](contracts/interfaces/IPublicationActionModule.sol) | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IReferenceModule.sol](contracts/interfaces/IReferenceModule.sol)                 | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ITokenHandleRegistry.sol](contracts/interfaces/ITokenHandleRegistry.sol)         | 3    |                                                                                                                          |                                                                                                          |

## Out of scope

Everything inside [`contracts/modules`](contracts/modules/), [`contracts/libraries/token-uris`](contracts/libraries/token-uris/) directories, and [`LensHubInitializable`](contracts/misc/LensHubInitializable.sol), [`VersionedInitializable`](contracts/base/upgradeability/VersionedInitializable.sol), [`UIDataProvider`](contracts/misc/UIDataProvider.sol) contracts.

| Contract                                                                                                                                 |
| ---------------------------------------------------------------------------------------------------------------------------------------- |
| [contracts/modules/ActionRestricted.sol](contracts/modules/ActionRestricted.sol)                                                         |
| [contracts/modules/FeeModuleBase.sol](contracts/modules/FeeModuleBase.sol)                                                               |
| [contracts/modules/libraries/FollowValidationLib.sol](contracts/modules/libraries/FollowValidationLib.sol)                               |
| [contracts/modules/constants/Errors.sol](contracts/modules/constants/Errors.sol)                                                         |
| [contracts/modules/act/collect/base/BaseFeeCollectModule.sol](contracts/modules/act/collect/base/BaseFeeCollectModule.sol)               |
| [contracts/modules/act/collect/CollectNFT.sol](contracts/modules/act/collect/CollectNFT.sol)                                             |
| [contracts/modules/act/collect/CollectPublicationAction.sol](contracts/modules/act/collect/CollectPublicationAction.sol)                 |
| [contracts/modules/act/collect/MultirecipientFeeCollectModule.sol](contracts/modules/act/collect/MultirecipientFeeCollectModule.sol)     |
| [contracts/modules/act/collect/SimpleFeeCollectModule.sol](contracts/modules/act/collect/SimpleFeeCollectModule.sol)                     |
| [contracts/modules/act/seadrop/LensSeaDropCollection.sol](contracts/modules/act/seadrop/LensSeaDropCollection.sol)                       |
| [contracts/modules/act/seadrop/SeaDropMintPublicationAction.sol](contracts/modules/act/seadrop/SeaDropMintPublicationAction.sol)         |
| [contracts/modules/follow/FeeFollowModule.sol](contracts/modules/follow/FeeFollowModule.sol)                                             |
| [contracts/modules/follow/RevertFollowModule.sol](contracts/modules/follow/RevertFollowModule.sol)                                       |
| [contracts/modules/reference/DegreesOfSeparationReferenceModule.sol](contracts/modules/reference/DegreesOfSeparationReferenceModule.sol) |
| [contracts/modules/reference/FollowerOnlyReferenceModule.sol](contracts/modules/reference/FollowerOnlyReferenceModule.sol)               |
| [contracts/modules/reference/TokenGatedReferenceModule.sol](contracts/modules/reference/TokenGatedReferenceModule.sol)                   |
| [contracts/modules/interfaces/IBaseFeeCollectModule.sol](contracts/modules/interfaces/IBaseFeeCollectModule.sol)                         |
| [contracts/modules/interfaces/IWMATIC.sol](contracts/modules/interfaces/IWMATIC.sol)                                                     |
|                                                                                                                                          |
| [contracts/libraries/token-uris/FollowTokenURILib.sol](contracts/libraries/token-uris/FollowTokenURILib.sol)                             |
| [contracts/libraries/token-uris/HandleTokenURILib.sol](contracts/libraries/token-uris/HandleTokenURILib.sol)                             |
| [contracts/libraries/token-uris/ProfileTokenURILib.sol](contracts/libraries/token-uris/ProfileTokenURILib.sol)                           |
| [contracts/libraries/token-uris/TokenURIMainFontLib.sol](contracts/libraries/token-uris/TokenURIMainFontLib.sol)                         |
| [contracts/libraries/token-uris/TokenURISecondaryFontLib.sol](contracts/libraries/token-uris/TokenURISecondaryFontLib.sol)               |
|                                                                                                                                          |
| [contracts/misc/LensHubInitializable.sol](contracts/misc/LensHubInitializable.sol)                                                       |
|                                                                                                                                          |
| [contracts/base/upgradeability/VersionedInitializable.sol](contracts/base/upgradeability/VersionedInitializable.sol)                     |
|                                                                                                                                          |
| [contracts/misc/UIDataProvider.sol](contracts/misc/UIDataProvider.sol)                                                                   |

# Additional Context

N/A (optional)

_Sponsor, please confirm/edit the information below._

## Scoping Details

```
- If you have a public code repo, please share it here: [TBA](#TBA)
- How many contracts are in scope?: 63
- Total SLoC for these contracts?: 4108
- How many external imports are there?: 0
- How many separate interfaces and struct definitions are there for the contracts within scope?: 32 Files = Interface files (24) + Error definition files (3) + Struct definition files (2) + Event definition files (2) + Constant definition files (1)
- Does most of your code generally use composition or inheritance?:  Inheritance
- How many external calls?: 0
- What is the overall line coverage percentage provided by your tests?: 84%
- Is this an upgrade of an existing system? Yes. We do in-place upgrades using different proxy patterns depending on the contract. LensHub (most core contract) is upgraded (transparent proxy), Follow NFT (beacon proxy).
- Does it use a timelock function?: Yes
- Is it an NFT?: Yes
- Does the token conform to the ERC20 standard?: N/A (its ERC721)
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?: Yes
- Please describe required context: Upgrade from Lens V1 to V2 will be done in-place using a transparent proxy pattern, knowdlege about Lens V1 is just required in the context of the secuiry
- Does it use an oracle?: No
- Are there any novel or unique curve logic or mathematical models?: No
- Is it a fork of a popular project?: No
- Does it use a side-chain?: Uses EVM-compatible chain (Polygon).
```

# Setup

1. Clone the repository (you must have SSH enabled in GitHub, otherwise git submodules will fail to be cloned):

```bash
git clone git@github.com:code-423n4/2023-07-lens.git
```

And initialize submodules:

```bash
git submodule update --init --recursive
```

2. Install Foundry by following the instructions from [their repository](https://book.getfoundry.sh/getting-started/installation).
   - curl -L https://foundry.paradigm.xyz | bash
   - foundryup

## Build

You can compile the project using:

```bash
forge build
```

You will notice a warning about [LensHubInitializable](contracts/misc/LensHubInitializable.sol) exceeding code size (anyways, this file is out of the scope for this audit). To avoid the warning, compile Via IR (it will take more time):

```bash
forge build --via-ir
```

## Test

You can run unit tests using:

```bash
forge test
```

## Coverage

You can run coverage using:

```bash
forge coverage
```

# Docs

You can go to our [docs](https://docs.lens.xyz/docs) (still V1) to learn more about Lens Protocol.
