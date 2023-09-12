# CardToggle Smart Contract

## Table of Contents

- [CardToggle Smart Contract](#cardtoggle-smart-contract)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Dependencies](#dependencies)
  - [Custom Errors](#custom-errors)
    - [Unauthorized](#unauthorized)
  - [Events](#events)
    - [CardIssued](#cardissued)
  - [Data Models](#data-models)
    - [CardType Enum](#cardtype-enum)
    - [Hat Struct](#hat-struct)
  - [Mutable State](#mutable-state)
    - [hats Mapping](#hats-mapping)
  - [Constructor](#constructor)
  - [Initializor](#initializor)
  - [Public Functions](#public-functions)
    - [toggleHat](#togglehat)
    - [issueYellowCard](#issueyellowcard)
    - [issueRedCard](#issueredcard)
    - [issueGreenCard](#issuegreencard)

---

## Introduction

The `CardToggle` contract is a Solidity smart contract that inherits from `HatsToggleModule`. It is designed to manage the state of "Hats" by issuing different types of cards (Yellow, Red, Green) to them. Each Hat has an active state, a count of yellow cards, and the last card type issued to it.

---

## Dependencies

- `IHatsToggle` from Hats protocol: Interface for Hats toggle functionality.
- `IHats` from Hats protocol: Interface for Hats functionality.
- `HatsToggleModule, HatsModule` from hats-module: Base classes for Hats modules.

---

## Custom Errors

### Unauthorized

Thrown when an unauthorized user tries to perform an admin operation.

---

## Events

### CardIssued

Emitted when a card is issued to a Hat. It contains the Hat ID and the type of card issued.

---

## Data Models

### CardType Enum

Represents the type of cards that can be issued. The types are NONE, YELLOW, RED, GREEN.

### Hat Struct

Represents the state of a Hat. It contains:

- `isActive`: A boolean indicating if the Hat is active.
- `yellowCards`: A uint256 count of yellow cards issued to the Hat.
- `lastCard`: The last type of card issued to the Hat.

---

## Mutable State

### hats Mapping

A public mapping that stores the state of each Hat. The key is the Hat ID, and the value is a Hat struct.

---

## Constructor

Used to deploy the implementation contract and set its version. It should not be used to deploy clones.

---

## Initializor

A function that sets up any state variables. It is an internal function and overrides the `_setUp` function from `HatsModule`.

---

## Public Functions

### toggleHat

Toggles the active state of a Hat. Only an admin of the Hat can call this function.

### issueYellowCard

Issues a yellow card to a Hat. If the Hat receives two yellow cards, a red card is automatically issued. Only an admin of the Hat can call this function.

### issueRedCard

Issues a red card to a Hat, deactivating it and resetting its yellow card count. Only an admin of the Hat can call this function.

### issueGreenCard

Issues a green card to a Hat, activating it and resetting its yellow and red card counts. Only an admin of the Hat can call this function.

---
