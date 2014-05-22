<%
' **************************************************************************
' File: app-ordering.asp
' Purpose: Include file containing web ordering functions functions.
' Created: 7/22/2008 - TAM
'
' Revision History:
' 7/22/2008 - Created
' **************************************************************************

' **************************************************************************
' Function: IsStoreEnabled
' Purpose: Determines if a store has been enabled.
' Return: TRUE or FALSE
' **************************************************************************
Function IsStoreEnabled(ByVal pnStore)
	Dim bRet, oConn, oRS, sSQL, dtNow, nTime
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select isactive, openmon, closemon, opentue, closetue, openwed, closewed, openthu, closethu, openfri, closefri, opensat, closesat, opensun, closesun from tblStores where StoreID = " & pnStore
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				If Not IsNull(oRS("isactive")) Then
					If oRS("isactive") Then
						dtNow = Now
						nTime = Hour(dtNow) * 100 + Minute(dtNow)
						
						Select Case Weekday(dtNow)
							Case 1
								If oRS("closesun") < oRS("opensun") Then
									If (nTime >= oRS("opensun") And nTime <= 2400) or (nTime >= 0 And nTime <= oRS("closesun")) Then
										bRet = TRUE
									End If
								Else
									If nTime >= oRS("opensun") And nTime <= oRS("closesun") Then
										bRet = TRUE
									End If
								End If
							Case 2
								If oRS("closemon") < oRS("openmon") Then
									If (nTime >= oRS("openmon") And nTime <= 2400) or (nTime >= 0 And nTime <= oRS("closemon")) Then
										bRet = TRUE
									End If
								Else
									If nTime >= oRS("openmon") And nTime <= oRS("closemon") Then
										bRet = TRUE
									End If
								End If
							Case 3
								If oRS("closetue") < oRS("opentue") Then
									If (nTime >= oRS("opentue") And nTime <= 2400) or (nTime >= 0 And nTime <= oRS("closetue")) Then
										bRet = TRUE
									End If
								Else
									If nTime >= oRS("opentue") And nTime <= oRS("closetue") Then
										bRet = TRUE
									End If
								End If
							Case 4
								If oRS("closewed") < oRS("openwed") Then
									If (nTime >= oRS("openwed") And nTime <= 2400) or (nTime >= 0 And nTime <= oRS("closewed")) Then
										bRet = TRUE
									End If
								Else
									If nTime >= oRS("openwed") And nTime <= oRS("closewed") Then
										bRet = TRUE
									End If
								End If
							Case 5
								If oRS("closethu") < oRS("openthu") Then
									If (nTime >= oRS("openthu") And nTime <= 2400) or (nTime >= 0 And nTime <= oRS("closethu")) Then
										bRet = TRUE
									End If
								Else
									If nTime >= oRS("openthu") And nTime <= oRS("closethu") Then
										bRet = TRUE
									End If
								End If
							Case 6
								If oRS("closefri") < oRS("openfri") Then
									If (nTime >= oRS("openfri") And nTime <= 2400) or (nTime >= 0 And nTime <= oRS("closefri")) Then
										bRet = TRUE
									End If
								Else
									If nTime >= oRS("openfri") And nTime <= oRS("closefri") Then
										bRet = TRUE
									End If
								End If
							Case 7
								If oRS("closesat") < oRS("opensat") Then
									If (nTime >= oRS("opensat") And nTime <= 2400) or (nTime >= 0 And nTime <= oRS("closesat")) Then
										bRet = TRUE
									End If
								Else
									If nTime >= oRS("opensat") And nTime <= oRS("closesat") Then
										bRet = TRUE
									End If
								End If
						End Select
					End If
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	IsStoreEnabled = bRet
End Function

Function EnableStore(ByVal pnStore)
	Dim bRet, sSQL
	
	bRet = FALSE
	
	sSQL = "update tblStores set isactive = 1 where storeid = " & pnStore
	
	If InvokeSQL(sSQL) Then
		bRet = TRUE
	End If
	
	EnableStore = bRet
End Function

Function DisableStore(ByVal pnStore)
	Dim bRet, sSQL
	
	bRet = FALSE
	
	sSQL = "update tblStores set isactive = 0 where storeid = " & pnStore
	
	If InvokeSQL(sSQL) Then
		bRet = TRUE
	End If
	
	DisableStore = bRet
End Function

Function GetStoresEnabled(panStores, pabEnabled)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim panStores(0), pabEnabled(0)
	panStores(0) = 0
	pabEnabled(0) = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select storeid, isactive from tblStores where storeid > 0 order by storeid"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve panStores(i), pabEnabled(i)
					
					panStores(i) = oRS("storeid")
					pabEnabled(i) = oRS("isactive")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	IsStoreEnabled = bRet
End Function

' **************************************************************************
' Function: IsStoreActive
' Purpose: Determines if a store has checked in within the global threshold.
'			UPDATE: Now just checks to see if the store is open.
' Return: TRUE or FALSE
' **************************************************************************
Function IsStoreActive(ByVal pnStore)
	Dim bRet, oConn, oRS, sSQL, dCheckin
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "Select top 1 CurrentStatus, ReportDate from tblStoreReportDate where StoreID = " & pnStore & " Order by RADRAT DESC"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.BOF And Not oRS.EOF Then
				If Trim(oRS("CurrentStatus")) <> "Closed" Then
					bRet = TRUE
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	IsStoreActive = bRet
End Function

Function GetCityState(ByVal psPostalCode, ByRef psCity, ByRef psState)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select distinct city, state from tblCASSAddresses where postalcode = '" & CleanDBLiteral(psPostalCode) & "'"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				psCity = Trim(oRS("city"))
				psState = Trim(oRS("state"))
			Else
				psCity = "UNKNOWN CITY"
				psState = "US"
			End If
			
			CloseQuery(oRS)
		Else
			psCity = "UNKNOWN CITY"
			psState = "US"
		End If
		
		CloseDatabase(oConn)
	Else
		psCity = "UNKNOWN CITY"
		psState = "US"
	End If
	
	GetCityState = bRet
End Function

' **************************************************************************
' Function: LocateStoreByAddress
' Purpose: Determines which store covers a given address. Also returns the normalized address with the apt/suite separated.
' Return: The store number or 0 if not found
' **************************************************************************
Function LocateStoreByAddress(ByVal psPostalCode, ByRef psAddress, ByRef psApt, ByRef psCity, ByRef psState, ByRef pnDelivery, ByRef pnDrMoney)
	Dim nRet, nAddress, sStreet, sApt, oConn, oRS, sSQL
	
	nRet = 0
	
	If IsNumeric(psPostalCode) Then
		If NormalizeAddress(psPostalCode, UCase(psAddress), nAddress, sStreet, sApt) Then
			If OpenDatabase(oConn) Then
				' Try exact
				sSQL = "select tblCASSAddresses.storeid, tblCASSAddresses.city, tblCASSAddresses.state, tblCASSAddresses.deliverycharge, tblCASSAddresses.drivermoney from tblCASSAddresses inner join tblStores on tblCASSAddresses.storeid = tblStores.storeid where tblStores.storeid > 0 and tblCASSAddresses.postalcode = '" & CleanDBLiteral(psPostalCode) & "' and tblCASSAddresses.street = '" & CleanDBLiteral(sStreet) & "' and tblCASSAddresses.lownumber <= " & nAddress & " and tblCASSAddresses.highnumber >= " & nAddress
				
				If OpenQuery(oConn, oRS, sSQL) Then
					If Not oRS.bof And Not oRS.eof Then
						' Put 1/2 apt back into address
						If sApt = "1/2" Then
							psAddress = nAddress & " 1/2 " & sStreet
							psApt = ""
						Else
							psAddress = nAddress & " " & sStreet
							psApt = sApt
						End If
						
						nRet = oRS("storeid")
						psCity = Trim(oRS("city"))
						psState = Trim(oRS("state"))
						pnDelivery = oRS("deliverycharge")
						pnDrMoney = oRS("drivermoney")
						
						CloseQuery(oRS)
					Else
						CloseQuery(oRS)
						
						' Try starting with replacing spaces with percent in case they left off the street type and with a direction
						sSQL = "select distinct tblCASSAddresses.storeid, tblCASSAddresses.street, tblCASSAddresses.city, tblCASSAddresses.state, tblCASSAddresses.deliverycharge, tblCASSAddresses.drivermoney from tblCASSAddresses inner join tblStores on tblCASSAddresses.storeid = tblStores.storeid where tblStores.storeid > 0 and tblCASSAddresses.postalcode = '" & CleanDBLiteral(psPostalCode) & "' and tblCASSAddresses.street like '" & Replace(CleanDBLiteral(sStreet), " ", "%") & "' and tblCASSAddresses.lownumber <= " & nAddress & " and tblCASSAddresses.highnumber >= " & nAddress
						If OpenQuery(oConn, oRS, sSQL) Then
							If Not oRS.bof And Not oRS.eof Then
' This is where we need to detect vague matches
								oRS.MoveNext
								If Not oRS.eof Then
									psAddress = UCase(psAddress)
									GetCityState psPostalCode, psCity, psState
									nRet = 0
								Else
									oRS.Requery
									
									' Put 1/2 apt back into address
									If sApt = "1/2" Then
										psAddress = nAddress & " 1/2 " & Trim(oRS("street"))
										psApt = ""
									Else
										psAddress = nAddress & " " & Trim(oRS("street"))
										psApt = sApt
									End If
									
									nRet = oRS("storeid")
									psCity = Trim(oRS("city"))
									psState = Trim(oRS("state"))
									pnDelivery = oRS("deliverycharge")
									pnDrMoney = oRS("drivermoney")
								End If
								
								CloseQuery(oRS)
							Else
								' Try starting with in case they left off the street type and without a direction
								sSQL = "select distinct tblCASSAddresses.storeid, tblCASSAddresses.street, tblCASSAddresses.city, tblCASSAddresses.state, tblCASSAddresses.deliverycharge, tblCASSAddresses.drivermoney from tblCASSAddresses inner join tblStores on tblCASSAddresses.storeid = tblStores.storeid where tblStores.storeid > 0 and tblCASSAddresses.postalcode = '" & CleanDBLiteral(psPostalCode) & "' and tblCASSAddresses.street like '" & CleanDBLiteral(sStreet) & " %' and tblCASSAddresses.lownumber <= " & nAddress & " and tblCASSAddresses.highnumber >= " & nAddress
								If OpenQuery(oConn, oRS, sSQL) Then
									If Not oRS.bof And Not oRS.eof Then
' This is where we need to detect vague matches
										oRS.MoveNext
										If Not oRS.eof Then
											psAddress = UCase(psAddress)
											GetCityState psPostalCode, psCity, psState
											nRet = 0
										Else
											oRS.Requery
											
											' Put 1/2 apt back into address
											If sApt = "1/2" Then
												psAddress = nAddress & " 1/2 " & Trim(oRS("street"))
												psApt = ""
											Else
												psAddress = nAddress & " " & Trim(oRS("street"))
												psApt = sApt
											End If
											
											nRet = oRS("storeid")
											psCity = Trim(oRS("city"))
											psState = Trim(oRS("state"))
											pnDelivery = oRS("deliverycharge")
											pnDrMoney = oRS("drivermoney")
										End If
										
										CloseQuery(oRS)
									Else
										CloseQuery(oRS)
										
										' Try half the street in case they left off the street type with a direction
										sSQL = "select distinct tblCASSAddresses.storeid, tblCASSAddresses.street, tblCASSAddresses.city, tblCASSAddresses.state, tblCASSAddresses.deliverycharge, tblCASSAddresses.drivermoney from tblCASSAddresses inner join tblStores on tblCASSAddresses.storeid = tblStores.storeid where tblStores.storeid > 0 and tblCASSAddresses.postalcode = '" & CleanDBLiteral(psPostalCode) & "' and tblCASSAddresses.street like '" & CleanDBLiteral(Left(sStreet, (Len(sStreet) / 2))) & "%' and tblCASSAddresses.lownumber <= " & nAddress & " and tblCASSAddresses.highnumber >= " & nAddress
										If OpenQuery(oConn, oRS, sSQL) Then
											If Not oRS.bof And Not oRS.eof Then
' This is where we need to detect vague matches
												oRS.MoveNext
												If Not oRS.eof Then
													psAddress = UCase(psAddress)
													GetCityState psPostalCode, psCity, psState
													nRet = 0
												Else
													oRS.Requery
													
													' Put 1/2 apt back into address
													If sApt = "1/2" Then
														psAddress = nAddress & " 1/2 " & Trim(oRS("street"))
														psApt = ""
													Else
														psAddress = nAddress & " " & Trim(oRS("street"))
														psApt = sApt
													End If
													
													nRet = oRS("storeid")
													psCity = Trim(oRS("city"))
													psState = Trim(oRS("state"))
													pnDelivery = oRS("deliverycharge")
													pnDrMoney = oRS("drivermoney")
												End If
												
												CloseQuery(oRS)
											Else
												psAddress = UCase(psAddress)
												GetCityState psPostalCode, psCity, psState
												
												' Put 1/2 apt back into address
												If sApt = "1/2" Then
'													psAddress = nAddress & " 1/2 " & Trim(oRS("street"))
													psAddress = nAddress & " 1/2 " & sStreet
													psApt = ""
												Else
													psAddress = nAddress & " " & sStreet
													psApt = sApt
												End If
											End If
										End If
									End If
								End If
							End If
						End If
					End If
				End If
				
				CloseDatabase(oConn)
			End If
		End If
	End If
	
	LocateStoreByAddress = nRet
End Function

