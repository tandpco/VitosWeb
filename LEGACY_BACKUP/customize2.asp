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
<!-- #Include File="include/fsovbs.asp" -->
<!-- #Include File="include/imgsz.asp" -->
<%
If Len(Session("ADDRESS")) = 0 Or Len(Session("ZIPCODE")) = 0 Or Len(Session("STORE")) = 0 Then
	Response.Redirect("Default.asp")
End If

If Not IsStoreEnabled(Session("STORE")) Then
	Response.Redirect("maintenance.asp")
End If

If Request("uid").Count = 0 And Request("pid").Count = 0 And Request("SIZE").Count = 0 Then
	Response.Redirect("deals.asp")
End If

If Not IsNumeric(Request("uid")) Then
	Response.Redirect("deals.asp")
End If

If Request("pid").Count <> 0 And Not IsNumeric(Request("pid")) Then
	Response.Redirect("deals.asp")
End If

If Not IsNumeric(Request("SIZE")) Then
	Response.Redirect("deals.asp")
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

function SetCrust()
{
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.CRUSTNAME") : document.getElementById('CRUSTNAME');
	tmpObj2 = ie4? eval("document.all.CRUST") : document.getElementById('CRUST');
	
	tmpObj1.value = tmpObj2.options[tmpObj2.selectedIndex].text;
}

function AddTopper()
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3, tmpObj4;
	
	tmpObj1 = ie4? eval("document.all.topperlist") : document.getElementById('topperlist');
	tmpObj2 = ie4? eval("document.all.CRUSTTOP") : document.getElementById('CRUSTTOP');
	tmpObj3 = ie4? eval("document.all.TOPPER") : document.getElementById('TOPPER');
	tmpObj4 = ie4? eval("document.all.CRUSTTOPNAME") : document.getElementById('CRUSTTOPNAME');
	
	if (tmpObj3.selectedIndex > 0) {
		curContent = new String(tmpObj1.innerHTML);
		curList = new String(tmpObj2.value);
		
		if (curContent.length == 0) {
			nEntries = 0;
		}
		else {
			var curSplit = curContent.split(", ");
			nEntries = curSplit.length;
		}
		
		if (curContent.length == 0) {
			tmpObj1.innerHTML = "<a href=\"javascript:RemoveTopper(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		else {
			tmpObj1.innerHTML = tmpObj1.innerHTML + ", <a href=\"javascript:RemoveTopper(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj4.value + ", " + tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		
		if (curList.length == 0)
			tmpObj2.value = tmpObj3.value;
		else
			tmpObj2.value = tmpObj2.value + ',' + tmpObj3.value;
		
		tmpObj3.selectedIndex = 0;
	}
}

function RemoveTopper(pnPos)
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3;
	
	tmpObj1 = ie4? eval("document.all.CRUSTTOPNAME") : document.getElementById('CRUSTTOPNAME');
	tmpObj2 = ie4? eval("document.all.CRUSTTOP") : document.getElementById('CRUSTTOP');
	tmpObj3 = ie4? eval("document.all.topperlist") : document.getElementById('topperlist');
	
	curContent = new String(tmpObj1.value);
	curList = new String(tmpObj2.value);

	var curSplitContent = curContent.split(", ");
	var newList = new String("");
	var newList2 = new String("");
	
	nEntries = 0;
	
	for (var i = 0; i < curSplitContent.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = "<a href=\"javascript:RemoveTopper(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = curSplitContent[i];
			}
			else {
				newList = newList + ", <a href=\"javascript:RemoveTopper(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = newList2 + ", " + curSplitContent[i];
			}
			
			nEntries++;
		}
	}
	
	tmpObj3.innerHTML = newList;
	tmpObj1.value = newList2;
	
	var curSplitList = curList.split(",");
	var newList = new String("");
	var newList2 = new String("");
	
	for (var i = 0; i < curSplitList.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = curSplitList[i];
			}
			else {
				newList = newList + "," + curSplitList[i];
			}
		}
	}
	
	tmpObj2.value = newList;
}

function SetSauceWhole()
{
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.SAUCENAMEWHOLE") : document.getElementById('SAUCENAMEWHOLE');
	tmpObj2 = ie4? eval("document.all.SAUCEWHOLE") : document.getElementById('SAUCEWHOLE');
	
	tmpObj1.value = tmpObj2.options[tmpObj2.selectedIndex].text;
}

function SetSauceHalf1()
{
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.SAUCENAMEHALF1") : document.getElementById('SAUCENAMEHALF1');
	tmpObj2 = ie4? eval("document.all.SAUCEHALF1") : document.getElementById('SAUCEHALF1');
	
	tmpObj1.value = tmpObj2.options[tmpObj2.selectedIndex].text;
}

function SetSauceHalf2()
{
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.SAUCENAMEHALF2") : document.getElementById('SAUCENAMEHALF2');
	tmpObj2 = ie4? eval("document.all.SAUCEHALF2") : document.getElementById('SAUCEHALF2');
	
	tmpObj1.value = tmpObj2.options[tmpObj2.selectedIndex].text;
}

function SetSauceModifierWhole()
{
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.SAUCEMODIFIERNAMEWHOLE") : document.getElementById('SAUCEMODIFIERNAMEWHOLE');
	tmpObj2 = ie4? eval("document.all.SAUCEMODIFIERWHOLE") : document.getElementById('SAUCEMODIFIERWHOLE');
	
	tmpObj1.value = tmpObj2.options[tmpObj2.selectedIndex].text;
}

function SetSauceModifierHalf1()
{
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.SAUCEMODIFIERNAMEHALF1") : document.getElementById('SAUCEMODIFIERNAMEHALF1');
	tmpObj2 = ie4? eval("document.all.SAUCEMODIFIERHALF1") : document.getElementById('SAUCEMODIFIERHALF1');
	
	tmpObj1.value = tmpObj2.options[tmpObj2.selectedIndex].text;
}

