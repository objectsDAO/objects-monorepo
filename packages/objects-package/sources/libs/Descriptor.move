module objectsDAO::descriptor {
  use std::string::String;
  use std::vector;
  use sui::object;
  use sui::object::UID;
  use sui::table;
  use sui::table::Table;
  use sui::transfer;
  use sui::tx_context::TxContext;

  #[test_only]
  use sui::test_scenario;
  #[test_only]
  use sui::test_scenario::Scenario;
  #[test_only]
  use std::string;

  struct ObjectsDescriptor has key, store {
    id: UID,
    // Noun Color Palettes (Index => Hex Colors)
    palettes: Table<u8, vector<String>>,
    // Noun Backgrounds (Hex Colors)
    backgrounds: vector<String>,
    // Noun Bodies (Custom RLE)
    bodies: vector<String>,
    // Noun Accessories (Custom RLE)
    accessories: vector<String>,
    // Noun Heads (Custom RLE)
    heads: vector<String>,
    // Noun Glasses (Custom RLE)
    glasses: vector<String>
  }

  fun init(ctx: &mut TxContext) {
    let objects_descriptor = ObjectsDescriptor {
      id: object::new(ctx),
      // Noun Color Palettes (Index => Hex Colors)
      palettes: table::new<u8, vector<String>>(ctx),
      // Noun Backgrounds (Hex Colors)
      backgrounds: vector::empty<String>(),
      // Noun Bodies (Custom RLE)
      bodies: vector::empty<String>(),
      // Noun Accessories (Custom RLE)
      accessories: vector::empty<String>(),
      // Noun Heads (Custom RLE)
      heads: vector::empty<String>(),
      // Noun Glasses (Custom RLE)
      glasses: vector::empty<String>(),
    };
    // Transfer the forge object to the module/package publisher
    transfer::public_share_object(objects_descriptor);
  }

  /**
  * @notice Get the number of available Noun `backgrounds`.
  */
  public fun backgroundCount(objects_descriptor: &mut ObjectsDescriptor): u256 {
    (vector::length(&objects_descriptor.backgrounds) as u256)
  }

  /**
   * @notice Get the number of available Noun `bodies`.
   */
  public fun bodyCount(objects_descriptor: &mut ObjectsDescriptor): u256 {
    (vector::length(&objects_descriptor.bodies) as u256)
  }

  /**
   * @notice Get the number of available Noun `accessories`.
   */
  public fun accessoryCount(objects_descriptor: &mut ObjectsDescriptor): u256 {
    (vector::length(&objects_descriptor.accessories) as u256)
  }

  /**
   * @notice Get the number of available Noun `heads`.
   */
  public fun headCount(objects_descriptor: &mut ObjectsDescriptor): u256 {
    (vector::length(&objects_descriptor.heads) as u256)
  }

  /**
   * @notice Get the number of available Noun `glasses`.
   */
  public fun glassesCount(objects_descriptor: &ObjectsDescriptor): u256 {
    (vector::length(&objects_descriptor.glasses) as u256)
  }

  public fun get_palettes(objects_descriptor: &ObjectsDescriptor): &Table<u8, vector<String>> {
    &objects_descriptor.palettes
  }

  public fun get_mut_palettes(objects_descriptor: &mut ObjectsDescriptor): &mut Table<u8, vector<String>> {
    &mut objects_descriptor.palettes
  }

  public fun get_backgrounds(objects_descriptor: &ObjectsDescriptor): &vector<String> {
    &objects_descriptor.backgrounds
  }

  public fun get_bodies(objects_descriptor: &ObjectsDescriptor): &vector<String> {
    &objects_descriptor.bodies
  }

  public fun get_accessories(objects_descriptor: &ObjectsDescriptor): &vector<String> {
    &objects_descriptor.accessories
  }

  public fun get_heads(objects_descriptor: &ObjectsDescriptor): &vector<String> {
    &objects_descriptor.heads
  }

  public fun get_glasses(objects_descriptor: &ObjectsDescriptor): &vector<String> {
    &objects_descriptor.glasses
  }

  public entry fun addColorsToPalette(
    paletteIndex: u8,
    newColors: vector<String>,
    objects_descriptor: &mut ObjectsDescriptor
  ) {
    let palettes_length = table::length<u8, vector<String>>(&objects_descriptor.palettes);
    let newColors_length = vector::length(&newColors);
    let length = palettes_length + newColors_length;
    assert!(length <= 256u64, 1);
    let i = 0;
    while (i < newColors_length) {
      let new_color = *vector::borrow(&newColors, i);
      // debug::print(&paletteIndex);
      addColorToPalette(paletteIndex, new_color, objects_descriptor);
      i = i + 1
    }
  }

  public entry fun addManyBackgrounds(backgrounds: vector<String>, objects_descriptor: &mut ObjectsDescriptor) {
    let backgrounds_length = vector::length(&backgrounds);
    let i = 0;
    while (i < backgrounds_length) {
      let background = *vector::borrow(&backgrounds, i);
      addBackground(background, objects_descriptor);
      i = i + 1
    }
  }
  /**
   * @notice Batch add Noun accessories.
   * @dev This function can only be called by the owner when not locked.
   */
  public entry fun addManyAccessories(accessories: vector<String>, objects_descriptor: &mut ObjectsDescriptor) {
    let accessories_length = vector::length(&accessories);
    let i = 0;
    while (i < accessories_length) {
      let access = *vector::borrow(&accessories, i);
      addAccessory(access, objects_descriptor);
      i = i + 1
    }
  }

  /**
   * @notice Batch add Noun bodies.
   * @dev This function can only be called by the owner when not locked.
   */
  public entry fun addManyBodies(bodies: vector<String>, objects_descriptor: &mut ObjectsDescriptor) {
    let bodies_length = vector::length(&bodies);
    let i = 0;
    while (i < bodies_length) {
      let body = *vector::borrow(&bodies, i);
      // debug::print(&string::utf8(b"body"));
      // debug::print(&body);
      addBody(body, objects_descriptor);
      i = i + 1
    }
  }

  /**
   * @notice Batch add Noun heads.
   * @dev This function can only be called by the owner when not locked.
   */
  public entry fun addManyHeads(heads: vector<String>, objects_descriptor: &mut ObjectsDescriptor) {
    let heads_length = vector::length(&heads);
    let i = 0;
    while (i < heads_length) {
      let head = *vector::borrow(&heads, i);
      addHead(head, objects_descriptor);
      i = i + 1
    }
  }

  /**
   * @notice Batch add Noun glasses.
   * @dev This function can only be called by the owner when not locked.
   */
  public entry fun addManyGlasses(glasses: vector<String>, objects_descriptor: &mut ObjectsDescriptor) {
    let glasses_length = vector::length(&glasses);
    let i = 0;
    while (i < glasses_length) {
      let glass = *vector::borrow(&glasses, i);
      addGlasses(glass, objects_descriptor);
      i = i + 1
    }
  }

  /**
   * @notice Add a single color to a color palette.
   */
  public fun addColorToPalette(paletteIndex: u8, color: String, objects_descriptor: &mut ObjectsDescriptor) {
    let bool = table::contains(&objects_descriptor.palettes, paletteIndex);
    if (bool) {
      let colors = table::borrow_mut(&mut objects_descriptor.palettes, paletteIndex);
      vector::push_back(colors, color);
    }else {
      let colors = vector[color];
      table::add<u8, vector<String>>(&mut objects_descriptor.palettes, paletteIndex, colors)
    }
  }

  /**
   * @notice Add a Noun background.
   */
  public fun addBackground(background: String, objects_descriptor: &mut ObjectsDescriptor) {
    // let i = vector::length(&objects_descriptor.backgrounds);
    // vector::insert(&mut objects_descriptor.backgrounds, background, i);

    vector::push_back(&mut objects_descriptor.backgrounds, background);
  }

  /**
   * @notice Add a Noun body.
   */
  public fun addBody(body: String, objects_descriptor: &mut ObjectsDescriptor) {
    // let i = vector::length(&objects_descriptor.bodies);
    // vector::insert(&mut objects_descriptor.bodies, body, i);
    // let body = hex::decode(body);
    vector::push_back(&mut objects_descriptor.bodies, body);
  }

  /**
   * @notice Add a Noun accessory.
   */
  public fun addAccessory(accessory: String, objects_descriptor: &mut ObjectsDescriptor) {
    // let i = vector::length(&objects_descriptor.accessories);
    // vector::insert(&mut objects_descriptor.accessories, accessory, i);
    vector::push_back(&mut objects_descriptor.accessories, accessory);
  }

  /**
   * @notice Add a Noun head.
   */
  public fun addHead(head: String, objects_descriptor: &mut ObjectsDescriptor) {
    // let i = vector::length(&objects_descriptor.heads);
    // vector::insert(&mut objects_descriptor.heads, head, i);
    vector::push_back(&mut objects_descriptor.heads, head);
  }

  /**
   * @notice Add Noun glasses.
   */
  public fun addGlasses(glasses: String, objects_descriptor: &mut ObjectsDescriptor) {
    // let i = vector::length(&objects_descriptor.glasses);
    // vector::insert(&mut objects_descriptor.glasses, glasses, i);
    vector::push_back(&mut objects_descriptor.glasses, glasses);
  }

  #[test_only]
  public fun init_test(): Scenario {
    let scenario_val = test_scenario::begin(@0x0001);
    let scenario = &mut scenario_val;
    {
      let ctx = test_scenario::ctx(scenario);
      init(ctx);
    };
    test_scenario::next_tx(scenario, @0x0001);
    scenario_val
  }






  #[test]
  fun test_addColorsToPalette() {
    let scenario_val = init_test();
    let scenario = &mut scenario_val;
    let colors: vector<String> = vector[
      string::utf8(b""),
      string::utf8(b"ffffff")
    ];
    let paletteIndex: u8 = 0u8;
    {
      let ctx = test_scenario::ctx(scenario);
      init(ctx)
    };
    test_scenario::next_tx(scenario, @0x0001);
    let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
    addColorsToPalette(paletteIndex, colors, &mut objects_descriptor);
    test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
    test_scenario::end(scenario_val);
  }


  // #[test]
  // fun test_addManyBackgrounds() {
  //   let scenario_val = init_test();
  //   let scenario = &mut scenario_val;
  //   let backgrounds: vector<String> = vector[
  //     string::utf8(b""),
  //     string::utf8(b"ffffff")
  //   ];
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addManyBackgrounds(backgrounds, &mut objects_descriptor);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::end(scenario_val);
  // }
  //
  //
  // #[test]
  // fun test_addManyAccessories() {
  //   let scenario_val = init_test();
  //   let scenario = &mut scenario_val;
  //   let accessories: vector<String> = vector[
  //     b"",
  //     b"ffffff"
  //   ];
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addManyAccessories(accessories, &mut objects_descriptor);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::end(scenario_val);
  // }
  //
  // #[test]
  // fun test_addManyBodies() {
  //   let scenario_val = init_test();
  //   let scenario = &mut scenario_val;
  //   let bodys: vector<String> = vector[
  //     b"",
  //     b"ffffff"
  //   ];
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addManyBodies(bodys, &mut objects_descriptor);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::end(scenario_val);
  // }
  //
  //
  // #[test]
  // fun test_addManyHeads() {
  //   let scenario_val = init_test();
  //   let scenario = &mut scenario_val;
  //   let heads: vector<String> = vector[
  //     b"",
  //     b"ffffff"
  //   ];
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addManyHeads(heads, &mut objects_descriptor);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::end(scenario_val);
  // }
  //
  // #[test]
  // fun test_addManyGlasses() {
  //   let scenario_val = init_test();
  //   let scenario = &mut scenario_val;
  //   let glasses: vector<String> = vector[
  //     b"",
  //     b"ffffff"
  //   ];
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addManyGlasses(glasses, &mut objects_descriptor);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::end(scenario_val);
  // }
}
