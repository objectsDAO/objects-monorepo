module governancer::govern {

    use sui::transfer;
    use std::string;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID, ID};
    use governancer::mock_nft::Num;

    /// Timeout for the proposal.
    // TODO: nfts have diff weight.
    // TODO: action: transfer object to sender.
    // TODO: batch transfer object.
    const ETimeout: u64 = 0;
    
    struct Proposal has key, store {
        id: UID,
        name: string::String,
        description: string::String,
        start_timestamp: u64,
        end_timestamp: u64,
        approve_num: u64,
        deny_num: u64
    }

    struct Vote has key, store {
        id: UID,
        proposal_id: ID,
        voter: address,
        decision: bool,
        reason: string::String
    }

    // const VOTE_THRESHOLD: u64 = 1;
    // const PROPOSE_THRESHOLD: u64 = 2;

    public entry fun vote(_nft: &mut Num, proposal: &mut Proposal, decision: bool, ctx: &mut TxContext) {
        let time_now: u64 = tx_context::epoch_timestamp_ms(ctx);
        // vote for a proposal if voter has one more NFT.
        assert!(time_now < proposal.end_timestamp, ETimeout);
        if(decision) {
            proposal.approve_num = proposal.approve_num + 1;
        } else {
            proposal.deny_num = proposal.deny_num + 1;
        };
        // create a new vote.
        let vote = Vote {
            id: object::new(ctx),
            proposal_id: object::uid_to_inner(&proposal.id),
            voter: tx_context::sender(ctx),
            decision: decision,
            reason: string::utf8(b"")
        };
        transfer::transfer(vote, tx_context::sender(ctx))

    }

    public entry fun vote_with_reason(_nft: &mut Num, proposal: &mut Proposal, decision: bool, reason: string::String, ctx: &mut TxContext) {
        let time_now: u64 = tx_context::epoch_timestamp_ms(ctx);
        // vote for a proposal if voter has one more NFT.
        assert!(time_now < proposal.end_timestamp, ETimeout);
        if(decision) {
            proposal.approve_num = proposal.approve_num + 1;
        } else {
            proposal.deny_num = proposal.deny_num + 1;
        };
        // create a new vote.
        let vote = Vote {
            id: object::new(ctx),
            proposal_id: object::uid_to_inner(&proposal.id),
            voter: tx_context::sender(ctx),
            decision: decision,
            reason: reason
        };
        transfer::transfer(vote, tx_context::sender(ctx))
    }

    public entry fun propose(
        _nft_1: &mut Num,
        _nft_2: &mut Num,
        name: string::String, 
        description: string::String, 
        start_timestamp: u64,
        end_timestamp: u64,
        ctx: &mut TxContext) {

        // create a new proposal.
        let proposal = Proposal {
            id: object::new(ctx),
            name: name,
            description: description,
            start_timestamp: start_timestamp,
            end_timestamp: end_timestamp,
            approve_num: 0,
            deny_num: 0
        };
        transfer::share_object(proposal)
    }
}