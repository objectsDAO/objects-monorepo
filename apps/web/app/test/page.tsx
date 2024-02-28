'use server'

import { ImageData, getNounData, getRandomNounSeed } from '@nouns/assets';
import { buildSVG, PNGCollectionEncoder } from '@nouns/sdk';
import Image from 'next/image'

export default async function Page() {
  const seed = {...getRandomNounSeed()};
  const {parts, background} = getNounData(seed);
  const encoder = await new PNGCollectionEncoder(ImageData.palette);
  const svg = buildSVG(parts, encoder.data.palette, background);

  console.log(svg)
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
