;--------------------------------
; Installation script for ContactsMgr
; bb - sdtp - June 2021
;--------------------------------
  Unicode true
  
  !include "MUI2.nsh"
  !include x64.nsh
  !include FileFunc.nsh
  
;--------------------------------
;Configuration

  ;General
  Name "Contacts Manager"
  OutFile "InstallContactsmgr.exe"
  !define lazarus_dir "C:\Users\Bernard\Documents\Lazarus"
  !define source_dir "${lazarus_dir}\contactmanager"
  
  RequestExecutionLevel admin
  
  ;Windows vista.. 10 manifest
  ManifestSupportedOS all

  ;!define MUI_LANGDLL_ALWAYSSHOW                     ; To display language selection dialog
  !define MUI_ICON "${source_dir}\contactmgr.ico"
  !define MUI_UNICON "${source_dir}\contactmgr.ico"

  ; The default installation directory
  InstallDir "$PROGRAMFILES\ContactMgr"

;--------------------------------
; Interface Settings

!define MUI_ABORTWARNING

;--------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKCU"
  !define MUI_LANGDLL_REGISTRY_KEY "Software\SDTP\ContactsMgr"
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"
  !define MUI_FINISHPAGE_SHOWREADME
  !define MUI_FINISHPAGE_SHOWREADME_TEXT "$(Check_box)"
  !define MUI_FINISHPAGE_SHOWREADME_FUNCTION inst_shortcut
; Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE $(licence)
 ; !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;Languages
  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_RESERVEFILE_LANGDLL

  ;Licence langage file
  LicenseLangString Licence ${LANG_ENGLISH} "${source_dir}\license.txt"
  LicenseLangString Licence ${LANG_FRENCH}  "${source_dir}\licensf.txt"

  ;Language strings for uninstall string
  LangString RemoveStr ${LANG_ENGLISH}  "Contacts Manager"
  LangString RemoveStr ${LANG_FRENCH} "Gestionnaire de contacts"

  ;Language string for links
  LangString ProgramLnkStr ${LANG_ENGLISH} "Contacts Manager.lnk"
  LangString ProgramLnkStr ${LANG_FRENCH} "Gestionnaire de contacts.lnk"
  LangString UninstLnkStr ${LANG_ENGLISH} "Contacts Manager uninstall.lnk"
  LangString UninstLnkStr ${LANG_FRENCH} "Désinstallation du Gestionnaire de contacts.lnk"

  LangString ProgramDescStr ${LANG_ENGLISH} "Contacts Manager"
  LangString ProgramDescStr ${LANG_FRENCH} "Gestionnaire de contacts"

  ;Language strings for language selection dialog
  LangString LangDialog_Title ${LANG_ENGLISH} "Installer Language|$(^CancelBtn)"
  LangString LangDialog_Title ${LANG_FRENCH} "Langue d'installation|$(^CancelBtn)"

  LangString LangDialog_Text ${LANG_ENGLISH} "Please select the installer language."
  LangString LangDialog_Text ${LANG_FRENCH} "Choisissez la langue du programme d'installation."

  ;language strings for checkbox
  LangString Check_box ${LANG_ENGLISH} "Install a shortcut on the desktop"
  LangString Check_box ${LANG_FRENCH} "Installer un raccourci sur le bureau"

  ;Cannot install
  LangString No_Install ${LANG_ENGLISH} "The application cannot be installed on a 32bit system"
  LangString No_Install ${LANG_FRENCH} "Cette application ne peut pas être installée sur un système 32bits"
  
  ; Language styring for remove old install
  LangString Remove_Old ${LANG_ENGLISH} "Install will remove a previous installation."
  LangString Remove_Old ${LANG_FRENCH} "Install va supprimer une ancienne installation."

  !define MUI_LANGDLL_WINDOWTITLE "$(LangDialog_Title)"
  !define MUI_LANGDLL_INFO "$(LangDialog_Text)"
;--------------------------------

  !getdllversion  "${source_dir}\contactmgrwin64.exe" expv_
  !define FileVersion "${expv_1}.${expv_2}.${expv_3}.${expv_4}"

  VIProductVersion "${FileVersion}"
  VIAddVersionKey "FileVersion" "${FileVersion}"
  VIAddVersionKey "ProductName" "InstallContactsmgr.exe"
  VIAddVersionKey "FileDescription" "ContactManager Installer"
  VIAddVersionKey "LegalCopyright" "sdtp - bb"
  VIAddVersionKey "ProductVersion" "${FileVersion}"

  ; Change nsis brand line
  BrandingText "$(ProgramDescStr) version ${FileVersion} - bb - sdtp"

