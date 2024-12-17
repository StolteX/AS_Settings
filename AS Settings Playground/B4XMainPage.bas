B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private AS_Settings1 As AS_Settings
	Private SettingPage2 As AS_SettingsPage
End Sub

Public Sub Initialize
	
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("frm_main")
	
	B4XPages.SetTitle(Me,"AS Settings Example")
	
	ChangeTheme(AS_Properties.GetPropertyDefault("PropertyName_1",True),0) 'Dark or Light mode

	AS_Settings1.MainPage.AddGroup("Basic","Basic Settings")
		
	AS_Settings1.MainPage.AddDescriptionItem("","Show sync help: when enabled, you'll see an explanation alert every time you tap 'Sync' on the Today tab.")
	
	'Boolean
	'AS_Settings1.MainPage.AddProperty_Boolean("Basic","PropertyName_1","Overview in the morning","Your goals for today: Goal1, Goal2, Goal3",Null,True)
	AS_Settings1.MainPage.AddProperty_Boolean("Basic","PropertyName_1","Light/Dark","",Null,True)
	AS_Settings1.MainPage.AddProperty_Boolean("Basic","PropertyName_2","Boolean Property False","Description Long Long Long Long Long Long Long Long Long Long Long Long Long Long Test Text",Null,False)

	AS_Settings1.MainPage.AddProperty_Boolean("Basic","PropertyName_3","Boolean Property True with a long text","",Null,True)
	'Action Button
	AS_Settings1.MainPage.AddProperty_Action("Basic","PropertyName_4","Action Property","Description Long Long Long Long Long Long Long Long Long Long Long Long Long Long Test Text",Null,"English")
	AS_Settings1.MainPage.AddProperty_Action("Basic","PropertyName_5","Icon","",AS_Settings1.FontToBitmap(Chr(0xF179),False,30,xui.Color_White),"English, German, Italian, Spanish, Swedish")
	AS_Settings1.MainPage.AddProperty_ActionClean("Basic","PropertyName_6","Delete Account","",AS_Settings1.FontToBitmap(Chr(0xE92B),True,34,xui.Color_White))
	AS_Settings1.MainPage.AddProperty_Action("Basic","PropertyName_7","Pro Feature","",Null,"Pro")
	
	AS_Settings1.MainPage.AddGroup("Advanced","Advanced Settings")
	
	'Numeric Example
	AS_Settings1.MainPage.AddProperty_Text("Advanced","PropertyName_8","Text Example","",Null,"Test",100dip,AS_Settings1.InputType_Text)
	AS_Settings1.MainPage.AddProperty_Text("Advanced","PropertyName_9","Numeric Example","",Null,24,60dip,AS_Settings1.InputType_Numeric)
	AS_Settings1.MainPage.AddProperty_Text("Advanced","PropertyName_10","Decimal Example","",Null,24.24,100dip,AS_Settings1.InputType_Decimal)
	'AS_Settings1.MainPage.AddProperty_Text("Advanced","PropertyName_12","Decimal Example",Null,24.24,100dip,AS_Settings1.InputType_IPv4,"")
	'ComboBox
	AS_Properties.RemoveProperty("PropertyName_11")
	AS_Settings1.MainPage.AddProperty_ComboBox("Advanced","PropertyName_11","ComboBox Example","",Null,"Option 2",Array("Option 1","Option 2","Option 3","Option 4"))
	
	AS_Properties.SetDefaultValue("PropertyName_13","Key3")
	Dim ComboBox2 As B4XOrderedMap = B4XCollections.CreateOrderedMap2(Array("Key1","Key2","Key3","Key4"),Array("DisplayText 1","DisplayText 2","DisplayText 3","DisplayText 4"))
	AS_Settings1.MainPage.AddProperty_ComboBox2("Advanced","PropertyName_13","ComboBox Example2","",Null,AS_Properties.GetDefaultValue("PropertyName_13"),ComboBox2)
	
	AS_Settings1.MainPage.BottomText = "Alexander Stolte" & CRLF & "V1.0.2"
	

	AS_Settings1.MainPage.Create

	
	'Second Page
	SettingPage2.Initialize(AS_Settings1,"Theme")
	SettingPage2.Height = 600dip
	
	SettingPage2.AddProperty_Custom("","CustomButton1",80dip)
	
	SettingPage2.AddGroup("Basic","Accent Color")
	
	SettingPage2.AddProperty_Boolean("Basic","PropertyName_1","Light/Dark","",Null,True)
	
	SettingPage2.AddGroup("MultiOptionExample","Accent Color")
	
	Dim lst_Items As List
	lst_Items.Initialize
	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Green Green Green Green Green Green Green Green Green",AS_Settings1.FontToBitmap(Chr(0xF111),False,30,xui.Color_RGB(45, 136, 121)),1))
	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Blue",AS_Settings1.FontToBitmap(Chr(0xF111),False,30,xui.Color_RGB(73, 98, 164)),2))
	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Red",AS_Settings1.FontToBitmap(Chr(0xF111),False,30,xui.Color_RGB(221, 95, 96)),3))
	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Purple",AS_Settings1.FontToBitmap(Chr(0xF111),False,30,xui.Color_RGB(141, 68, 173)),4))
	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Magenta",AS_Settings1.FontToBitmap(Chr(0xF111),False,30,xui.Color_Magenta),5))
	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Cyan",AS_Settings1.FontToBitmap(Chr(0xF111),False,30,xui.Color_Cyan),6))
	AS_Properties.RemoveProperty("OptionsExample1")
	SettingPage2.AddProperty_SelectionList("MultiOptionExample","OptionsExample1",lst_Items,Array(1),False,False)

	SettingPage2.AddGroup("ColorChooser","Choose Color")

	Dim lst_Colors As List
	lst_Colors.Initialize
	lst_Colors.Add(xui.Color_ARGB(255, 49, 208, 89))
	lst_Colors.Add(xui.Color_ARGB(255, 25, 29, 31))
	lst_Colors.Add(xui.Color_ARGB(255, 9, 131, 254))
	lst_Colors.Add(xui.Color_ARGB(255, 255, 159, 10))
	
	lst_Colors.Add(xui.Color_ARGB(255, 45, 136, 121))
	lst_Colors.Add(AS_Settings1.CreateColorItem(xui.Color_ARGB(255, 73, 98, 164),False))
	lst_Colors.Add(AS_Settings1.CreateColorItem(xui.Color_ARGB(255, 221, 95, 96),False))
	lst_Colors.Add(AS_Settings1.CreateColorItem(xui.Color_ARGB(255, 141, 68, 173),False))
	lst_Colors.Add(xui.Color_Magenta)
	lst_Colors.Add(xui.Color_Cyan)

	'SettingPage2.AddProperty_ColorChooser("ColorChooser","AppColor",lst_Colors,Null,50dip,Null)
	
	SettingPage2.AddProperty_ColorChooser("ColorChooser","AppColor",lst_Colors,xui.Color_Magenta,50dip,AS_Settings1.FontToBitmap(Chr(0xE897),True,30,xui.Color_LightGray))

	'AS_Properties.RemoveProperty("OptionsExample1")

