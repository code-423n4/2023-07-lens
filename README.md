# Lens Protocol V2 audit details

We want to proposal this structure for the prize pool (please remove this line if you are ok with it if not chat in discord)

- Total Prize Pool: $85,500 USDC
  - HM awards: $63,000 USDC
  - Analysis awards: $0 USDC
  - QA awards: $1,750 USDC
  - Bot Race awards: $5,250 USDC
  - Gas awards: $0 USDC
  - Judge awards: $9,000 USDC
  - Lookout awards: $6,000 USDC
  - Scout awards: $500 USDC
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-07-lens-protocol-v2/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts July 17, 2023 20:00 UTC
- Ends July 31, 2023 20:00 UTC

**Please note that for this contest, gas optimizations AND Analysis Reports are both out of scope. The Lens Protocol team will not be awarding prize funds for gas-specific submissions.**

## Automated Findings / Publicly Known Issues / Clarifications & Assumptions

Automated findings output for the audit can be found [here](add link to report) within 24 hours of audit opening.

_Note for C4 wardens: Anything included in the automated findings output is considered a publicly known issue and is ineligible for awards._

Below is a list of statements we wish to clear up, these are not bugs it as design but flagging so nobody raises them:

- You can link a `LensHandle` to a `Profile` and on transfer of that handle or profile the link will still be valid. The new owner will need to unlink for it to be removed.
- Referral system:
  - Duplicated referrals are allowed.
  - A user that is about to act on a publication can always first interact (mirror, quote, comment) and then act passing its own publication as referral (wether he is using the same profile or an alt profile he also owns). This not only applies to act, but also to mirror, quote and comment.
  - A user can pass itself as unverified referral for any action trying to get a benefit. However, take into account that specific module implementations can reject unverified referrals.
