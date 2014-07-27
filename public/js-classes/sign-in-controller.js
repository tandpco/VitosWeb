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

        password = $.md5(password);

        var json = {
            email: email,
            password: password
        }

        $('#modal-please-wait').modal('show');

        $.ajax({
            url: "/rest/view/customer/get-customer",
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
                if(data != '') {
                    console.log(data);
                    var customer     = data[0]
                    var email        = customer['EMail'];
                    var addressLine1 = customer['AddressLine1'];
                    var postalCode   = customer['PostalCode'];

                    $.session.set('email', email);

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

                var json = {
                    x: lng,
                    y: lat
                }
        
                $.ajax({
                    url: "/rest/view/store-locator/find-store",
                    type: "POST",
                    data: JSON.stringify(json),
                    success: function(data) {
                        // Yay! It worked!
                        if(data != '') {
                            var storeId = data['StoreID']
                            CommonUtils.chooseLocation(storeId);
                        }
                    }
                });

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


}
