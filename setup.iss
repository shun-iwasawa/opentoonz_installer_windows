﻿; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "OpenToonz"
#define MyAppVersion "1.4.0"
#define MyAppPublisher "DWANGO Co., Ltd."
#define MyAppURL "https://opentoonz.github.io/"
#define MyAppExeName "OpenToonz.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
; AppId={{D9A9B1A3-9370-4BE9-9C8F-7B52EEECB973} (until v1.2.1)
AppId={{DF519282-600D-4E03-9190-6046329B1CB4}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\OpenToonz
DefaultGroupName=OpenToonz
AllowNoIcons=yes
LicenseFile=license.rtf
OutputBaseFilename=OpenToonzSetup
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "jp"; MessagesFile: "compiler:Languages\Japanese.isl"; LicenseFile: "license_ja.rtf"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Files]
#include "files.iss"

[Dirs]
Name: "{code:GetGeneralDir}\plugins"; Flags: uninsneveruninstall
Name: "{code:GetGeneralDir}\toonzfarm"; Flags: uninsneveruninstall
Name: "{code:GetGeneralDir}\projects"; Flags: uninsneveruninstall

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Registry]
Root: HKLM; Subkey: "Software\OpenToonz"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; ValueType: string; ValueName: "TOONZROOT"; ValueData: "{code:GetGeneralDir}"
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; ValueType: string; ValueName: "TOONZPROJECTS"; ValueData: "{code:GetGeneralDir}\projects"
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; ValueType: string; ValueName: "TOONZCONFIG"; ValueData: "{code:GetGeneralDir}\config"
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; ValueType: string; ValueName: "TOONZPROFILES"; ValueData: "{code:GetGeneralDir}\profiles"
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; ValueType: string; ValueName: "TOONZFXPRESETS"; ValueData: "{code:GetGeneralDir}\fxs"
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; ValueType: string; ValueName: "TOONZLIBRARY"; ValueData: "{code:GetGeneralDir}\library"
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; ValueType: string; ValueName: "TOONZSTUDIOPALETTE"; ValueData: "{code:GetGeneralDir}\studiopalette"
Root: HKLM; Subkey: "Software\OpenToonz\OpenToonz"; ValueType: string; ValueName: "FARMROOT"; ValueData: ""

[Dirs]
Name: {code:GetGeneralDir}; Flags: uninsneveruninstall

[CustomMessages]
en.GeneralDirPageTitle=Choose Destination Location for Stuff Folder
en.GeneralDirPageDescription=Select the folder where setup will install the OpenToonz Stuff folder containing various setting files
en.GeneralDirPageLabel=Install the OpenToonz Stuff folder to:
en.OverwriteStuffCheckBoxLabel=Overwrite all setting files in the Stuff folder except user's personal settings 

jp.GeneralDirPageTitle=Stuffフォルダのインストール先の選択
jp.GeneralDirPageDescription=各種設定が保存されるStuffフォルダのインストール先を選択してください
jp.GeneralDirPageLabel=Stuffフォルダのインストール先:
jp.OverwriteStuffCheckBoxLabel=ユーザーの個人設定以外のStuffフォルダ内の設定ファイルを全て上書きする

fr.GeneralDirPageTitle=Choose Destination Location for Stuff Folder
fr.GeneralDirPageDescription=Select the folder where setup will install the OpenToonz Stuff folder containing various setting files
fr.GeneralDirPageLabel=Install the OpenToonz Stuff folder to:
fr.OverwriteStuffCheckBoxLabel=Overwrite all setting files in the Stuff folder except user's personal settings 

it.GeneralDirPageTitle=Choose Destination Location for Stuff Folder
it.GeneralDirPageDescription=Select the folder where setup will install the OpenToonz Stuff folder containing various setting files
it.GeneralDirPageLabel=Install the OpenToonz Stuff folder to:
it.OverwriteStuffCheckBoxLabel=Overwrite all setting files in the Stuff folder except user's personal settings

[Code]
var
  GeneralDirPage: TInputDirWizardPage;
  OverwriteStuffCheckBox: TNewCheckBox;

procedure InitializeWizard;
begin
  GeneralDirPage := CreateInputDirPage(wpSelectDir,
    CustomMessage('GeneralDirPageTitle'),
    CustomMessage('GeneralDirPageDescription'),
    CustomMessage('GeneralDirPageLabel'),
    False,
    '');
  GeneralDirPage.Add('');
  GeneralDirPage.Values[0] := 'C:\OpenToonz stuff';
  OverwriteStuffCheckBox := TNewCheckBox.Create(GeneralDirPage);
  OverwriteStuffCheckBox.Caption := CustomMessage('OverwriteStuffCheckBoxLabel');
  OverwriteStuffCheckBox.Parent := GeneralDirPage.Surface;
  OverwriteStuffCheckBox.Top := ScaleY(70);
  OverwriteStuffCheckBox.Width := GeneralDirPage.SurfaceWidth;
  OverwriteStuffCheckBox.Checked := True;
end;

function GetGeneralDir(Param: String): String;
begin
  Result := GeneralDirPage.Values[0];
end;

function IsOverwiteStuffCheckBoxChecked: Boolean;
begin
  Result := OverwriteStuffCheckBox.Checked;
end;
