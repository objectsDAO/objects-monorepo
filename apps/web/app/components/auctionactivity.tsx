
import { Button } from "@ui/components/ui/button"
import { Input } from "@ui/components/ui/input"

export const AuctionActivity = () => {
  return (

    <div>
      <div className='flex flex-col'>
          <div>
            Object 0
          </div>
        <div className='flex'>
          <div>
            <div>
              Current bid
            </div>
            <div>
              Ξ 7.09
            </div>
          </div>
          <div>
            <div>
              Auction ends in
            </div>
            <div>
              10:32:47 PM
            </div>
          </div>
        </div>
      </div>
      <div className="flex w-full max-w-sm items-center space-x-2">
        <Input type="email" placeholder="Ξ 0.001 or more" />
        <Button type="submit">Place Bid</Button>
      </div>
    </div>
  )
}