; The stuff to install
Section "" ;No components page, name is not important
  SetShellVarContext all
  SetOutPath "$INSTDIR"

  ${If} ${RunningX64}
    SetRegView 64    ; change registry entries and install dir for 64 bit
  ${EndIf}
  Var /GLOBAL prg_to_inst
  Var /GLOBAL prg_to_del
  
  ${If} ${RunningX64}  ; change registry entries and install dir for 64 bit
     StrCpy "$prg_to_inst" "$INSTDIR\contactmgrwin64.exe"
     StrCpy "$prg_to_del" "$INSTDIR\contactmgrwin32.exe"
     File "${lazarus_dir}\openssl\win64\libeay32.dll"
     File "${lazarus_dir}\openssl\win64\ssleay32.dll"
     File "${lazarus_dir}\openssl\OpenSSL License.txt"
  ${Else}
     StrCpy "$prg_to_inst" "$INSTDIR\contactmgrwin32.exe"
     StrCpy "$prg_to_del" "$INSTDIR\contactmgrwin64.exe"
     File "${lazarus_dir}\openssl\win32\libeay32.dll"
     File "${lazarus_dir}\openssl\win32\ssleay32.dll"
     File "${lazarus_dir}\openssl\OpenSSL License.txt"
   ${EndIf}

  ; Dans le cas ou on n'aurait pas pu fermer l'application
  Delete /REBOOTOK "$INSTDIR\contactmgr.exe"
  File "${source_dir}\contactmgrwin64.exe"
  File "${source_dir}\contactmgrwin32.exe"
  File "${source_dir}\licensf.txt"
  File "${source_dir}\license.txt"
  File "${source_dir}\history.txt"
  File "${source_dir}\contactmgr.txt"
  File "${source_dir}\contactmgr.lng"
  Rename /REBOOTOK "$prg_to_inst" "$INSTDIR\contactmgr.exe"
  Delete /REBOOTOK "$prg_to_del"

  ; write out uninstaller
  WriteUninstaller "$INSTDIR\uninst.exe"
  
  ; Get install folder size
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2

  ;Write uninstall in register
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "DisplayIcon" "$INSTDIR\uninst.exe"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "DisplayName" "$(RemoveStr)"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "DisplayVersion" "${FileVersion}"
  WriteRegDWORD HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "EstimatedSize" "$0"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "Publisher" "SDTP"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "URLInfoAbout" "www.sdtp.com"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "HelpLink" "www.sdtp.com"
  ;Store install folder
  WriteRegStr HKCU "Software\SDTP\contactmgr" "InstallDir" $INSTDIR

SectionEnd ; end the section

; Install shortcuts, language dependant

Section "Start Menu Shortcuts"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\contactmgr"
  CreateShortCut  "$SMPROGRAMS\contactmgr\$(ProgramLnkStr)" "$INSTDIR\contactmgr.exe" "" "$INSTDIR\contactmgr.exe" 0 SW_SHOWNORMAL "" "$(ProgramDescStr)"
  CreateShortCut  "$SMPROGRAMS\contactmgr\$(UninstLnkStr)" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0

SectionEnd

;Uninstaller Section

Section Uninstall
SetShellVarContext all
${If} ${RunningX64}
  SetRegView 64    ; change registry entries and install dir for 64 bit
${EndIf}
; add delete commands to delete whatever files/registry keys/etc you installed here.
Delete /REBOOTOK "$INSTDIR\contactmgr.exe"
Delete "$INSTDIR\history.txt"
Delete "$INSTDIR\contactmgr.txt"
Delete "$INSTDIR\contactmgr.lng"
Delete "$INSTDIR\libeay32.dll"
Delete "$INSTDIR\ssleay32.dll"
Delete "$INSTDIR\licensf.txt"
Delete "$INSTDIR\license.txt"
Delete "$INSTDIR\OpenSSL License.txt"
Delete "$INSTDIR\uninst.exe"

; remove shortcuts, if any.
  Delete  "$SMPROGRAMS\contactmgr\$(ProgramLnkStr)"
  Delete  "$SMPROGRAMS\contactmgr\$(UninstLnkStr)"
  Delete  "$DESKTOP\$(ProgramLnkStr)"


; remove directories used.
  RMDir "$SMPROGRAMS\contactmgr"
  RMDir "$INSTDIR"

DeleteRegKey HKCU "Software\SDTP\contactmgr"
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr"

SectionEnd ; end of uninstall section

Function inst_shortcut
  CreateShortCut "$DESKTOP\$(ProgramLnkStr)" "$INSTDIR\contactmgr.exe"
FunctionEnd

Function .onInit
  ; !insertmacro MUI_LANGDLL_DISPLAY
  ${If} ${RunningX64}
    SetRegView 64    ; change registry entries and install dir for 64 bit
    StrCpy "$INSTDIR" "$PROGRAMFILES64\contactmgr"
  ${Else}

  ${EndIf}
  SetShellVarContext all
  ; Close all apps instance
  FindProcDLL::FindProc "$INSTDIR\contactmgr.exe"
  ${While} $R0 > 0
    FindProcDLL::KillProc "$INSTDIR\contactmgr.exe"
    FindProcDLL::WaitProcEnd "$INSTDIR\contactmgr.exe" -1
    FindProcDLL::FindProc "$INSTDIR\contactmgr.exe"
  ${EndWhile}
  ; See if there is old program
  ReadRegStr $R0 HKLM "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\contactmgr" "UninstallString"
   ${If} $R0 == ""
        Goto Done
   ${EndIf}
  MessageBox MB_OK "$(Remove_Old)"
  ExecWait $R0
  Done:
FunctionEnd