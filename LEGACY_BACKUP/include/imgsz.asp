<%
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ':::                                                             :::
  ':::  This routine will attempt to identify any filespec passed  :::
  ':::  as a graphic file (regardless of the extension). This will :::
  ':::  work with BMP, GIF, JPG and PNG files.                     :::
  ':::                                                             :::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ':::          Based on ideas presented by David Crowell          :::
  ':::                   (credit where due)                        :::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  '::: blah blah blah blah blah blah blah blah blah blah blah blah :::
  '::: blah blah blah blah blah blah blah blah blah blah blah blah :::
  '::: blah blah     Copyright *c* MM,  Mike Shaffer     blah blah :::
  '::: blah blah      ALL RIGHTS RESERVED WORLDWIDE      blah blah :::
  '::: blah blah  Permission is granted to use this code blah blah :::
  '::: blah blah   in your projects, as long as this     blah blah :::
  '::: blah blah      copyright notice is included       blah blah :::
  '::: blah blah blah blah blah blah blah blah blah blah blah blah :::
  '::: blah blah blah blah blah blah blah blah blah blah blah blah :::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ':::                                                             :::
  ':::  This function gets a specified number of bytes from any    :::
  ':::  file, starting at the offset (base 1)                      :::
  ':::                                                             :::
  ':::  Passed:                                                    :::
  ':::       flnm        => Filespec of file to read               :::
  ':::       offset      => Offset at which to start reading       :::
  ':::       bytes       => How many bytes to read                 :::
  ':::                                                             :::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  function GetBytes(flnm, offset, bytes)

     Dim objFSO
     Dim objFTemp
     Dim objTextStream
     Dim lngSize
     Dim strBuff

     on error resume next

     Set objFSO = CreateObject("Scripting.FileSystemObject")
     
     ' First, we get the filesize
     Set objFTemp = objFSO.GetFile(flnm)
     lngSize = objFTemp.Size
     set objFTemp = nothing

'     fsoForReading = 1
     Set objTextStream = objFSO.OpenTextFile(flnm, fsoForReading)

     if offset > 0 then
        strBuff = objTextStream.Read(offset - 1)
     end if

     if bytes = -1 then		' Get All!

        GetBytes = objTextStream.Read(lngSize)  'ReadAll

     else

        GetBytes = objTextStream.Read(bytes)

     end if

     objTextStream.Close
     set objTextStream = nothing
     set objFSO = nothing

  end function


  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ':::                                                             :::
  ':::  Functions to convert two bytes to a numeric value (long)   :::
  ':::  (both little-endian and big-endian)                        :::
  ':::                                                             :::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  function lngConvert(strTemp)
     lngConvert = clng(ascb(left(strTemp, 1)) + ((ascb(right(strTemp, 1)) * 256)))
  end function

  function lngConvert2(strTemp)
     lngConvert2 = clng(ascb(right(strTemp, 1)) + ((ascb(left(strTemp, 1)) * 256)))
  end function

  
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ':::                                                             :::
  ':::  This function does most of the real work. It will attempt  :::
  ':::  to read any file, regardless of the extension, and will    :::
  ':::  identify if it is a graphical image.                       :::
  ':::                                                             :::
  ':::  Passed:                                                    :::
  ':::       flnm        => Filespec of file to read               :::
  ':::       width       => width of image                         :::
  ':::       height      => height of image                        :::
  ':::       depth       => color depth (in number of colors)      :::
  ':::       strImageType=> type of image (e.g. GIF, BMP, etc.)    :::
  ':::                                                             :::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  function gfxSpex(flnm, width, height, depth, strImageType)

     dim strPNG 
     dim strGIF
     dim strBMP
     dim strType
     dim strBuff
     dim lngSize
     dim flgFound
     dim strTarget
     dim lngPos
     dim ExitLoop
     dim lngMarkerSize
     
     strType = ""
     strImageType = "(unknown)"

     gfxSpex = False

     strPNG = chr(137) & chr(80) & chr(78)
     strGIF = "GIF"
     strBMP = chr(66) & chr(77)

     strType = GetBytes(flnm, 0, 3)

     if strType = strGIF then				' is GIF

        strImageType = "GIF"
        Width = lngConvert(GetBytes(flnm, 7, 2))
        Height = lngConvert(GetBytes(flnm, 9, 2))
        Depth = 2 ^ ((ascb(GetBytes(flnm, 11, 1)) and 7) + 1)
        gfxSpex = True

     elseif left(strType, 2) = strBMP then		' is BMP

        strImageType = "BMP"
        Width = lngConvert(GetBytes(flnm, 19, 2))
        Height = lngConvert(GetBytes(flnm, 23, 2))
        Depth = 2 ^ (ascb(GetBytes(flnm, 29, 1)))
        gfxSpex = True

     elseif strType = strPNG then			' Is PNG

        strImageType = "PNG"
        Width = lngConvert2(GetBytes(flnm, 19, 2))
        Height = lngConvert2(GetBytes(flnm, 23, 2))
        Depth = getBytes(flnm, 25, 2)

        select case ascb(right(Depth,1))
           case 0
              Depth = 2 ^ (ascb(left(Depth, 1)))
              gfxSpex = True
           case 2
              Depth = 2 ^ (ascb(left(Depth, 1)) * 3)
              gfxSpex = True
           case 3
              Depth = 2 ^ (ascb(left(Depth, 1)))  '8
              gfxSpex = True
           case 4
              Depth = 2 ^ (ascb(left(Depth, 1)) * 2)
              gfxSpex = True
           case 6
              Depth = 2 ^ (ascb(left(Depth, 1)) * 4)
              gfxSpex = True
           case else
              Depth = -1
        end select


     else

        strBuff = GetBytes(flnm, 0, -1)		' Get all bytes from file
        lngSize = len(strBuff)
        flgFound = 0

        strTarget = chr(255) & chr(216) & chr(255)
