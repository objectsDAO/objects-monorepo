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
    mouths: vector<String>,
    // Noun Heads (Custom RLE)
    decoration: vector<String>,
    // Noun Glasses (Custom RLE)
    masks: vector<String>
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
      mouths: vector::empty<String>(),
      // Noun Heads (Custom RLE)
      decoration: vector::empty<String>(),
      // Noun Glasses (Custom RLE)
      masks: vector::empty<String>(),
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
   * @notice Get the number of available Noun `mouths`.
   */
  public fun mouthsCount(objects_descriptor: &mut ObjectsDescriptor): u256 {
    (vector::length(&objects_descriptor.mouths) as u256)
  }

  /**
   * @notice Get the number of available Noun `decoration`.
   */
  public fun decorationsCount(objects_descriptor: &mut ObjectsDescriptor): u256 {
    (vector::length(&objects_descriptor.decoration) as u256)
  }

  /**
   * @notice Get the number of available Noun `masks`.
   */
  public fun masksCount(objects_descriptor: &ObjectsDescriptor): u256 {
    (vector::length(&objects_descriptor.masks) as u256)
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

  public fun get_mouths(objects_descriptor: &ObjectsDescriptor): &vector<String> {
    &objects_descriptor.mouths
  }

  public fun get_decoration(objects_descriptor: &ObjectsDescriptor): &vector<String> {
    &objects_descriptor.decoration
  }

  public fun get_masks(objects_descriptor: &ObjectsDescriptor): &vector<String> {
    &objects_descriptor.masks
  }

  public entry fun addColorsToPalette(
    paletteIndex: u8,
    newColors: vector<String>,
    objects_descriptor: &mut ObjectsDescriptor
  ) {
    let palettes_length = table::length<u8, vector<String>>(&objects_descriptor.palettes);
    let newColors_length = vector::length(&newColors);
    let length = palettes_length + newColors_length;
    // assert!(length <= 1000u64, 1);
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
  * @notice Batch add Noun mouths.
  * @dev This function can only be called by the owner when not locked.
  */
  public entry fun addManyMouths(mouths: vector<String>, objects_descriptor: &mut ObjectsDescriptor) {
    let mouths_length = vector::length(&mouths);
    let i = 0;
    while (i < mouths_length) {
      let mouths = *vector::borrow(&mouths, i);
      addMouth(mouths, objects_descriptor);
      i = i + 1
    }
  }

  /**
   * @notice Batch add Noun decoration.
   * @dev This function can only be called by the owner when not locked.
   */
  public entry fun addManyDecorations(decoration: vector<String>, objects_descriptor: &mut ObjectsDescriptor) {
    let decoration_length = vector::length(&decoration);
    let i = 0;
    while (i < decoration_length) {
      let decoration = *vector::borrow(&decoration, i);
      addDecoration(decoration, objects_descriptor);
      i = i + 1
    }
  }

  /**
   * @notice Batch add Noun masks.
   * @dev This function can only be called by the owner when not locked.
   */
  public entry fun addManyMasks(masks: vector<String>, objects_descriptor: &mut ObjectsDescriptor) {
    let masks_length = vector::length(&masks);
    let i = 0;
    while (i < masks_length) {
      let masks = *vector::borrow(&masks, i);
      addMasks(masks, objects_descriptor);
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
    vector::push_back(&mut objects_descriptor.backgrounds, background);
  }

  /**
   * @notice Add a Noun body.
   */
  public fun addBody(body: String, objects_descriptor: &mut ObjectsDescriptor) {
    vector::push_back(&mut objects_descriptor.bodies, body);
  }

  /**
   * @notice Add a Noun mouth.
   */
  public fun addMouth(mouth: String, objects_descriptor: &mut ObjectsDescriptor) {
    vector::push_back(&mut objects_descriptor.mouths, mouth);
  }

  /**
   * @notice Add a Noun head.
   */
  public fun addDecoration(decoration: String, objects_descriptor: &mut ObjectsDescriptor) {
    vector::push_back(&mut objects_descriptor.decoration, decoration);
  }

  /**
   * @notice Add Noun masks.
   */
  public fun addMasks(masks: String, objects_descriptor: &mut ObjectsDescriptor) {
    vector::push_back(&mut objects_descriptor.masks, masks);
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
  //   let mouths: vector<String> = vector[
  //     b"",
  //     b"ffffff"
  //   ];
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addManyAccessories(mouths, &mut objects_descriptor);
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
  //   let decoration: vector<String> = vector[
  //     b"",
  //     b"ffffff"
  //   ];
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addManyHeads(decoration, &mut objects_descriptor);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::end(scenario_val);
  // }
  //
  // #[test]
  // fun test_addManyGlasses() {
  //   let scenario_val = init_test();
  //   let scenario = &mut scenario_val;
  //   let masks: vector<String> = vector[
  //     b"",
  //     b"ffffff"
  //   ];
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addManyGlasses(masks, &mut objects_descriptor);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::end(scenario_val);
  // }
}
