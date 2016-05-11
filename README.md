# A common Yii+Smarty environment provider

[tpl + mock data] + **docker** => page

Write and render smarty template with no environment depend.

## TODO

- [ ] Supports remote mock data

## STOCK

- Yii 1.1.13
- Smarty 3.1
- nginx 1.0.15

## Quick Start

1. Install docker

  > Recommend [docker beta](https://beta.docker.com/docs/), no more Virtualbox and many awesome features.

2. Start a container

```sh
$ docker run -p 8000:80 registry.aliyuncs.com/do/yii
```

Waiting a while, the first startup need to download a image, after the container is running we can open http://localhost:8000/ in browser.

Yes it works, we may see a simple page because there is a smarty render server in the container.

## Start with local endpoint mount

```sh
$ docker run -p 8000:80 -v ~/tmp/views:/views registry.aliyuncs.com/do/yii
```

A basic file structure be generated in `~/tmp/views`:

```
├── views
│   ├── mock
│   │   └── index.json
│   ├── static
│   │   └── css
│   │       └── index.css
│   └── tpl
│       └── index.tpl
```

Try to edit it and refresh the browser.

## Q & A

### How the url and resource mapping

```
/ -> tpl/index.tpl
/detail -> tpl/detail.tpl
/sub/page -> tpl/sub/page.tpl

/static/reset.css -> static/reset.css
/static/css/index.css -> static/css/index.css
```

### How to connect the container with ssh protocol

```sh
$ docker run -p 8000:80 -p 2222:22 registry.aliyuncs.com/do/yii
```

Add a port map (`2222`:`22`), then:

```sh
$ ssh root@localhost -p 2222
```

> Notice that the default password is `123`

### If I have a `views` folder, will mount overwrite the within file content

Nope, after you understand the file structure, it's better to generate your `view` files and mount the folder.

```sh
$ mkdir -p views/{mock,static/css,tpl} && touch views/{mock/index.json,static/css/index.css,tpl/index.tpl}
```
