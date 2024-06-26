"use client";

import "@repo/ui/globals.css";
// import type { Metadata } from "next";
import { Inter } from "next/font/google";

import "@mysten/dapp-kit/dist/index.css";
import {
  createNetworkConfig,
  SuiClientProvider,
  WalletProvider,
} from "@mysten/dapp-kit";
import { getFullnodeUrl } from "@mysten/sui.js/client";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@repo/ui/components/ui/sonner";
import { NETWORK } from "./chain/config";
import { Footer } from "./components/footer";
import { Header } from "./components/header";
const inter = Inter({ subsets: ["latin"] });

const { networkConfig } = createNetworkConfig({
  localnet: { url: getFullnodeUrl("localnet") },
  devnet: { url: getFullnodeUrl("devnet") },
  testnet: { url: getFullnodeUrl("testnet") },
  mainnet: { url: getFullnodeUrl("mainnet") },
});

const queryClient = new QueryClient();

// export const metadata: Metadata = {
//   title: "Docs",
//   description: "Generated by create turbo",
// };

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}): JSX.Element {
  return (
    <html lang="en">
      <body className={inter.className}>
        <QueryClientProvider client={queryClient}>
          <SuiClientProvider networks={networkConfig} defaultNetwork={NETWORK}>
            <WalletProvider>
              <Header />
              <Toaster />
              {children}
              <div className="bg-slate-100">
                <Footer />
              </div>
            </WalletProvider>
          </SuiClientProvider>
        </QueryClientProvider>
      </body>
    </html>
  );
}
