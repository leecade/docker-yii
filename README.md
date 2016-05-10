```sh
$ docker run --rm -it -p 2222:22 -p 8080:8080 -v /Users/yuji/work/new/www:/home/work/www -v /Users/yuji/work/new/vhost:/home/work/local/nginx-1.7.7/conf/virtualhost homelink 
```


docker run --rm -it -p 8000:80 -p 2222:22 -v ~/tmp/htdocs:/app/yii/htdocs yii



http://localhost:8000/ index.tpl
http://localhost:8000/detail detail/index.tpl
http://localhost:8000/detail/xxx/ detail/xxx/index.tpl


SSH

```sh
$ ssh root@localhost -p 2222
```

password: 123