function SetSauceModifierHalf2()
{
	var tmpObj1, tmpObj2;
	
	tmpObj1 = ie4? eval("document.all.SAUCEMODIFIERNAMEHALF2") : document.getElementById('SAUCEMODIFIERNAMEHALF2');
	tmpObj2 = ie4? eval("document.all.SAUCEMODIFIERHALF2") : document.getElementById('SAUCEMODIFIERHALF2');
	
	tmpObj1.value = tmpObj2.options[tmpObj2.selectedIndex].text;
}

function WholeTopping()
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3, tmpObj4;
	
	tmpObj1 = ie4? eval("document.all.wholelist") : document.getElementById('wholelist');
	tmpObj2 = ie4? eval("document.all.TOPWHOLE") : document.getElementById('TOPWHOLE');
	tmpObj3 = ie4? eval("document.all.WHOLE") : document.getElementById('WHOLE');
	tmpObj4 = ie4? eval("document.all.TOPWHOLENAME") : document.getElementById('TOPWHOLENAME');
	
	if (tmpObj3.selectedIndex > 0) {
		curContent = new String(tmpObj1.innerHTML);
		curList = new String(tmpObj2.value);
		
		if (curContent.length == 0) {
			nEntries = 0;
		}
		else {
			var curSplit = curContent.split(", ");
			nEntries = curSplit.length;
		}
		
		if (curContent.length == 0) {
			tmpObj1.innerHTML = "<a href=\"javascript:RemoveWholeTopping(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		else {
			tmpObj1.innerHTML = tmpObj1.innerHTML + ", <a href=\"javascript:RemoveWholeTopping(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj4.value + ", " + tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		
		if (curList.length == 0)
			tmpObj2.value = tmpObj3.value;
		else
			tmpObj2.value = tmpObj2.value + ',' + tmpObj3.value;
		
		tmpObj3.selectedIndex = 0;
	}
}

function RemoveWholeTopping(pnPos)
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3;
	
	tmpObj1 = ie4? eval("document.all.TOPWHOLENAME") : document.getElementById('TOPWHOLENAME');
	tmpObj2 = ie4? eval("document.all.TOPWHOLE") : document.getElementById('TOPWHOLE');
	tmpObj3 = ie4? eval("document.all.wholelist") : document.getElementById('wholelist');
	
	curContent = new String(tmpObj1.value);
	curList = new String(tmpObj2.value);

	var curSplitContent = curContent.split(", ");
	var newList = new String("");
	var newList2 = new String("");
	
	nEntries = 0;
	
	for (var i = 0; i < curSplitContent.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = "<a href=\"javascript:RemoveWholeTopping(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = curSplitContent[i];
			}
			else {
				newList = newList + ", <a href=\"javascript:RemoveWholeTopping(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = newList2 + ", " + curSplitContent[i];
			}
			
			nEntries++;
		}
	}
	
	tmpObj3.innerHTML = newList;
	tmpObj1.value = newList2;
	
	var curSplitList = curList.split(",");
	var newList = new String("");
	var newList2 = new String("");
	
	for (var i = 0; i < curSplitList.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = curSplitList[i];
			}
			else {
				newList = newList + "," + curSplitList[i];
			}
		}
	}
	
	tmpObj2.value = newList;
}

function Half1Topping()
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3, tmpObj4;
	
	tmpObj1 = ie4? eval("document.all.half1list") : document.getElementById('half1list');
	tmpObj2 = ie4? eval("document.all.TOPHALF1") : document.getElementById('TOPHALF1');
	tmpObj3 = ie4? eval("document.all.HALF1") : document.getElementById('HALF1');
	tmpObj4 = ie4? eval("document.all.TOPHALF1NAME") : document.getElementById('TOPHALF1NAME');
	
	if (tmpObj3.selectedIndex > 0) {
		curContent = new String(tmpObj1.innerHTML);
		curList = new String(tmpObj2.value);
		
		if (curContent.length == 0) {
			nEntries = 0;
		}
		else {
			var curSplit = curContent.split(", ");
			nEntries = curSplit.length;
		}
		
		if (curContent.length == 0) {
			tmpObj1.innerHTML = "<a href=\"javascript:RemoveHalf1Topping(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		else {
			tmpObj1.innerHTML = tmpObj1.innerHTML + ", <a href=\"javascript:RemoveHalf1Topping(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj4.value + ", " + tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		
		if (curList.length == 0)
			tmpObj2.value = tmpObj3.value;
		else
			tmpObj2.value = tmpObj2.value + ',' + tmpObj3.value;
		
		tmpObj3.selectedIndex = 0;
	}
}

function RemoveHalf1Topping(pnPos)
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3;
	
	tmpObj1 = ie4? eval("document.all.TOPHALF1NAME") : document.getElementById('TOPHALF1NAME');
	tmpObj2 = ie4? eval("document.all.TOPHALF1") : document.getElementById('TOPHALF1');
	tmpObj3 = ie4? eval("document.all.half1list") : document.getElementById('half1list');
	
	curContent = new String(tmpObj1.value);
	curList = new String(tmpObj2.value);

	var curSplitContent = curContent.split(", ");
	var newList = new String("");
	var newList2 = new String("");
	
	nEntries = 0;
	
	for (var i = 0; i < curSplitContent.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = "<a href=\"javascript:RemoveHalf1Topping(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = curSplitContent[i];
			}
			else {
				newList = newList + ", <a href=\"javascript:RemoveHalf1Topping(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = newList2 + ", " + curSplitContent[i];
			}
			
			nEntries++;
		}
	}
	
	tmpObj3.innerHTML = newList;
	tmpObj1.value = newList2;
	
	var curSplitList = curList.split(",");
	var newList = new String("");
	var newList2 = new String("");
	
	for (var i = 0; i < curSplitList.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = curSplitList[i];
			}
			else {
				newList = newList + "," + curSplitList[i];
			}
		}
	}
	
	tmpObj2.value = newList;
}

