pragma solidity 0.5.8;

contract Certificate {

    address[] certificateIndexes;

    struct UserCertificate {
            string userDomain;
            string userMail;
            uint trustValue;
            string periodOfValidity;
            string signature;
            string version;
            uint   totalCertified;
            uint   index;
            bool   isAvailable;
    }

    mapping(address => UserCertificate) UserCertificates;

    // ****************NEW***CERTIFICATE***********

    function newCertificate( address userAddress,
                              string memory userDomain,
                              string memory userMail,
                              string memory periodOfValidity,
                              string memory signature)
    public
    returns(bool success){
          UserCertificates[userAddress].userMail          = userMail;
          UserCertificates[userAddress].userDomain        = userDomain;
          UserCertificates[userAddress].periodOfValidity  = periodOfValidity;
          UserCertificates[userAddress].trustValue        = 0;
          UserCertificates[userAddress].version           = "0.0.1";
          UserCertificates[userAddress].signature         = "testing.... The signature...";
          UserCertificates[userAddress].isAvailable       = true;
          UserCertificates[userAddress].index             = certificateIndexes.push(userAddress)-1;
          UserCertificates[userAddress].totalCertified    = 0;

          return true;
    }

    // ****GET***CERTIFICAT****INFORMATION***

    function getUserCertificate(address userAddress)
    public
    view
    returns( string memory userDomain,
             string memory userMail,
             uint    trustValue,
             string memory periodOfValidity,
             string memory signature,
             string memory version   ) {

                    return( UserCertificates[userAddress].userDomain,
                            UserCertificates[userAddress].userMail,
                            UserCertificates[userAddress].trustValue,
                            UserCertificates[userAddress].periodOfValidity,
                            UserCertificates[userAddress].signature,
                            UserCertificates[userAddress].version  );
             }



    //*********CHECK**IF**CERTIFICATE**CREATED******

    function isCertificateExist(address userAddress)
    public
    returns( bool isCertificateValid ){
              if(certificateIndexes.length == 0) return false;
              if(certificateIndexes[ UserCertificates[userAddress].index ] == userAddress)return true;
              else return false;
            }


    //********UPDATE***TRUST****VALUE*****
    event check(uint totalTrustValue);
    event check1(uint totalTrustValue);
    event check2(uint totalTrustValue);

    function updateTrustValue( address userAddress, uint aTrustValue )
    public
    returns(bool success){
               uint totalTrustValue = UserCertificates[userAddress].trustValue  + aTrustValue;
               UserCertificates[userAddress].totalCertified = UserCertificates[userAddress].totalCertified +1;
               UserCertificates[userAddress].trustValue =  totalTrustValue;
               emit check(totalTrustValue);
               return true;
    }


    //*****REQUEST******PART****


    struct CertifyBy {
        address certifyByAddress;
        uint receiveAmount;
        uint returnedAmount;
        bool returned;

    }
    mapping(address => CertifyBy[]) certifyBypeoples;

    function requestCertificationTo(address certifyForAddress, address byAddress, uint amountGiven)
    public
    returns(bool success){
        CertifyBy memory singleCertifier;
        singleCertifier.certifyByAddress =byAddress;
        singleCertifier.receiveAmount = amountGiven;
        singleCertifier.returnedAmount = 0;
        singleCertifier.returned =false;
        certifyBypeoples[certifyForAddress].push(singleCertifier);
        return true;
    }

    function backEtherForCertification(address certifyForAdd, address byAdd, uint amountGivenBack)
    public
    returns(bool success){

        for (uint i = 0; i < certifyBypeoples[certifyForAdd].length; i++) {
        emit check1(1);

            if(certifyBypeoples[certifyForAdd][i].certifyByAddress == byAdd){
                certifyBypeoples[certifyForAdd][i].returnedAmount = amountGivenBack;

                if(certifyBypeoples[certifyForAdd][i].returnedAmount == certifyBypeoples[certifyForAdd][i].receiveAmount ){

                    emit check2(2);
                    certifyBypeoples[certifyForAdd][i].returned = true;
                    uint newTrustValue = amountGivenBack;

                    if(newTrustValue > 10)newTrustValue = 10;

                    updateTrustValue(certifyForAdd,newTrustValue);

                    return true;
                }
             else{
                    return false;
                }
            }
        }


    }


}
