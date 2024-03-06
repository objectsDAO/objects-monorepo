import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';
import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import {OBJECT} from "./package";


const main =  async () =>{


  const package_address = '0xe3b146d91c993afd7e22b3541fd41b5b479f4f2c2b2fd695dd05484f7079fb86'

  const suiClient = new SuiClient({ url: getFullnodeUrl('testnet') });
  const keypair = Ed25519Keypair.fromSecretKey(Buffer.from("0bc2bd8d2135c9c0ea18d56cb0b021788e79c7fdf3435c455a049ee92c532a57", 'hex'))
  const txb = new TransactionBlock();
  // 5sui
  txb.setGasBudget(5000000000)


  const descriptor = txb.pure('0x3ceee5cf8635f2ada99fccb300b952a01ffcfb34a033f82b429c0cd16503686b')


  txb.moveCall(
    {
      target:`${package_address}::objects_seeder::mint`,
      arguments: [
        txb.pure('0xb87c85983394eaa66572e8d0b4d51374d74cab6a04c26edc73b10df3f290a183'),
        txb.pure(0),
        txb.pure("0x6"),
        descriptor],
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
