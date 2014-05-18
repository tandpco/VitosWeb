vitos-pizza-legacy
==================

Vitos Pizza Legacy

```
sudo apt-get install freetds-common freetds-dev
```

```
get '/' do
    stores = Tblstores.all
    html  = "<html>"
    html  += "<head><title>Stores</title></head>"
    stores.each do |store|
        html += "<p>#{store.Address1}</p>"
    end
    html += "</html>"
    html
end
```
