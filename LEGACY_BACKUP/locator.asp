<%
option explicit
Response.buffer = TRUE

If UCase(Request.ServerVariables("HTTPS")) <> "ON" Then
	Response.Redirect("https://www.vitos.com/orderdev/Default.asp")
End If

If Request("EMAIL").Count = 0 And Request("EMAIL2").Count = 0 Then
	Response.Redirect("Default.asp")
End If

If Request("EMAIL").Count > 0 Then
	If Len(Trim(Request("EMAIL"))) = 0 Or Len(Trim(Request("PASSWORD"))) = 0 Then
		Response.Redirect("Default.asp")
	End If
End If

If Request("EMAIL2").Count > 0 Then
	If Len(Trim(Request("EMAIL2"))) = 0 Or Len(Trim(Request("ZIPCODE"))) = 0 Or Len(Trim(Request("ADDRESS"))) = 0 Then
		Response.Redirect("Default.asp")
	End If
End If

If Request("RefID").Count = 1 Then
	Session("RefID") = Left(Request("RefID"), 15)
End If
%>
<!-- #Include File="include/adovbs.asp" -->
<!-- #Include File="include/app-settings.asp" -->
<!-- #Include File="include/app-database.asp" -->
<!-- #Include File="include/app-ordering.asp" -->
<!-- #Include File="include/md5.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Welcome to Vito&#39;s Pizza Online Ordering</title>
<link rel="stylesheet" href="css/ordering2.css" type="text/css" />
<script type="text/javascript">
<!--
function validateNewUserForm() {
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.EMAIL2") : document.getElementById('EMAIL2');
	if (tmpObj1.value == "") {
		alert("Email address is a required field.");
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.ADDRESS") : document.getElementById('ADDRESS');
	if (tmpObj1.value == "") {
		alert("Street address is a required field.");
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.ZIPCODE") : document.getElementById('ZIPCODE');
	if (tmpObj1.value == "") {
		alert("Zip code is a required field.");
		return false;
	}
	
	return true;
}

function limitText(limitField, limitNum) {
	if (limitField.value.length > limitNum) {
		limitField.value = limitField.value.substring(0, limitNum);
	}
}
//-->
</script>
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
<%
Dim sAddress, sDisplayAddress, sApt, nStore, aStore(), aName(), aAddress(), aAddress2(), aCity(), aState(), aPostalCode(), aPhone(), aFax(), aHours(), i
Dim aRemain, sName, nAddressID, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours, nDelivery, nDrMoney

Dim sError, nCustomerID, sFirstName, sLastName, sCustZip, sSpecInst, sDOB, sAddressName

Session("ORDERID") = 0
Session("NUMITEMS") = 0
Session("PROMOS") = ""
Session("PROMOCODES") = ""

nStore = 0

If Request("mode").count > 0 Then
	If ValidateCustomer(Request("EMAIL"), Request("PASSWORD"), nCustomerID, sFirstName, sLastName, nAddressID, sAddressName, sAddress, sApt, sCity, sState, sPostalCode, sPhone, sDOB, sSpecInst) Then
		Session("EMAIL") = Request("EMAIL")
		Session("FIRSTNAME") = sFirstName
		Session("LASTNAME") = sLastName
		Session("PHONE") = sPhone
		Session("CUSTOMERID") = nCustomerID
		Session("ADDRESSID") = nAddressID
		Session("ADDRESSNAME") = sAddressName
		If Len(sApt) > 0 Then
			sAddress = sAddress & " #" & sApt
			sApt = ""
		End If
		Session("DOB") = sDOB
		Session("SPECINST") = sSpecInst
		nStore = LocateStoreByAddress(sPostalCode, sAddress, sApt, sCity, sState, nDelivery, nDrMoney)
		
		Session("ACTIVITYID") = LogActivity(Session("EMAIL"), sAddress, sApt, sCity, sState, sPostalCode, nStore)
	Else
		Session("ACTIVITYID") = LogActivity(Request("EMAIL"), "", "", "", "", "", 0)
	End If
Else
	' Strip all non-numeric from zip and phone
	sPostalCode = ""
	For i = 1 to Len(Trim(Request("ZIPCODE")))
		If IsNumeric(Mid(Trim(Request("ZIPCODE")), i, 1)) Then
			sPostalCode = sPostalCode + Mid(Trim(Request("ZIPCODE")), i, 1)
		End If
	Next
	If Len(sPostalCode) > 5 Then
		sPostalCode = Left(sPostalCode, 5)
	End If
	
	sAddress = Request("ADDRESS")
	If Len(Request("APT")) > 0 Then
'		If InStr(Request("APT"), "#") > 0 Then
'			sAddress = sAddress & " " & Request("APT")
'		Else
'			sAddress = sAddress & " #" & Request("APT")
'		End If
		' Strip down to just number
		aRemain = Split(UCase(Request("APT")))
		For i = 0 to UBound(aRemain)
			If Not (aRemain(i) = "APT" Or aRemain(i) = "APT." Or aRemain(i) = "APARTMENT" Or aRemain(i) = "APART" Or aRemain(i) = "APART." Or aRemain(i) = "#" Or aRemain(i) = "STE" Or aRemain(i) = "STE." Or aRemain(i) = "SUITE" Or aRemain(i) = "BLDG" Or aRemain(i) = "BLDG." Or aRemain(i) = "BUILDING" Or aRemain(i) = "LOT" Or aRemain(i) = "FLR" Or aRemain(i) = "FLR." Or aRemain(i) = "FLOOR" Or aRemain(i) = "UNIT") Then
				If Left(aRemain(i), 1) = "#" Then
					sAddress = sAddress & " #" & Mid(aRemain(i), 2)
				Else
					sAddress = sAddress & " #" & aRemain(i)
				End If
				Exit For
			End If
		Next
	End If
	nStore = LocateStoreByAddress(sPostalCode, sAddress, sApt, sCity, sState, nDelivery, nDrMoney)
	
	Session("EMAIL") = Request("EMAIL2")
	Session("FIRSTNAME") = "Vito's"
	Session("LASTNAME") = "Fan"
	Session("PHONE") = ""
	Session("CUSTOMERID") = 1
	Session("SPECINST") = ""
	
	nAddressID = GetAddressID(sPostalCode, sAddress, sApt, sCity, sState)
	If nAddressID = 0 Then
		nAddressID = AddAddress(nStore, sAddress, sApt, sCity, sState, sPostalCode)
	End If
	
	Session("ADDRESSID") = nAddressID
	
	Session("ACTIVITYID") = LogActivity(Session("EMAIL"), sAddress, sApt, sCity, sState, sPostalCode, nStore)
End If

sDisplayAddress = UCase(sAddress)
If Len(sApt) > 0 Then
	sDisplayAddress = sDisplayAddress & " #" & sApt
End If

Session("ADDRESS") = sAddress
Session("APT") = sApt
Session("CITY") = sCity
Session("STATE") = sState
Session("ZIPCODE") = sPostalCode
Session("DMA") = 1

If nStore > 0 Then
	Session("STORE") = nStore
	Session("MODE") = "DELIVERY"
	Session("DELIVERY") = CDbl(nDelivery)
	Session("DRMONEY") = CDbl(nDrMoney)
	
	If GetStoreInfo(nStore, sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours) Then
%>
			<img alt="Location" src="images/location.jpg" width="204" height="28"><br>
			The following store services <%=sDisplayAddress%>,&nbsp;<%=Session("CITY")%>,&nbsp;<%=Session("STATE")%>&nbsp;<%=Session("ZIPCODE")%>:<br>&nbsp;<br>
			<%=sName%><br>
			<%=sAddress1%><br>
<%
		If Not IsEmpty(sAddress2) And Not IsNull(sAddress2) Then
%>
			<%=sAddress2%><br>
<%
		End If
%>
			<%=sCity%>,&nbsp;<%=sState%>&nbsp;<%=sPostalCode%><br>
			<%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%><br>
<%
		If Not IsEmpty(sFax) And Not IsNull(sFax) Then
%>
			<%=sFax%><br>
<%
		End If
%>
			Hours: <%=sHours%><br>&nbsp;<br>
<%
		If nStore < 17 And nStore > 2 And nStore <> 5 And nStore <> 15 And nStore <> 13 Then
			Dim sFormAction3
			
			If Right(LCase(Request.ServerVariables("SERVER_NAME")), 9) = "vitos.com" Then
				If InStr(UCase(Request.ServerVariables("URL")), "ORDERTESTNEW") = 0 Then
					sFormAction3 = "https://www.vitos.com/ordering/deals.asp"
				Else
					sFormAction3 = "https://www.vitos.com/ordertest/deals.asp"
				End If
			Else
				sFormAction3 = "http://www.arlglobal.com/ordering2/deals.asp"
			End If
%>
			<form method="post" action="<%=sFormAction3%>">
				<input type="hidden" name="SWITCHSYS" value="YES" />
				<input type="hidden" name="SWITCHSYS-RefID" value="<%=SESSION("RefID")%>" />
				<input type="hidden" name="SWITCHSYS-EMAIL" value="<%=SESSION("EMAIL")%>" />
				<input type="hidden" name="SWITCHSYS-ADDRESS" value="<%=SESSION("ADDRESS")%>" />
				<input type="hidden" name="SWITCHSYS-APT" value="<%=SESSION("APT")%>" />
				<input type="hidden" name="SWITCHSYS-ZIPCODE" value="<%=SESSION("ZIPCODE")%>" />
				<input type="hidden" name="ACTION" value="DELIVERY" />
				<input type="hidden" name="STORE" value="<%=nStore%>" />
<%
			If Request("PROMOCODE").Count > 0 Then
%>
				<input type="hidden" name="PROMOCODE" value="<%=Request("PROMOCODE")%>" />
<%
			End If
%>
				<input name="submit" type="image" src="images/go.jpg" />
			</form>
<%
		Else
			If Request("PROMOCODE").Count > 0 Then
%>
			<a href="deals.asp?ACTION=PROMOCODE&PROMOCODE=<%=Request("PROMOCODE")%>"><img src="images/go.jpg" width="106" height="42"></a><br>
<%
			Else
				If Request("uid").Count > 0 Then
					If Request("spec").Count > 0 Then
%>
			<a href="customize.asp?uid=<%=Request("uid")%>&spec=<%=Server.URLEncode(Request("spec"))%>"><img src="images/go.jpg" width="106" height="42"></a><br>
<%
					Else
%>
			<a href="customize.asp?uid=<%=Request("uid")%>"><img src="images/go.jpg" width="106" height="42"></a><br>
<%
					End If
				Else
%>
			<a href="deals.asp"><img src="images/go.jpg" width="106" height="42"></a><br>
<%
				End If
			End If
		End If
	Else
		If InStr(UCase(Request.ServerVariables("URL")), "ORDERTESTNEW") = 0 And InStr(UCase(Request.ServerVariables("SERVER_NAME")), "ARLGLOBAL.COM") = 0 Then
			SendMail "4193924776@vtext.com", "", "", "Vito Ordering", "Ordering system could not retrieve store information.", FALSE
		End If
%>
			<span class="error">An error occured retieving store information.</span>
<%
	End If
Else
	If Request("mode").count > 0 And Len(Session("CUSTOMERID")) = 0 Then
%>
			<span class="error">Invalid e-mail address or password.</span><br>
			<a href="Default.asp">Click here to try again.</a><br>
<%
	Else
		If LocateStoresByPostalCode(Session("ZIPCODE"), aStore, aName, aAddress, aAddress2, aCity, aState, aPostalCode, aPhone, aFax, aHours) Then
			Session("MODE") = "PICKUP"
			Session("DELIVERY") = CDbl(0.00)
			Session("DRMONEY") = CDbl(0.00)
%>
			Either we could not determine your exact address or there are no stores that deliver to <%=sDisplayAddress%> in the <%=Session("ZIPCODE")%> zip code.
			Please verify your address and zip code paying attention to such things as 
			&quot;Road&quot;, &quot;Street&quot;, etc., as well as directions such as &quot;North&quot;, &quot;South&quot;, etc.<br />&nbsp;<br />
			<form name="formNewUser" id="formNewUser" method="post" action="locator.asp" onsubmit="return validateNewUserForm();">
				Email Address:<br />
				<input name="EMAIL2" id="EMAIL2" type="text" style="width: 250px" value="<%=Request("EMAIL2")%>" /><br />
				<br />
				Zip Code:<br />
				<input name="ZIPCODE" id="ZIPCODE" type="text" style="width: 100px" value="<%=Request("ZIPCODE")%>" onKeyDown="limitText(this.form.ZIPCODE,5);" onKeyUp="limitText(this.form.ZIPCODE,5);" /><br />
				<br />
				Street Number and Street Name:<br />
				<input name="ADDRESS" id="ADDRESS" type="text" style="width: 250px" value="<%=Request("ADDRESS")%>" /><br />
				<br />
				Apt./Suite/Floor/Room/Unit:<br />
				<input name="APT" id="APT" type="text" style="width: 250px" value="<%=Request("APT")%>" /><br />
				<br />
				<input name="submit" type="image" src="images/go.jpg" />
			</form>
			&nbsp;<br />
			Or please select one of our restaurants for pickup service:<br>&nbsp;<br>
<%
			Dim sFormAction, sFormAction2
			
			If Request("PROMOCODE").Count > 0 Then
				sFormAction = "deals.asp"
			Else
				If Request("uid").Count > 0 Then
					sFormAction = "customize.asp"
				Else
					sFormAction = "deals.asp"
				End If
			End If
			
			For i = 1 To UBound(aName)
				If CLng(aStore(i)) < 17 And CLng(aStore(i)) > 2 And CLng(aStore(i)) <> 5 And CLng(aStore(i)) <> 15 And CLng(aStore(i)) <> 13 Then
					If Right(LCase(Request.ServerVariables("SERVER_NAME")), 9) = "vitos.com" Then
						If InStr(UCase(Request.ServerVariables("URL")), "ORDERTESTNEW") = 0 Then
							sFormAction2 = "https://www.vitos.com/ordering/deals.asp"
						Else
							sFormAction2 = "https://www.vitos.com/ordertest/deals.asp"
						End If
					Else
						sFormAction2 = "http://www.arlglobal.com/ordering2/deals.asp"
					End If
%>
			<form method="post" action="<%=sFormAction2%>">
				<input type="hidden" name="SWITCHSYS" value="YES" />
				<input type="hidden" name="SWITCHSYS-RefID" value="<%=SESSION("RefID")%>" />
				<input type="hidden" name="SWITCHSYS-EMAIL" value="<%=SESSION("EMAIL")%>" />
				<input type="hidden" name="SWITCHSYS-ADDRESS" value="<%=SESSION("ADDRESS")%>" />
				<input type="hidden" name="SWITCHSYS-APT" value="<%=SESSION("APT")%>" />
				<input type="hidden" name="SWITCHSYS-ZIPCODE" value="<%=SESSION("ZIPCODE")%>" />
				<input type="hidden" name="ACTION" value="PICKUP" />
				<input type="hidden" name="STORE" value="<%=aStore(i)%>" />
<%
					If Request("PROMOCODE").Count > 0 Then
%>
				<input type="hidden" name="PROMOCODE" value="<%=Request("PROMOCODE")%>" />
<%
					End If
%>
				<%=aName(i)%><br>
				<%=aAddress(i)%><br>
<%
					If Not IsEmpty(aAddress2(i)) And Not IsNull(aAddress2(i)) Then
%>
				<%=aAddress2(i)%><br>
<%
					End If
%>
				<%=aCity(i)%>,&nbsp;<%=aState(i)%>&nbsp;<%=aPostalCode(i)%><br>
				<%=Left(aPhone(i), 3) & "-" & Mid(aPhone(i), 4, 3) & "-" & Mid(aPhone(i), 7)%><br>
<%
					If Not IsEmpty(aFax(i)) And Not IsNull(aFax(i)) Then
%>
				<%=aFax(i)%><br>
<%
					End If
%>
				Hours: <%=aHours(i)%><br>
				<input name="submit" type="image" src="images/go.jpg" />
			</form>
			&nbsp;<br>
<%
				Else
%>
			<form method="post" action="<%=sFormAction%>">
				<input type="hidden" name="ACTION" value="PICKUP">
				<input type="hidden" name="STORE" value="<%=aStore(i)%>">
<%
					If Request("PROMOCODE").Count > 0 Then
%>
				<input type="hidden" name="PROMOCODE" value="<%=Request("PROMOCODE")%>" />
<%
					Else
						If Request("uid").Count > 0 Then
%>
				<input type="hidden" name="uid" value="<%=Request("uid")%>" />
<%
							If Request("spec").Count > 0 Then
%>
				<input type="hidden" name="spec" value="<%=Request("spec")%>" />
<%
							End If
						End If
					End If
%>
				<%=aName(i)%><br>
				<%=aAddress(i)%><br>
<%
					If Not IsEmpty(aAddress2(i)) And Not IsNull(aAddress2(i)) Then
%>
				<%=aAddress2(i)%><br>
<%
					End If
%>
				<%=aCity(i)%>,&nbsp;<%=aState(i)%>&nbsp;<%=aPostalCode(i)%><br>
				<%=Left(aPhone(i), 3) & "-" & Mid(aPhone(i), 4, 3) & "-" & Mid(aPhone(i), 7)%><br>
<%
					If Not IsEmpty(aFax(i)) And Not IsNull(aFax(i)) Then
%>
				<%=aFax(i)%><br>
<%
					End If
%>
				Hours: <%=aHours(i)%><br>
				<input name="submit" type="image" src="images/go.jpg" />
			</form>
			&nbsp;<br>
<%
				End If
			Next
		Else
			If UCase(Left(gs_ErrorMsg, 15)) = "TIMEOUT EXPIRED" Then
				If InStr(UCase(Request.ServerVariables("URL")), "ORDERTESTNEW") = 0 And InStr(UCase(Request.ServerVariables("SERVER_NAME")), "ARLGLOBAL.COM") = 0 Then
					SendMail "4193924776@vtext.com", "", "", "Vito Ordering", "Ordering System SQL Timeout", FALSE
				End If
%>
			Sorry, our ordering system is currently unavailable. Please try again shortly.<br>
<%
			Else
%>
			Sorry, no stores were found in your area.<br>
<%
			End If
		End If
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
