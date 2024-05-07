module objectsDAO::objects_seeder {
  use std::ascii;
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
      string::utf8(b"Objects {name}"),
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

  public fun mint_nft(nft_id: u64, randomness: u64, objects_descriptor: &mut ObjectsDescriptor,ctx: &mut TxContext): Objects {
    let seed = generateSeed(randomness, objects_descriptor);
    let generate_svg_image = generateSVGImage(seed, objects_descriptor);

    let url_ascii = string::to_ascii(generate_svg_image);

    Objects {
      id: object::new(ctx),
      name:string::utf8(ascii::into_bytes(to_string((nft_id as u128)))),
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

  /// Converts a `u128` to its `ascii::String` decimal representation.
  fun to_string(value: u128): ascii::String {
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
}