function Half2Topping()
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3, tmpObj4;
	
	tmpObj1 = ie4? eval("document.all.half2list") : document.getElementById('half2list');
	tmpObj2 = ie4? eval("document.all.TOPHALF2") : document.getElementById('TOPHALF2');
	tmpObj3 = ie4? eval("document.all.HALF2") : document.getElementById('HALF2');
	tmpObj4 = ie4? eval("document.all.TOPHALF2NAME") : document.getElementById('TOPHALF2NAME');
	
	if (tmpObj3.selectedIndex > 0) {
		curContent = new String(tmpObj1.innerHTML);
		curList = new String(tmpObj2.value);
		
		if (curContent.length == 0) {
			nEntries = 0;
		}
		else {
			var curSplit = curContent.split(", ");
			nEntries = curSplit.length;
		}
		
		if (curContent.length == 0) {
			tmpObj1.innerHTML = "<a href=\"javascript:RemoveHalf2Topping(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		else {
			tmpObj1.innerHTML = tmpObj1.innerHTML + ", <a href=\"javascript:RemoveHalf2Topping(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj4.value + ", " + tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		
		if (curList.length == 0)
			tmpObj2.value = tmpObj3.value;
		else
			tmpObj2.value = tmpObj2.value + ',' + tmpObj3.value;
		
		tmpObj3.selectedIndex = 0;
	}
}

function RemoveHalf2Topping(pnPos)
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3;
	
	tmpObj1 = ie4? eval("document.all.TOPHALF2NAME") : document.getElementById('TOPHALF2NAME');
	tmpObj2 = ie4? eval("document.all.TOPHALF2") : document.getElementById('TOPHALF2');
	tmpObj3 = ie4? eval("document.all.half2list") : document.getElementById('half2list');
	
	curContent = new String(tmpObj1.value);
	curList = new String(tmpObj2.value);

	var curSplitContent = curContent.split(", ");
	var newList = new String("");
	var newList2 = new String("");
	
	nEntries = 0;
	
	for (var i = 0; i < curSplitContent.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = "<a href=\"javascript:RemoveHalf2Topping(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = curSplitContent[i];
			}
			else {
				newList = newList + ", <a href=\"javascript:RemoveHalf2Topping(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = newList2 + ", " + curSplitContent[i];
			}
			
			nEntries++;
		}
	}
	
	tmpObj3.innerHTML = newList;
	tmpObj1.value = newList2;
	
	var curSplitList = curList.split(",");
	var newList = new String("");
	var newList2 = new String("");
	
	for (var i = 0; i < curSplitList.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = curSplitList[i];
			}
			else {
				newList = newList + "," + curSplitList[i];
			}
		}
	}
	
	tmpObj2.value = newList;
}

function SetIncludedSide(pnPos, psValue)
{
	var tmpObj1;
	
	if (psValue != "Select a side...")
	{
		tmpObj1 = ie4? eval("document.all.INCLUDEDSIDENAME") : document.getElementById('INCLUDEDSIDENAME');
		
		var curList = new String(tmpObj1.value);
		var curSplit = curList.split(",")
		var newList = new String("");
		var curItem = new String("");
		
		for (var i = 0; i < curSplit.length; i++) {
			if (i == pnPos) {
				curItem = psValue;
			}
			else {
				curItem = curSplit[i];
			}
			
			if (newList.length == 0) {
				newList = curItem;
			}
			else {
				newList = newList + "," + curItem;
			}
		}
		
		tmpObj1.value = newList;
	}
}

function AddSide()
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3, tmpObj4;
	
	tmpObj1 = ie4? eval("document.all.sidelist") : document.getElementById('sidelist');
	tmpObj2 = ie4? eval("document.all.ADDSIDE") : document.getElementById('ADDSIDE');
	tmpObj3 = ie4? eval("document.all.SIDE") : document.getElementById('SIDE');
	tmpObj4 = ie4? eval("document.all.ADDSIDENAME") : document.getElementById('ADDSIDENAME');
	
	if (tmpObj3.selectedIndex > 0) {
		curContent = new String(tmpObj1.innerHTML);
		curList = new String(tmpObj2.value);
		
		if (curContent.length == 0) {
			nEntries = 0;
		}
		else {
			var curSplit = curContent.split(", ");
			nEntries = curSplit.length;
		}
		
		if (curContent.length == 0) {
			tmpObj1.innerHTML = "<a href=\"javascript:RemoveAddSide(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		else {
			tmpObj1.innerHTML = tmpObj1.innerHTML + ", <a href=\"javascript:RemoveAddSide(" + nEntries + ")\">" + tmpObj3.options[tmpObj3.selectedIndex].innerHTML + "</a>";
			tmpObj4.value = tmpObj4.value + ", " + tmpObj3.options[tmpObj3.selectedIndex].innerHTML;
		}
		
		if (curList.length == 0)
			tmpObj2.value = tmpObj3.value;
		else
			tmpObj2.value = tmpObj2.value + ',' + tmpObj3.value;
		
		tmpObj3.selectedIndex = 0;
	}
}

function RemoveAddSide(pnPos)
{
	var curContent, curList, nEntries, tmpObj1, tmpObj2, tmpObj3;
	
	tmpObj1 = ie4? eval("document.all.ADDSIDENAME") : document.getElementById('ADDSIDENAME');
	tmpObj2 = ie4? eval("document.all.ADDSIDE") : document.getElementById('ADDSIDE');
	tmpObj3 = ie4? eval("document.all.sidelist") : document.getElementById('sidelist');
	
	curContent = new String(tmpObj1.value);
	curList = new String(tmpObj2.value);

	var curSplitContent = curContent.split(", ");
	var newList = new String("");
	var newList2 = new String("");
	
	nEntries = 0;
	
	for (var i = 0; i < curSplitContent.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = "<a href=\"javascript:RemoveAddSide(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = curSplitContent[i];
			}
			else {
				newList = newList + ", <a href=\"javascript:RemoveAddSide(" + nEntries + ")\">" + curSplitContent[i] + "</a>";
				newList2 = newList2 + ", " + curSplitContent[i];
			}
			
			nEntries++;
		}
	}
	
	tmpObj3.innerHTML = newList;
	tmpObj1.value = newList2;
	
	var curSplitList = curList.split(",");
	var newList = new String("");
	var newList2 = new String("");
	
	for (var i = 0; i < curSplitList.length; i++) {
		if (i != pnPos) {
			if (newList.length == 0) {
				newList = curSplitList[i];
			}
			else {
				newList = newList + "," + curSplitList[i];
			}
		}
	}
	
	tmpObj2.value = newList;
}

