# "Cheap" Page Development

The full project template has a web directory "agreement" that
corresponds to /src/web .

The apache server configuations contain examples for how to configure that.

If you would like to expose only a portion of your project directory on a
web server (NOTE:  This is not good practice entirely), then you do the
following:

In the project_root/.htaccess :

```
Order deny,allow
Deny from all
```

In project_root/src/web/.htaccess :
```
Order allow,deny
Allow from all
```

