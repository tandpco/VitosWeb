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
    html += '                <a style="cursor:pointer; cursor:hand;" id="modeDelivery" onclick="SetDelivery.chooseDelivery(\''+isRedirect+'\')">';
    html += '                    <img src="/img/mode-delivery.png"/>';
    html += '                </a>';
    html += '                <a style="cursor:pointer; cursor:hand;" id="modePickup" onclick="SetPickup.choosePickup(\''+isRedirect+'\')">';
    html += '                    <img src="/img/mode-pickup.png"/>';
    html += '                </a>';
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
    html += '                    <button class="red-gradient-button" onclick="$(\'#invalidLogin\').modal(\'hide\');">' + message + '</button>';
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
    html += '                    <button class="red-gradient-button" onclick="pageController.chooseMode()">CHANGE LOCATION</button>';
    html += '                </div>';
    html += '                <div class="row">';
    html += '                    <button class="green-gradient-button" onclick="pageController.chooseMode()">CONTINUE</button>';
    html += '                </div>';
    html += '            </div>';
    html += '        </div><!-- /.modal-content -->';
    html += '    </div><!-- /.modal-dialog -->';
    html += '</div><!-- /.modal -->';
    return html;
}

function SetDelivery (){}
SetDelivery.chooseDelivery = function(isRedirect) {
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

function SetPickup (){}
    SetPickup.choosePickup = function(isRedirect) {
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
  

