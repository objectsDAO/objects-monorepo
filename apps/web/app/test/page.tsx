'use server'

import {  ImageData, getNounData, getRandomNounSeed } from '@nouns/assets';
import {buildSVG,  PNGCollectionEncoder } from '@nouns/sdk';
import Image from 'next/image'
import {NounSeed} from "@nouns/assets/dist/types";
// import {decodeImage} from "@nouns/sdk/dist/image/svg-builder";


// const getRectLength = (currentX: number, drawLength: number, rightBound: number): number => {
//     const remainingPixelsInLine = rightBound - currentX;
//     return drawLength <= remainingPixelsInLine ? drawLength : remainingPixelsInLine;
// };

// let value = 0



// const getRectLength = (currentX: number, drawLength: number, rightBound: number): number => {
//     const remainingPixelsInLine = rightBound - currentX;
//     return drawLength <= remainingPixelsInLine ? drawLength : remainingPixelsInLine;
// };
//
// const buildSVG = (
//     parts: { data: string }[],
//     paletteColors: string[],
//     bgColor?: string,
// ): string => {
//     const svgWithoutEndTag = parts.reduce((result, part) => {
//         const svgRects: string[] = [];
//         const { bounds, rects } = decodeImage(part.data);
//
//         let currentX = bounds.left;
//         let currentY = bounds.top;
//
//         rects.forEach(draw => {
//             let drawLength = draw[0];
//             const colorIndex = draw[1];
//             const hexColor = paletteColors[colorIndex];
//
//
//
//             let length = getRectLength(currentX, drawLength, bounds.right);
//
//             while (length > 0) {
//
//                 // Do not push rect if transparent
//                 if (colorIndex !== 0) {
//                     svgRects.push(
//                         `<rect width="${length * 10}" height="10" x="${currentX * 10}" y="${
//                             currentY * 10
//                         }" fill="#${hexColor}" />`,
//                     );
//                 }
//
//                 currentX += length;
//                 if (currentX === bounds.right) {
//                     currentX = bounds.left;
//                     currentY++;
//                 }
//
//                 drawLength -= length;
//                 length = getRectLength(currentX, drawLength, bounds.right);
//                 value++
//             }
//         });
//         result += svgRects.join('');
//
//         return result;
//
//     }, `<svg width="320" height="320" viewBox="0 0 320 320" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges"><rect width="100%" height="100%" fill="${bgColor ? `#${bgColor}` : 'none'}" />`);
//     console.log("value")
//     console.log(value)
//     return `${svgWithoutEndTag}</svg>`;
//
// };


export default async function Page() {
  // const seed = {...getRandomNounSeed()};
  const seed:NounSeed = {
      background:0,
      body: 24,
      accessory: 108,
      head: 222,
      glasses: 18,

  }

  // const seed:NounSeed = {
  //   background:1,
  //   body: 7,
  //   accessory: 110,
  //   head: 37,
  //   glasses: 19,
  //
  // }
  // console.log(seed)
  const {parts, background} = getNounData(seed);

  console.log(parts)

  // console.log(parts,background);
  const encoder = await new PNGCollectionEncoder(ImageData.palette);
  // console.log("parts")
  // console.log(parts)
  // console.log("encoder.data.palette")
  // console.log(encoder.data.palette)


  const svg = buildSVG(parts, encoder.data.palette, background);
  // console.log(svg)
  // const svg =

    // console.log(svg)
    // @ts-ignore
  // const { bounds, rects } =   decodeImage(parts[0].data)
  //   console.log(rects)
  // let currentX = bounds.left;
  //
  //   rects.forEach(draw => {
  //       let drawLength = draw[0]
  //       // console.log(drawLength)
  //
  //       const remainingPixelsInLine = bounds.right - currentX;
  //       let length =  drawLength <= remainingPixelsInLine ? drawLength : remainingPixelsInLine;
  //       console.log(length)
  //
  //
  //       // console.log(length)
  //   });





  // // @ts-ignore
  // const { bounds, rects } =   decodeImage(parts[0].data)
  //   // @ts-ignore
  // const { bounds2, rects2 } =   decodeImage(parts[1].data)
  //   // @ts-ignore
  // const { bounds3, rects3 } =   decodeImage(parts[2].data)
  //   // @ts-ignore
  // const { bounds4, rects4 } =   decodeImage(parts[3].data)
  //   // @ts-ignore
  // // console.log(parts)
  // console.log(bounds,rects)


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

  // console.log(`data:image/svg+xml;base64,${btoa(svg)}`)
  // console.log()
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
