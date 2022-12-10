// SPDx-License-Identifier : MIT

 pragma solidity ^0.8.17;

  contract RaiseMoney{
      struct Campaign{
          address payable beneficiary;
          uint goal;
          uint realizedMoney;
          Donors [] donorsList;
      }

      struct Donors{
          address giver;
          uint amount;
      }

      mapping(uint => Campaign) campaigns;

      uint campaignId = 0;

      modifier onlyBeneficiary(uint _campaignId) {
          require(campaigns[_campaignId].beneficiary == msg.sender);
          _; 
      }

      function launchFundRaising(uint _campaignId, address payable _beneficiary, uint _realizedMoney) public {
        campaigns[_campaignId].beneficiary = _beneficiary;
        campaigns[_campaignId].goal = 0;
        campaigns[_campaignId].realizedMoney = _realizedMoney;

        //keep incrementing

        campaignId ++;
      }

      function giveMoney(uint _campaignId, uint _amount) public {
        require(campaigns[_campaignId].goal > campaigns[_campaignId].realizedMoney, "can no longer donate as we have achieved the goal");
        campaigns[_campaignId].realizedMoney += _amount;
        //pushing the new donor into the Donors array
        campaigns[_campaignId].donorsList.push(Donors(msg.sender, _amount));
      }

      function checkCompletness(uint _campaignId) public view returns(bool completed){
        if(
            campaigns[_campaignId].realizedMoney == campaigns[_campaignId].goal
        ){
            completed = true;
        }
      }

      function claimTheMoney(uint _campaignId) public onlyBeneficiary(_campaignId){
       require(address(this).balance != 0, "it cannot be address zero.");
       campaigns[_campaignId].beneficiary.transfer (address(this).balance);
       campaigns[_campaignId].realizedMoney -= address(this).balance;
      }
  }
