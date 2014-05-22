<%
' **************************************************************************
' File: cm-database.asp
' Purpose: Include file containing database access functions.
' Created: 7/18/2007 - TAM
'
' Revision History:
' 7/18/2007 - Created
' 11/5/2007 - Altered to support SQL Server and Access and added a few
'				more useful functions.
' **************************************************************************

' **************************************************************************
' Function: OpenDatabase
' Purpose: Establishes a connection to the database.
' Return: TRUE or FALSE indicating success
' **************************************************************************
Function OpenDatabase(ByRef po_Conn)
	Dim ls_DBPath
	
	OpenDatabase = FALSE
	
	On Error Resume Next
	
	Set po_Conn = Server.CreateObject("ADODB.Connection")
	If Err.Number = 0 And IsObject(po_Conn) Then
		po_Conn.Provider = gs_DBProvider
		
		If gs_DBProvider = "SQLOLEDB" Then
			po_Conn.Properties("Data Source") = gs_SQLServerHost
			po_Conn.Properties("Initial Catalog") = gs_SQLServerDatabase
			po_Conn.Properties("User ID") = gs_SQLServerUserID
			po_Conn.Properties("Password") = gs_SQLServerPassword
			
			po_Conn.Open
		Else
			ls_DBPath = Server.MapPath(gs_DBFile)
			
			po_Conn.Mode = gn_DBMode
			
			po_Conn.Open ls_DBPath
		End If
		
		If Err.Number = 0 And po_Conn.State = adStateOpen Then
			OpenDatabase = TRUE
		Else
			gs_ErrorMsg = Err.Description
			Set po_Conn = Nothing
		End If
	Else
		gs_ErrorMsg = Err.Description
	End If
End Function

' **************************************************************************
' Subroutine: CloseDatabase
' Purpose: Disconnects a connection to the database.
' **************************************************************************
Sub CloseDatabase(ByRef po_Conn)
	On Error Resume Next
	
	po_Conn.Close
	Set po_Conn = Nothing
End Sub

' **************************************************************************
' Function: CleanDBLiteral
' Purpose: Examines a literal sting and adds any neccessary escape clauses.
' Return: String containing cleaned literal
' **************************************************************************
Function CleanDBLiteral(ByVal ps_Literal)
	Dim sRet, i, c
	
	sRet = ""
	For i = 1 to Len(ps_Literal)
		c = Mid(ps_Literal, i, 1)
		
		Select Case c
			Case "'" c = "''"
			Case "\" c= "\\"
		End Select
		
		sRet = sRet & c
	Next
	
	CleanDBLiteral = sRet
End Function

' **************************************************************************
' Function: OpenQuery
' Purpose: Executes a given query against a connection populating a
'			forward-only, read-only recordset.
' Return: TRUE or FALSE if query succeeded
' **************************************************************************
Function OpenQuery(ByRef po_Conn, ByRef po_RS, ByVal ps_SQL)
	OpenQuery = FALSE
	
	On Error Resume Next
	
	Set po_RS = po_Conn.Execute(ps_SQL)
	If Err.Number = 0 And IsObject(po_RS) Then
		OpenQuery = TRUE
	Else
		gs_ErrorMsg = Err.Description & " SQL: " & ps_SQL
	End If
End Function

' **************************************************************************
' Function: OpenQueryRW
' Purpose: Executes a given query against a connection populating a
'			forward-only, read/write recordset.
' Return: TRUE or FALSE if query succeeded
' **************************************************************************
Function OpenQueryRW(ByRef po_Conn, ByRef po_RS, ByVal ps_SQL)
	OpenQueryRW = FALSE
	
	On Error Resume Next
	
	Set po_RS = Server.CreateObject("ADODB.Recordset")
	If Err.Number = 0 And IsObject(po_Conn) Then
		po_RS.Open ps_SQL, po_Conn, adOpenForwardOnly, adLockOptimistic
		
		If Err.Number = 0 And po_RS.State = adStateOpen Then
			OpenQueryRW = TRUE
		Else
			gs_ErrorMsg = Err.Description & " SQL: " & ps_SQL
		End If
	Else
		gs_ErrorMsg = Err.Description & " SQL: " & ps_SQL
	End If
End Function

'*******************************************************
' Function ExecuteSQL
' Executes an SQL statement.
' Returns TRUE or FALSE
'*********************************************************
Function ExecuteSQL(ByRef po_Conn, ps_SQL)
	ExecuteSQL = FALSE
	
	On Error Resume Next
	
	po_Conn.Execute ps_SQL
	If Err.Number = 0 Then
		ExecuteSQL = TRUE
	Else
		gs_ErrorMsg = Err.Description & " SQL: " & ps_SQL
	End If
End Function

' **************************************************************************
' Subroutine: CloseQuery
' Purpose: Disconnects a recordset.
' **************************************************************************
Sub CloseQuery(ByRef po_RS)
	On Error Resume Next
	
	po_RS.Close
	Set po_RS= Nothing
End Sub

'*******************************************************
' Function InvokeSQL
' Invokes an SQL statement, returns true or false.
'*********************************************************
Function InvokeSQL(ps_SQL)
	Dim oConn
	
	InvokeSQL = FALSE
	
	If OpenDatabase(oConn) Then
		On Error Resume Next
		
		oConn.BeginTrans
		
		If Err.Number = 0 Then
			If ExecuteSQL(oConn, ps_SQL) Then
				InvokeSQL = TRUE
				oConn.CommitTrans
			Else
				oConn.RollbackTrans
			End If
		End If
		
		CloseDatabase(oConn)
	End If
End Function

'*******************************************************
' Function SleepSQL
' Sleeps for a given amount of time, dependent on Microsoft SQL Server.
'*********************************************************
Function SleepSQL(ByVal pnSeconds)
	Dim bRet, oConn, sSQL
	
	bRet = FALSE
	
	If gs_DBProvider = "SQLOLEDB" Then
		If OpenDatabase(oConn) Then
			oConn.commandTimeout = pnSeconds + 5
			
			sSQL = "WAITFOR DELAY '00:00:" & Right("0" & pnSeconds, 2) & "'"
			
			oConn.Execute sSQL,,129
			
			CloseDatabase(oConn)
		End If
	End If
	
	SleepSQL = bRet
End Function
%>
