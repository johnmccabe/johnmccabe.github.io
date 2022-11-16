---
aliases:
- /technology/projects/youtube-dl-with-docker-and-bash/
categories:
- Technology
- Projects
date: "2016-01-25T00:00:00Z"
tags:
- youtube
- project
- oss
- docker
- bash
title: Download Youtube Videos with Docker
---
I finally took some time recently to cobble together a set of bash scripts to allow me to download local copies of videos from youtube, heavily piggy backing off the [jbergknoff/youtube-dl](https://hub.docker.com/r/jbergknoff/youtube-dl/) Docker image and the associated [youtube-dl](https://github.com/rg3/youtube-dl) project.

[![asciicast](https://asciinema.org/a/34851.svg)](https://asciinema.org/a/34851)


You can add the following bash functions to your own env files (I've a post on my own setup in the works).

{{< gist johnmccabe 714abb85af1e691e58a5 docker.fn.sh >}}
{{< gist johnmccabe 714abb85af1e691e58a5 utils.fn.sh >}}
{{< gist johnmccabe 714abb85af1e691e58a5 youtube-dl.fn.sh >}}

Then assuming you have Docker running you can download a Youtube video as follows:

```
youtube-dl https://www.youtube.com/watch?v=WPsu4OH9hsk ~/brooklyn-gource.mp4
```

You can omit the target file and it will download to `./video.mp4`.
