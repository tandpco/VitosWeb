require 'sinatra'
require "sinatra/config_file"
require 'json'
require 'active_record'

config_file 'config/settings.yml'
Dir["./ViewControllers/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

Dir["./ModelControllers/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

config = JSON::load(File.open(settings.configName))

$sizes          = JSON::load(File.open("./JSON-DATA/sizes.json"))
$styles         = JSON::load(File.open("./JSON-DATA/styles.json"))
$topper         = JSON::load(File.open("./JSON-DATA/toppers.json"))
$items          = JSON::load(File.open("./JSON-DATA/items.json"))
$specialtyItems = JSON::load(File.open("./JSON-DATA/specialty-items.json"))
$sauce          = JSON::load(File.open("./JSON-DATA/sauces.json"))
$saucemodifier  = JSON::load(File.open("./JSON-DATA/saucemodifiers.json"))
$specialty      = JSON::load(File.open("./JSON-DATA/specialties.json"))
$stores         = JSON::load(File.open("./JSON-DATA/store-coordinates.json"))

$PIZZA               = "1"
$SUB                 = "32"
$SALAD               = "3"
$SIDE                = "8000"
$VITOBREAD           = "8002"
$WINGS               = "8004"
$CINNAMONBREADSTICKS = "8005"
$DIPPERS             = "8007"
$BEVERAGE            = "8015"
# HTML static routes (GET)
get '/' do
    send_file('public/sign-in.html')
end

get '/sign-in' do
    send_file('public/sign-in.html')
end

get '/order-pizza' do
    send_file('public/order-items.html')
end

get '/order-subs' do
    send_file('public/order-items.html')
end

get '/order-salads' do
    send_file('public/order-items.html')
end

get '/order-sides' do
    send_file('public/order-items.html')
end

get '/order-confirmation' do
    send_file('public/order-confirmation.html')
end

get '/order-information' do
    send_file('public/order-information.html')
end

get '/payment-information' do
    send_file('public/payment-information.html')
end

get '/store-locator' do
    send_file('public/store-locator.html')
end

get '/tblunit' do
    send_file('public/tblunit.html')
end

get '/tblspecialty' do
    send_file('public/tblspecialty.html')
end

get '/tblcustomers' do
    send_file('public/tblcustomers.html')
end

get '/tblitems' do
    send_file('public/tblitems.html')
end

get '/tblsauce' do
    send_file('public/tblsauce.html')
end

get '/tbltopper' do
    send_file('public/tbltopper.html')
end

get '/tblsizes' do
    send_file('public/tblsizes.html')
end

get '/tblstyles' do
    send_file('public/tblstyles.html')
end

get '/tblsaucemodifier' do
    send_file('public/tblsaucemodifier.html')
end

get '/tblorders' do
    send_file('public/tblorders.html')
end

get '/tblorderlines' do
    send_file('public/tblorderlines.html')
end

# View REST routes (POST)
post '/rest/view/topping/list-toppings' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    ToppingViewController.listToppings(data)
end
post '/rest/view/customer/get-customer' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    CustomerViewController.getCustomer(data)
end
post '/rest/view/store-locator/find-store' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    StoreLocatorViewController.findStore(data)
end
post '/rest/view/store/list-stores' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    StoreViewController.listStores(data)
end
post '/rest/view/store/get-store' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    StoreViewController.getStore(data)
end
post '/rest/view/order/get-order' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    OrderViewController.getOrder(data)
end
post '/rest/view/order/create-order' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    OrderViewController.createOrder(data)
end

post '/rest/view/tblspecialty/get-tblspecialties' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    TblspecialtyViewController.getTblspecialties(data)
end

post '/rest/view/order-items/get-default-specialty-items' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    OrderItemsViewController.getDefaultSpecialtyItems(data)
end

post '/rest/view/tblorderlines/create-tblorderlines' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesViewController.createTblorderlines(data)
end

post '/rest/view/tblorderlines/delete-tblorderlines' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesViewController.deleteTblorderlines(data)
end

post '/rest/view/tblorderlines/get-tblorderlines' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesViewController.getTblorderlines(data)
end
ActiveRecord::Base.establish_connection(
    :adapter => config['adapter'],
    :host => config['host'],
    :port => config['port'],
    :username => config['username'],
    :password => config['password'],
    :database => config['database'],
    :pool => 100
)

# Model REST routes (POST)
post '/rest/model/tbladdresses/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbladdressesController.create(data)
end

post '/rest/model/tbladdresses/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbladdressesController.read(data)
end

post '/rest/model/tbladdresses/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbladdressesController.update(data)
end

post '/rest/model/tbladdresses/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbladdressesController.delete(data)
end

post '/rest/model/tbladdresses/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbladdressesController.list(data)
end

post '/rest/model/tbladdresses/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbladdressesController.filter(data)
end

post '/rest/model/tblcassaddresses/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcassaddressesController.create(data)
end

post '/rest/model/tblcassaddresses/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcassaddressesController.read(data)
end

post '/rest/model/tblcassaddresses/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcassaddressesController.update(data)
end

post '/rest/model/tblcassaddresses/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcassaddressesController.delete(data)
end

post '/rest/model/tblcassaddresses/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcassaddressesController.list(data)
end

post '/rest/model/tblcassaddresses/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcassaddressesController.filter(data)
end

post '/rest/model/tblcouponappliestos/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponappliestoController.create(data)
end

post '/rest/model/tblcouponappliestos/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponappliestoController.read(data)
end

post '/rest/model/tblcouponappliestos/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponappliestoController.update(data)
end

post '/rest/model/tblcouponappliestos/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponappliestoController.delete(data)
end

post '/rest/model/tblcouponappliestos/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponappliestoController.list(data)
end

post '/rest/model/tblcouponappliestos/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponappliestoController.filter(data)
end

post '/rest/model/tblcoupondateranges/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcoupondaterangeController.create(data)
end

post '/rest/model/tblcoupondateranges/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcoupondaterangeController.read(data)
end

post '/rest/model/tblcoupondateranges/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcoupondaterangeController.update(data)
end

post '/rest/model/tblcoupondateranges/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcoupondaterangeController.delete(data)
end

post '/rest/model/tblcoupondateranges/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcoupondaterangeController.list(data)
end

post '/rest/model/tblcoupondateranges/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcoupondaterangeController.filter(data)
end

post '/rest/model/tblcouponpromocodedateranges/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponpromocodedaterangeController.create(data)
end

post '/rest/model/tblcouponpromocodedateranges/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponpromocodedaterangeController.read(data)
end

post '/rest/model/tblcouponpromocodedateranges/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponpromocodedaterangeController.update(data)
end

post '/rest/model/tblcouponpromocodedateranges/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponpromocodedaterangeController.delete(data)
end

post '/rest/model/tblcouponpromocodedateranges/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponpromocodedaterangeController.list(data)
end

post '/rest/model/tblcouponpromocodedateranges/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponpromocodedaterangeController.filter(data)
end

post '/rest/model/tblcoupons/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponsController.create(data)
end

post '/rest/model/tblcoupons/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponsController.read(data)
end

post '/rest/model/tblcoupons/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponsController.update(data)
end

post '/rest/model/tblcoupons/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponsController.delete(data)
end

post '/rest/model/tblcoupons/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponsController.list(data)
end

post '/rest/model/tblcoupons/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponsController.filter(data)
end

post '/rest/model/tblcouponspromocodes/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponspromocodesController.create(data)
end

post '/rest/model/tblcouponspromocodes/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponspromocodesController.read(data)
end

post '/rest/model/tblcouponspromocodes/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponspromocodesController.update(data)
end

post '/rest/model/tblcouponspromocodes/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponspromocodesController.delete(data)
end

post '/rest/model/tblcouponspromocodes/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponspromocodesController.list(data)
end

post '/rest/model/tblcouponspromocodes/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcouponspromocodesController.filter(data)
end

post '/rest/model/tblcustomers/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcustomersController.create(data)
end

post '/rest/model/tblcustomers/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcustomersController.read(data)
end

post '/rest/model/tblcustomers/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcustomersController.update(data)
end

post '/rest/model/tblcustomers/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcustomersController.delete(data)
end

post '/rest/model/tblcustomers/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcustomersController.list(data)
end

post '/rest/model/tblcustomers/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblcustomersController.filter(data)
end

post '/rest/model/tblitems/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblitemsController.create(data)
end

post '/rest/model/tblitems/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblitemsController.read(data)
end

post '/rest/model/tblitems/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblitemsController.update(data)
end

post '/rest/model/tblitems/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblitemsController.delete(data)
end

post '/rest/model/tblitems/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblitemsController.list(data)
end

post '/rest/model/tblitems/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblitemsController.filter(data)
end

post '/rest/model/tblmarquees/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblmarqueeController.create(data)
end

post '/rest/model/tblmarquees/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblmarqueeController.read(data)
end

post '/rest/model/tblmarquees/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblmarqueeController.update(data)
end

post '/rest/model/tblmarquees/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblmarqueeController.delete(data)
end

post '/rest/model/tblmarquees/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblmarqueeController.list(data)
end

post '/rest/model/tblmarquees/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblmarqueeController.filter(data)
end

post '/rest/model/tblorderlineitems/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlineitemsController.create(data)
end

post '/rest/model/tblorderlineitems/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlineitemsController.read(data)
end

post '/rest/model/tblorderlineitems/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlineitemsController.update(data)
end

post '/rest/model/tblorderlineitems/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlineitemsController.delete(data)
end

post '/rest/model/tblorderlineitems/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlineitemsController.list(data)
end

post '/rest/model/tblorderlineitems/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlineitemsController.filter(data)
end

post '/rest/model/tblorderlines/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesController.create(data)
end

post '/rest/model/tblorderlines/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesController.read(data)
end

post '/rest/model/tblorderlines/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesController.update(data)
end

post '/rest/model/tblorderlines/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesController.delete(data)
end

post '/rest/model/tblorderlines/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesController.list(data)
end

post '/rest/model/tblorderlines/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesController.filter(data)
end

post '/rest/model/tblorderlinesidealcosts/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidealcostController.create(data)
end

post '/rest/model/tblorderlinesidealcosts/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidealcostController.read(data)
end

post '/rest/model/tblorderlinesidealcosts/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidealcostController.update(data)
end

post '/rest/model/tblorderlinesidealcosts/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidealcostController.delete(data)
end

post '/rest/model/tblorderlinesidealcosts/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidealcostController.list(data)
end

post '/rest/model/tblorderlinesidealcosts/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidealcostController.filter(data)
end

post '/rest/model/tblorderlinesides/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidesController.create(data)
end

post '/rest/model/tblorderlinesides/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidesController.read(data)
end

post '/rest/model/tblorderlinesides/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidesController.update(data)
end

post '/rest/model/tblorderlinesides/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidesController.delete(data)
end

post '/rest/model/tblorderlinesides/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidesController.list(data)
end

post '/rest/model/tblorderlinesides/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinesidesController.filter(data)
end

post '/rest/model/tblorderlinetoppers/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinetoppersController.create(data)
end

post '/rest/model/tblorderlinetoppers/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinetoppersController.read(data)
end

post '/rest/model/tblorderlinetoppers/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinetoppersController.update(data)
end

post '/rest/model/tblorderlinetoppers/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinetoppersController.delete(data)
end

post '/rest/model/tblorderlinetoppers/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinetoppersController.list(data)
end

post '/rest/model/tblorderlinetoppers/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblorderlinetoppersController.filter(data)
end

post '/rest/model/tblorders/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblordersController.create(data)
end

post '/rest/model/tblorders/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblordersController.read(data)
end

post '/rest/model/tblorders/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblordersController.update(data)
end

post '/rest/model/tblorders/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblordersController.delete(data)
end

post '/rest/model/tblorders/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblordersController.list(data)
end

post '/rest/model/tblorders/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblordersController.filter(data)
end

post '/rest/model/tblsauces/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsauceController.create(data)
end

post '/rest/model/tblsauces/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsauceController.read(data)
end

post '/rest/model/tblsauces/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsauceController.update(data)
end

post '/rest/model/tblsauces/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsauceController.delete(data)
end

post '/rest/model/tblsauces/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsauceController.list(data)
end

post '/rest/model/tblsauces/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsauceController.filter(data)
end

post '/rest/model/tblsaucemodifiers/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsaucemodifierController.create(data)
end

post '/rest/model/tblsaucemodifiers/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsaucemodifierController.read(data)
end

post '/rest/model/tblsaucemodifiers/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsaucemodifierController.update(data)
end

post '/rest/model/tblsaucemodifiers/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsaucemodifierController.delete(data)
end

post '/rest/model/tblsaucemodifiers/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsaucemodifierController.list(data)
end

post '/rest/model/tblsaucemodifiers/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsaucemodifierController.filter(data)
end

post '/rest/model/tblsidegroups/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidegroupController.create(data)
end

post '/rest/model/tblsidegroups/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidegroupController.read(data)
end

post '/rest/model/tblsidegroups/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidegroupController.update(data)
end

post '/rest/model/tblsidegroups/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidegroupController.delete(data)
end

post '/rest/model/tblsidegroups/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidegroupController.list(data)
end

post '/rest/model/tblsidegroups/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidegroupController.filter(data)
end

post '/rest/model/tblsides/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidesController.create(data)
end

post '/rest/model/tblsides/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidesController.read(data)
end

post '/rest/model/tblsides/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidesController.update(data)
end

post '/rest/model/tblsides/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidesController.delete(data)
end

post '/rest/model/tblsides/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidesController.list(data)
end

post '/rest/model/tblsides/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsidesController.filter(data)
end

post '/rest/model/tblsizes/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsizesController.create(data)
end

post '/rest/model/tblsizes/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsizesController.read(data)
end

post '/rest/model/tblsizes/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsizesController.update(data)
end

post '/rest/model/tblsizes/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsizesController.delete(data)
end

post '/rest/model/tblsizes/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsizesController.list(data)
end

post '/rest/model/tblsizes/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblsizesController.filter(data)
end

post '/rest/model/tblspecialties/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblspecialtyController.create(data)
end

post '/rest/model/tblspecialties/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblspecialtyController.read(data)
end

post '/rest/model/tblspecialties/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblspecialtyController.update(data)
end

post '/rest/model/tblspecialties/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblspecialtyController.delete(data)
end

post '/rest/model/tblspecialties/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblspecialtyController.list(data)
end

post '/rest/model/tblspecialties/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblspecialtyController.filter(data)
end

post '/rest/model/tblstorereportdates/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstorereportdateController.create(data)
end

post '/rest/model/tblstorereportdates/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstorereportdateController.read(data)
end

post '/rest/model/tblstorereportdates/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstorereportdateController.update(data)
end

post '/rest/model/tblstorereportdates/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstorereportdateController.delete(data)
end

post '/rest/model/tblstorereportdates/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstorereportdateController.list(data)
end

post '/rest/model/tblstorereportdates/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstorereportdateController.filter(data)
end

post '/rest/model/tblstores/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstoresController.create(data)
end

post '/rest/model/tblstores/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstoresController.read(data)
end

post '/rest/model/tblstores/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstoresController.update(data)
end

post '/rest/model/tblstores/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstoresController.delete(data)
end

post '/rest/model/tblstores/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstoresController.list(data)
end

post '/rest/model/tblstores/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstoresController.filter(data)
end

post '/rest/model/tblstyles/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstylesController.create(data)
end

post '/rest/model/tblstyles/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstylesController.read(data)
end

post '/rest/model/tblstyles/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstylesController.update(data)
end

post '/rest/model/tblstyles/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstylesController.delete(data)
end

post '/rest/model/tblstyles/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstylesController.list(data)
end

post '/rest/model/tblstyles/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblstylesController.filter(data)
end

post '/rest/model/tbltoppers/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbltopperController.create(data)
end

post '/rest/model/tbltoppers/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbltopperController.read(data)
end

post '/rest/model/tbltoppers/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbltopperController.update(data)
end

post '/rest/model/tbltoppers/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbltopperController.delete(data)
end

post '/rest/model/tbltoppers/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbltopperController.list(data)
end

post '/rest/model/tbltoppers/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TbltopperController.filter(data)
end

post '/rest/model/tblunits/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblunitController.create(data)
end

post '/rest/model/tblunits/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblunitController.read(data)
end

post '/rest/model/tblunits/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblunitController.update(data)
end

post '/rest/model/tblunits/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblunitController.delete(data)
end

post '/rest/model/tblunits/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblunitController.list(data)
end

post '/rest/model/tblunits/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblunitController.filter(data)
end

post '/rest/model/tblwebactivities/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblwebactivityController.create(data)
end

post '/rest/model/tblwebactivities/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblwebactivityController.read(data)
end

post '/rest/model/tblwebactivities/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblwebactivityController.update(data)
end

post '/rest/model/tblwebactivities/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblwebactivityController.delete(data)
end

post '/rest/model/tblwebactivities/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblwebactivityController.list(data)
end

post '/rest/model/tblwebactivities/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TblwebactivityController.filter(data)
end

post '/rest/model/trelcouponstores/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcouponstoreController.create(data)
end

post '/rest/model/trelcouponstores/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcouponstoreController.read(data)
end

post '/rest/model/trelcouponstores/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcouponstoreController.update(data)
end

post '/rest/model/trelcouponstores/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcouponstoreController.delete(data)
end

post '/rest/model/trelcouponstores/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcouponstoreController.list(data)
end

post '/rest/model/trelcouponstores/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcouponstoreController.filter(data)
end

post '/rest/model/trelcustomeraddresses/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcustomeraddressesController.create(data)
end

post '/rest/model/trelcustomeraddresses/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcustomeraddressesController.read(data)
end

post '/rest/model/trelcustomeraddresses/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcustomeraddressesController.update(data)
end

post '/rest/model/trelcustomeraddresses/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcustomeraddressesController.delete(data)
end

post '/rest/model/trelcustomeraddresses/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcustomeraddressesController.list(data)
end

post '/rest/model/trelcustomeraddresses/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelcustomeraddressesController.filter(data)
end

post '/rest/model/trelsidegroupsides/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsidegroupsidesController.create(data)
end

post '/rest/model/trelsidegroupsides/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsidegroupsidesController.read(data)
end

post '/rest/model/trelsidegroupsides/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsidegroupsidesController.update(data)
end

post '/rest/model/trelsidegroupsides/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsidegroupsidesController.delete(data)
end

post '/rest/model/trelsidegroupsides/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsidegroupsidesController.list(data)
end

post '/rest/model/trelsidegroupsides/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsidegroupsidesController.filter(data)
end

post '/rest/model/trelsizestyles/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsizestyleController.create(data)
end

post '/rest/model/trelsizestyles/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsizestyleController.read(data)
end

post '/rest/model/trelsizestyles/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsizestyleController.update(data)
end

post '/rest/model/trelsizestyles/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsizestyleController.delete(data)
end

post '/rest/model/trelsizestyles/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsizestyleController.list(data)
end

post '/rest/model/trelsizestyles/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelsizestyleController.filter(data)
end

post '/rest/model/trelspecialtyitems/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtyitemController.create(data)
end

post '/rest/model/trelspecialtyitems/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtyitemController.read(data)
end

post '/rest/model/trelspecialtyitems/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtyitemController.update(data)
end

post '/rest/model/trelspecialtyitems/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtyitemController.delete(data)
end

post '/rest/model/trelspecialtyitems/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtyitemController.list(data)
end

post '/rest/model/trelspecialtyitems/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtyitemController.filter(data)
end

post '/rest/model/trelspecialtysizesidegroups/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtysizesidegroupController.create(data)
end

post '/rest/model/trelspecialtysizesidegroups/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtysizesidegroupController.read(data)
end

post '/rest/model/trelspecialtysizesidegroups/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtysizesidegroupController.update(data)
end

post '/rest/model/trelspecialtysizesidegroups/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtysizesidegroupController.delete(data)
end

post '/rest/model/trelspecialtysizesidegroups/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtysizesidegroupController.list(data)
end

post '/rest/model/trelspecialtysizesidegroups/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelspecialtysizesidegroupController.filter(data)
end

post '/rest/model/trelstoreitems/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreitemController.create(data)
end

post '/rest/model/trelstoreitems/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreitemController.read(data)
end

post '/rest/model/trelstoreitems/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreitemController.update(data)
end

post '/rest/model/trelstoreitems/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreitemController.delete(data)
end

post '/rest/model/trelstoreitems/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreitemController.list(data)
end

post '/rest/model/trelstoreitems/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreitemController.filter(data)
end

post '/rest/model/trelstoresides/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresidesController.create(data)
end

post '/rest/model/trelstoresides/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresidesController.read(data)
end

post '/rest/model/trelstoresides/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresidesController.update(data)
end

post '/rest/model/trelstoresides/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresidesController.delete(data)
end

post '/rest/model/trelstoresides/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresidesController.list(data)
end

post '/rest/model/trelstoresides/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresidesController.filter(data)
end

post '/rest/model/trelstoresizestyles/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresizestyleController.create(data)
end

post '/rest/model/trelstoresizestyles/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresizestyleController.read(data)
end

post '/rest/model/trelstoresizestyles/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresizestyleController.update(data)
end

post '/rest/model/trelstoresizestyles/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresizestyleController.delete(data)
end

post '/rest/model/trelstoresizestyles/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresizestyleController.list(data)
end

post '/rest/model/trelstoresizestyles/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoresizestyleController.filter(data)
end

post '/rest/model/trelstorespecialties/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstorespecialtyController.create(data)
end

post '/rest/model/trelstorespecialties/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstorespecialtyController.read(data)
end

post '/rest/model/trelstorespecialties/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstorespecialtyController.update(data)
end

post '/rest/model/trelstorespecialties/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstorespecialtyController.delete(data)
end

post '/rest/model/trelstorespecialties/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstorespecialtyController.list(data)
end

post '/rest/model/trelstorespecialties/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstorespecialtyController.filter(data)
end

post '/rest/model/trelstoreunitsizes/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreunitsizeController.create(data)
end

post '/rest/model/trelstoreunitsizes/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreunitsizeController.read(data)
end

post '/rest/model/trelstoreunitsizes/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreunitsizeController.update(data)
end

post '/rest/model/trelstoreunitsizes/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreunitsizeController.delete(data)
end

post '/rest/model/trelstoreunitsizes/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreunitsizeController.list(data)
end

post '/rest/model/trelstoreunitsizes/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelstoreunitsizeController.filter(data)
end

post '/rest/model/trelunititems/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunititemsController.create(data)
end

post '/rest/model/trelunititems/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunititemsController.read(data)
end

post '/rest/model/trelunititems/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunititemsController.update(data)
end

post '/rest/model/trelunititems/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunititemsController.delete(data)
end

post '/rest/model/trelunititems/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunititemsController.list(data)
end

post '/rest/model/trelunititems/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunititemsController.filter(data)
end

post '/rest/model/trelunitsauces/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsauceController.create(data)
end

post '/rest/model/trelunitsauces/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsauceController.read(data)
end

post '/rest/model/trelunitsauces/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsauceController.update(data)
end

post '/rest/model/trelunitsauces/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsauceController.delete(data)
end

post '/rest/model/trelunitsauces/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsauceController.list(data)
end

post '/rest/model/trelunitsauces/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsauceController.filter(data)
end

post '/rest/model/trelunitsides/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsidesController.create(data)
end

post '/rest/model/trelunitsides/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsidesController.read(data)
end

post '/rest/model/trelunitsides/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsidesController.update(data)
end

post '/rest/model/trelunitsides/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsidesController.delete(data)
end

post '/rest/model/trelunitsides/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsidesController.list(data)
end

post '/rest/model/trelunitsides/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsidesController.filter(data)
end

post '/rest/model/trelunitsizes/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizeController.create(data)
end

post '/rest/model/trelunitsizes/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizeController.read(data)
end

post '/rest/model/trelunitsizes/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizeController.update(data)
end

post '/rest/model/trelunitsizes/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizeController.delete(data)
end

post '/rest/model/trelunitsizes/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizeController.list(data)
end

post '/rest/model/trelunitsizes/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizeController.filter(data)
end

post '/rest/model/trelunitsizesidegroups/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizesidegroupController.create(data)
end

post '/rest/model/trelunitsizesidegroups/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizesidegroupController.read(data)
end

post '/rest/model/trelunitsizesidegroups/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizesidegroupController.update(data)
end

post '/rest/model/trelunitsizesidegroups/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizesidegroupController.delete(data)
end

post '/rest/model/trelunitsizesidegroups/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizesidegroupController.list(data)
end

post '/rest/model/trelunitsizesidegroups/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitsizesidegroupController.filter(data)
end

post '/rest/model/trelunitstyles/create' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitstylesController.create(data)
end

post '/rest/model/trelunitstyles/read' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitstylesController.read(data)
end

post '/rest/model/trelunitstyles/update' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitstylesController.update(data)
end

post '/rest/model/trelunitstyles/delete' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitstylesController.delete(data)
end

post '/rest/model/trelunitstyles/list' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitstylesController.list(data)
end

post '/rest/model/trelunitstyles/filter' do
    request.body.rewind
    data = JSON.parse request.body.read
    content_type :json
    TrelunitstylesController.filter(data)
end

