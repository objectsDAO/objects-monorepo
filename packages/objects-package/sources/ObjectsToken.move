module objectsDAO::token{
  use std::ascii;
  use std::string;
  use std::vector;
  use sui::clock::Clock;
  use sui::event;
  use sui::object;
  use objectsDAO::descriptor::ObjectsDescriptor;
  use objectsDAO::objects_seeder;
  use objectsDAO::objects_seeder::Seed;
  use sui::object::UID;
  use sui::table;
  use sui::table::Table;
  use sui::transfer;
  use sui::tx_context::TxContext;
  use sui::url;
  use sui::url::Url;

  struct ObjectToken has key,store{
    id:UID,
    // The noun seeds
    objects_dao_treasury:address,
    seeds:Table<u256,Seed>,
    current_object_id:u256,
  }

  struct ObjectCreated has copy, drop {
    object_id:u256,
    seed:Seed,
  }


  struct Object has key,store {
    id:UID, /// Name for the token
    name: string::String,
    /// Description of the token
    description: string::String,
    /// URL for the token
    image_url: Url,
  }


  public fun mint(to:address,clock: &sui::clock::Clock,object_token:&mut ObjectToken,objects_descriptor: &mut ObjectsDescriptor,ctx: &mut TxContext):u256{

    let object_number_check = object_token.current_object_id <= 1820;
    let object_team_number_check = object_token.current_object_id % 10 ==0;

    let current_object_id = object_token.current_object_id;
    if(object_number_check && object_team_number_check){
      object_token.current_object_id = current_object_id + 1;
      let object_id = mint_to(object_token.objects_dao_treasury,current_object_id,clock,object_token,objects_descriptor,ctx);
      object_id
    }else{
      object_token.current_object_id = current_object_id + 1;
      let object_id = mint_to(to,current_object_id,clock,object_token,objects_descriptor,ctx);
      object_id
    }
  }

  fun mint_to(to:address,object_id:u256,clock: &sui::clock::Clock, object_token:&mut ObjectToken,objects_descriptor: &mut ObjectsDescriptor,ctx: &mut TxContext):u256{
    let seed = objects_seeder::generateSeed(object_id,clock,objects_descriptor);
    table::add<u256,Seed>(&mut object_token.seeds,object_id,seed);
    mint_(to,object_id,clock,objects_descriptor,ctx);
    event::emit(ObjectCreated {
      object_id,
      seed
    });
    object_id
  }

  fun mint_(to:address,object_id: u256, clock: &Clock, objects_descriptor: &mut ObjectsDescriptor,ctx: &mut TxContext){
    let seed = objects_seeder::generateSeed(object_id, clock, objects_descriptor);
    let generate_svg_image = objects_seeder::generateSVGImage(seed, objects_descriptor);

    let url_ascii = string::to_ascii(generate_svg_image);

    let string = string::utf8(b"Object#");
    let object_id_string = string::from_ascii(to_string(object_id));
    string::append(&mut string,object_id_string);

    let nft = Object {
      id: object::new(ctx),
      name:string,
      description:string::utf8(b"Member of Objects Dao"),
      image_url:url::new_unsafe(url_ascii)
    };
    // let sender = tx_context::sender(ctx);
    transfer::public_transfer(nft, to);
  }

  /// Converts a `u128` to its `ascii::String` decimal representation.
  fun to_string(value: u256): ascii::String {
    if (value == 0) {
      return ascii::string(b"0")
    };
    let buffer = vector::empty<u8>();
    while (value != 0) {
      vector::push_back(&mut buffer, ((48 + value % 10) as u8));
      value = value / 10;
    };
    vector::reverse(&mut buffer);
    ascii::string(buffer)
  }

  public fun objects_dao_treasury_address(object_token:&ObjectToken):address{
    object_token.objects_dao_treasury
  }

}
