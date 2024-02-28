import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';
import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { bgcolors, partcolors, parts } from '../files/encoded-layers.json';
import {chunkArray} from "./utils";
// const { execSync } = require('child_process');

const main =  async () =>{

  const [bodies, accessories, heads, glasses] = parts;

  // console.log(chunkArray(accessories, 10).map(chunk =>
  //   chunk.map(({ data }) => data),
  // ))
  const package_address = '0x8354a55741b6eb7f7720c78027bc659627e77e821b6321f09d48c931375bee23'

  const suiClient = new SuiClient({ url: getFullnodeUrl('testnet') });
  const keypair = Ed25519Keypair.fromSecretKey(Buffer.from("0bc2bd8d2135c9c0ea18d56cb0b021788e79c7fdf3435c455a049ee92c532a57", 'hex'))
  const txb = new TransactionBlock();
  // 1sui
  txb.setGasBudget(1000000000)


  const descriptor = txb.pure('0xdc77eee8deff2383866a8a47e148ec87b740279ac862250ee2aafe90739ed4f4')


  txb.moveCall(
    {
      target:`${package_address}::Descriptor::addColorsToPalette`,
      arguments: [txb.pure(0),txb.pure(partcolors),descriptor],
    }
  )

  txb.moveCall(
    {
      target:`${package_address}::Descriptor::addManyBackgrounds`,
      arguments: [txb.pure(bgcolors),descriptor],
    }
  )

  txb.moveCall(
    {
      target:`${package_address}::Descriptor::addManyBodies`,
      arguments: [txb.pure(bodies.map(({ data }) => data)),descriptor],
    }
  )


  chunkArray(accessories, 10).map(chunk =>
    txb.moveCall(
      {
        target:`${package_address}::Descriptor::addManyAccessories`,
        arguments: [txb.pure(chunk.map(({ data }) => data)),descriptor],
      }
    ),
  )



  chunkArray(heads, 10).map(chunk =>
    txb.moveCall(
      {
        target:`${package_address}::Descriptor::addManyHeads`,
        arguments: [txb.pure(chunk.map(({ data }) => data)),descriptor],
      }
    )
  )

  txb.moveCall(
    {
      target:`${package_address}::Descriptor::addManyGlasses`,
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
