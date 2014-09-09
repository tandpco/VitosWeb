(function() {
  var $app;

  $app = angular.module('app', ['ngRoute', 'ui.router', 'restangular']);

  $app.config(function($stateProvider, $urlRouterProvider, RestangularProvider) {
    RestangularProvider.setBaseUrl('/api');
    return $stateProvider.state('detail', {
      url: "/detail/:unitId/:specialtyId",
      templateUrl: "app/partials/detail.html",
      resolve: {
        $specialty: function(Restangular, $stateParams) {
          return Restangular.one('item').get({
            "StoreID": "7",
            "UnitID": $stateParams.unitId,
            "SpecialtyID": $stateParams.specialtyId,
            "SizeID": "null"
          });
        }
      },
      controller: function($scope, $specialty, $stateParams, Restangular) {
        var verifySelectedSize, x, _i, _j, _len, _len1, _ref, _ref1;
        $scope.$sp = $specialty;
        $scope.onMeat = true;
        $scope.tab = 'size';
        $scope.$line = {
          SauceID: $specialty.specialty.SauceID,
          SizeID: null,
          Sides: [],
          Toppings: [],
          StyleID: $specialty.specialty.StyleID,
          Toppers: [],
          notes: ''
        };
        $scope.$selectedSides = {};
        $scope.$selectedToppings = {};
        $scope.$selectedToppers = {};
        $scope.styleSurcharge = function() {
          var x, _i, _len, _ref;
          _ref = $scope.$sp.sizes;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            x = _ref[_i];
            if ($scope.$line.SizeID === x.SizeID && x.StyleSurcharge > 0) {
              return x.StyleSurcharge;
            }
          }
          return 0;
        };
        verifySelectedSize = function(sizes) {
          var sel, x, _i, _len;
          sel = false;
          for (_i = 0, _len = sizes.length; _i < _len; _i++) {
            x = sizes[_i];
            if (x.SizeID === $scope.$line.SizeID) {
              sel = true;
            }
          }
          if (sel === false) {
            return $scope.$line.SizeID = sizes[0].SizeID;
          }
        };
        $scope.filterCheese = function(i) {
          if ([10, 12, 13, 49, 52, 53, 59, 60, 84, 104].indexOf(i.ItemID) !== -1) {
            return true;
          }
          return false;
        };
        $scope.filterMeat = function(i) {
          if ([10, 12, 13, 49, 52, 53, 59, 60, 84, 104].indexOf(i.ItemID) !== -1) {
            return false;
          }
          if ($scope.onMeat && [11, 14, 19, 21, 27, 28, 33, 35, 43, 44, 45, 46, 50, 51, 55, 56, 97, 105].indexOf(i.ItemID) !== -1) {
            return true;
          }
          if (!$scope.onMeat && [11, 14, 19, 21, 27, 28, 33, 35, 43, 44, 45, 46, 50, 51, 55, 56, 97, 105].indexOf(i.ItemID) === -1) {
            return true;
          }
          return false;
        };
        $scope.orderItem = function() {
          var URL, deliveryMode, json, mode, orderItemJson, orderJson, toppingsJson, x, _i, _len, _ref;
          orderItemJson = {
            pUnitID: $stateParams.unitId,
            pSpecialtyID: $stateParams.specialtyId,
            pSizeID: $scope.$line.SizeID,
            pStyleID: $scope.$line.StyleID,
            pHalf1SauceID: $scope.$line.SauceID,
            pHalf2SauceID: $scope.$line.SauceID,
            pHalf1SauceModifierID: $scope.$line.sauceModifierID,
            pHalf2SauceModifierID: $scope.$line.sauceModifierID,
            pOrderLineNotes: $scope.$line.notes,
            pQuantity: $scope.$line.Quantity || 1
          };
          mode = Session.get("mode");
          deliveryMode = mode === "Delivery" ? "1" : "2";
          orderJson = {
            pCustomerID: "6063",
            pCustomerName: "Vito''s Fan",
            pCustomerPhone: "1111111111",
            pAddressID: "1",
            pOrderTypeID: deliveryMode,
            pDeliveryCharge: Session.get("deliveryCharge"),
            pDriverMoney: Session.get("driverMoney"),
            pOrderNotes: ""
          };
          toppingsJson = [];
          _ref = $scope.$line.Toppings;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            x = _ref[_i];
            toppingsJson.push({
              id: x['ItemID'],
              portion: x['Portion']
            });
          }
          json = {
            order: orderJson,
            orderItem: orderItemJson,
            orderItemToppings: toppingsJson,
            orderItemToppers: $scope.$line.Toppers,
            orderItemSides: $scope.$line.Sides
          };
          URL = "/rest/view/order/create-order";
          return $.ajax({
            url: URL,
            type: "POST",
            data: JSON.stringify(json),
            success: function(data) {
              console.log(data);
              return $scope.$root.updateOrder();
            }
          });
        };
        $scope.setSide = function(side, value) {
          var $v;
          $scope.$selectedSides[side.SideID] = value;
          $v = {
            already: false,
            remove: false
          };
          _.each($scope.$line.Sides, function(val, key) {
            if (val.SideID === side.SideID) {
              if (value === false) {
                $v.remove = key;
              } else {
                val.Quantity = parseInt(value);
              }
              return $v.already = true;
            }
          });
          console.log(side, value);
          if ($v.remove !== false) {
            $scope.$line.Sides.splice($v.remove, 1);
            console.log('removed');
          }
          if (!$v.already) {
            return $scope.$line.Sides.push({
              SideID: side.SideID,
              Quantity: parseInt(value)
            });
          }
        };
        $scope.setTopping = function(topping, value, side) {
          var $v;
          if (value) {
            $scope.$selectedToppings[topping.ItemID] = side;
          } else {
            $scope.$selectedToppings[topping.ItemID] = false;
          }
          $v = {
            already: false,
            remove: false
          };
          _.each($scope.$line.Toppings, function(val, key) {
            if (val.ItemID === topping.ItemID) {
              if (value === false) {
                $v.remove = key;
              }
              val.Portion = side;
              return $v.already = true;
            }
          });
          console.log(topping, value, $scope.$line.Toppings);
          if ($v.remove !== false) {
            $scope.$line.Toppings.splice($v.remove, 1);
            console.log('removed');
          }
          if (!$v.already) {
            return $scope.$line.Toppings.push({
              ItemID: topping.ItemID,
              Portion: side
            });
          }
        };
        $scope.setTopper = function(topper, value) {
          var exists;
          $scope.$selectedToppers[topper.TopperID] = value && true || false;
          exists = $scope.$line.Toppers.indexOf(topper.TopperID) !== -1;
          if (!value && exists) {
            $scope.$line.Toppers.splice($scope.$line.Toppers.indexOf(topper.TopperID), 1);
          }
          if (value && !exists) {
            return $scope.$line.Toppers.push(topper.TopperID);
          }
        };
        if (_.isArray($scope.$sp.defaults)) {
          _ref = $scope.$sp.defaults;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            x = _ref[_i];
            $scope.setTopping(x, true, 'whole');
          }
        }
        if (!$specialty.NoBaseCheese) {
          _ref1 = $specialty.toppings;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            x = _ref1[_j];
            if (x.IsBaseCheese) {
              $scope.setTopping(x, true, 'whole');
            }
          }
        }
        return $scope.$watch("$line.StyleID", function(v) {
          if (v) {
            $scope.checkingSizes = true;
            return Restangular.all("item-sizes").getList({
              "StoreID": "7",
              "UnitID": $stateParams.unitId,
              "SpecialtyID": $stateParams.specialtyId,
              "StyleID": v
            }).then(function(v) {
              $scope.checkingSizes = false;
              verifySelectedSize(v);
              return $scope.$sp.sizes = v;
            });
          }
        });
      }
    });
  });

  $app.run(function($state, $rootScope, Restangular) {
    window.__itemDetail = function(unitId, specialtyId) {
      return $state.go('detail', {
        unitId: unitId,
        specialtyId: specialtyId
      });
    };
    window.updateOrder = function() {
      return $rootScope.updateOrder();
    };
    $rootScope.halfPretty = function(half) {
      var halfs;
      half = parseInt(half);
      halfs = ['Whole', 'Left', 'Right', '2x'];
      return halfs[half];
    };
    $rootScope.updateOrder = function() {
      $rootScope.$lines = [];
      Restangular.one("order").get().then(function(v) {
        return $rootScope.$order = v;
      });
      return Restangular.one("order").all("lines").getList().then(function(v) {
        console.log(v);
        return $rootScope.$lines = v;
      });
    };
    $rootScope.updateOrder();
  });

}).call(this);
