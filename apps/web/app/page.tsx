'use client'

import {ConnectButton, useSuiClientQuery} from "@mysten/dapp-kit";
import { Button } from "@repo/ui/components/ui/button";
import Image from 'next/image'
import Link from "next/link";

import {Content} from "./components/content";
import {Footer} from "./components/footer";
import {AuctionActivity} from "./components/auctionactivity";

export default function Page() {

  const { data, isPending, isError, error, refetch } = useSuiClientQuery(
    'getAllBalances',
    {
      owner: '0x2cf0029ed0845f27da4af2f3bb252437c4e33378332b873b53b88dfc1dba4fb1'
    },
    {
      gcTime: 10000,
    },
  );

  const address = 'https://suiexplorer.com/address/0x2cf0029ed0845f27da4af2f3bb252437c4e33378332b873b53b88dfc1dba4fb1?network=testnet'

  return (
          <main className='flex flex-col min-h-screen min-w-full'>
              {/*navbar */}
              <div className='flex items-center justify-around bg-zinc-300 py-6'>
                {/*logo&& Treasury*/}
                <div className='flex items-center'>
                  <div>
                    <Link href={address}>
                      <Image
                        src='/noggles.svg'
                        width={80}
                        height={80}
                        alt="Picture of the author"
                      />
                    </Link>
                  </div>
                  <div className='ml-5'>
                    <Link href={address}>
                      <Button  variant="outline" className='font-bold bg-zinc-300 '>
                        Treasury Ξ {data?.map((balance) => (
                            `Ξ 0.${balance.totalBalance} SUI`
                      ))}
                      </Button>
                    </Link>
                  </div>
                </div>
                <div>
                  <ConnectButton/>
                </div>
              </div>
              {/* image  */}
            <div className='flex items-center justify-around'>
              <Image
                src='/loading-skull-noun.gif'
                width={800}
                height={800}
                alt="Picture of the author"
              />
              <AuctionActivity/>
            </div>
              <Content/>
              <Footer/>
          </main>
  );
}