' **************************************************************************
' Function: NormalizeAddress
' Purpose: Takes an address and separates the number, street, and apartment portions.
' Return: The store number or 0 if not found
' **************************************************************************
Function NormalizeAddress(ByVal psPostalCode, ByVal psAddress, ByRef pnAddress, ByRef psStreet, ByRef psApt)
	Dim bRet, sRemain, aRemain, i, j, sDir, bCheck2
	
	bRet = FALSE
	
	' Extract street number
	pnAddress = 0
	For i = 1 to Len(psAddress)
		If IsNumeric(Mid(psAddress, i, 1)) Then
			pnAddress = pnAddress * 10 + CInt(Mid(psAddress, i, 1))
		Else
			sRemain = Trim(psAddress)
			
			' Strip anything after a comma in case they put city/state
			If InStr(sRemain, ",") > 0 Then
				sRemain = Left(sRemain, (InStr(sRemain, ",") - 1))
			End If
			
			' Put a space after all periods in case it was forgotten
			sRemain = Trim(Replace(sRemain, ".", ". "))
			
			' Kill any periods
			sRemain = Trim(Replace(sRemain, ".", ""))
			
			aRemain = Split(sRemain)
			Exit For
		End If
	Next

	If Len(sRemain) > 0 Then
		psStreet = ""
		sDir = ""
		psApt = ""
		
		' Look backwards for Apt/Suite
		For i = UBound(aRemain) To 1 Step -1
			If aRemain(i) = "APT" Or aRemain(i) = "APT." Or aRemain(i) = "APARTMENT" Or aRemain(i) = "APART" Or aRemain(i) = "APART." Or aRemain(i) = "#" Or Left(aRemain(i), 1) = "#" Or aRemain(i) = "STE" Or aRemain(i) = "STE." Or aRemain(i) = "SUITE" Or aRemain(i) = "BLDG" Or aRemain(i) = "BLDG." Or aRemain(i) = "BUILDING" Or aRemain(i) = "LOT" Or aRemain(i) = "FLR" Or aRemain(i) = "FLR." Or aRemain(i) = "FLOOR" Or aRemain(i) = "UNIT" Then
				If Len(aRemain(i)) > 1 And Left(aRemain(i), 1) = "#" Then
					psApt = Mid(aRemain(i), 2)
				Else
					psApt = aRemain(i+1)
				End If
				ReDim Preserve aRemain(i-1)
				Exit For
			End If
		Next
		
		' Check for double Apt/Suite (i.e. "Apt #")
		i = UBound(aRemain)
		Do While (i > 0) And (Len(Trim(aRemain(i))) = 0)
			i = i - 1
		Loop
		If i > 0 Then
			If aRemain(i) = "APT" Or aRemain(i) = "APT." Or aRemain(i) = "APARTMENT" Or aRemain(i) = "APART" Or aRemain(i) = "APART." Or aRemain(i) = "#" Or Left(aRemain(i), 1) = "#" Or aRemain(i) = "STE" Or aRemain(i) = "STE." Or aRemain(i) = "SUITE" Or aRemain(i) = "BLDG" Or aRemain(i) = "BLDG." Or aRemain(i) = "BUILDING" Or aRemain(i) = "LOT" Or aRemain(i) = "FLR" Or aRemain(i) = "FLR." Or aRemain(i) = "FLOOR" Or aRemain(i) = "UNIT" Then
				ReDim Preserve aRemain(i-1)
			End If
		End If
		
		IF UBound(aRemain) > 0 Then
			' THE FOLLOWING CODE BREAKS A LOT OF ADDRESSES
'			For i = 1 To UBound(aRemain)
'				If Len(Trim(aRemain(i))) > 0 Then
'					' Check for initial direction
'					Select Case aRemain(i)
'						case "N", "N.", "NORTH"
'							If Len(sDir) = 0 Then
'								sDir = "NORTH"
'							Else
'								psStreet = psStreet & " " & aRemain(i)
'							End If
'						case "S", "S.", "SOUTH"
'							If Len(sDir) = 0 Then
'								sDir = "SOUTH"
'							Else
'								psStreet = psStreet & " " & aRemain(i)
'							End If
'						case "E", "E.", "EAST"
'							If Len(sDir) = 0 Then
'								sDir = "EAST"
'							Else
'								psStreet = psStreet & " " & aRemain(i)
'							End If
'						case "W", "W.", "WEST"
'							If Len(sDir) = 0 Then
'								sDir = "WEST"
'							Else
'								psStreet = psStreet & " " & aRemain(i)
'							End If
'						case else
'							psStreet = psStreet & " " & aRemain(i)
'					End Select
'				End If
'			Next
			
' 2013-06-17 TAM: Deal with 1/2 before others
			' Account for 1/2
			For i = 1 To UBound(aRemain)
				If aRemain(i) = "1/2" Then
					If Len(psApt) = 0 Then
						psApt = "1/2"
					End If
					
					For j = (i + 1) to UBound(aRemain)
						aRemain(j - 1) = aRemain(j)
					Next
					ReDim Preserve aRemain(UBound(aRemain) - 1)
					Exit For
				End If
			Next
			
			' Prevent looking for direction if 2 words and last is type of road
			bCheck2 = TRUE
			If UBound(aRemain) = 2 Then
				Select Case aRemain(UBound(aRemain))
					Case "RD", "ROAD", "DR", "DRIVE", "CT", "COURT", "PL", "PLACE", "BLVD", "BOULEVARD", "BL.", "BL", "BOLEVARD", "ST", "STREET", "AVE", "AVENUE", "AV.", "AV", "LN", "LANE", "CIR", "CIRCLE", "TRCE", "TRACE", "TRL", "TRAIL", "CROSSING"
						bCheck2 = FALSE
				End Select
			End If
			
			' THE FOLLOWING CODE BREAKS "N LOCKWOOD" TYPE ADDRESSES - BUT THERE WAS A REASON THIS WAS DONE - WHY?
			If (UBound(aRemain) > 2) Or (UBound(aRemain) = 2 AND bCheck2) Then
				' Check for trailing direction
				Select Case aRemain(UBound(aRemain))
					case "N", "NORTH"
						sDir = "NORTH"
					case "S", "SOUTH"
						sDir = "SOUTH"
					case "E", "EAST"
						sDir = "EAST"
					case "W", "WEST"
						sDir = "WEST"
				End Select
				If Len(sDir) > 0 Then
					For i = 1 to (UBound(aRemain) - 1)
						psStreet = psStreet & " " & aRemain(i)
					Next
				Else
					' Check for initial direction
					Select Case aRemain(1)
						case "N", "NORTH"
							sDir = "NORTH"
						case "S", "SOUTH"
							sDir = "SOUTH"
						case "E", "EAST"
							sDir = "EAST"
						case "W", "WEST"
							sDir = "WEST"
					End Select
					If Len(sDir) > 0 Then
						For i = 2 to UBound(aRemain)
							psStreet = psStreet & " " & aRemain(i)
						Next
					Else
						For i = 1 to UBound(aRemain)
							psStreet = psStreet & " " & aRemain(i)
						Next
					End If
				End If
			Else
				For i = 1 to UBound(aRemain)
					psStreet = psStreet & " " & aRemain(i)
				Next
			End If
			
			aRemain = Split(psStreet)
			
			' Check for FIRST, SECOND, THIRD, etc.
			Select Case aRemain(1)
				Case "FIRST"
					aRemain(1) = "1ST"
				Case "SECOND"
					aReamin(1) = "2ND"
				Case "THIRD"
					aRemain(1) = "3RD"
				Case "FOURTH"
					aRemain(1) = "4TH"
				Case "FIFTH"
					aRemain(1) = "5TH"
				Case "SIXTH"
					aRemain(1) = "6TH"
				Case "SEVENTH"
					aRemain(1) = "7TH"
				Case "EIGHTH"
					aRemain(1) = "8TH"
				Case "NINTH"
					aRemain(1) = "9TH"
				Case "TENTH"
					aRemain(1) = "10TH"
				Case "ELEVENTH"
					aRemain(1) = "11TH"
				Case "TWELVETH"
					aReamin(1) = "12TH"
				Case "THIRTEENTH"
					aRemain(1) = "13TH"
				Case "FOURTEENTH"
					aRemain(1) = "14TH"
				Case "FIFTEENTH"
					aRemain(1) = "15TH"
				Case "SIXTEENTH"
					aReamin(1) = "16TH"
				Case "SEVENTEENTH"
					aRemain(1) = "17TH"
				Case "EIGHTEENTH"
					aRemain(1) = "18TH"
				Case "NINTEENTH"
					aRemain(1) = "19TH"
				Case "TWENTYETH"
					aRemain(1) = "20TH"
			End Select
			
			' Check end for street type and correct
			Select Case aRemain(UBound(aRemain))
				Case "RD", "ROAD"
					aRemain(UBound(aRemain)) = "RD"
				Case "DR", "DRIVE"
					aRemain(UBound(aRemain)) = "DR"
				Case "CT", "COURT"
					aRemain(UBound(aRemain)) = "CT"
				Case "PL", "PLACE"
					aRemain(UBound(aRemain)) = "PL"
				Case "BLVD", "BOULEVARD", "BL.", "BL", "BOLEVARD"
					aRemain(UBound(aRemain)) = "BLVD"
				Case "ST", "STREET"
					aRemain(UBound(aRemain)) = "ST"
				Case "AVE", "AVENUE", "AV.", "AV"
					aRemain(UBound(aRemain)) = "AVE"
				Case "LN", "LANE"
					aRemain(UBound(aRemain)) = "LN"
				Case "CIR", "CIRCLE"
					aRemain(UBound(aRemain)) = "CIR"
				Case "TRCE", "TRACE"
					aRemain(UBound(aRemain)) = "TRCE"
				Case "TRL", "TRAIL"
					aRemain(UBound(aRemain)) = "TRL"
				Case "CROSSING"
					aRemain(UBound(aRemain)) = "XING"
				Case "TERRACE"
					aRemain(UBound(aRemain)) = "TER"
			End Select
			
			' Rebuild Street
			psStreet = ""
			For i = 1 To UBound(aRemain)
' 2013-06-17 TAM: Deal with 1/2 above
'				' Account for 1/2
'				If aRemain(i) = "1/2" and Len(psApt) = 0 Then
'					psApt = "1/2"
'				Else
					psStreet = psStreet + " " + aRemain(i)
'				End If
			Next
			
			' Replace hyphens with spaces
			psStreet = Replace(psStreet, "-", " ")
			
			' Move direction to end
			psStreet = Trim(psStreet + " " + sDir)
	
			' Static Conversions
			If Left(psStreet, 4) = "TWP " Then
				psStreet = "TOWNSHIP " & Mid(psStreet, 5)
			End If
			If Left(psStreet, 12) = "TOWNSHIP RD " Then
				psStreet = "TOWNSHIP ROAD " & Mid(psStreet, 13)
			End If
			If Left(psStreet, 3) = "ST " Then
				' Must differentiate between SAINT and STATE ROUTE
				If Left(psStreet, 6) = "ST RT " Or Left(psStreet, 7) = "ST RTE " Or Left(psStreet, 9) = "ST ROUTE " Then
					psStreet = "STATE " & Mid(psStreet, 4)
				Else
					psStreet = "SAINT " & Mid(psStreet, 4)
				End If
			End If
			If Left(psStreet, 9) = "STATE RT " Then
				psStreet = "STATE ROUTE " & Mid(psStreet, 10)
			End If
			If Left(psStreet, 10) = "STATE RTE " Then
				psStreet = "STATE ROUTE " & Mid(psStreet, 11)
			End If
			If Left(psStreet, 10) = "COUNTY RD " Then
				psStreet = "COUNTY ROAD " & Mid(psStreet, 11)
			End If
			If psPostalCode = "43612" And (psStreet = "TOWNE MALL DR NORTH" or psStreet = "TOWNE MALL NORTH") Then
				psStreet = "NORTH TOWNE MALL DR"
			End If
			If psPostalCode = "45840" And (psStreet = "POINT DR EAST" Or psStreet = "POINT EAST") Then
				psStreet = "EAST POINT DR"
			End If
			If psPostalCode = "45840" And (psStreet = "POINT DR NORTH" Or psStreet = "POINT NORTH") Then
				psStreet = "NORTH POINT DR"
			End If
			If psPostalCode = "45840" And (psStreet = "POINT DR SOUTH" Or psStreet = "POINT SOUTH") Then
				psStreet = "SOUTH POINT DR"
			End If
			If psPostalCode = "45840" And psStreet = "NORTH WEST" Then
				psStreet = "WEST ST NORTH"
			End If
			If psPostalCode = "43611" And psStreet = "TER" Then
				psStreet = "TERRACE DR"
			End If
			If psPostalCode = "43528" And psStreet = "OAK TER" Then
				psStreet = "OAK TERRACE BLVD"
			End If
			If psPostalCode = "43551" And psStreet = "FIVE POINT RD" Then
				psStreet = "5 POINT RD"
			End If
			If psPostalCode = "48162" And (psStreet = "AVENUE DE LAYFAYETTE" Or psStreet = "AVENUE DELAYFAYETTE" Or psStreet = "AVE DELAYFAYETTE") Then
				psStreet = "AVE DE LAYFAYETTE"
			End If
			
			bRet = TRUE
		End If
	End If
	
	NormalizeAddress = bRet
End Function

' **************************************************************************
' Function: LocateStoresByPostalCode
' Purpose: Determines which stores covers a given zip code, returning arrays.
' Return: TRUE or FALSE based on success
' **************************************************************************
Function LocateStoresByPostalCode(ByVal psPostalCode, ByRef paStore, ByRef paName, ByRef paAddress, ByRef paAddress2, ByRef paCity, ByRef paState, ByRef paPostalCode, ByRef paPhone, ByRef paFax, ByRef paHours)
	Dim bRet, oConn, oRS, sSQL, i, nBaseZip
	
	bRet = FALSE
	
	If IsNumeric(psPostalCode) Then
		If OpenDatabase(oConn) Then
			' Try exact
