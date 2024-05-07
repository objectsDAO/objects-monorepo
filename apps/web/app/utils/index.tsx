import type {
  SuiTransactionBlockResponse,
  DevInspectResults,
  SuiMoveNormalizedModules,
  SuiObjectData,
} from "@0xobelisk/sui-client";
import { getSuiMoveConfig, BCS } from "@0xobelisk/sui-client";

export function formatQueryResult(txResult: DevInspectResults) {
  let returnValue = [];
  const bcs = new BCS(getSuiMoveConfig());

  //   struct Bidder has copy, store {
  //     bid_time: u64,
  //     bid_price: u64,
  //     bid_address: address
  //   }

  //   struct Auction has copy, store {
  //      object_address: ID,
  //     // The current highest bid amount
  //       amount: u64,
  //     // The time that the auction started
  //       start_time:u64,
  //     // The time that the auction is scheduled to end
  //       end_time:u64,
  //     // The address of the current highest bid
  //       payable_bidder:address,

  //       bid_list: vector<Bidder>,
  //   }

  // "success" | "failure";
  if (txResult.effects.status.status === "success") {
    const resultList = txResult.results![0].returnValues!;
    for (const res of resultList) {
      const value = Uint8Array.from(res[0]);
      const bcsType = res[1].replace(/0x1::ascii::String/g, "string");
      const data = bcs.de("0x1::ascii::String", value);
      console.log(data);
      returnValue.push(data);
    }
    return returnValue;
  } else {
    return undefined;
  }
}

export function convertBalanceToCurrency(balance: number): string {
    const amount = balance / Math.pow(10, 8);
    const formattedAmount = amount.toFixed(2);
    return formattedAmount;
}