- All contracts' critical roles (like the owner address in the Ownable pattern) are expected to be secure multisigs, not EOAs.
- There are five TODOs inside the `contracts/` directory: LensHandles ([#1](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/namespaces/LensHandles.sol#L167), [#2](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/namespaces/LensHandles.sol#L176)), Types ([#3](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/constants/Types.sol#L49), [#4](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/constants/Types.sol#L345)), LensSeaDropCollection ([#5](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/act/seadrop/LensSeaDropCollection.sol#L22) this file is out of the audit scope). These TODOs will be resolved later.
- Breaking changes from V1 to V2:
  - Follow NFT delegation power feature removed. It might be added in the future, compatible with DAO Governors.
  - Lens V1 Collect and Reference modules that were querying the Follow state will fail after V2 upgrade, given that `isFollowing(uint256 profileId, address follower, uint256 followNFTTokenId)` function is not part of the Follow module interface anymore.
  - Function interfaces have changed for most of them.
  - Cannot comment on mirrors anymore.
  - Indexers will need to adapt to new events.
- You can still act and legacy collect publications of burnt profiles. Unless the modules contain logic that requires profile existence.
- Publications from burnt profiles are allowed as verified referrals, unless the modules contain logic that requires referral profiles existence. We might change this to not be allowed.
- Whitelisted profile/handle creators are expected to be trusted (i.e. [Lens V1 - C4 | M-03](https://code4rena.com/reports/2022-02-aave-lens#m-03-profile-creation-can-be-frontrun), [Lens V1 - C4 | M-04](https://code4rena.com/reports/2022-02-aave-lens#m-04-name-squatting), [Lens V1 - C4 | M-12](https://code4rena.com/reports/2022-02-aave-lens#m-12-ineffective-whitelist) are "by design"). Thus, any malicious behaviour is not contemplated as a bug. For example, front-running between each-other, handle squatting, creation/minting of any amount of desired profiles, etc.
- Governance and Proxy Admins are trusted. Issues that can come from Governance malicious executions or Proxy Admins malicious upgrades will not be taken into account (for example, a LensHub upgrade that will perform malicious actions on users who gave approvals to it [Lens V1 - C4 | M-06](https://code4rena.com/reports/2022-02-aave-lens#m-06-imprecise-management-of-users-allowance-allows-the-admin-of-the-upgradeable-proxy-contract-to-rug-users), or Governance whitelisting a malicious/erroneous module on purpose [Lens V1 - C4 | M-10](https://code4rena.com/reports/2022-02-aave-lens#m-10-zero-collection-module-can-be-whitelisted-and-set-to-a-post-which-will-then-revert-all-collects-and-mirrors-with-publicationdoesnotexist)). This is part of the risk model assumptions and its management will become more decentralized over time.

# Overview

[Lens V1 docs](https://docs.lens.xyz/docs) to learn more about the Lens Protocol.

Although these docs are for Lens V1, they are still useful to understand the Lens Protocol in general. To see the changes done in Lens V2 - look at the next section.

Upgrade from Lens V1 to V2 will be done in-place using a transparent proxy pattern, knowdlege about Lens V1 is required in the context of upgrade and migration success, including unexpected breaking changes.

## What is Lens v2 and Lens in general?

**Lens Protocol** is a social graph built on-chain, designed to empower creators to own their identities, and links between themselves and their community, forming a fully composable, user-owned social graph. The protocol is built from the ground up with modularity in mind, allowing new features and fixes to be added while ensuring immutable user-owned content and social relationships.

**Lens V2** is the first big upgrade of the Lens Protocol, it aims to improve the protocol design based on all the learnings after its first year, as well as introduce some new interesting features:

- All the social operations are now Profile-based, instead of address-based, meaning that they require to be performed by a Profile
  - You can no longer follow with an address. All follows are required to be done by a Profile
  - Legacy Collect action, and new Publication Actions are now executed by Profiles (common proxy profiles might be used to support address-based collects if wanted)
- Follow NFTs are optimized for the best UX by not being ERC-721 by default. They now have two states:
  - Unwrapped (default, non-ERC-721 state): Tied to the follower Profile, meaning they move with the follower Profile when it is transferred to a different address
  - Wrapped (opt-in, ERC-721 state): Follow NFTs natively support being wrapped into ERC-721 tokens, to get the best out of composability with other protocols
  - Ownership/Custody of the Follow NFT is no longer related to the following state, the follower profile is set as a field inside the Follow NFT. This enables a lot of interesting use cases and improvements.
- Addition of the Advanced Referral System (more details below)
- Addition of Publication Action Modules
- Addition of Delegated Executors (more details below)
- Lens Handles are now ERC721s and managed by a separate contract
- TokenGuardian pattern introduced on both Profiles and Handles to supply additional protection of social assets
- All code was reworked and rewritten from scratch
- Many more fixes and improvements

Many of the things mentioned above introduce breaking changes in the protocol.

## Special logic found in this contest

- The ControllableByContract pattern that we introduced to allow preparing upgrades on beforehand, automating them through contracts and testing them in forks, while also avoiding the risk of transferring ownership of Governance and ProxyAdmin.

- The Follow NFT design.

## Areas of specific concern

Please give special attention to Upgrade and Migration procedures, and anything that can get broken after the V2 upgrade (like the breaking changes mentioned in the "Publicly Known Issues" section). For that you might need to refer to the Lens V1 code.

The ControllableByContract pattern introduced, as it will be used by Governance and ProxyAdmin contracts, the latter being the most critical piece of Lens Protocol's security.

## Definition of words and terms in Lens codebase

- **Delegated Executor:** An address allowed to manage a the social operations of a profile (following, posting, commenting, mirroring, acting). This was specially motivated by the use case of holding the profile in a secure wallet (e.g. hardware wallet or multisig), and delegating execution to another wallet (e.g. a hot wallet in your phone).
- **Transaction Executor:** The msg.sender in a regular transaction, the signer in a meta-transaction. Take into account that this can be either the owner of a profile, as well as one of its delegated executors.
- **Publication:** Either a Post, Comment, Quote or Mirror. Do not confuse the generic term "Publication" with "Post", which is an specific type of Publication.
- **Mirror:** An amplification of a Post, Comment or Quote. For example, on Twitter it would be a "Retweet", on Instagram a "Repost", etc.
- **Legacy Collect:** The collect operation from Lens V1. It says "Legacy" as in Lens V2 it was re-implemented as a Publication Action.
- **Token Guardian:** Protection mechanism for the tokens held by an address, which restricts transfers and approvals when enabled. See [LIP-4](https://github.com/lens-protocol/LIPs/blob/main/LIPs/lip-4.md) for more.
- **Pure-V2 Tree:** A tree of interactions formed by all Lens V2 publications. Basically, a set of Lens V2 comments, quotes and/or mirrors that converge on a Lens V2 post.
- **Non-Pure V2 Tree or V1-Contaminated Tree:** A tree of interactions that has a V1 post at the root, and some mix of V1/V2 comments/quotes/mirrors.
- **Target:** A publication that an operation is performed on (publication that is being acted on, or a publication that is being commented/quoted/mirrored).
- **Referrer or Referral:** A publication that allowed the discovery of the TARGET which led to an operation on TARGET (e.g. a mirror that led to a collect of the original post, etc).
- **Unverified referrals:** Referrals passed just as profiles (no publication specified), which are not verified if they're connected to the Target publication by the referral system.

## Lens V2 Advanced Referral system

In V2 we introduced a complex Referral System, which supports verified and non-verified referrals for any module action that is performed on a publication (Reference Modules, Action Modules).
Referral system allows to reward users that helped to discover a publication, and also to reward original posters for any activity that happens below, and reward the applications and UIs that are used to interact with Lens Protocol and help the discovery of content.

Lens V2 Referral System supports:

- Passing multiple referrals.
- Passing any publication as a referral as long as it originates from the same post (any from a multi-branch tree of comments/quotes/mirrors of a single post).
- Upwards and downwards referrals (a post can be a referral for it’s comment/quote, and vice-versa), allowing to award original posters for any activity that happens below.
- Non-verified referrals: you can pass a profile as a referral (good for mentions, or front-ends, anything that allowed a person to discover something).

### Referral System Rules

As we upgrade from Lens V1 to Lens V2, we need to take into account that not all publications would support the new Referral system (Lens V1 publications are supported only partly):

- **Rule #1 - About Pure-V2 Trees:** all the new complex interactions and referrers that were introduced in V2 work as expected.
  - Mirrors cannot be a target, but any other publication (post, comment, quote) can.
  - The same publication cannot be simultaneously a target and a referrer. Basically, a publication cannot be referrer of itself.
  - Any publication can be referrer of another publication if exists a path (conformed by quotes, comments and/or mirrors) from each of them to the same root post.
  - The path can go upwards and downwards (later comments can be referrer of the earlier ones, and vice versa).
- **Rule #2 - About Non-Pure Trees:** referrers only work for “direct/pointed” publications:
  - Only 1 level of depth between target and referrer is allowed (as root publication is not forwarded on non-pure v2 trees).
  - Only downwards publication can be a referral (e.g. in a post←comment situation, only the comment can refer a post, but not the other way around).
  - V2 pubs support referrals for act and reference modules. Basically, referrals are supported when acting, mirroring, quoting and commenting.
  - V1 publications did not support referrals in the reference modules, so any comment/mirror interaction on a V1 pub should not support a referral.
  - During Legacy Collect of V1 publications only a single mirror (either V1 or V2 mirror) directly pointing to the target is supported as a referrer.
- **Rule #3 - Non-Verified Referrals (profile referrals):** should work in all V1 and V2 publications that support referrals

**_Why there is a difference between Pure and Non-Pure trees?_**

In V2 we introduced a “ROOT” - which is a post, and all the comments/quotes have this root copied recursively. So all the publication tree can always refer and check if two publications belong to the same ROOT - originating from the same post.

But in V1 we didn’t have a concept of a “ROOT”, so the existing V1 trees don’t have it.

## High-level overview of Lens protocol

### Lens V2 Publication Layer Architecture

![LensV2 Publication Layer Architecture](https://github.com/code-423n4/2023-07-lens/blob/main/diagrams/pub-layer-architecture.png)

### Lens V2 Social Layer Architecture

![LensV2 Social Layer Architecture](https://github.com/code-423n4/2023-07-lens/blob/main/diagrams/social-layer-architecture.png)

### Lens V1->V2 Migration Scheme

![Lens V1-V2 Migration Scheme](https://github.com/code-423n4/2023-07-lens/blob/main/diagrams/migration-scheme.png)

### Lens V1->V2 Upgrade Scheme

![Lens V1-V2 Upgrade Scheme](https://github.com/code-423n4/2023-07-lens/blob/main/diagrams/upgrade-scheme.png)

### Advanced Referral System Example

![Advanced Referral System](https://github.com/code-423n4/2023-07-lens/blob/main/diagrams/referral-system.png)

# Scope

| Contract                                                                                               | SLOC | Purpose                                                                                                                  | Libraries used                                                                                           |
| ------------------------------------------------------------------------------------------------------ | ---- | ------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- |
| [contracts/LensHub.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/LensHub.sol)                                                         | 263  | Main contract. Entry point for all social operations (like publishing, follow, etc) and events. Profile NFT collection.  | ActionLib, LegacyCollectLib, FollowLib, MetaTxLib, ProfileLib, PublicationLib, StorageLib, ValidationLib |
| [contracts/FollowNFT.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/FollowNFT.sol)                                                     | 357  | Follow NFT collection implementation, that is pointed by a Beacon proxy pattern by all Follow NFTs of all Lens Profiles. | @openzeppelin/\*, StorageLib, FollowTokenURILib                                                          |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/libraries/ActionLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/ActionLib.sol)                                 | 52   | Library containing logic of Publication Actions.                                                                         | StorageLib, ValidationLib                                                                                |
| [contracts/libraries/FollowLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/FollowLib.sol)                                 | 97   | Library containing logic of Follow operations.                                                                           | StorageLib, ValidationLib                                                                                |
| [contracts/libraries/GovernanceLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/GovernanceLib.sol)                         | 70   | Library containing logic of Governance operations.                                                                       | StorageLib                                                                                               |
| [contracts/libraries/LegacyCollectLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/LegacyCollectLib.sol)                   | 89   | Library containing logic of Legacy Lens V1 Collect operations.                                                           | StorageLib, ValidationLib, @openzeppelin/\*                                                              |
| [contracts/libraries/MetaTxLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/MetaTxLib.sol)                                 | 365  | Library containing logic of everything related to Meta-Transactions.                                                     | StorageLib, Typehash                                                                                     |
| [contracts/libraries/MigrationLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/MigrationLib.sol)                           | 109  | Library that will be used to migrate and adjust some state after Lens V1 to Lens V2 upgrade.                             | StorageLib                                                                                               |
| [contracts/libraries/ProfileLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/ProfileLib.sol)                               | 199  | Library containing logic of Profile operations.                                                                          | StorageLib, ValidationLib                                                                                |
| [contracts/libraries/PublicationLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/PublicationLib.sol)                       | 385  | Library for everything related to Publication (Posts/Comments/Quotes/Mirrors).                                           | StorageLib, ValidationLib                                                                                |
| [contracts/libraries/StorageLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/StorageLib.sol)                               | 154  | Library handling the storage operations and helpers for getting and setting storage slots.                               | -                                                                                                        |
| [contracts/libraries/ValidationLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/ValidationLib.sol)                         | 150  | Library containing logic of Validation.                                                                                  | StorageLib, ProfileLib, PublicationLib                                                                   |
| [contracts/libraries/constants/Errors.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/constants/Errors.sol)                   | 40   | Library containing main custom error definitions.                                                                        | -                                                                                                        |
| [contracts/libraries/constants/Events.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/constants/Events.sol)                   | 136  | Library containing main Events.                                                                                          | -                                                                                                        |
| [contracts/libraries/constants/Typehash.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/constants/Typehash.sol)               | 18   | Library containing the Typehash constants for Meta-Transactions.                                                         | -                                                                                                        |
| [contracts/libraries/constants/Types.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/constants/Types.sol)                     | 193  | Library containing custom types, enums and structs.                                                                      | -                                                                                                        |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/base/ERC2981CollectionRoyalties.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/ERC2981CollectionRoyalties.sol)         | 42   | Base contract containing a generic implementation of ERC-2981.                                                           | -                                                                                                        |
| [contracts/base/HubRestricted.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/HubRestricted.sol)                                   | 14   | Base contract containing logic to restrict functions to be only called by the LensHub.                                   | -                                                                                                        |
| [contracts/base/LensBaseERC721.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/LensBaseERC721.sol)                                 | 220  | Base contract implementing ERC-721. Used by Lens Profiles (LensHub), Follow, and Collect NFTs.                           | MetaTxLib, @openzeppelin/\*                                                                              |
| [contracts/base/LensGovernable.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/LensGovernable.sol)                                 | 51   | Base contract implementing governance operations. Part of the LensHub.                                                   | StorageLib, ValidationLib, GovernanceLib                                                                 |
| [contracts/base/LensHubEventHooks.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/LensHubEventHooks.sol)                           | 21   | Base contract implementing logic to hook events into the LensHub. Part of the LensHub.                                   | StorageLib                                                                                               |
| [contracts/base/LensHubStorage.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/LensHubStorage.sol)                                 | 24   | Base contract containing the last part of LensHub storage layout. Part of the LensHub.                                   | -                                                                                                        |
| [contracts/base/LensImplGetters.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/LensImplGetters.sol)                               | 16   | Base contract implementing getters for Follow and Legacy Collect NFT implementations. Part of the LensHub.               | -                                                                                                        |
| [contracts/base/LensProfiles.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/LensProfiles.sol)                                     | 118  | Base contract implementing Lens Profiles collection. Part of the LensHub.                                                | StorageLib, ValidationLib, ProfileLib, ProfileTokenURILib, @openzeppelin/\*                              |
| [contracts/base/upgradeability/FollowNFTProxy.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/upgradeability/FollowNFTProxy.sol)   | 13   | Proxy implementing Beacon pattern to be used by each Follow NFT.                                                         | @openzeppelin/\*                                                                                         |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/misc/ImmutableOwnable.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/ImmutableOwnable.sol)                             | 23   | An Ownable contract to be inherited instead of OZ Ownable if the owner shall be immutable.                               | -                                                                                                        |
| [contracts/misc/LegacyCollectNFT.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/LegacyCollectNFT.sol)                             | 69   | Legacy Collect NFT for Lens V1 support.                                                                                  | @openzeppelin/\*                                                                                         |
| [contracts/misc/LensV2Migration.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/LensV2Migration.sol)                               | 38   | Lens V1 to V2 Migration functions.                                                                                       | MigrationLib                                                                                             |
| [contracts/misc/LensV2UpgradeContract.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/LensV2UpgradeContract.sol)                   | 111  | Contract handling the V1 to V2 upgrade procedure.                                                                        | -                                                                                                        |
| [contracts/misc/ModuleGlobals.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/ModuleGlobals.sol)                                   | 75   | Contract containing global Module-related values (fee, governance, etc).                                                 | -                                                                                                        |
| [contracts/misc/ProfileCreationProxy.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/ProfileCreationProxy.sol)                     | 35   | A trusted whitelisted Proxy for Profile creation.                                                                        | -                                                                                                        |
| [contracts/misc/access/ControllableByContract.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/access/ControllableByContract.sol)   | 24   | An additional Ownable layer that has an owner and a manager.                                                             | @openzeppelin/\*                                                                                         |
| [contracts/misc/access/Governance.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/access/Governance.sol)                           | 44   | A contract helper for safer Governance during upgrades, operated by Governance MultiSig.                                 | -                                                                                                        |
| [contracts/misc/access/ProxyAdmin.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/access/ProxyAdmin.sol)                           | 34   | A contract helper for safer upgrades, operated by ProxyAdmin Multisig.                                                   | @openzeppelin/\*                                                                                         |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/namespaces/LensHandles.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/namespaces/LensHandles.sol)                           | 196  | Default namespace contract (".lens" Handles).                                                                            | HandleTokenURILib, @openzeppelin/\*                                                                      |
| [contracts/namespaces/TokenHandleRegistry.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/namespaces/TokenHandleRegistry.sol)           | 120  | Registry that links Tokens (so far, Lens Profiles) with Handles.                                                         | @openzeppelin/\*                                                                                         |
| [contracts/namespaces/constants/Errors.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/namespaces/constants/Errors.sol)                 | 22   | Namespaces Errors.                                                                                                       | -                                                                                                        |
| [contracts/namespaces/constants/Events.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/namespaces/constants/Events.sol)                 | 15   | Namespaces Events.                                                                                                       | -                                                                                                        |
| [contracts/namespaces/constants/Types.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/namespaces/constants/Types.sol)                   | 11   | Namespaces Types.                                                                                                        | -                                                                                                        |
|                                                                                                        |      |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ICollectModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ICollectModule.sol)                     | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ICollectNFT.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ICollectNFT.sol)                           | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IERC721Burnable.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/IERC721Burnable.sol)                   | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IERC721MetaTx.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/IERC721MetaTx.sol)                       | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IERC721Timestamped.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/IERC721Timestamped.sol)             | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IFollowModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/IFollowModule.sol)                       | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IFollowNFT.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/IFollowNFT.sol)                             | 10   |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILegacyCollectModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILegacyCollectModule.sol)         | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILegacyCollectNFT.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILegacyCollectNFT.sol)               | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILegacyFollowModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILegacyFollowModule.sol)           | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILegacyReferenceModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILegacyReferenceModule.sol)     | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensERC721.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensERC721.sol)                           | 7    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensGovernable.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensGovernable.sol)                   | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensHandles.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensHandles.sol)                         | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensHub.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensHub.sol)                                 | 7    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensHubEventHooks.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensHubEventHooks.sol)             | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensHubInitializable.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensHubInitializable.sol)       | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensImplGetters.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensImplGetters.sol)                 | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensProfiles.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensProfiles.sol)                       | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ILensProtocol.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ILensProtocol.sol)                       | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IModuleGlobals.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/IModuleGlobals.sol)                     | 3    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IPublicationActionModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/IPublicationActionModule.sol) | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/IReferenceModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/IReferenceModule.sol)                 | 4    |                                                                                                                          |                                                                                                          |
| [contracts/interfaces/ITokenHandleRegistry.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/interfaces/ITokenHandleRegistry.sol)         | 3    |                                                                                                                          |                                                                                                          |

