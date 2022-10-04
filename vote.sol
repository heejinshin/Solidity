// 간단한 투표 프로그램 생성 
    // 후보자 등록하기 
    // 후보자 불러오기 
    // 투표하기 
    // 투표를 끝내도록 해야함 

// 1. 어떤 버전의 솔리디티 사용할 것인지 먼저 정의 

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Vote {

    // structure
        //candidate 만들기
    struct candidator {
        string name;
        uint upVote;
    }

    // variable 
    bool live; 
    address owner;  // owner 변수 생성  
    candidator[] public candidatorList;  // 후보자들을 계속 담을 수 있는 동적인 배열을 만든 것 

    // mapping 
    mapping(address => bool) Voted; //address는 누군지를 판단할 수 있는 기준이 된다. 댑에서는 보통 address를 사용, 했는지 여부만 알면 되니까 bool 값 설정     


    // event ; emit 사항을 noti. 한다
    event AddCandidator(string name); // 누가 등록됐는지
    event UpVote(string candidator, uint upVote);  // 누가 몇표를 받았는지
    event FinishVote(bool live);
    event Voting(address owner); // 처음 생성됐을 떄 주인이 누구인지 말해주는 이벤트  

    // modifier
    modifier onlyOwner {  
        require(msg.sender == owner);   // 메시지를 보낸 사람이 owner인지 판단하고, 그게 맞으면 그 이후의 함수를 실행 하라는 modifier 생성
         -; 
    }


    // constructor 
    constructor() public {
          owner = msg.sender;
          live = true;

          emit Voting(owner); 
    }

    // candidator 
    function addCandidator(string _name) public onlyOwner {  // 후보자를 등록시키는 과정 
        require(live = true);
        require(candidatorList.length < 5); // 등록할 수 있는 후보자의 수에 제한을 뒀다. 

        candidatorList.push(candidator(_name, 0)); // name 을 받고 초기에는 vote를 하나도 안받았으니까 0 

        //emit event ; 이벤트를 발생시킴 
        emit AddCandidator(_name);  // addCandidator로 브로드캐스트함 
            
            
    }

    // voting 
    function upVote(uint _indexOfCandidator) public {// uint ; 몇번째 후보를 지지할건지 
            require(live = true);
            require(_indexOfCandidator < candidatorList.length;);  // 등록된 후보자 수보다 vote수가 작도록 
            require(Voted[msg.sender] == false );     // voting을 아직 하지 않은 사람이 하도록
            candidatorList[_indexOfCandidator].upVote++;  // voting을 받은 후보자가 받은 투표수를 늘린다 

            // voting을 이미 한 사람은 다시 voting할 수 없게 막는다  -> voting을 했는지 안했는지 담고 있는 data를 mapping에 작성. 
            Voted[msg.sender] = true; // solidity의 특별한 변수 msg.sender; 메시지를 보낸 사람의 주소를 갖는다 

            emit upVote(candidatorList[_indexOfCandidator].name, candidatorList[_indexOfCandidator].upVote);
            // 어떤 후보자가 몇 vote를 받았는지 외부에 알림 (emit) 


    }

    // finish vote
    function finishVote() public onlyOwner{    // vote를 끝내는 함수 , public이라 누구나 끝낼 수 있어 주인만 닫을 수있도록 (upVote
        require(live = true);
    //컨트랙트를 만든 사람만 닫을 수 있게 modifier 생성; 
        live = false;   // vote의 상태; 끝난상태로 false로 초기화 

        emit FinishVote(live);  // vote가 끝났음을 알림 
    }

}



