function Session () {}
Session.set = function(name, value) {
    $.session.set(name, value);
}
Session.get = function(name) {
    return($.session.get(name));
}

function NavBar () {}
NavBar.createMarkup = function() {
    var html = "";
    html += '<nav class="navbar-default main-navbar" role="navigation">';
    html += '    <div class="container">';
    html += '        <!-- Brand and toggle get grouped for better mobile display -->';
    html += '        <div class="navbar-header">';
    html += '            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse" id="collapse-button">';
    html += '                <span class="sr-only">Toggle navigation</span>';
    html += '                <span class="icon-bar"></span>';
    html += '                <span class="icon-bar"></span>';
    html += '                <span class="icon-bar"></span>';
    html += '            </button>';
    html += '        </div>';
    html += '';
    html += '        <!-- Collect the nav links, forms, and other content for toggling -->';
    html += '        <div class="collapse navbar-collapse">';
    html += '            <ul class="nav navbar-nav navbar-right">';
     var curr_loc= window.location.pathname;
    html += '                <li><a href="/order-pizza" class="white-shadow"'+(curr_loc.indexOf("pizza")!=-1?'style="background-color:#006122"':'')+'>PIZZAS</a></li>';
    html += '                <li><a href="/order-subs" class="white-shadow"'+(curr_loc.indexOf("subs")!=-1?'style="background-color:#006122"':'')+'>SUBS</a></li>';
    html += '                <li><a href="/order-salads" class="white-shadow"'+(curr_loc.indexOf("salads")!=-1?'style="background-color:#006122"':'')+'>SALADS</a></li>';
    html += '                <li><a href="/order-sides" class="white-shadow"'+(curr_loc.indexOf("sides")!=-1?'style="background-color:#006122"':'')+'>SIDES</a></li>';
    html += '                <li><a href="/sign-in" onclick="$.session.clear()" class="white-shadow">Sign Out</a></li>';
    html += '            </ul>';
    html += '        </div>';
    html += '    </div>';
    html += '</nav>';
    return html;
}

function ModalPleaseWait () {}
ModalPleaseWait.createMarkup = function(name, message) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <h4 class="modal-title">' + message + '</h4>';
    html += '                <img src="/img/loading.gif"></img>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function ModalDelivery () {}
ModalDelivery.createMarkup = function(name, message, isRedirect) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <h5 class="modal-title">' + message + '</h4>';
    html += '                <a style="cursor:pointer; cursor:hand;" id="modeDelivery" onclick="CommonUtils.chooseDelivery(\''+isRedirect+'\')">';
    html += '                    <img src="/img/mode-delivery.png"/>';
    html += '                </a>';
    html += '                <a style="cursor:pointer; cursor:hand;" id="modePickup" onclick="CommonUtils.choosePickup(\''+isRedirect+'\')">';
    html += '                    <img src="/img/mode-pickup.png"/>';
    html += '                </a>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function ModalStoreIsClosed () {}
ModalStoreIsClosed.createMarkup = function(name, message) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <div class="row">';
    html += '                    <h4 class="modal-title">Store is currently closed.<br>Please try again during normal business hours.</h4>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="red-gradient-button" onclick="$.session.clear(); window.location.href = \'/sign-in\';">' + message + '</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}


function ModalInvalidLogin () {}
ModalInvalidLogin.createMarkup = function(name, message) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <div class="row">';
    html += '                    <h4 class="modal-title">Invalid e-mail address or password.</h4>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="red-gradient-button" onclick="$(\'#modal-invalid-login\').modal(\'hide\');">' + message + '</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}


