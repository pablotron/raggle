; Raggle.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install raggle into a directory that the user selects,

!define VER_MAJ 0
!define VER_MIN 3
!define VER_REV 0
!define VER_SUF -pre
!define MUI_LICENSEPAGE

;--------------------------------

; The name of the installer
Name "Raggle ${VER_MAJ}.${VER_MIN}.${VER_REV}${VER_SUF} Installer"

; The file to write
OutFile "Raggle-${VER_MAJ}_${VER_MIN}_${VER_REV}${VER_SUF}.exe"
SetCompressor bzip2

; The default installation directory
InstallDir $PROGRAMFILES\Raggle

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM SOFTWARE\NSIS_Raggle "Install_Dir"

; The text to prompt the user to enter a directory
ComponentText "This will install Raggle on your computer. Select which components to install."

; License text (this doesn't work for some reason :/)
; LicenseData ..\COPYING.txt

; The text to prompt the user to enter a directory
DirText "Choose a directory to install in to:"

;--------------------------------

; The stuff to install
Section "Raggle (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put files there
  File "..\..\raggle"
  File "raggle_server.bat"
  File "raggle_client.html"
  
  SetOutPath $INSTDIR\web_ui
  File "..\web_ui\*.html"
  SetOutPath $INSTDIR\web_ui\inc
  File "..\web_ui\inc\*.*"
  SetOutPath $INSTDIR\web_ui\images
  File "..\web_ui\images\*.*"
  
  SetOutPath $INSTDIR\extras
  File "..\*.rb"
  
  SetOutPath $INSTDIR\doc
  File "win32.html"
  File "..\..\doc\*.*"
  File /oname=Authors.txt "..\..\AUTHORS"
  File /oname=Bugs.txt "..\..\BUGS"
  File /oname=ChangeLog.txt "..\..\ChangeLog"
  File /oname=License.txt "..\..\COPYING"
  File /oname=ReadMe.txt "..\..\README"
  File /oname=ToDo.txt "..\..\TODO"
  
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\NSIS_Raggle "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Raggle" "DisplayName" "Raggle (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Raggle" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Raggle"
  CreateShortCut "$SMPROGRAMS\Raggle\Getting Started.lnk" "$INSTDIR\doc\win32.html" "" "$INSTDIR\doc\win32.html" 0
  CreateShortCut "$SMPROGRAMS\Raggle\Raggle.lnk" "$INSTDIR\raggle_server.bat" "" "$INSTDIR\raggle_server.bat" 0
;  CreateShortCut "$SMPROGRAMS\Raggle\Raggle Client.lnk" "$INSTDIR\raggle_client.html" "" "$INSTDIR\raggle_client.html" 0
  CreateShortCut "$SMPROGRAMS\Raggle\Documentation.lnk" "$INSTDIR\doc\" "" "$INSTDIR\doc\" 0
  CreateShortCut "$SMPROGRAMS\Raggle\Uninstall Raggle.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd

;--------------------------------

; Uninstaller

UninstallText "This will uninstall Raggle. Hit next to continue."

; Uninstall section

Section "Uninstall"
  
  ; remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Raggle"
  DeleteRegKey HKLM SOFTWARE\NSIS_Raggle

  ; remove files and uninstaller
  Delete $INSTDIR\raggle
  Delete $INSTDIR\raggle_server.bat
  Delete $INSTDIR\raggle_client.html
  Delete $INSTDIR\uninstall.exe

  RMDir /R $INSTDIR\web_ui

  ; remove shortcuts, if any
  Delete "$SMPROGRAMS\Raggle\*.*"

  ; remove directories used
  RMDir "$SMPROGRAMS\Raggle"
  RMDir /R "$INSTDIR"

SectionEnd