'        flgFound = instr(strBuff, strTarget)

'        if flgFound = 0 then
        if ascb(Mid(strBuff, 1, 1)) <> 255 or ascb(Mid(strBuff, 2, 1)) <> 216 or ascb(Mid(strBuff, 3, 1)) <> 255 Then
           exit function
        end if
        flgFound = 1

        strImageType = "JPG"
        lngPos = flgFound + 2
        ExitLoop = false

        do while ExitLoop = False and lngPos < lngSize

           do while (ascb(mid(strBuff, lngPos, 1)) = 255) and (lngPos < lngSize)
              lngPos = lngPos + 1
           loop

           if ascb(mid(strBuff, lngPos, 1)) < 192 or ascb(mid(strBuff, lngPos, 1)) > 195 then
              lngMarkerSize = lngConvert2(mid(strBuff, lngPos + 1, 2))
              lngPos = lngPos + lngMarkerSize  + 1
           else
              ExitLoop = True
           end if

       loop
       '
       if ExitLoop = False then

          Width = -1
          Height = -1
          Depth = -1

       else

          Height = lngConvert2(mid(strBuff, lngPos + 4, 2))
          Width = lngConvert2(mid(strBuff, lngPos + 6, 2))
          Depth = 2 ^ (ascb(mid(strBuff, lngPos + 8, 1)) * 8)
          gfxSpex = True

       end if
                   
     end if

  end function



  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ':::     Test Harness                                              :::
  ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  
'  ' To test, we'll just try to show all files with a .GIF extension in the root of C:
'
'  Set objFSO = CreateObject("Scripting.FileSystemObject")
'  Set objF = objFSO.GetFolder("c:\")
'  Set objFC = objF.Files
'
'  response.write "<table border=""0"" cellpadding=""5"">"
'
'  For Each f1 in objFC
'    if instr(ucase(f1.Name), ".GIF") then
'       response.write "<tr><td>" & f1.name & "</td><td>" & f1.DateCreated & "</td><td>" & f1.Size & "</td><td>"
'
'       if gfxSpex(f1.Path, w, h, c, strType) = true then
'          response.write w & " x " & h & " " & c & " colors"
'       else
'          response.write "&nbsp;"
'       end if
'
'       response.write "</td></tr>"
'
'    end if
'
'  Next
'
'  response.write "</table>"
'
'  set objFC = nothing
'  set objF = nothing
'  set objFSO = nothing


%>
