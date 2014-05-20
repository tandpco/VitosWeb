function SignInController () {
    this.geo = new google.maps.Geocoder();
    this.delay = 100;
    
    this.constructSession = function(){
        Session.set('orderItems', JSON.stringify(new Array()));
        Session.set('userPromoCodes',JSON.stringify(new Array()));
        Session.set('PIZZA_TOPPERS',JSON.stringify(new Array()));
        Session.set('SUBS_TOPPERS',JSON.stringify(new Array()));
        Session.set('SALADS_TOPPERS',JSON.stringify(new Array()));
        Session.set('PIZZA_SIZES',JSON.stringify(new Array()));
        Session.set('SUBS_SIZES',JSON.stringify(new Array()));
        Session.set('SALADS_SIZES',JSON.stringify(new Array()));
        Session.set('PIZZA_SAUCES',JSON.stringify(new Array()));
        Session.set('SUBS_SAUCES',JSON.stringify(new Array()));
        Session.set('SALADS_SAUCES',JSON.stringify(new Array()));
        Session.set('PIZZA_STYLES',JSON.stringify(new Array()));
        Session.set('SUBS_STYLES',JSON.stringify(new Array()));
        Session.set('SALADS_STYLES',JSON.stringify(new Array()));
        Session.set('PIZZA_SAUCEMODIFIERS',JSON.stringify(new Array()));
        Session.set('SUBS_SAUCEMODIFIERS',JSON.stringify(new Array()));
        Session.set('SALADS_SAUCEMODIFIERS',JSON.stringify(new Array()));
        Session.set('PIZZA_TOPPINGS',JSON.stringify(new Array()));
        Session.set('SUBS_TOPPINGS',JSON.stringify(new Array()));
        Session.set('SALADS_TOPPINGS',JSON.stringify(new Array()));
    }
 
    this.init = function() {
    
        $('#nav-container').append(NavBar.createMarkup());

        $('#main').append(ModalPleaseWait.createMarkup('modal-please-wait', 'Please wait'));
        $('#main').append(ModalInvalidLogin.createMarkup('modal-invalid-login', 'Click to try again'));
        $('#main').append(ModalLocation.createMarkup('modal-location', 'LOCATION CLOSEST TO YOU'));
        $('#main').append(ModalDelivery.createMarkup('modal-delivery', 'HOW WOULD YOU LIKE YOUR ORDER?','YES'));

    }

    this.signIn = function() {
        var email    = $("#sign-in-email-address").val();
        var password = $("#sign-in-password").val();
        var json = {
            Tblcustomers: {
                filters: [
                    {
                        name: "EMail",
                        value: email
                    }
                ],
                pagination: {
                    page: "1",
                    limit: "1"
                }
            }
        }

        $('#modal-please-wait').modal('show');

        $.ajax({
            url: "/rest/view/tblcustomers/get-tblcustomers",
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                if(data != '') {
                    console.log(data);
                    var customer     = data[0]
                    var email        = customer['EMail'];
                    var addressLine1 = customer['AddressLine1'];
                    var postalCode   = customer['PostalCode'];

                    Session.set('email', email);

                    $('#modal-please-wait').modal('hide');

                    search = addressLine1 + " " + postalCode;
                    pageController.findStore(search);

                }
                else {
                    $('#modal-please-wait').modal('hide');
                    $('#modal-invalid-login').modal('show');
                }
            },
            error: function() {
                $('#modal-please-wait').modal('hide');
                $('#modal-invalid-login').modal('show');
            }

        });
        
    }

    this.signUp = function() {

        var email  = $("#sign-up-email-address").val();
        var zip    = $("#sign-up-zip-code").val();
        var street = $("#sign-up-street").val();
        var apt    = $("#sign-up-apt").val();

        console.log("Email: " + email);
        console.log("Address Line 1: " + street);

        $.session.set('email', email);
        $.session.set('apt', apt);

        $('#modal-please-wait').modal('show');
        search = street + " " + zip;
        pageController.findStore(search);
    }

    this.findStore = function(search) {
        this.geo.geocode({address:search}, function (results,status) { 
            // If that was successful
            if (status == google.maps.GeocoderStatus.OK) {
                // Lets assume that the first marker is the one we want
                var point = results[0];
                var location = point.geometry.location;
                var lat = location.lat();
                var lng = location.lng();

                // Get Google's version of the address
                var streetNumber = "";
                var route        = "";
                var city         = "";
                var state        = "";
                var zip          = "";
                for (var component in point['address_components']) {
                    var shortName = point['address_components'][component]['short_name'];
                    for (var i in point['address_components'][component]['types']) {
                        var type = point['address_components'][component]['types'][i];
                        if (type == "administrative_area_level_1") {
                            state = shortName;
                        }
                        if (type == "locality") {
                            city = shortName;
                        }
                        if (type == "street_number") {
                            streetNumber = shortName;
                        }
                        if (type == "route") {
                            route = shortName;
                        }
                        if (type == "postal_code") {
                            var zip = shortName;
                        }
                    }
                }
                var street = streetNumber + " " + route;
                Session.set('addressLine1', street);
                Session.set('city', city);
                Session.set('state', state);
                Session.set('zip', zip);
    
                // Output the data
                var msg = 'address="' + search + '" lat=' +lat+ ' lng=' +lng+ '(delay=' + pageController.delay + 'ms)<br>';

                var stores = new Array();
                stores[0]  = { storeId: "1", lat: "41.6611726", lng: "-83.66769339999996" };
                stores[1]  = { storeId: "2", lat: "41.58776779999999", lng: "-83.4926021" };
                stores[2]  = { storeId: "3", lat: "41.690257", lng: "-83.71288800000002" };
                stores[3]  = { storeId: "4", lat: "41.6373726", lng: "-83.45169169999997" };
                stores[4]  = { storeId: "5", lat: "41.6330219", lng: "-83.590169" };
                stores[5]  = { storeId: "6", lat: "41.5942302", lng: "-83.64468590000001" };
                stores[6]  = { storeId: "7", lat: "41.704079", lng: "-83.56567100000001" };
                stores[7]  = { storeId: "8", lat: "41.705399", lng: "-83.66177299999998" };
                stores[8]  = { storeId: "9", lat: "41.5451618", lng: "-83.62160929999999" };
                stores[9]  = { storeId: "10", lat: "41.6258259", lng: "-83.70329290000001" };
                stores[10] = { storeId: "11", lat: "41.64471", lng: "-83.51976200000001" };
                stores[11] = { storeId: "12", lat: "41.696273", lng: "-83.604289" };
                stores[12] = { storeId: "13", lat: "41.684755", lng: "-83.54274399999997" };
                stores[13] = { storeId: "14", lat: "41.059306", lng: "-83.65056600000003" };
                stores[14] = { storeId: "15", lat: "41.7155184", lng: "-83.47915039999998" };
                stores[15] = { storeId: "16", lat: "41.6776187", lng: "-83.62064929999997" };
                stores[16] = { storeId: "17", lat: "41.7501802", lng: "-83.5677637" };
                stores[17] = { storeId: "18", lat: "41.1023733", lng: "-85.05734899999999" };
                stores[18] = { storeId: "19", lat: "41.9256341", lng: "-83.4133933" };
                stores[19] = { storeId: "20", lat: "41.374559", lng: "-83.64959899999997" };
    
                var minDistance = 1000;
                var closeestStoreId = -1;
                for(var i = 0; i < stores.length; i++) {
                    var store = stores[i]; 
                    var distance = getDistanceFromLatLonInKm(lat,lng,store['lat'],store['lng']);
                    if(distance < minDistance) {
                        closestStoreId = store['storeId'];
                        minDistance = distance;
                    }
                }
    
                console.log('Closest store: ' + closestStoreId);
                console.log('Distance: ' + minDistance + ' km');
                pageController.chooseLocation(closestStoreId);

            }
            // ====== Decode the error status ======
            else {
                // === if we were sending the requests to fast, try this one again and increase the delay
                if (status == google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
                    pageController.delay++;
                } else {
                    var reason="Code "+status;
                    var msg = 'address="' + search + '" error=' + reason + '(delay=' + pageController.delay + 'ms)<br>';
                }   
            }
          }
        );
    }

    function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
        var R = 6371; // Radius of the earth in km
        var dLat = deg2rad(lat2-lat1);  // deg2rad below
        var dLon = deg2rad(lon2-lon1); 
        var a = 
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
        Math.sin(dLon/2) * Math.sin(dLon/2)
        ; 
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
        var d = R * c; // Distance in km
        return d;
    }

    function deg2rad(deg) {
        return deg * (Math.PI/180)
    }

    this.chooseMode = function() {
        $('#modal-location').modal('hide');
        $('#modal-delivery').modal('show');
    }

    this.chooseLocation = function(storeId) {
        var json = {
            Tblstores: {
                filters: [
                    {
                        name: "StoreID",
                        value: storeId
                    }
                ],
                pagination: {
                    page: "1",
                    limit: "1"
                }
            }
        }

        $.ajax({
            url: "/rest/model/tblstores/filter",
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                // Yay! It worked!
                if(data != '') {
                    var store = data['tblstores'][0]
                    storeId          = store['StoreID'];
                    storeName        = store['StoreName'];
                    addressLine1     = store['Address1'];
                    addressLine2     = store['ADdress2'];
                    city             = store['City'];
                    state            = store['State'];
                    postalCode       = store['PostalCode'];
                    phone            = store['Phone']
                    hours            = store['Hours'];

                    Session.set('storeId', storeId);

                    /*
                    array = phone.split('');
                    if(array.length > 0) {
                        phone = "(" + array[0] + array[1] + array[2] + ") " + array[3] + array[4] + array[5] + "-" + array[6] + array[7] + array[8]+ array[9];
                    }
                    */

                    html  = '<img src="/img/store-' + storeId + '-map.png"></img>';
                    html += '<h5>' + addressLine1 + '</h5>';
                    html += '<h5>' + city + ", " + state + " " + postalCode + '</h5>';
                    html += '<label for="#store_phone_num">' + 'PHONE: </label><p id="store_phone_num">' + phone + '</p>';
                    html += '<label>' + "HOURS" + '</label>';
                    html += '<p>' + hours + '</p>';
                    $('#storeInfo').html(html);

                    $('#storeInfo').find("img").css({height: "200px", width: "200px"});
                    $('#storeInfo').attr("align","center");

                    $('#modal-please-wait').modal('hide');
                    $('#modal-location').modal('show');
                }
                else {
                    $('#modal-please-wait').modal('hide');
                    $('#modal-invalid-login').modal('show');
                }
            }
        });
    }

}
