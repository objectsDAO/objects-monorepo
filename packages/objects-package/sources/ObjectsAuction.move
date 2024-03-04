module objectsDAO::objects_auctio  {

  use std::option;
  use std::option::Option;
  use objectsDAO::token::{ObjectToken, objects_dao_treasury_address};
  use sui::balance;
  use objectsDAO::object::OBJECT;
  use sui::clock;
  use sui::clock::Clock;
  use sui::coin;
  use sui::coin::Coin;
  use sui::event;
  use sui::object;
  use objectsDAO::descriptor::ObjectsDescriptor;
  use objectsDAO::objects_seeder::mint;
  use sui::object::UID;
  use sui::transfer;
  use sui::transfer::transfer;
  use sui::tx_context;
  use sui::tx_context::TxContext;


  const AUCTION_STARTED: u64 = 0;
  const AUCTION_SETTLED: u64 = 1;
  const AUCTION_COMPLETED: u64 = 2;

  const OBJECT_NOT_AUCTION: u64 = 3;
  const AUCTION_EXPIRED: u64 = 4;
  const LESS_RESERVEPRICE: u64 = 5;
  const LESS_MIN_BID_PRICE: u64 = 6;


  struct AuctionCreated has copy, drop {
    object_id:u256,
    start_time:u256,
    end_time:u256
  }

  struct AuctionBid has copy, drop {
    object_id:u256,
    sender:address,
    bid_price_value:u64,
    extended:bool
  }

  struct AuctionExtended has copy, drop {
    object_id:u256,
    endTime:u256
  }

  struct AuctionSettled has copy, drop {
    object_id:u256,
    winner:address,
    amount:u256
  }

  struct AuctionTimeBufferUpdated has copy, drop {
    timeBuffer:u256
  }

  struct AuctionReservePriceUpdated has copy, drop {
    reservePrice:u256
  }

  struct AuctionMinBidIncrementPercentageUpdated has copy, drop {
    minBidIncrementPercentage:u256
  }


  struct AuctionManager {
    id:UID,
    reservePrice:u256,
    minBidIncrementPercentage:u256,
    // The minimum amount of time left in an auction after a new bid is created
    timeBuffer:u256,
    duration:u256,
    auction:Auction
  }


  struct Auction has store {
      object_id:u256,
    // The current highest bid amount
      amount:u256,
    // The time that the auction started
      startTime:u256,
    // The time that the auction is scheduled to end
      endTime:u256,
    // The address of the current highest bid
      payable_bidder:address,
    // Whether or not the auction has been settled
      settled:bool,
  }


  fun init(ctx: &mut TxContext){
     let auction_manager = AuctionManager{
       id:object::new(ctx),
       reservePrice:0u256,
       minBidIncrementPercentage:0u256,
       timeBuffer:0u256,
       duration:0u256,
       auction:Auction{
         object_id:1u256,
         // The current highest bid amount
         amount:0u256,
         // The time that the auction started
         startTime:0u256,
         // The time that the auction is scheduled to end
         endTime:0u256,
         // The address of the current highest bid
         payable_bidder:@0,
         // Whether or not the auction has been settled
         settled:true,
       }
     };
    // Transfer the forge object to the module/package publisher
    transfer::public_share_object(auction_manager);
  }


  public fun settleCurrentAndCreateNewAuction(clock: &Clock,auction_manager:&mut AuctionManager) {
    settleAuction_(auction_manager);
    createAuction_(clock,auction_manager);
  }

  public fun settleAuction(auction_manager:&mut AuctionManager){
    settleAuction_(auction_manager);
  }




  public entry fun createBid(input_coin: Coin<OBJECT>,object_id:u256,clock: &Clock,auction_manager:&mut AuctionManager,ctx:&mut TxContext){
    let auction_ = auction_manager.auction;

    let bid_price_value = coin::value(&input_coin);

    let timestamp = clock::timestamp_ms(clock);
      assert!(auction_.object_id == object_id,OBJECT_NOT_AUCTION);
      assert!(timestamp < (auction_.endTime as u64),AUCTION_EXPIRED);
      assert!(bid_price_value >= (auction_manager.reservePrice as u64),LESS_MIN_BID_PRICE);
      assert!(bid_price_value >= ((auction_.amount + ((auction_.amount * (auction_manager.minBidIncrementPercentage as u256) /100))) as u64),LESS_MIN_BID_PRICE);

      let last_bidder = auction_.payable_bidder;

      // Refund the last bidder, if applicable

      if(last_bidder != @0){
        transfer_objects_coin(input_coin,last_bidder)
      };

      auction_manager.auction.amount = (bid_price_value as u256);
      auction_manager.auction.payable_bidder = tx_context::sender(ctx);

      // Extend the auction if the bid was received within `timeBuffer` of the auction end time
      let extended = ( (auction_manager.auction.endTime - (timestamp as u256)) < auction_manager.timeBuffer );
      if (extended) {
        auction_manager.auction.endTime = (timestamp as u256) + auction_manager.timeBuffer;

      };

      event::emit(AuctionBid {
        object_id:auction_.object_id,
        sender:tx_context::sender(ctx),
        bid_price_value,
        extended
      });

      if (extended) {
        event::emit(AuctionExtended {
          object_id:auction_.object_id,
          endTime:auction_.endTime
        });
      }
  }

  // fun pause(){
  //   pause_()
  // }
  //
  // fun unpause(auction:&mut Auction){
  //   unpause_();
  //   if(auction.startTime ==0 || auction.settled){
  //     createAuction_();
  //   }
  // }


  public fun setTimeBuffer(time_buffer:u256,auction_manager:&mut AuctionManager){
      auction_manager.timeBuffer = time_buffer;
      event::emit(AuctionTimeBufferUpdated {
        timeBuffer:time_buffer
      });
  }

  public fun setReservePrice(reserve_price:u256,auction_manager:&mut AuctionManager){
      auction_manager.reservePrice = reserve_price;
      event::emit(AuctionReservePriceUpdated {
        reservePrice:reserve_price
      });
  }

  public fun setMinBidIncrementPercentage(minBidIncrementPercentage:u256,auction_manager:&mut AuctionManager){
    auction_manager.minBidIncrementPercentage = minBidIncrementPercentage;
    event::emit(AuctionMinBidIncrementPercentageUpdated {
      minBidIncrementPercentage
    });
  }

  fun createAuction_(clock: &Clock,auction_manager:&mut AuctionManager){
    let object_id = 0u256;
    let timestamp = (clock::timestamp_ms(clock) as u256);
    let start_time:u256 = timestamp;
    let end_time = start_time + auction_manager.duration;
    auction_manager.auction = Auction{
      object_id,
      amount:0,
      startTime:start_time,
      endTime:end_time,
      payable_bidder:@0,
      settled:false
    };
    event::emit(AuctionCreated {
      object_id,
      start_time,
      end_time
    });
  }


  fun settleAuction_(input_coin: Coin<OBJECT>,auction_manager:&mut AuctionManager,object_token:&ObjectToken) {
    let auction_ = auction_manager.auction;
    assert!(auction_.startTime!=0,AUCTION_STARTED);
    assert!(auction_.startTime!=0,AUCTION_SETTLED);
    assert!(auction_.startTime!=0,AUCTION_COMPLETED);

    auction_manager.auction.settled = true;

    if(auction_.payable_bidder == @0){

    }else{

    };

    if(auction_.amount > 0){
      transfer_objects_coin(input_coin,objects_dao_treasury_address(object_token))
    };

    event::emit(AuctionSettled {
      object_id:auction_.object_id,
      winner:auction_.payable_bidder,
      amount:auction_.amount
    });
  }

  fun transfer_objects_coin(input_coin:Coin<OBJECT>,address:address){
    transfer::public_transfer(input_coin,address);
  }
}
