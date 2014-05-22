<%
option explicit
Response.buffer = TRUE

If UCase(Request.ServerVariables("HTTPS")) <> "ON" Then
	Response.Redirect("https://www.vitos.com/orderdev/Default.asp")
End If
%>
<!-- #Include File="include/adovbs.asp" -->
<!-- #Include File="include/app-settings.asp" -->
<!-- #Include File="include/app-database.asp" -->
<!-- #Include File="include/app-ordering.asp" -->
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
		loObj.style.height = "65px";
	}
}
//-->
</script>
<script type="text/javascript" src="include/valid-date2.js"></script>
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table id="Table_01" width="851" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td rowspan="5" background="images/template2_01.jpg" width="1" height="400"></td>
		<td colspan="15" align="left" valign="top" background="images/template_02.jpg" width="804" height="133">
						<span class="total">TEST SYSTEM</span>
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
		<td align="left" valign="top" background="images/template_11.jpg" width="87" height="23">
		<img src="images/template_11.jpg" width="87" height="23" alt="Locations" /></td>
		<td align="left" valign="top" background="images/template_12.jpg" width="13" height="23"></td>
		<td align="left" valign="top" background="images/template_13.jpg" width="89" height="23">
		<img src="images/template_13.jpg" width="89" height="23" alt="Franchise" /></td>
		<td align="left" valign="top" background="images/template_14.jpg" width="13" height="23"></td>
		<td align="left" valign="top" background="images/template_15.jpg" width="41" height="23">
		<img src="images/template_15.jpg" width="41" height="23" alt="Jobs" /></td>
		<td align="left" valign="top" background="images/template_16.jpg" width="14" height="23"></td>
		<td align="left" valign="top" background="images/template_17.jpg" width="73" height="23">
		<img src="images/template_17.jpg" width="73" height="23" alt="Contact" /></td>
		<td align="left" valign="top" background="images/template_18.jpg" width="46" height="23"></td>
	</tr>
	<tr>
		<td colspan="16" align="left" valign="top" background="images/template2_19.jpg" width="850" height="88">
			<div align="right" style="margin-right:24px; margin-top:4px">
				<font color="#FFFF00" size="4">
					<marquee bgcolor="#FF0000" direction="left" loop="-1" width="575">
						<strong><%=GetMarqueeText()%></strong></marquee>
				</font>
			</div>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" background="images/template2_20.jpg" width="81" height="70"></td>
		<td colspan="13" align="left" valign="top" background="images/template2_21.jpg" width="650" height="70">
			<img alt="Registration" src="images/registration.jpg" width="282" height="35"><br>
<%
Dim sError, sZipCode, i, sPhone, sName, sAddress, sApt, sCity, sState, nDelivery, nDrMoney, nStore, sDisplayAddress, nMailList, nSMSList, nCustomerID
Dim sAddress1, sAddress2, sFax, sHours, sPostalCode
Dim nOrderID, nOrderItems, anOrderItemID(), anQty(), asDescription(), adPrice(), sDescription, nQty, sNotes, nAddressID
Dim dSubtotal, dTotal, dTax, dDelivery, dDrMoney, dTip
Dim saUnitName(), naUnitNum(), saUnitDesc(), saCustomDesc(), oFS, sFileName

sError = ""
nOrderID = Session("ORDERID")

If Request.Form("ACTION") = "REGISTER" Then
	' Strip all non-numeric from zip and phone
	sZipCode = ""
	For i = 1 to Len(Trim(Request("ZIPCODE")))
		If IsNumeric(Mid(Trim(Request("ZIPCODE")), i, 1)) Then
			sZipCode = sZipCode + Mid(Trim(Request("ZIPCODE")), i, 1)
		End If
	Next
	If Len(sZipCode) > 5 Then
		sZipCode = Left(sZipCode, 5)
	End If
	sPhone = ""
	For i = 1 to Len(Trim(Request("PHONE")))
		If IsNumeric(Mid(Trim(Request("PHONE")), i, 1)) Then
			sPhone = sPhone + Mid(Trim(Request("PHONE")), i, 1)
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
		If InStr(Request("APT"), "#") > 0 Then
			sAddress = Request("ADDRESS") + " " + Request("APT")
		Else
			sAddress = Request("ADDRESS") + " #" + Request("APT")
		End If
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
			
			If Session("ORDERID") > 0 Then
				If Not SetOrderAddress(Session("ORDERID"), nAddressID) Then
					sError = "Sorry we are currently unable to process your order online."
					nStore = 0
				End If
			End If
		Else
			Session("STATE") = sState
			Session("ZIPCODE") = sZipCode
			sError = "Sorry we are currently unable to process your order online."
			nStore = 0
		End If
	Else
		Session("STATE") = sState
		Session("ZIPCODE") = sZipCode
		sError = "Sorry we are currently unable to process your information online."
		nStore = 0
	End If
End If

If Len(sError) > 0 Then
%>
			<%=sError%><br>
			&nbsp;<br>
