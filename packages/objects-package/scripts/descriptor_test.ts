import { bgcolors, partcolors, parts } from '../files/encoded-layers.json';
import {chunkArray} from "./utils";
import { promises as fs } from 'fs';
import path from "path";

const main =  async () =>{

  const [bodies, accessories, heads, glasses] = parts;



    // let a = bodies.map(({ data }) => `b${data}`)
    // let a = accessories.map(({ data }) => `b${data}`)
    // let a = heads.map(({ data }) => `b${data}`,)
    let a = glasses.map(({ data }) => `b${data}`)

    const DESTINATION = path.join(__dirname, '../files/image-data.json');
    await fs.writeFile(
        DESTINATION,
        JSON.stringify(
            {
              a
            },
            null,
            2,
        ),
    );


}

main();