'	Sleep(4000)
'	Log("jetzt")
'	AS_Settings1.MainPage.GetProperty("PropertyName_1").Description = "Last Backup Backup Backup: Now"
'	AS_Settings1.MainPage.Refresh
End Sub

Private Sub B4XPage_KeyboardStateChanged (Height As Float)
	
	AS_Settings1.Base_Resize(Root.Width,Root.Height - Height)
	
End Sub

Private Sub ChangeTheme(Dark As Boolean,Duration As Long)
	If Duration > 0 Then Sleep(Duration) 'If you are using an switch to change this, then it is recommented a delay of 200 milliseconds
	If Dark Then
		AS_Settings1.Theme = AS_Settings1.Theme_Dark
	Else
		AS_Settings1.Theme = AS_Settings1.Theme_Light
	End If
End Sub

Private Sub AS_Settings1_ValueChanged(Property As AS_Settings_Property, Value As Object)
	'Log("ValueChanged " & Property.PropertyName & ": " & Value)

	Select Property.PropertyName
		
		Case "AppColor"
			LogColor("Lul",Value)
		
		Case "PropertyName_1"
			ChangeTheme(Value,200)
		Case "PropertyName_2"
			AS_Settings1.MainPage.SetProperty_Boolean("PropertyName_3",Value)
			AS_Settings1.MainPage.SetProperty_Boolean("PropertyName_4",Value)
			AS_Settings1.MainPage.GetProperty("PropertyName_3").View.As(B4XSwitch).Enabled = Value
			AS_Settings1.MainPage.GetProperty("PropertyName_4").View.As(B4XSwitch).Enabled = Value
			
		Case "OptionsExample1"
			
			If Property.Value.As(List).Get(0).As(Int) = 1 Then
				AS_Settings1.Theme = AS_Settings1.Theme_Light
			Else If Property.Value.As(List).Get(0).As(Int) = 2 Then
				AS_Settings1.Theme = AS_Settings1.Theme_Dark
			End If
			SettingPage2.Refresh
		Case Else
			Log("PropertyName: " & Property.PropertyName & " Value: " & Value)
	End Select
	
End Sub

Private Sub AS_Settings1_ActionClicked(Property As AS_Settings_Property)
	Log("ActionClicked: " & Property.PropertyName)
	
	Select Property.PropertyName
		Case "PropertyName_4"
			'Do something
		Case "PropertyName_5"
			'Do something
		Case "PropertyName_6"
			'Do something
			
	End Select
	
	If Property.PropertyName = "PropertyName_4" Or Property.PropertyName = "PropertyName_5" Or Property.PropertyName = "PropertyName_7" Then	
		'Shows an input box
		'ShowInputBox(Property.Value,Property.PropertyName)
		SettingPage2.ShowPage
	End If