function addCheckout()
{
	var tmpObj1;
	
	tmpObj1 = ie4? eval("document.all.customize") : document.getElementById('customize');
	tmpObj1.action = "checkout.asp";
	tmpObj1.submit();
}

function limitText(limitField, limitCount, limitNum) {
	if (limitField.value.length > limitNum) {
		limitField.value = limitField.value.substring(0, limitNum);
	} else {
		limitCount.value = limitNum - limitField.value.length;
	}
}
//-->
</script>
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
<%
sDisplayAddress = Session("ADDRESS")
If Len(Session("APT")) > 0 Then
	sDisplayAddress = sDisplayAddress & " #" & Session("APT")
End If
%>
						<strong>Your Location:</strong><br />
						<%=Session("FIRSTNAME")%>&nbsp;<%=Session("LASTNAME")%><br />
						<%=sDisplayAddress%><br />
						<%=Session("CITY")%>, <%=Session("STATE")%>&nbsp;<%=Session("ZIPCODE")%><br />
						<a href="register.asp"><img src="images/change.jpg" width="109" height="38" alt="Change" /></a>
					</td>
					<td valign="top" width="170">
<%
If GetStoreInfo(Session("STORE"), sName, sAddress1, sAddress2, sCity, sState, sPostalCode, sPhone, sFax, sHours) Then
	If Session("MODE") = "DELIVERY" Then
%>
						<strong>Delivering From:</strong><br />
<%
	Else
%>
						<strong>Pickup From:</strong><br />
<%
	End If
%>
						<%=sAddress1%><br />
<%
	If Not IsEmpty(sAddress2) And Not IsNull(sAddress2) Then
%>
						<%=sAddress2%><br />
<%
	End If
%>
						<%=sCity%>,&nbsp;<%=sState%>&nbsp;<%=sPostalCode%><br />
						<%=Left(sPhone, 3) & "-" & Mid(sPhone, 4, 3) & "-" & Mid(sPhone, 7)%><br />
<%
	If Session("MODE") = "DELIVERY" Then
%>
						<a href="pickup.asp?ACTION=PICKUP"><img src="images/pickup.jpg" width="118" height="36" alt="Switch to Pickup" /></a>
<%
	Else
		nTempStore = LocateStoreByAddress(Session("ZIPCODE"), Session("ADDRESS"), Session("APT"), Session("CITY"), Session("STATE"), nDelivery, nDrMoney)
		
		If nTempStore > 0 Then
%>
						<a href="deals.asp?ACTION=DELIVERY"><img src="images/delivery.jpg" width="124" height="35" alt="Switch to Delivery" /></a>
<%
		End If
	End If
End If
%>
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
					<td valign="top" width="419" class="customize">
<%
Dim sItemList, sItemListName, sItemNumList, bAllowHalf, nInclSideCount, sInclSideList, bIgnoreSpecialtySides, nSpecCrust, nSpecSauce, sDescription
Dim saItemName(), naItemNum(), saUnitSize(), naUnitSizeNum(), saCrust(), naCrustNum(), saTopper(), naTopperNum(), saSauce(), naSauceNum()
Dim saSauceModifier(), naSauceModifierNum(), saSide(), saSideID(), saDefaultSide(), saDefaultSideID(), naDefaultSideCount()
Dim saSpecialtySide(), saSpecialtySideID(), naSpecialtySideCount(), saNotes()
Dim saSpecItemName(), naSpecItemNum(), saSpecSide(), naSpecSideNum(), saInclSide(), naInclSideNum()
Dim sSpecDesc, sSpecImage, nWidth, nHeight, nDepth, sType
Dim nUID, sSpecialty, sUnitName, nSize, nPromo, bFoundFree, sPromoCode
Dim nIncludedSidePosition, j, bInclSideValid, sTemp, nPos
Dim naCrustPrice()
Dim saSideGroup(), naSideGroupID(), saSideGroupSide(), naSideGroupSideID(), baSideGroupSideIsDefault(), k, l, m, nPos2, nCount

sItemList = ""
sItemListName = ""
sItemNumList = ""
bAllowHalf = FALSE
nInclSideCount = 0
sInclSideList = ""
bIgnoreSpecialtySides = FALSE

nUID = CInt(Request("uid"))
nPromo = Request("pid")
sPromoCode = Request("pcode")
nSize = CInt(Request("SIZE"))

If Request("spec").Count > 0 Then
	If Len(Trim(Request("spec"))) = 0 Then
		sSpecialty = 0
	Else
		sSpecialty = CLng(Request("spec"))
	End If
Else
	sSpecialty = 0
End If

sUnitName = GetUnitName(Session("STORE"), nUID)

If GetItems(Session("STORE"), nUID, saItemName, naItemNum, bAllowHalf) Then
	If GetUnitSizes(Session("STORE"), nUID, saUnitSize, naUnitSizeNum) Then
		If GetCrusts(Session("STORE"), nUID, nSize, saCrust, naCrustNum, naCrustPrice) Then
			If GetToppers(Session("STORE"), nUID, saTopper, naTopperNum) Then
				If GetSauces(Session("STORE"), nUID, saSauce, naSauceNum) Then
					If GetSauceModifiers(Session("STORE"), nUID, saSauceModifier, naSauceModifierNum) Then
						If GetSides(Session("STORE"), nUID, saSide, saSideID) Then
							If GetDefaultSides(Session("STORE"), nUID, nSize, saDefaultSideID, naDefaultSideCount) Then
								If GetSpecialtySides(Session("STORE"), nUID, nSize, sSpecialty, saSpecialtySideID, naSpecialtySideCount) Then
									If GetSideGroups(Session("STORE"), nUID, saSideGroup, naSideGroupID, saSideGroupSide, naSideGroupSideID, baSideGroupSideIsDefault) Then
										If GetBaseCheese(Session("STORE"), nUID, sItemList, sItemListName, sItemNumList) Then
											If sSpecialty > 0 Then
												If IsNoBaseCheese(nUID, sSpecialty) Then
													sItemList = ""
													sItemListName = ""
													sItemNumList = ""
												End If
												
												If GetDefaultItems(Session("STORE"), nUID, sSpecialty, saSpecItemName, naSpecItemNum) Then
													If Len(saSpecItemName(0)) > 0 Then
														For i = 0 To UBound(saSpecItemName)
															If Len(sItemList) = 0 Then
																sItemList = "<a href=""javascript:RemoveWholeTopping(" & i & ")"">" & saSpecItemName(i) & "</a>"
																sItemListName = saSpecItemName(i)
																sItemNumList = naSpecItemNum(i)
															Else
																sItemList = sItemList & ", <a href=""javascript:RemoveWholeTopping(" & i & ")"">" & saSpecItemName(i) & "</a>"
																sItemListName = sItemListName & ", " & saSpecItemName(i)
																sItemNumList = sItemNumList & "," & naSpecItemNum(i)
															End If
														Next
													End If
												End If
											End If
											
											If sSpecialty > 0 Then
												nSpecCrust = GetDefaultCrust(Session("STORE"), nUID, sSpecialty)
												nSpecSauce = GetDefaultSauce(Session("STORE"), nUID, sSpecialty)
											Else
												nSpecCrust = 0
												nSpecSauce = naSauceNum(0)
											End If
											
											sDescription = GetFullDescription(Session("STORE"), nUID, sSpecialty)
											