## Out of scope

Everything inside [`contracts/modules`](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/), [`contracts/libraries/token-uris`](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/token-uris/) directories, and [`LensHubInitializable`](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/LensHubInitializable.sol), [`VersionedInitializable`](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/upgradeability/VersionedInitializable.sol), [`UIDataProvider`](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/UIDataProvider.sol) contracts.

| Contract                                                                                                                                 |
| ---------------------------------------------------------------------------------------------------------------------------------------- |
| [contracts/modules/ActionRestricted.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/ActionRestricted.sol)                                                         |
| [contracts/modules/FeeModuleBase.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/FeeModuleBase.sol)                                                               |
| [contracts/modules/libraries/FollowValidationLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/libraries/FollowValidationLib.sol)                               |
| [contracts/modules/constants/Errors.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/constants/Errors.sol)                                                         |
| [contracts/modules/act/collect/base/BaseFeeCollectModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/act/collect/base/BaseFeeCollectModule.sol)               |
| [contracts/modules/act/collect/CollectNFT.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/act/collect/CollectNFT.sol)                                             |
| [contracts/modules/act/collect/CollectPublicationAction.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/act/collect/CollectPublicationAction.sol)                 |
| [contracts/modules/act/collect/MultirecipientFeeCollectModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/act/collect/MultirecipientFeeCollectModule.sol)     |
| [contracts/modules/act/collect/SimpleFeeCollectModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/act/collect/SimpleFeeCollectModule.sol)                     |
| [contracts/modules/act/seadrop/LensSeaDropCollection.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/act/seadrop/LensSeaDropCollection.sol)                       |
| [contracts/modules/act/seadrop/SeaDropMintPublicationAction.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/act/seadrop/SeaDropMintPublicationAction.sol)         |
| [contracts/modules/follow/FeeFollowModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/follow/FeeFollowModule.sol)                                             |
| [contracts/modules/follow/RevertFollowModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/follow/RevertFollowModule.sol)                                       |
| [contracts/modules/reference/DegreesOfSeparationReferenceModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/reference/DegreesOfSeparationReferenceModule.sol) |
| [contracts/modules/reference/FollowerOnlyReferenceModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/reference/FollowerOnlyReferenceModule.sol)               |
| [contracts/modules/reference/TokenGatedReferenceModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/reference/TokenGatedReferenceModule.sol)                   |
| [contracts/modules/interfaces/IBaseFeeCollectModule.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/interfaces/IBaseFeeCollectModule.sol)                         |
| [contracts/modules/interfaces/IWMATIC.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/modules/interfaces/IWMATIC.sol)                                                     |
|                                                                                                                                          |
| [contracts/libraries/token-uris/FollowTokenURILib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/token-uris/FollowTokenURILib.sol)                             |
| [contracts/libraries/token-uris/HandleTokenURILib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/token-uris/HandleTokenURILib.sol)                             |
| [contracts/libraries/token-uris/ProfileTokenURILib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/token-uris/ProfileTokenURILib.sol)                           |
| [contracts/libraries/token-uris/TokenURIMainFontLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/token-uris/TokenURIMainFontLib.sol)                         |
| [contracts/libraries/token-uris/TokenURISecondaryFontLib.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/libraries/token-uris/TokenURISecondaryFontLib.sol)               |
|                                                                                                                                          |
| [contracts/misc/LensHubInitializable.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/LensHubInitializable.sol)                                                       |
|                                                                                                                                          |
| [contracts/base/upgradeability/VersionedInitializable.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/base/upgradeability/VersionedInitializable.sol)                     |
|                                                                                                                                          |
| [contracts/misc/UIDataProvider.sol](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/UIDataProvider.sol)                                                                   |

