//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.5.0<0.9.0;

contract Insta{

   struct Post{
       uint id;
       address from;
       string content;
       uint createdAt;
    }
    struct Message{
       uint id;
       address from;
       address to;
       string content;
       uint createdAt;
    }
    uint postId;
    uint messageId;
   

    mapping(uint=>Post) public postNum;
    mapping(address=>uint[])public postFrom;
    mapping(address=>Message[]) public conversation;
   
    mapping(address=>address[]) public following;
    mapping(address=>mapping(address=>bool)) public operator;

    function postFeed(address from, string memory content) private{
        require(msg.sender==from||operator[from][msg.sender], "No access");
        postNum[postId]=Post(postId,msg.sender,content,block.timestamp);
        postFrom[msg.sender].push(postId);
        postId++;
    }


    function _postFeed(string memory content) public {
        postFeed(msg.sender,content);
    }

    function allow(address guest) public {
        operator[msg.sender][guest]=true;
    }
    function disAllow(address guest) public {
        operator[msg.sender][guest]=false;
    }

    function _postFeed(address from,string memory content) public {
        postFeed(from,content);
    }
    function message(address from,address to, string memory content) private{
        require(msg.sender==from||operator[from][msg.sender], "No access");
        conversation[from].push(Message(messageId,from,to,content,block.timestamp));
        conversation[to].push(Message(messageId,from,to,content,block.timestamp));     
        messageId++;
    }
    function _message(address to,string memory content) public {
        message(msg.sender,to,content);
    }
    function _mesage(address from,address to,string memory content) public {
        message(from,to,content);
    }
    
    function follow(address ppl) public{
        following[msg.sender].push(ppl);
    }

    function getLatestPost(uint count) public view returns (Post[] memory ){
        require(count>0 && count<=postId,"Count is not proper");
        Post[] memory p = new Post[](count);
        uint j;
        for(uint i=postId-count;i<(postId);i++){
         Post memory structure = postNum[i];
         p[j]=Post(structure.id,structure.from,structure.content,structure.createdAt);
         j++;
        }
        return p;
    }
    
    function getLatestPostOf(address from, uint count) public view returns(Post[] memory){
        uint[] memory id = postFrom[from];
        Post[] memory p = new Post[](count);
        require(count>0 && count<=id.length,"Count is not proper");
        uint j;
        for(uint i=id.length-count;i<(id.length);i++){
            Post memory structure = postNum[id[i]];
            p[j]= Post(structure.id,structure.from, structure.content,structure.createdAt);
            j++;
        }
        return p;
    }

    function getFollowing(address ofPerson) public view returns(address[] memory){
       address[] memory f =   following[ofPerson];
       return f;         
    } 
  
}