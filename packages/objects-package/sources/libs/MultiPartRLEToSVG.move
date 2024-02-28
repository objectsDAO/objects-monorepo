module objectsDAO::MultiPartRLEToSVG {
    use std::string;
    use std::ascii;
    use std::debug;
    use std::string::String;
    use std::vector;
    use objectsDAO::Descriptor::{ObjectsDescriptor, get_palettes, get_mut_palettes};
    use sui::bcs;
    use sui::table;


    struct SVGParams has drop {
        parts:vector<vector<u8>>,
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

    public fun create_svg_params(parts:vector<vector<u8>,>,background:String):SVGParams{
        SVGParams{
            parts,
            background
        }
    }

    /**
     * @notice Given RLE image parts and color palettes, merge to generate a single SVG image.
     */
    public fun generateSVG(params:SVGParams,objects_descriptor:&mut ObjectsDescriptor): vector<u8> {
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
        string::append_utf8(&mut svg, svg_rect);
        string::append(&mut svg, svg_tail);


        let to_ascii = string::to_ascii(svg);
        // let to_bytes = ascii::into_bytes(to_ascii);
        let to_bytes = ascii::into_bytes(to_ascii);
        return to_bytes
    }

    /**
     * @notice Given RLE image parts and color palettes, generate SVG rects.
     */
    public fun generateSVGRects_(params:SVGParams,objects_descriptor:&mut ObjectsDescriptor): vector<u8> {
        let lookup:vector<String> =
          vector[
            string::utf8(b"0"),
            string::utf8(b"10"),
            string::utf8(b"20"),
            string::utf8(b"30"),
            string::utf8(b"40"),
            string::utf8(b"50"),
            string::utf8(b"60"),
            string::utf8(b"70"),
            string::utf8(b"80"),
            string::utf8(b"90"),
            string::utf8(b"100"),
            string::utf8(b"110"),
            string::utf8(b"120"),
            string::utf8(b"130"),
            string::utf8(b"140"),
            string::utf8(b"150"),
            string::utf8(b"160"),
            string::utf8(b"170"),
            string::utf8(b"180"),
            string::utf8(b"190"),
            string::utf8(b"200"),
            string::utf8(b"210"),
            string::utf8(b"220"),
            string::utf8(b"230"),
            string::utf8(b"240"),
            string::utf8(b"250"),
            string::utf8(b"260"),
            string::utf8(b"270"),
            string::utf8(b"280"),
            string::utf8(b"290"),
            string::utf8(b"300"),
            string::utf8(b"310"),
            string::utf8(b"320"),
          ];
        let rects = string::utf8(b"");

        let p = 0;
        let len = vector::length(&params.parts);



        while (p < len) {
            debug::print(&string::utf8(b"len"));
            debug::print(&len);
            debug::print(&string::utf8(b"p"));
            debug::print(&p);
            let image = decodeRLEImage_(*vector::borrow(&params.parts,p));
            // debug::print(&string::utf8(b"image.paletteIndex"));
            // debug::print(&image.paletteIndex);

            let palettes_table = get_mut_palettes(objects_descriptor);

            // debug::print(&string::utf8(b"palettes_table"));
            // debug::print(&table::contains(palettes_table,image.paletteIndex));
            let bool = table::contains(palettes_table, image.paletteIndex);
            if (!bool) {
              table::add(palettes_table, image.paletteIndex,vector[string::utf8(b"")]);
            };

            let palette = table::borrow(palettes_table, image.paletteIndex);

            let currentX = (image.bounds.left as u256);
            let currentY = (image.bounds.top as u256);
            let cursor = 0;

            let buffer:String = string::utf8(b"");
            let part = string::utf8(b"");

            let i = 0;
            let len = vector::length(&image.rects);
            while (i < len) {
                let rect = vector::borrow(&image.rects,i);
                let (_length,color_index) = get_rect_length_and_colorIndex(rect);

                if (color_index != 0) {
                    // debug::print(&rect.length);
                    // debug::print(&color_index);

                    let width = *vector::borrow(&lookup,(rect.length as u64));
                    let x = *vector::borrow(&lookup,(currentX as u64));
                    let y = *vector::borrow(&lookup,(currentY as u64));
                    let color_Index = *vector::borrow(palette,(color_index as u64));

                    string::insert(&mut buffer, cursor, width);
                    string::insert(&mut buffer, cursor + 1, x);
                    string::insert(&mut buffer, cursor + 2, y);
                    string::insert(&mut buffer,  cursor + 3,color_Index);
                    cursor = cursor + 4;

                    if (cursor >= 16) {
                        string::append_utf8(&mut part, getChunk_(cursor, (*string::bytes(&buffer))));
                        cursor = 0;
                    };
                };

                // debug::print(&currentX);
                // debug::print(&rect.length);



                currentX = currentX + (rect.length as u256);
                if (currentX == (image.bounds.right as u256)) {
                    currentX = (image.bounds.left as u256);
                    currentY = currentY + 1;
                }
            };

            if (cursor != 0) {
                string::append_utf8(&mut part, getChunk_(cursor,(*string::bytes(&buffer))));
            };

            string::append(&mut rects, part);
        };

        let to_ascii = string::to_ascii(rects);
        let to_bytes = ascii::into_bytes(to_ascii);

        return to_bytes
    }
    /**
     * @notice Return a string that consists of all rects in the provided `buffer`.
     */
    public fun getChunk_(cursor: u64, buffer: vector<u8>): vector<u8> {
        let chunk = string::utf8(b"<rec width='");
        let i = 0;
        while (i < cursor) {
            let single_buff = bcs::to_bytes(vector::borrow(&buffer, i));
            let double_buff = bcs::to_bytes(vector::borrow(&buffer, i + 1));
            let triple_buff = bcs::to_bytes(vector::borrow(&buffer, i + 2));
            let quadruple_buff = bcs::to_bytes(vector::borrow(&buffer, i + 3));
            string::append_utf8(&mut chunk, single_buff);
            string::append_utf8(&mut chunk, b"' ");
            string::append_utf8(&mut chunk, b"height='10' x='");
            string::append_utf8(&mut chunk, double_buff);
            string::append_utf8(&mut chunk, b"' ");
            string::append_utf8(&mut chunk, b"y='");
            string::append_utf8(&mut chunk, triple_buff);
            string::append_utf8(&mut chunk, b"' ");
            string::append_utf8(&mut chunk, b"fill='#");
            string::append_utf8(&mut chunk, quadruple_buff);
            string::append_utf8(&mut chunk, b"' ");
            string::append_utf8(&mut chunk, b"/>");
            i = i + 1;
        };

        let to_ascii = string::to_ascii(chunk);
        let to_bytes = ascii::into_bytes(to_ascii);

        return to_bytes
    }

    /**
     * @notice Decode a single RLE compressed image into a `DecodedImage`.
     */
    public fun decodeRLEImage_(image: vector<u8>): DecodedImage {
        // debug::print(&string::utf8(b"image"));
        // debug::print(&image);
        // extract palette index from byte array
        let paletteIndex = *vector::borrow(&image, 0);
        // debug::print(&string::utf8(b"paletteIndex"));
        // debug::print(&paletteIndex);
        // extract content bounds from byte array
        let bounds = ContentBounds {
            top: *vector::borrow(&image, 1),
            right: *vector::borrow(&image, 2),
            bottom: *vector::borrow(&image, 3),
            left: *vector::borrow(&image, 4)
        };

        let len = vector::length(&image);
        // let rect_count = (len - 5) / 2;
        let rects = vector::empty<Rect>();
        let cursor = 0;
        let i = 5;


        while (i < len) {

            debug::print(&string::utf8(b"i"));
            debug::print(&i);
            let length = *vector::borrow(&image, i);
            let color_index = 0;

            // if ( (i+1) != len) {
            //   color_index = *vector::borrow(&image, i + 1);
            // };

            let new_rect = Rect {
              length,
              colorIndex:color_index
            };
            // debug::print(&string::utf8(b"new_rect"));
            // debug::print(&new_rect);

          // debug::print(&string::utf8(b"i + 1"));
          // debug::print(&(i + 1));
            vector::insert(&mut rects, new_rect, cursor);
            cursor = cursor + 1;
            i = i + 2;
        };

        return DecodedImage {
            paletteIndex: paletteIndex,
            bounds: bounds,
            rects: rects
        }
    }
}
