require 'sinatra'
require "sinatra/config_file"
require 'json'
require 'active_record'
require 'moneta'

enable :sessions
enable :raise_errors

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
$toppers        = JSON::load(File.open("./JSON-DATA/toppers.json"))
$items          = JSON::load(File.open("./JSON-DATA/items.json"))
$specialtyItems = JSON::load(File.open("./JSON-DATA/specialty-items.json"))
$sauces         = JSON::load(File.open("./JSON-DATA/sauces.json"))
$sauceModifiers = JSON::load(File.open("./JSON-DATA/saucemodifiers.json"))
$specialties    = JSON::load(File.open("./JSON-DATA/specialties.json"))
$stores         = JSON::load(File.open("./JSON-DATA/store-coordinates.json"))
# $session        = Hash.new()
$session        = Moneta.new(:File, dir: 'sessions')
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

# View REST routes (POST)
post '/rest/view/session/create-session' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    SessionViewController.createSession(data,session).to_json
end
post '/rest/view/session/set' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    SessionViewController.set(data['key'],data['value'],session).to_json
end
post '/rest/view/session/get' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    SessionViewController.get(data['key'],session).to_json
end
get '/rest/view/session/get' do
    content_type :json
    SessionViewController.get(params[:key],session).to_json
end
get '/rest/view/session/set' do
    content_type :json
    SessionViewController.set(params[:key],params[:value],session).to_json
end
post '/rest/view/specialty/list-specialties' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    SpecialtyViewController.listSpecialties(data)
end
get '/rest/view/specialty/list-specialties' do
    request.body.rewind  # in case someone already read it
    data = {"StoreID"=>params[:StoreID],"UnitID"=>params[:UnitID],"SizeID"=>params[:SizeID]}
    content_type :json
    SpecialtyViewController.listSpecialties(data)
end
get '/api/item' do
    request.body.rewind  # in case someone already read it
    data = {"StoreID"=>params[:StoreID],"UnitID"=>params[:UnitID],"SizeID"=>params[:SizeID],"SpecialtyID"=>params[:SpecialtyID]}
    content_type :json
    SpecialtyViewController.specialtyItem(data)
end
get '/api/item-sizes' do
    request.body.rewind  # in case someone already read it
    data = {"StoreID"=>params[:StoreID],"UnitID"=>params[:UnitID],"StyleID"=>params[:StyleID],"SpecialtyID"=>params[:SpecialtyID]}
    content_type :json
    StyleViewController.listSizesForStyle(data)
end
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
    OrderViewController.getOrder(data,session)
end
post '/rest/view/order/create-order' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    OrderViewController.createOrder(data,session)
end

post '/rest/view/order-item/get-default-specialty-items' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    OrderItemViewController.getDefaultSpecialtyItems(data)
end

post '/rest/view/order-line/delete-order-line' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    OrderLineViewController.deleteOrderLine(data,session)
end

post '/rest/view/order-line/get-order-lines' do
    request.body.rewind  # in case someone already read it
    data = JSON.parse request.body.read
    content_type :json
    OrderLineViewController.getOrderLines(data,session)
end
get '/api/order' do
    data = {}
    OrderViewController.getOrderNew(data,session).to_json
end
get '/api/order/lines' do
    data = {}
    OrderLineViewController.getOrderLines(data,session)
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