# Additional Context

N/A (optional)

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
- Please describe required context: Upgrade from Lens V1 to V2 will be done in-place using a transparent proxy pattern, knowdlege about Lens V1 is required in the context of upgrade and migration success, including unexpected breaking changes.
- Does it use an oracle?: No
- Are there any novel or unique curve logic or mathematical models?: No
- Is it a fork of a popular project?: No
- Does it use a side-chain?: Uses EVM-compatible chain (Polygon).
```

# Setup

1. Clone the repository:

```bash
git clone https://github.com/code-423n4/2023-07-lens.git
```

2. Install Foundry by following the instructions from [their repository](https://book.getfoundry.sh/getting-started/installation).

```bash
curl -L https://foundry.paradigm.xyz | bash
```

```bash
foundryup
```

## Install dependencies in submodules

You can do it either with forge:

```bash
forge install
```

or directly with git:

```bash
git submodule update --init --recursive
```

## Build

You can compile the project using:

```bash
forge build
```

You will notice a warning about [LensHubInitializable](https://github.com/code-423n4/2023-07-lens/blob/main/contracts/misc/LensHubInitializable.sol) exceeding code size (anyways, this file is out of the scope for this audit). To avoid the warning, compile Via IR (it will take more time):

```bash
forge build --via-ir
```

During the deployment we will compile with `--via-ir` and tweak the optimizer runs for optimum gas performance while still keeping the contract size under the limit.

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

## Slither

If you run `slither .` it will output an error. As a workaround, at the time of writing this, you need to follow these steps.

1. Have latest foundry version, update it with the following command:

```bash
foundryup
```

2. Run slither after compiling excluding `test/` and `contract/modules/` directories (which are out of the scope of this audit anyways):

```bash
forge build --build-info --skip '*/test/**' --skip '*/modules/**' --force && slither . --ignore-compile
```

# Docs

You can go to our [docs](https://docs.lens.xyz/docs) (still V1) to learn more about Lens Protocol.

Upgrade from Lens V1 to V2 will be done in-place using a transparent proxy pattern, knowdlege about Lens V1 is required in the context of upgrade and migration success, including unexpected breaking changes.