%>
						<form method="post" action="deals.asp" name="customize" id="customize">
							<input type="hidden" name="ACTION" id="ACTION" value="ADD">
							<input type="hidden" name="UNITNUM" id="UNITNUM" value="<%=nUID%>">
							<input type="hidden" name="UNITNAME" id="UNITNAME" value="<%=sUnitName%>">
							<input type="hidden" name="SPECIALTY" id="SPECIALTY" value="<%=sSpecialty%>">
							<input type="hidden" name="PROMO" id="PROMO" value="<%=nPromo%>">
							<input type="hidden" name="PROMOCODE" id="PROMOCODE" value="<%=sPromoCode%>">
<%
											If sSpecialty > 0 Then
												If GetSpecialtyInfo(Session("STORE"), nUID, sSpecialty, sSpecDesc) Then
													Set oFS = CreateObject("Scripting.FileSystemObject")
													
													sFileName = "images/special-images/" & nUID & "-" & sSpecialty & ".jpg"
													If oFS.FileExists(Server.MapPath(sFileName)) Then
'														If gfxSpex(Server.MapPath(sFileName), nWidth, nHeight, nDepth, sType) Then
															' TODO NOTE: FOR WHATEVER REASON RETRIEVING THE SIZE PERIODICALLY FAILS SO I'VE REMOVED IT FOR NOW
%>
							<img src="<%=sFileName%>" alt="<%=sSpecDesc%>">
							<%=sSpecDesc%><br />&nbsp;<br />
<%
'														End If
													Else
%>
							<strong><%=GetSpecialtyName(Session("STORE"), nUID, sSpecialty)%>&nbsp;<%=sUnitName%></strong> - <%=sDescription%><br />&nbsp;<br />
<%
													End If
												Else
%>
							<strong><%=GetSpecialtyName(Session("STORE"), nUID, sSpecialty)%>&nbsp;<%=sUnitName%></strong> - <%=sDescription%><br />&nbsp;<br />
<%
												End If
											Else
												Set oFS = CreateObject("Scripting.FileSystemObject")
												
												sFileName = "images/special-images/" & nUID & ".jpg"
												If oFS.FileExists(Server.MapPath(sFileName)) Then
'													If gfxSpex(Server.MapPath(sFileName), nWidth, nHeight, nDepth, sType) Then
														' TODO NOTE: FOR WHATEVER REASON RETRIEVING THE SIZE PERIODICALLY FAILS SO I'VE REMOVED IT FOR NOW
%>
							<img src="<%=sFileName%>" alt="<%=sDescription%>">
							<%=sDescription%><br />&nbsp;<br />
<%
'													End If
												Else
%>
							<strong><%=sUnitName%></strong> - <%=sDescription%><br />&nbsp;<br />
<%
												End If
											End If
											
											If Len(saUnitSize(0)) > 0 and UBound(saUnitSize) > 0 Then
												For i = 0 To UBound(naUnitSizeNum)
													If naUnitSizeNum(i) = nSize Then
%>
							<img src="images/custom-size.jpg" width="78" height="34">
							<input type="hidden" name="SIZENAME" id="SIZENAME" value="<%=saUnitSize(i)%>">
							<input type="hidden" name="SIZE" id="SIZE" value="<%=nSize%>">
							<%=saUnitSize(i)%><br />&nbsp;<br />
<%
														Exit For
													End If
												Next
											Else
%>
							<input type="hidden" name="SIZENAME" id="SIZENAME" value="<%=saUnitSize(0)%>">
							<input type="hidden" name="SIZE" id="SIZE" value="<%=naUnitSizeNum(0)%>">
<%
											End If
											
											If nSpecCrust <= UBound(saCrust) Then
%>
							<input type="hidden" name="CRUSTNAME" id="CRUSTNAME" value="<%=saCrust(nSpecCrust)%>">
<%
											Else
%>
							<input type="hidden" name="CRUSTNAME" id="CRUSTNAME" value="">
<%
											End If
							
											If Len(saCrust(0)) > 0 Then
%>
							<img src="images/custom-style.jpg" width="94" height="32">
							<select name="CRUST" id="CRUST" onchange="SetCrust();" onmousewheel="return(false);" onkeydown="return(false);">
<%
												For i = 0 To UBound(saCrust)
													If naCrustNum(i) = nSpecCrust Then
														If naCrustPrice(i) = 0 Then
%>
								<option value="<%=naCrustNum(i)%>" selected><%=saCrust(i)%></option>
<%
														Else
%>
								<option value="<%=naCrustNum(i)%>" selected><%=saCrust(i) & " (add " & FormatCurrency(naCrustPrice(i)) & ")"%></option>
<%
														End If
													Else
														If naCrustPrice(i) = 0 Then
%>
								<option value="<%=naCrustNum(i)%>"><%=saCrust(i)%></option>
<%
														Else
%>
								<option value="<%=naCrustNum(i)%>"><%=saCrust(i) & " (add " & FormatCurrency(naCrustPrice(i)) & ")"%></option>
