
import { Button } from "@ui/components/ui/button"
import { Input } from "@ui/components/ui/input"

export const AuctionActivity = () => {
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
        <Button className='h-14 w-28' type="submit">Place Bid</Button>
      </div>
    </div>
  )
}
