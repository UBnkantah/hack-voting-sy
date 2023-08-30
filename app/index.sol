// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Candidate {
        uint256 candidateId;
        // struct name;
        uint256 voteCount;
    }
    struct Contract {
        uint256 contractId;
        string contractText;
        uint256 yesVotes;
        uint256 noVotes;
        mapping(address => bool) hasVoted;
    }

    Contract[] public contracts;

    function createContract(string memory contractText) public {
        uint256 contractId = contracts.length;
        contracts.push(Contract(contractId, contractText, 0, 0));
    }

    function vote(uint256 contractId, bool voteYes) public {
        require(contractId < contracts.length, "Invalid contract ID");
        require(!contracts[contractId].hasVoted[msg.sender], "Already voted");

        if (voteYes) {
            contracts[contractId].yesVotes++;
        } else {
            contracts[contractId].noVotes++;
        }

        contracts[contractId].hasVoted[msg.sender] = true;
    }

    function getVoteCount(uint256 contractId) public view returns (uint256 yesVotes, uint256 noVotes) {
        require(contractId < contracts.length, "Invalid contract ID");
        Contract memory contractObj = contracts[contractId];
        yesVotes = contractObj.yesVotes;
        noVotes = contractObj.noVotes;
    }
}
// Explanation of Data Types and Functions:

// Struct Contract: This struct defines the properties of a contract, including its ID, text, yes and no votes counts, and a mapping to track whether an address has voted for the contract.

// Function createContract: This function creates a new contract and adds it to the array of contracts. It takes a contractText parameter of type string representing the text of the contract.

// Function vote: This function allows participants to vote on a specific contract. It takes a contractId parameter of type uint256 to identify the contract and a voteYes parameter of type bool to indicate whether the vote is a "yes" or "no" vote.

// Function getVoteCount: This function retrieves the vote counts (yes and no) for a specific contract. It takes a contractId parameter of type uint256 and returns the counts as uint256.

// Remember that this is a simplified example. Real-world contract voting systems might have more complex requirements and security considerations. Additionally, the above code is written in Solidity-like syntax; it needs to be compiled and deployed on a blockchain platform that supports smart contracts, like Ethereum.




// User
// Define Appropriate Data Types and work with code Implementation for the various functions/methods in the contract voting system:
// 1. Define an appropriate data type to store candidates
// 2. Define an appropriate data type to track if voter has already voted
// 3. add new candidate
// 4. remove already added candidate
// 5. retrieve all candidate for viewing 
// 6. allow voter to cast a vote for single candidate
// ChatGPT
// Sure, I can help you with that! Below is a more detailed implementation of the contract voting system that includes the functionalities you've mentioned. This implementation uses Solidity, a popular smart contract language for Ethereum-based applications.

// solidity
// Copy code
// pragma solidity ^0.8.0;

contract VotingSystem {
    struct Candidate {
        uint256 candidateId;
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint256 votedCandidateId;
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(address => Voter) public voters;

    uint256 public candidateCount;

    constructor() {
        candidateCount = 0;
    }

    function addCandidate(string memory name) public {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, name, 0);
    }

    function removeCandidate(uint256 candidateId) public {
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID");
        require(candidates[candidateId].voteCount == 0, "Cannot remove candidate with votes");
        delete candidates[candidateId];
    }

    function getCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory candidateList = new Candidate[](candidateCount);
        for (uint256 i = 1; i <= candidateCount; i++) {
            candidateList[i - 1] = candidates[i];
        }
        return candidateList;
    }

    function vote(uint256 candidateId) public {
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID");
        require(!voters[msg.sender].hasVoted, "Already voted");

        candidates[candidateId].voteCount++;
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedCandidateId = candidateId;
    }
}}

// Explanation of Data Types and Functions:

// Struct Candidate: This struct defines the properties of a candidate, including their ID, name, and vote count.

// Struct Voter: This struct tracks whether a voter has voted and the ID of the candidate they voted for.

