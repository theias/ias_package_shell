# "Cheap" Page Development

The full project template has a web directory "agreement" that
corresponds to /src/web .

The apache server configuations contain examples for how to configure that.

## Ubuntu

```
a2enmod cgid
```

And set AllowOverride to "all" for the directory you're going to do this in.

Copy the .htaccess files where they need to go.

Profit.
