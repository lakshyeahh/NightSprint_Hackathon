pragma solidity ^0.5.16;

contract DecentralisedArticleManagement {
    struct Article {
        uint id;
        string title;
        string content;
        uint timestamp;
        address author;
    }

    uint public articleCount;
    mapping(uint => Article) public articles;
    mapping(address => uint[]) public userArticles; // Mapping from user address to their article IDs

    event ArticleCreated(
        uint id,
        string title,
        string content,
        uint timestamp,
        address author
    );

    constructor() public {
        // Create users and their articles
        createArticle("User1 Article 1", "Sample Content 1", msg.sender);
        createArticle("User1 Article 2", "Sample Content 2", msg.sender);
        createArticle("User2 Article 1", "Sample Content 3", address(0x1234567890123456789012345678901234567890)); // Replace with User 2's address
        createArticle("User3 Article 1", "Sample Content 4", address(0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef)); // Replace with User 3's address
    }

    function createArticle(string memory _title, string memory _content, address _userId) public {
        articleCount++;
        uint _timestamp = block.timestamp;
        articles[articleCount] = Article(articleCount, _title, _content, _timestamp, _userId);
        userArticles[_userId].push(articleCount); // Add the article to the user's list
        emit ArticleCreated(articleCount, _title, _content, _timestamp, _userId);
    }

    function readArticle(uint _id) public view returns (uint, string memory, string memory, uint, address) {
        return (articles[_id].id, articles[_id].title, articles[_id].content, articles[_id].timestamp, articles[_id].author);
    }

    function getUserArticles(address _userId) public view returns (uint[] memory) {
        return userArticles[_userId];
    }

    function updateArticle(address _author, uint _id, string memory _title, string memory _content) public {
        require(articles[_id].author == _author, "Only the author can update the article.");
        require(keccak256(abi.encodePacked(articles[_id].title)) == keccak256(abi.encodePacked(_title)), "Title does not match.");
        require(keccak256(abi.encodePacked(articles[_id].content)) == keccak256(abi.encodePacked(_content)), "Content does not match.");
        articles[_id].title = _title;
        articles[_id].content = _content;
    }

    function deleteArticle(address _author, uint _id, string memory _title, string memory _content) public {
        require(articles[_id].author == _author, "Only the author can delete the article.");
        require(keccak256(abi.encodePacked(articles[_id].title)) == keccak256(abi.encodePacked(_title)), "Title does not match.");
        require(keccak256(abi.encodePacked(articles[_id].content)) == keccak256(abi.encodePacked(_content)), "Content does not match.");
        delete articles[_id];
        articleCount--;
    }
}