' For now show all
'			sSQL = "select distinct stores.storeid, name, address1, address2, stores.city, stores.state, stores.postalcode, phone, fax, hours from addresses inner join stores on addresses.storeid = stores.storeid where stores.storeid > 0 and addresses.postalcode = " & psPostalCode
			sSQL = "select distinct storeid, storename, address1, address2, city, state, postalcode, phone, fax, hours from tblStores where storeid > 0"
			
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
					i = 1
					
					Do While Not oRS.eof
						ReDim Preserve paStore(i), paName(i), paAddress(i), paAddress2(i), paCity(i), paState(i), paPostalCode(i), paPhone(i), paFax(i), paHours(i)
						
						paStore(i) = oRS("storeid")
						paName(i) = oRS("storename")
						paAddress(i) = oRS("address1")
						paAddress2(i) = oRS("address2")
						paCity(i) = oRS("city")
						paState(i) = oRS("state")
						paPostalCode(i) = oRS("postalcode")
						paPhone(i) = oRS("phone")
						paFax(i) = oRS("fax")
						paHours(i) = oRS("hours")
						
						i = i + 1
						oRS.MoveNext
					Loop
					
					CloseQuery(oRS)
				Else
					CloseQuery(oRS)
					
					nBaseZip = Int(psPostalCode / 100) * 100
					sSQL = "select distinct stores.storeid, storename, address1, address2, stores.city, stores.state, stores.postalcode, phone, fax, hours from tblCASSAddresses inner join tblStores on tblCASSAddresses.storeid = tblStores.storeid where tblStores.storeid > 0 and tblCASSAddresses.postalcode >= '" & CleanDBLiteral(nBaseZip) & "' and tblCASSAddresses.postalcode <= '" & CleanDBLiteral(nBaseZip + 100) & "'"
					If OpenQuery(oConn, oRS, sSQL) Then
						If Not oRS.bof And Not oRS.eof Then
							bRet = TRUE
							i = 1
							
							Do While Not oRS.eof
								ReDim Preserve paStore(i), paName(i), paAddress(i), paAddress2(i), paCity(i), paState(i), paPostalCode(i), paPhone(i), paFax(i), paHours(i)
								
								paStore(i) = oRS("storeid")
								paName(i) = oRS("storename")
								paAddress(i) = oRS("address1")
								paAddress2(i) = oRS("address2")
								paCity(i) = oRS("city")
								paState(i) = oRS("state")
								paPostalCode(i) = oRS("postalcode")
								paPhone(i) = oRS("phone")
								paFax(i) = oRS("fax")
								paHours(i) = oRS("hours")
								
								i = i + 1
								oRS.MoveNext
							Loop
						End If
						
						CloseQuery(oRS)
					End If
				End If
			End If
			
			CloseDatabase(oConn)
		End If
	End If
	
	LocateStoresByPostalCode = bRet
End Function

' **************************************************************************
' Function: GetStoreInfo
' Purpose: Retrieves a store's information.
' Return: TRUE or FALSE based on success
' **************************************************************************
Function GetStoreInfo(ByVal pnStore, ByRef psName, ByRef psAddress, ByRef psAddress2, ByRef psCity, ByRef psState, ByRef psPostalCode, ByRef psPhone, ByRef psFax, ByRef psHours)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If IsNumeric(pnStore) Then
		If OpenDatabase(oConn) Then
			' Try exact
			sSQL = "select storename, address1, address2, city, state, postalcode, phone, fax, hours from tblStores where storeid = " & pnStore
			
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
					
					psName = oRS("storename")
					psAddress = oRS("address1")
					psAddress2 = oRS("address2")
					psCity = oRS("city")
					psState = oRS("state")
					psPostalCode = oRS("postalcode")
					psPhone = oRS("phone")
					psFax = oRS("fax")
					psHours = oRS("hours")
				End If
					
				CloseQuery(oRS)
			End If
			
			CloseDatabase(oConn)
		End If
	End If
	
	GetStoreInfo = bRet
End Function

' **************************************************************************
' Function: RegisterCustomer
' Purpose: Stores a customer's information.
' Return: TRUE or FALSE based on success
' **************************************************************************
Function RegisterCustomer(ByVal pnStoreID, ByVal pnOrderID, ByVal psEMail, ByVal psPassword, ByVal psFirstName, ByVal psLastName, ByVal psAddressName, ByVal psAddress, ByVal psApt, ByVal psCity, ByVal psState, ByVal psZipCode, ByVal psPhone, ByVal pnMailList, ByVal pnSMSList, ByVal psDOB, ByVal psSpecInst, ByRef pnAddressID)
	Dim bRet, sSQL, nCustomerID, bAddCustomerAddress, oConn, oRS
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		nCustomerID = GetCustomerID(psEMail)
		
		bAddCustomerAddress = FALSE
		pnAddressID = GetAddressID(psZipCode, psAddress, psApt, psCity, psState)
		If pnAddressID = 0 Then
			pnAddressID = AddAddress(pnStoreID, psAddress, psApt, psCity, psState, psZipCode)
			bAddCustomerAddress = TRUE
		Else
			If nCustomerID = -1 Then
				bAddCustomerAddress = TRUE
			Else
				sSQL = "select CustomerID from trelCustomerAddresses where CustomerID = " & nCustomerID & " and AddressID = " & pnAddressID
				If OpenQuery(oConn, oRS, sSQL) Then
					If Not (Not oRS.bof And Not oRS.eof) Then
						bAddCustomerAddress = TRUE
					End If
						
					CloseQuery(oRS)
				Else
					pnAddressID = 0
				End If
			End If
		End If
		
		If pnAddressID <> 0 Then
			If nCustomerID <> -1 Then
				If Len(psDOB) = 0 Then
					sSQL = "update tblCustomers set PrimaryAddressID = " & pnAddressID & ", password = '" & CleanDBLiteral(MD5(psPassword)) & "', firstname = '" & CleanDBLiteral(psFirstName) & "', lastname = '" & CleanDBLiteral(psLastName) & "', cellphone = '" & CleanDBLiteral(psPhone) & "', isemaillist = " & pnMailList & ", istextlist = " & pnSMSList & ", birthdate = NULL where customerid = " & nCustomerID
				Else
					sSQL = "update tblCustomers set PrimaryAddressID = " & pnAddressID & ", password = '" & CleanDBLiteral(MD5(psPassword)) & "', firstname = '" & CleanDBLiteral(psFirstName) & "', lastname = '" & CleanDBLiteral(psLastName) & "', cellphone = '" & CleanDBLiteral(psPhone) & "', isemaillist = " & pnMailList & ", istextlist = " & pnSMSList & ", birthdate = '" & psDOB & "' where customerid = " & nCustomerID
				End If
			Else
				If Len(psDOB) = 0 Then
					sSQL = "insert into tblCustomers (email, PrimaryAddressID, password, firstname, lastname, cellphone, isemaillist, istextlist) values ('" & CleanDBLiteral(psEMail) & "', " & pnAddressID & ", '" & CleanDBLiteral(MD5(psPassword)) & "', '" & CleanDBLiteral(psFirstName) & "', '" & CleanDBLiteral(psLastName) & "', '" & CleanDBLiteral(psPhone) & "', " & pnMailList & ", " & pnSMSList & ")"
				Else
					sSQL = "insert into tblCustomers (email, PrimaryAddressID, password, firstname, lastname, cellphone, isemaillist, istextlist, birthdate) values ('" & CleanDBLiteral(psEMail) & "', " & pnAddressID & ", '" & CleanDBLiteral(MD5(psPassword)) & "', '" & CleanDBLiteral(psFirstName) & "', '" & CleanDBLiteral(psLastName) & "', '" & CleanDBLiteral(psPhone) & "', " & pnMailList & ", " & pnSMSList & ", '" & CleanDBLiteral(psDOB) & "')"
				End If
			End If
			
			If ExecuteSQL(oConn, sSQL) Then
				nCustomerID = GetCustomerID(psEMail)
				
				If nCustomerID <> -1 Then
					If bAddCustomerAddress Then
						sSQL = "insert into trelCustomerAddresses (CustomerID, AddressID, CustomerAddressDescription, CustomerAddressNotes) values (" & nCustomerID & ", " & pnAddressID & ", '" & CleanDBLiteral(Trim(psAddressName)) & "', "
						If Len(Trim(psSpecInst)) > 0 Then
							sSQL = sSQL & "'" & CleanDBLiteral(Trim(psSpecInst)) & "')"
						Else
							sSQL = sSQL & "NULL)"
						End If
					Else
						sSQL = "update trelCustomerAddresses set CustomerAddressDescription = '" & CleanDBLiteral(Trim(psAddressName)) & "', CustomerAddressNotes = "
						If Len(Trim(psSpecInst)) > 0 Then
							sSQL = sSQL & "'" & CleanDBLiteral(Trim(psSpecInst)) & "' "
						Else
							sSQL = sSQL & "NULL "
						End If
						sSQL = sSQL & "where CustomerID = " & nCustomerID & " and AddressID = " & pnAddressID
					End If
					
					If ExecuteSQL(oConn, sSQL) Then
						If pnOrderID > 0 Then
							If nCustomerID <> -1 Then
								sSQL = "update tblOrders set CustomerID = " & nCustomerID & ", CustomerName = '" & CleanDBLiteral(psFirstName & " " & psLastName) & "', CustomerPhone = '" & CleanDBLiteral(psPhone) & "', OrderNotes = "
								If Len(Trim(psSpecInst)) > 0 Then
									sSQL = sSQL & "'" & CleanDBLiteral(Trim(psSpecInst)) & "' "
								Else
									sSQL = sSQL & "NULL "
								End If
								sSQL = sSQL & "where OrderID = " & pnOrderID
								If ExecuteSQL(oConn, sSQL) Then
									bRet = TRUE
								End If
							End If
						Else
							bRet = TRUE
						End If
					End If
				End If
			End If
		End If
		
		CloseDatabase(oConn)
	End If
	
	RegisterCustomer = bRet
End Function

' **************************************************************************
' Function: GetCustomerID
' Purpose: Retrieves a customer's ID number.
' Return: Customer ID or -1 if not found
' **************************************************************************
Function GetCustomerID(ByVal psEMail)
	Dim nRet, oConn, oRS, sSQL
	
	nRet = -1
	
	If OpenDatabase(oConn) Then
		' Try exact
		sSQL = "select customerid from tblCustomers where email = '" & CleanDBLiteral(psEMail) & "'"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = oRS("customerid")
			End If
				
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetCustomerID = nRet
End Function

' **************************************************************************
' Function: ValidateCustomer
' Purpose: Validates and retrieves a customer's information.
' Return: TRUE or FALSE based on success
' **************************************************************************
Function ValidateCustomer(ByVal psEMail, ByVal psPassword, ByRef pnCustomerID, ByRef psFirstName, ByRef psLastName, ByRef pnAddressID, ByRef psAddressName, ByRef psAddress, ByRef psApt, ByRef psCity, ByRef psState, ByRef psZipCode, ByRef psPhone, ByRef psDOB, ByRef psSpecInst)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		' Try exact
		sSQL = "select tblCustomers.CustomerID, FirstName, LastName, CellPhone, Birthdate, PrimaryAddressID, CustomerAddressDescription, AddressLine1, AddressLine2, City, State, PostalCode, CustomerAddressNotes from tblCustomers inner join trelCustomerAddresses on tblCustomers.CustomerID = trelCustomerAddresses.CustomerID and tblCustomers.PrimaryAddressID = trelCustomerAddresses.AddressID inner join tblAddresses on trelCustomerAddresses.AddressID = tblAddresses.AddressID where EMail = '" & CleanDBLiteral(psEMail) & "' and Password = '" & CleanDBLiteral(MD5(psPassword)) & "'"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				
				pnCustomerID = oRS("CustomerID")
				If IsNull(oRS("FirstName")) Then
					psFirstName = ""
				Else
					psFirstName = oRS("FirstName")
				End If
				If IsNull(oRS("LastName")) Then
					psLastName = ""
				Else
					psLastName = oRS("LastName")
				End If
				pnAddressID = oRS("PrimaryAddressID")
				psAddressName = oRS("CustomerAddressDescription")
				psAddress = oRS("AddressLine1")
				If IsNull(oRS("AddressLine2")) Then
					psApt = ""
				Else
					psApt = oRS("AddressLine2")
				End If
				psCity = oRS("City")
				psState = oRS("State")
				psZipCode = oRS("PostalCode")
				If IsNull(oRS("CellPhone")) Then
					psPhone = ""
				Else
					psPhone = oRS("CellPhone")
				End If
				If IsNull(oRS("Birthdate")) Then
					psDOB = ""
				Else
					psDOB = oRS("Birthdate")
				End If
				If IsNull(oRS("CustomerAddressNotes")) Then
					psSpecInst = ""
				Else
					psSpecInst = oRS("CustomerAddressNotes")
				End If
			End If
				
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidateCustomer = bRet
End Function

Function GetAddressID(ByVal psPostalCode, ByVal psAddress, ByVal psApt, ByVal psCity, ByVal psState)
	Dim nRet, oConn, oRS, sSQL
	
	nRet = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select AddressID from tblAddresses where AddressLine1 = '" & CleanDBLiteral(Trim(psAddress)) & "' and AddressLine2 "
'		If Len(Trim(psApt)) > 0 Then
'			sSQL = sSQL & " = '" & CleanDBLiteral(Trim(psApt)) & "' "
'		Else
'			sSQL = sSQL & " IS NULL "
'		End If
		sSQL = sSQL & " = '" & CleanDBLiteral(Trim(psApt)) & "' "
		sSQL = sSQL & "and City = '" & CleanDBLiteral(Trim(psCity)) & "' and State = '" & CleanDBLiteral(Trim(psState)) & "' and PostalCode = '" & CleanDBLiteral(Trim(psPostalCode)) & "'"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = oRS("AddressID")
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetAddressID = nRet
End Function

Function AddAddress(ByVal pnStoreID, ByVal psAddress1, ByVal psAddress2, ByVal psCity, ByVal psState, ByVal psPostalCode)
	Dim lnRet, oConn, lsSQL, loRS
	
	lnRet = 0
	
	If OpenDatabase(oConn) Then
		lsSQL = "EXEC AddAddress @pStoreID = " & pnStoreID & ", @pAddressLine1 = '" & CleanDBLiteral(psAddress1) & "', @pAddressLine2 = "
