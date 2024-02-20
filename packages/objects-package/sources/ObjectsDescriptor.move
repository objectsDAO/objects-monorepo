module objectsDAO::ObjectsDescriptor {
    use std::string::String;
    use sui::table::Table;

    struct ObjectsArt has key,store {
        palettes:Table<u8,String>

    }

    public fun get_palettes(objects_art:ObjectsArt):Table<u8,String>{
        return objects_art.palettes
    }
}
