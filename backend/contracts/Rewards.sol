// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "./Flipcoin.sol";

contract FlipcoinRewardSystem {
    enum Tier {
        Rookie,
        Silver,
        Gold,
        Platinum
    }

    struct UserInfo {
        Tier tier;
        uint256 totalPurchases;
    }

    mapping(address => UserInfo) public userInfos;

    Flipcoin private flipcoinToken;
    address private owner;

    uint256 rookieThreshold;
    uint256 silverThreshold;
    uint256 goldThreshold;
    uint256 platinumThreshold;

    constructor(address _flipcoinToken) {
        flipcoinToken = Flipcoin(_flipcoinToken);
        owner = msg.sender;
        rookieThreshold = 0;
        silverThreshold = 5000;
        goldThreshold = 10000;
        platinumThreshold = 15000;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function registerForReward(address _address) external {
        userInfos[_address].tier = Tier.Rookie;
    }

    function addProduct(uint256 _amount, address _address) external {
        require(_amount > 0, "Purchase amount must be greater than 0");

        UserInfo storage userInfo = userInfos[_address];
        userInfo.totalPurchases += _amount;
        uint256 rewardAmount = calculateReward(userInfo.tier, _amount);

        if (rewardAmount > 0) {
            flipcoinToken.giveReward(_address, rewardAmount);
        }

        updateTier(_address);
    }

    function updateTier(address _user) internal {
        UserInfo storage userInfo = userInfos[_user];

        if (userInfo.tier == Tier.Platinum) return; // User is already at the highest tier

        Tier newTier;
        if (userInfo.totalPurchases >= platinumThreshold) {
            newTier = Tier.Platinum;
        } else if (userInfo.totalPurchases >= goldThreshold) {
            newTier = Tier.Gold;
        } else if (userInfo.totalPurchases >= silverThreshold) {
            newTier = Tier.Silver;
        }

        if (newTier > userInfo.tier) {
            userInfo.tier = newTier;
        }
    }

    function getProfile(
        address _address
    ) public view returns (UserInfo memory) {
        UserInfo memory currProfile = userInfos[_address];
        return currProfile;
    }

    function calculateReward(
        Tier _tier,
        uint256 _totalPurchases
    ) internal pure returns (uint256) {
        uint256 rewardPercentage;
        if (_tier == Tier.Rookie) {
            return 0;
        } else if (_tier == Tier.Silver) {
            rewardPercentage = 3;
        } else if (_tier == Tier.Gold) {
            rewardPercentage = 6;
        } else if (_tier == Tier.Platinum) {
            rewardPercentage = 9;
        }

        return (_totalPurchases * rewardPercentage) / 100;
    }
}
