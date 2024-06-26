import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';
import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import {OBJECT} from "./package";


const main =  async () =>{


  const package_address = '0x60c5c57650f9ed5006a26c3c832455f1d7a3aef80b62a74c8f4b0a5f50b18b3b'

  const suiClient = new SuiClient({ url: getFullnodeUrl('testnet') });
  const keypair = Ed25519Keypair.fromSecretKey(Buffer.from("0bc2bd8d2135c9c0ea18d56cb0b021788e79c7fdf3435c455a049ee92c532a57", 'hex'))
  const txb = new TransactionBlock();
  // 5sui
  txb.setGasBudget(5000000000)


  const descriptor = txb.pure('0xb9eed160832edf5ec64b1d2fb0fb035bb9d580f77bf28dd0926a59149bc02bb8')


  txb.moveCall(
    {
      target:`${package_address}::objects_seeder::mint`,
      arguments: [txb.pure(0),txb.pure("0x6"),descriptor],
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
