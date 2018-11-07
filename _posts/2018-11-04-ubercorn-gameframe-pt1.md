---
title: Ubercorn Game Frame (part 1)
categories:
  - Technology
  - Projects
tags:
  - project
  - pimoroni
  - raspberrypi
---

{% include responsive-embed url="https://www.youtube-nocookie.com/embed/5UThZC_qA4w?controls=0&amp;" %}

I've long wanted to have my own [Game Frame](https://ledseq.com/) after seeing it [unveiled on Tested](https://www.youtube.com/watch?v=lN4X4grFZa0) by its creator [Jeremy Williams](https://twitter.com/jerware), but had never gotten round to picking one up. It was however the first thing that jumped into my mind when I saw the unveil of the [Pimoroni Ubercorn](https://shop.pimoroni.com/products/ubercorn) - a lovely APA102-based LED matrix that you just need to plug a [Raspberry Pi Zero](https://www.raspberrypi.org/products/raspberry-pi-zero/) into.

I began by recreating a Game Frame-like mesh in Fusion 360 which prevents light from each LED bleeding when illuminated through a diffuser. _I'll update this post with links to the object files soon_.

The print bed of my Prusa3d i3 Mk2 was just big enough to let me print a complete mesh.

![center-aligned-image](/assets/ubercorn-gameframe-pt1/printing-mesh.jpg){: .align-center}

The Ubercorn itself is 192mm x 192mm so a quick google later and I found a close match in the [Ikea Ribba Frame](https://www.ikea.com/gb/en/products/decoration/frames-pictures/ribba-frame-black-art-40378401/) (23cm x 23cm), its priced very cheaply at £3.95 here in the UK.

As the print bed size is limited I opted to print corner spacers that both position the mesh + Ubercorn in the centre of the frame, and push them down when the Ribba frames back is clipped in place.

![center-aligned-image](/assets/ubercorn-gameframe-pt1/corner-spacer-fusion-360.png){: .align-center}

![center-aligned-image](/assets/ubercorn-gameframe-pt1/spacers.jpg){: .align-center}

I avoided making any modifications to the Ikea Ribba frame up to this point, but the capacitors and Pi Zero both extend beyond the frames default spacer so I had to cut (very badly) some holes to allow me to replace the frames back. I may print some vented covers to tidy the appearance.

![center-aligned-image](/assets/ubercorn-gameframe-pt1/back.jpg){: .align-center}

As a final step before reassembling the Frame and Ubercorn, I cut a simple diffuser from some A3 kids sketch paper (picked up in Tescos) using the frames mount as a template.

![center-aligned-image](/assets/ubercorn-gameframe-pt1/diffuser.jpg){: .align-center}

After ensuring the frame was clean, and assembling everything I found the diffuser was seperated from the mesh in the centre of the frame, resulting in the mesh seen through the diffuser losing sharpness. I fixed this by a light application of glue stick to the mesh and pushing down on the front of the frame gently when reassembled so that the diffuser adhered to the mesh.

I've been very pleased with the build so far and look forward to spending some time working on the software side next, watch out for a Part 2 post in the coming weeks, where
I'll be picking up the [official Game Frame images](https://ledseq.com/product/game-frame-sd-files/) from Ledseq and getting them working on the Pi.


![center-aligned-image](/assets/ubercorn-gameframe-pt1/front.jpg){: .align-center}
