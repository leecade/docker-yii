# A simple yii+smarty env for front-end developer

How to run the env

```
$ docker run --rm -it -p 8000:80 leecade/yii
```

then: http://localhost:8000/

it works, we may see a simple webapp include mock data, template and static resource.

Now we create some front-end files, looks like:

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

generate file structure

```sh
$ mkdir -p views/{mock,static/css,tpl} && touch views/{mock/index.json,static/css/index.css,tpl/index.tpl}
```

views/mock/index.json

```json
{
  "name": "张三"
}
```

views/tpl/index.tpl

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>你好,{$data.name}!</title>
  <link rel="stylesheet" href="/static/css/index.css">
</head>
<body>
你好,{$data.name}!
</body>
</html>
```

views/static/css/index.css

```css
html, body {
  background: #999;
}
```

Mount the folder

```
docker run --rm -it -p 8000:80 -v /Users/yuji/tmp/views:/views leecade/yii
```

then: http://localhost:8000/

url -> tpl:

```
/ -> tpl/index.tpl
/detail -> tpl/detail.tpl
/sub/page -> tpl/sub/page.tpl
```

SSH

```
docker run --rm -it -p 8000:80 -p 2222:22 -v /Users/yuji/tmp/views:/views leecade/yii
```

then(password: `123`):

```
ssh root@localhost -p 2222
```