'		If Len(Trim(psAddress2)) = 0 Then
'			lsSQL = lsSQL & "NULL"
'		Else
'			lsSQL = lsSQL & "'" & CleanDBLiteral(Trim(psAddress2)) & "'"
'		End If
		lsSQL = lsSQL & "'" & CleanDBLiteral(Trim(psAddress2)) & "'"
		lsSQL = lsSQL & ", @pCity = '" & CleanDBLiteral(Trim(psCity)) & "', @pState = '" & CleanDBLiteral(Trim(psState)) & "', @pPostalCode = '" & CleanDBLiteral(Trim(psPostalCode)) & "', @pAddressNotes = NULL"
		lsSQL = lsSQL & ", @pIsManual = 0"
		If OpenQuery(oConn, loRS, lsSQL) Then
			If Not loRS.bof And Not loRS.eof Then
				lnRet = CLng(loRS(0))
			End If
			
			CloseQuery(loRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	AddAddress = lnRet
End Function

Function ChecksOK(ByVal pnStore)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select checkok from tblStores where storeid = " & pnStore
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				If Not IsNull(oRS("checkok")) Then
					bRet = oRS("checkok")
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	ChecksOK = bRet
End Function

Function GetUnits(ByVal pnStore, ByRef psaUnitName, ByRef pnaUnitNum, ByRef psaUnitDesc, ByRef psaCustomDesc)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaUnitName(0), pnaUnitNum(0)
	psaUnitName(0) = ""
	pnaUnitNum(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select distinct UnitDescription, tblUnit.UnitID, CustomDescription, InternetDescription, UnitMenuSortOrder from tblUnit inner join trelUnitSize on tblUnit.UnitID = trelUnitSize.UnitID inner join trelStoreUnitSize on trelUnitSize.UnitID = trelStoreUnitSize.UnitID and trelUnitSize.SizeID = trelStoreUnitSize.SizeID where StoreID = " & pnStore & " and tblUnit.IsActive <> 0 and tblUnit.IsInternet <> 0 order by UnitMenuSortOrder"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaUnitName(i), pnaUnitNum(i), psaUnitDesc(i), psaCustomDesc(i)
					
					psaUnitName(i) = Trim(oRS("UnitDescription"))
					pnaUnitNum(i) = oRS("UnitID")
					psaUnitDesc(i) = Trim(oRS("InternetDescription"))
					psaCustomDesc(i) = Trim(oRS("CustomDescription"))				
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetUnits = bRet
End Function

Function GetUnitName(ByVal pnStore, ByVal pnUnitNum)
	Dim sRet, oConn, oRS, sSQL
	
	sRet = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select UnitDescription from tblUnit where UnitID = " & pnUnitNum
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				sRet = Trim(oRS("UnitDescription"))
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetUnitName = sRet
End Function

Function GetSpecials(ByVal pnStore, ByVal pnUnitNum, ByRef psaSpecial, ByRef psaSpecialDesc, ByRef psaSpecialID)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaSpecial(0), psaSpecialID(0)
	psaSpecial(0) = ""
	psaSpecialID(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select SpecialtyDescription, InternetDescription, tblSpecialty.SpecialtyID from trelStoreSpecialty inner join tblSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID where StoreID = " & pnStore & " and UnitID = " & pnUnitNum & " and IsActive <> 0 and IsInternet <> 0 order by tblSpecialty.SpecialtyID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaSpecial(i), psaSpecialDesc(i), psaSpecialID(i)
					
					psaSpecial(i) = Trim(oRS("SpecialtyDescription"))
					psaSpecialDesc(i) = Trim(oRS("InternetDescription"))
					psaSpecialID(i) = Trim(oRS("SpecialtyID"))
					
					i = i + 1
					oRS.MoveNext
				Loop
				
				If Len(psaSpecial(0)) > 0 Then
					bRet = TRUE
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetSpecials = bRet
End Function

Function GetFullDescription(ByVal pnStore, ByVal pnUnitNum, ByVal pnSpecialID)
	Dim sRet, oConn, oRS, sSQL, i
	
	sRet = ""
	
	If OpenDatabase(oConn) Then
		If pnSpecialID > 0 Then
			sSQL = "select InternetDescription from tblSpecialty where SpecialtyID = " & pnSpecialID
		Else
			sSQL = "select CustomDescription as InternetDescription from tblUnit where UnitID = " & pnUnitNum
		End If
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				sRet = Trim(oRS("InternetDescription"))
			End If
			
			CloseQuery(oRS)
		End If
	
		CloseDatabase(oConn)
	End If
	
	GetFullDescription = sRet
End Function

Function GetSpecialtyName(ByVal pnStore, ByVal pnUnitNum, ByVal pnSpecialID)
	Dim sRet, oConn, oRS, sSQL, i
	
	sRet = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select SpecialtyDescription from trelStoreSpecialty inner join tblSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID where StoreID = " & pnStore & " and trelStoreSpecialty.SpecialtyID = " & pnSpecialID & " and UnitID = " & pnUnitNum & " and IsActive <> 0 order by tblSpecialty.SpecialtyID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				sRet = Trim(oRS("SpecialtyDescription"))
			End If
			
			CloseQuery(oRS)
		End If
	
		CloseDatabase(oConn)
	End If
	
	GetSpecialtyName = sRet
End Function

Function GetSpecialtyInfo(ByVal pnStore, ByVal pnUnitNum, ByVal psSpecialty, ByRef psDescription)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	psDescription = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select InternetDescription from trelStoreSpecialty inner join tblSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID where StoreID = " & pnStore & " and trelStoreSpecialty.SpecialtyID = " & psSpecialty & " and UnitID = " & pnUnitNum & " and IsActive <> 0 order by tblSpecialty.SpecialtyID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				
				psDescription = Trim(oRS("InternetDescription"))
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetSpecialtyInfo = bRet
End Function

Function GetItems(ByVal pnStore, ByVal pnUnitNum, ByRef psaItemName, ByRef pnaItemNum, ByRef pbAllowHalf)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	pbAllowHalf = FALSE
	
	ReDim psaItemName(0), pnaItemNum(0)
	psaItemName(0) = ""
	pnaItemNum(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select tblItems.ItemID, ItemDescription, ItemCount, FreeItemFlag, AllowHalfItems from trelStoreItem inner join tblItems on trelStoreItem.ItemID = tblItems.ItemID inner join trelUnitItems on tblItems.ItemID = trelUnitItems.ItemID inner join tblUnit on trelUnitItems.UnitID = tblUnit.UnitID where StoreID = " & pnStore & " and trelUnitItems.UnitID = " & pnUnitNum & " and tblItems.IsActive <> 0 and tblItems.IsInternet <> 0 and IsBaseCheese = 0 order by ItemDescription"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			
			If Not oRS.bof And Not oRS.eof Then
				pbAllowHalf = oRS("AllowHalfItems")
				
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaItemName(i), pnaItemNum(i)
					
					psaItemName(i) = Trim(oRS("ItemDescription"))
					If oRS("ItemCount") > 1 Then
						psaItemName(i) = psaItemName(i) & " - " & oRS("ItemCount") & " toppings"
					End If
					If oRS("FreeItemFlag") Then
						psaItemName(i) = psaItemName(i) & " *"
					End If
					pnaItemNum(i) = oRS("ItemID")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetItems = bRet
End Function

Function GetBaseCheese(ByVal pnStore, ByVal pnUnitNum, ByRef psItemList, ByRef psItemListName, ByRef psItemListNum)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select tblItems.ItemID, ItemDescription from trelStoreItem inner join tblItems on trelStoreItem.ItemID = tblItems.ItemID inner join trelUnitItems on tblItems.ItemID = trelUnitItems.ItemID inner join tblUnit on trelUnitItems.UnitID = tblUnit.UnitID where StoreID = " & pnStore & " and trelUnitItems.UnitID = " & pnUnitNum & " and tblItems.IsActive <> 0 and tblItems.IsInternet <> 0 and IsBaseCheese <> 0 order by ItemDescription"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			
			If Not oRS.bof And Not oRS.eof Then
				If Len(psItemList) = 0 Then
					psItemList = oRS("ItemDescription")
					psItemListName = oRS("ItemDescription")
					psItemListNum = oRS("ItemID")
				Else
					psItemList = psItemList & ", " & oRS("ItemDescription")
					psItemListName = psItemListName & ", " & oRS("ItemDescription")
					psItemListNum = psItemListNum & "," & oRS("ItemID")
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetBaseCheese = bRet
End Function

Function IsNoBaseCheese(ByVal pnUnitID, ByVal pnSpecialtyID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select NoBaseCheese from tblSpecialty where UnitID = " & pnUnitID & " and SpecialtyID = " & pnSpecialtyID
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				If oRS("NoBaseCheese") <> 0 Then
					bRet = TRUE
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	IsNoBaseCheese = bRet
End Function

Function GetItemName(ByRef poConn, ByVal pnStore, ByVal pnUnitNum, ByVal pnItemNum)
	Dim sRet, oRS, sSQL
	
	sRet = ""
	
	sSQL = "select ItemDescription, ItemCount, FreeItemFlag from tblItems where ItemID = " & pnItemNum
	
	If OpenQuery(poConn, oRS, sSQL) Then
		If Not oRS.bof And Not oRS.eof Then
			sRet = Trim(oRS("ItemDescription"))
			If oRS("ItemCount") > 1 Then
				sRet = sRet & " - " & oRS("ItemCount") & " toppings"
			End If
			If oRS("FreeItemFlag") Then
				sRet = sRet & " *"
			End If
		End If
		
		CloseQuery(oRS)
	End If
	
	GetItemName = sRet
End Function

Function GetIncludedSideCount(ByRef poConn, ByVal pnStore, ByVal pnUnitNum)
	Dim nRet, oRS, oRS2, sSQL, sTable
	
	nRet = 0
	
	sSQL = "select sum(Quantity) as Quantity from trelStoreUnitSize inner join trelUnitSizeSideGroup on trelStoreUnitSize.SizeID = trelUnitSizeSideGroup.SizeID and trelStoreUnitSize.UnitID = trelUnitSizeSideGroup.UnitID where StoreID = " & pnStore & " and trelStoreUnitSize.UnitID = " & pnUnitNum
	
	If OpenQuery(poConn, oRS, sSQL) Then
		If Not oRS.bof And Not oRS.eof Then
			nRet = oRS("Quantity")
		End If
		
		CloseQuery(oRS)
	End If
	
	GetIncludedSideCount = nRet
End Function

Function GetDefaultItems(ByVal pnStore, ByVal pnUnitNum, ByVal psSpecialty, ByRef psaItemName, ByRef pnaItemNum)
	Dim bRet, oConn, oRS, sSQL, i, nCount, j, nPos, sSides, sSide
	
	bRet = FALSE
	
	ReDim psaItemName(0), psaItemNum(0)
	psaItemName(0) = ""
	psaItemNum(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select tblItems.ItemID, ItemDescription, ItemCount, FreeItemFlag, SpecialtyItemQuantity from trelStoreSpecialty inner join tblSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID inner join trelSpecialtyItem on tblSpecialty.SpecialtyID = trelSpecialtyItem.SpecialtyID inner join tblItems on trelSpecialtyItem.ItemID = tblItems.ItemID inner join trelStoreItem on trelStoreSpecialty.StoreID = trelStoreItem.StoreID and tblItems.ItemID = trelStoreItem.ItemID inner join trelUnitItems on tblSpecialty.UnitID = trelUnitItems.UnitID and tblItems.ItemID = trelUnitItems.ItemID where trelStoreSpecialty.StoreID = " & pnStore & " and tblSpecialty.UnitID = " & pnUnitNum & " and trelStoreSpecialty.SpecialtyID = " & psSpecialty & " and tblItems.IsActive <> 0 order by ItemDescription"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				nPos = 0
				
				Do While Not oRS.eof
					For i = 1 To oRS("SpecialtyItemQuantity")
						ReDim Preserve psaItemName(nPos), pnaItemNum(nPos)
						
						pnaItemNum(nPos) = oRS("ItemID")
						psaItemName(nPos) = Trim(oRS("ItemDescription"))
						If oRS("ItemCount") > 1 Then
							psaItemName(nPos) = psaItemName(nPos) & " - " & oRS("ItemCount") & " toppings"
						End If
						If oRS("FreeItemFlag") Then
							psaItemName(nPos) = psaItemName(nPos) & " *"
						End If
						
						nPos = nPos + 1
					Next
					
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetDefaultItems = bRet
End Function

Function GetUnitSizes(ByVal pnStore, ByVal pnUnitNum, ByRef psaUnitSize, ByRef pnaUnitSizeNum)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaUnitSize(0), pnaUnitSizeNum(0)
	psaUnitSize(0) = ""
	pnaUnitSizeNum(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select tblSizes.SizeID, SizeDescription from trelStoreUnitSize inner join tblSizes on trelStoreUnitSize.SizeID = tblSizes.SizeID where StoreID = " & pnStore & " and UnitID = " & pnUnitNum & " and IsActive <> 0 order by tblSizes.SizeID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaUnitSize(i), pnaUnitSizeNum(i)
					
					psaUnitSize(i) = Trim(oRS("SizeDescription"))
					pnaUnitSizeNum(i) = oRS("SizeID")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetUnitSizes = bRet
End Function

Function GetSizeName(ByRef poConn, ByVal pnStore, ByVal pnUnitNum, ByVal pnSize)
	Dim sRet, oRS, sSQL, sField
	
	sRet = ""
	
	sSQL = "select SizeDescription from tblSizes where SizeID = " & pnSize
	
	If OpenQuery(poConn, oRS, sSQL) Then
		If Not oRS.bof And Not oRS.eof Then
			sRet = Trim(oRS("SizeDescription"))
		End If
		
		CloseQuery(oRS)
	End If
	
	GetSizeName = sRet
End Function

Function GetSides(ByVal pnStore, ByVal pnUnitNum, ByRef psaSide, ByRef psaSideID)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaSide(0), psaSideID(0)
	psaSide(0) = ""
	psaSideID(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select tblSides.SideID, SideDescription, SidePrice from trelStoreSides inner join trelUnitSides on trelStoreSides.SideID = trelUnitSides.SideID and trelUnitSides.UnitID = " & pnUnitNum & " inner join tblSides on trelUnitSides.SideID = tblSides.SideID where StoreID = " & pnStore & " and IsActive <> 0 order by tblSides.SideID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			
			If Not oRS.bof And Not oRS.eof Then
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaSide(i), psaSideID(i)
					
					psaSide(i) = Trim(oRS("SideDescription")) & " " & FormatCurrency(oRS("SidePrice"))
					psaSideID(i) = oRS("SideID")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetSides = bRet
End Function

Function GetDefaultSides(ByVal pnStore, ByVal pnUnitNum, ByVal pnSizeID, ByRef psaDefaultSideID, ByRef pnaDefaultSideCount)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaDefaultSideID(0), pnaDefaultSideCount(0)
	psaDefaultSideID(0) = 0
	pnaDefaultSideCount(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select SideGroupID, Quantity from trelStoreUnitSize inner join trelUnitSizeSideGroup on trelStoreUnitSize.SizeID = trelUnitSizeSideGroup.SizeID and trelStoreUnitSize.UnitID = trelUnitSizeSideGroup.UnitID where StoreID = " & pnStore & " and trelStoreUnitSize.UnitID = " & pnUnitNum & " and trelStoreUnitSize.SizeID = " & pnSizeID & " order by trelUnitSizeSideGroup.SideGroupID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			i = 0
			
			If Not oRS.bof And Not oRS.eof Then
				Do While Not oRS.eof
					ReDim Preserve psaDefaultSideID(i), pnaDefaultSideCount(i)
					
					psaDefaultSideID(i) = oRS("SideGroupID")
					pnaDefaultSideCount(i) = oRS("Quantity")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetDefaultSides = bRet
End Function

Function GetSpecialtySides(ByVal pnStore, ByVal pnUnitNum, ByVal pnSizeID, ByVal psSpecialty, ByRef psaDefaultSideID, ByRef pnaDefaultSideCount)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaDefaultSideID(0), pnaDefaultSideCount(0)
	psaDefaultSideID(0) = 0
	pnaDefaultSideCount(0) = 0
	
	If psSpecialty = 0 Then
		bRet = TRUE
	Else
		If OpenDatabase(oConn) Then
			sSQL = "select SideGroupID, Quantity from trelStoreSpecialty inner join tblSpecialty on trelStoreSpecialty.SpecialtyID = tblSpecialty.SpecialtyID inner join trelSpecialtySizeSideGroup on tblSpecialty.SpecialtyID = trelSpecialtySizeSideGroup.SpecialtyID where StoreID = " & pnStore & " and trelStoreSpecialty.SpecialtyID = " & psSpecialty & " and UnitID = " & pnUnitNum & " and SizeID = " & pnSizeID & " and IsActive <> 0 order by trelSpecialtySizeSideGroup.SideGroupID"
			
			If OpenQuery(oConn, oRS, sSQL) Then
				bRet = TRUE
				i = 0
				
				If Not oRS.bof And Not oRS.eof Then
					Do While Not oRS.eof
						ReDim Preserve psaDefaultSideID(i), pnaDefaultSideCount(i)
						
						psaDefaultSideID(i) = oRS("SideGroupID")
						pnaDefaultSideCount(i) = oRS("Quantity")
						
						i = i + 1
						oRS.MoveNext
					Loop
				End If
				
				CloseQuery(oRS)
			End If
			
			CloseDatabase(oConn)
		End If
	End If
	
	GetSpecialtySides = bRet
End Function

Function GetSideGroups(ByVal pnStore, ByVal pnUnitNum, ByRef psaSideGroup, ByRef psaSideGroupID, ByRef saSideGroupSide, ByRef naSideGroupSideID, ByRef baSideGroupSideIsDefault)
	Dim bRet, oConn, loRS, sSQL, lnPos, lnSideGroupID, lnPos2, lnPos2Max, i
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select distinct tblSideGroup.SideGroupID, SideGroupDescription, tblSides.SideID, SideDescription, IsDefault from tblSideGroup inner join trelSideGroupSides on tblSideGroup.SideGroupID = trelSideGroupSides.SideGroupID inner join tblSides on trelSideGroupSides.SidesID = tblSides.SideID and tblSideGroup.IsActive <> 0 and tblSides.IsActive <> 0 order by tblSideGroup.SideGroupID, tblSides.SideID"
		
		If OpenQuery(oConn, loRS, sSQL) Then
			bRet = TRUE
			
			If Not loRS.bof And Not loRS.eof Then
				lnPos = -1
				lnPos2 = 0
				lnPos2Max = -1
				lnSideGroupID = 0
				
				Do While Not loRS.eof
					If loRS("SideGroupID") <> lnSideGroupID Then
						lnPos = lnPos + 1
						lnSideGroupID = loRS("SideGroupID")
						lnPos2 = 0
					End If
					
					If lnPos2 > lnPos2Max Then
						lnPos2Max = lnPos2
					End If
					
					lnPos2 = lnPos2 + 1
					loRS.MoveNext
				Loop
				
				ReDim Preserve psaSideGroup(lnPos), psaSideGroupID(lnPos), saSideGroupSide(lnPos, lnPos2Max), naSideGroupSideID(lnPos, lnPos2Max), baSideGroupSideIsDefault(lnPos, lnPos2Max)
				lnPos = -1
				lnPos2 = 0
				lnSideGroupID = 0
				
				loRS.Requery
				Do While Not loRS.eof
					If loRS("SideGroupID") <> lnSideGroupID Then
						If lnPos <> -1 And lnPos2 <= lnPos2Max Then
							For i = lnPos2 To lnPos2Max
								naSideGroupSideID(lnPos, i) = 0
								saSideGroupSide(lnPos, i) = ""
								baSideGroupSideIsDefault(lnPos, i) = FALSE
							Next
						End If
						
						lnPos = lnPos + 1
						lnSideGroupID = loRS("SideGroupID")
						lnPos2 = 0
						
						psaSideGroupID(lnPos) = loRS("SideGroupID")
						If IsNull(loRS("SideGroupDescription")) Then
							psaSideGroup(lnPos) = ""
						Else
							psaSideGroup(lnPos) = Trim(loRS("SideGroupDescription"))
						End If
					End If
					
					naSideGroupSideID(lnPos, lnPos2) = loRS("SideID")
					If IsNull(loRS("SideDescription")) Then
						saSideGroupSide(lnPos, lnPos2) = ""
					Else
						saSideGroupSide(lnPos, lnPos2) = Trim(loRS("SideDescription"))
					End If
					baSideGroupSideIsDefault(lnPos, lnPos2) = loRS("IsDefault")
					
					lnPos2 = lnPos2 + 1
					loRS.MoveNext
				Loop
				
				For i = lnPos2 To lnPos2Max
					naSideGroupSideID(lnPos, i) = 0
					saSideGroupSide(lnPos, i) = ""
					baSideGroupSideIsDefault(lnPos, i) = FALSE
				Next
			Else
				ReDim psaSideGroup(0), psaSideGroupID(0), saSideGroupSide(0, 0), naSideGroupSideID(0, 0), baSideGroupSideIsDefault(0, 0)
				psaSideGroup(0) = ""
				psaSideGroupID(0) = 0
				saSideGroupSide(0, 0) = ""
				naSideGroupSideID(0, 0) = 0
				baSideGroupSideIsDefault(0, 0) = FALSE
			End If
			
			CloseQuery(loRS)
		Else
			ReDim psaSideGroup(0), psaSideGroupID(0), saSideGroupSide(0, 0), naSideGroupSideID(0, 0), baSideGroupSideIsDefault(0, 0)
			psaSideGroup(0) = ""
			psaSideGroupID(0) = 0
			saSideGroupSide(0, 0) = ""
			naSideGroupSideID(0, 0) = 0
			baSideGroupSideIsDefault(0, 0) = FALSE
		End If
		
		CloseDatabase(oConn)
	Else
		ReDim psaSideGroup(0), psaSideGroupID(0), saSideGroupSide(0, 0), naSideGroupSideID(0, 0), baSideGroupSideIsDefault(0, 0)
		psaSideGroup(0) = ""
		psaSideGroupID(0) = 0
		saSideGroupSide(0, 0) = ""
		naSideGroupSideID(0, 0) = 0
		baSideGroupSideIsDefault(0, 0) = FALSE
	End If
	
	GetSideGroups = bRet
End Function

Function GetSideName(ByRef poConn, ByVal pnStore, ByVal pnUnitNum, ByVal pnSideNum)
	Dim sRet, oRS, sSQL
	
	sRet = ""
	
	sSQL = "select SideDescription from tblSides where SideID = " & pnSideNum
	
	If OpenQuery(poConn, oRS, sSQL) Then
		If Not oRS.bof And Not oRS.eof Then
			sRet = Trim(oRS("SideDescription"))
		End If
		
		CloseQuery(oRS)
	End If
	
	GetSideName = sRet
End Function

Function GetCrusts(ByVal pnStore, ByVal pnUnitNum, ByVal pnSize, ByRef psaCrust, ByRef pnaCrustNum, ByRef pnaCrustPrice)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaCrust(0), pnaCrustNum(0)
	psaCrust(0) = ""
	pnaCrustNum(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select tblStyles.StyleID, StyleDescription, StyleSurcharge from trelStoreSizeStyle inner join trelSizeStyle on trelStoreSizeStyle.StyleID = trelSizeStyle.StyleID and trelStoreSizeStyle.SizeID = trelSizeStyle.SizeID inner join tblStyles on trelSizeStyle.StyleID = tblStyles.StyleID inner join trelUnitStyles on tblStyles.StyleID = trelUnitStyles.StyleID  where StoreID = " & pnStore & " and UnitID = " & pnUnitNum & " and trelStoreSizeStyle.SizeID = " & pnSize & " and IsActive <> 0"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			
			If Not oRS.bof And Not oRS.eof Then
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaCrust(i), pnaCrustNum(i), pnaCrustPrice(i)
					
					psaCrust(i) = Trim(oRS("StyleDescription"))
					pnaCrustNum(i) = oRS("StyleID")
					pnaCrustPrice(i) = oRS("StyleSurcharge")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetCrusts = bRet
End Function

Function GetCrustName(ByRef poConn, ByVal pnStore, ByVal pnUnitNum, ByVal pnCrust)
	Dim sRet, oRS, sSQL, sField
	
	sRet = ""
	
	sSQL = "select StyleDescription from tblStyles where StyleID = " & pnCrust
	
	If OpenQuery(poConn, oRS, sSQL) Then
		If Not oRS.bof And Not oRS.eof Then
			sRet = Trim(oRS("StyleDescription"))
		End If
		
		CloseQuery(oRS)
	End If
	
	GetCrustName = sRet
End Function

Function GetDefaultCrust(ByVal pnStore, ByVal pnUnitNum, ByVal psSpecialty)
	Dim nRet, oConn, oRS, sSQL, i
	
	nRet = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select StyleID from tblSpecialty where SpecialtyID = " & psSpecialty
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = oRS("StyleID")
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetDefaultCrust = nRet
End Function

Function GetSauces(ByVal pnStore, ByVal pnUnitNum, ByRef psaSauce, ByRef pnaSauceNum)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaSauce(0), pnaSauceNum(0)
	psaSauce(0) = ""
	pnaSauceNum(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select distinct tblSauce.SauceID, SauceDescription from trelStoreUnitSize inner join trelUnitSauce on trelStoreUnitSize.UnitID = trelUnitSauce.UnitID inner join tblSauce on trelUnitSauce.SauceID = tblSauce.SauceID where StoreID = " & pnStore & " and trelStoreUnitSize.UnitID = " & pnUnitNum & " and IsActive <> 0 and IsInternet <> 0 order by tblSauce.SauceID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			
			If Not oRS.bof And Not oRS.eof Then
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaSauce(i), pnaSauceNum(i)
					
					psaSauce(i) = Trim(oRS("SauceDescription"))
					pnaSauceNum(i) = oRS("SauceID")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetSauces = bRet
End Function

Function GetSauceModifiers(ByVal pnStore, ByVal pnUnitNum, ByRef psaSauceModifier, ByRef pnaSauceModifierNum)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaSauceModifier(0), pnaSauceModifierNum(0)
	psaSauceModifier(0) = ""
	pnaSauceModifierNum(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select SauceModifierID, SauceModifierDescription from tblSauceModifier where IsActive <> 0 order by SauceModifierID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			
			If Not oRS.bof And Not oRS.eof Then
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaSauceModifier(i), pnaSauceModifierNum(i)
					
					psaSauceModifier(i) = Trim(oRS("SauceModifierDescription"))
					pnaSauceModifierNum(i) = oRS("SauceModifierID")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetSauceModifiers = bRet
End Function

Function GetSauceName(ByRef poConn, ByVal pnStore, ByVal pnUnitNum, ByVal pnSauce)
	Dim sRet, oRS, sSQL, sField
	
	sRet = ""
	
	sSQL = "select SauceDescription from tblSauce where SauceID = " & pnSauce
	
	If OpenQuery(poConn, oRS, sSQL) Then
		If Not oRS.bof And Not oRS.eof Then
			sRet = Trim(oRS("SauceDescription"))
		End If
		
		CloseQuery(oRS)
	End If
	
	GetSauceName = sRet
End Function

Function GetDefaultSauce(ByVal pnStore, ByVal pnUnitNum, ByVal psSpecialty)
	Dim nRet, oConn, oRS, sSQL, i
	
	nRet = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select SauceID from tblSpecialty where SpecialtyID = " & psSpecialty
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = oRS("SauceID")
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetDefaultSauce = nRet
End Function

Function GetToppers(ByVal pnStore, ByVal pnUnitNum, ByRef psaTopper, ByRef pnaTopperNum)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim psaTopper(0), pnaTopperNum(0)
	psaTopper(0) = ""
	pnaTopperNum(0) = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select distinct tblTopper.TopperID, TopperDescription from trelStoreUnitSize inner join trelUnitTopper on trelStoreUnitSize.UnitID = trelUnitTopper.UnitID inner join tblTopper on trelUnitTopper.TopperID = tblTopper.TopperID where StoreID = " & pnStore & " and trelStoreUnitSize.UnitID = " & pnUnitNum & " and IsActive <> 0 order by tblTopper.TopperID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			
			If Not oRS.bof And Not oRS.eof Then
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve psaTopper(i), pnaTopperNum(i)
					
					psaTopper(i) = Trim(oRS("TopperDescription"))
					pnaTopperNum(i) = oRS("TopperID")
					
					i = i + 1
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetToppers = bRet
End Function

Function CreateOrder(ByVal pnStore, ByVal pnCustomerID, ByVal pnOrderType, ByVal pdDelivery, ByVal pdDrMoney, ByVal psCustomerName, ByVal psCustomerPhone, ByVal pnAddressID, ByVal psOrderNotes)
	Dim nRet, oConn, oRS, oRS2, lsSQL, lsTransactionDate
	
	nRet = 0
	
	If OpenDatabase(oConn) Then
		lsSQL = "Select top 1 CurrentStatus, ReportDate from tblStoreReportDate where StoreID = " & pnStore & " Order by RADRAT DESC"
		If OpenQuery(oConn, oRS, lsSQL) Then
			If Not oRS.BOF And Not oRS.EOF Then
				If Trim(oRS("CurrentStatus")) <> "Closed" Then
					lsTransactionDate = Left(oRS("ReportDate"), 10)
			
					lsSQL = "EXEC AddOrder @pSessionID = " & Session.SessionID & ", @pIPAddress = '" & Request.ServerVariables("REMOTE_ADDR") & "', @pEmpID = 1, @pRefID = "
					If Len(Trim(Session("RefID"))) = 0 Then
						lsSQL = lsSQL & "NULL"
					Else
						lsSQL = lsSQL & "'" & CleanDBLiteral(Trim(Session("RefID"))) & "'"
					End If
					lsSQL = lsSQL & ", @pTransactionDate = '" & lsTransactionDate & "', @pStoreID = " & pnStore & ", @pCustomerID = " & pnCustomerID & ", @pCustomerName = "
					If Len(Trim(psCustomerName)) = 0 Then
						lsSQL = lsSQL & "NULL"
					Else
						lsSQL = lsSQL & "'" & CleanDBLiteral(Trim(psCustomerName)) & "'"
					End If
					lsSQL = lsSQL & ", @pCustomerPhone = "
					If Len(Trim(psCustomerPhone)) = 0 Then
						lsSQL = lsSQL & "NULL"
					Else
						lsSQL = lsSQL & "'" & CleanDBLiteral(Trim(psCustomerPhone)) & "'"
					End If
					lsSQL = lsSQL & ", @pAddressID = " & pnAddressID & ", @pOrderTypeID = " & pnOrderType & ", @pDeliveryCharge = " & pdDelivery & ", @pDriverMoney = " & pdDrMoney & ", @pOrderNotes = "
					If Len(Trim(psOrderNotes)) = 0 Then
						lsSQL = lsSQL & "NULL"
					Else
						lsSQL = lsSQL & "'" & CleanDBLiteral(Trim(psOrderNotes)) & "'"
					End If
					
					If OpenQuery(oConn, oRS2, lsSQL) Then
						If Not oRS2.bof And Not oRS2.eof Then
							nRet = CLng(oRS2(0))
						End If
						
						CloseQuery(oRS2)
					End If
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	CreateOrder = nRet
End Function

Function SetOrderType(ByVal pnOrderID, ByVal pnStore, ByVal pnOrderType, ByVal pdDelivery, ByVal pdDrMoney)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "update tblOrders set StoreID = " & pnStore & ", OrderTypeID = " & pnOrderType & ", DeliveryCharge = " & pdDelivery & ", DriverMoney = " & pdDrMoney & " where OrderID = " & pnOrderID
		
		If ExecuteSQL(oConn, sSQL) Then
			bRet = TRUE
		End If
		
		CloseDatabase(oConn)
	End If
	
	SetOrderType = bRet
End Function

Function SetOrderAddress(ByVal pnOrderID, ByVal pnAddressID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "update tblOrders set AddressID = " & pnAddressID & " where OrderID = " & pnOrderID
		
		If ExecuteSQL(oConn, sSQL) Then
			bRet = TRUE
		End If
		
		CloseDatabase(oConn)
	End If
	
	SetOrderAddress = bRet
End Function

Function AddToOrder(ByVal pnOrderID, ByVal pnQty, ByVal psDescription, ByVal pnUnitNum, ByVal psSpecialty, ByVal pnSize, ByVal pnCrust, ByVal pnSauceWhole, ByVal pnSauceHalf1, ByVal pnSauceHalf2, ByVal pnSauceModifierWhole, ByVal pnSauceModifierHalf1, ByVal pnSauceModifierHalf2, ByVal psTopWhole, ByVal psTopH1, ByVal psTopH2, ByVal psCrustTop, ByVal psIncludeSide, ByVal psAddSide, ByVal psNotes)
	Dim bRet, oConn, oRS, lsSQL, nOrderLineID, i, j, aItemsWhole, aItemsHalf1, aItemsHalf2, aToppers, aInclSides, aAddSides, bOK
	
	bRet = FALSE
	bOK = TRUE
	
	If OpenDatabase(oConn) Then
		For j = 1 To pnQty
			If bOK Then
				lsSQL = "EXEC AddOrderLine @pOrderID = " & pnOrderID & ", @pUnitID = " & pnUnitNum & ", @pSpecialtyID = "
				If psSpecialty = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & psSpecialty
				End If
				lsSQL = lsSQL & ", @pSizeID = "
				If pnSize = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & pnSize
				End If
				lsSQL = lsSQL & ", @pStyleID = "
				If pnCrust = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & pnCrust
				End If
				lsSQL = lsSQL & ", @pHalf1SauceID = "
				If pnSauceWhole = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & pnSauceWhole
				End If
				lsSQL = lsSQL & ", @pHalf2SauceID = "
				If pnSauceWhole = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & pnSauceWhole
				End If
				lsSQL = lsSQL & ", @pHalf1SauceModifierID = "
				If pnSauceModifierWhole = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & pnSauceModifierWhole
				End If
				lsSQL = lsSQL & ", @pHalf2SauceModifierID = "
				If pnSauceModifierWhole = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & pnSauceModifierWhole
				End If
				lsSQL = lsSQL & ", @pOrderLineNotes = "
				If Len(Trim(psNotes)) = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & "'" & CleanDBLiteral(Trim(psNotes)) & "'"
				End If
				lsSQL = lsSQL & ", @pQuantity = 1, @pInternetDescription = "
				If Len(Trim(psDescription)) = 0 Then
					lsSQL = lsSQL & "NULL"
				Else
					lsSQL = lsSQL & "'" & CleanDBLiteral(Trim(psDescription)) & "'"
				End If
				
				bOK = FALSE
				If OpenQuery(oConn, oRS, lsSQL) Then
					If Not oRS.bof And Not oRS.eof Then
						nOrderLineID = CLng(oRS(0))
						bOK = TRUE
					End If
					
					CloseQuery(oRS)
				End If
			End If
			
			If bOK Then
				If Len(Trim(psTopWhole)) > 0 Then
					bOK = FALSE
					aItemsWhole = Split(psTopWhole, ",")
					For i = 0 To UBound(aItemsWhole)
						If Len(Trim(aItemsWhole(i))) > 0 Then
							lsSQL = "EXEC AddOrderLineItem @pOrderLineID = " & nOrderLineID & ", @pItemID = " & aItemsWhole(i) & ", @pHalfID = 0"
							If ExecuteSQL(oConn, lsSQL) Then
								bOK = TRUE
							End If
						Else
							bOK = TRUE
						End If
					Next
				End If
			End If
			
			If bOK Then
				If Len(Trim(psTopH1)) > 0 Then
					bOK = FALSE
					aItemsHalf1 = Split(psTopH1, ",")
					For i = 0 To UBound(aItemsHalf1)
						If Len(Trim(aItemsHalf1(i))) > 0 Then
							lsSQL = "EXEC AddOrderLineItem @pOrderLineID = " & nOrderLineID & ", @pItemID = " & aItemsHalf1(i) & ", @pHalfID = 1"
							If ExecuteSQL(oConn, lsSQL) Then
								bOK = TRUE
							End If
						Else
							bOK = TRUE
						End If
					Next
				End If
			End If
			
			If bOK Then
				If Len(Trim(psTopH2)) > 0 Then
					bOK = FALSE
					aItemsHalf2 = Split(psTopH2, ",")
					For i = 0 To UBound(aItemsHalf2)
						If Len(Trim(aItemsHalf2(i))) > 0 Then
							lsSQL = "EXEC AddOrderLineItem @pOrderLineID = " & nOrderLineID & ", @pItemID = " & aItemsHalf2(i) & ", @pHalfID = 2"
							If ExecuteSQL(oConn, lsSQL) Then
								bOK = TRUE
							End If
						Else
							bOK = TRUE
						End If
					Next
				End If
			End If
			
			If bOK Then
				If Len(Trim(psCrustTop)) > 0 Then
					bOK = FALSE
					aToppers = Split(psCrustTop, ",")
					For i = 0 To UBound(aToppers)
						If Len(Trim(aToppers(i))) > 0 Then
							lsSQL = "EXEC AddOrderLineTopper @pOrderLineID = " & nOrderLineID & ", @pTopperID = " & aToppers(i) & ", @pTopperHalfID = 0"
							If ExecuteSQL(oConn, lsSQL) Then
								bOK = TRUE
							End If
						Else
							bOK = TRUE
						End If
					Next
				End If
			End If
			
			If bOK Then
				If Len(Trim(psIncludeSide)) > 0 Then
					bOK = FALSE
					aInclSides = Split(psIncludeSide, ",")
					For i = 0 To UBound(aInclSides)
						If Len(Trim(aInclSides(i))) > 0 Then
							lsSQL = "EXEC AddOrderLineSide @pOrderLineID = " & nOrderLineID & ", @pSideID = " & aInclSides(i) & ", @pIsFreeSide = 1"
							If ExecuteSQL(oConn, lsSQL) Then
								bOK = TRUE
							End If
						Else
							bOK = TRUE
						End If
					Next
				End If
			End If
			
			If bOK Then
				If Len(Trim(psAddSide)) > 0 Then
					bOK = FALSE
					aAddSides = Split(psAddSide, ",")
					For i = 0 To UBound(aAddSides)
						If Len(Trim(aAddSides(i))) > 0 Then
							lsSQL = "EXEC AddOrderLineSide @pOrderLineID = " & nOrderLineID & ", @pSideID = " & aAddSides(i) & ", @pIsFreeSide = 0"
							If ExecuteSQL(oConn, lsSQL) Then
								bOK = TRUE
							End If
						Else
							bOK = TRUE
						End If
					Next
				End If
			End If
		Next
		
		bRet = bOK
		
		CloseDatabase(oConn)
	End If
	
	AddToOrder = bRet
End Function
	
Function GetPricing(ByVal pnStore, ByVal pnOrderID, ByVal psPromoCodes, ByVal psPromos)
	Dim bRet, oConn, lsSQL, oRS
	
	bRet = FALSE
	If OpenDatabase(oConn) Then
		lsSQL = "EXEC WebRecalculateOrderPrice @pStoreID = " & pnStore & ", @pOrderID = " & pnOrderID & ", @pCouponIDs = '" & CleanDBLiteral(psPromos) & "', @pPromoCodes = '" & CleanDBLiteral(psPromoCodes) & "'"
		If OpenQuery(oConn, oRS, lsSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				If oRS(0) = "SUCCESS" Then
					bRet = TRUE
				End If
			End If
			
			CloseQuery(oRS)
		End If
	End If
	
	GetPricing = bRet
End Function

Function GetOrder(ByVal pnOrderID, ByRef pdDelivery, ByRef pdDrMoney, ByRef pdTax, ByRef pdTip)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	pdDelivery = 0.00
	pdDrMoney = 0.00
	pdTax = 0.00
	pdTip = 0.00
	
	If OpenDatabase(oConn) Then
		sSQL = "select DeliveryCharge, DriverMoney, Tax + Tax2 as TotalTax, Tip from tblOrders where OrderID = " & pnOrderID
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				
				pdDelivery = oRS("DeliveryCharge")
				pdDrMoney = oRS("DriverMoney")
				If IsNull(oRS("TotalTax")) Then
					pdTax = 0.00
				Else
					pdTax = oRS("TotalTax")
				End If
				If IsNull(oRS("Tip")) Then
					pdTip = 0.00
				Else
					pdTip = oRS("Tip")
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetOrder = bRet
End Function

Function GetOrderItemCount(ByVal pnOrderID)
	Dim nRet, oConn, oRS, sSQL
	
	nRet = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select count(*) as numitems from tblOrderLines where OrderID = " & pnOrderID
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = oRS("numitems")
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetOrderItemCount = nRet
End Function

Function GetOrderItems(ByVal pnOrderID, ByRef pnaOrderItemID, ByRef pnaQty, ByRef psaDescription, ByRef pdaPrice)
	Dim bRet, oConn, oRS, sSQL, i
	
	bRet = FALSE
	
	ReDim pnaOrderItemID(0), pnaQty(0), psaDescription(0), pdaPrice(0)
	pnaOrderItemID(0) = 0
	psaDescription(0) = ""
	pdaPrice(0) = 0.00
	
	If OpenDatabase(oConn) Then
		sSQL = "select OrderLineID, Quantity, Cost, Discount, InternetDescription from tblOrderLines where OrderID = " & pnOrderID & " order by OrderLineID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve pnaOrderItemID(i), pnaQty(i), psaDescription(i), pdaPrice(i)
					
					pnaQty(i) = oRS("Quantity")
					pnaOrderItemID(i) = oRS("OrderLineID")
					psaDescription(i) = oRS("InternetDescription")
					If IsNull(oRS("Cost")) Then
						pdaPrice(i) = (0.00 - 0.01)
					Else
'						pdaPrice(i) = CDbl(oRS("Cost"))
						If IsNull(oRS("Discount")) Then
							pdaPrice(i) = CDbl(oRS("Cost"))
						Else
							pdaPrice(i) = CDbl(oRS("Cost")) - CDbl(oRS("Discount"))
						End If
					End If
					
					i = i + 1
					
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetOrderItems = bRet
End Function

Function RemoveOrderItem(ByVal pnOrderID, ByVal pnOrderItemID)
	Dim bRet, sSQL
	
	bRet = FALSE
	
	sSQL = "delete from tblOrderLines where OrderLineID = " & pnOrderItemID
	
	If InvokeSQL(sSQL) Then
		bRet = TRUE
	End If
	
	RemoveOrderItem = bRet
End Function

Function RemoveOrder(ByVal pnOrderID)
	Dim bRet, sSQL
	
	bRet = FALSE
	
	sSQL = "delete from tblOrders where OrderID = " & pnOrderID
	
	If InvokeSQL(sSQL) Then
		bRet = TRUE
	End If
	
	RemoveOrder = bRet
End Function

Function SetPaymentInfo(ByVal pnOrderID, ByVal psPayMethod, ByVal pdTip, ByVal psReference)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		Select Case UCase(psPayMethod)
			Case "CASH"
				sSQL = "update tblOrders set PaymentTypeID = 1, Tip = " & pdTip & " where OrderID = " & pnOrderID
			Case "CHECK"
				sSQL = "update tblOrders set PaymentTypeID = 2, Tip = " & pdTip & " where OrderID = " & pnOrderID
			Case Else
'				sSQL = "update tblOrders set PaymentTypeID = 3, Tip = " & pdTip & ", PaymentAuthorization = '" & psReference & "' where OrderID = " & pnOrderID
				sSQL = "update tblOrders set PaidDate = GetDate(), IsPaid = 1, PaymentTypeID = 3, PaymentEmpID = 1, Tip = " & pdTip & ", PaymentAuthorization = '" & psReference & "' where OrderID = " & pnOrderID
		End Select
		
		If ExecuteSQL(oConn, sSQL) Then
			bRet = TRUE
		End If
		
		CloseDatabase(oConn)
	End If
	
	SetPaymentInfo = bRet
End Function

Function SetTip(ByVal pnOrderID, ByVal pdTip)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "update tblOrders set Tip = " & pdTip & " where OrderID = " & pnOrderID
		
		If ExecuteSQL(oConn, sSQL) Then
			bRet = TRUE
		End If
		
		CloseDatabase(oConn)
	End If
	
	SetTip = bRet
End Function

Function GetCurrentPromos(ByVal pnDMA, ByVal pnStore, ByRef panPromoIDs, ByRef pasPromoNames, ByRef pnaUnitNum, ByRef pnaUnitSize, ByRef psaUnitSize, ByRef psaUnitName)
	Dim bRet, oConn, sSQL, oRS, i
	
	bRet = FALSE
	
	ReDim panPromoIDs(0), pasPromoNames(0), pnaUnitNum(0), pnaUnitSize(0), psaUnitSize(0), psaUnitName(0)
	panPromoIDs(0) = 0
	pasPromoNames(0) = ""
	pnaUnitNum(0) = 0
	pnaUnitSize(0) = 0
	psaUnitSize(0) = ""
	psaUnitName(0) = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select tblCoupons.CouponID, Description, tblUnit.UnitID, tblSizes.SizeID, UnitDescription, SizeDescription from tblCoupons inner join trelCouponStore on tblCoupons.CouponID = trelCouponStore.CouponID and trelCouponStore.StoreID = " & pnStore
		sSQL = sSQL & " inner join tblCouponAppliesTo on tblCoupons.CouponID = tblCouponAppliesTo.CouponID "
		sSQL = sSQL & "inner join tblUnit on tblCouponAppliesTo.UnitID = tblUnit.UnitID "
		sSQL = sSQL & "inner join tblSizes on tblCouponAppliesTo.SizeID = tblSizes.SizeID "
		sSQL = sSQL & "inner join tblCouponDateRange on tblCoupons.CouponID = tblCouponDateRange.CouponID "
		sSQL = sSQL & "where '" & Date & "' between ValidFrom and ValidTo and ValidForInternetOrder <> 0 and ShowOnWeb <> 0 "
		sSQL = sSQL & "order by UnitID, SizeID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			bRet = TRUE
			
			If Not oRS.bof And Not oRS.eof Then
				i = 0
				
				Do While Not oRS.eof
					ReDim Preserve panPromoIDs(i), pasPromoNames(i), pnaUnitNum(i), pnaUnitSize(i), psaUnitSize(i), psaUnitName(i)
					
					panPromoIDs(i) = oRS("CouponID")
					pasPromoNames(i) = Trim(oRS("Description"))
					pnaUnitNum(i) = oRS("UnitID")
					pnaUnitSize(i) = oRS("SizeID")
					psaUnitSize(i) = Trim(oRS("SizeDescription"))
					psaUnitName(i) = Trim(oRS("UnitDescription"))
					
					i = i + 1
					
					oRS.MoveNext
				Loop
			End If
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetCurrentPromos = bRet
End Function

Function GetPromoName(ByVal pnDMA, ByVal pnPromoID)
	Dim sRet, oConn, oRS, sSQL
	
	sRet = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select Description from tblCoupons where CouponID = " & pnPromoID
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				sRet = Trim(oRS("Description"))
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetPromoName = sRet
End Function

Function GetPromoUnitSizeSpecialty(ByVal pnDMA, ByVal pnStore, ByVal pnPromoID, ByRef pnUnitID, ByRef pnSize, ByRef psSpecialty)
	Dim bRet, oConn, oRS, sSQL, sTable
	
	bRet = FALSE
	psSpecialty = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select UnitID, SizeID, SpecialtyID from tblCoupons inner join trelCouponStore on tblCoupons.CouponID = trelCouponStore.CouponID and trelCouponStore.StoreID = " & pnStore
		sSQL = sSQL & " inner join tblCouponAppliesTo on tblCoupons.CouponID = tblCouponAppliesTo.CouponID "
		sSQL = sSQL & "inner join tblCouponDateRange on tblCoupons.CouponID = tblCouponDateRange.CouponID "
		sSQL = sSQL & "where tblCoupons.CouponID = " & pnPromoID
		sSQL = sSQL & " and '" & Date & "' between ValidFrom and ValidTo and ValidForInternetOrder <> 0 "
		sSQL = sSQL & "order by UnitID, SizeID"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				
				pnUnitID = oRS("UnitID")
				pnSize = oRS("SizeID")
				If Not IsNull(oRS("SpecialtyID")) Then
					psSpecialty = oRS("SpecialtyID")
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetPromoUnitSizeSpecialty = bRet
End Function

Function GetPromoCodeName(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim sRet, oConn, oRS, sSQL
	
	sRet = ""
	
'	If UCase(pnPromoCodeID) = "TMENUS" Or UCase(pnPromoCodeID) = "SPORTS" Then
'		sRet = "20% Off Your Order (Not valid with other offers)"
'	Else
		If OpenDatabase(oConn) Then
			sSQL = "select Description from tblCouponsPromoCodes inner join tblCoupons on tblCouponsPromoCodes.CouponID = tblCoupons.CouponID where PromoCode = '" & CleanDBLiteral(pnPromoCodeID) & "'"
			
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					sRet = Trim(oRS("Description"))
				End If
				
				CloseQuery(oRS)
			End If
			
			CloseDatabase(oConn)
		End If
'	End If
	
	GetPromoCodeName = sRet
End Function


Function GetPromoCodeUnitSizeSpecialty(ByVal pnDMA, ByVal pnStore, ByVal psPromoCode, ByRef pnUnitID, ByRef panSize, ByRef psSpecialty)
	Dim bRet, oConn, oRS, sSQL, sTable, i
	
	bRet = FALSE
	psSpecialty = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select UnitID, SizeID, SpecialtyID from tblCouponsPromoCodes inner join tblCoupons on tblCouponsPromoCodes.CouponID = tblCoupons.CouponID "
		sSQL = sSQL & "inner join trelCouponStore on tblCoupons.CouponID = trelCouponStore.CouponID and trelCouponStore.StoreID = " & pnStore
		sSQL = sSQL & " inner join tblCouponAppliesTo on tblCoupons.CouponID = tblCouponAppliesTo.CouponID "
		sSQL = sSQL & "inner join tblCouponPromoCodeDateRange on tblCouponsPromoCodes.PromoCode = tblCouponPromoCodeDateRange.PromoCode "
		sSQL = sSQL & "where tblCouponsPromoCodes.PromoCode = '" & CleanDBLiteral(psPromoCode) & "' "
		sSQL = sSQL & "and '" & Date & "' between ValidFrom and ValidTo and ValidForInternetOrder <> 0 and MaxUses >= 0 "
		sSQL = sSQL & "order by SizeID "
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
				
				i = 0
				ReDim Preserve panSize(i)
				
				pnUnitID = oRS("UnitID")
				panSize(i) = oRS("SizeID")
				If Not IsNull(oRS("SpecialtyID")) Then
					psSpecialty = oRS("SpecialtyID")
				End If
				oRS.MoveNext
				i = 1
				Do While Not oRS.eof
					ReDim Preserve panSize(i)
					
					panSize(i) = oRS("SizeID")
					i = i + 1
					
					If oRS("SpecialtyID") <> psSpecialty Then
						psSpecialty = ""
'						Exit Do
					End If
					oRS.MoveNext
				Loop
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetPromoCodeUnitSizeSpecialty = bRet
End Function

Function ValidatePromoCode(ByVal pnDMA, ByVal pnStore, ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
'	If (UCase(pnPromoCodeID) = "TMENUS" Or UCase(pnPromoCodeID) = "SPORTS") AND (Date < CDate("1/1/2011")) Then
'		bRet = TRUE
'	Else
		If OpenDatabase(oConn) Then
			sSQL = "select tblCoupons.CouponID from tblCouponsPromoCodes "
			sSQL = sSQL & "inner join tblCoupons on tblCouponsPromoCodes.CouponID = tblCoupons.CouponID "
			sSQL = sSQL & "inner join trelCouponStore on tblCoupons.CouponID = trelCouponStore.CouponID and trelCouponStore.StoreID = " & pnStore
			sSQL = sSQL & "inner join tblCouponPromoCodeDateRange on tblCouponsPromoCodes.PromoCode = tblCouponPromoCodeDateRange.PromoCode "
			sSQL = sSQL & "where tblCouponsPromoCodes.PromoCode = '" & CleanDBLiteral(pnPromoCodeID) & "' "
			sSQL = sSQL & "and '" & Date & "' between ValidFrom and ValidTo and ValidForInternetOrder <> 0 and (MaxUses = 0 Or (MaxUses > 0 and Uses < MaxUses))"
			
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
			
			CloseDatabase(oConn)
		End If
'	End If
	
	ValidatePromoCode = bRet
End Function

Function LogActivity(ByVal psEmail, ByVal psAddress1, ByVal psAddress2, ByVal psCity, ByVal psState, ByVal pnPostalCode, ByVal pnStore)
	Dim nRet, oConn, oRS, sSQL
	
	nRet = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "EXEC LogWebActivity @pSessionID = " & Session.SessionID & ", @pEMail = '" & psEmail & "', @pAddress1 = '" & psAddress1 & "', @pAddress2 = '" & psAddress2 & "', @pCity = '" & psCity & "', @pState = '" & psState & "', @pPostalCode = '" & pnPostalCode & "', @pStoreID = " & pnStore & ", @pIPAddress = '" & Request.ServerVariables("REMOTE_ADDR") & "', @pRefID = '" & Session("RefID") & "'"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = CLng(oRS(0))
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	LogActivity = nRet
End Function

Function UpdateActivity(ByVal pnActivityID, ByVal pnOrderID)
	Dim bRet, sSQL
	
	bRet = FALSE
	
	sSQL = "update tblWebActivity set OrderID = " & pnOrderID & " where WebActivityID = " & pnActivityID
	
	If InvokeSQL(sSQL) Then
		bRet = TRUE
	End If
	
	UpdateActivity = bRet
End Function

Function GetActivityOrderID(ByVal pnActivityID)
	Dim nRet, oConn, oRS, sSQL
	
	nRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select OrderID from tblWebActivity where WebActivityID = " & pnActivityID
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = oRS("OrderID")
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetActivityOrderID = nRet
End Function

Function UpdateActivityStore(ByVal pnActivityID, ByVal pnStoreID, ByVal pnOrderType)
	Dim bRet, sSQL
	
	bRet = FALSE
	
	sSQL = "update tblWebActivity set StoreID = " & pnStoreID & ", OrderTypeID = " & pnOrderType & " where WebActivityID = " & pnActivityID
	
	If InvokeSQL(sSQL) Then
		bRet = TRUE
	End If
	
	UpdateActivityStore = bRet
End Function

Function GetDeliveryMinimum(ByVal pnStore)
	Dim dRet, oConn, oRS, sSQL
	
	dRet = 0.00
	
	If OpenDatabase(oConn) Then
		sSQL = "select DeliveryMin from tblStores where StoreID = " & pnStore
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				dRet = CDbl(oRS("deliverymin"))
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetDeliveryMinimum = dRet
End Function

Function GetOrderTotalNoDiscount(ByVal pnOrderID)
	Dim dRet, oConn, oRS, sSQL
	
	dRet = CDbl(0)
	
	If OpenDatabase(oConn) Then
		sSQL = "select sum(Cost) as pretotal from tblOrderLines where OrderID = " & pnOrderID
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				If IsNull(oRS("pretotal")) Then
					dRet = CDbl(0)
				Else
					dRet = CDbl(oRS("pretotal"))
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetOrderTotalNoDiscount = dRet
End Function

Function GetOrderDiscount(ByVal pnOrderID)
	Dim dRet, oConn, oRS, sSQL
	
	dRet = CDbl(0)
	
	If OpenDatabase(oConn) Then
		sSQL = "select sum(Discount) as discount from tblOrderLines where OrderID = " & pnOrderID
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				If IsNull(oRS("discount")) Then
					dRet = CDbl(0)
				Else
					dRet = CDbl(oRS("discount"))
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetOrderDiscount = dRet
End Function

Function GetCouponID(ByVal pnDMA, ByVal psPromoCode)
	Dim nRet, oConn, oRS, sSQL
	
	nRet = CDbl(0)
	
	If OpenDatabase(oConn) Then
		sSQL = "select CouponID from tblCouponsPromoCodes where PromoCode = '" & CleanDBLiteral(psPromoCode) & "'"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = CDbl(oRS("CouponID"))
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetCouponID = nRet
End Function

Function WasCouponUsed(ByVal pnOrderID, ByVal pnCouponID)
	Dim bRet, oConn, oRS, sSQL, aCouponIDs, i
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select CouponID from tblOrderLines where OrderID = " & pnOrderID
		If OpenQuery(oConn, oRS, sSQL) Then
			Do While Not oRS.eof
				If CLng(pnCouponID) = oRS("CouponID") Then
					bRet = TRUE
					Exit Do
				End If
				
				oRS.MoveNext
			Loop
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	WasCouponUsed = bRet
End Function

Function InvalidatePromoCode(ByVal pnDMA, ByVal psPromoCode)
	Dim bRet, sSQL
	
	bRet = FALSE
	
	sSQL = "update tblCouponsPromoCodes set Uses = Uses + 1 where PromoCode = '" & psPromoCode & "'"
	
	If InvokeSQL(sSQL) Then
		bRet = TRUE
	End If
	
	InvalidatePromoCode = bRet
End Function

Function GetMarqueeText()
	Dim sRet, sSQL, oConn, oRS
	
	sRet = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select marqueeMain, marqueeSub from tblMarquee where getdate() between startdate and enddate"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				If Not IsNull(oRS("marqueeMain")) Then
					sRet = Trim(oRS("marqueeMain"))
					
					If Not IsNull(oRS("marqueeSub")) Then
						If Len(Trim(oRS("marqueeSub"))) > 0 Then
							sRet = sRet & " (Promo Code: " & Trim(oRS("marqueeSub")) & ")"
						End If
					End If
				End If
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetMarqueeText = sRet
End Function

Function IsPromoCodeFreeSaladAndBread(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If (pnDMA = 1) And (((UCase(pnPromoCodeID) = "FREESB") And (Date < CDate("6/6/2011"))) Or ((UCase(pnPromoCodeID) = "LETTER") And (Date < CDate("6/6/2011"))) Or ((UCase(pnPromoCodeID) = "FREESB2") And (Date < CDate("6/23/2011")))) Then
		bRet = TRUE
	End If
	
	IsPromoCodeFreeSaladAndBread = bRet
End Function

Function ValidateFreeSaladAndBread(ByVal pnOrderID, ByVal psPromoCode)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		' Confirm pizza or sub added
		If UCase(psPromoCode) = "FREESB" Or UCase(psPromoCode) = "FREESB2" Then
			sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and unitnum = 1"
		Else
			sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and (unitnum = 1 or unitnum = 25 or unitnum = 8 or unitnum = 19)"
		End If
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		If bRet Then
			bRet = FALSE
			
			' Confirm small salad
			sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and unitnum = 3 and size = 2"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		If bRet Then
			bRet = FALSE
			
			' Confirm small cheesybread
			sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and unitnum = 2 and size = 1"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		If bRet And UCase(psPromoCode) = "FREESB2" Then
			bRet = FALSE
			
			' Confirm 2 liter
			sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and description like '2 Liter%'"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidateFreeSaladAndBread = bRet
End Function

Function IsPromoCodeSub(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If (pnDMA = 1) And (UCase(pnPromoCodeID) = "5SUB") And (Date < CDate("7/1/2012")) Then
		bRet = TRUE
	End If
	
	IsPromoCodeSub = bRet
End Function

Function ValidateBunSubPromo(ByVal pnOrderID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and unitnum = 8 and size = 1"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidateBunSubPromo = bRet
End Function

Function ValidateFoldoverSubPromo(ByVal pnOrderID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and unitnum = 8 and size = 2"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidateFoldoverSubPromo = bRet
End Function

Function ValidateWholeSubPromo(ByVal pnOrderID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and unitnum = 19 and size = 2"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidateWholeSubPromo = bRet
End Function

Function ValidateWholeFoldoverPromo(ByVal pnOrderID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select orderitemid from order_items where orderid = " & pnOrderID & " and unitnum = 25 and size = 2"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidateWholeFoldoverPromo = bRet
End Function

Function IsPromoCodePizzaAndBread(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If (pnDMA = 1) And (UCase(pnPromoCodeID) = "L450") And (Date < CDate("6/25/2012")) Then
		bRet = TRUE
	End If
	
	IsPromoCodePizzaAndBread = bRet
End Function

Function ValidatePizzaAndBread(ByVal pnOrderID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 1 and SizeID = 9"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		If bRet Then
			bRet = FALSE
			
			' Confirm small cheesybread
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 2 and SizeID = 11"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidatePizzaAndBread = bRet
End Function

Function IsPromoCodeWithPizzaPurchase(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If (pnDMA = 1) And ((UCase(pnPromoCodeID) = "10FW") Or (UCase(pnPromoCodeID) = "SVBF") Or (UCase(pnPromoCodeID) = "FSCB")) And (Date <= CDate("3/27/2013")) Then
		bRet = TRUE
	End If
	
	IsPromoCodeWithPizzaPurchase = bRet
End Function

Function ValidatePizza(ByVal pnOrderID, ByVal psPromoCode)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		' Confirm pizza added
		sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 1"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		If bRet And UCase(psPromoCode) = "10FW" Then
			bRet = FALSE
			
			' Confirm wings
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 4 and SizeID = 18"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		If bRet And UCase(psPromoCode) = "SVBF" Then
			bRet = FALSE
			
			' Confirm small bread
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 2 and SizeID = 11"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		If bRet And UCase(psPromoCode) = "FSCB" Then
			bRet = FALSE
			
			' Confirm small cinnamon bread
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 5 and SizeID = 11"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidatePizza = bRet
End Function

Function IsPromoCodeWithPizzaOrSubPurchase(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If (pnDMA = 1) And ((UCase(pnPromoCodeID) = "UTMAC") And (Date < CDate("1/1/2013"))) Then
		bRet = TRUE
	End If
	
	IsPromoCodeWithPizzaOrSubPurchase = bRet
End Function

Function ValidatePizzaOrSub(ByVal pnOrderID, ByVal psPromoCode)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		' Confirm pizza added
		sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 1"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		If Not bRet Then
			' Confirm sub
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 17"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		If Not bRet Then
			' Confirm foldover
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 18"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidatePizzaOrSub = bRet
End Function

Function GetPromoCodeCouponID(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim nRet, oConn, oRS, sSQL
	
	nRet = 0
	
	If OpenDatabase(oConn) Then
		sSQL = "select CouponID from tblCouponsPromoCodes where PromoCode = '" & CleanDBLiteral(pnPromoCodeID) & "'"
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				nRet = oRS("CouponID")
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetPromoCodeCouponID = nRet
End Function

Function IsPromoCodeSpecificSpecialty(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If (GetPromoCodeCouponID(pnDMA, pnPromoCodeID) = 199) And  (Date < CDate("9/19/2012")) Then
		bRet = TRUE
	End If
	
	IsPromoCodeSpecificSpecialty = bRet
End Function

Function ValidateSpecificSpecialty(ByVal pnDMA, ByVal pnOrderID, ByVal psPromoCode)
	Dim bRet, oConn, oRS, sSQL, lnID
	
	bRet = FALSE
	lnID = GetPromoCodeCouponID(pnDMA, psPromoCode)
	
	If OpenDatabase(oConn) Then
		If lnID = 199 Then
			' Confirm small taco
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 1 and (SizeID = 11 Or SizeID = 39) and SpecialtyID = 10"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
			
			If Not bRet Then
				' Confirm small mediterranean
				sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 1 and (SizeID = 11 Or SizeID = 39) and SpecialtyID = 14"
				If OpenQuery(oConn, oRS, sSQL) Then
					If Not oRS.bof And Not oRS.eof Then
						bRet = TRUE
					End If
					
					CloseQuery(oRS)
				End If
			End If
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidateSpecificSpecialty = bRet
End Function

Function IsPromoCodeWithMinimumPurchase(ByVal pnDMA, ByVal psPromoCode)
	Dim bRet
	
	bRet = FALSE
	
	If (pnDMA = 1) And ((UCase(psPromoCode) = "LBREAD") Or (UCase(psPromoCode) = "FSSP") Or (UCase(psPromoCode) = "LCINN")) Then
		bRet = TRUE
	End If
	
	IsPromoCodeWithMinimumPurchase = bRet
End Function

Function ValidateMinimumPurchase(ByVal pnOrderID, ByVal psPromoCode, ByVal pdPurchase)
	Dim bRet
	
	bRet = FALSE
	
	If (UCase(psPromoCode) = "LCINN" And ((Date >= CDate("5/28/2013") and Date <= CDate("5/30/2013")) or Date = CDate("6/5/2013") or Date = CDate("6/6/2013") or Date = CDate("6/12/2013") or Date = CDate("6/13/2013") or Date = CDate("6/19/2013") or Date = CDate("6/20/2013") or Date = CDate("6/26/2013") or Date = CDate("6/27/2013")) And pdPurchase >= 10.00) Or (UCase(psPromoCode) = "LBREAD" And ((Date >= CDate("4/24/2013") and Date <= CDate("4/25/2013")) or Date = CDate("4/10/2013") or Date = CDate("4/11/2013") or Date = CDate("4/17/2013") or Date = CDate("4/18/2013")) And pdPurchase >= 10.00) Or (UCase(psPromoCode) = "FSSP" And ((Date >= CDate("4/30/2013") and Date <= CDate("5/1/2013")) or Date = CDate("5/6/2013") or Date = CDate("5/7/2013") or Date = CDate("5/13/2013") or Date = CDate("5/14/2013") or Date = CDate("5/20/2013") or Date = CDate("5/21/2013") or Date = CDate("5/27/2013") or Date = CDate("5/28/2013")) And pdPurchase >= 9.00) Then
		bRet = TRUE
	End If
		
	ValidateMinimumPurchase = bRet
End Function

Function IsPromoCodeTimeBased(ByVal pnDMA, ByVal psPromoCode)
	Dim bRet
	
	bRet = FALSE
	
	If (pnDMA = 1) And ((UCase(psPromoCode) = "5SS5") Or (UCase(psPromoCode) = "5SR5") Or (UCase(psPromoCode) = "6SS5") Or (UCase(psPromoCode) = "6SR5")) Then
		bRet = TRUE
	End If
	
	IsPromoCodeTimeBased = bRet
End Function

Function ValidateTimeBased(ByVal pnOrderID, ByVal psPromoCode)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If (((UCase(psPromoCode) = "5SS5") Or (UCase(psPromoCode) = "5SR5")) And Hour(Now) < 17 And ((Date >= CDate("3/27/2013") and Date <= CDate("4/2/2013")) Or (Month(Now) = 4 And Year(Now) = 2013 And (Weekday(Now) = 2 or Weekday(Now) = 3)))) Or (((UCase(psPromoCode) = "6SS5") Or (UCase(psPromoCode) = "6SR5")) And Hour(Now) >= 17 And ((Date >= CDate("3/27/2013") and Date <= CDate("4/2/2013")) Or (Month(Now) = 4 And Year(Now) = 2013 And (Weekday(Now) = 2 or Weekday(Now) = 3)))) Then
		bRet = TRUE
	End If
		
	ValidateTimeBased = bRet
End Function

Function IsPromoCodeBOGO(ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		sSQL = "select tblCoupons.CouponID from tblCouponsPromoCodes "
		sSQL = sSQL & "inner join tblCoupons on tblCouponsPromoCodes.CouponID = tblCoupons.CouponID "
		sSQL = sSQL & "inner join tblCouponPromoCodeDateRange on tblCouponsPromoCodes.PromoCode = tblCouponPromoCodeDateRange.PromoCode "
		sSQL = sSQL & "where tblCouponsPromoCodes.PromoCode = '" & CleanDBLiteral(pnPromoCodeID) & "' "
		sSQL = sSQL & "and '" & Date & "' between ValidFrom and ValidTo and ValidForInternetOrder <> 0 and (MaxUses = 0 Or (MaxUses > 0 and Uses < MaxUses)) and CouponTypeID = 1"
		
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				bRet = TRUE
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	IsPromoCodeBOGO = bRet
End Function

Function IsPromoCodePizzaFoldAndPop(ByVal pnDMA, ByVal pnPromoCodeID)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If (pnDMA = 1) And ((UCase(pnPromoCodeID) = "6SCOMBO") Or (UCase(pnPromoCodeID) = "6FCOMBO")) And (Date < CDate("10/06/2013")) Then
		bRet = TRUE
	End If
	
	IsPromoCodePizzaFoldAndPop = bRet
End Function

Function ValidatePizzaFoldAndPop(ByVal pnOrderID, ByVal psPromoCode)
	Dim bRet, oConn, oRS, sSQL
	
	bRet = FALSE
	
	If OpenDatabase(oConn) Then
		If UCase(psPromoCode) = "6SCOMBO" Then
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 1 and (SizeID = 11 Or SizeID = 39)"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		Else
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 18 and SizeID = 27"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		If bRet Then
			bRet = FALSE
			
			' Confirm pop
			sSQL = "select OrderLineID from tblOrderLines where OrderID = " & pnOrderID & " and UnitID = 15 and SizeID = 22"
			If OpenQuery(oConn, oRS, sSQL) Then
				If Not oRS.bof And Not oRS.eof Then
					bRet = TRUE
				End If
				
				CloseQuery(oRS)
			End If
		End If
		
		CloseDatabase(oConn)
	End If
	
	ValidatePizzaFoldAndPop = bRet
End Function

Function GetPGWID(ByVal pnStore)
	Dim sRet, oConn, oRS, sSQL
	
	sRet = ""
	
	If OpenDatabase(oConn) Then
		sSQL = "select PGWWebID from tblStores where StoreID = " & pnStore
		If OpenQuery(oConn, oRS, sSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				sRet = Trim(oRS("PGWWebID"))
			End If
			
			CloseQuery(oRS)
		End If
		
		CloseDatabase(oConn)
	End If
	
	GetPGWID = sRet
End Function

Function PrintOrder(ByVal pnStore, ByVal pnOrderID, ByRef psResult)
	Dim bRet, oConn, lsSQL, oRS
	
	bRet = FALSE
	psResult = ""
	
	If OpenDatabase(oConn) Then
		lsSQL = "EXEC WebPrintOrder @pStoreID = " & pnStore & ", @pOrderID = " & pnOrderID
		If OpenQuery(oConn, oRS, lsSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				psResult = oRS(0)
				
				If oRS(0) = "SUCCESS" Then
					bRet = TRUE
				End If
			End If
			
			CloseQuery(oRS)
		End If
	End If
	
	PrintOrder = bRet
End Function

Function ForceCreditCard(ByVal pnOrderID, ByVal psRefNum, ByRef psResult)
	Dim bRet, oConn, lsSQL, oRS
	
	bRet = FALSE
	psResult = ""
	
	If OpenDatabase(oConn) Then
		lsSQL = "EXEC WebForceCreditCard @pOrderID = " & pnOrderID & ", @pRefNum = '" & psRefNum & "'"
		If OpenQuery(oConn, oRS, lsSQL) Then
			If Not oRS.bof And Not oRS.eof Then
				psResult = oRS(0)
				
				If oRS(0) = "SUCCESS" Then
					bRet = TRUE
				End If
			End If
			
			CloseQuery(oRS)
		End If
	End If
	
	ForceCreditCard = bRet
End Function
%>
