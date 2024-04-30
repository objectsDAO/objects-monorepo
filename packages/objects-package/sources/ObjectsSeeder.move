module objectsDAO::objects_seeder {
  use std::string;
  use std::string::String;
  use std::vector;
  use objectsDAO::multi_part_rel_to_svg::{create_svg_params, generateSVG};
  use objectsDAO::descriptor::{backgroundCount, bodyCount, accessoryCount, headCount, glassesCount, ObjectsDescriptor,
    get_bodies, get_accessories, get_heads, get_glasses, get_backgrounds
  };
  use sui::display;
  use sui::event;
  use sui::object;
  use sui::object::UID;
  use sui::package;
  use sui::transfer;
  use sui::tx_context::{TxContext, sender};
  use sui::url;
  use sui::url::Url;


  const NAME: vector<u8> = b"Objects";
  const DESCRIPTION: vector<u8> = b"Object NFT";

  #[test_only]
  use objectsDAO::descriptor::{init_test, addColorsToPalette, addManyBackgrounds, addManyAccessories, addManyGlasses,
    addManyHeads, addManyBodies
  };
  #[test_only]
  use sui::test_scenario;
  #[test_only]
  use std::debug;
  #[test_only]
  use objectsDAO::descriptor;
  #[test_only]
  use sui::random;
  #[test_only]
  use sui::random::Random;

  struct Seed has store,copy, drop {
    background: u64,
    body: u64,
    accessory: u64,
    head: u64,
    glasses: u64
  }

  struct RandomEvent has copy,drop{
    value:u64
  }

  struct Objects has key,store {
      id:UID, /// Name for the token
      name: string::String,
      /// Description of the token
      description: string::String,
      /// URL for the token
      image_url: Url,
  }

  /// One-Time-Witness for the module.
  struct OBJECTS_SEEDER has drop {}


  fun init(otw: OBJECTS_SEEDER,ctx: &mut TxContext) {
    let keys = vector[
      string::utf8(b"name"),
      string::utf8(b"description"),
      string::utf8(b"project_url"),
      string::utf8(b"image_url"),
      string::utf8(b"creator"),
    ];

    let values = vector[
      // For `name` we can use the `Hero.name` property
      string::utf8(NAME),
      // Description is static for all `Hero` objects.
      string::utf8(DESCRIPTION),
      // Project URL is usually static
      string::utf8(b"https://objects.club/"),
      string::utf8(b"data:image/svg+xml;base64,{image_url}"),
      // Creator field can be any
      string::utf8(b"Objects Dao Developer")
    ];
    // Claim the `Publisher` for the package!
    let publisher = package::claim(otw, ctx);

    // Get a new `Display` object for the `Hero` type.
    let display = display::new_with_fields<Objects>(
      &publisher, keys, values, ctx
    );

    // Commit first version of `Display` to apply changes.
    display::update_version(&mut display);

    transfer::public_transfer(publisher, sender(ctx));
    transfer::public_transfer(display, sender(ctx));
  }

  public fun mint_nft(randomness: u64, objects_descriptor: &mut ObjectsDescriptor,ctx: &mut TxContext): Objects {
    let seed = generateSeed(randomness, objects_descriptor);
    let generate_svg_image = generateSVGImage(seed, objects_descriptor);

    let url_ascii = string::to_ascii(generate_svg_image);

    Objects {
      id: object::new(ctx),
      name:string::utf8(b"1"),
      description:string::utf8(b"1"),
      image_url:url::new_unsafe(url_ascii)
    }
  }

  public fun generateSeed(randomness: u64, objects_descriptor: &mut ObjectsDescriptor): Seed {
    event::emit(RandomEvent { value: randomness });
    let backgroundCount = backgroundCount(objects_descriptor);
    let bodyCount = bodyCount(objects_descriptor);
    let accessoryCount = accessoryCount(objects_descriptor);
    let headCount = headCount(objects_descriptor);
    let glassesCount = glassesCount(objects_descriptor);

    Seed {
      background: randomness % backgroundCount,
      body: randomness % bodyCount,
      accessory: randomness % accessoryCount,
      head: randomness % headCount,
      glasses: randomness % glassesCount
    }
  }

  public fun generateSVGImage(seed: Seed, objects_descriptor: &mut ObjectsDescriptor): String {
    let parts = getPartsForSeed_(seed, objects_descriptor);
    let backgrounds = get_backgrounds(objects_descriptor);
    let background = *vector::borrow(backgrounds, seed.background);

    let params = create_svg_params(parts, background);
    let svg = generateSVG(params, objects_descriptor);
    svg
  }

  fun getPartsForSeed_(seed: Seed, objects_descriptor: &ObjectsDescriptor): vector<String> {
    let bodies = get_bodies(objects_descriptor);
    let accessories = get_accessories(objects_descriptor);
    let heads = get_heads(objects_descriptor);
    let glasses = get_glasses(objects_descriptor);
    let body = *vector::borrow(bodies, seed.body);
    let accessory = *vector::borrow(accessories, seed.accessory);
    let head = *vector::borrow(heads, seed.head);
    let glasses = *vector::borrow(glasses, seed.glasses);
    let parts: vector<String> = vector[body, accessory, head, glasses];
    parts
  }

  // #[test]
  // fun test_generateSVGImage() {
  //   let scenario_val = test_scenario::begin(@0x0);
  //   let scenario = &mut scenario_val;
  //
  //   // setup random
  //   random::create_for_testing(test_scenario::ctx(scenario));
  //   test_scenario::next_tx(scenario, @0x0);
  //   let random = test_scenario::take_shared<Random>(scenario);
  //   random::update_randomness_state_for_testing(
  //     &mut random,
  //     0,
  //     x"1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F",
  //     test_scenario::ctx(scenario),
  //   );
  //     let random_generator = random::new_generator(&random, test_scenario::ctx(scenario));
  //     let randomness = random::generate_u64(&mut random_generator);
  //   debug::print(&randomness);
  //
  //   descriptor::init_test(test_scenario::ctx(scenario));
  //   test_scenario::next_tx(scenario, @0x1);
  //
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addColorsToPalette(&mut objects_descriptor);
  //   addManyBackgrounds(&mut objects_descriptor);
  //   addManyAccessories(&mut objects_descriptor);
  //   addManyBodies(&mut objects_descriptor);
  //   addManyGlasses(&mut objects_descriptor);
  //
  //
  //
  //   addManyHeads(heads, &mut objects_descriptor);
  //
  //   let seed = generateSeed(randomness, &mut objects_descriptor);
  //   let svg = generateSVGImage(seed, &mut objects_descriptor);
  //   debug::print(&svg);
  //
  //   // clock::destroy_for_testing(clock);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::return_shared(random);
  //   test_scenario::end(scenario_val);
  // }
}
