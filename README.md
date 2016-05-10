```sh
$ docker run --rm -it -p 2222:22 -p 8080:8080 -v /Users/yuji/work/new/www:/home/work/www -v /Users/yuji/work/new/vhost:/home/work/local/nginx-1.7.7/conf/virtualhost homelink 
```


docker run --rm -it -p 8000:80 -p 2222:22 -v ~/tmp/htdocs:/app/yii/htdocs yii
docker run --rm -it -p 8000:80 -p 2222:22 -v views:/app/yii/htdocs/protected/views yii



http://localhost:8000/ index.tpl
http://localhost:8000/detail detail/index.tpl
http://localhost:8000/detail/xxx/ detail/xxx/index.tpl


SSH

```sh
$ ssh root@localhost -p 2222
```

password: 123



#



simple

```
$ docker run --rm -it -p 8000:80 yii
```

then: http://localhost:8000/

provide `views`


```
mkdir -p views/{mock,static/css,tpl} && touch views/{mock/index.json,static/css/index.css,tpl/index.tpl}
```

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


```
docker run --rm -it -p 8000:80 -v /Users/yuji/tmp/views:/views yii
```

then: http://localhost:8000/

url to tpl:

```
/ -> tpl/index.tpl
/detail -> tpl/detail.tpl
/sub/page -> tpl/sub/page.tpl
```

SSH

```
docker run --rm -it -p 8000:80 -p 2222:22 -v /Users/yuji/tmp/views:/views yii
```

then:

```
ssh root@localhost -p 2222
```
