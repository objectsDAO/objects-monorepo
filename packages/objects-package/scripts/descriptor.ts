import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';
import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { bgcolors, palette, images } from '../files/image-data.json';


import {chunkArray} from "./utils";
// const { execSync } = require('child_process');

const main =  async () =>{

  const {bodies, mouths, decoration, masks} = images;

  // console.log(chunkArray(mouths, 10).map(chunk =>
  //   chunk.map(({ data }) => data),
  // ))
  const package_address = '0xe3b146d91c993afd7e22b3541fd41b5b479f4f2c2b2fd695dd05484f7079fb86'

  const suiClient = new SuiClient({ url: getFullnodeUrl('testnet') });
  const keypair = Ed25519Keypair.fromSecretKey(Buffer.from("0bc2bd8d2135c9c0ea18d56cb0b021788e79c7fdf3435c455a049ee92c532a57", 'hex'))
  const txb = new TransactionBlock();
  // 1sui
  txb.setGasBudget(1000000000)


  const descriptor = txb.pure('0x3ceee5cf8635f2ada99fccb300b952a01ffcfb34a033f82b429c0cd16503686b')


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


  txb.moveCall(
    {
      target:`${package_address}::descriptor::addManyMouths`,
      arguments: [txb.pure(mouths.map(({ data }) => data)),descriptor],
    }
  )

  // chunkArray(mouths, 10).map(chunk =>
  //   txb.moveCall(
  //     {
  //       target:`${package_address}::descriptor::addManyAccessories`,
  //       arguments: [txb.pure(chunk.map(({ data }) => data)),descriptor],
  //     }
  //   ),
  // )


  txb.moveCall(
    {
      target:`${package_address}::descriptor::addManyDecorations`,
      arguments: [txb.pure(decoration.map(({ data }) => data)),descriptor],
    }
  )


  // chunkArray(decoration, 10).map(chunk =>
  //   txb.moveCall(
  //     {
  //       target:`${package_address}::descriptor::addManyHeads`,
  //       arguments: [txb.pure(chunk.map(({ data }) => data)),descriptor],
  //     }
  //   )
  // )

  txb.moveCall(
    {
      target:`${package_address}::descriptor::addManyMasks`,
      arguments: [txb.pure(masks.map(({ data }) => data)),descriptor],
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
