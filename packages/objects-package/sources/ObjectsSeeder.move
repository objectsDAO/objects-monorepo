module objectsDAO::ObjectsSeeder {
  use std::debug;
  use std::string::String;
  use std::vector;
  use objectsDAO::MultiPartRLEToSVG::{create_svg_params, generateSVG};
  use objectsDAO::Descriptor::{backgroundCount, bodyCount, accessoryCount, headCount, glassesCount, ObjectsDescriptor,
    get_bodies, get_accessories, get_heads, get_glasses, get_backgrounds
  };
  use sui::clock;
  use sui::clock::Clock;
  use sui::event;

  #[test_only]
  use std::string;

  #[test_only]
  use objectsDAO::Descriptor::{init_test, addColorsToPalette, addManyBackgrounds, addManyAccessories, addManyGlasses,
    addManyHeads, addManyBodies
  };

  #[test_only]
  use sui::test_scenario;


  struct Seed has copy, drop {
    background: u64,
    body: u64,
    accessory: u64,
    head: u64,
    glasses: u64
  }

  struct SVG has copy, drop {
    svg: String
  }

  public entry fun mint(object_id: u256, clock: &Clock, objects_descriptor: &mut ObjectsDescriptor) {
    let seed = generateSeed(object_id, clock, objects_descriptor);
    let generate_svg_image = generateSVGImage(seed, objects_descriptor);
    event::emit(SVG {
      svg: generate_svg_image
    })
  }


  fun generateSeed(object_id: u256, clock: &Clock, objects_descriptor: &mut ObjectsDescriptor): Seed {
    let randomness = (clock::timestamp_ms(clock) as u256) + object_id;

    let backgroundCount = backgroundCount(objects_descriptor);
    let bodyCount = bodyCount(objects_descriptor);
    let accessoryCount = accessoryCount(objects_descriptor);
    let headCount = headCount(objects_descriptor);
    let glassesCount = glassesCount(objects_descriptor);
    // debug::print(&b"randomness");
    // debug::print(&randomness);
    Seed {
      background: (((randomness) % backgroundCount) as u64),
      body: (((randomness) % bodyCount) as u64),
      accessory: (((randomness >> 96) % accessoryCount) as u64),
      head: (((randomness >> 144) % headCount) as u64),
      glasses: (((randomness >> 192) % glassesCount) as u64)
    }
  }

  fun generateSVGImage(seed: Seed, objects_descriptor: &ObjectsDescriptor): String {
    let parts = getPartsForSeed_(seed, objects_descriptor);
    let backgrounds = get_backgrounds(objects_descriptor);
    let background = *vector::borrow(backgrounds, seed.background);
    // debug::print(&b"background");
    // debug::print(&background);
    let params = create_svg_params(parts, background);
    // debug::print(&b"params");
    // debug::print(&params);
    let svg = generateSVG(params, objects_descriptor);
    svg
  }

  fun getPartsForSeed_(seed: Seed, objects_descriptor: &ObjectsDescriptor): vector<vector<u8>> {
    let bodies = get_bodies(objects_descriptor);
    let accessories = get_accessories(objects_descriptor);
    let heads = get_heads(objects_descriptor);
    let glasses = get_glasses(objects_descriptor);

    let body = *vector::borrow(bodies, seed.body);
    let accessory = *vector::borrow(accessories, seed.accessory);
    let head = *vector::borrow(heads, seed.head);
    let glasses = *vector::borrow(glasses, seed.glasses);

    let parts: vector<vector<u8>> = vector[body, accessory, head, glasses];
    parts
  }


  #[test]
  fun testSeed() {
    let scenario_val = init_test();
    let scenario = &mut scenario_val;
    let object_id: u256 = 1u256;

    let clock = clock::create_for_testing(test_scenario::ctx(scenario));


    let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);


    let colors: vector<String> = vector[
      string::utf8(b""),
      string::utf8(b"ffffff"),
      string::utf8(b"c5b9a1"),
      string::utf8(b"cfc2ab"),
      string::utf8(b"63a0f9"),
      string::utf8(b"807f7e"),
      string::utf8(b"caeff9"),
      string::utf8(b"5648ed"),
      string::utf8(b"5a423f"),
      string::utf8(b"b9185c"),
      string::utf8(b"b87b11"),
      string::utf8(b"fffdf2"),
      string::utf8(b"4b4949"),
      string::utf8(b"343235"),
      string::utf8(b"1f1d29"),
      string::utf8(b"068940"),
      string::utf8(b"867c1d"),
      string::utf8(b"ae3208"),
      string::utf8(b"9f21a0"),
      string::utf8(b"f98f30"),
      string::utf8(b"fe500c"),
      string::utf8(b"d26451"),
      string::utf8(b"fd8b5b"),
      string::utf8(b"5a65fa"),
      string::utf8(b"d22209"),
      string::utf8(b"e9265c"),
      string::utf8(b"c54e38"),
      string::utf8(b"80a72d"),
      string::utf8(b"4bea69"),
      string::utf8(b"34ac80"),
      string::utf8(b"eed811"),
      string::utf8(b"62616d"),
      string::utf8(b"ff638d"),
      string::utf8(b"8bc0c5"),
      string::utf8(b"c4da53"),
      string::utf8(b"000000"),
      string::utf8(b"f3322c"),
      string::utf8(b"ffae1a"),
      string::utf8(b"ffc110"),
      string::utf8(b"505a5c"),
      string::utf8(b"ffef16"),
      string::utf8(b"fff671"),
      string::utf8(b"fff449"),
      string::utf8(b"db8323"),
      string::utf8(b"df2c39"),
      string::utf8(b"f938d8"),
      string::utf8(b"5c25fb"),
      string::utf8(b"2a86fd"),
      string::utf8(b"45faff"),
      string::utf8(b"38dd56"),
      string::utf8(b"ff3a0e"),
      string::utf8(b"d32a09"),
      string::utf8(b"903707"),
      string::utf8(b"6e3206"),
      string::utf8(b"552e05"),
      string::utf8(b"e8705b"),
      string::utf8(b"f38b7c"),
      string::utf8(b"e4a499"),
      string::utf8(b"667af9"),
      string::utf8(b"648df9"),
      string::utf8(b"7cc4f2"),
      string::utf8(b"97f2fb"),
      string::utf8(b"a3efd0"),
      string::utf8(b"87e4d9"),
      string::utf8(b"71bde4"),
      string::utf8(b"ff1a0b"),
      string::utf8(b"f78a18"),
      string::utf8(b"2b83f6"),
      string::utf8(b"d62149"),
      string::utf8(b"834398"),
      string::utf8(b"ffc925"),
      string::utf8(b"d9391f"),
      string::utf8(b"bd2d24"),
      string::utf8(b"ff7216"),
      string::utf8(b"254efb"),
      string::utf8(b"e5e5de"),
      string::utf8(b"00a556"),
      string::utf8(b"c5030e"),
      string::utf8(b"abf131"),
      string::utf8(b"fb4694"),
      string::utf8(b"e7a32c"),
      string::utf8(b"fff0ee"),
      string::utf8(b"009c59"),
      string::utf8(b"0385eb"),
      string::utf8(b"00499c"),
      string::utf8(b"e11833"),
      string::utf8(b"26b1f3"),
      string::utf8(b"fff0be"),
      string::utf8(b"d8dadf"),
      string::utf8(b"d7d3cd"),
      string::utf8(b"1929f4"),
      string::utf8(b"eab118"),
      string::utf8(b"0b5027"),
      string::utf8(b"f9f5cb"),
      string::utf8(b"cfc9b8"),
      string::utf8(b"feb9d5"),
      string::utf8(b"f8d689"),
      string::utf8(b"5d6061"),
      string::utf8(b"76858b"),
      string::utf8(b"757576"),
      string::utf8(b"ff0e0e"),
      string::utf8(b"0adc4d"),
      string::utf8(b"fdf8ff"),
      string::utf8(b"70e890"),
      string::utf8(b"f7913d"),
      string::utf8(b"ff1ad2"),
      string::utf8(b"ff82ad"),
      string::utf8(b"535a15"),
      string::utf8(b"fa6fe2"),
      string::utf8(b"ffe939"),
      string::utf8(b"ab36be"),
      string::utf8(b"adc8cc"),
      string::utf8(b"604666"),
      string::utf8(b"f20422"),
      string::utf8(b"abaaa8"),
      string::utf8(b"4b65f7"),
      string::utf8(b"a19c9a"),
      string::utf8(b"58565c"),
      string::utf8(b"da42cb"),
      string::utf8(b"027c92"),
      string::utf8(b"cec189"),
      string::utf8(b"909b0e"),
      string::utf8(b"74580d"),
      string::utf8(b"027ee6"),
      string::utf8(b"b2958d"),
      string::utf8(b"efad81"),
      string::utf8(b"7d635e"),
      string::utf8(b"eff2fa"),
      string::utf8(b"6f597a"),
      string::utf8(b"d4b7b2"),
      string::utf8(b"d18687"),
      string::utf8(b"cd916d"),
      string::utf8(b"6b3f39"),
      string::utf8(b"4d271b"),
      string::utf8(b"85634f"),
      string::utf8(b"f9f4e6"),
      string::utf8(b"f8ddb0"),
      string::utf8(b"b92b3c"),
      string::utf8(b"d08b11"),
      string::utf8(b"257ced"),
      string::utf8(b"a3baed"),
      string::utf8(b"5fd4fb"),
      string::utf8(b"c16710"),
      string::utf8(b"a28ef4"),
      string::utf8(b"3a085b"),
      string::utf8(b"67b1e3"),
      string::utf8(b"1e3445"),
      string::utf8(b"ffd067"),
      string::utf8(b"962236"),
      string::utf8(b"769ca9"),
      string::utf8(b"5a6b7b"),
      string::utf8(b"7e5243"),
      string::utf8(b"a86f60"),
      string::utf8(b"8f785e"),
      string::utf8(b"cc0595"),
      string::utf8(b"42ffb0"),
      string::utf8(b"d56333"),
      string::utf8(b"b8ced2"),
      string::utf8(b"b91b43"),
      string::utf8(b"f39713"),
      string::utf8(b"e8e8e2"),
      string::utf8(b"ec5b43"),
      string::utf8(b"235476"),
      string::utf8(b"b2a8a5"),
      string::utf8(b"d6c3be"),
      string::utf8(b"49b38b"),
      string::utf8(b"fccf25"),
      string::utf8(b"f59b34"),
      string::utf8(b"375dfc"),
      string::utf8(b"99e6de"),
      string::utf8(b"27a463"),
      string::utf8(b"554543"),
      string::utf8(b"b19e00"),
      string::utf8(b"d4a015"),
      string::utf8(b"9f4b27"),
      string::utf8(b"f9e8dd"),
      string::utf8(b"6b7212"),
      string::utf8(b"9d8e6e"),
      string::utf8(b"4243f8"),
      string::utf8(b"fa5e20"),
      string::utf8(b"f82905"),
      string::utf8(b"555353"),
      string::utf8(b"876f69"),
      string::utf8(b"410d66"),
      string::utf8(b"552d1d"),
      string::utf8(b"f71248"),
      string::utf8(b"fee3f3"),
      string::utf8(b"c16923"),
      string::utf8(b"2b2834"),
      string::utf8(b"0079fc"),
      string::utf8(b"d31e14"),
      string::utf8(b"f83001"),
      string::utf8(b"8dd122"),
      string::utf8(b"fffdf4"),
      string::utf8(b"ffa21e"),
      string::utf8(b"e4afa3"),
      string::utf8(b"fbc311"),
      string::utf8(b"aa940c"),
      string::utf8(b"eedc00"),
      string::utf8(b"fff006"),
      string::utf8(b"9cb4b8"),
      string::utf8(b"a38654"),
      string::utf8(b"ae6c0a"),
      string::utf8(b"2bb26b"),
      string::utf8(b"e2c8c0"),
      string::utf8(b"f89865"),
      string::utf8(b"f86100"),
      string::utf8(b"dcd8d3"),
      string::utf8(b"049d43"),
      string::utf8(b"d0aea9"),
      string::utf8(b"f39d44"),
      string::utf8(b"eeb78c"),
      string::utf8(b"f9f5e9"),
      string::utf8(b"5d3500"),
      string::utf8(b"c3a199"),
      string::utf8(b"aaa6a4"),
      string::utf8(b"caa26a"),
      string::utf8(b"fde7f5"),
      string::utf8(b"fdf008"),
      string::utf8(b"fdcef2"),
      string::utf8(b"f681e6"),
      string::utf8(b"018146"),
      string::utf8(b"d19a54"),
      string::utf8(b"9eb5e1"),
      string::utf8(b"f5fcff"),
      string::utf8(b"3f9323"),
      string::utf8(b"00fcff"),
      string::utf8(b"4a5358"),
      string::utf8(b"fbc800"),
      string::utf8(b"d596a6"),
      string::utf8(b"ffb913"),
      string::utf8(b"e9ba12"),
      string::utf8(b"767c0e"),
      string::utf8(b"f9f6d1"),
      string::utf8(b"d29607"),
      string::utf8(b"f8ce47"),
      string::utf8(b"395ed1"),
      string::utf8(b"ffc5f0"),
      string::utf8(b"cbc1bc"),
      string::utf8(b"d4cfc0"),
    ];
    let paletteIndex: u8 = 0u8;
    addColorsToPalette(paletteIndex, colors, &mut objects_descriptor);

    let backgrounds: vector<String> = vector[
      string::utf8(b"0x0015171f090e020e020e020e02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02"),
      string::utf8(b"0x0015171f090e030e030e030e03020301000b03020301000b03020301000b03020301000b03020301000b03020301000b03020301000b03")
    ];
    addManyBackgrounds(backgrounds, &mut objects_descriptor);


    let accessories: vector<vector<u8>> = vector[
      b"0x0017141e0d0100011f0500021f05000100011f0300011f01000100011f0200011f02000300011f03000200011f0200021f0100011f0200011f0100011f0400011f0100011f",
      b"0x0018151a0d020003200100012001000100052002000120010001200100012001000220"
    ];
    addManyAccessories(accessories, &mut objects_descriptor);

    let bodys: vector<vector<u8>> = vector[
      b"0x0015171f090e020e020e020e02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02",
      b"0x0015171f090e0b0e0b0e0b0e0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b"
    ];
    addManyBodies(bodys, &mut objects_descriptor);


    let heads: vector<vector<u8>> = vector[
      b"0x00021e140605000137020001370f0004000237020002370e0003000337020003370d0002000437020004370c0003000337020003370d0004000237020002370e0005000137020001370f000d370b000d370b000d370b000d370b000d370b000d370b000d370600057d0d370600017d017e017d017e017d0b37097d017e017d017e017d0b370d7d0a370523097d0b370d7d",
      b"0x00041a1405045c01000447010004470100017f01000114010001140100045c01230447012304470123017f01230114012301140123045c01230447012304470123017f01230114012301140123045c01230447012304470123017f01230114012301140123045c01230447012304470123017f012301140123011401230100142301230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f012304460100132301000123015401230154012301540123040701230455012304550123015401230154012301540123040701230455012304550123015401230154012301540123010703540123045501230455012301540123015401230154012304070123045501230455012301540123015401230154012304070123045501230455"
    ];
    addManyHeads(heads, &mut objects_descriptor);

    let glasses: vector<vector<u8>> = vector[
      b"0x000b1710070300062001000620030001200201022301200100012002010223012004200201022303200201022301200420020102230320020102230120012002000120020102230120010001200201022301200300062001000620",
      b"0x000b17100703000623010006230300012302010264012301000123020102640123042302010264032302010264012301230200012302010264012301000123020102640123012302000123020102640123010001230201026401230300062301000623"
    ];
    addManyGlasses(glasses, &mut objects_descriptor);

    let _seed = generateSeed(object_id, &clock, &mut objects_descriptor);
    // debug::print(&seed);
    clock::destroy_for_testing(clock);
    test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
    test_scenario::end(scenario_val);
  }

  #[test]
  fun test_generateSVGImage() {
    let scenario_val = init_test();
    let scenario = &mut scenario_val;
    let object_id: u256 = 1u256;

    let clock = clock::create_for_testing(test_scenario::ctx(scenario));


    let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);


    let colors: vector<String> = vector[
      string::utf8(b""),
      string::utf8(b"ffffff"),
      string::utf8(b"c5b9a1"),
      string::utf8(b"cfc2ab"),
      string::utf8(b"63a0f9"),
      string::utf8(b"807f7e"),
      string::utf8(b"caeff9"),
      string::utf8(b"5648ed"),
      string::utf8(b"5a423f"),
      string::utf8(b"b9185c"),
      string::utf8(b"b87b11"),
      string::utf8(b"fffdf2"),
      string::utf8(b"4b4949"),
      string::utf8(b"343235"),
      string::utf8(b"1f1d29"),
      string::utf8(b"068940"),
      string::utf8(b"867c1d"),
      string::utf8(b"ae3208"),
      string::utf8(b"9f21a0"),
      string::utf8(b"f98f30"),
      string::utf8(b"fe500c"),
      string::utf8(b"d26451"),
      string::utf8(b"fd8b5b"),
      string::utf8(b"5a65fa"),
      string::utf8(b"d22209"),
      string::utf8(b"e9265c"),
      string::utf8(b"c54e38"),
      string::utf8(b"80a72d"),
      string::utf8(b"4bea69"),
      string::utf8(b"34ac80"),
      string::utf8(b"eed811"),
      string::utf8(b"62616d"),
      string::utf8(b"ff638d"),
      string::utf8(b"8bc0c5"),
      string::utf8(b"c4da53"),
      string::utf8(b"000000"),
      string::utf8(b"f3322c"),
      string::utf8(b"ffae1a"),
      string::utf8(b"ffc110"),
      string::utf8(b"505a5c"),
      string::utf8(b"ffef16"),
      string::utf8(b"fff671"),
      string::utf8(b"fff449"),
      string::utf8(b"db8323"),
      string::utf8(b"df2c39"),
      string::utf8(b"f938d8"),
      string::utf8(b"5c25fb"),
      string::utf8(b"2a86fd"),
      string::utf8(b"45faff"),
      string::utf8(b"38dd56"),
      string::utf8(b"ff3a0e"),
      string::utf8(b"d32a09"),
      string::utf8(b"903707"),
      string::utf8(b"6e3206"),
      string::utf8(b"552e05"),
      string::utf8(b"e8705b"),
      string::utf8(b"f38b7c"),
      string::utf8(b"e4a499"),
      string::utf8(b"667af9"),
      string::utf8(b"648df9"),
      string::utf8(b"7cc4f2"),
      string::utf8(b"97f2fb"),
      string::utf8(b"a3efd0"),
      string::utf8(b"87e4d9"),
      string::utf8(b"71bde4"),
      string::utf8(b"ff1a0b"),
      string::utf8(b"f78a18"),
      string::utf8(b"2b83f6"),
      string::utf8(b"d62149"),
      string::utf8(b"834398"),
      string::utf8(b"ffc925"),
      string::utf8(b"d9391f"),
      string::utf8(b"bd2d24"),
      string::utf8(b"ff7216"),
      string::utf8(b"254efb"),
      string::utf8(b"e5e5de"),
      string::utf8(b"00a556"),
      string::utf8(b"c5030e"),
      string::utf8(b"abf131"),
      string::utf8(b"fb4694"),
      string::utf8(b"e7a32c"),
      string::utf8(b"fff0ee"),
      string::utf8(b"009c59"),
      string::utf8(b"0385eb"),
      string::utf8(b"00499c"),
      string::utf8(b"e11833"),
      string::utf8(b"26b1f3"),
      string::utf8(b"fff0be"),
      string::utf8(b"d8dadf"),
      string::utf8(b"d7d3cd"),
      string::utf8(b"1929f4"),
      string::utf8(b"eab118"),
      string::utf8(b"0b5027"),
      string::utf8(b"f9f5cb"),
      string::utf8(b"cfc9b8"),
      string::utf8(b"feb9d5"),
      string::utf8(b"f8d689"),
      string::utf8(b"5d6061"),
      string::utf8(b"76858b"),
      string::utf8(b"757576"),
      string::utf8(b"ff0e0e"),
      string::utf8(b"0adc4d"),
      string::utf8(b"fdf8ff"),
      string::utf8(b"70e890"),
      string::utf8(b"f7913d"),
      string::utf8(b"ff1ad2"),
      string::utf8(b"ff82ad"),
      string::utf8(b"535a15"),
      string::utf8(b"fa6fe2"),
      string::utf8(b"ffe939"),
      string::utf8(b"ab36be"),
      string::utf8(b"adc8cc"),
      string::utf8(b"604666"),
      string::utf8(b"f20422"),
      string::utf8(b"abaaa8"),
      string::utf8(b"4b65f7"),
      string::utf8(b"a19c9a"),
      string::utf8(b"58565c"),
      string::utf8(b"da42cb"),
      string::utf8(b"027c92"),
      string::utf8(b"cec189"),
      string::utf8(b"909b0e"),
      string::utf8(b"74580d"),
      string::utf8(b"027ee6"),
      string::utf8(b"b2958d"),
      string::utf8(b"efad81"),
      string::utf8(b"7d635e"),
      string::utf8(b"eff2fa"),
      string::utf8(b"6f597a"),
      string::utf8(b"d4b7b2"),
      string::utf8(b"d18687"),
      string::utf8(b"cd916d"),
      string::utf8(b"6b3f39"),
      string::utf8(b"4d271b"),
      string::utf8(b"85634f"),
      string::utf8(b"f9f4e6"),
      string::utf8(b"f8ddb0"),
      string::utf8(b"b92b3c"),
      string::utf8(b"d08b11"),
      string::utf8(b"257ced"),
      string::utf8(b"a3baed"),
      string::utf8(b"5fd4fb"),
      string::utf8(b"c16710"),
      string::utf8(b"a28ef4"),
      string::utf8(b"3a085b"),
      string::utf8(b"67b1e3"),
      string::utf8(b"1e3445"),
      string::utf8(b"ffd067"),
      string::utf8(b"962236"),
      string::utf8(b"769ca9"),
      string::utf8(b"5a6b7b"),
      string::utf8(b"7e5243"),
      string::utf8(b"a86f60"),
      string::utf8(b"8f785e"),
      string::utf8(b"cc0595"),
      string::utf8(b"42ffb0"),
      string::utf8(b"d56333"),
      string::utf8(b"b8ced2"),
      string::utf8(b"b91b43"),
      string::utf8(b"f39713"),
      string::utf8(b"e8e8e2"),
      string::utf8(b"ec5b43"),
      string::utf8(b"235476"),
      string::utf8(b"b2a8a5"),
      string::utf8(b"d6c3be"),
      string::utf8(b"49b38b"),
      string::utf8(b"fccf25"),
      string::utf8(b"f59b34"),
      string::utf8(b"375dfc"),
      string::utf8(b"99e6de"),
      string::utf8(b"27a463"),
      string::utf8(b"554543"),
      string::utf8(b"b19e00"),
      string::utf8(b"d4a015"),
      string::utf8(b"9f4b27"),
      string::utf8(b"f9e8dd"),
      string::utf8(b"6b7212"),
      string::utf8(b"9d8e6e"),
      string::utf8(b"4243f8"),
      string::utf8(b"fa5e20"),
      string::utf8(b"f82905"),
      string::utf8(b"555353"),
      string::utf8(b"876f69"),
      string::utf8(b"410d66"),
      string::utf8(b"552d1d"),
      string::utf8(b"f71248"),
      string::utf8(b"fee3f3"),
      string::utf8(b"c16923"),
      string::utf8(b"2b2834"),
      string::utf8(b"0079fc"),
      string::utf8(b"d31e14"),
      string::utf8(b"f83001"),
      string::utf8(b"8dd122"),
      string::utf8(b"fffdf4"),
      string::utf8(b"ffa21e"),
      string::utf8(b"e4afa3"),
      string::utf8(b"fbc311"),
      string::utf8(b"aa940c"),
      string::utf8(b"eedc00"),
      string::utf8(b"fff006"),
      string::utf8(b"9cb4b8"),
      string::utf8(b"a38654"),
      string::utf8(b"ae6c0a"),
      string::utf8(b"2bb26b"),
      string::utf8(b"e2c8c0"),
      string::utf8(b"f89865"),
      string::utf8(b"f86100"),
      string::utf8(b"dcd8d3"),
      string::utf8(b"049d43"),
      string::utf8(b"d0aea9"),
      string::utf8(b"f39d44"),
      string::utf8(b"eeb78c"),
      string::utf8(b"f9f5e9"),
      string::utf8(b"5d3500"),
      string::utf8(b"c3a199"),
      string::utf8(b"aaa6a4"),
      string::utf8(b"caa26a"),
      string::utf8(b"fde7f5"),
      string::utf8(b"fdf008"),
      string::utf8(b"fdcef2"),
      string::utf8(b"f681e6"),
      string::utf8(b"018146"),
      string::utf8(b"d19a54"),
      string::utf8(b"9eb5e1"),
      string::utf8(b"f5fcff"),
      string::utf8(b"3f9323"),
      string::utf8(b"00fcff"),
      string::utf8(b"4a5358"),
      string::utf8(b"fbc800"),
      string::utf8(b"d596a6"),
      string::utf8(b"ffb913"),
      string::utf8(b"e9ba12"),
      string::utf8(b"767c0e"),
      string::utf8(b"f9f6d1"),
      string::utf8(b"d29607"),
      string::utf8(b"f8ce47"),
      string::utf8(b"395ed1"),
      string::utf8(b"ffc5f0"),
      string::utf8(b"cbc1bc"),
      string::utf8(b"d4cfc0"),
    ];
    let paletteIndex: u8 = 0u8;
    addColorsToPalette(paletteIndex, colors, &mut objects_descriptor);

    let backgrounds: vector<String> = vector[
      string::utf8(b"0x0015171f090e020e020e020e02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02"),
      string::utf8(b"0x0015171f090e030e030e030e03020301000b03020301000b03020301000b03020301000b03020301000b03020301000b03020301000b03")
    ];
    addManyBackgrounds(backgrounds, &mut objects_descriptor);


    let accessories: vector<vector<u8>> = vector[
      b"0x0017141e0d0100011f0500021f05000100011f0300011f01000100011f0200011f02000300011f03000200011f0200021f0100011f0200011f0100011f0400011f0100011f",
      b"0x0018151a0d020003200100012001000100052002000120010001200100012001000220"
    ];
    addManyAccessories(accessories, &mut objects_descriptor);

    let bodys: vector<vector<u8>> = vector[
      b"0x0015171f090e020e020e020e02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02",
      b"0x0015171f090e0b0e0b0e0b0e0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b"
    ];
    addManyBodies(bodys, &mut objects_descriptor);


    let heads: vector<vector<u8>> = vector[
      b"0x00021e140605000137020001370f0004000237020002370e0003000337020003370d0002000437020004370c0003000337020003370d0004000237020002370e0005000137020001370f000d370b000d370b000d370b000d370b000d370b000d370b000d370600057d0d370600017d017e017d017e017d0b37097d017e017d017e017d0b370d7d0a370523097d0b370d7d",
      b"0x00041a1405045c01000447010004470100017f01000114010001140100045c01230447012304470123017f01230114012301140123045c01230447012304470123017f01230114012301140123045c01230447012304470123017f01230114012301140123045c01230447012304470123017f012301140123011401230100142301230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f012304460100132301000123015401230154012301540123040701230455012304550123015401230154012301540123040701230455012304550123015401230154012301540123010703540123045501230455012301540123015401230154012304070123045501230455012301540123015401230154012304070123045501230455"
    ];
    addManyHeads(heads, &mut objects_descriptor);

    let glasses: vector<vector<u8>> = vector[
      b"0x000b1710070300062001000620030001200201022301200100012002010223012004200201022303200201022301200420020102230320020102230120012002000120020102230120010001200201022301200300062001000620",
      b"0x000b17100703000623010006230300012302010264012301000123020102640123042302010264032302010264012301230200012302010264012301000123020102640123012302000123020102640123010001230201026401230300062301000623"
    ];
    addManyGlasses(glasses, &mut objects_descriptor);

    let seed = generateSeed(object_id, &clock, &mut objects_descriptor);
    let _svg = generateSVGImage(seed, &mut objects_descriptor);
    // debug::print(&b"svg");
    // debug::print(&svg);

    clock::destroy_for_testing(clock);
    test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
    test_scenario::end(scenario_val);
  }

  #[test]
  fun test_getPartsForSeed_() {
    let scenario_val = init_test();
    let scenario = &mut scenario_val;
    let object_id: u256 = 1u256;

    let clock = clock::create_for_testing(test_scenario::ctx(scenario));


    let objects_descriptor = test_scenario::take_shared<ObjectsDescriptor>(scenario);


    let colors: vector<String> = vector[
      string::utf8(b""),
      string::utf8(b"ffffff"),
      string::utf8(b"c5b9a1"),
      string::utf8(b"cfc2ab"),
      string::utf8(b"63a0f9"),
      string::utf8(b"807f7e"),
      string::utf8(b"caeff9"),
      string::utf8(b"5648ed"),
      string::utf8(b"5a423f"),
      string::utf8(b"b9185c"),
      string::utf8(b"b87b11"),
      string::utf8(b"fffdf2"),
      string::utf8(b"4b4949"),
      string::utf8(b"343235"),
      string::utf8(b"1f1d29"),
      string::utf8(b"068940"),
      string::utf8(b"867c1d"),
      string::utf8(b"ae3208"),
      string::utf8(b"9f21a0"),
      string::utf8(b"f98f30"),
      string::utf8(b"fe500c"),
      string::utf8(b"d26451"),
      string::utf8(b"fd8b5b"),
      string::utf8(b"5a65fa"),
      string::utf8(b"d22209"),
      string::utf8(b"e9265c"),
      string::utf8(b"c54e38"),
      string::utf8(b"80a72d"),
      string::utf8(b"4bea69"),
      string::utf8(b"34ac80"),
      string::utf8(b"eed811"),
      string::utf8(b"62616d"),
      string::utf8(b"ff638d"),
      string::utf8(b"8bc0c5"),
      string::utf8(b"c4da53"),
      string::utf8(b"000000"),
      string::utf8(b"f3322c"),
      string::utf8(b"ffae1a"),
      string::utf8(b"ffc110"),
      string::utf8(b"505a5c"),
      string::utf8(b"ffef16"),
      string::utf8(b"fff671"),
      string::utf8(b"fff449"),
      string::utf8(b"db8323"),
      string::utf8(b"df2c39"),
      string::utf8(b"f938d8"),
      string::utf8(b"5c25fb"),
      string::utf8(b"2a86fd"),
      string::utf8(b"45faff"),
      string::utf8(b"38dd56"),
      string::utf8(b"ff3a0e"),
      string::utf8(b"d32a09"),
      string::utf8(b"903707"),
      string::utf8(b"6e3206"),
      string::utf8(b"552e05"),
      string::utf8(b"e8705b"),
      string::utf8(b"f38b7c"),
      string::utf8(b"e4a499"),
      string::utf8(b"667af9"),
      string::utf8(b"648df9"),
      string::utf8(b"7cc4f2"),
      string::utf8(b"97f2fb"),
      string::utf8(b"a3efd0"),
      string::utf8(b"87e4d9"),
      string::utf8(b"71bde4"),
      string::utf8(b"ff1a0b"),
      string::utf8(b"f78a18"),
      string::utf8(b"2b83f6"),
      string::utf8(b"d62149"),
      string::utf8(b"834398"),
      string::utf8(b"ffc925"),
      string::utf8(b"d9391f"),
      string::utf8(b"bd2d24"),
      string::utf8(b"ff7216"),
      string::utf8(b"254efb"),
      string::utf8(b"e5e5de"),
      string::utf8(b"00a556"),
      string::utf8(b"c5030e"),
      string::utf8(b"abf131"),
      string::utf8(b"fb4694"),
      string::utf8(b"e7a32c"),
      string::utf8(b"fff0ee"),
      string::utf8(b"009c59"),
      string::utf8(b"0385eb"),
      string::utf8(b"00499c"),
      string::utf8(b"e11833"),
      string::utf8(b"26b1f3"),
      string::utf8(b"fff0be"),
      string::utf8(b"d8dadf"),
      string::utf8(b"d7d3cd"),
      string::utf8(b"1929f4"),
      string::utf8(b"eab118"),
      string::utf8(b"0b5027"),
      string::utf8(b"f9f5cb"),
      string::utf8(b"cfc9b8"),
      string::utf8(b"feb9d5"),
      string::utf8(b"f8d689"),
      string::utf8(b"5d6061"),
      string::utf8(b"76858b"),
      string::utf8(b"757576"),
      string::utf8(b"ff0e0e"),
      string::utf8(b"0adc4d"),
      string::utf8(b"fdf8ff"),
      string::utf8(b"70e890"),
      string::utf8(b"f7913d"),
      string::utf8(b"ff1ad2"),
      string::utf8(b"ff82ad"),
      string::utf8(b"535a15"),
      string::utf8(b"fa6fe2"),
      string::utf8(b"ffe939"),
      string::utf8(b"ab36be"),
      string::utf8(b"adc8cc"),
      string::utf8(b"604666"),
      string::utf8(b"f20422"),
      string::utf8(b"abaaa8"),
      string::utf8(b"4b65f7"),
      string::utf8(b"a19c9a"),
      string::utf8(b"58565c"),
      string::utf8(b"da42cb"),
      string::utf8(b"027c92"),
      string::utf8(b"cec189"),
      string::utf8(b"909b0e"),
      string::utf8(b"74580d"),
      string::utf8(b"027ee6"),
      string::utf8(b"b2958d"),
      string::utf8(b"efad81"),
      string::utf8(b"7d635e"),
      string::utf8(b"eff2fa"),
      string::utf8(b"6f597a"),
      string::utf8(b"d4b7b2"),
      string::utf8(b"d18687"),
      string::utf8(b"cd916d"),
      string::utf8(b"6b3f39"),
      string::utf8(b"4d271b"),
      string::utf8(b"85634f"),
      string::utf8(b"f9f4e6"),
      string::utf8(b"f8ddb0"),
      string::utf8(b"b92b3c"),
      string::utf8(b"d08b11"),
      string::utf8(b"257ced"),
      string::utf8(b"a3baed"),
      string::utf8(b"5fd4fb"),
      string::utf8(b"c16710"),
      string::utf8(b"a28ef4"),
      string::utf8(b"3a085b"),
      string::utf8(b"67b1e3"),
      string::utf8(b"1e3445"),
      string::utf8(b"ffd067"),
      string::utf8(b"962236"),
      string::utf8(b"769ca9"),
      string::utf8(b"5a6b7b"),
      string::utf8(b"7e5243"),
      string::utf8(b"a86f60"),
      string::utf8(b"8f785e"),
      string::utf8(b"cc0595"),
      string::utf8(b"42ffb0"),
      string::utf8(b"d56333"),
      string::utf8(b"b8ced2"),
      string::utf8(b"b91b43"),
      string::utf8(b"f39713"),
      string::utf8(b"e8e8e2"),
      string::utf8(b"ec5b43"),
      string::utf8(b"235476"),
      string::utf8(b"b2a8a5"),
      string::utf8(b"d6c3be"),
      string::utf8(b"49b38b"),
      string::utf8(b"fccf25"),
      string::utf8(b"f59b34"),
      string::utf8(b"375dfc"),
      string::utf8(b"99e6de"),
      string::utf8(b"27a463"),
      string::utf8(b"554543"),
      string::utf8(b"b19e00"),
      string::utf8(b"d4a015"),
      string::utf8(b"9f4b27"),
      string::utf8(b"f9e8dd"),
      string::utf8(b"6b7212"),
      string::utf8(b"9d8e6e"),
      string::utf8(b"4243f8"),
      string::utf8(b"fa5e20"),
      string::utf8(b"f82905"),
      string::utf8(b"555353"),
      string::utf8(b"876f69"),
      string::utf8(b"410d66"),
      string::utf8(b"552d1d"),
      string::utf8(b"f71248"),
      string::utf8(b"fee3f3"),
      string::utf8(b"c16923"),
      string::utf8(b"2b2834"),
      string::utf8(b"0079fc"),
      string::utf8(b"d31e14"),
      string::utf8(b"f83001"),
      string::utf8(b"8dd122"),
      string::utf8(b"fffdf4"),
      string::utf8(b"ffa21e"),
      string::utf8(b"e4afa3"),
      string::utf8(b"fbc311"),
      string::utf8(b"aa940c"),
      string::utf8(b"eedc00"),
      string::utf8(b"fff006"),
      string::utf8(b"9cb4b8"),
      string::utf8(b"a38654"),
      string::utf8(b"ae6c0a"),
      string::utf8(b"2bb26b"),
      string::utf8(b"e2c8c0"),
      string::utf8(b"f89865"),
      string::utf8(b"f86100"),
      string::utf8(b"dcd8d3"),
      string::utf8(b"049d43"),
      string::utf8(b"d0aea9"),
      string::utf8(b"f39d44"),
      string::utf8(b"eeb78c"),
      string::utf8(b"f9f5e9"),
      string::utf8(b"5d3500"),
      string::utf8(b"c3a199"),
      string::utf8(b"aaa6a4"),
      string::utf8(b"caa26a"),
      string::utf8(b"fde7f5"),
      string::utf8(b"fdf008"),
      string::utf8(b"fdcef2"),
      string::utf8(b"f681e6"),
      string::utf8(b"018146"),
      string::utf8(b"d19a54"),
      string::utf8(b"9eb5e1"),
      string::utf8(b"f5fcff"),
      string::utf8(b"3f9323"),
      string::utf8(b"00fcff"),
      string::utf8(b"4a5358"),
      string::utf8(b"fbc800"),
      string::utf8(b"d596a6"),
      string::utf8(b"ffb913"),
      string::utf8(b"e9ba12"),
      string::utf8(b"767c0e"),
      string::utf8(b"f9f6d1"),
      string::utf8(b"d29607"),
      string::utf8(b"f8ce47"),
      string::utf8(b"395ed1"),
      string::utf8(b"ffc5f0"),
      string::utf8(b"cbc1bc"),
      string::utf8(b"d4cfc0"),
    ];
    let paletteIndex: u8 = 0u8;
    addColorsToPalette(paletteIndex, colors, &mut objects_descriptor);

    let backgrounds: vector<String> = vector[
      string::utf8(b"0x0015171f090e020e020e020e02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02"),
      string::utf8(b"0x0015171f090e030e030e030e03020301000b03020301000b03020301000b03020301000b03020301000b03020301000b03020301000b03")
    ];
    addManyBackgrounds(backgrounds, &mut objects_descriptor);


    let accessories: vector<vector<u8>> = vector[
      b"0x0017141e0d0100011f0500021f05000100011f0300011f01000100011f0200011f02000300011f03000200011f0200021f0100011f0200011f0100011f0400011f0100011f",
      b"0x0018151a0d020003200100012001000100052002000120010001200100012001000220"
    ];
    addManyAccessories(accessories, &mut objects_descriptor);

    let bodys: vector<vector<u8>> = vector[
      b"0x0015171f090e020e020e020e02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02",
      b"0x0015171f090e0b0e0b0e0b0e0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b020b01000b0b"
    ];
    addManyBodies(bodys, &mut objects_descriptor);


    let heads: vector<vector<u8>> = vector[
      b"0x00021e140605000137020001370f0004000237020002370e0003000337020003370d0002000437020004370c0003000337020003370d0004000237020002370e0005000137020001370f000d370b000d370b000d370b000d370b000d370b000d370b000d370600057d0d370600017d017e017d017e017d0b37097d017e017d017e017d0b370d7d0a370523097d0b370d7d",
      b"0x00041a1405045c01000447010004470100017f01000114010001140100045c01230447012304470123017f01230114012301140123045c01230447012304470123017f01230114012301140123045c01230447012304470123017f01230114012301140123045c01230447012304470123017f012301140123011401230100142301230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f0123044601230158012301580123017f012304460123047f012304460100132301000123015401230154012301540123040701230455012304550123015401230154012301540123040701230455012304550123015401230154012301540123010703540123045501230455012301540123015401230154012304070123045501230455012301540123015401230154012304070123045501230455"
    ];
    addManyHeads(heads, &mut objects_descriptor);

    let glasses: vector<vector<u8>> = vector[
      b"0x000b1710070300062001000620030001200201022301200100012002010223012004200201022303200201022301200420020102230320020102230120012002000120020102230120010001200201022301200300062001000620",
      b"0x000b17100703000623010006230300012302010264012301000123020102640123042302010264032302010264012301230200012302010264012301000123020102640123012302000123020102640123010001230201026401230300062301000623"
    ];
    addManyGlasses(glasses, &mut objects_descriptor);

    let seed = generateSeed(object_id, &clock, &mut objects_descriptor);
    let _parts = getPartsForSeed_(seed, &mut objects_descriptor);
    // debug::print(&b"parts");
    // debug::print(&parts);

    clock::destroy_for_testing(clock);
    test_scenario::return_shared<ObjectsDescriptor>(objects_descriptor);
    test_scenario::end(scenario_val);
  }
}
