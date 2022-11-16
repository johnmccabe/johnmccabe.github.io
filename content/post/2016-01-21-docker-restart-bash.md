---
aliases:
- /technology/projects/docker-restart-bash/
categories:
- Technology
- Projects
date: "2016-01-21T00:00:00Z"
tags:
- project
- oss
- docker
- bash
title: Restarting Docker with Bash
---
Having frequently found it necessary to restart the Docker Machine on my Macbook after sleeping/changing network, I threw together a small bash script that streamlines the process for me, similar to `docker-machine restart` but with the added benefit of restoring any containers that were active at the time of restart.

<script type="text/javascript" src="https://asciinema.org/a/7khffteogj4ojeobv182jbqfh.js" id="asciicast-7khffteogj4ojeobv182jbqfh" async></script>
