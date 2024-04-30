module objectsDAO::multi_part_rel_to_svg {
    use std::string;
    use std::ascii;
    use std::string::{String};
    use std::vector;
    use objectsDAO::base64;
    use objectsDAO::descriptor::{ObjectsDescriptor, get_mut_palettes};
    use sui::table;

    const EInvalidHexLength: u64 = 0;
    const ENotValidHexCharacter: u64 = 1;

    struct SVGParams has drop {
        parts:vector<String>,
        background:String
    }


    struct ContentBounds has drop, store {
        top: u8,
        right: u8,
        bottom: u8,
        left: u8
    }

    struct Rect has copy, drop, store {
        length: u8,
        colorIndex: u8
    }

    struct DecodedImage has drop {
        paletteIndex: u8,
        bounds: ContentBounds,
        rects: vector<Rect>
    }

    public fun get_rect_length_and_colorIndex(rect:&Rect):(u8,u8) {
        return (rect.length,rect.colorIndex)
    }

    public fun create_svg_params(parts:vector<String>,background:String):SVGParams{
        SVGParams{
            parts,
            background
        }
    }

    /**
     * @notice Given RLE image parts and color palettes, merge to generate a single SVG image.
     */
    public fun generateSVG(params:SVGParams,objects_descriptor:&mut ObjectsDescriptor): String {
        let svg = string::utf8(b"");
        //header
        let svg_header = string::utf8(b"<svg width='320' height='320' viewBox='0 0 320 320' xmlns='http://www.w3.org/2000/svg' shape-rendering='crispEdges'>");

        //body
        let rect = string::utf8(b"<rect width='100%' height='100%' fill='#");
        let background = params.background;
        let rect_tail =  string::utf8(b"' />");
        let svg_rect = generateSVGRects_(params, objects_descriptor);
        let svg_tail = string::utf8(b"</svg>");
        string::append(&mut svg, svg_header);
        string::append(&mut svg, rect);
        string::append(&mut svg, background);
        string::append(&mut svg, rect_tail);
        string::append(&mut svg, svg_rect);
        string::append(&mut svg, svg_tail);

        // debug::print(&string::utf8(b"svgsvgsvgsvgsvgsvgsvg"));
        // debug::print(&svg);

        let base_64_svg = base64::encode(string::bytes(&svg));
        let base_64_string = string::utf8(base_64_svg);
        // debug::print(&string::utf8(b"svgsvgsvgsvgsvgsvgsvg"));
        // debug::print(&svg);
        // let to_ascii = string::to_ascii(svg);
        // // let to_bytes = ascii::into_bytes(to_ascii);
        // let to_bytes = ascii::into_bytes(to_ascii);
        // return to_bytes
      base_64_string
    }


    public fun generateSVGRects_(params:SVGParams,objects_descriptor:&mut ObjectsDescriptor): String {

        let value = 0;

        let cache_svg_rects_string = string::utf8(b"");
        // let final_svg_rects = vector::empty<String>();
        let p = 0;
        let len = vector::length(&params.parts);

        while (p < len){
            // debug::print(&string::utf8(b"p"));
            // debug::print(&p);
            // debug::print(&string::utf8(b"len"));
            // debug::print(&len);
            let svg_rects = vector::empty<String>();

            let image = decodeRLEImage_(*vector::borrow(&params.parts,p));

            let currentX = (image.bounds.left as u64);
            let currentY = (image.bounds.top as u64);

            let i = 0;
            let rects_length = vector::length(&image.rects);
            // debug::print(&string::utf8(b"rects_length"));
            // debug::print(&rects_length);
            while (i < rects_length){
                let rect = vector::borrow(&image.rects,i);
                let drawLength = (rect.length as u64);
                let colorIndex = rect.colorIndex;

                let palettes_table = get_mut_palettes(objects_descriptor);
                let hexColor_vector = table::borrow(palettes_table, 0);
                let hexColor = vector::borrow(hexColor_vector, (colorIndex as u64));


                let length = getRectLength(currentX, drawLength, (image.bounds.right as u64));

                while (length > 0 ){
                    if (colorIndex != 0) {
                        let new_length = length * 10;
                        let new_current_x = currentX * 10;
                        let new_current_y = currentY * 10;
                        let chunk= getChunk_(new_length,new_current_x,new_current_y,hexColor);
                        vector::push_back(&mut svg_rects,chunk);
                    };
                    currentX = currentX + length;

                    if (currentX == (image.bounds.right as u64)){
                        currentX = (image.bounds.left as u64);
                        currentY = currentY + 1;
                    };

                    drawLength = drawLength - length;
                    // debug::print(&string::utf8(b"length"));
                    // debug::print(&length);
                    length = getRectLength(currentX, drawLength, (image.bounds.right as u64));
                    value = value + 1;
                    // debug::print(&string::utf8(b"value"));
                    // debug::print(&value);
                };
                i = i + 1;
            };

            let i = 0;
            let l = vector::length(&svg_rects);
            // let final_svg_string = string::utf8(b"");
            while (i < l){
                let svg_string = vector::borrow(&svg_rects,i);
                string::append(&mut cache_svg_rects_string,*svg_string);
                i = i + 1
            };

            // debug::print(&string::utf8(b"svg_reacts"));
            // debug::print(&svg_rects);
            p = p + 1
        };

        cache_svg_rects_string
    }

    // public fun generateSVGRects_(params:SVGParams,objects_descriptor:&mut ObjectsDescriptor): String {
    //     let lookup:vector<String> =
    //       vector[
    //         string::utf8(b"0"),
    //         string::utf8(b"10"),
    //         string::utf8(b"20"),
    //         string::utf8(b"30"),
    //         string::utf8(b"40"),
    //         string::utf8(b"50"),
    //         string::utf8(b"60"),
    //         string::utf8(b"70"),
    //         string::utf8(b"80"),
    //         string::utf8(b"90"),
    //         string::utf8(b"100"),
    //         string::utf8(b"110"),
    //         string::utf8(b"120"),
    //         string::utf8(b"130"),
    //         string::utf8(b"140"),
    //         string::utf8(b"150"),
    //         string::utf8(b"160"),
    //         string::utf8(b"170"),
    //         string::utf8(b"180"),
    //         string::utf8(b"190"),
    //         string::utf8(b"200"),
    //         string::utf8(b"210"),
    //         string::utf8(b"220"),
    //         string::utf8(b"230"),
    //         string::utf8(b"240"),
    //         string::utf8(b"250"),
    //         string::utf8(b"260"),
    //         string::utf8(b"270"),
    //         string::utf8(b"280"),
    //         string::utf8(b"290"),
    //         string::utf8(b"300"),
    //         string::utf8(b"310"),
    //         string::utf8(b"320"),
    //       ];
    //     let rects = string::utf8(b"");
    //
    //     let p = 0;
    //     // let len = vector::length(&params.parts);
    //
    //     let len = 1u64;
    //
    //     // debug::print(&string::utf8(b"len"));
    //     // debug::print(&len);
    //
    //     while (p < len) {
    //         let image = decodeRLEImage_(*vector::borrow(&params.parts,p));
    //
    //         debug::print(&string::utf8(b"image"));
    //         debug::print(&image);
    //
    //         let palettes_table = get_mut_palettes(objects_descriptor);
    //         let palette = table::borrow(palettes_table,image.paletteIndex);
    //         let currentX:u256 = (image.bounds.left as u256);
    //         let currentY:u256 = (image.bounds.top as u256);
    //         let cursor:u256 = 0u256;
    //         let buffer:vector<String> = vector::empty<String>();
    //         let part:String = string::utf8(b"");
    //
    //         // debug::print(&string::utf8(b"currentX"));
    //         // debug::print(&currentX);
    //
    //         let i= 0;
    //         let rects_length = vector::length(&image.rects);
    //
    //         debug::print(&string::utf8(b"rects_length"));
    //         debug::print(&rects_length);
    //         debug::print(&string::utf8(b"image.rects"));
    //         debug::print(&image.rects);
    //
    //         while (i < rects_length ){
    //             let rect = vector::borrow(&image.rects,i);
    //             let rect_length = rect.length;
    //             let current_x = currentX;
    //             if (rect.colorIndex != 0){
    //
    //                 // debug::print(&string::utf8(b"rect.length"));
    //                 // debug::print(&rect.length);
    //                 // debug::print(&string::utf8(b"currentX--"));
    //                 // debug::print(&currentX);
    //                 // debug::print(&string::utf8(b"currentY"));
    //                 // debug::print(&currentY);
    //                 // debug::print(&string::utf8(b"rect.colorIndex"));
    //                 // debug::print(&rect.colorIndex);
    //
    //                 // if(rect_length > (vector::length(&lookup) as u8)){
    //                 //     rect_length = (0u64 as u8);
    //                 //
    //                 // };
    //
    //                 // if(current_x > (vector::length(&lookup) as u256)){
    //                 //     current_x = (0u64 as u256);
    //                 //     // debug::print(&string::utf8(b"rect.current_x"));
    //                 //     // debug::print(&current_x);
    //                 // };
    //
    //
    //
    //
    //
    //
    //                 debug::print(&string::utf8(b"lookup"));
    //                 debug::print(&vector::length(&lookup));
    //                 debug::print(&string::utf8(b"rect_length"));
    //                 debug::print(&rect_length);
    //
    //                 let width = vector::borrow(&lookup, (rect_length as u64));
    //                 let x = vector::borrow(&lookup, (current_x as u64));
    //                 let y = vector::borrow(&lookup, (currentY as u64));
    //                 let color = vector::borrow(palette, (rect.colorIndex as u64));
    //
    //                 // debug::print(&string::utf8(b"width"));
    //                 // debug::print(width);
    //                 // debug::print(&string::utf8(b"x"));
    //                 // debug::print(x);
    //                 // debug::print(&string::utf8(b"y"));
    //                 // debug::print(y);
    //                 // debug::print(&string::utf8(b"color"));
    //                 // debug::print(color);
    //
    //                 vector::insert(&mut buffer, *width, (cursor as u64));
    //                 vector::insert(&mut buffer, *x, (cursor + 1 as u64));
    //                 vector::insert(&mut buffer, *y, (cursor + 2 as u64));
    //                 vector::insert(&mut buffer, *color, (cursor + 3 as u64));
    //
    //                 cursor = cursor + 4;
    //
    //                 if (cursor >= 16){
    //                     // debug::print(&string::utf8(b" cursor >= 16 buffer"));
    //                     // debug::print(&buffer);
    //                     string::append(&mut part, getChunk_((cursor as u64),buffer));
    //                     cursor = 0;
    //                 }
    //
    //             };
    //
    //             currentX = (currentX + (rect_length as u256));
    //
    //             if (currentX == (image.bounds.right as u256)){
    //                 currentX = (image.bounds.left as u256);
    //                 currentY = currentY +1;
    //             };
    //             i = i + 1;
    //         };
    //
    //         if (cursor != 0){
    //             // debug::print(&string::utf8(b" cursor != 0"));
    //             // debug::print(&buffer);
    //             string::append(&mut part, getChunk_((cursor as u64),buffer));
    //         };
    //
    //         // debug::print(&string::utf8(b"image.paletteIndex"));
    //         // debug::print(&image.paletteIndex);
    //         // let svgRects = string::utf8(b"");
    //         // string::append(&mut rects, svgRects);
    //
    //         let part = string::utf8(b"");
    //         string::append(&mut rects,part);
    //         p = p + 1;
    //     };
    //     return rects
    // }

    // /**
    //  * @notice Given RLE image parts and color palettes, generate SVG rects.
    //  */
    // public fun generateSVGRects_(params:SVGParams,objects_descriptor:&mut ObjectsDescriptor): vector<u8> {
    //     let lookup:vector<String> =
    //       vector[
    //         string::utf8(b"0"),
    //         string::utf8(b"10"),
    //         string::utf8(b"20"),
    //         string::utf8(b"30"),
    //         string::utf8(b"40"),
    //         string::utf8(b"50"),
    //         string::utf8(b"60"),
    //         string::utf8(b"70"),
    //         string::utf8(b"80"),
    //         string::utf8(b"90"),
    //         string::utf8(b"100"),
    //         string::utf8(b"110"),
    //         string::utf8(b"120"),
    //         string::utf8(b"130"),
    //         string::utf8(b"140"),
    //         string::utf8(b"150"),
    //         string::utf8(b"160"),
    //         string::utf8(b"170"),
    //         string::utf8(b"180"),
    //         string::utf8(b"190"),
    //         string::utf8(b"200"),
    //         string::utf8(b"210"),
    //         string::utf8(b"220"),
    //         string::utf8(b"230"),
    //         string::utf8(b"240"),
    //         string::utf8(b"250"),
    //         string::utf8(b"260"),
    //         string::utf8(b"270"),
    //         string::utf8(b"280"),
    //         string::utf8(b"290"),
    //         string::utf8(b"300"),
    //         string::utf8(b"310"),
    //         string::utf8(b"320"),
    //       ];
    //     let rects = string::utf8(b"");
    //
    //     let p = 0;
    //     let len = vector::length(&params.parts);
    //
    //     // debug::print(&string::utf8(b"params.parts"));
    //     // debug::print(&params.parts);
    //
    //     while (p < len) {
    //         // debug::print(&string::utf8(b"len"));
    //         // debug::print(&len);
    //         // debug::print(&string::utf8(b"vector::borrow(&params.parts,p)"));
    //         // debug::print(vector::borrow(&params.parts,p));
    //         let image = decodeRLEImage_(*vector::borrow(&params.parts,p));
    //
    //
    //         // debug::print(&string::utf8(b"image"));
    //         // debug::print(&image);
    //
    //         let palettes_table = get_mut_palettes(objects_descriptor);
    //
    //         // debug::print(&string::utf8(b"palettes_table"));
    //         // debug::print(&table::contains(palettes_table,image.paletteIndex));
    //         let bool = table::contains(palettes_table, image.paletteIndex);
    //         if (!bool) {
    //           table::add(palettes_table, image.paletteIndex,vector[string::utf8(b"")]);
    //         };
    //
    //         let palette = table::borrow(palettes_table, image.paletteIndex);
    //
    //         let currentX = (image.bounds.left as u256);
    //         let currentY = (image.bounds.top as u256);
    //         let cursor = 0;
    //
    //         let buffer:String = string::utf8(b"");
    //         let svgRects = string::utf8(b"");
    //
    //         let i = 0;
    //         let len = vector::length(&image.rects);
    //
    //         p = p + 1;
    //         while (i < len) {
    //             let rect = vector::borrow(&image.rects,i);
    //             let draw_length = rect.length;
    //             let color_index = rect.colorIndex;
    //             let (_length,color_index) = get_rect_length_and_colorIndex(rect);
    //
    //
    //             if (color_index != 0) {
    //                 // debug::print(&rect.length);
    //                 // debug::print(&color_index);
    //
    //                 // debug::print(&string::utf8(b"palettes_table"));
    //                 // debug::print(&table::contains(palettes_table,image.paletteIndex));
    //
    //                 debug::print(&string::utf8(b"rect.length"));
    //                 debug::print(&rect.length);
    //
    //
    //                 let width = *vector::borrow(&lookup,(rect.length as u64));
    //                 let x = *vector::borrow(&lookup,(currentX as u64));
    //                 let y = *vector::borrow(&lookup,(currentY as u64));
    //                 let color_Index = *vector::borrow(palette,(color_index as u64));
    //
    //                 string::insert(&mut buffer, cursor, width);
    //                 string::insert(&mut buffer, cursor + 1, x);
    //                 string::insert(&mut buffer, cursor + 2, y);
    //                 string::insert(&mut buffer,  cursor + 3,color_Index);
    //                 cursor = cursor + 4;
    //
    //                 if (cursor >= 16) {
    //                     string::append_utf8(&mut svgRects, getChunk_(cursor, (*string::bytes(&buffer))));
    //                     cursor = 0;
    //                 };
    //             };
    //
    //             // debug::print(&currentX);
    //             // debug::print(&rect.length);
    //             currentX = currentX + (rect.length as u256);
    //             if (currentX == (image.bounds.right as u256)) {
    //                 currentX = (image.bounds.left as u256);
    //                 currentY = currentY + 1;
    //             }
    //         };
    //
    //         if (cursor != 0) {
    //             string::append_utf8(&mut svgRects, getChunk_(cursor,(*string::bytes(&buffer))));
    //         };
    //
    //         string::append(&mut rects, svgRects);
    //     };
    //
    //     let to_ascii = string::to_ascii(rects);
    //     let to_bytes = ascii::into_bytes(to_ascii);
    //
    //     return to_bytes
    // }
    // /**
    //  * @notice Return a string that consists of all rects in the provided `buffer`.
    //  */
    // public fun getChunk_(cursor: u64, buffer: vector<u8>): vector<u8> {
    //     let chunk = string::utf8(b"<rec width='");
    //     let i = 0;
    //     while (i < cursor) {
    //         let single_buff = bcs::to_bytes(vector::borrow(&buffer, i));
    //         let double_buff = bcs::to_bytes(vector::borrow(&buffer, i + 1));
    //         let triple_buff = bcs::to_bytes(vector::borrow(&buffer, i + 2));
    //         let quadruple_buff = bcs::to_bytes(vector::borrow(&buffer, i + 3));
    //         string::append_utf8(&mut chunk, single_buff);
    //         string::append_utf8(&mut chunk, b"' ");
    //         string::append_utf8(&mut chunk, b"height='10' x='");
    //         string::append_utf8(&mut chunk, double_buff);
    //         string::append_utf8(&mut chunk, b"' ");
    //         string::append_utf8(&mut chunk, b"y='");
    //         string::append_utf8(&mut chunk, triple_buff);
    //         string::append_utf8(&mut chunk, b"' ");
    //         string::append_utf8(&mut chunk, b"fill='#");
    //         string::append_utf8(&mut chunk, quadruple_buff);
    //         string::append_utf8(&mut chunk, b"' ");
    //         string::append_utf8(&mut chunk, b"/>");
    //         i = i + 1;
    //     };
    //
    //     let to_ascii = string::to_ascii(chunk);
    //     let to_bytes = ascii::into_bytes(to_ascii);
    //
    //     return to_bytes
    // }

    // public fun getChunk_(cursor: u64, buffer: vector<String>): String {
    //     let chunk = string::utf8(b"<rec width='");
    //     let i = 0;
    //     while (i < cursor) {
    //
    //         // debug::print(&string::utf8(b"buffer"));
    //         // debug::print(&buffer);
    //
    //
    //         let single_buff = vector::borrow(&buffer,i);
    //         let double_buff = vector::borrow(&buffer,i+1);
    //         let triple_buff = vector::borrow(&buffer,i+2);
    //         let quadruple_buff = vector::borrow(&buffer,i+3);
    //
    //         //
    //         // debug::print(&string::utf8(b"single_buff"));
    //         // debug::print(single_buff);
    //         // debug::print(&string::utf8(b"double_buff"));
    //         // debug::print(double_buff);
    //         // debug::print(&string::utf8(b"triple_buff"));
    //         // debug::print(triple_buff);
    //         // debug::print(&string::utf8(b"quadruple_buff"));
    //         // debug::print(quadruple_buff);
    //
    //         string::append(&mut chunk, *single_buff);
    //         string::append_utf8(&mut chunk, b"' ");
    //         string::append_utf8(&mut chunk, b"height='10' x='");
    //         string::append(&mut chunk, *double_buff);
    //         string::append_utf8(&mut chunk, b"' ");
    //         string::append_utf8(&mut chunk, b"y='");
    //         string::append(&mut chunk, *triple_buff);
    //         string::append_utf8(&mut chunk, b"' ");
    //         string::append_utf8(&mut chunk, b"fill='#");
    //         string::append(&mut chunk, *quadruple_buff);
    //         string::append_utf8(&mut chunk, b"' ");
    //         string::append_utf8(&mut chunk, b"/>");
    //         i = i + 4;
    //     };
    //     chunk
    // }



    public fun getChunk_(new_length:u64,new_currentX:u64,new_currentY:u64,new_hexColor:&String): String {
        let new_length_string = string::from_ascii(u64_to_string(new_length));
        let new_currentX_string = string::from_ascii(u64_to_string(new_currentX));
        let new_currentY_string = string::from_ascii(u64_to_string(new_currentY));
        let chunk = string::utf8(b"<rect width='");
        string::append(&mut chunk, new_length_string);
        string::append_utf8(&mut chunk, b"' ");
        string::append_utf8(&mut chunk, b"height='10' x='");
        string::append(&mut chunk, new_currentX_string);
        string::append_utf8(&mut chunk, b"' ");
        string::append_utf8(&mut chunk, b"y='");
        string::append(&mut chunk, new_currentY_string);
        string::append_utf8(&mut chunk, b"' ");
        string::append_utf8(&mut chunk, b"fill='#");
        string::append(&mut chunk, *new_hexColor);
        string::append_utf8(&mut chunk, b"' ");
        string::append_utf8(&mut chunk, b"/>");
        chunk
    }

    public fun getRectLength(currentX: u64, drawLength: u64, rightBound: u64): u64 {
        let remainingPixelsInLine = rightBound - currentX;

        if (drawLength <= remainingPixelsInLine){
            drawLength
        }else {
            remainingPixelsInLine
        }
    }

    fun u64_to_string(value: u64): ascii::String {
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

    /**
     * @notice Decode a single RLE compressed image into a `DecodedImage`.
     */
    public fun decodeRLEImage_(image: String): DecodedImage {
        let new_image = string::sub_string(&image,2,string::length(&image));


        let paletteIndex_hex = string::bytes(&string::sub_string(&new_image,0,2));
        let paletteIndex= hex_to_u8(paletteIndex_hex);


        let top_string = string::sub_string(&new_image,2,4);
        let top_hex = string::bytes(&top_string);

        let right_string = string::sub_string(&new_image,4,6);
        let right_hex = string::bytes(&right_string);

        let bottom_string = string::sub_string(&new_image,6,8);
        let bottom_hex = string::bytes(&bottom_string);

        let left_string = string::sub_string(&new_image,8,10);
        let left_hex = string::bytes(&left_string);

        let bounds = ContentBounds {
            top: hex_to_u8(top_hex),
            right: hex_to_u8(right_hex),
            bottom: hex_to_u8(bottom_hex),
            left: hex_to_u8(left_hex)
        };

        let rects_image = string::sub_string(&new_image,10,string::length(&new_image));

        let rects_image_length = string::length(&rects_image);

        let i = 0;
        let j = 0;
        let rects_image_vector =  vector::empty<String>();

        while (i < rects_image_length / 4){
            let rects_image_string = string::sub_string(&rects_image,j,j+4);
            vector::push_back(&mut rects_image_vector,rects_image_string);
            i = i + 1;
            j = j + 4;
        };


        let v = 0;
        let rects = vector::empty<Rect>();
        while (v <  vector::length(&rects_image_vector)){

            let string_vector = vector::borrow(&rects_image_vector,v);

            let length_new_string = string::sub_string(string_vector, 0,  2);
            let length = string::bytes(&length_new_string);
            let color_index_string = string::sub_string(string_vector,  2, 4);
            let color_index = string::bytes(&color_index_string);



            let new_rect = Rect {
                length:hex_to_u8(length),
                colorIndex:hex_to_u8(color_index)
            };
            // debug::print(&string::utf8(b"new_rect"));
            // debug::print(&new_rect);

            vector::push_back(&mut rects,new_rect);
            v = v + 1;
        };

        return DecodedImage {
            paletteIndex: paletteIndex,
            bounds: bounds,
            rects: rects
        }
    }



    fun hex_to_u8(hex_vector:&vector<u8>):u8{
        // debug::print(&string::utf8(b"hex_vector"));
        // debug::print(hex_vector);
        let value = 0u8;
        let (i,  l) = (0,  vector::length(hex_vector));
        assert!(l % 2 == 0, EInvalidHexLength);
        while (i < l) {
            value = (decode_byte(*vector::borrow(hex_vector, i)) * 16) +
                decode_byte(*vector::borrow(hex_vector, i + 1));
            i = i + 2;
        };
        return value
    }

    fun decode_byte(hex: u8): u8 {
        if (/* 0 .. 9 */ 48 <= hex && hex < 58) {
            hex - 48
        } else if (/* A .. F */ 65 <= hex && hex < 71) {
            10 + hex - 65
        } else if (/* a .. f */ 97 <= hex && hex < 103) {
            10 + hex - 97
        } else {
            abort ENotValidHexCharacter
        }
    }
}
