<%
option explicit
Response.buffer = TRUE

If UCase(Request.ServerVariables("HTTPS")) <> "ON" Then
	Response.Redirect("https://www.vitos.com/orderdev/Default.asp")
End If

If Len(Session("ORDERID")) = 0 Then
	Response.Redirect("deals.asp")
End If

If Session("ORDERID") = 0 Then
	Response.Redirect("deals.asp")
End If%>
<!-- #Include File="include/adovbs.asp" -->
<!-- #Include File="include/app-settings.asp" -->
<!-- #Include File="include/app-database.asp" -->
<!-- #Include File="include/app-ordering.asp" -->
<!-- #Include File="include/app-mail.asp" -->
<!-- #Include File="include/md5.asp" -->
<%
If Len(Session("ADDRESS")) = 0 Or Len(Session("ZIPCODE")) = 0 Or Len(Session("STORE")) = 0 Then
	Response.Redirect("Default.asp")
End If

If Not IsStoreEnabled(Session("STORE")) Then
	Response.Redirect("maintenance.asp")
End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Welcome to Vito&#39;s Pizza Online Ordering</title>
<link rel="stylesheet" href="css/ordering2.css" type="text/css" />
<script type="text/javascript">
<!--
var ie4=document.all;

function validateForm()
{
	var tmpObj1, tmpObj2, cemail, cpassword, cfirstname, clastname, caddress, ccity, cstate, czipcode, cphone;
	
	tmpObj1 = ie4? eval("document.all.EMAIL") : document.getElementById('EMAIL');
	cemail = new String(tmpObj1.value);
	if (cemail.length == 0)
	{
		alert('E-Mail Address is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.PASSWORD") : document.getElementById('PASSWORD');
	cpassword = new String(tmpObj1.value);
	if (cpassword.length == 0)
	{
		alert('Password is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.FIRSTNAME") : document.getElementById('FIRSTNAME');
	cfirstname = new String(tmpObj1.value);
	if (cfirstname.length == 0)
	{
		alert('First Name is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.LASTNAME") : document.getElementById('LASTNAME');
	clastname = new String(tmpObj1.value);
	if (clastname.length == 0)
	{
		alert('Last Name is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.ADDRESS") : document.getElementById('ADDRESS');
	caddress = new String(tmpObj1.value);
	if (caddress.length == 0)
	{
		alert('Address is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.CITY") : document.getElementById('CITY');
	ccity = new String(tmpObj1.value);
	if (ccity.length == 0)
	{
		alert('City is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.STATE") : document.getElementById('STATE');
	cstate = new String(tmpObj1.value);
	if (cstate.length == 0)
	{
		alert('State is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.ZIPCODE") : document.getElementById('ZIPCODE');
	czipcode = new String(tmpObj1.value);
	if (czipcode.length == 0)
	{
		alert('Zip Code is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.PHONE") : document.getElementById('PHONE');
	cphone = new String(tmpObj1.value);
	if (cphone.length == 0)
	{
		alert('Phone Number is required.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.EMAIL") : document.getElementById('EMAIL');
	tmpObj2 = ie4? eval("document.all.EMAILCONFIRM") : document.getElementById('EMAILCONFIRM');
	if (tmpObj1.value != tmpObj2.value) {
		alert('E-Mail Addresses do not match.');
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.PASSWORD") : document.getElementById('PASSWORD');
	tmpObj2 = ie4? eval("document.all.PASSWORDCONFIRM") : document.getElementById('PASSWORDCONFIRM');
	if (tmpObj1.value != tmpObj2.value) {
		alert('Passwords do not match.');
		return false;
	}
	
	return true;
}

function togglePayment()
{
	var tmpObj1, tmpObj2, tmpObj3;
	
	tmpObj1 = ie4? eval("document.all.PAYMETHOD1") : document.getElementById('PAYMETHOD1');
	if (tmpObj1.checked)
	{
//		tmpObj1 = ie4? eval("document.all.tip1") : document.getElementById('tip1');
//		tmpObj1.style.visibility = 'visible'
		tmpObj1 = ie4? eval("document.all.subtext") : document.getElementById('subtext');
		tmpObj1.innerHTML = "<strong>All credit card orders are processed by our secure payment gateway.</strong>"
	}
	else
	{
//		tmpObj1 = ie4? eval("document.all.tip1") : document.getElementById('tip1');
//		tmpObj1.style.visibility = 'hidden'
		tmpObj1 = ie4? eval("document.all.subtext") : document.getElementById('subtext');
		tmpObj1.innerHTML = "<strong>By clicking the submit button your order will be sent to our store and you will receive an order confirmation.</strong>"
	}
	
//	recalcGT()
}

function recalcGT()
{
	var tmpObj1;
	
//	tmpObj1 = ie4? eval("document.all.PAYMETHOD1") : document.getElementById('PAYMETHOD1');
//	if (tmpObj1.checked)
//	{
//		tmpObj1 = ie4? eval("document.all.TIP") : document.getElementById('TIP');
//		var nGT = <%=Session("GTOTAL")%> + <%=Session("DELIVERY")%> + <%=Session("TAX")%> + (tmpObj1.value * 1.00)
//	}
//	else
//	{
		var nGT = <%=Session("GTOTAL")%> + <%=Session("DELIVERY")%> + <%=Session("TAX")%>
//	}
	
	tmpObj1 = ie4? eval("document.all.GT") : document.getElementById('GT');
	tmpObj1.innerHTML = "$" + (Math.round(nGT * 100) / 100)
}

function limitText(limitField, limitCount, limitNum) {
	if (limitField.value.length > limitNum) {
		limitField.value = limitField.value.substring(0, limitNum);
	} else {
		limitCount.value = limitNum - limitField.value.length;
	}
}

function toggleTCPA() {
	var loObj;
	
	loObj = ie4? eval("document.all.TCPA") : document.getElementById("TCPA");
	if (loObj.style.visibility == "visible") {
		loObj.style.visibility = "hidden";
		loObj.style.height = "0px";
	}
	else {
		loObj.style.visibility = "visible";
		loObj.style.height = "90px";
	}
}
//-->
</script>
<script type="text/javascript" src="include/valid-date2.js"></script>
</head>

<%
Dim sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours, sDisplayAddress, nTempStore, nDelivery, nDrMoney
Dim saUnitName(), naUnitNum(), saUnitDesc(), saCustomDesc(), i, oFS, sFileName
Dim nOrderID, dDelivery, dDrMoney, dTax, dTip, anOrderItemID(), anQty(), asDescription(), adPrice(), dSubtotal, dTotal, dDeliveryMin, naPromos, naPromoCodes
%>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table id="Table_01" width="851" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td rowspan="8" background="images/template_01.jpg" width="1" height="647"></td>
		<td colspan="18" align="left" valign="top" background="images/template_02.jpg" width="804" height="133">
			&nbsp;<br />
			<table width="804" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" width="254" align="center">
						<span class="total">TEST SYSTEM</span>
					</td>
					<td valign="top" width="170">
					</td>
					<td valign="top" width="170">
					</td>
					<td valign="top" align="right" width="210"></td>
				</tr>
			</table>
		</td>
		<td align="left" valign="top" background="images/template_03.jpg" width="46" height="133"></td>
	</tr>
	<tr>
		<td colspan="2" align="left" valign="top" background="images/template_04.jpg" width="258" height="23"></td>
		<td align="left" valign="top" background="images/template_05.jpg" width="53" height="23">
		<img src="images/template_05.jpg" width="53" height="23" alt="Home" /></td>
		<td align="left" valign="top" background="images/template_06.jpg" width="12" height="23"></td>
		<td align="left" valign="top" background="images/template_07.jpg" width="49" height="23">
		<img src="images/template_07.jpg" width="49" height="23" alt="Menu" /></td>
		<td align="left" valign="top" background="images/template_08.jpg" width="15" height="23"></td>
		<td align="left" valign="top" background="images/template_09.jpg" width="74" height="23">
		<img src="images/template_09.jpg" width="74" height="23" alt="Coupons" /></td>
		<td align="left" valign="top" background="images/template_10.jpg" width="13" height="23"></td>
		<td colspan="3" align="left" valign="top" background="images/template_11.jpg" width="87" height="23">
		<img src="images/template_11.jpg" width="87" height="23" alt="Locations" /></td>
		<td align="left" valign="top" background="images/template_12.jpg" width="13" height="23"></td>
		<td align="left" valign="top" background="images/template_13.jpg" width="89" height="23">
		<img src="images/template_13.jpg" width="89" height="23" alt="Franchise" /></td>
		<td align="left" valign="top" background="images/template_14.jpg" width="13" height="23"></td>
		<td align="left" valign="top" background="images/template_15.jpg" width="41" height="23">
		<img src="images/template_15.jpg" width="41" height="23" alt="Jobs" /></td>
		<td align="left" valign="top" background="images/template_16.jpg" width="14" height="23"></td>
		<td colspan="2" align="left" valign="top" background="images/template_17.jpg" width="73" height="23">
		<img src="images/template_17.jpg" width="73" height="23" alt="Contact" /></td>
		<td align="left" valign="top" background="images/template_18.jpg" width="46" height="23"></td>
	</tr>
	<tr>
		<td colspan="19" align="left" valign="top" background="images/template_19.jpg" width="850" height="78">
			<div align="right" style="margin-right:24px; margin-top:4px">
				<font color="#FFFF00" size="4">
					<marquee bgcolor="#FF0000" direction="left" loop="-1" width="575">
						<strong><%=GetMarqueeText()%></strong></marquee>
				</font>
			</div>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template_20.jpg" width="65" height="80"></td>
		<td colspan="18" align="left" valign="top" background="images/template_21.jpg" width="785" height="80">
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" background="images/navigation-left.jpg" width="27" height="64"></td>
<%
If GetUnits(Session("STORE"), saUnitName, naUnitNum, saUnitDesc, saCustomDesc) Then
	If Len(saUnitName(0)) > 0 Then
		Set oFS = CreateObject("Scripting.FileSystemObject")
		
		For i = 0 To UBound(saUnitName)
			sFileName = "images/navigation-unit" & naUnitNum(i) & ".jpg"
			
			If oFS.FileExists(Server.MapPath(sFileName)) Then
%>
					<td valign="top" background="<%=sFileName%>" height="64">
					<a href="unit.asp?uid=<%=naUnitNum(i)%>"><img src="<%=sFileName%>" height="64" alt="<%=saUnitName(i)%>" /></a></td>
					<td valign="top" background="images/navigation-spacer.jpg" width="6" height="64"></td>
<%
			End If
		Next
		
		Set oFS = Nothing
	End If
End If
%>
					<td valign="top" background="images/navigation-sides.jpg" width="129" height="64">
					<a href="sides.asp"><img src="images/navigation-sides.jpg" width="129" height="64" alt="Sides" /></a></td>
					<td valign="top" background="images/navigation-spacer.jpg" width="6" height="64"></td>
					<td valign="top" background="images/navigation-deals.jpg" width="58" height="64">
					<a href="deals.asp"><img src="images/navigation-deals.jpg" width="58" height="64" alt="Deals" /></a></td>
					<td valign="top" background="images/navigation-right.jpg" width="40" height="64"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template_22.jpg" width="65" height="86"></td>
		<td colspan="8" rowspan="3" align="left" valign="top" background="images/template_23.jpg" width="434" height="246">
			<table width="434" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" width="15"></td>
					<td valign="top" width="419">
<%
Dim sError, sZipCode, sAddress, sApt, nStore, nMailList, nSMSList, nCustomerID, nOrderItems, sDescription, nQty, sNotes, sCashCheck, nAddressID

sError = ""
nOrderID = Session("ORDERID")

If Request.Form("ACTION") = "REGISTER" Then
	' Strip all non-numeric from zip and phone
	sZipCode = ""
	For i = 1 to Len(Request("ZIPCODE"))
		If IsNumeric(Mid(Request("ZIPCODE"), i, 1)) Then
			sZipCode = sZipCode + Mid(Request("ZIPCODE"), i, 1)
		End If
	Next
	sPhone = ""
	For i = 1 to Len(Request("PHONE"))
		If IsNumeric(Mid(Request("PHONE"), i, 1)) Then
			sPhone = sPhone + Mid(Request("PHONE"), i, 1)
		End If
	Next
	If Left(sPhone, 1) = "1" Then
		sPhone = Mid(sPhone, 2)
	End If
	If Len(sPhone) > 10 Then
		sPhone = Left(sPhone, 10)
	End If
	
	' Normalize address
	' Also ensure delivery store is correct.
	If Len(Request("APT")) > 0 Then
		sAddress = Request("ADDRESS") + " #" + Request("APT")
	Else
		sAddress = Request("ADDRESS")
	End If
	sApt = ""
	nStore = LocateStoreByAddress(sZipCode, sAddress, sApt, sCity, sState, nDelivery, nDrMoney)
	
	sDisplayAddress = Session("ADDRESS")
	If Len(sApt) > 0 Then
		sDisplayAddress = sDisplayAddress & " #" & Session("APT")
	End If
	
	If Request("MAILLIST") = "YES" Then
		nMailList = 1
	Else
		nMailList = 0
	End If
	
	If Request("SMSLIST") = "YES" Then
		nSMSList = 1
	Else
		nSMSList = 0
	End If
	
	' Add/Update customer here
	If RegisterCustomer(nStore, nOrderID, Request("EMAIL"), Request("PASSWORD"), Request("FIRSTNAME"), Request("LASTNAME"), Request("ADDRESSNAME"), sAddress, sApt, sCity, sState, sZipCode, sPhone, nMailList, nSMSList, Request("DOB"), Request("SPECINST"), nAddressID) Then
		nCustomerID = GetCustomerID(Request("EMAIL"))
		
		If nCustomerID <> -1 Then
			Session("EMAIL") = Request("EMAIL")
			Session("FIRSTNAME") = Request("FIRSTNAME")
			Session("LASTNAME") = Request("LASTNAME")
			Session("ADDRESSID") = nAddressID
			Session("ADDRESSNAME") = Request("ADDRESSNAME")
			Session("ADDRESS") = sAddress
			Session("APT") = sApt
			Session("CITY") = sCity
			Session("STATE") = sState
			Session("ZIPCODE") = sZipCode
			Session("PHONE") = sPhone
			Session("CUSTOMERID") = nCustomerID
			Session("DOB") = Request("DOB")
			Session("SPECINST") = Request("SPECINST")
			
			If Len(sApt) > 0 Then
				sAddress = sAddress & sApt
			End If
			
			If Session("MODE") = "DELIVERY" Then
				nStore = LocateStoreByAddress(sZipCode, sAddress, sApt, sCity, sState, nDelivery, nDrMoney)
				If nStore > 0 Then
					If Session("ORDERID") > 0 Then
						If SetOrderType(Session("ORDERID"), nStore, 1, nDelivery, nDrMoney) Then
							If CInt(Session("NUMITEMS")) > 0 Then
								GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
							End If
							
							If Not SetOrderAddress(Session("ORDERID"), nAddressID) Then
								sError = "Sorry we are currently unable to process your order online."
								nStore = 0
							End If
						Else
							Response.Redirect("Default.asp")
						End If
					End If
					
					Session("STORE") = nStore
					Session("MODE") = "DELIVERY"
					Session("DELIVERY") = CDbl(nDelivery)
					Session("DRMONEY") = CDbl(nDrMoney)
					
					UpdateActivityStore Session("ACTIVITYID"), nStore, 1
				Else
					If Session("ORDERID") > 0 Then
						If Not SetOrderAddress(Session("ORDERID"), nAddressID) Then
							sError = "Sorry we are currently unable to process your order online."
							nStore = 0
						Else
							Response.Redirect("pickup.asp?ACTION=PICKUP")
						End If
					Else
						Response.Redirect("pickup.asp?ACTION=PICKUP")
					End If
				End If
			Else
				' Need to put store number back
				nStore = Session("STORE")
				
				If Session("ORDERID") > 0 Then
					If SetOrderType(Session("ORDERID"), nStore, 2, 0.00, 0.00) Then
						If CInt(Session("NUMITEMS")) > 0 Then
							GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
						End If
						
						If Not SetOrderAddress(Session("ORDERID"), nAddressID) Then
							sError = "Sorry we are currently unable to process your order online."
							nStore = 0
						End If
					Else
						Response.Redirect("Default.asp")
					End If
				End If
			End If
		Else
			Session("ZIPCODE") = sZipCode
			sError = "Sorry we are currently unable to process your order online."
			nStore = 0
		End If
	Else
		Session("ZIPCODE") = sZipCode
		sError = "Sorry we are currently unable to process your information online."
		nStore = 0
	End If
End If

Dim bFoundPromo, naCurrentPromos, saCurrentPromoCodes

nOrderID = Session("ORDERID")

If Request.Form("ACTION") = "ADD" Then
	If Request("PROMO").Count > 0 Then
		If IsNumeric(Request("PROMO")) And Request("PROMO") <> "0" Then
			If Len(Session("PROMOS")) = 0 Then
				Session("PROMOS") = Request("PROMO")
			Else
				bFoundPromo = FALSE
				naCurrentPromos = Split(Session("PROMOS"), ",")
				
				For i = 0 To UBound(naCurrentPromos)
					If CDbl(naCurrentPromos(i)) = CDbl(Request("PROMO")) Then
						bFoundPromo = TRUE
					End If
				Next
				
				If Not bFoundPromo Then
					Session("PROMOS") = Session("PROMOS") & "," & Request("PROMO")
				End If
			End If
		End If
	End If
	
	If Len(Trim(Request.Form("PROMOCODE"))) > 0 Then
		If ValidatePromoCode(Session("DMA"), Session("STORE"), UCase(Trim(Request("PROMOCODE")))) Then
			If Len(Session("PROMOCODES")) = 0 Then
				Session("PROMOCODES") = UCase(Trim(Request("PROMOCODE")))
			Else
				bFoundPromo = FALSE
				saCurrentPromoCodes = Split(Session("PROMOCODES"), ",")
				
				For i = 0 To UBound(saCurrentPromoCodes)
					If UCase(saCurrentPromoCodes(i)) = UCase(Trim(Request("PROMOCODE"))) Then
						bFoundPromo = TRUE
					End If
				Next
				
				If Not bFoundPromo Then
					Session("PROMOCODES") = Session("PROMOCODES") & "," & UCase(Trim(Request("PROMOCODE")))
				End If
			End If
		Else
			sPromoCodeError = "<b><i>Sorry, the promo code you entered is not valid.</i></b>"
		End If
	End If
	
	If nOrderID = 0 Then
		If Session("MODE") = "DELIVERY" Then
			nOrderID = CreateOrder(Session("STORE"), Session("CUSTOMERID"), 1, Session("DELIVERY"), Session("DRMONEY"), Session("FIRSTNAME") & " " & Session("LASTNAME"), Session("PHONE"), Session("ADDRESSID"), Session("SPECINST"))
		Else
			nOrderID = CreateOrder(Session("STORE"), Session("CUSTOMERID"), 2, 0.00, 0.00, Session("FIRSTNAME") & " " & Session("LASTNAME"), Session("PHONE"), Session("ADDRESSID"), Session("SPECINST"))
		End If
		
		Session("ORDERID") = nOrderID
	End If
	
	If nOrderID > 0 Then
		If Request.Form("ACTION") = "ADD" Then
			sDescription = ""
			If Len(Request.Form("SIZENAME")) > 0 Then
				sDescription = Request.Form("SIZENAME")
			End If
			If Len(Request.Form("CRUSTNAME")) > 0 Then
				sDescription = sDescription & " " & Request.Form("CRUSTNAME")
			End If
			If Len(Request.Form("SPECIALTY")) > 0 Then
				sDescription = sDescription & " " & GetSpecialtyName(Session("STORE"), Request.Form("UNITNUM"), Request.Form("SPECIALTY"))
			End If
			If Len(Request.Form("UNITNAME")) > 0 Then
				sDescription = sDescription & " " & Request.Form("UNITNAME")
			End If
			If Len(Request.Form("SAUCENAMEWHOLE")) > 0 Then
				sDescription = sDescription & " w/ " & Request.Form("SAUCENAMEWHOLE")
				If Len(Request.Form("SAUCEMODIERNAMEWHOLE")) > 0 Then
					sDescription = sDescription & " (" & Request.Form("SAUCEMODIFIERNAMEWHOLE") & ")"
				End If
			Else
				If Len(Request.Form("SAUCENAMEHALF1")) > 0 Then
					If Request.Form("SAUCENAMEHALF1") = Request.Form("SAUCENAMEHALF2") Then
						sDescription = sDescription & " w/ " & Request.Form("SAUCENAMEHALF1")
						If Len(Request.Form("SAUCEMODIFIERNAMEHALF1")) > 0 Or Len(Request.Form("SAUCEMODIFIERNAMEHALF2")) > 0 Then
							If Request.Form("SAUCEMODIFIERNAMEHALF1") = Request.Form("SAUCEMODIFIERNAMEHALF2") Then
								sDescription = sDescription & " (" & Request.Form("SAUCEMODIFIERNAMEHALF1") & ")"
							Else
								sDescription = sDescription & " ("
								If Len(Request.Form("SAUCEMODIFIERNAMEHALF1")) > 0 Then
									sDescription = sDescription & Request.Form("SAUCEMODIFIERNAMEHALF1") & " on first half"
									If Len(Request.Form("SAUCEMODIFIERNAMEHALF2")) > 0 Then
										sDescription = sDescription & " and "
									End If
								End If
								If Len(Request.Form("SAUCEMODIFIERNAMEHALF2")) > 0 Then
									sDescription = sDescription & Request.Form("SAUCEMODIFIERNAMEHALF2") & " on second half"
								End If
								sDescription = sDescription & ")"
							End If
						End If
					Else
						sDescription = sDescription & " w/ " & Request.Form("SAUCENAMEHALF1")
						If Len(Request.Form("SAUCEMODIFIERNAMEHALF1")) > 0 Then
							sDescription = sDescription & " (" & Request.Form("SAUCEMODIFIERNAMEHALF1") & ")"
						End If
						sDescription = sDescription & " on one half and " & Request.Form("SAUCENAMEHALF2")
						If Len(Request.Form("SAUCEMODIFIERNAMEHALF2")) > 0 Then
							sDescription = sDescription & " (" & Request.Form("SAUCEMODIFIERNAMEHALF2") & ")"
						End If
						sDescription = sDescription & " on other half"
					End If
				End If
			End If
			sDescription = sDescription & "<br/>"
			If Len(Request.Form("TOPWHOLENAME")) > 0 Then
				sDescription = sDescription & "Whole Toppings: " & Request.Form("TOPWHOLENAME")
				sDescription = sDescription & "<br/>"
			End If
			If Len(Request.Form("TOPHALF1NAME")) > 0 Then
				sDescription = sDescription & "1st Half Toppings: " & Request.Form("TOPHALF1NAME")
				sDescription = sDescription & "<br/>"
			End If
			If Len(Request.Form("TOPHALF2NAME")) > 0 Then
				sDescription = sDescription & "2nd Half Toppings: " & Request.Form("TOPHALF2NAME")
				sDescription = sDescription & "<br/>"
			End If
			If Len(Request.Form("CRUSTTOPNAME")) > 0 Then
				sDescription = sDescription & "Crust Toppers: " & Request.Form("CRUSTTOPNAME")
				sDescription = sDescription & "<br/>"
			End If
			If Len(Request.Form("INCLUDEDSIDENAME")) > 0 Then
				sDescription = sDescription & "Included Sides: " & Request.Form("INCLUDEDSIDENAME")
				sDescription = sDescription & "<br/>"
			End If
			If Len(Request.Form("ADDSIDENAME")) > 0 Then
				sDescription = sDescription & "Added Sides: " & Request.Form("ADDSIDENAME")
				sDescription = sDescription & "<br/>"
			End If
			If Len(Request.Form("QTY")) = 0 Then
				nQty = 1
			Else
				If Not IsNumeric(Request.Form("QTY")) Then
					nQty = 1
				Else
					nQty = CInt(Request.Form("QTY"))
				End If
			End If
			If Len(Request.Form("NOTES")) > 0 Then
				sDescription = sDescription & "Notes: " & Request.Form("NOTES")
				sDescription = sDescription & "<br/>"
			End If
			
'Response.Write("Order - " & nOrderID & "<br>Qty - " & nQty & "<br>Desc - " & sDescription & "<br>UNITNUM - " & Request.Form("UNITNUM") & "<br>SPECIALTY - " & Request.Form("SPECIALTY") & "<br>SIZE - " & Request.Form("SIZE") & "<br>CRUST - " & Request.Form("CRUST") & "<br>SAUCEWHOLE - " & Request.Form("SAUCEWHOLE") & "<br>SAUCEHALF1 - " & Request.Form("SAUCEHALF1") & "<br>SAUCEHALF2 - " & Request.Form("SAUCEHALF2") & "<br>SAUCEMODIFIERWHOLE - " & Request.Form("SAUCEMODIFIERWHOLE") & "<br>SAUCEMODIFIERHALF1 - " & Request.Form("SAUCEMODIFIERHALF1") & "<br>SAUCEMODIFIERHALF2 - " & Request.Form("SAUCEMODIFIERHALF2") & "<br>TOPWHOLE - " & Request.Form("TOPWHOLE") & "<br>TOOPHALF1 - " & Request.Form("TOPHALF1") & "<br>TOPHALF1 - " & Request.Form("TOPHALF2") & "<br>CRUSTTOP - " & Request.Form("CRUSTTOP") & "<br>INCLUDEDSIDE - " & Request.Form("INCLUDEDSIDE") & "<br>ADDSIDE - " & Request.Form("ADDSIDE") & "<br>NOTES - " & Request.Form("NOTES") & "<br>")
			If AddToOrder(nOrderID, nQty, sDescription, Request.Form("UNITNUM"), Request.Form("SPECIALTY"), Request.Form("SIZE"), Request.Form("CRUST"), Request.Form("SAUCEWHOLE"), Request.Form("SAUCEHALF1"), Request.Form("SAUCEHALF2"), Request.Form("SAUCEMODIFIERWHOLE"), Request.Form("SAUCEMODIFIERHALF1"), Request.Form("SAUCEMODIFIERHALF2"), Request.Form("TOPWHOLE"), Request.Form("TOPHALF1"), Request.Form("TOPHALF2"), Request.Form("CRUSTTOP"), Request.Form("INCLUDEDSIDE"), Request.Form("ADDSIDE"), Request.Form("NOTES")) Then
'				nOrderItems = Session("NUMITEMS") + 1
				nOrderItems = Session("NUMITEMS") + nQty
				Session("NUMITEMS") = nOrderItems
				
				If Not GetPricing(Session("STORE"), nOrderID, Session("PROMOCODES"), Session("PROMOS")) Then
					sError = "<strong>We apologize but our online ordering is temporarily unavailable (1). Please call our store at " & Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7) & " to complete your order.</strong>"
				End If
			Else
				sError = "<strong>We apologize but our online ordering is temporarily unavailable (2). Please call our store at " & Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7) & " to complete your order.</strong>"
			End If
		Else
			If Len(Request.Form("QTY")) = 0 Then
				nQty = 1
			Else
				If Not IsNumeric(Request.Form("QTY")) Then
					nQty = 1
				Else
					nQty = CInt(Request.Form("QTY"))
				End If
			End If
			
			sDescription = GetBeverageDescription(Session("STORE"), Request.Form("BEVERAGEID"))
			
			If AddBeverageToOrder(nOrderID, nQty, sDescription, Request.Form("BEVERAGEID")) Then
'				nOrderItems = Session("NUMITEMS") + 1
				nOrderItems = Session("NUMITEMS") + nQty
				Session("NUMITEMS") = nOrderItems
				
				If Not GetPricing(Session("STORE"), nOrderID, Session("PROMOCODES"), Session("PROMOS")) Then
					sError = "<strong>We apologize but our online ordering is temporarily unavailable (9). Please call our store at " & Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7) & " to complete your order.</strong>"
				End If
			Else
				sError = "<strong>We apologize but our online ordering is temporarily unavailable (10). Please call our store at " & Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7) & " to complete your order.</strong>"
			End If
		End If
	Else
		sError = "<strong>We apologize but our online ordering is temporarily unavailable (3). Please call our store at " & Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7) & " to complete your order.</strong>"
	End If
End If

dSubtotal = 0.00
dTotal = 0.00

nOrderID = Session("ORDERID")

If nOrderID <> 0 Then
	If GetOrder(nOrderID, dDelivery, dDrMoney, dTax, dTip) Then
		If GetOrderItems(nOrderID, anOrderItemID, anQty, asDescription, adPrice) Then
			For i = 0 To UBound(asDescription)
				dSubtotal = dSubtotal + adPrice(i)
			Next
			
			Session("GTOTAL") = dSubtotal
			Session("DELIVERY") = dDelivery
			Session("DRMONEY") = dDrMoney
			Session("TAX") = dTax
			
			dTotal = dSubtotal + dDelivery + dTax
		End If
	End If
End If

If Len(sError) > 0 Then
%>
						<strong><%=sError%></strong>
<%
Else
	If Request.Form("ACTION") <> "CHANGEINFO" And Session("STORE") <> 0 And Session("CUSTOMERID") > 1 Then
		nStore = Session("STORE")
%>
						<strong>Checkout</strong><br />&nbsp;<br />
<%
		If IsStoreActive(nStore) Then
			If ChecksOK(nStore) Then
				sCashCheck = "Cash / Check / Vito's Gift Card"
			Else
				sCashCheck = "Cash / Vito's Gift Card<br><b><i>Sorry - No Checks</i></b>"
			End If
%>
						<strong>Step 1: Verify your location.</strong><br />&nbsp;<br />
<%
			If GetStoreInfo(nStore, sName, sAddress1, sAddress2, sCity, sState, sZipCode, sPhone, sFax, sHours) Then
				sDisplayAddress = Session("ADDRESS")
				If Len(Session("APT")) > 0 Then
					sDisplayAddress = sDisplayAddress & " #" & Session("APT")
				End If
%>
						<table width="100%" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td valign="top">Your Location:</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">
<%
				If Session("MODE") = "DELIVERY" Then
%>
									Delivering From:
<%
				Else
%>
									Pick Up From:
<%
				End If
%>
								</td>
							</tr>
							<tr>
								<td valign="top" style="height: 64px"><%=Session("FIRSTNAME")%>&nbsp;<%=Session("LASTNAME")%><br>
								<%=sDisplayAddress%><br>
								<%=Session("CITY")%>, <%=Session("STATE")%>&nbsp;<%=Session("ZIPCODE")%>
<%
				If Len(Session("SPECINST")) > 0 Then
%>
								<br><b>Special Instructions:</b><br>
								<b><%=Session("SPECINST")%></b>
<%
				End If
%>
								</td>
								<td valign="top" style="height: 64px"></td>
								<td valign="top" style="height: 64px"><%=sAddress1%><br>
<%
				If Not IsEmpty(sAddress2) And Not IsNull(sAddress2) Then
%>
								<%=sAddress2%><br>
<%
				End If
%>
								<%=sCity%>,&nbsp;<%=sState%>&nbsp;<%=sZipCode%><br>
								<%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%>
								</td>
							</tr>
							<tr>
								<td valign="top">
									<form method="post" action="checkout.asp">
									<input type="hidden" name="ACTION" value="CHANGEINFO">
									<input name="submit" type="image" src="images/change.jpg" />
									</form>
								</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">
<%
				If Session("MODE") = "DELIVERY" Then
%>
									<a href="pickup.asp?ACTION=PICKUP"><img src="images/pickup.jpg" width="118" height="36" alt="Switch to Pickup" /></a>
<%
				Else
					sAddress = Session("ADDRESS")
					sApt = Session("APT")
					sCity = Session("CITY")
					sState = Session("STATE")
					sPostalCode = Session("ZIPCODE")
					
					nStore = LocateStoreByAddress(sPostalCode, sAddress, sApt, sCity, sState, nDelivery, nDrMoney)
					
					If nStore > 0 Then
%>
						<a href="deals.asp?ACTION=DELIVERY"><img src="images/delivery.jpg" width="124" height="35" alt="Switch to Delivery" /></a>
<%
					End If
				End If
%>
								</td>
							</tr>
						</table><br />&nbsp;<br />
<%
			End If
%>
						<form method="post" action="submit.asp" name="FORMPAYMENT" id="FORMPAYMENT">
						<input type="hidden" name="ACTION" value="PROCESS">
<%
			If dTotal = 0 Then
%>
						<input type="hidden" name="PAYMETHOD" value="CASH" />
<%
			End If
%>
						<table width="100%" cellspacing="5" cellpadding="0" align="center">
<%
			If dTotal > 0 Then
%>
							<tr>
								<td valign="middle"><strong>Payment Method:</strong></td>
								<td valign="top"><input name="PAYMETHOD" id="PAYMETHOD1" type="radio" value="CREDIT" checked onclick="togglePayment();">Credit Card</td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top">&nbsp;</td>
								<td valign="top"><input name="PAYMETHOD" id="PAYMETHOD2" type="radio" value="CASH" onclick="togglePayment();"><%=sCashCheck%></td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top">&nbsp;</td>
								<td valign="top" class="style1">&nbsp;</td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
<%
			End If
%>
							<tr>
								<td valign="top"><strong>Total</strong></td>
								<td valign="top" class="style1" id="TOTAL"><%=FormatCurrency(Session("GTOTAL"))%></td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top">
<%
			If Session("MODE") = "PICKUP" Then
%>
								<b>Pick Up</b>
<%
			Else
%>
								<b>Delivery</b>
<%
			End If
%>
								</td>
								<td valign="top" class="style1" id="DELIVERY"><%=FormatCurrency(Session("DELIVERY"))%></td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top"><strong>Tax</strong></td>
								<td valign="top" class="style1" id="TAX"><%=FormatCurrency(Session("TAX"))%></td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top">&nbsp;</td>
								<td valign="top" class="style1">&nbsp;</td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top"><strong>Grand Total</strong></td>
								<td valign="top" class="style1" id="GT"><%=FormatCurrency(Session("GTOTAL") + Session("DELIVERY") + Session("TAX"))%></td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top">&nbsp;</td>
								<td valign="top" class="style1">&nbsp;</td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
<%
			If dTotal = 0 Then
%>
							<tr>
								<td colspan="2" valign="top" class="banner"><span id="subtext">
								<strong>By clicking the submit button your order will be sent to our store and you will receive an order confirmation.</strong></span></td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
<%
			Else
%>
							<tr>
								<td colspan="2" valign="top" class="banner"><span id="subtext">
								<strong>All credit card orders are processed by our secure payment gateway.</strong></span></td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
<%
			End If
%>
							<tr>
								<td colspan="3" valign="top" class="banner"><strong>NOTE: Orders submitted will be processed immediately. If you are submitting an order for a future date or time please call the store at&nbsp;<%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%>.</strong></td>
							</tr>
							<tr>
								<td colspan="2" valign="top" class="banner"><input name="submit" type="image" src="images/submit.jpg" /></td>
								<td valign="top" width="10%">&nbsp;</td>
							</tr>
						</table>
						</form><br />&nbsp;<br />
<%
		Else
			If InStr(UCase(Request.ServerVariables("URL")), "ORDERTESTNEW") = 0 And InStr(UCase(Request.ServerVariables("SERVER_NAME")), "ARLGLOBAL.COM") = 0 Then
				If GetActivityOrderID(Session("ACTIVITYID")) <> -1 Then
					SendMail "vito@vitos.com", "4192975309@vtext.com, 4193203567@vtext.com, 4192606748@vtext.com, 4193672798@vtext.com", "", "", "Store Down", "Store " & nStore & " has not checked in.", FALSE
				End If
			End If
			
			' Log store's inactivity
			UpdateActivity Session("ACTIVITYID"), -1
			
			If GetStoreInfo(nStore, sName, sAddress1, sAddress2, sCity, sState, sZipCode, sPhone, sFax, sHours) Then
%>
						<b>We apologize but that store is currently unable 
						to accept online orders. Please call our store at <%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%> to 
						complete your order.</b><br />&nbsp;<br />
<%
			Else
%>
						<b>We apologize but that store is currently unable 
						to accept online orders. Please call our store to 
						complete your order.</b><br />&nbsp;<br />
<%
			End If
		End If
	Else
		Dim lsFirst, lsLast
		
		If Session("FIRSTNAME") = "Vito's" And Session("LASTNAME") = "Fan" Then
			lsFirst = ""
			lsLast = ""
		Else
			lsFirst = Session("FIRSTNAME")
			lsLast = Session("LASTNAME")
		End If
%>
						Please take a moment to carefully enter the 
						information below so we can process your order.<br />&nbsp;<br />
						* indicates a required field<br />&nbsp;<br />
						<form method="post" action="checkout.asp" name="FORMREGISTRATION" id="FORMREGISTRATION" onsubmit="return validateForm();">
						<input type="hidden" name="ACTION" value="REGISTER" />
						<table width="100%" cellspacing="5" cellpadding="0">
							<tr>
								<td width="150" align="right"><strong>* E-Mail Address:</strong></td>
								<td valign="top">
								<input type="text" name="EMAIL" id="EMAIL" style="width: 270px" value="<%=Session("EMAIL")%>" /></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* Confirm E-Mail Address:</strong></td>
								<td valign="top">
								<input type="text" name="EMAILCONFIRM" id="EMAILCONFIRM" style="width: 270px" /></td>
							</tr>
							<tr>
								<td align="center" colspan="2"><input type="checkbox" name="MAILLIST" id="MAILLIST" value="YES" checked />E-Mail me special offers from Vito&#39;s 
								Pizza</td>
							</tr>
							<tr>
								<td align="center" colspan="2"><input type="checkbox" name="SMSLIST" id="SMSLIST" value="YES" onclick="toggleTCPA();" />Text me (SMS) special offers from Vito&#39;s 
								Pizza</td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* Choose a Password:</strong></td>
								<td valign="top">
								<input type="password" name="PASSWORD" id="PASSWORD" style="width: 270px"></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* Confirm Password:</strong></td>
								<td valign="top">
								<input type="password" name="PASSWORDCONFIRM" id="PASSWORDCONFIRM" style="width: 270px" /></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* First Name:</strong></td>
								<td valign="top">
								<input type="text" name="FIRSTNAME" id="FIRSTNAME" style="width: 270px" value="<%=lsFirst%>" /></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* Last Name:</strong></td>
								<td valign="top">
								<input type="text" name="LASTNAME" id="LASTNAME" style="width: 270px" value="<%=lsLast%>" /></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* Address Name (e.g. Home):</strong></td>
								<td valign="top">
								<input type="text" name="ADDRESSNAME" id="ADDRESSNAME" style="width: 270px" value="<%=Session("ADDRESSNAME")%>" /></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* Address:</strong></td>
								<td valign="top">
								<input type="text" name="ADDRESS" id="ADDRESS" style="width: 270px" value="<%=Session("ADDRESS")%>" /></td>
							</tr>
							<tr>
								<td width="150" align="right" valign="top"><strong>Apt./Suite/Floor/Room:</strong></td>
								<td valign="top">
								<input type="text" name="APT" id="APT" style="width: 270px" value="<%=Session("APT")%>" /><br />
								<em>(Letters and Numbers Only, Please)</em></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* City:</strong></td>
								<td valign="top">
								<input type="text" name="CITY" id="CITY" style="width: 270px" value="<%=Session("CITY")%>" /></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* State:</strong></td>
								<td valign="top">
								<select name="STATE" id="STATE" size="1">
									<option VALUE="" <%If Session("STATE")="" or Session("STATE")="??" then Response.write "Selected"%>>Select a State</option>
									<option value="AK" <%If Session("STATE")="AK" then Response.write "Selected"%>>Alaska</option>
									<option value="AL" <%If Session("STATE")="AL" then Response.write "Selected"%>>Alabama</option>
									<option value="AZ" <%If Session("STATE")="AZ" then Response.write "Selected"%>>Arizona</option>
									<option value="AR" <%If Session("STATE")="AR" then Response.write "Selected"%>>Arkansas</option>
									<option value="AA" <%If Session("STATE")="AA" then Response.write "Selected"%>>Armed Forces Americas</option>
									<option value="AE" <%If Session("STATE")="AE" then Response.write "Selected"%>>Armed Forces (General)</option>
									<option value="AP" <%If Session("STATE")="AP" then Response.write "Selected"%>>Armed Forces Pacific</option>
									<option value="CA" <%If Session("STATE")="CA" then Response.write "Selected"%>>California</option>
									<option value="CO" <%If Session("STATE")="CO" then Response.write "Selected"%>>Colorado</option>
									<option value="CT" <%If Session("STATE")="CT" then Response.write "Selected"%>>Connecticut</option>
									<option value="DC" <%If Session("STATE")="DC" then Response.write "Selected"%>>District of Columbia</option>
									<option value="DE" <%If Session("STATE")="DE" then Response.write "Selected"%>>Delaware</option>
									<option value="FL" <%If Session("STATE")="FL" then Response.write "Selected"%>>Florida</option>
									<option value="GA" <%If Session("STATE")="GA" then Response.write "Selected"%>>Georgia</option>
									<option value="HI" <%If Session("STATE")="HI" then Response.write "Selected"%>>Hawaii</option>
									<option value="ID" <%If Session("STATE")="ID" then Response.write "Selected"%>>Idaho</option>
									<option value="IL" <%If Session("STATE")="IL" then Response.write "Selected"%>>Illinois</option>
									<option value="IN" <%If Session("STATE")="IN" then Response.write "Selected"%>>Indiana</option>
									<option value="IA" <%If Session("STATE")="IA" then Response.write "Selected"%>>Iowa</option>
									<option value="KS" <%If Session("STATE")="KS" then Response.write "Selected"%>>Kansas</option>
									<option value="KY" <%If Session("STATE")="KY" then Response.write "Selected"%>>Kentucky</option>
									<option value="LA" <%If Session("STATE")="LA" then Response.write "Selected"%>>Louisiana</option>
									<option value="ME" <%If Session("STATE")="ME" then Response.write "Selected"%>>Maine</option>
									<option value="MD" <%If Session("STATE")="MD" then Response.write "Selected"%>>Maryland</option>
									<option value="MA" <%If Session("STATE")="MA" then Response.write "Selected"%>>Massachusetts</option>
									<option value="MI" <%If Session("STATE")="MI" then Response.write "Selected"%>>Michigan</option>
									<option value="MN" <%If Session("STATE")="MN" then Response.write "Selected"%>>Minnesota</option>
									<option value="MS" <%If Session("STATE")="MS" then Response.write "Selected"%>>Mississippi</option>
									<option value="MO" <%If Session("STATE")="MO" then Response.write "Selected"%>>Missouri</option>
									<option value="MT" <%If Session("STATE")="MT" then Response.write "Selected"%>>Montana</option>
									<option value="NE" <%If Session("STATE")="NE" then Response.write "Selected"%>>Nebraska</option>
									<option value="NV" <%If Session("STATE")="NV" then Response.write "Selected"%>>Nevada</option>
									<option value="NH" <%If Session("STATE")="NH" then Response.write "Selected"%>>New Hampshire</option>
									<option value="NJ" <%If Session("STATE")="NJ" then Response.write "Selected"%>>New Jersey</option>
									<option value="NM" <%If Session("STATE")="NM" then Response.write "Selected"%>>New Mexico</option>
									<option value="NY" <%If Session("STATE")="NY" then Response.write "Selected"%>>New York</option>
									<option value="NC" <%If Session("STATE")="NC" then Response.write "Selected"%>>North Carolina</option>
									<option value="ND" <%If Session("STATE")="ND" then Response.write "Selected"%>>North Dakota</option>
									<option value="OH" <%If Session("STATE")="OH" then Response.write "Selected"%>>Ohio</option>
									<option value="OK" <%If Session("STATE")="OK" then Response.write "Selected"%>>Oklahoma</option>
									<option value="OR" <%If Session("STATE")="OR" then Response.write "Selected"%>>Oregon</option>
									<option value="PA" <%If Session("STATE")="PA" then Response.write "Selected"%>>Pennsylvania</option>
									<option value="RI" <%If Session("STATE")="RI" then Response.write "Selected"%>>Rhode Island</option>
									<option value="SC" <%If Session("STATE")="SC" then Response.write "Selected"%>>South Carolina</option>
									<option value="SD" <%If Session("STATE")="SD" then Response.write "Selected"%>>South Dakota</option>
									<option value="TN" <%If Session("STATE")="TN" then Response.write "Selected"%>>Tennessee</option>
									<option value="TX" <%If Session("STATE")="TX" then Response.write "Selected"%>>Texas</option>
									<option value="UT" <%If Session("STATE")="UT" then Response.write "Selected"%>>Utah</option>
									<option value="VT" <%If Session("STATE")="VT" then Response.write "Selected"%>>Vermont</option>
									<option value="VA" <%If Session("STATE")="VA" then Response.write "Selected"%>>Virginia</option>
									<option value="WA" <%If Session("STATE")="WA" then Response.write "Selected"%>>Washington</option>
									<option value="WV" <%If Session("STATE")="WV" then Response.write "Selected"%>>West Virginia</option>
									<option value="WI" <%If Session("STATE")="WI" then Response.write "Selected"%>>Wisconsin</option>
									<option value="WY" <%If Session("STATE")="WY" then Response.write "Selected"%>>Wyoming</option>
								</select>
								</td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* Zip Code:</strong></td>
								<td valign="top">
								<input type="text" name="ZIPCODE" id="ZIPCODE" style="width: 270px" value="<%=Session("ZIPCODE")%>" /></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>* Phone Number:</strong></td>
								<td valign="top">
								<input type="text" name="PHONE" id="PHONE" style="width: 270px" value="<%=Session("PHONE")%>" /></td>
							</tr>
							<tr>
								<td width="150" align="right"><strong>Birth Date:</strong></td>
								<td valign="top">
								<input type="text" name="DOB" id="DOB" style="width: 100px" value="<%=Session("DOB")%>" onblur="checkdate(this)" maxlength="11" /></td>
							</tr>
							<tr>
								<td width="150" align="right" valign="top"><strong>Special Delivery 
								Instructions:<br />
								(Limit 100 Characters)</strong></td>
								<td valign="top">
								<textarea name="SPECINST" id="SPECINST" onKeyDown="limitText(this.form.SPECINST,this.form.countdown,100);" onKeyUp="limitText(this.form.SPECINST,this.form.countdown,100);" style="width: 270px; height: 75px"><%=Session("SPECINST")%></textarea><br />
								<input readonly type="text" name="countdown" value="100" style="width:25px;" /> characters remaining.</td>
							</tr>
							<tr>
								<td width="150" align="right">&nbsp;</td>
								<td valign="top"><div id="TCPA" name="TCPA" style="visibility: hidden; height: 0px;">
									By checking the SMS box above I 
									hereby consent to receive autodialed and/or 
									pre-recorded telemarketing calls from or on 
									behalf of Vito's Pizza and Subs at the 
									telephone number provided above. I 
									understand that consent is not a condition 
									of purchase.</div><input name="submit" type="image" src="images/submit.jpg" /></td>
							</tr>
						</table>
						</form><br />&nbsp;<br />
<%
	End If
End If
%>
					</td>
				</tr>
			</table>
		</td>
		<td align="left" valign="top" background="images/template_31.jpg" width="351" height="246" colspan="10" rowspan="3">
			<table width="351" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td align="left" valign="top" background="images/template_24.jpg" width="26" height="86"></td>
					<td align="left" valign="top" background="images/template_25.jpg" width="268" height="86">
						<table width="268" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td colspan="3" valign="top" align="center"><img src="images/yourorder.jpg" width="154" height="36" /></td>
							</tr>
							<tr>
								<td colspan="3" valign="top">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3" valign="top">
<%
dSubtotal = 0.00
dTotal = 0.00

nOrderID = Session("ORDERID")

If Session("NUMITEMS") = 0 Then
%>
									<strong>Your cart is currently empty.</strong><br />
<%
			If Len(Session("PROMOS")) > 0 Or Len(Session("PROMOCODES")) > 0 Then
				naPromos = Split(Session("PROMOS"), ",")
				naPromoCodes = Split(Session("PROMOCODES"), ",")
%>
									&nbsp;<br/>
									<table width="268" cellpadding="0" cellspacing="2">
										<tr>
											<td valign="top" colspan="3">Selected Deals:</td>
										</tr>
<%
					If Len(Session("PROMOS")) > 0 Then
						For i = 0 To UBound(naPromos)
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xpromo=<%=naPromos(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2"><%=GetPromoName(Session("DMA"), naPromos(i))%></td>
										</tr>
<%
						Next
					End If
					If Len(Session("PROMOCODES")) > 0 Then
						For i = 0 To UBound(naPromoCodes)
							If naPromoCodes(i) = "FREESB" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad and Small Cheezy Breadsticks With Any Pizza</td>
										</tr>
<%
							Else
								If naPromoCodes(i) = "LETTER" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad and Small Cheezy Breadsticks With Any Pizza Or Sub</td>
										</tr>
<%
								Else
									If naPromoCodes(i) = "FREESB2" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad, Small Cheezy Breadsticks and 2 Liter With Any Pizza</td>
										</tr>
<%
									Else
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2"><%=GetPromoCodeName(Session("DMA"), naPromoCodes(i))%></td>
										</tr>
<%
									End If
								End If
							End If
						Next
					End If
%>
									</table>
<%
			End If
Else
	If GetOrder(nOrderID, dDelivery, dDrMoney, dTax, dTip) Then
		If GetOrderItems(nOrderID, anOrderItemID, anQty, asDescription, adPrice) Then
%>
									<table width="268" cellpadding="0" cellspacing="2">
<%
			For i = 0 To UBound(asDescription)
				dSubtotal = dSubtotal + adPrice(i)
%>
										<tr>
											<td valign="top" width="21">
												<form method="post" action="deals.asp">
													<input type="hidden" name="ACTION" value="REMOVE" />
													<input type="hidden" name="ORDERITEMID" value="<%=anOrderItemID(i)%>" />
													<input type="image" src="images/remove.jpg" alt="Remove" />
												</form>
											</td>
											<td valign="top"><%=asDescription(i)%></td>
											<td valign="top" align="right"><%=FormatCurrency(adPrice(i))%></td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top">&nbsp;</td>
											<td valign="top" align="right">&nbsp;</td>
										</tr>
<%
			Next
			
			If Len(Session("PROMOS")) > 0 Or Len(Session("PROMOCODES")) > 0 Then
				naPromos = Split(Session("PROMOS"), ",")
				naPromoCodes = Split(Session("PROMOCODES"), ",")
%>
										<tr>
											<td valign="top" colspan="3">Selected Deals:</td>
										</tr>
<%
					If Len(Session("PROMOS")) > 0 Then
						For i = 0 To UBound(naPromos)
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xpromo=<%=naPromos(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2"><%=GetPromoName(Session("DMA"), naPromos(i))%></td>
										</tr>
<%
						Next
					End If
					If Len(Session("PROMOCODES")) > 0 Then
						For i = 0 To UBound(naPromoCodes)
							If naPromoCodes(i) = "FREESB" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad and Small Cheezy Breadsticks With Any Pizza</td>
										</tr>
<%
							Else
								If naPromoCodes(i) = "LETTER" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad and Small Cheezy Breadsticks With Any Pizza Or Sub</td>
										</tr>
<%
								Else
									If naPromoCodes(i) = "FREESB2" Then
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2">Free Small Salad, Small Cheezy Breadsticks and 2 Liter With Any Pizza</td>
										</tr>
<%
									Else
%>
										<tr>
											<td valign="top" width="21"><a href="deals.asp?xcode=<%=naPromoCodes(i)%>"><img src="images/remove.jpg" width="21" height="21" border="0" alt="Remove" /></a></td>
											<td valign="top" colspan="2"><%=GetPromoCodeName(Session("DMA"), naPromoCodes(i))%></td>
										</tr>
<%
									End If
								End If
							End If
						Next
					End If
			End If
			
			Session("GTOTAL") = dSubtotal
			Session("DELIVERY") = dDelivery
			Session("DRMONEY") = dDrMoney
			Session("TAX") = dTax
			
			dTotal = dSubtotal + dDelivery + dTax
%>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top">&nbsp;</td>
											<td valign="top" align="right">&nbsp;</td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top" align="right">Subtotal:&nbsp;&nbsp;</td>
											<td valign="top" align="right"><%=FormatCurrency(dSubtotal)%></td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top">&nbsp;</td>
											<td valign="top" align="right">&nbsp;</td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top" align="right">Tax:&nbsp;&nbsp;</td>
											<td valign="top" align="right"><%=FormatCurrency(dTax)%></td>
										</tr>
<%
			If Session("MODE") = "DELIVERY" Then
%>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top">&nbsp;</td>
											<td valign="top" align="right">&nbsp;</td>
										</tr>
										<tr>
											<td valign="top" width="21">&nbsp;</td>
											<td valign="top" align="right">Delivery:&nbsp;&nbsp;</td>
											<td valign="top" align="right"><%=FormatCurrency(dDelivery)%></td>
										</tr>
<%
			End If
%>
									</table>
<%
		End If
	End If
End If
%>
								</td>
							</tr>
							<tr>
								<td colspan="3" valign="top">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3" valign="top" align="center"><img src="images/total.jpg" width="56" height="14" alt="Total" /></td>
							</tr>
							<tr>
								<td valign="top" width="50">&nbsp;</td>
								<td valign="top" align="center" width="168" style="border: 2px solid #000000; padding: 5px 0px 5px 0px;">
								<span class="total"><%=FormatCurrency(dTotal)%></span>
								</td>
								<td valign="top" width="50">&nbsp;</td>
							</tr>
						</table>
					</td>
					<td align="left" valign="top" background="images/template_26.jpg" width="11" height="86"></td>
					<td align="left" valign="top" background="images/template_27.jpg" width="46" height="86"></td>
				</tr>
				<tr>
					<td colspan="4" align="left" valign="top" background="images/template_29.jpg" width="351" height="20"></td>
				</tr>
				<tr>
					<td colspan="4" align="left" valign="top" background="images/template_31.jpg" width="351" height="140"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template_28.jpg" width="65" height="20"></td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template_30.jpg" width="65" height="140"></td>
	</tr>
	<tr>
		<td colspan="19" align="left" valign="top" background="images/template_32.jpg" width="850" height="87" class="copyright">
		&nbsp;<br />
		&nbsp;<br />
		&nbsp;<br />
		
		&copy; 2009-2011 Vito&#39;s Pizza Inc. All Rights Reserved</td>
	</tr>
	<tr>
		<td background="images/spacer.gif" width="1" height="1"></td>
		<td background="images/spacer.gif" width="65" height="1"></td>
		<td background="images/spacer.gif" width="193" height="1"></td>
		<td background="images/spacer.gif" width="53" height="1"></td>
		<td background="images/spacer.gif" width="12" height="1"></td>
		<td background="images/spacer.gif" width="49" height="1"></td>
		<td background="images/spacer.gif" width="15" height="1"></td>
		<td background="images/spacer.gif" width="74" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="25" height="1"></td>
		<td background="images/spacer.gif" width="26" height="1"></td>
		<td background="images/spacer.gif" width="36" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="89" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="41" height="1"></td>
		<td background="images/spacer.gif" width="14" height="1"></td>
		<td background="images/spacer.gif" width="62" height="1"></td>
		<td background="images/spacer.gif" width="11" height="1"></td>
		<td background="images/spacer.gif" width="46" height="1"></td>
	</tr>
</table>
</body>
</html>