module governancer::excute_transfer {
    use sui::tx_context::TxContext;
    use sui::transfer;

    use governancer::govern::Proposal;
    use governancer::govern;

    const ProposalNotPassed: u64 = 20;
    public entry fun excute_nft_transfer<NFT: key + store>(proposal: &mut Proposal, nft: NFT, to: address, ctx: &mut TxContext) {
        // 1. check if the proposal is passed
        assert!(govern::get_result(proposal, ctx), ProposalNotPassed);
        // 2. excute the transfer
        // TODO: excute the transfer
        transfer::public_transfer(nft, to);
    }
}