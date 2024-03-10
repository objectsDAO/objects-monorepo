module objectsDAO::descriptor {
  use std::signer;
  use std::string::String;
  use std::vector;
  use aptos_std::table_with_length;
  use aptos_std::table_with_length::TableWithLength;
  use aptos_framework::object;
  use aptos_framework::object::{Object, object_from_constructor_ref};

  // #[test_only]
  // use sui::test_scenario;
  // #[test_only]
  // use sui::test_scenario::Scenario;
  // #[test_only]
  // use std::string;
  //

  #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
  struct ObjectsDescriptor has key,store {
    // Objects Color Palettes (Index => Hex Colors)
    palettes: TableWithLength<String, vector<String>>,
    // Objects Backgrounds (Hex Colors)
    backgrounds: vector<String>,
    // Objects Bodies (Custom RLE)
    bodies: vector<String>,
    // Objects Mouths (Custom RLE)
    mouths: vector<String>,
    // Objects Decoration (Custom RLE)
    decorations: vector<String>,
    // Objects Masks (Custom RLE)
    masks: vector<String>
  }

  fun init(deployer: &signer) {
    let objects_descriptor = ObjectsDescriptor {
      // Objects Color Palettes (Index => Hex Colors)
      palettes:table_with_length::new<String, vector<String>>(),
      // Objects Backgrounds (Hex Colors)
      backgrounds: vector::empty<String>(),
      // Objects Bodies (Custom RLE)
      bodies: vector::empty<String>(),
      // Objects Accessories (Custom RLE)
      mouths: vector::empty<String>(),
      // Objects Heads (Custom RLE)
      decorations: vector::empty<String>(),
      // Objects Glasses (Custom RLE)
      masks: vector::empty<String>(),
    };
    let caller_address = signer::address_of(deployer);
    // Creates the object
    let constructor_ref = object::create_object(caller_address);
    // Retrieves a signer for the object
    let object_signer = object::generate_signer(&constructor_ref);
    // Moves the MyStruct resource into the object
    move_to(&object_signer, objects_descriptor);

  }

  /**
  * @notice Get the number of available Objects `backgrounds`.
  */
  public fun backgroundCount(objects_descriptor: &Object<ObjectsDescriptor>): u256 acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let backgrounds = borrow_global<ObjectsDescriptor>(object_address).backgrounds;
    (vector::length(&backgrounds) as u256)
  }

  /**
   * @notice Get the number of available Objects `bodies`.
   */
  public fun bodyCount(objects_descriptor: &Object<ObjectsDescriptor>): u256 acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let bodies = borrow_global<ObjectsDescriptor>(object_address).bodies;
    (vector::length(&bodies) as u256)
  }

  /**
   * @notice Get the number of available Objects `mouths`.
   */
  public fun mouthsCount(objects_descriptor: &Object<ObjectsDescriptor>): u256 acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let mouths = borrow_global<ObjectsDescriptor>(object_address).mouths;
    (vector::length(&mouths) as u256)
  }

  /**
   * @notice Get the number of available Objects `decoration`.
   */
  public fun decorationsCount(objects_descriptor: &Object<ObjectsDescriptor>): u256 acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let decorations = borrow_global<ObjectsDescriptor>(object_address).decorations;
    (vector::length(&decorations) as u256)
  }

  /**
   * @notice Get the number of available Objects `masks`.
   */
  public fun masksCount(objects_descriptor: &Object<ObjectsDescriptor>): u256 acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let masks = borrow_global<ObjectsDescriptor>(object_address).masks;
    (vector::length(&masks) as u256)
  }

  // get

  public fun get_palettes(objects_descriptor: &Object<ObjectsDescriptor>): TableWithLength<String, vector<String>> acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let palettes = borrow_global<ObjectsDescriptor>(object_address).palettes;
    palettes
  }

  public fun get_backgrounds(objects_descriptor: &Object<ObjectsDescriptor>): vector<String> acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let backgrounds = borrow_global<ObjectsDescriptor>(object_address).backgrounds;
    backgrounds
  }

  public fun get_bodies(objects_descriptor: &Object<ObjectsDescriptor>): vector<String> acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let bodies = borrow_global<ObjectsDescriptor>(object_address).bodies;
    bodies
  }

  public fun get_mouths(objects_descriptor: &Object<ObjectsDescriptor>): vector<String> acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let mouths = borrow_global<ObjectsDescriptor>(object_address).mouths;
    mouths
  }

  public fun get_decoration(objects_descriptor: &Object<ObjectsDescriptor>): vector<String> acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let decorations = borrow_global<ObjectsDescriptor>(object_address).decorations;
    decorations
  }

  public fun get_masks(objects_descriptor: &Object<ObjectsDescriptor>): vector<String> acquires ObjectsDescriptor {
    let object_address = object::object_address(objects_descriptor);
    let masks = borrow_global<ObjectsDescriptor>(object_address).masks;
    masks
  }
  //
  // public entry fun addColorsToPalette(
  //   paletteIndex: u8,
  //   newColors: vector<String>,
  //   objects_descriptor: &mut Object<ObjectsDescriptor>
  // ) acquires ObjectsDescriptor {
  //   let object_address = object::object_address(objects_descriptor);
  //   let palettes = borrow_global_mut<ObjectsDescriptor>(object_address).palettes;
  //   let palettes_length = table_with_length::length(&palettes);
  //   let newColors_length = vector::length(&newColors);
  //   let length = palettes_length + newColors_length;
  //   // assert!(length <= 1000u64, 1);
  //   let i = 0;
  //   while (i < newColors_length) {
  //     let new_color = *vector::borrow(&newColors, i);
  //     // debug::print(&paletteIndex);
  //     addColorToPalette(paletteIndex, new_color, objects_descriptor);
  //     i = i + 1
  //   }
  // }
  //
  // public entry fun addManyBackgrounds(backgrounds: vector<String>, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let backgrounds_length = vector::length(&backgrounds);
  //   let i = 0;
  //   while (i < backgrounds_length) {
  //     let background = *vector::borrow(&backgrounds, i);
  //     addBackground(background, objects_descriptor);
  //     i = i + 1
  //   }
  // }
  //
  //
  // /**
  //  * @notice Batch add Objects bodies.
  //  * @dev This function can only be called by the owner when not locked.
  //  */
  // public entry fun addManyBodies(bodies: vector<String>, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let bodies_length = vector::length(&bodies);
  //   let i = 0;
  //   while (i < bodies_length) {
  //     let body = *vector::borrow(&bodies, i);
  //     // debug::print(&string::utf8(b"body"));
  //     // debug::print(&body);
  //     addBody(body, objects_descriptor);
  //     i = i + 1
  //   }
  // }
  //
  // /**
  // * @notice Batch add Objects mouths.
  // * @dev This function can only be called by the owner when not locked.
  // */
  // public entry fun addManyMouths(mouths: vector<String>, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let mouths_length = vector::length(&mouths);
  //   let i = 0;
  //   while (i < mouths_length) {
  //     let mouths = *vector::borrow(&mouths, i);
  //     addMouth(mouths, objects_descriptor);
  //     i = i + 1
  //   }
  // }
  //
  // /**
  //  * @notice Batch add Objects decoration.
  //  * @dev This function can only be called by the owner when not locked.
  //  */
  // public entry fun addManyDecorations(decoration: vector<String>, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let decoration_length = vector::length(&decoration);
  //   let i = 0;
  //   while (i < decoration_length) {
  //     let decoration = *vector::borrow(&decoration, i);
  //     addDecoration(decoration, objects_descriptor);
  //     i = i + 1
  //   }
  // }
  //
  // /**
  //  * @notice Batch add Objects masks.
  //  * @dev This function can only be called by the owner when not locked.
  //  */
  // public entry fun addManyMasks(masks: vector<String>, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let masks_length = vector::length(&masks);
  //   let i = 0;
  //   while (i < masks_length) {
  //     let mask = *vector::borrow(&masks, i);
  //     addMasks(mask, objects_descriptor);
  //     i = i + 1
  //   }
  // }
  //
  // /**
  //  * @notice Add a single color to a color palette.
  //  */
  // public fun addColorToPalette(paletteIndex: u8, color: String, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let object_address = object::object_address(objects_descriptor);
  //   let palettes = borrow_global_mut<ObjectsDescriptor>(object_address).palettes;
  //   let bool = table_with_length::contains(&palettes,paletteIndex);
  //   if (bool) {
  //     let colors = table_with_length::borrow_mut(&mut palettes,paletteIndex);
  //     vector::push_back(colors, color);
  //   }else {
  //     let colors = vector[color];
  //     table_with_length::add<u8, vector<String>>(&mut palettes,paletteIndex, colors);
  //   }
  // }
  //
  // /**
  //  * @notice Add a Objects background.
  //  */
  // public fun addBackground(background: String, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let object_address = object::object_address(objects_descriptor);
  //   let backgrounds = borrow_global_mut<ObjectsDescriptor>(object_address).backgrounds;
  //   vector::push_back(&mut backgrounds, background);
  // }
  //
  // /**
  //  * @notice Add a Objects body.
  //  */
  // public fun addBody(body: String, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let object_address = object::object_address(objects_descriptor);
  //   let bodies = borrow_global_mut<ObjectsDescriptor>(object_address).bodies;
  //   vector::push_back(&mut bodies, body);
  // }
  //
  // /**
  //  * @notice Add a Objects mouth.
  //  */
  // public fun addMouth(mouth: String, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let object_address = object::object_address(objects_descriptor);
  //   let mouths = borrow_global_mut<ObjectsDescriptor>(object_address).mouths;
  //   vector::push_back(&mut mouths, mouth);
  // }
  //
  // /**
  //  * @notice Add a Objects head.
  //  */
  // public fun addDecoration(decoration: String, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let object_address = object::object_address(objects_descriptor);
  //   let decorations = borrow_global_mut<ObjectsDescriptor>(object_address).decorations;
  //   vector::push_back(&mut decorations, decoration);
  // }
  //
  // /**
  //  * @notice Add Objects masks.
  //  */
  // public fun addMasks(mask: String, objects_descriptor: &mut Object<ObjectsDescriptor>) acquires ObjectsDescriptor {
  //   let object_address = object::object_address(objects_descriptor);
  //   let masks = borrow_global_mut<ObjectsDescriptor>(object_address).masks;
  //   vector::push_back(&mut masks, mask);
  // }

  // #[test_only]
  // public fun init_test(): Scenario {
  //   let scenario_val = test_scenario::begin(@0x0001);
  //   let scenario = &mut scenario_val;
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx);
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   scenario_val
  // }
  //
  //
  //
  //
  //
  //
  // #[test]
  // fun test_addColorsToPalette() {
  //   let scenario_val = init_test();
  //   let scenario = &mut scenario_val;
  //   let colors: vector<String> = vector[
  //     string::utf8(b""),
  //     string::utf8(b"ffffff")
  //   ];
  //   let paletteIndex: u8 = 0u8;
  //   {
  //     let ctx = test_scenario::ctx(scenario);
  //     init(ctx)
  //   };
  //   test_scenario::next_tx(scenario, @0x0001);
  //   let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);
  //   addColorsToPalette(paletteIndex, colors, &mut objects_descriptor);
  //   test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
  //   test_scenario::end(scenario_val);
  // }


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
