"use client";

import { Button } from "@repo/ui/components/ui/button";
import React, { useState, useEffect } from "react";
import {
  GovManager,
  NETWORK,
  OBJECT_ADDRESS,
  OBJECT_TYPE,
  PACKAGE_ID,
} from "../../chain/config";
import {
  Obelisk,
  loadMetadata,
  TransactionBlock,
  ObeliskObjectContent,
} from "@0xobelisk/sui-client";
import { Input } from "@repo/ui/components/ui/input";
import { Label } from "@repo/ui/components/ui/label";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@repo/ui/components/ui/dialog";
import {
  ConnectButton,
  useCurrentAccount,
  useSignAndExecuteTransactionBlock,
} from "@mysten/dapp-kit";
import { toast } from "sonner";

type ProposalType = {
  fields: {
    approve_num: string;
    creater: string;
    deny_num: string;
    description: string;
    end_timestamp: string;
    executed_hash: string;
    id: string;
    name: string;
    start_timestamp: string;
  };
};

export default function Page({ params }: { params: { id: string } }) {
  const [voteOpen, setVoteOpen] = useState(false);
  const [executeOpen, setExecuteOpen] = useState(false);
  const [executedHash, setExecutedHash] = useState("");
  const [proposal, setProposal] = React.useState<ProposalType>({
    fields: {
      approve_num: "",
      creater: "",
      deny_num: "",
      description: "",
      end_timestamp: "",
      executed_hash: "",
      id: "",
      name: "",
      start_timestamp: "",
    },
  });
  const [ownedObjects, setOwnedObjects] = React.useState([]);

  const { mutate: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransactionBlock();
  const address = useCurrentAccount()?.address;

  // useEffect(() => {
  //   const query_proposal = async (proposal_id: string) => {
  //     const metadata = await loadMetadata(NETWORK, PACKAGE_ID);

  //     const obelisk = new Obelisk({
  //       networkType: NETWORK,
  //       packageId: PACKAGE_ID,
  //       metadata: metadata,
  //     });

  //     const tx = new TransactionBlock();
  //     const proposalParams = [tx.pure(GovManager), tx.pure(proposal_id)];
  //     const proposal: any[] = await obelisk.query.gov.get_proposal(
  //       tx,
  //       proposalParams,
  //     );
  //     console.log(proposal);
  //     setProposal(proposal[0]);
  //   };
  //   query_proposal(params.id);
  // }, [proposal]);

  useEffect(() => {
    const query_proposal = async () => {
      const metadata = await loadMetadata(NETWORK, PACKAGE_ID);

      const obelisk = new Obelisk({
        networkType: NETWORK,
        packageId: PACKAGE_ID,
        metadata: metadata,
      });
      const govObject = await obelisk.getObject(GovManager);
      const itemObjectContent = govObject.content;
      if (itemObjectContent != null) {
        const objectContent = itemObjectContent as ObeliskObjectContent;
        const objectFields = objectContent.fields as Record<string, any>;
        setProposal(objectFields.proposals[params.id]);
      }
    };
    query_proposal();
  }, [proposal]);

  useEffect(() => {
    const query_owned_objects = async () => {
      const metadata = await loadMetadata(NETWORK, PACKAGE_ID);

      const obelisk = new Obelisk({
        networkType: NETWORK,
        packageId: PACKAGE_ID,
        metadata: metadata,
      });

      try {
        const objects = await obelisk.selectObjectsWithType(
          OBJECT_TYPE,
          address,
        );
        setOwnedObjects(objects);
        console.log(objects);
      } catch {
        console.log("no object");
      }
    };
    query_owned_objects();
  }, [ownedObjects]);

  const handleVote = async (voteChoise) => {
    console.log("vote");
    const metadata = await loadMetadata(NETWORK, PACKAGE_ID);

    const obelisk = new Obelisk({
      networkType: NETWORK,
      packageId: PACKAGE_ID,
      metadata: metadata,
    });

    const tx = new TransactionBlock();
    const voteParams = [
      tx.pure(ownedObjects[0]),
      tx.pure(GovManager),
      tx.pure("0x6"),
      tx.pure(params.id),
      tx.pure(voteChoise),
    ];

    // _objects: &Objects,
    // gov_manager:&mut GovManager,
    // clock: &Clock,
    // proposal_id: u64,
    // decision: bool,
    await obelisk.tx.gov.vote(
      tx,
      voteParams, // params
      undefined, // typeArguments
      true,
    );

    signAndExecuteTransactionBlock(
      {
        transactionBlock: tx,
      },
      {
        onSuccess: async (result) => {
          toast("Translation Successful", {
            description: new Date().toUTCString(),
            action: {
              label: "Check in Explorer ",
              onClick: () => {
                const hash = result.digest;
                window.open(`https://suiscan.xyz/devnet/tx/${hash}`, "_blank"); // 在新页面中打开链接
              },
            },
          });
        },
      },
    );

    setTimeout(async () => {}, 1000);
    setVoteOpen(false);
  };

  const handleExecute = async () => {
    console.log("vote");
    const metadata = await loadMetadata(NETWORK, PACKAGE_ID);

    const obelisk = new Obelisk({
      networkType: NETWORK,
      packageId: PACKAGE_ID,
      metadata: metadata,
    });
    const tx = new TransactionBlock();
    const confirmParams = [
      tx.pure(GovManager),
      tx.pure("0x6"),
      tx.pure(params.id),
      tx.pure(executedHash),
    ];
    await obelisk.tx.gov.excuted_confirm(
      tx,
      confirmParams, // params
      undefined, // typeArguments
      true,
    );

    signAndExecuteTransactionBlock(
      {
        transactionBlock: tx,
      },
      {
        onSuccess: async (result) => {
          toast("Translation Successful", {
            description: new Date().toUTCString(),
            action: {
              label: "Check in Explorer ",
              onClick: () => {
                const hash = result.digest;
                window.open(`https://suiscan.xyz/devnet/tx/${hash}`, "_blank"); // 在新页面中打开链接
              },
            },
          });
        },
      },
    );

    setTimeout(async () => {}, 1000);
    setExecuteOpen(false);
  };
  const handleVoteOpen = () => {
    setVoteOpen(true);
  };

  const handleExecuteOpen = () => {
    setExecuteOpen(true);
  };

  const handleExecutedHash = (event: any) => {
    setExecutedHash(event.target.value);
  };

  const handleApprove = async () => {
    await handleVote(true);
  };

  const handleDeny = async () => {
    await handleVote(false);
  };

  const handleStatusByVotingTime = (start_time: number, end_time: number) => {
    const startTime = new Date(start_time);
    const now = new Date();

    const endTime = new Date(end_time);
    if (startTime < now && now < endTime) {
      return "Ongoing";
    }
    if (now > endTime) {
      return "Closed";
    }
    return "Pending";
  };

  const handleResult = (
    start_time: number,
    end_time: number,
    yes: number,
    no: number,
  ) => {
    const votingPeriod = handleStatusByVotingTime(start_time, end_time);

    if (votingPeriod === "Closed") {
      if (yes > no) {
        return "PASSED";
      } else {
        return "REJECTED";
      }
    }
    return "PROCESSING";
  };
  // return <h1>My Page {params.id}</h1>;
  // let a= proposal.start_timestamp
  // const start_time = new Date(a)
  console.log(proposal.fields.start_timestamp);
  return (
    <>
      <main className="flex flex-col min-h-screen min-w-full mt-12">
        <div className="flex items-center justify-center">
          <div className="w-1/2 h-auto">
            <h4 className="scroll-m-20 text-2xl font-semibold tracking-tight text-gray-400 mb-2">
              # {params.id}
            </h4>
            <h1 className="scroll-m-20 text-4xl font-extrabold tracking-tight lg:text-5xl mb-2">
              {proposal.fields.name}
            </h1>
            <p className="leading-7 [&:not(:first-child)]:mt-6 mb-2">
              created by {proposal.fields.creater}
            </p>
            <p className="leading-7 [&:not(:first-child)]:mt-6 mb-2">
              yes {proposal.fields.approve_num} / no {proposal.fields.deny_num}
            </p>
            <p className="leading-7 [&:not(:first-child)]:mt-6 mb-2">
              Description: {proposal.fields.description}
            </p>
            <p className="leading-7 [&:not(:first-child)]:mt-6 mb-2">
              Start Time:{" "}
              {new Date(Number(proposal.fields.start_timestamp)).toUTCString()}
            </p>
            <p className="leading-7 [&:not(:first-child)]:mt-6 mb-2">
              End time:{" "}
              {new Date(Number(proposal.fields.end_timestamp)).toUTCString()}
            </p>
            {proposal.fields.executed_hash !== "" ? (
              <p className="leading-7 [&:not(:first-child)]:mt-6 mb-2">
                Excuted Hash: {proposal.fields.executed_hash}
              </p>
            ) : (
              <></>
            )}
          </div>
          {handleResult(
            Number(proposal.fields.start_timestamp),
            Number(proposal.fields.end_timestamp),
            Number(proposal.fields.approve_num),
            Number(proposal.fields.deny_num),
          ) === "PASSED" ? (
            <Dialog open={executeOpen} onOpenChange={setExecuteOpen}>
              <DialogTrigger asChild>
                <Button
                  variant="outline"
                  className="mb-2"
                  onClick={handleExecuteOpen}
                >
                  Upload hash
                </Button>
              </DialogTrigger>
              <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                  <DialogTitle>Upload executed hash</DialogTitle>
                  <DialogDescription>
                    Please upload executed hash after this proposal is passed.
                  </DialogDescription>
                </DialogHeader>
                <div className="grid gap-4 py-4">
                  <div className="grid grid-cols-4 items-center gap-4">
                    <Label htmlFor="username" className="text-right">
                      Hash
                    </Label>
                    <Input
                      id="title"
                      className="col-span-3"
                      value={executedHash}
                      onChange={(e) => handleExecutedHash(e)}
                    />
                  </div>

                  <DialogFooter>
                    <Button type="submit" onClick={handleExecute}>
                      Submit
                    </Button>
                  </DialogFooter>
                </div>
              </DialogContent>
            </Dialog>
          ) : handleResult(
              Number(proposal.fields.start_timestamp),
              Number(proposal.fields.end_timestamp),
              Number(proposal.fields.approve_num),
              Number(proposal.fields.deny_num),
            ) === "PROCESSING" ? (
            <Dialog open={voteOpen} onOpenChange={setVoteOpen}>
              <DialogTrigger asChild>
                <Button
                  variant="outline"
                  className="mb-2"
                  onClick={handleVoteOpen}
                >
                  Vote
                </Button>
              </DialogTrigger>
              <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                  <DialogTitle>Vote proposal</DialogTitle>
                  <DialogDescription>
                    Choise yes/no to this proposal
                  </DialogDescription>
                </DialogHeader>
                <div className="grid gap-4 py-4">
                  {/* <div className="grid grid-cols-4 items-center gap-4">
									<Label
										htmlFor="name"
										className="text-right"
									>
										Name
									</Label>
									<Input
										id="name"
										value="Pedro Duarte"
										className="col-span-3"
									/>
								</div> */}
                  <div className="grid grid-cols-4 items-center gap-4">
                    <Button
                      className="bg-green-500"
                      type="submit"
                      onClick={handleApprove}
                    >
                      Approve
                    </Button>

                    <Button
                      className="bg-red-500"
                      type="submit"
                      onClick={handleDeny}
                    >
                      Deny
                    </Button>
                  </div>
                </div>
              </DialogContent>
            </Dialog>
          ) : (
            <></>
          )}
        </div>
      </main>
    </>
  );
}
