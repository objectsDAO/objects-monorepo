module objectsDAO::Descriptor {
    use std::string::String;
    use std::vector;
  use sui::object;
  use sui::object::UID;
  use sui::table;
  use sui::table::Table;
    use sui::transfer;
  use sui::tx_context::TxContext;


  struct ObjectsDescriptor has key,store{
          id:UID,
          // Noun Color Palettes (Index => Hex Colors)
          palettes:Table<u8,vector<String>>,
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

    fun init(ctx: &mut TxContext) {
      let objects_descriptor = ObjectsDescriptor {
        id: object::new(ctx),
        // Noun Color Palettes (Index => Hex Colors)
        palettes:table::new<u8,vector<String>>(ctx),
        // Noun Backgrounds (Hex Colors)
        backgrounds:vector::empty<String>(),
        // Noun Bodies (Custom RLE)
        bodies:vector::empty<vector<u8>>(),
        // Noun Accessories (Custom RLE)
        accessories:vector::empty<vector<u8>>(),
        // Noun Heads (Custom RLE)
        heads:vector::empty<vector<u8>>(),
        // Noun Glasses (Custom RLE)
        glasses:vector::empty<vector<u8>>(),
      };
      // Transfer the forge object to the module/package publisher
      transfer::public_share_object(objects_descriptor);
    }

    /**
    * @notice Get the number of available Noun `backgrounds`.
    */
    public fun backgroundCount(objects_descriptor:&mut ObjectsDescriptor):u256 {
        (vector::length(&objects_descriptor.backgrounds) as u256)
    }

  /**
   * @notice Get the number of available Noun `bodies`.
   */
    public fun bodyCount(objects_descriptor:&mut ObjectsDescriptor):u256 {
        (vector::length(&objects_descriptor.bodies) as u256)
    }

  /**
   * @notice Get the number of available Noun `accessories`.
   */
    public fun accessoryCount(objects_descriptor:&mut ObjectsDescriptor):u256 {
        (vector::length(&objects_descriptor.accessories) as u256)
    }

  /**
   * @notice Get the number of available Noun `heads`.
   */
    public fun headCount(objects_descriptor:&mut ObjectsDescriptor):u256{
        (vector::length(&objects_descriptor.heads) as u256)
    }

  /**
   * @notice Get the number of available Noun `glasses`.
   */
    public fun glassesCount(objects_descriptor:&mut ObjectsDescriptor):u256 {
      (vector::length(&objects_descriptor.glasses) as u256)
    }

    /**
     * @notice Add a single color to a color palette.
     */
    public fun addColorToPalette_(paletteIndex:u8,color:vector<String>,objects_descriptor:&mut ObjectsDescriptor){
        table::add<u8,vector<String>>(&mut objects_descriptor.palettes,paletteIndex,color)
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
    public fun addGlasses_(glasses:vector<u8>,objects_descriptor:&mut ObjectsDescriptor) {
        let i = vector::length(&objects_descriptor.glasses);
        vector::insert(&mut objects_descriptor.glasses, glasses, i);
    }


    public fun get_backgrounds(objects_descriptor:&ObjectsDescriptor):&vector<String>{
      &objects_descriptor.backgrounds
    }

    public fun get_bodies(objects_descriptor:&ObjectsDescriptor):&vector<vector<u8>>{
      &objects_descriptor.bodies
    }

    public fun get_accessories(objects_descriptor:&ObjectsDescriptor):&vector<vector<u8>>{
      &objects_descriptor.accessories
    }

    public fun get_heads(objects_descriptor:&ObjectsDescriptor):&vector<vector<u8>>{
      &objects_descriptor.heads
    }

    public fun get_glasses(objects_descriptor:&ObjectsDescriptor):&vector<vector<u8>>{
      &objects_descriptor.glasses
    }

    public fun get_palettes(objects_descriptor:&ObjectsDescriptor):&Table<u8,vector<String>>{
      &objects_descriptor.palettes
    }



}
