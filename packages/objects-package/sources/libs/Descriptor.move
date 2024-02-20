module objectsDAO::Descriptor {
    use std::string::String;
    use std::vector;
    use objectsDAO::ObjectsSeeder::{Seed, get_seed};
    use sui::table;
    use sui::table::Table;
    use objectsDAO::MultiPartRLEToSVG::{SVGParams, create_svg_params};
    use objectsDAO::MultiPartRLEToSVG;


    struct ObjectsDescriptor has key,store{
        // Noun Color Palettes (Index => Hex Colors)
        palettes:Table<u8,String>,
        // Noun Backgrounds (Hex Colors)
        backgrounds:vector<String>,
        // Noun Bodies (Custom RLE)
        bodies:vector<vector<u8>>,
        // Noun Accessories (Custom RLE)
        accessories:vector<vector<u8>>,
        // Noun Heads (Custom RLE)
        heads:vector<vector<u8>>,
        // Noun Glasses (Custom RLE)
        glasses:vector<vector<u8>>
    }


    // /**
    //  * @notice Generate an SVG image for use in the object URI.
    //     return svg:string
    //  */
    // public fun generateSVGImage(params:SVGParams,objectsArt:ObjectsArt):String{
    //     let svg = MultiPartRLEToSVG::generateSVG(params, objectsArt);
    //     let svg_encode_vector = base64::encode(&svg);
    //     let svg_encode= string::utf8(svg_encode_vector);
    //     return svg_encode
    // }


    /**
    * @notice Given a seed, construct a base64 encoded SVG image.
    */
    fun generateSVGImage(seed:Seed):String{
        let parts =
        let params =
        MultiPartRLEToSVG.SVGParams memory params = create_svg_params()

        MultiPartRLEToSVG.SVGParams memory params = MultiPartRLEToSVG.SVGParams({
            parts: _getPartsForSeed(seed),
            background: backgrounds[seed.background]
        });
        return NFTDescriptor.generateSVGImage(params, palettes);
    }

    /**
     * @notice Add a single color to a color palette.
     */
    public fun addColorToPalette_(paletteIndex:u8,color:String,objects_descriptor:&mut ObjectsDescriptor){
        table::add(objects_descriptor,paletteIndex,color)
    }

    /**
     * @notice Add a Noun background.
     */
    public fun addBackground_(background:String,objects_descriptor:&mut ObjectsDescriptor) {
        let i = vector::length(&objects_descriptor.backgrounds);
        vector::insert(&mut objects_descriptor.backgrounds, background, i);
    }

    /**
     * @notice Add a Noun body.
     */
    public fun addBody_(body:vector<u8>,objects_descriptor:&mut ObjectsDescriptor) {
        let i = vector::length(&objects_descriptor.bodies);
        vector::insert(&mut objects_descriptor.bodies, body, i);
    }

    /**
     * @notice Add a Noun accessory.
     */
    public fun addAccessory_(accessory:vector<u8>,objects_descriptor:&mut ObjectsDescriptor){
        let i = vector::length(&objects_descriptor.accessories);
        vector::insert(&mut objects_descriptor.accessories, accessory, i);
    }

    /**
     * @notice Add a Noun head.
     */
    public fun addHead_(head:vector<u8>,objects_descriptor:&mut ObjectsDescriptor) {
        let i = vector::length(&objects_descriptor.heads);
        vector::insert(&mut objects_descriptor.heads, head, i);
    }

    /**
     * @notice Add Noun glasses.
     */
    fun addGlasses_(glasses:vector<u8>,objects_descriptor:&mut ObjectsDescriptor) {
        let i = vector::length(&objects_descriptor.glasses);
        vector::insert(&mut objects_descriptor.glasses, glasses, i);
    }

    /**
     * @notice Get all Noun parts for the passed `seed`.
     */
    fun getPartsForSeed_(seed:Seed,objects_descriptor:&ObjectsDescriptor):vector<vector<u8>> {
        let (_background,body,accessory,head,glasses) = get_seed(seed);
        let body = *vector::borrow(&objects_descriptor.bodies,body);
        let accessory = *vector::borrow(&objects_descriptor.bodies,accessory);
        let head = *vector::borrow(&objects_descriptor.bodies,head);
        let glasses = *vector::borrow(&objects_descriptor.bodies,glasses);
        let parts:vector<u8> = vector[body,accessory,head,glasses];
        parts
    }
}