<%
														End If
													End If
												Next
%>
							</select><br />&nbsp;<br />
<%
											Else
%>
							<input type="hidden" name="CRUST" id="CRUST" value="0">
<%
											End If
											
											If Len(saTopper(0)) > 0 Then
%>
							<img src="images/custom-toppers.jpg" width="379" height="32">
							<input type="hidden" name="CRUSTTOPNAME" id="CRUSTTOPNAME" value="">
							<input type="hidden" name="CRUSTTOP" id="CRUSTTOP" value="">
							<select name="TOPPER" id="TOPPER" onchange="AddTopper();" onmousewheel="return(false);" onkeydown="return(false);">
								<option value="" selected>Select Crust Toppers</option>
<%
												For i = 0 To UBound(saTopper)
%>
								<option value="<%=naTopperNum(i)%>"><%=saTopper(i)%></option>
<%
												Next
%>
							</select><br />
							<span id="topperlist"></span><br />&nbsp;<br />
<%
											Else
%>
							<input type="hidden" name="CRUSTTOPNAME" id="CRUSTTOPNAME" value="">
							<input type="hidden" name="CRUSTTOP" id="CRUSTTOP" value="">
							<input type="hidden" name="TOPPER" id="TOPPER" value="">
<%
											End If
							
											If Len(saSauce(0)) > 0 Then
%>
							<img src="images/custom-sauce.jpg" width="246" height="35">
<%
												If nSpecSauce <> naSauceNum(0) Then
%>
							On this particular Specialty pizza we do not suggest you alter the sauce.<br />
<%
												End If
' Temporarily don't allow half sauces
'												If bAllowHalf Then
												If 1 = 0 Then
%>
							<input type="hidden" name="SAUCEWHOLE" id="SAUCEWHOLE" value="0">
							<input type="hidden" name="SAUCENAMEWHOLE" id="SAUCENAMEWHOLE" value="">
							<input type="hidden" name="SAUCEMODIFIERWHOLE" id="SAUCEMODIFIERWHOLE" value="0">
<%
													For i = 0 To UBound(naSauceNum)
														If naSauceNum(i) = nSpecSauce Then
%>
							<input type="hidden" name="SAUCENAMEHALF1" id="SAUCENAMEHALF1" value="<%=saSauce(i)%>">
							<input type="hidden" name="SAUCENAMEHALF2" id="SAUCENAMEHALF2" value="<%=saSauce(i)%>">
<%
															Exit For
														End If
													Next
%>
							1st Half: <select name="SAUCEHALF1" id="SAUCEHALF1" onchange="SetSauceHalf1();" onmousewheel="return(false);" onkeydown="return(false);">
<%
													For i = 0 To UBound(saSauce)
														If naSauceNum(i) = nSpecSauce Then
%>
								<option value="<%=naSauceNum(i)%>" selected><%=saSauce(i)%></option>
<%
														Else
%>
								<option value="<%=naSauceNum(i)%>"><%=saSauce(i)%></option>
<%
														End If
													Next
%>
							</select>
<%
													If Len(saSauceModifier(0)) > 0 Then
%>
							&nbsp;<select name="SAUCEMODIFIERHALF1" id="SAUCEMODIFIERHALF1" onchange="SetSauceModifierHalf1();" onmousewheel="return(false);" onkeydown="return(false);">
								<option value="0" selected=>Select sauce options...</option>
<%
														For i = 0 To UBound(saSauceModifier)
%>
								<option value="<%=naSauceModifierNum(i)%>"><%=saSauceModifier(i)%></option>
<%
														Next
%>
							</select>
<%
													End If
%>
							<br />2nd Half: <select name="SAUCEHALF2" id="SAUCEHALF2" onchange="SetSauceHalf2();" onmousewheel="return(false);" onkeydown="return(false);">
<%
													For i = 0 To UBound(saSauce)
														If naSauceNum(i) = nSpecSauce Then
%>
								<option value="<%=naSauceNum(i)%>" selected><%=saSauce(i)%></option>
<%
														Else
%>
								<option value="<%=naSauceNum(i)%>"><%=saSauce(i)%></option>
<%
														End If
													Next
%>
							</select>
<%
													If Len(saSauceModifier(0)) > 0 Then
%>
							&nbsp;<select name="SAUCEMODIFIERHALF2" id="SAUCEMODIFIERHALF2" onchange="SetSauceModifierHalf2();" onmousewheel="return(false);" onkeydown="return(false);">
								<option value="0" selected=>Select sauce options...</option>
<%
														For i = 0 To UBound(saSauceModifier)
%>
								<option value="<%=naSauceModifierNum(i)%>"><%=saSauceModifier(i)%></option>
<%
														Next
%>
							</select>
<%
													End If
												Else
													For i = 0 To UBound(naSauceNum)
														If naSauceNum(i) = nSpecSauce Then
%>
							<input type="hidden" name="SAUCENAMEWHOLE" id="SAUCENAMEWHOLE" value="<%=saSauce(i)%>">
<%
															Exit For
														End If
													Next
%>
							<input type="hidden" name="SAUCEHALF1" id="SAUCEHALF1" value="0">
							<input type="hidden" name="SAUCEHALF2" id="SAUCEHALF2" value="0">
							<input type="hidden" name="SAUCENAMEHALF1" id="SAUCENAMEHALF1" value="">
							<input type="hidden" name="SAUCENAMEHALF2" id="SAUCENAMEHALF2" value="">
							<input type="hidden" name="SAUCEMODIFIERHALF1" id="SAUCEMODIFIERHALF1" value="0">
							<input type="hidden" name="SAUCEMODIFIERHALF2" id="SAUCEMODIFIERHALF2" value="0">
							<select name="SAUCEWHOLE" id="SAUCEWHOLE" onchange="SetSauceWhole();" onmousewheel="return(false);" onkeydown="return(false);">
<%
													For i = 0 To UBound(saSauce)
														If naSauceNum(i) = nSpecSauce Then
%>
								<option value="<%=naSauceNum(i)%>" selected><%=saSauce(i)%></option>
<%
														Else
