import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';
import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { bgcolors, palette, images } from '../files/image-data.json';


import {chunkArray} from "./utils";
// const { execSync } = require('child_process');

const main =  async () =>{

  const {bodies, accessories, heads, glasses} = images;

  // console.log(chunkArray(accessories, 10).map(chunk =>
  //   chunk.map(({ data }) => data),
  // ))
  const package_address = '0x60c5c57650f9ed5006a26c3c832455f1d7a3aef80b62a74c8f4b0a5f50b18b3b'

  const suiClient = new SuiClient({ url: getFullnodeUrl('testnet') });
  const keypair = Ed25519Keypair.fromSecretKey(Buffer.from("0bc2bd8d2135c9c0ea18d56cb0b021788e79c7fdf3435c455a049ee92c532a57", 'hex'))
  const txb = new TransactionBlock();
  // 1sui
  txb.setGasBudget(1000000000)


  const descriptor = txb.pure('0xb9eed160832edf5ec64b1d2fb0fb035bb9d580f77bf28dd0926a59149bc02bb8')


  txb.moveCall(
    {
      target:`${package_address}::descriptor::addColorsToPalette`,
      arguments: [txb.pure(0),txb.pure(palette),descriptor],
    }
  )

  txb.moveCall(
    {
      target:`${package_address}::descriptor::addManyBackgrounds`,
      arguments: [txb.pure(bgcolors),descriptor],
    }
  )

  txb.moveCall(
    {
      target:`${package_address}::descriptor::addManyBodies`,
      arguments: [txb.pure(bodies.map(({ data }) => data)),descriptor],
    }
  )


  chunkArray(accessories, 10).map(chunk =>
    txb.moveCall(
      {
        target:`${package_address}::descriptor::addManyAccessories`,
        arguments: [txb.pure(chunk.map(({ data }) => data)),descriptor],
      }
    ),
  )



  chunkArray(heads, 10).map(chunk =>
    txb.moveCall(
      {
        target:`${package_address}::descriptor::addManyHeads`,
        arguments: [txb.pure(chunk.map(({ data }) => data)),descriptor],
      }
    )
  )

  txb.moveCall(
    {
      target:`${package_address}::descriptor::addManyGlasses`,
      arguments: [txb.pure(glasses.map(({ data }) => data)),descriptor],
    }
  )

  const result = await suiClient.signAndExecuteTransactionBlock({
    transactionBlock: txb,
    signer: keypair,
    requestType: 'WaitForLocalExecution',
    options: {
      showEffects: true,
    },
  });
  console.log(result)

}

main();