// Mapping candidates: This mapping stores the candidate data with the candidate ID as the key.

// Mapping voters: This mapping stores the voter data using their Ethereum address as the key.

// Function addCandidate: Adds a new candidate to the system. It takes a name parameter of type string.

// Function removeCandidate: Removes a candidate from the system. The candidate must have a vote count of zero. It takes a candidateId parameter of type uint256.

// Function getCandidates: Retrieves all candidates for viewing. It returns an array of Candidate structs.

// Function vote: Allows a voter to cast a vote for a specific candidate. It takes a candidateId parameter of type uint256.

// Keep in mind that this code is a basic implementation. In a real-world scenario, you would need to consider additional security measures, error handling, and potentially more complex logic for various use cases. Additionally, remember to deploy this contract on a suitable blockchain platform that supports smart contracts.




// User
// express and mongodb user authentication code
// ChatGPT
// Sure, I can provide you with an example of user authentication using Express.js and MongoDB. In this example, we'll use the express framework to create a simple API for user registration, login, and authentication. We'll also use bcrypt for password hashing and jsonwebtoken for creating and verifying JWT tokens. This example assumes you have MongoDB set up and running.

// Install the required packages:
// bash
// Copy code
// npm install express mongoose bcrypt jsonwebtoken
// Create a file named app.js and add the following code:
// javascript
// Copy code
// const express = require('express');
// const mongoose = require('mongoose');
// const bcrypt = require('bcrypt');
// const jwt = require('jsonwebtoken');

// const app = express();
// app.use(express.json());

// // Connect to MongoDB
// mongoose.connect('mongodb://localhost/auth_example', { useNewUrlParser: true, useUnifiedTopology: true });
// const db = mongoose.connection;

// db.on('error', console.error.bind(console, 'MongoDB connection error:'));

// // Define User Schema
// const userSchema = new mongoose.Schema({
//   username: String,
//   password: String,
// });

// const User = mongoose.model('User', userSchema);

// // Register User
// app.post('/register', async (req, res) => {
//   const { username, password } = req.body;

//   try {
//     const hashedPassword = await bcrypt.hash(password, 10);
//     const newUser = new User({ username, password: hashedPassword });
//     await newUser.save();
//     res.status(201).json({ message: 'User registered successfully' });
//   } catch (error) {
//     res.status(500).json({ error: 'Registration failed' });
//   }
// });

// // Login User
// app.post('/login', async (req, res) => {
//   const { username, password } = req.body;

//   try {
//     const user = await User.findOne({ username });
//     if (!user) {
//       return res.status(401).json({ error: 'Authentication failed' });
//     }

//     const passwordMatch = await bcrypt.compare(password, user.password);
//     if (!passwordMatch) {
//       return res.status(401).json({ error: 'Authentication failed' });
//     }

//     const token = jwt.sign({ userId: user._id }, 'secret_key');
//     res.json({ token });
//   } catch (error) {
//     res.status(500).json({ error: 'Login failed' });
//   }
// });

// // Protected Route
// app.get('/protected', (req, res) => {
//   const token = req.header('Authorization');

//   if (!token) {
//     return res.status(401).json({ error: 'Unauthorized' });
//   }

//   jwt.verify(token, 'secret_key', (err, decoded) => {
//     if (err) {
//       return res.status(401).json({ error: 'Unauthorized' });
//     }
//     res.json({ message: 'Protected route accessed successfully', user: decoded.userId });
//   });
// });

// // Start the server
// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => {
//   console.log(`Server is running on port ${PORT}`);
// });
// Replace 'mongodb://localhost/auth_example' with your actual MongoDB connection string.

// In this example:

// The /register endpoint handles user registration and hashes the password before storing it in the database.
// The /login endpoint handles user login and generates a JWT token upon successful authentication.
// The /protected endpoint is a protected route that requires a valid JWT token for access.
// Remember that this is a basic example and might need further improvements for a production environment, such as error handling, validation, and security enhancements.






//     constructor() {
//         candidateCount = 0;
//     }
// 