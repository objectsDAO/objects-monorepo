module objectsDAO::ObjectsSeeder {

    struct Seed has drop {
        background:u64,
        body:u64,
        accessory:u64,
        head:u64,
        glasses:u64
    }



    fun generateSeed(object_id:u256) :Seed {

    }

    public fun get_seed(seed:Seed):(u64,u64,u64,u64,u64){
        (seed.background,seed.body,seed.accessory,seed.head,seed.glasses)
    }
}
