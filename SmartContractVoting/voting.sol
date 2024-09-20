pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Ballot
 * @dev Implements voting process along with vote delegation, proposal addition, vote retraction, and voting deadline.
 */
contract Ballot {

    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    struct Proposal {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;
    uint public votingDeadline;
    Proposal[] public proposals;

    mapping(address => Voter) public voters;

    /**
     * @dev Create a new ballot to choose one of 'proposalNames' with a voting deadline.
     * @param proposalNames names of proposals
     * @param durationMinutes the time duration for voting in minutes
     */
    constructor(bytes32[] memory proposalNames, uint durationMinutes) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        votingDeadline = block.timestamp + (durationMinutes * 1 minutes);

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    modifier onlyBeforeDeadline() {
        require(block.timestamp < votingDeadline, "Voting has ended.");
        _;
    }

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only chairperson can perform this action.");
        _;
    }

    /**
     * @dev Give 'voter' the right to vote on this ballot. May only be called by 'chairperson'.
     * @param voter address of voter
     */
    function giveRightToVote(address voter) public onlyChairperson {
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0, "Voter already has the right to vote.");
        voters[voter].weight = 1;
    }

    /**
     * @dev Delegate your vote to the voter 'to'.
     * @param to address to which vote is delegated
     */
    function delegate(address to) public onlyBeforeDeadline {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    /**
     * @dev Give your vote to proposal 'proposals[proposal].name'.
     * @param proposal index of proposal in the proposals array
     */
    function vote(uint proposal) public onlyBeforeDeadline {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote.");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }

    /**
     * @dev Retract your vote, allowing you to vote again.
     */
    function retractVote() public onlyBeforeDeadline {
        Voter storage sender = voters[msg.sender];
        require(sender.voted, "You haven't voted yet.");
        proposals[sender.vote].voteCount -= sender.weight;
        sender.voted = false;
        sender.vote = 0;
    }

    /**
     * @dev Add a new proposal. Only the chairperson can call this.
     * @param proposalName name of the new proposal
     */
    function addProposal(bytes32 proposalName) public onlyChairperson {
        proposals.push(Proposal({
            name: proposalName,
            voteCount: 0
        }));
    }

    /**
     * @dev Computes the winning proposal taking all previous votes into account.
     * @return winningProposal_ index of winning proposal in the proposals array
     */
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    /**
     * @dev Calls winningProposal() function to get the index of the winner and returns the name of the winner.
     * @return winnerName_ the name of the winning proposal
     */
    function winnerName() public view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }

    /**
     * @dev Announce the winner of the voting process by emitting an event.
     */
    event VotingResults(bytes32 winnerName, uint voteCount);

    function announceWinner() public onlyBeforeDeadline {
        bytes32 winner = winnerName();
        uint winningVoteCount = proposals[winningProposal()].voteCount;
        emit VotingResults(winner, winningVoteCount);
    }
}