%>
								<option value="<%=naSauceNum(i)%>"><%=saSauce(i)%></option>
<%
														End If
													Next
%>
							</select>
<%
													If Len(saSauceModifier(0)) > 0 Then
%>
							&nbsp;<select name="SAUCEMODIFIERWHOLE" id="SAUCEMODIFIERWHOLE" onchange="SetSauceModifierWhole();" onmousewheel="return(false);" onkeydown="return(false);">
								<option value="0" selected>Select sauce options...</option>
<%
														For i = 0 To UBound(saSauceModifier)
%>
								<option value="<%=naSauceModifierNum(i)%>"><%=saSauceModifier(i)%></option>
<%
														Next
%>
							</select>
<%
													End If
												End If
%>
							<br />&nbsp;<br />
<%
											Else
%>
							<input type="hidden" name="SAUCEWHOLE" id="SAUCEWHOLE" value="0">
							<input type="hidden" name="SAUCENAMEWHOLE" id="SAUCENAMEWHOLE" value="">
							<input type="hidden" name="SAUCEHALF1" id="SAUCEHALF1" value="0">
							<input type="hidden" name="SAUCEHALF2" id="SAUCEHALF2" value="0">
							<input type="hidden" name="SAUCENAMEHALF1" id="SAUCENAMEHALF1" value="">
							<input type="hidden" name="SAUCENAMEHALF2" id="SAUCENAMEHALF2" value="">
							<input type="hidden" name="SAUCEMODIFIERHALF1" id="SAUCEMODIFIERHALF1" value="0">
							<input type="hidden" name="SAUCEMODIFIERHALF2" id="SAUCEMODIFIERHALF2" value="0">
<%
											End If
											
%>
							<input type="hidden" name="TOPHALF1NAME" id="TOPHALF1NAME" value="">
							<input type="hidden" name="TOPHALF1" id="TOPHALF1" value="">
							<input type="hidden" name="TOPHALF2NAME" id="TOPHALF2NAME" value="">
							<input type="hidden" name="TOPHALF2" id="TOPHALF2" value="">
<%
											If Len(saItemName(0)) > 0 Then
%>
							<input type="hidden" name="TOPWHOLENAME" id="TOPWHOLENAME" value="<%=sItemListName%>">
							<input type="hidden" name="TOPWHOLE" id="TOPWHOLE" value="<%=sItemNumList%>">
<%
												bFoundFree = FALSE
												For i = 0 To UBound(saItemName)
													If InStr(saItemName(i), "*") Then
														bFoundFree = TRUE
														Exit For
													End If
												Next
%>
							<img src="images/custom-toppings.jpg" width="190" height="31">
<%
												If bFoundFree Then
%>
							* - Indicates free toppings<br />
<%
												End If
%>
							Click on a topping to remove it<br />&nbsp;<br />
							<select name="WHOLE" id="WHOLE" onchange="WholeTopping();" onmousewheel="return(false);" onkeydown="return(false);">
								<option>Add Toppings to Whole <%=Request("UNITNAME")%></option>
<%
												For i = 0 To UBound(saItemName)
%>
								<option value="<%=naItemNum(i)%>"><%=saItemName(i)%></option>
<%
												Next
%>
							</select><br />
							<span id="wholelist"><%=sItemList%></span><br />&nbsp;<br />
<%
												If bAllowHalf Then
%>
							<select name="HALF1" id="HALF1" onchange="Half1Topping();" onmousewheel="return(false);" onkeydown="return(false);">
								<option>Add Toppings to 1st Half</option>
<%
													For i = 0 To UBound(saItemName)
%>
								<option value="<%=naItemNum(i)%>"><%=saItemName(i)%></option>
<%
													Next
%>
							</select><br />
							<span id="half1list"></span><br />&nbsp;<br />
							<select name="HALF2" id="HALF2" onchange="Half2Topping();" onmousewheel="return(false);" onkeydown="return(false);">
								<option>Add Toppings to 2nd Half</option>
<%
													For i = 0 To UBound(saItemName)
%>
								<option value="<%=naItemNum(i)%>"><%=saItemName(i)%></option>
<%
													Next
%>
							</select><br />
							<span id="half2list"></span><br />&nbsp;<br />
<%
												End If
											Else
%>
							<input type="hidden" name="TOPWHOLENAME" id="TOPWHOLENAME" value="">
							<input type="hidden" name="TOPWHOLE" id="TOPWHOLE" value="">
<%
											End If
											
											If saDefaultSideID(0) <> 0 Or (sSpecialty <> 0 And saSpecialtySideID(0) <> 0) Then
												nPos = 0
												sInclSideList = ""
%>
							<img src="images/custom-sides.jpg" width="295" height="35">
<%
												If sSpecialty <> 0 And saSpecialtySideID(0) <> 0 Then
													For i = 0 To UBound(saSpecialtySideID)
														For j = 0 To UBound(naSideGroupID)
															If saSpecialtySideID(i) = naSideGroupID(j) Then
																nCount = 0
																For k = 1 To naSpecialtySideCount(i)
%>
							<select name="INCLUDEDSIDE" id="INCLUDEDSIDE" onchange="SetIncludedSide(<%=nPos%>, this.options[this.selectedIndex].text);" onmousewheel="return(false);" onkeydown="return(false);">
<%
																	nPos2 = 0
																	
																	bFoundFree = FALSE
																	For l = 0 To UBound(naSideGroupSideID, 2)
																		If naSideGroupSideID(j, l) <> 0 Then
																			If baSideGroupSideIsDefault(j, l) Then
																				If nPos2 = nCount Then
																					bFoundFree = TRUE
																					Exit For
																				End If
																				nPos2 = nPos2 + 1
																			End If
																		End If
																	Next
																	
																	If Not bFoundFree Then
%>
								<option value="" selected>Select a side...</option>
<%
																	End If
																	
																	nPos2 = 0
																	
																	For l = 0 To UBound(naSideGroupSideID, 2)
																		If naSideGroupSideID(j, l) <> 0 Then
																			If baSideGroupSideIsDefault(j, l) Then
																				If nPos2 = nCount Then
																					If Len(sInclSideList) > 0 Then
																						sInclSideList = sInclSideList & ","
																					End If
																					sInclSideList = sInclSideList & saSideGroupSide(j, l)