End Sub

Private Sub AS_Settings1_CustomDrawProperty(CustomDrawProperty As AS_Settings_CustomDrawProperty)
	
	If CustomDrawProperty.Property.PropertyName = "PropertyName_6" Then
		CustomDrawProperty.PropertyViews.NameLabel.TextColor = xui.Color_ARGB(255,221, 95, 96)
		CustomDrawProperty.PropertyViews.IconImageView.SetBitmap(AS_Settings1.FontToBitmap(Chr(0xE92B),True,34,xui.Color_ARGB(255,221, 95, 96)))
	else If CustomDrawProperty.Property.PropertyName = "PropertyName_7" Then
		
		Dim ChipWidth As Float = 45dip
		Dim ChipHeight As Float = 20dip
		
		Dim xlbl_ProVersionChip As B4XView = CustomDrawProperty.PropertySettingViews.ActionValueLabel
		Dim xlbl_ActionButtonArrowLabel As B4XView = CustomDrawProperty.PropertySettingViews.ActionButtonArrowLabel
		xlbl_ProVersionChip.SetTextAlignment("CENTER","CENTER")
		xlbl_ProVersionChip.Font = xui.CreateDefaultBoldFont(15)
		xlbl_ProVersionChip.SetColorAndBorder(xui.Color_ARGB(255,81,190,97),0,0,ChipHeight/2)
		'Resize the Chip Label
		xlbl_ProVersionChip.SetLayoutAnimated(0,xlbl_ActionButtonArrowLabel.Left - ChipWidth - 5dip,CustomDrawProperty.PropertySettingViews.BackgroundPanel.Height/2 - ChipHeight/2,ChipWidth,ChipHeight)
	
	End If
	
End Sub


Private Sub ShowInputBox(DefaultText As String,PropertyName As String)
	Dim dialog As B4XDialog
	dialog.Initialize(Root)
	Dim input As B4XInputTemplate
	input.Initialize
	input.lblTitle.Text = "Title"
	input.Text = DefaultText
	Wait For (dialog.ShowTemplate(input, "OK", "", "CANCEL")) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		AS_Properties.PutProperty(PropertyName,input.Text)
		AS_Settings1.MainPage.Refresh
	End If
End Sub

Private Sub AS_Settings1_CustomDrawCustomProperty(CustomProperty As AS_Settings_CustomDrawCustomProperty)
	Select CustomProperty.Property.PropertyName
		Case "CustomButton1"
			
			Dim xpnl_CustomButton1 As B4XView = xui.CreatePanel("xpnl_CustomButton1")
			CustomProperty.BackgroundPanel.AddView(xpnl_CustomButton1,10dip,5dip,Root.Width - 10dip*2,CustomProperty.Height - 5dip*2)
			xpnl_CustomButton1.SetColorAndBorder(xui.Color_White,0,0,10dip)
			
			Dim xlbl_TopText As B4XView = CreateLabel("")
			Dim xlbl_BottomText As B4XView = CreateLabel("")
			
			xlbl_TopText.Text = "Danke für die Verwendung von"
			xlbl_TopText.Font = xui.CreateDefaultFont(17)
			xlbl_TopText.TextColor = xui.Color_Black
			xlbl_TopText.SetTextAlignment("CENTER","LEFT")
		
			xlbl_BottomText.Text = "CleanTasks Pro"
			xlbl_BottomText.Font = xui.CreateDefaultBoldFont(20)
			xlbl_BottomText.TextColor = xui.Color_Black
			xlbl_BottomText.SetTextAlignment("CENTER","LEFT")
			
			xpnl_CustomButton1.AddView(xlbl_TopText,20dip,10dip,xpnl_CustomButton1.Width - 20dip*2,20dip)
			xpnl_CustomButton1.AddView(xlbl_BottomText,20dip,40dip,xpnl_CustomButton1.Width - 20dip*2,20dip)
			
	End Select
End Sub

Private Sub CreateLabel(EventName As String) As B4XView
	Dim lbl As Label
	lbl.Initialize(EventName)
	Return lbl
End Sub

Private Sub AS_Settings1_DisabledItemClicked(Property As AS_Settings_Property, Value As Object)
	LogColor("DisabledItemClicked",Value)
	EnableAllItems(SettingPage2.GetProperty("AppColor").PropertyType)
End Sub

Private Sub EnableAllItems(ColorChooserProperty As AS_Settings_Property_ColorChooser)
	ColorChooserProperty.Property.Icon = Null 'Resets the icon e.g. the premium icon
	For i = 0 To ColorChooserProperty.ColorList.Size -1
		If ColorChooserProperty.ColorList.Get(i) Is AS_Settings_ColorItem Then
			ColorChooserProperty.ColorList.Get(i).As(AS_Settings_ColorItem).Enabled = True 'Enables this item
		End If
	Next
	SettingPage2.Refresh
End Sub