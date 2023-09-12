// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// Importing the necessary modules and interfaces from the Hats protocol
import { IHatsToggle } from "hats-protocol/Interfaces/IHatsToggle.sol";
import { IHats } from "hats-protocol/Interfaces/IHats.sol";
import { HatsToggleModule, HatsModule } from "hats-module/HatsToggleModule.sol";

// CardToggle contract inheriting from HatsToggleModule
contract CardToggle is HatsToggleModule {
  /*//////////////////////////////////////////////////////////////
                            CUSTOM ERRORS
  //////////////////////////////////////////////////////////////*/
  
  /// @notice Thrown when an unauthorized user tries to perform an admin operation
  error Unauthorized();

  /*//////////////////////////////////////////////////////////////
                              EVENTS
  //////////////////////////////////////////////////////////////*/

  /// @notice Emitted when a card is issued
  event CardIssued(uint256 hatId, string cardType);

  /*//////////////////////////////////////////////////////////////
                            DATA MODELS
  //////////////////////////////////////////////////////////////*/

  /// @notice Enum to represent the type of cards
  enum CardType { NONE, YELLOW, RED, GREEN }

  /// @notice Struct to represent the state of a Hat
  struct Hat {
    bool isActive;
    uint256 yellowCards;
    CardType lastCard;
  }

  /*//////////////////////////////////////////////////////////////
                            MUTABLE STATE
  //////////////////////////////////////////////////////////////*/

  /// @notice Mapping to store the state of each Hat
  mapping(uint256 => Hat) public hats;

  /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
  //////////////////////////////////////////////////////////////*/

  /// @notice Deploy the implementation contract and set its version
  /// @dev This is only used to deploy the implementation contract, and should not be used to deploy clones
  constructor(string memory _version) HatsModule(_version) { }

  /*//////////////////////////////////////////////////////////////
                            INITIALIZOR
  //////////////////////////////////////////////////////////////*/

  /// @inheritdoc HatsModule
  function _setUp(bytes calldata _initData) internal override {
    // Decode and initialize any state variables here
  }

/*//////////////////////////////////////////////////////////////
                        PUBLIC FUNCTIONS
//////////////////////////////////////////////////////////////*/

/// @notice Toggles the Hat state
/// @param _hatId The ID of the Hat to toggle
function toggleHat(uint256 _hatId) external {
    // Check if the sender is an admin of the Hat
    require(HATS().isAdminOfHat(msg.sender, _hatId), "Unauthorized");
    
    // Toggle the active state of the Hat
    hats[_hatId].isActive = !hats[_hatId].isActive;
    
    // Emit an event indicating the new state of the Hat
    emit CardIssued(_hatId, hats[_hatId].isActive ? "Activated" : "Deactivated");
}

/// @notice Issues a yellow card to a Hat
/// @param _hatId The ID of the Hat to issue the yellow card to
function issueYellowCard(uint256 _hatId) external {
    // Check if the sender is an admin of the Hat
    require(HATS().isAdminOfHat(msg.sender, _hatId), "Unauthorized");
    
    // Reference to the Hat's state in storage
    Hat storage hat = hats[_hatId];
    
    // Increment the yellow card count for the Hat
    hat.yellowCards++;
    
    // Check if the Hat should receive a red card
    if (hat.yellowCards >= 2) {
        issueRedCard(_hatId);
        return;
    }
    
    // Update the last card type issued to the Hat
    hat.lastCard = CardType.YELLOW;
    
    // Emit an event indicating that a yellow card has been issued
    emit CardIssued(_hatId, "Yellow");
}

/// @notice Issues a red card to a Hat
/// @param _hatId The ID of the Hat to issue the red card to
function issueRedCard(uint256 _hatId) public {
    // Check if the sender is an admin of the Hat
    require(HATS().isAdminOfHat(msg.sender, _hatId), "Unauthorized");
    
    // Reference to the Hat's state in storage
    Hat storage hat = hats[_hatId];
    
    // Deactivate the Hat
    hat.isActive = false;
    
    // Reset the yellow card count
    hat.yellowCards = 0;
    
    // Update the last card type issued to the Hat
    hat.lastCard = CardType.RED;
    
    // Emit an event indicating that a red card has been issued
    emit CardIssued(_hatId, "Red");
}

  /// @notice Issues a green card to a Hat
  /// @param _hatId The ID of the Hat to issue the green card to
  function issueGreenCard(uint256 _hatId) public {
    // Check if the sender is an admin of the Hat
    require(HATS().isAdminOfHat(msg.sender, _hatId), "Unauthorized");
    
    // Reference to the Hat's state in storage
    Hat storage hat = hats[_hatId];
    
    // Activate the Hat
    hat.isActive = true;
    
    // Reset the yellow and red card counts
    hat.yellowCards = 0;
    
    // Update the last card type issued to the Hat
    hat.lastCard = CardType.GREEN;
    
    // Emit an event indicating that a green card has been issued
    emit CardIssued(_hatId, "Green");
  }
}