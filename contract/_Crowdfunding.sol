// SPDX-License-Identifier: GPL-3.0

// 众筹

/*
1.需要一个地址
2.需要众筹的开始时间
3.众筹的结束时间
4.需要一个众筹数量
5.目前众筹的数量
.

*/
import "hardhat/console.sol";
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract Crowdfunding {
    event TransEvent(address, uint);

    struct crowdfund {
        address croedfunder;
        uint256 crowdfundStratTime; // 1670169600000 2022-12-05 00:00:00
        uint256 crowdfundEndTime; // 1672848000000 2023-01-5 23:59:59
        uint256 amount;
        uint256 currentAmount; // 当前数量
    }
    mapping(address => crowdfund) public crowdfunds;
    struct participant {
        address personer;
        uint256 personAmount; //
    }
    participant[] public participants;
    uint256 public currentAmount = 0;

    constructor(address _addr) {
        require(_addr != address(0), "invaild address");
        crowdfunds[msg.sender].croedfunder = _addr;
    }

    modifier onlyOwner() {
        require(
            msg.sender == crowdfunds[msg.sender].croedfunder,
            unicode"只有拥有者才可以进行操作"
        );
        _;
    }
    modifier onlyTime(uint256 _startTime, uint256 _endTime) {
        if (_startTime > _endTime) revert(unicode"结束时间必须大于开始时间");
        _;
    }

    function createCrowdfunding(
        uint256 _amount,
        uint256 _startTime,
        uint256 _endTime
    ) external onlyOwner onlyTime(_startTime, _endTime) {
        crowdfunds[msg.sender].amount = _amount;
        crowdfunds[msg.sender].crowdfundStratTime = _startTime;
        crowdfunds[msg.sender].crowdfundEndTime = _endTime;
    }

    // function crowdfunding(address _addr, uint256 _amount)
    //     external
    //     returns (participant[] memory)
    // {
    // participants.push(
    //     participant({personer: _addr, personAmount: _amount})
    // );
    // return participants;
    // }
    fallback() external payable {
        // emit TransEvent(address(this), 1);
    }

    receive() external payable {
        // emit TransEvent(address(this), 2);
    }

    function pay(address payable _addr, uint256 _amount)
        external
        payable
        returns (participant[] memory)
    {
        participants.push(
            participant({personer: _addr, personAmount: _amount})
        );

        _addr.transfer(msg.value);

        return participants;
    }

    function getAmount() external returns (uint256) {
        for (uint256 i = 0; i < participants.length; i++) {
            currentAmount += participants[i].personAmount;
            console.log(currentAmount, unicode"哈哈哈哈");
        }
        crowdfunds[msg.sender].currentAmount = currentAmount;
        return crowdfunds[msg.sender].currentAmount;
    }
}

contract CrowdfundingOperator is
    Crowdfunding(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
{}
