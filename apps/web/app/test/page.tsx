'use server'

import { ImageData, getNounData, getRandomNounSeed } from '@nouns/assets';
import { buildSVG, PNGCollectionEncoder } from '@nouns/sdk';
import Image from 'next/image'
import {NounSeed} from "@nouns/assets/dist/types";
import {decodeImage} from "@nouns/sdk/dist/image/svg-builder";

export default async function Page() {
  // const seed = {...getRandomNounSeed()};
  const seed:NounSeed = {
      background:1,
      body: 7,
      accessory: 110,
      head: 37,
      glasses: 19,

  }
  console.log(seed)
  const {parts, background} = getNounData(seed);
  // console.log(parts,background);
  const encoder = await new PNGCollectionEncoder(ImageData.palette);
  // console.log(encoder.data.palette)
  const svg = buildSVG(parts, encoder.data.palette, background);
  // @ts-ignore
  const { bounds, rects } =   decodeImage(parts[0].data)
    // @ts-ignore
  console.log(parts)
  console.log(bounds)
  // console.log(svg);
  // const generateNounSvg = useCallback(
  //   (amount: number = 1) => {
  //     for (let i = 0; i < amount; i++) {
  //       const seed = { ...getRandomNounSeed(), ...modSeed };
  //       const { parts, background } = getNounData(seed);
  //       const svg = buildSVG(parts, encoder.data.palette, background);
  //       setNounSvgs(prev => {
  //         return prev ? [svg, ...prev] : [svg];
  //       });
  //     }
  //   },
  //   // eslint-disable-next-line react-hooks/exhaustive-deps
  //   [pendingTrait, modSeed],
  // );

  return (
    <main className='flex flex-col min-h-screen min-w-full'>
      <div>
        1
      </div>
      <Image
        src={`data:image/svg+xml;base64,${btoa(svg)}`}
        width={500}
        height={500}
        alt="Picture of the author"
      />
    </main>
  );
}