%>
								<option value="<%=naSideGroupSideID(j, l)%>" selected><%=saSideGroupSide(j, l)%></option>
<%
																				Else
%>
								<option value="<%=naSideGroupSideID(j, l)%>"><%=saSideGroupSide(j, l)%></option>
<%
																				End If
																				nPos2 = nPos2 + 1
																			Else
%>
								<option value="<%=naSideGroupSideID(j, l)%>"><%=saSideGroupSide(j, l)%></option>
<%
																			End If
																		End If
																	Next
%>
							</select><br />&nbsp;<br />
<%
																	nPos = nPos + 1
																	nCount = nCount + 1
																Next
																
																Exit For
															End If
														Next
													Next
												Else
													For i = 0 To UBound(saDefaultSideID)
														For j = 0 To UBound(naSideGroupID)
															If saDefaultSideID(i) = naSideGroupID(j) Then
																nCount = 0
																For k = 1 To naDefaultSideCount(i)
%>
							<select name="INCLUDEDSIDE" id="INCLUDEDSIDE" onchange="SetIncludedSide(<%=nPos%>, this.options[this.selectedIndex].text);" onmousewheel="return(false);" onkeydown="return(false);">
<%
																	nPos2 = 0
																	
																	bFoundFree = FALSE
																	For l = 0 To UBound(naSideGroupSideID, 2)
																		If naSideGroupSideID(j, l) <> 0 Then
																			If baSideGroupSideIsDefault(j, l) Then
																				If nPos2 = nCount Then
																					bFoundFree = TRUE
																					Exit For
																				End If
																				nPos2 = nPos2 + 1
																			End If
																		End If
																	Next
																	
																	If Not bFoundFree Then
%>
								<option value="" selected>Select a side...</option>
<%
																	End If
																	
																	nPos2 = 0
																	
																	For l = 0 To UBound(naSideGroupSideID, 2)
																		If naSideGroupSideID(j, l) <> 0 Then
																			If baSideGroupSideIsDefault(j, l) Then
																				If nPos2 = nCount Then
																					If Len(sInclSideList) > 0 Then
																						sInclSideList = sInclSideList & ","
																					End If
																					sInclSideList = sInclSideList & saSideGroupSide(j, l)
%>
								<option value="<%=naSideGroupSideID(j, l)%>" selected><%=saSideGroupSide(j, l)%></option>
<%
																				Else
%>
								<option value="<%=naSideGroupSideID(j, l)%>"><%=saSideGroupSide(j, l)%></option>
<%
																				End If
																				nPos2 = nPos2 + 1
																			Else
%>
								<option value="<%=naSideGroupSideID(j, l)%>"><%=saSideGroupSide(j, l)%></option>
<%
																			End If
																		End If
																	Next
%>
							</select><br />&nbsp;<br />
<%
																	nPos = nPos + 1
																	nCount = nCount + 1
																Next
																
																Exit For
															End If
														Next
													Next
												End If
											Else
%>
							<input type="hidden" name="INCLUDEDSIDE" id="INCLUDEDSIDE" value="">
<%
											End If
%>
							<input type="hidden" name="INCLUDEDSIDENAME" id="INCLUDEDSIDENAME" value="<%=sInclSideList%>">
							<input type="hidden" name="ADDSIDENAME" id="ADDSIDENAME" value="">
							<input type="hidden" name="ADDSIDE" id="ADDSIDE" value="">
<%
											If Len(saSide(0)) > 0 Then
%>
							<img src="images/custom-add-sides.jpg" width="326" height="35">
							<select name="SIDE" id="SIDE" onchange="AddSide();" onmousewheel="return(false);" onkeydown="return(false);">
								<option value="" selected>Additional Sides</option>
<%
												For i = 0 To UBound(saSide)
%>
								<option value="<%=saSideID(i)%>"><%=saSide(i)%></option>
<%
												Next
%>
							</select><br />
							<span id="sidelist"></span><br />&nbsp;<br />
<%
											End If
%>
							Special Instructions: (Maximum 255 characters)<br />
							<input readonly type="text" name="countdown" value="255" style="width:30px;"> characters remaining.<br />
							<textarea name="NOTES" id="NOTES" onKeyDown="limitText(this.form.NOTES,this.form.countdown,255);" onKeyUp="limitText(this.form.NOTES,this.form.countdown,255);" style="width: 400px; height: 75px"></textarea><br />&nbsp;<br />
							<img src="images/custom-quantity.jpg" width="173" height="31">
							<input type="text" name="QTY" id="QTY" style="width: 30px" value="1" /><br />&nbsp;<br />
							<input type="image" src="images/add-to-order.jpg" name="submit" />
						</form>
<%
										Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (11).</strong>
<%
										End If
									Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (10).</strong>
<%
									End If
								Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (9).</strong>
<%
								End If
							Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (8).</strong>
<%
							End If
						Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (7).</strong>
<%
						End If
					Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (6).</strong>
<%
					End If
				Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (5).</strong>
<%
				End If
			Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (4).</strong>
<%
			End If
		Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (3).</strong>
<%
		End If
	Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (2).</strong>
<%
	End If
Else
%>
						<strong>We apologize but our online ordering is temporarily unavailable (1).</strong>
<%
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
<%
If dTotal > 0 Then
%>
							<tr>
								<td colspan="3" valign="top" align="center">
<%
	dDeliveryMin = GetDeliveryMinimum(Session("STORE"))
	If Session("MODE") = "DELIVERY" And GetOrderTotalNoDiscount(nOrderID) < dDeliveryMin Then
%>
									Your order has not reached our minimum delivery of <%=FormatCurrency(dDeliveryMin)%>. 
									Please add more to your order or switch to pickup.
<%
	Else
%>
									<a href="javascript:addCheckout();"><img src="images/checkout-add.jpg" width="191" height="38" alt="Add to Cart and Checkout" /></a>
									<a href="checkout.asp"><img src="images/checkout-noadd.jpg" width="191" height="38" alt="Checkout Without Adding" /></a>
<%
	End If
%>
								</td>
							</tr>
<%
End If
%>
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