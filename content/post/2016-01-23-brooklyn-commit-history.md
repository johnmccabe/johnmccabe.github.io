---
aliases:
- /technology/projects/brooklyn-commit-history/
categories:
- Technology
- Projects
date: "2016-01-23T00:00:00Z"
tags:
- visualisation
- project
- oss
- apache brooklyn
- git
title: Apache Brooklyn Commit History Visualisation
---

{{< youtube WPsu4OH9hsk >}}

Visualisation of the Apache Brooklyn commit history - 10 Jun 2011 - 23 Jan 2016 ([master](https://github.com/apache/incubator-brooklyn/tree/master)) - (1080p 60fps)

```
gource -s .1 -a 1 ./ -1920x1080 --logo ./brooklyn_logo_817px_wide.png \
  --hide filenames,bloom --bloom-multiplier .5 --bloom-intensity .4 \
  --highlight-users --key -o - | ffmpeg -y -r 60 -f image2pipe \
  -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p \
  -crf 1 -threads 0 -bf 0 brooklyn-incubator.mp4
```

The version of Gource currently installed by `brew` segfaults on El Capitan 10.11.3 so you may need to install from source:

```
brew install gource --HEAD
```

- Apache Brooklyn: [https://brooklyn.apache.org/](https://brooklyn.apache.org/)
- Music: [Blur by RSF](https://soundcloud.com/rsfmu/blur) - ([CC BY 3.0](https://creativecommons.org/licenses/by/3.0/))
- Visualisation: [Gource](https://github.com/acaudwell/Gource)