<%
Else
	If Request.Form("ACTION") = "REGISTER" Then
		If Session("MODE") = "DELIVERY" Then
			If nStore > 0 Then
				If Session("ORDERID") > 0 Then
					If SetOrderType(Session("ORDERID"), nStore, 1, nDelivery, nDrMoney) Then
						If CInt(Session("NUMITEMS")) > 0 Then
							GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
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
				
				Response.Redirect("deals.asp")
			Else
				Response.Redirect("pickup.asp?ACTION=PICKUP")
			End If
		Else
			If Session("ORDERID") > 0 Then
				If SetOrderType(Session("ORDERID"), nStore, 2, 0.00, 0.00) Then
					If CInt(Session("NUMITEMS")) > 0 Then
						GetPricing Session("STORE"), Session("ORDERID"), Session("PROMOCODES"), Session("PROMOS")
					End If
				Else
					Response.Redirect("Default.asp")
				End If
			End If
			
			Response.Redirect("deals.asp")
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
			Please take a moment to carefully enter the information below so we can 
			process your order.<br />
			* indicates a required field<br />
			&nbsp;<br />
			<form method="post" action="register.asp" name="FORMREGISTRATION" id="FORMREGISTRATION" onsubmit="return validateForm();">
				<input type="hidden" name="ACTION" value="REGISTER" />
				<table width="650" cellspacing="5" cellpadding="0">
					<tr>
						<td width="250" align="right"><strong>* E-Mail Address:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="EMAIL" id="EMAIL" style="width: 270px" value="<%=Session("EMAIL")%>" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* Confirm E-Mail Address:</strong></td>
						<td valign="top" width="400">
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
						<td width="250" align="right"><strong>* Choose a Password:</strong></td>
						<td valign="top" width="400">
						<input type="password" name="PASSWORD" id="PASSWORD" style="width: 270px" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* Confirm Password:</strong></td>
						<td valign="top" width="400">
						<input type="password" name="PASSWORDCONFIRM" id="PASSWORDCONFIRM" style="width: 270px" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* First Name:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="FIRSTNAME" id="FIRSTNAME" style="width: 270px" value="<%=lsFirst%>" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* Last Name:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="LASTNAME" id="LASTNAME" style="width: 270px" value="<%=lsLast%>" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* Address Name (e.g. Home):</strong></td>
						<td valign="top" width="400">
						<input type="text" name="ADDRESSNAME" id="ADDRESSNAME" style="width: 270px" value="<%=Session("ADDRESSNAME")%>" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* Address:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="ADDRESS" id="ADDRESS" style="width: 270px" value="<%=Session("ADDRESS")%>" /></td>
					</tr>
					<tr>
						<td width="250" align="right" valign="top"><strong>Apt./Suite/Floor/Room/Unit:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="APT" id="APT" style="width: 270px" value="<%=Session("APT")%>" /><br />
						<em>(Letters and Numbers Only, Please)</em></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* City:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="CITY" id="CITY" style="width: 270px" value="<%=Session("CITY")%>" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* State:</strong></td>
						<td valign="top" width="400">
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
						<td width="250" align="right"><strong>* Zip Code:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="ZIPCODE" id="ZIPCODE" style="width: 270px" value="<%=Session("ZIPCODE")%>" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>* Phone Number:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="PHONE" id="PHONE" style="width: 270px" value="<%=Session("PHONE")%>" /></td>
					</tr>
					<tr>
						<td width="250" align="right"><strong>Birth Date:</strong></td>
						<td valign="top" width="400">
						<input type="text" name="DOB" id="DOB" style="width: 100px" value="<%=Session("DOB")%>" onblur="checkdate(this)" maxlength="11" /></td>
					</tr>
					<tr>
						<td width="250" align="right" valign="top"><strong>Special Delivery 
						Instructions:<br />
						(Limit 100 Characters)</strong></td>
						<td valign="top" width="400">
						<textarea name="SPECINST" id="SPECINST" onKeyDown="limitText(this.form.SPECINST,this.form.countdown,100);" onKeyUp="limitText(this.form.SPECINST,this.form.countdown,100);" style="width: 300px; height: 75px"><%=Session("SPECINST")%></textarea><br />
						<input readonly type="text" name="countdown" value="100" style="width:25px;"> characters remaining.</td>
					</tr>
					<tr>
						<td width="250" align="right">&nbsp;</td>
						<td valign="top" width="400"><div id="TCPA" name="TCPA" style="visibility: hidden; height: 0px;">
							By checking the SMS box above I 
							hereby consent to receive autodialed and/or 
							pre-recorded telemarketing calls from or on 
							behalf of Vito's Pizza and Subs at the 
							telephone number provided above. I 
							understand that consent is not a condition 
							of purchase.</div><input name="submit" type="image" src="images/submit.jpg" /></td>
					</tr>
				</table>
			</form>
<%
	End If
End If
%>
		</td>
		<td colspan="2" align="left" valign="top" background="images/template2_22.jpg" width="119" height="70"></td>
	</tr>
	<tr>
		<td colspan="16" align="left" valign="top" background="images/template2_23.jpg" width="850" height="86" class="copyright">
		&nbsp;<br />
		&nbsp;<br />
		&nbsp;<br />
		
		&copy; 2009-2011 Vito&#39;s Pizza Inc. All Rights Reserved</td>
	</tr>
	<tr>
		<td background="images/spacer.gif" width="1" height="1"></td>
		<td background="images/spacer.gif" width="81" height="1"></td>
		<td background="images/spacer.gif" width="177" height="1"></td>
		<td background="images/spacer.gif" width="53" height="1"></td>
		<td background="images/spacer.gif" width="12" height="1"></td>
		<td background="images/spacer.gif" width="49" height="1"></td>
		<td background="images/spacer.gif" width="15" height="1"></td>
		<td background="images/spacer.gif" width="74" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="87" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="89" height="1"></td>
		<td background="images/spacer.gif" width="13" height="1"></td>
		<td background="images/spacer.gif" width="41" height="1"></td>
		<td background="images/spacer.gif" width="14" height="1"></td>
		<td background="images/spacer.gif" width="73" height="1"></td>
		<td background="images/spacer.gif" width="46" height="1"></td>
	</tr>
</table>
</body>
</html>
