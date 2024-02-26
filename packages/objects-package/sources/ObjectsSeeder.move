module objectsDAO::ObjectsSeeder {
  use std::string::String;
  use std::vector;
  use objectsDAO::MultiPartRLEToSVG::{create_svg_params, generateSVG};
  use objectsDAO::Descriptor::{backgroundCount, bodyCount, accessoryCount, headCount, glassesCount, ObjectsDescriptor,
    get_bodies, get_accessories, get_heads, get_glasses, get_backgrounds
  };
  use sui::clock;
  use sui::clock::Clock;

  struct Seed has copy,drop {
        background:u64,
        body:u64,
        accessory:u64,
        head:u64,
        glasses:u64
  }

  // public entry fun mint(){
  //
  // }


  public entry fun generateSeed(object_id:u256, objects_descriptor:&mut ObjectsDescriptor,clock: &Clock):Seed {
      let randomness =  (clock::timestamp_ms(clock) as u256) + object_id;

      let backgroundCount = backgroundCount(objects_descriptor);
      let bodyCount = bodyCount(objects_descriptor);
      let accessoryCount = accessoryCount(objects_descriptor);
      let headCount = headCount(objects_descriptor);
      let glassesCount = glassesCount(objects_descriptor);

      Seed{
        background:(((randomness) % backgroundCount) as u64),
        body:(((randomness) % bodyCount) as u64),
        accessory:(((randomness >> 96) % accessoryCount) as u64),
        head:(((randomness >> 144) % headCount) as u64),
        glasses:(((randomness >> 192) % glassesCount) as u64)
      }
  }

  public fun getPartsForSeed_(seed:Seed,objects_descriptor:&ObjectsDescriptor):vector<vector<u8>> {
    let bodies = get_bodies(objects_descriptor);
    let accessories = get_accessories(objects_descriptor);
    let heads = get_heads(objects_descriptor);
    let glasses = get_glasses(objects_descriptor);

    let body = *vector::borrow(bodies,seed.body);
    let accessory = *vector::borrow(accessories,seed.accessory);
    let head = *vector::borrow(heads,seed.head);
    let glasses = *vector::borrow(glasses,seed.glasses);

    let parts:vector<vector<u8>> = vector[body,accessory,head,glasses];
    parts
  }

  public fun generateSVGImage(seed:Seed,objects_descriptor:&ObjectsDescriptor):String{
    let parts = getPartsForSeed_(seed,objects_descriptor);
    let backgrounds = get_backgrounds(objects_descriptor);
    let background = *vector::borrow(backgrounds,seed.background);
    let params = create_svg_params(parts,background);
    let svg= generateSVG(params,objects_descriptor);
    svg
  }

  // #[test]
  // fun test_generateSeed(){
  //   let objects_id = 0
  // }
}
