module objectsDAO::multi_part_rel_to_svg {
    // use std::string;
    // use std::ascii;
    // use std::debug;
    // use std::string::{String};
    // use std::vector;
    // use objectsDAO::base64;
    // use objectsDAO::descriptor::{ObjectsDescriptor, get_mut_palettes};
    // use sui::table;
    //
    // const EInvalidHexLength: u64 = 0;
    // const ENotValidHexCharacter: u64 = 1;
    //
    // struct SVGParams has drop {
    //     parts:vector<String>,
    //     background:String
    // }
    //
    //
    // struct ContentBounds has drop, store {
    //     top: u8,
    //     right: u8,
    //     bottom: u8,
    //     left: u8
    // }
    //
    // struct Rect has copy, drop, store {
    //     length: u8,
    //     colorIndex: u8
    // }
    //
    // struct DecodedImage has drop {
    //     paletteIndex: u8,
    //     bounds: ContentBounds,
    //     rects: vector<Rect>
    // }
    //
    // public fun get_rect_length_and_colorIndex(rect:&Rect):(u8,u8) {
    //     return (rect.length,rect.colorIndex)
    // }
    //
    // public fun create_svg_params(parts:vector<String>,background:String):SVGParams{
    //     SVGParams{
    //         parts,
    //         background
    //     }
    // }
    //
    // /**
    //  * @notice Given RLE image parts and color palettes, merge to generate a single SVG image.
    //  */
    // public fun generateSVG(params:SVGParams,objects_descriptor:&mut ObjectsDescriptor): String {
    //     let svg = string::utf8(b"");
    //     //header
    //     let svg_header = string::utf8(b"<svg width='320' height='320' viewBox='0 0 320 320' xmlns='http://www.w3.org/2000/svg' shape-rendering='crispEdges'>");
    //
    //     //body
    //     let rect = string::utf8(b"<rect width='100%' height='100%' fill='#");
    //     let background = params.background;
    //     let rect_tail =  string::utf8(b"' />");
    //     let svg_rect = generateSVGRects_(params, objects_descriptor);
    //     let svg_tail = string::utf8(b"</svg>");
    //     string::append(&mut svg, svg_header);
    //     string::append(&mut svg, rect);
    //     string::append(&mut svg, background);
    //     string::append(&mut svg, rect_tail);
    //     string::append(&mut svg, svg_rect);
    //     string::append(&mut svg, svg_tail);
    //
    //     // debug::print(&string::utf8(b"svgsvgsvgsvgsvgsvgsvg"));
    //     // debug::print(&svg);
    //
    //     let base_64_svg = base64::encode(string::bytes(&svg));
    //     let base_64_string = string::utf8(base_64_svg);
    //     // debug::print(&string::utf8(b"svgsvgsvgsvgsvgsvgsvg"));
    //     // debug::print(&svg);
    //     // let to_ascii = string::to_ascii(svg);
    //     // // let to_bytes = ascii::into_bytes(to_ascii);
    //     // let to_bytes = ascii::into_bytes(to_ascii);
    //     // return to_bytes
    //   base_64_string
    // }
    //
    //
    // public fun generateSVGRects_(params:SVGParams,objects_descriptor:&mut ObjectsDescriptor): String {
    //
    //     let value = 0;
    //
    //     let cache_svg_rects_string = string::utf8(b"");
    //     // let final_svg_rects = vector::empty<String>();
    //     let p = 0;
    //     let len = vector::length(&params.parts);
    //
    //     while (p < len){
    //         // debug::print(&string::utf8(b"p"));
    //         // debug::print(&p);
    //         // debug::print(&string::utf8(b"len"));
    //         // debug::print(&len);
    //         let svg_rects = vector::empty<String>();
    //
    //         let image = decodeRLEImage_(*vector::borrow(&params.parts,p));
    //         debug::print(&string::utf8(b"image"));
    //         debug::print(&image);
    //
    //         let currentX = (image.bounds.left as u64);
    //         let currentY = (image.bounds.top as u64);
    //
    //         let i = 0;
    //         let rects_length = vector::length(&image.rects);
    //         // debug::print(&string::utf8(b"rects_length"));
    //         // debug::print(&rects_length);
    //         while (i < rects_length){
    //             let rect = vector::borrow(&image.rects,i);
    //             let drawLength = (rect.length as u64);
    //             let colorIndex = rect.colorIndex;
    //
    //             let palettes_table = get_mut_palettes(objects_descriptor);
    //             let hexColor_vector = table::borrow(palettes_table, 0);
    //             let hexColor = vector::borrow(hexColor_vector, (colorIndex as u64));
    //
    //
    //             let length = getRectLength(currentX, drawLength, (image.bounds.right as u64));
    //
    //             while (length > 0 ){
    //                 if (colorIndex != 0) {
    //                     let new_length = length * 10;
    //                     let new_current_x = currentX * 10;
    //                     let new_current_y = currentY * 10;
    //                     let chunk= getChunk_(new_length,new_current_x,new_current_y,hexColor);
    //                     vector::push_back(&mut svg_rects,chunk);
    //                 };
    //                 currentX = currentX + length;
    //
    //                 if (currentX == (image.bounds.right as u64)){
    //                     currentX = (image.bounds.left as u64);
    //                     currentY = currentY + 1;
    //                 };
    //
    //                 drawLength = drawLength - length;
    //                 // debug::print(&string::utf8(b"length"));
    //                 // debug::print(&length);
    //                 length = getRectLength(currentX, drawLength, (image.bounds.right as u64));
    //                 value = value + 1;
    //                 // debug::print(&string::utf8(b"value"));
    //                 // debug::print(&value);
    //             };
    //             i = i + 1;
    //         };
    //
    //         let i = 0;
    //         let l = vector::length(&svg_rects);
    //         // let final_svg_string = string::utf8(b"");
    //         while (i < l){
    //             let svg_string = vector::borrow(&svg_rects,i);
    //             string::append(&mut cache_svg_rects_string,*svg_string);
    //             i = i + 1
    //         };
    //
    //         // debug::print(&string::utf8(b"svg_reacts"));
    //         // debug::print(&svg_rects);
    //         p = p + 1
    //     };
    //     // debug::print(&string::utf8(b"cache_svg_rects_string"));
    //     // debug::print(&cache_svg_rects_string);
    //     cache_svg_rects_string
    //
    // }
    //
    // public fun getChunk_(new_length:u64,new_currentX:u64,new_currentY:u64,new_hexColor:&String): String {
    //     let new_length_string = string::from_ascii(u64_to_string(new_length));
    //     let new_currentX_string = string::from_ascii(u64_to_string(new_currentX));
    //     let new_currentY_string = string::from_ascii(u64_to_string(new_currentY));
    //     let chunk = string::utf8(b"<rect width='");
    //     string::append(&mut chunk, new_length_string);
    //     string::append_utf8(&mut chunk, b"' ");
    //     string::append_utf8(&mut chunk, b"height='10' x='");
    //     string::append(&mut chunk, new_currentX_string);
    //     string::append_utf8(&mut chunk, b"' ");
    //     string::append_utf8(&mut chunk, b"y='");
    //     string::append(&mut chunk, new_currentY_string);
    //     string::append_utf8(&mut chunk, b"' ");
    //     string::append_utf8(&mut chunk, b"fill='#");
    //     string::append(&mut chunk, *new_hexColor);
    //     string::append_utf8(&mut chunk, b"' ");
    //     string::append_utf8(&mut chunk, b"/>");
    //     chunk
    // }
    //
    // public fun getRectLength(currentX: u64, drawLength: u64, rightBound: u64): u64 {
    //     let remainingPixelsInLine = rightBound - currentX;
    //
    //     if (drawLength <= remainingPixelsInLine){
    //         drawLength
    //     }else {
    //         remainingPixelsInLine
    //     }
    // }
    //
    // fun u64_to_string(value: u64): ascii::String {
    //     if (value == 0) {
    //         return ascii::string(b"0")
    //     };
    //     let buffer = vector::empty<u8>();
    //     while (value != 0) {
    //         vector::push_back(&mut buffer, ((48 + value % 10) as u8));
    //         value = value / 10;
    //     };
    //     vector::reverse(&mut buffer);
    //     ascii::string(buffer)
    // }
    //
    // /**
    //  * @notice Decode a single RLE compressed image into a `DecodedImage`.
    //  */
    // public fun decodeRLEImage_(image: String): DecodedImage {
    //
    //     // debug::print(&string::utf8(b"image"));
    //     // debug::print(&image);
    //
    //
    //     let new_image = string::sub_string(&image,2,string::length(&image));
    //
    //
    //     let paletteIndex_hex = string::bytes(&string::sub_string(&new_image,0,2));
    //     let paletteIndex= hex_to_u8(paletteIndex_hex);
    //
    //
    //     let top_string = string::sub_string(&new_image,2,4);
    //     let top_hex = string::bytes(&top_string);
    //
    //     let right_string = string::sub_string(&new_image,4,6);
    //     let right_hex = string::bytes(&right_string);
    //
    //     let bottom_string = string::sub_string(&new_image,6,8);
    //     let bottom_hex = string::bytes(&bottom_string);
    //
    //     let left_string = string::sub_string(&new_image,8,10);
    //     let left_hex = string::bytes(&left_string);
    //
    //     let bounds = ContentBounds {
    //         top: hex_to_u8(top_hex),
    //         right: hex_to_u8(right_hex),
    //         bottom: hex_to_u8(bottom_hex),
    //         left: hex_to_u8(left_hex)
    //     };
    //
    //     let rects_image = string::sub_string(&new_image,10,string::length(&new_image));
    //
    //     let rects_image_length = string::length(&rects_image);
    //
    //     let i = 0;
    //     let j = 0;
    //     let rects_image_vector =  vector::empty<String>();
    //
    //     while (i < rects_image_length / 4){
    //         let rects_image_string = string::sub_string(&rects_image,j,j+4);
    //         vector::push_back(&mut rects_image_vector,rects_image_string);
    //         i = i + 1;
    //         j = j + 4;
    //     };
    //
    //
    //     let v = 0;
    //     let rects = vector::empty<Rect>();
    //     while (v <  vector::length(&rects_image_vector)){
    //
    //         let string_vector = vector::borrow(&rects_image_vector,v);
    //
    //         let length_new_string = string::sub_string(string_vector, 0,  2);
    //         let length = string::bytes(&length_new_string);
    //         let color_index_string = string::sub_string(string_vector,  2, 4);
    //         let color_index = string::bytes(&color_index_string);
    //
    //
    //
    //         let new_rect = Rect {
    //             length:hex_to_u8(length),
    //             colorIndex:hex_to_u8(color_index)
    //         };
    //         // debug::print(&string::utf8(b"new_rect"));
    //         // debug::print(&new_rect);
    //
    //         vector::push_back(&mut rects,new_rect);
    //         v = v + 1;
    //     };
    //
    //     return DecodedImage {
    //         paletteIndex: paletteIndex,
    //         bounds: bounds,
    //         rects: rects
    //     }
    // }
    //
    //
    //
    // fun hex_to_u8(hex_vector:&vector<u8>):u8{
    //     // debug::print(&string::utf8(b"hex_vector"));
    //     // debug::print(hex_vector);
    //     let value = 0u8;
    //     let (i,  l) = (0,  vector::length(hex_vector));
    //     assert!(l % 2 == 0, EInvalidHexLength);
    //     while (i < l) {
    //         value = (decode_byte(*vector::borrow(hex_vector, i)) * 16) +
    //             decode_byte(*vector::borrow(hex_vector, i + 1));
    //         i = i + 2;
    //     };
    //     return value
    // }
    //
    // fun decode_byte(hex: u8): u8 {
    //     if (/* 0 .. 9 */ 48 <= hex && hex < 58) {
    //         hex - 48
    //     } else if (/* A .. F */ 65 <= hex && hex < 71) {
    //         10 + hex - 65
    //     } else if (/* a .. f */ 97 <= hex && hex < 103) {
    //         10 + hex - 97
    //     } else {
    //         abort ENotValidHexCharacter
    //     }
    // }
}
