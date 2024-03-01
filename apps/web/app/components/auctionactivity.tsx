import {
  ConnectButton,
  useCurrentAccount,
  useSignAndExecuteTransactionBlock,

} from '@mysten/dapp-kit';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { Button } from "@ui/components/ui/button"
import { Input } from "@ui/components/ui/input"

export const AuctionActivity = () => {
  const { mutate: signAndExecuteTransactionBlock } = useSignAndExecuteTransactionBlock();


  const test_mint = () =>{

    const package_address = '0x60c5c57650f9ed5006a26c3c832455f1d7a3aef80b62a74c8f4b0a5f50b18b3b'

    const txb = new TransactionBlock();
    // 5sui
    txb.setGasBudget(2000000000)

    const descriptor = txb.pure('0xb9eed160832edf5ec64b1d2fb0fb035bb9d580f77bf28dd0926a59149bc02bb8')

    txb.moveCall(
      {
        target:`${package_address}::objects_seeder::mint`,
        arguments: [txb.pure(0),txb.pure("0x6"),descriptor],
      }
    )

    signAndExecuteTransactionBlock(
      {
        transactionBlock: txb,
        chain: 'sui:testnet',
      },
      {
        onSuccess: (result) => {
          console.log('executed transaction block', result);
        },
      },
    );
  }

  return (

    <div className=''>
      <div className='flex flex-col w-full'>
          <div className='mb-20 text-5xl font-medium'>
            Object 0
          </div>
        <div className='flex items-center justify-between'>
          <div >
            <div>
              Current bid
            </div>
            <div className='text-3xl font-medium'>
              Ξ 7.09
            </div>
          </div>
          <div>
            <div>
              Auction ends in
            </div>
            <div className='text-3xl font-medium'>
              10:32:47 PM
            </div>
          </div>
        </div>
      </div>
      <div className="flex w-full max-w-sm items-center mt-20 space-x-2 ">
        <Input className='h-14' type="email" placeholder="Ξ 0.001 or more" />
        <Button className='h-14 w-28' onClick={test_mint} type="submit">Place Bid</Button>
      </div>
    </div>
  )
}