function ModalInvalidPromo () {}
ModalInvalidPromo.createMarkup = function(name, message) {
    var html = "";
    html += '<div id="' + name + '" class="modal fade" data-backdrop="static" data-keyboard="false">';
    html += '    <div class="modal-dialog" style="width:25%">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <div class="row">';
    html += '                    <h4 class="modal-title">' + message + '</h4><br>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="red-gradient-button" onclick="$(\'#modal-invalid-promo\').modal(\'hide\');" style="width:30%">Ok</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function ModalLocation () {}
ModalLocation.createMarkup = function(name, message) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <div class="row">';
    html += '                    <h4 class="modal-title">' + message + '</h4>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <div id="storeInfo">';
    html += '                    </div>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="red-gradient-button" onclick="CommonUtils.chooseStore()">CHANGE LOCATION</button>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="green-gradient-button" onclick="CommonUtils.chooseMode()">CONTINUE</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function ModalStores () {}
ModalStores.createMarkup = function(name, message) {
    var html = "";
    html += '<div class="modal fade" data-backdrop="static" data-keyboard="false" id="' + name + '">';
    html += '    <div class="modal-dialog">';
    html += '        <div class="modal-content">';
    html += '            <div class="modal-body">';
    html += '                <div class="row">';
    html += '                    <h4 class="modal-title">' + message + '</h4>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <div id="stores">';
    html += '                    </div>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function CommonUtils() {}
CommonUtils.chooseDelivery = function(isRedirect) {
    $.session.set('mode', 'Delivery');
    $('#modal-delivery').modal('hide');
    $('.modal-backdrop').remove();
    if(isRedirect =="YES"){
       window.location.href = "/order-pizza";
    }
    else if(isRedirect =="NO"){
       OrderItems.buildYourOrder();
    }
}

CommonUtils.choosePickup = function(isRedirect) {
    $.session.set('mode', 'Pickup');
    $('#modal-delivery').modal('hide');
    $('.modal-backdrop').remove();
    if(isRedirect =="YES"){
       window.location.href = "/order-pizza";
    }
    else if(isRedirect =="NO"){
       OrderItems.buildYourOrder();
    }
}

CommonUtils.chooseMode = function() {
    $('#modal-location').modal('hide');
    $('#modal-delivery').modal('show');
}


CommonUtils.chooseLocation = function(storeId) {
    var json = {
        storeId:      storeId,
        streetName:   Session.get("streetName"),
        streetNumber: Session.get("streetNumber"),
        zip: Session.get("zip")
    }

    $.ajax({
        url: "/rest/view/store/get-store",
        type: "POST",
        data: JSON.stringify(json),
        success: function(data) {
            // Yay! It worked!
            if(data != '') {
                var store = data[0]
                storeId          = store['StoreID'];
                storeName        = store['StoreName'];
                addressLine1     = store['Address1'];
                addressLine2     = store['ADdress2'];
                city             = store['City'];
                state            = store['State'];
                postalCode       = store['PostalCode'];
                phone            = store['Phone']
                hours            = store['Hours'];
                isOpen           = store['IsOpen'];
                driverMoney      = store['DefaultDriverMoney'];
                deliveryCharge   = store['DefaultDeliveryCharge'];
                deliveryMin      = store['DeliveryMin'];

                Session.set('driverMoney', driverMoney);
                Session.set('deliveryCharge', deliveryCharge);
                Session.set('deliveryMin', deliveryMin);

                //console.log(hours);
                //console.log('Store is open: ' + isOpen);

                if(isOpen == false) {
                    $('#modal-store-is-closed').modal('show');
                }

                Session.set('storeId', storeId);

                var storeAddress = addressLine1 + ' ' + city + ', ' + state + ', ' + postalCode;
                Session.set('storeAddress', storeAddress);

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

CommonUtils.chooseStore = function() {
    var json = {
    }

    $.ajax({
        url: "/rest/view/store/list-stores",
        type: "POST",
        data: JSON.stringify(json),
        success: function(data) {
            // Yay! It worked!
            if(data != '') {
                var stores = data;
                var html   = "<h3>Stores:</h3>";

                $.each(data, function( index ) {
                    store = data[index];
                    console.log(store);

                    storeId          = store['StoreID'];
                    storeName        = store['StoreName'];
                    addressLine1     = store['Address1'];
                    addressLine2     = store['ADdress2'];
                    city             = store['City'];
                    state            = store['State'];
                    postalCode       = store['PostalCode'];
                    phone            = store['Phone']
                    hours            = store['Hours'];

                    var storeAddress = addressLine1 + ' ' + city + ', ' + state + ', ' + postalCode; 
                    var search       = addressLine1 + ' ' + postalCode; 
                    html += "<div>"
                    html += '<a href="#" onclick="$(\'#modal-stores\').modal(\'hide\'); CommonUtils.findStore(\'' + search + '\');">' + storeAddress + '</a>'
                    html += "</div>"
                });
                $('#stores').html(html);

                $('#modal-please-wait').modal('hide');
                $('#modal-stores').modal('show');
            }
            else {
                $('#modal-please-wait').modal('hide');
                $('#modal-invalid-login').modal('show');
            }
        }
    });
}

CommonUtils.findStore = function(search) {
    $('#modal-please-wait').modal();
    geo.geocode({address:search}, function (results,status) { 
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
                        zip = shortName;
                    }
                }
            }
            var street = streetNumber + " " + route;
            Session.set('streetName', route);
            Session.set('streetNumber', streetNumber);
            Session.set('addressLine1', street);
            Session.set('city', city);
            Session.set('state', state);
            Session.set('zip', zip);

            // Output the data
            var msg = 'address="' + search + '" lat=' +lat+ ' lng=' +lng+ '(delay=' + delay + 'ms)<br>';
            console.log("Address From Google: " + street);

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
                delay++;
            } else {
                var reason="Code "+status;
                var msg = 'address="' + search + '" error=' + reason + '(delay=' + delay + 'ms)<br>';
            }   
        }
      }
    );
}
