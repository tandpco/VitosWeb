<%
option explicit
Response.buffer = TRUE

If UCase(Request.ServerVariables("HTTPS")) <> "ON" Then
	Response.Redirect("https://www.vitos.com/orderdev/Default.asp")
End If

If Request("RefID").Count > 0 Then
	Session("RefID") = Request("RefID")
End If

' Start everything anew.
Session.Abandon
%>
<!-- #Include File="include/adovbs.asp" -->
<!-- #Include File="include/app-settings.asp" -->
<!-- #Include File="include/app-database.asp" -->
<!-- #Include File="include/app-ordering.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META NAME="description" CONTENT="Place orders online for award winning Vito's Pizza and Subs, serving the Northwest Ohio area for nearly 20 years.">
<title>Welcome to Vito&#39;s Pizza Online Ordering</title>
<link rel="stylesheet" href="css/ordering2.css" type="text/css" />
<script type="text/javascript">
<!--
var ie4=document.all;

function validateLoginForm() {
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.EMAIL") : document.getElementById('EMAIL');
	if (tmpObj1.value == "") {
		alert("Email address is a required field.");
		return false;
	}
	
	tmpObj1 = ie4? eval("document.all.PASSWORD") : document.getElementById('PASSWORD');
	if (tmpObj1.value == "") {
		alert("Password is a required field.");
		return false;
	}
	
	return true;
}

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
<style type="text/css">
.auto-style1 {
	font-size: 12px;
	color: #FF0000;
}
.auto-style2 {
	color: #FF0000;
}
</style>
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
	If gb_SystemActive Then
%>
			<table width="650" cellpadding="0" cellspacing="0" border="0">
				<td valign="top" width="300">
					<form name="formLogin" id="formLogin" method="post" action="locator.asp" onsubmit="return validateLoginForm();">
						<input type="hidden" name="RefID" value="<%=Session("RefID")%>" />
						<input type="hidden" name="mode" value="login" />
<%
		If Request("pcode").Count > 0 Then
%>
						<input type="hidden" name="PROMOCODE" value="<%=Request("pcode")%>" />
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
		
		Dim sFormAction3
		
		If Right(LCase(Request.ServerVariables("SERVER_NAME")), 9) = "vitos.com" Then
			If InStr(UCase(Request.ServerVariables("URL")), "ORDERTESTNEW") = 0 Then
				sFormAction3 = "https://www.vitos.com/ordering"
			Else
				sFormAction3 = "https://www.vitos.com/ordertest"
			End If
		Else
			sFormAction3 = "http://www.arlglobal.com/ordering2"
		End If
		
		If Len(Request.QueryString) > 0 Then
			sFormAction3 = sFormAction3 & "/Default.asp?" & Request.QueryString
		End If
%>
						Login below if you are an existing customer.<br />
						<br />
						<span class="auto-style2"><strong>NOTE: This is the 
						ordering system for the stores listed below:<br><br>- 
						3392 Lagrange St.<br>- 
						315 S. Detroit Ave.<br>- 
						5145 Summit St. (Point Place)<br>- 
						2129 N. Reynolds Rd.<br>- 
						104 E. Union St. (Walbridge)<br>- 7321 Lewis Avenue (Bedford, 
						MI)<br>- 6533 E. State Blvd. (Ft. Wayne, IN)<br>
						- 226 N. Telegraph (Monroe, MI)<br>- 140 E. Wooster 
						(Bowling Green, OH)<br>
						<br>Please log in or register if you are a new customer.<br>
						<br>If your store is not listed above please <a href="<%=sFormAction3%>">CLICK HERE</a></strong></span>.<br>
						<br />
						Email Address:<br />
						<input name="EMAIL" id="EMAIL" type="text" style="width: 225px" /><br />
						<br />
						Password:<br />
						<input name="PASSWORD" id="PASSWORD" type="password" style="width: 225px" /><br />
						<br />
						<input name="submit" type="image" src="images/go.jpg" /><br />
						<br />
						<em><span class="auto-style1">Forgot your password? Simply enter your e-mail address, zip code, and address to the right and re-register as a new customer.
						</span></em>
					</form>
				</td>
				<td valign="top" width="50"></td>
				<td valign="top" width="300">
					<form name="formNewUser" id="formNewUser" method="post" action="locator.asp" onsubmit="return validateNewUserForm();">
						<input type="hidden" name="RefID" value="<%=Session("RefID")%>" />
<%
		If Request("pcode").Count > 0 Then
%>
						<input type="hidden" name="PROMOCODE" value="<%=Request("pcode")%>" />
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
						New customer? Enter your information below.<br />
						<br />
						Email Address:<br />
						<input name="EMAIL2" id="EMAIL2" type="text" style="width: 250px" /><br />
						<br />
						Zip Code:<br />
						<input name="ZIPCODE" id="ZIPCODE" type="text" style="width: 100px" onKeyDown="limitText(this.form.ZIPCODE,5);" onKeyUp="limitText(this.form.ZIPCODE,5);" /><br />
						<br />
						Street Number and Street Name:<br />
						<input name="ADDRESS" id="ADDRESS" type="text" style="width: 250px" /><br />
						<br />
						Apt./Suite/Floor/Room/Unit:<br>
						<em>(Letters and Numbers Only, Please)</em><br />
						<input name="APT" id="APT" type="text" style="width: 250px" /><br />
						<br />
						<input name="submit" type="image" src="images/go.jpg" />
					</form>
				</td>
			</table>
<%
	Else
%>
			<span class="error">We apologize but our online ordering is currently undergoing maintenance.<br>
Please check back in a few moments.</span>
<%
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
