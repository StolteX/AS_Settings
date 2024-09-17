B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.3
@EndOfDesignText@
Sub Class_Globals
	
	Private xui As XUI
	Private m_Settings As AS_Settings
	Private m_DisplayName As String
	Private lst_Items As List
	
	Private xpnl_Page As B4XView
	Private xiv_RefreshImage As B4XView
	Private xclv_Main As CustomListView
	#IF B4A or B4I
	Private xpnl_DragIndicator As B4XView
	Private m_StartY As Float
	Private m_LastY As Float
	#Else

	#End If
	Private xpnl_SecondPageBackground As B4XView
	Private xpnl_Header As B4XView
	
	Private xiv_ExitIcon As B4XView
	Private xpnl_ExitIcon As B4XView
	Private xlbl_HeaderText As B4XView
	
	Private isReady As Boolean = False
	Private isMainPage As Boolean = False
	Private m_BottomText As String
	Private m_Height As Float = 500dip
	Private isVisible As Boolean = False 'Ignore
	
	#If B4I
	Private nome As NativeObject=Me
	Private mView As View'ignore
	Private mView2 As View'ignore
	#End If
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Settings As AS_Settings,DisplayName As String)
	isMainPage = Settings.Pages.NumberOfViews = 0
	lst_Items.Initialize
	m_Settings = Settings
	m_DisplayName = DisplayName
	
	If xui.IsB4J And isMainPage = False Then
		xpnl_Page = xui.CreatePanel("xpnl_Page")
	Else
		xpnl_Page = xui.CreatePanel("")
	End If
	
	If isMainPage = False Then
		xpnl_SecondPageBackground = xui.CreatePanel("xpnl_SecondPageBackground")
		m_Settings.Pages.AddView(xpnl_SecondPageBackground,-100000dip,0,m_Settings.Pages.Width,m_Settings.Pages.Height)
		xpnl_SecondPageBackground.Color = m_Settings.SecondPageShadowColor
		xpnl_SecondPageBackground.Visible = False
	End If
	
	#IF B4J
	If isMainPage = False Then
		xpnl_SecondPageBackground.AddView(xpnl_Page,0,0,500dip,600dip)
		xpnl_Page.SetColorAndBorder(m_Settings.BackgroundColor,0,0,15dip)
		SetCircleClip(xpnl_Page,15dip)
	Else
		m_Settings.Pages.AddView(xpnl_Page,IIf(isMainPage,0,-100000dip),0,m_Settings.Pages.Width,m_Settings.Pages.Height)
	End If
	#Else
	m_Settings.Pages.AddView(xpnl_Page,IIf(isMainPage,0,-100000dip),0,m_Settings.Pages.Width,IIf(isMainPage,m_Settings.Pages.Height,m_Height))
	#End If
	
	Dim xpnl_ListBackground As B4XView = xui.CreatePanel("")
	xpnl_Page.AddView(xpnl_ListBackground,0,IIf(isMainPage,0,IIf(m_DisplayName <> "", m_Settings.HeaderHeight,0)),xpnl_Page.Width,xpnl_Page.Height - IIf(isMainPage,0,IIf(m_DisplayName <> "", m_Settings.HeaderHeight,0)))
	#IF B4J
	xpnl_ListBackground.Top = xpnl_ListBackground.Top - 2dip
	#End If
	
	xclv_Main = ini_xclv("xclv_Main",xpnl_ListBackground,xui.IsB4J)
	
	xpnl_Header = xui.CreatePanel("xpnl_Header")
	#IF B4A or B4I
	xpnl_DragIndicator = xui.CreatePanel("")
	#End If
	
	If isMainPage = False And m_DisplayName <> "" Then
		
		xpnl_Page.AddView(xpnl_Header,0,0,xpnl_Page.Width,m_Settings.HeaderHeight)
		xpnl_Header.Color = m_Settings.BackgroundColor
		
		xpnl_ExitIcon = xui.CreatePanel("xpnl_ExitIcon")
		xiv_ExitIcon = CreateImageView("")
		
		Dim IconWidthHeight As Float = 12dip
		Dim IconBackgroundWidthHeight As Float = 25dip
		
		#If B4A or B4I
		
		'DragIndicator
		xpnl_Header.AddView(xpnl_DragIndicator,xpnl_Page.Width/2 - 70dip/2,(m_Settings.HeaderHeight/2)/2,70dip,6dip)
		xpnl_DragIndicator.SetColorAndBorder(m_Settings.DragIndicatorColor,0,0,3dip)
		
		#End If
		
		xpnl_Header.AddView(xpnl_ExitIcon,xpnl_Page.Width - IconBackgroundWidthHeight - 15dip,m_Settings.HeaderHeight/2 - IconBackgroundWidthHeight/2,IconBackgroundWidthHeight,IconBackgroundWidthHeight)
		
		xpnl_ExitIcon.AddView(xiv_ExitIcon,xpnl_ExitIcon.Width/2 - IconWidthHeight/2,xpnl_ExitIcon.Height/2 - IconWidthHeight/2,IconWidthHeight,IconWidthHeight)
		xiv_ExitIcon.SetBitmap(m_Settings.FontToBitmap(Chr(0xE5CD),True,45,xui.Color_White))
		xpnl_ExitIcon.SetColorAndBorder(m_Settings.ExitIconColor,0,0,xpnl_ExitIcon.Height/2)
		
		xlbl_HeaderText = CreateLabel("")
		xlbl_HeaderText.Text = m_DisplayName
		xlbl_HeaderText.SetTextAlignment("CENTER","CENTER")
		xlbl_HeaderText.Font = xui.CreateDefaultFont(20)
		xlbl_HeaderText.TextColor = m_Settings.SecondPageHeaderTextColor
		xpnl_Header.AddView(xlbl_HeaderText,0,m_Settings.HeaderHeight/2,xpnl_Page.Width,m_Settings.HeaderHeight/2)
		
		#If B4J
		
		xlbl_HeaderText.Top = xpnl_Header.Height/2 - xlbl_HeaderText.Height/2
		xpnl_ExitIcon.Left = xpnl_Header.Width - xpnl_ExitIcon.Width - 15dip
		#Else
		xlbl_HeaderText.Top = xlbl_HeaderText.Top - 5dip
		#End If
		
	End If
	
	#If B4J
	Dim xtf_DummyTextBox As B4XView = CreateEditText("xtf_TextBox",m_Settings.InputType_Text)
	xpnl_Page.AddView(xtf_DummyTextBox,-10000dip,0,2dip,2dip)
	
	If isMainPage = False Then
'		xpnl_ExitIcon.Left = xpnl_Page.Width - xpnl_ExitIcon.Width + 10dip
		xiv_ExitIcon.SetBitmap(m_Settings.FontToBitmap(Chr(0xE5CD),True,45,xui.Color_White))
		xlbl_HeaderText.Left = 12dip
	End If
	
	#End If
	
	If isMainPage = False Then
	#If B4A
	Private r As Reflector
	r.Target = xpnl_Header
	r.SetOnTouchListener("xpnl_Header_Touch2")
'	r.Target = xclv_Main.sv
'	r.SetOnTouchListener("xpnl_Header_Touch2")
	#Else If B4I
		AddPanGesture(1,2)
	#End If
	End If
	
	xiv_RefreshImage = CreateImageView("")
	xiv_RefreshImage.Visible = False
	xpnl_Page.AddView(xiv_RefreshImage,0,0,xpnl_Page.Width,xpnl_Page.Height)
End Sub

Public Sub Base_Resize(Width As Float,Height As Float)
	xiv_RefreshImage.SetLayoutAnimated(0,0,0,Width,Height)
	If isMainPage Then
		xpnl_Page.SetLayoutAnimated(0,0,0,Width,Height)
		xclv_Main.AsView.Width = Width
		xclv_Main.AsView.Height = xpnl_Page.Height - IIf(isMainPage,0,IIf(m_DisplayName <> "", m_Settings.HeaderHeight,0))
		xclv_Main.Base_Resize(xclv_Main.AsView.Width,xclv_Main.AsView.Height)
		
	Else
		
		xpnl_SecondPageBackground.SetLayoutAnimated(0,0,0,Width,Height)
		
		#If B4J
		
		If isVisible Then
			xpnl_Page.Left = m_Settings.mBase.Width/2 - xpnl_Page.Width/2
			xpnl_Page.Top = m_Settings.mBase.Height/2 - xpnl_Page.Height/2
		End If
		
		#End If
		
	End If
	
End Sub

#Region AddThings


Public Sub AddGroup(GroupKey As String,Name As String)
	
	Dim lst_Props As List
	lst_Props.Initialize
	
	Dim Group As AS_Settings_Group = CreateAS_Settings_Group(GroupKey,Name,lst_Props)
	lst_Items.Add(Group)
	
End Sub

'GroupKey - Optional
Public Sub AddSpaceItem(PageKey As String,GroupKey As String,Height As Float) As AS_Settings_SpaceItem
	
	Dim SpaceItem As AS_Settings_SpaceItem
	SpaceItem.Initialize
	SpaceItem.GroupKey = GroupKey
	SpaceItem.Height = Height
	SpaceItem.BackgroundColor = m_Settings.BackgroundColor
	
	If GroupKey = "" Then
		
		lst_Items.Add(SpaceItem)
		
	Else
			
		Dim Group As AS_Settings_Group = GetGroup(GroupKey)
		Dim lst_Properties As List = Group.Properties
	
		lst_Properties.Add(SpaceItem)
		
	End If
	
	Return SpaceItem
	
End Sub

'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-descriptionitem.159268/</code>
Public Sub AddDescriptionItem(GroupKey As String,Text As String) As AS_Settings_DescriptionItem
	
	Dim DescriptionItem As AS_Settings_DescriptionItem
	DescriptionItem.Initialize
	DescriptionItem.GroupKey = GroupKey
	DescriptionItem.Text = Text
	DescriptionItem.SidePadding = m_Settings.Padding + 10dip
	DescriptionItem.TopPadding = m_Settings.Padding
	
	DescriptionItem.xFont = xui.CreateDefaultFont(15)
	DescriptionItem.HorizontalAlignment = "LEFT"
	
	If GroupKey = "" Then
		
		lst_Items.Add(DescriptionItem)
		
	Else
			
		Dim Group As AS_Settings_Group = GetGroup(GroupKey)
		Dim lst_Properties As List = Group.Properties
	
		lst_Properties.Add(DescriptionItem)
		
	End If

	Return DescriptionItem
	
End Sub

'<code>AS_Settings1.AddProperty_Boolean("General","PropertyName_1","Boolean Property True",Null,True)</code>
'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-boolean-property.159261/</code>
Public Sub AddProperty_Boolean(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap,DefaultValue As Boolean) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	Property.DefaultValue = DefaultValue
	
	Dim Property_Boolean As AS_Settings_Property_Boolean
	Property_Boolean.Initialize
	
	
	Property.PropertyType = Property_Boolean
	
	If GroupKey <> "" Then
		lst_Properties.Add(Property)
	End If
	
	Return Property
	
End Sub

'MultiSelect - If true more than one item can selected. If false only one item is selected if you click, it deselect the previous item
'CanDeselectAll - If false, then the last item cannot be deselected, it need min one selected
'<code>
'	SettingPage2.AddGroup("MultiOptionExample","Multi Option")
'	
'	Dim lst_Items As List
'	lst_Items.Initialize
'	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Option #1",Null,1))
'	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Option #2",Null,2))
'	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Option #3",Null,3))
'	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Option #4",Null,4))
'	lst_Items.Add(AS_Settings1.CreateSelectionListItem("Option #5",Null,5))
'	
'	SettingPage2.AddProperty_SelectionList("MultiOptionExample","OptionsExample1",lst_Items,Array(),False,True)
'</code>
'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-selectionlist-property.159217/</code>
Public Sub AddProperty_SelectionList(GroupKey As String,PropertyName As String,ListItems As List,DefaultValue As List,MultiSelect As Boolean,CanDeselectAll As Boolean) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = ""
	Property.Description = ""
	Property.Icon = Null
	
	#If B4A or B4J
	Dim lst As List
	lst.Initialize
	lst.AddAll(DefaultValue)
	Property.DefaultValue = lst
	#Else
		Property.DefaultValue = DefaultValue
	#End If
	
	Dim Property_SelectionList As AS_Settings_Property_SelectionList
	Property_SelectionList.Initialize
	Property_SelectionList.ListItems = ListItems

	Property_SelectionList.MultiSelect = MultiSelect
	Property_SelectionList.CanDeselectAll = CanDeselectAll
	Property_SelectionList.Property = Property
	
	Property.PropertyType = Property_SelectionList
	
	lst_Properties.Add(Property)
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		Dim Value As List = AS_Properties.GetProperty(Property.PropertyName)
		Value = IIf(Value.IsInitialized = False,IIf(Property.DefaultValue = Null,CreateList,Property.DefaultValue),Value)
		If Value.IsInitialized = False Then
			Value.Initialize
		End If
		Property.Value = Value
	End If
	
	Return Property
	
End Sub

Private Sub CreateList As List
	Dim lst As List
	lst.Initialize
	Return lst
End Sub

'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-text-property.159265/</code>
Public Sub AddProperty_Text(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap,DefaultValue As Object,Width As Float,InputType As String) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Property As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	Property.DefaultValue = DefaultValue
	
	Dim Property_Text As AS_Settings_Property_Text
	Property_Text.Initialize
	Property_Text.Width = Width
	Property_Text.InputType = InputType

	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		Dim DisplayValueText As Object = AS_Properties.GetPropertyDisplayValueText(Property.PropertyName)
		Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
		Property.DisplayValueText = IIf(DisplayValueText = Null,"",DisplayValueText)
	End If
	
	Property.PropertyType = Property_Text
	
	lst_Property.Add(Property)
	
	Return Property
	
End Sub

'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-action-property.159263/</code>
Public Sub AddProperty_Action(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap,DefaultValue As Object) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	Property.DefaultValue = DefaultValue
	
	Dim Property_Action As AS_Settings_Property_Action
	Property_Action.Initialize
	
	
	If m_Settings.saveMode = m_Settings.SaveMode_Automatic Then
		Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		Dim DisplayValueText As Object = AS_Properties.GetPropertyDisplayValueText(Property.PropertyName)
		Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
		Property.DisplayValueText = IIf(DisplayValueText = Null,"",DisplayValueText)
	End If
	
	Property.PropertyType = Property_Action
	lst_Properties.Add(Property)
	
	Return Property
	
End Sub

'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-actionclean-property.159264/</code>
Public Sub AddProperty_ActionClean(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	
	Dim Property_ActionClean As AS_Settings_Property_ActionClean
	Property_ActionClean.Initialize
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		'Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		Dim DisplayValueText As Object = AS_Properties.GetPropertyDisplayValueText(Property.PropertyName)
		'Property_ActionClean.Value = IIf(Value = Null,Property_ActionClean.DefaultValue,Value)
		Property.DisplayValueText = IIf(DisplayValueText = Null,"",DisplayValueText)
	End If
	
	Property.PropertyType = Property_ActionClean
	lst_Properties.Add(Property)
	
	Return Property
	
End Sub

'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-combobox-property.159266/#post-977923</code>
Public Sub AddProperty_ComboBox(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap,DefaultValue As String,ItemList As List) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	Property.DefaultValue = DefaultValue
	
	Dim Property_ComboBox As AS_Settings_Property_ComboBox
	Property_ComboBox.Initialize
	Property_ComboBox.ItemList = ItemList
	
	
	If m_Settings.SaveMode = m_Settings.saveMode_Automatic Then
		Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		Dim DisplayValueText As Object = AS_Properties.GetPropertyDisplayValueText(Property.PropertyName)
		Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
		Property.DisplayValueText = IIf(DisplayValueText = Null,"",DisplayValueText)
	End If
	
	Property.PropertyType = Property_ComboBox
	lst_Properties.Add(Property)
	
	Return Property
	
End Sub

'The value is displayed in the ComboBox and the key is used for selection and stored in the database
'<code>
'Dim ComboBox2 As B4XOrderedMap = B4XCollections.CreateOrderedMap2(Array("Key1","Key2","Key3","Key4"),Array("DisplayText 1","DisplayText 2","DisplayText 3","DisplayText 4"))
'AS_Settings1.MainPage.AddProperty_ComboBox2("Advanced","PropertyName_13","ComboBox Example2","",Null,"Key4",ComboBox2)
'</code>
'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-combobox-property.159266/#post-977923</code>
Public Sub AddProperty_ComboBox2(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap,DefaultKey As Object,KeyValue As B4XOrderedMap) As AS_Settings_Property
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	Property.DefaultValue = DefaultKey
	
	Dim Property_ComboBox As AS_Settings_Property_ComboBox
	Property_ComboBox.Initialize
	Property_ComboBox.KeyValue = KeyValue
	
	
	If m_Settings.SaveMode = m_Settings.saveMode_Automatic Then
		Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		Dim DisplayValueText As Object = AS_Properties.GetPropertyDisplayValueText(Property.PropertyName)
		Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
		Property.DisplayValueText = IIf(DisplayValueText = Null,"",DisplayValueText)
	End If
	
	Property.PropertyType = Property_ComboBox
	lst_Properties.Add(Property)
	
	Return Property
	
End Sub

Public Sub AddProperty_Chooser(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap,DefaultValue As String,Width As Float) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	Property.DefaultValue = DefaultValue

	Dim Property_Chooser As AS_Settings_Property_Chooser
	Property_Chooser.Initialize
	
	Property_Chooser.Width = Width
	
	Dim PropertyProperties As AS_Settings_Property_Properties
	PropertyProperties.Initialize
	PropertyProperties.Width = Width
	PropertyProperties.Height = m_Settings.PropertyProperties.Height
	PropertyProperties.BackgroundColor = m_Settings.PropertyProperties.BackgroundColor
	PropertyProperties.FieldBackgroundColor = m_Settings.PropertyProperties.FieldBackgroundColor
	PropertyProperties.FieldHeight = m_Settings.PropertyProperties.FieldHeight
	PropertyProperties.TextColor = m_Settings.PropertyProperties.TextColor
	PropertyProperties.xFont = m_Settings.PropertyProperties.xFont
	PropertyProperties.CornerRadius = m_Settings.PropertyProperties.CornerRadius
	PropertyProperties.InputType = m_Settings.InputType_Text
	
	Property.PropertyType = Property_Chooser
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		Dim DisplayValueText As Object = AS_Properties.GetPropertyDisplayValueText(Property.PropertyName)
		Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
		Property.DisplayValueText = IIf(DisplayValueText = Null,"",DisplayValueText)
	End If
	
	lst_Properties.Add(Property)
	
	Return Property
	
End Sub

'Add your own layout over the CustomDraw Event
Public Sub AddProperty_Custom(GroupKey As String,PropertyName As String,Height As Float) As AS_Settings_Property
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = ""
	Property.Description = ""
	Property.Icon = Null
	Property.DefaultValue = ""
	
	Dim Property_Custom As AS_Settings_Property_Custom
	Property_Custom.Initialize
	Property_Custom.Height = Height
	Property_Custom.Property = Property
	Property.PropertyType = Property_Custom
	
	If GroupKey = "" Then
		
		lst_Items.Add(Property)
		
	Else
			
		Dim Group As AS_Settings_Group = GetGroup(GroupKey)
		Dim lst_Properties As List = Group.Properties
		lst_Properties.Add(Property)
		
	End If
	
	Return Property
	
End Sub

#If SETTINGS_SegmentedTab
'Width: If 0 then the full width is used
'<code>AS_Settings1.AddProperty_SegmentedTab("Basic","PropertyName_1","Segmented Example 1",Null,1,CreateMap("Option 1":"Value1","Option 2":"Value2"),200dip)</code>
'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-with-segmentedtab.148104/</code>
Public Sub AddProperty_SegmentedTab(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap,DefaultValue As String,ItemMap As Map,Width As Float) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	Property.DefaultValue = DefaultValue
	
	Dim Property_SegmentedTab As AS_Settings_Property_SegmentedTab
	Property_SegmentedTab.Initialize
	Property_SegmentedTab.ItemMap = ItemMap
	Property_SegmentedTab.Width = Width
	Property_SegmentedTab.BackgroundColor = m_Settings.SegmentedTabProperties.BackgroundColor
	Property_SegmentedTab.CornerRadius = m_Settings.SegmentedTabProperties.CornerRadius
	Property_SegmentedTab.SelectionColor = m_Settings.SegmentedTabProperties.SelectionColor
	Property_SegmentedTab.SeperatorColor = m_Settings.SegmentedTabProperties.SeperatorColor
	Property_SegmentedTab.ShowSeperators = m_Settings.SegmentedTabProperties.ShowSeperators
	Property_SegmentedTab.TextColor = m_Settings.SegmentedTabProperties.TextColor
	Property_SegmentedTab.xFont = m_Settings.SegmentedTabProperties.xFont
	
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		'Dim DisplayValueText As Object = AS_Properties.GetPropertyDisplayValueText(Property.PropertyName)
		Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
		'Property_SegmentedTab.DisplayValueText = IIf(DisplayValueText = Null,"",DisplayValueText)
	End If
	
	Property.PropertyType = Property_SegmentedTab
	
	lst_Properties.Add(Property)
	
	Return Property
	
End Sub

#End If

#If SETTINGS_PlusMinus
'<code>https://www.b4x.com/android/forum/threads/b4x-as-settings-with-plusminus.148105/</code>
Public Sub AddProperty_PlusMinus(GroupKey As String,PropertyName As String,DisplayName As String,Description As String,Icon As B4XBitmap,DefaultValue As String,MinValue As Int,MaxValue As Int,Increment As Int,Prefix As String,Suffix As String) As AS_Settings_Property
	
	Dim Group As AS_Settings_Group = GetGroup(GroupKey)
	Dim lst_Properties As List = Group.Properties
	
	Dim Property As AS_Settings_Property
	Property.Initialize
	Property.PropertyName = PropertyName
	Property.DisplayName = DisplayName
	Property.Description = Description
	Property.Icon = Icon
	Property.DefaultValue = DefaultValue
	
	Dim PropertyProperties As AS_Settings_Property_Properties
	PropertyProperties.Initialize
	PropertyProperties.Width = 0
	PropertyProperties.Height = m_Settings.PropertyProperties.Height
	PropertyProperties.BackgroundColor = m_Settings.PropertyProperties.BackgroundColor
	PropertyProperties.FieldBackgroundColor = m_Settings.PropertyProperties.FieldBackgroundColor
	PropertyProperties.FieldHeight = m_Settings.PropertyProperties.FieldHeight
	PropertyProperties.TextColor = m_Settings.PropertyProperties.TextColor
	PropertyProperties.xFont = m_Settings.PropertyProperties.xFont
	PropertyProperties.CornerRadius = m_Settings.PropertyProperties.CornerRadius
	PropertyProperties.InputType = m_Settings.InputType_Text
	
	Dim PlusMinusProperties As AS_Settings_Property_PlusMinus
	PlusMinusProperties.Initialize
	
	PlusMinusProperties.PropertyProperties = PropertyProperties
	PlusMinusProperties.MinValue = MinValue
	PlusMinusProperties.MaxValue = MaxValue
	PlusMinusProperties.Increment = Increment
	PlusMinusProperties.Prefix = Prefix
	PlusMinusProperties.Suffix = Suffix
	Property.PropertyType = PlusMinusProperties
	
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
	End If
	
	lst_Properties.Add(Property)
	
	Return Property
	
End Sub
#End If

#End Region

#Region Add2List

Private Sub AddBottomText
	
	Dim xpnl_Background As B4XView = xui.CreatePanel("")
	xpnl_Background.Color = m_Settings.BackgroundColor
	
	Dim xlbl As B4XView = CreateLabel("")
	xlbl.Width = xpnl_Page.Width
	xlbl.Text = m_BottomText
	xlbl.Font = m_Settings.BottomTextProperties.xFont
		#If B4I
	xlbl.As(Label).Multiline = True
	#Else If B4J
	xlbl.As(Label).WrapText = True
	#Else B4A
	xlbl.As(Label).SingleLine = False
	#End If
	
	xpnl_Background.SetLayoutAnimated(0,0,0,xpnl_Page.Width,MeasureMultilineTextHeight(xlbl) + 10dip)
	
	xclv_Main.Add(xpnl_Background,"BottomText")
	
End Sub

Private Sub AddInternBottomText(xpnl_Background As B4XView)
	
	xpnl_Background.Color = m_Settings.BackgroundColor
	
	Dim xlbl As B4XView = CreateLabel("")
	xlbl.Width = xpnl_Page.Width
	xlbl.Text = m_BottomText
	xlbl.Font = m_Settings.BottomTextProperties.xFont
	xlbl.SetTextAlignment("CENTER","CENTER")
	xlbl.TextColor = m_Settings.BottomTextProperties.TextColor
			#If B4I
	xlbl.As(Label).Multiline = True
	#Else If B4J
	xlbl.As(Label).WrapText = True
	#Else B4A
	xlbl.As(Label).SingleLine = False
	#End If
	
	Dim LabelHeight As Float = MeasureMultilineTextHeight(xlbl)
	
	xpnl_Background.AddView(xlbl,0,xpnl_Background.Height/2 - LabelHeight/2,xpnl_Page.Width,LabelHeight)
	
End Sub

Private Sub AddMadeWithLove
	
	Dim xpnl_Background As B4XView = xui.CreatePanel("")
	xpnl_Background.Color = m_Settings.BackgroundColor
	xpnl_Background.SetLayoutAnimated(0,0,0,xpnl_Page.Width,40dip)
	
	xclv_Main.Add(xpnl_Background,"MadeWithLove")
	
End Sub

Private Sub AdInternMadeWithLove(xpnl_Background As B4XView)
	Dim xpnl_MadeWithLoveBackground As B4XView = xui.CreatePanel("")
	xpnl_Background.Color = m_Settings.BackgroundColor
	xpnl_MadeWithLoveBackground.Color = m_Settings.BackgroundColor
	xpnl_MadeWithLoveBackground.SetLayoutAnimated(0,0,xpnl_Background.Height/2 - 20dip/2,xpnl_Page.Width,20dip)
	
	Dim xlbl_MadeWithLove As B4XView = CreateLabel("")
	xlbl_MadeWithLove.TextColor = m_Settings.MadeWithLoveTextColor
	xlbl_MadeWithLove.Font = xui.CreateDefaultFont(15)
	
	Dim MadeWithLoveBadge As MadeWithLove
	MadeWithLoveBadge.Initialize(Me,"MadeWithLove")
	
	MadeWithLoveBadge.DesignerCreateView(xpnl_MadeWithLoveBackground,xlbl_MadeWithLove,CreateMap())
	
	xpnl_Background.AddView(xpnl_MadeWithLoveBackground,0,xpnl_MadeWithLoveBackground.Top,xpnl_Page.Width,xpnl_MadeWithLoveBackground.Height)
End Sub

Private Sub AddGroup2List(Group As AS_Settings_Group)
	
	Dim Height As Float = IIf(Group.Name = "",0, m_Settings.GroupHeight)
	Dim xpnl_Group As B4XView = xui.CreatePanel("")
	xpnl_Group.SetLayoutAnimated(0,0,0,xpnl_Page.Width,Height)
	xpnl_Group.Color = m_Settings.BackgroundColor
	xclv_Main.Add(xpnl_Group,Group)
	
	Dim Properties As List = Group.Properties
	
	AddGroupBorder2List(True)
	For i = 0 To Properties.Size -1
		If Properties.Get(i) Is AS_Settings_Property Then
			Dim Property As AS_Settings_Property = Properties.Get(i)
			Property.Group = Group
			Property.isLast = IIf(i = Properties.Size -1,True,False)
			'AddInternProperty(Group,Property,IIf(i = Properties.Size -1,True,False))
			AddProperty2List(Property)
		else If Properties.Get(i) Is AS_Settings_SpaceItem Then
			AddSpaceItem2List(xui.CreatePanel(""),Properties.Get(i),False)
		else If Properties.Get(i) Is AS_Settings_DescriptionItem Then
			AddDescriptionItem2List(xui.CreatePanel(""),Properties.Get(i),False)
		End If
	Next
	AddGroupBorder2List(False)
	
End Sub

Private Sub AddDescriptionItem2List(xpnl_Background As B4XView,DescriptionItem As AS_Settings_DescriptionItem,FromLazyLoading As Boolean)
	
	xpnl_Background.Color = m_Settings.BackgroundColor
	
	Dim xlbl_Description As B4XView = CreateLabel("")
	xlbl_Description.Text = DescriptionItem.Text
	xlbl_Description.Font = DescriptionItem.xFont
	xlbl_Description.TextColor = m_Settings.PropertyProperties.DescriptionTextColor
	xlbl_Description.SetTextAlignment("CENTER",DescriptionItem.HorizontalAlignment.ToUpperCase)
	#If B4I
	xlbl_Description.As(Label).Multiline = True
	#Else If B4J
		xlbl_Description.As(Label).WrapText = True
	#Else B4A
	xlbl_Description.As(Label).SingleLine = False
	#End If
	
	xpnl_Background.AddView(xlbl_Description,DescriptionItem.SidePadding,0,xpnl_Page.Width - DescriptionItem.SidePadding*2,10dip)
	
	Dim TextHeight As Float = MeasureMultilineTextHeight(xlbl_Description)
	
	xlbl_Description.Height = TextHeight
	xlbl_Description.Top = DescriptionItem.TopPadding
	
	xpnl_Background.SetLayoutAnimated(0,0,0,xpnl_Page.Width,TextHeight + (DescriptionItem.TopPadding*2))
	xpnl_Background.Color = m_Settings.BackgroundColor
	
	If FromLazyLoading = False Then
		xclv_Main.Add(xpnl_Background,DescriptionItem)
	End If
	
End Sub

Private Sub AddCustomItem2List(xpnl_Background As B4XView,CustomItem As AS_Settings_Property_Custom,FromLazyLoading As Boolean)
	xpnl_Background.SetLayoutAnimated(0,0,0,xpnl_Page.Width,CustomItem.Height)
	If FromLazyLoading Then
		
		Dim xpnl_CustomDrawBackground As B4XView = xui.CreatePanel("")
		xpnl_Background.AddView(xpnl_CustomDrawBackground,0,0,xpnl_Background.Width,xpnl_Background.Height)
		
		Dim CustomDraw As AS_Settings_CustomDrawCustomProperty
		CustomDraw.Initialize
		CustomDraw.BackgroundPanel = xpnl_CustomDrawBackground
		CustomDraw.Property = CustomItem.Property
		CustomDraw.Group = CustomItem.Property.Group
		CustomDraw.Height = CustomItem.Height
		CallSubDelayed2(m_Settings,"CustomDrawCustomProperty",CustomDraw)
	Else
		xclv_Main.Add(xpnl_Background,CustomItem)
	End If
End Sub

Private Sub AddSpaceItem2List(xpnl_Background As B4XView,SpaceItem As AS_Settings_SpaceItem,FromLazyLoading As Boolean)
	
	xpnl_Background.SetLayoutAnimated(0,0,0,xpnl_Page.Width,SpaceItem.Height)
	xpnl_Background.Color = SpaceItem.BackgroundColor
	If FromLazyLoading = False Then xclv_Main.Add(xpnl_Background,SpaceItem)
	
End Sub

Private Sub AddProperty2List(Property As AS_Settings_Property)
	
	If Property.PropertyType Is AS_Settings_Property_SelectionList Then
		
		Dim SelectionList As AS_Settings_Property_SelectionList = Property.PropertyType
		Dim PropertyBackgroundWidth As Float = xpnl_Page.Width - (m_Settings.Padding*2)
		
		For i = 0 To SelectionList.ListItems.Size -1
			
			Dim xpnl_Background As B4XView = xui.CreatePanel("")
			xpnl_Background.SetLayoutAnimated(0,0,0,xpnl_Page.Width,m_Settings.PropertyProperties.Height)
			xpnl_Background.Color = m_Settings.BackgroundColor
			xpnl_Background.Tag = Property
			
			xclv_Main.Add(xpnl_Background,SelectionList.ListItems.Get(i).As(AS_Settings_SelectionListItem))
			
		Next
			
	Else
			
		Dim xpnl_Background As B4XView = xui.CreatePanel("")
		xpnl_Background.SetLayoutAnimated(0,0,0,xpnl_Page.Width,m_Settings.PropertyProperties.Height)
		xpnl_Background.Color = m_Settings.BackgroundColor
	
		Dim PropertyBackgroundWidth As Float = xpnl_Page.Width - (m_Settings.Padding*2)
	
		If Property.Description <> "" Then

			Dim Gap As Float = 5dip

			Dim xlbl_Name As B4XView = CreateLabel("")
			xlbl_Name.Font = xui.CreateDefaultBoldFont(18)
			xlbl_Name.Text = Property.DisplayName
			xlbl_Name.Width = PropertyBackgroundWidth/2' - Gap
			#If B4I
			xlbl_Name.As(Label).Multiline = True
	#Else If B4J
	xlbl_Name.As(Label).WrapText = True
	#Else B4A
	xlbl_Name.As(Label).SingleLine = False
	#End If
		
			Dim xlbl_Description As B4XView = CreateLabel("")
			xlbl_Description.Text = Property.Description
			xlbl_Description.Font = xui.CreateDefaultFont(15)
			xlbl_Description.TextColor = m_Settings.PropertyProperties.DescriptionTextColor
			xlbl_Description.SetTextAlignment("TOP","LEFT")
	#If B4I
			xlbl_Description.As(Label).Multiline = True
	#Else If B4J
		xlbl_Description.As(Label).WrapText = True
	#Else B4A
	xlbl_Description.As(Label).SingleLine = False
	#End If
		
			xlbl_Description.Width = PropertyBackgroundWidth/2 - Gap
			xlbl_Description.Height = 10dip

			Dim NameHeight As Float = MeasureMultilineTextHeight(xlbl_Name)
			Dim DescriptionHeight As Float = MeasureMultilineTextHeight(xlbl_Description) + 5dip
		
			If NameHeight + DescriptionHeight >= m_Settings.PropertyProperties.Height Then
				xpnl_Background.Height = NameHeight + DescriptionHeight + 10dip
			End If
		
		End If
			
		xclv_Main.Add(xpnl_Background,Property)
			
	End If
	
End Sub

Private Sub AddInternGroup(xpnl_Group As B4XView,Group As AS_Settings_Group)
		
	Dim Height As Float = m_Settings.GroupHeight
	
	Dim xlbl_GroupName As B4XView = CreateLabel("xlbl_GroupName")
	xlbl_GroupName.Text = Group.Name
	xlbl_GroupName.Font = xui.CreateDefaultBoldFont(20)
	xlbl_GroupName.TextColor = m_Settings.GroupNameTextColor
	xlbl_GroupName.SetTextAlignment("CENTER","LEFT")
	xlbl_GroupName.Tag = Group
	xpnl_Group.Color = m_Settings.GroupNameBackgroundColor
		
	xpnl_Group.AddView(xlbl_GroupName,m_Settings.Padding,0,xpnl_Page.Width - (m_Settings.Padding*2),Height)
		
End Sub

Private Sub AddInternSelectionItem(xpnl_Background As B4XView,SelectionListItem As AS_Settings_SelectionListItem)
	xpnl_Background.Color = m_Settings.BackgroundColor
	Dim Gap As Float = 5dip
	
	Dim xpnl_Property As B4XView = xui.CreatePanel("SelectionItem")
	xpnl_Background.AddView(xpnl_Property,m_Settings.Padding,0,xpnl_Page.Width - (m_Settings.Padding*2),xpnl_Background.Height)
	
		#if b4j
	xpnl_Property.Width = xpnl_Property.Width - IIf(isMainPage,20dip,m_Settings.Padding/2)
	#End If
	
	xpnl_Property.Color = m_Settings.PropertyProperties.BackgroundColor
	Dim xlbl_PropertyName As B4XView = CreateLabel("")
	xlbl_PropertyName.Text = SelectionListItem.DisplayName
	xlbl_PropertyName.Font = xui.CreateDefaultBoldFont(18)
	xlbl_PropertyName.TextColor = m_Settings.PropertyProperties.TextColor
	xlbl_PropertyName.SetTextAlignment("CENTER","LEFT")
	#If B4I
	xlbl_PropertyName.As(Label).Multiline = True
	#Else If B4J
	xlbl_PropertyName.As(Label).WrapText = True
	#Else B4A
	xlbl_PropertyName.As(Label).SingleLine = False
	#End If
	
	Dim xlbl_CheckItem As B4XView = CreateLabel("")
	xlbl_CheckItem.TextColor = m_Settings.SelectionItemSelectionColor
	xlbl_CheckItem.SetTextAlignment("CENTER","CENTER")
	xlbl_CheckItem.Font = xui.CreateMaterialIcons(20)
	
	Dim Property As AS_Settings_Property = xpnl_Background.Tag
	
	If ListGetDefault(Property.Value,SelectionListItem.Value,"") <> "" Then
		xlbl_CheckItem.Text = Chr(0xE5CA)
	Else
		xlbl_CheckItem.Text = ""
	End If

	Private xpnl_Seperator As B4XView = xui.CreatePanel("")
	xpnl_Seperator.Color = m_Settings.PropertySeperatorColor

	xpnl_Property.AddView(xlbl_PropertyName,m_Settings.Padding,0,xpnl_Property.Width - 40dip - 5dip - Gap,xpnl_Background.Height)
	xpnl_Property.AddView(xlbl_CheckItem,xpnl_Property.Width - 40dip,0,40dip,xpnl_Property.Height)
	
	Dim xiv_Icon As B4XView = CreateImageView("")
	If SelectionListItem.Icon.IsInitialized Then
		xpnl_Property.AddView(xiv_Icon,m_Settings.Padding,(xpnl_Background.Height)/2 - ((xpnl_Background.Height)/2)/2,(xpnl_Background.Height)/2,(xpnl_Background.Height)/2)
		xlbl_PropertyName.Left = xiv_Icon.Left + xiv_Icon.Width + 5dip
		xlbl_PropertyName.Width = xlbl_PropertyName.Width - xiv_Icon.Width - 5dip
		xiv_Icon.SetBitmap(SelectionListItem.Icon)
	End If
	
	xpnl_Seperator.Visible = Property.PropertyType.As(AS_Settings_Property_SelectionList).ListItems.IndexOf(SelectionListItem) > 0
	xpnl_Property.AddView(xpnl_Seperator,xlbl_PropertyName.Left,0,xpnl_Property.Width,1dip)
	
End Sub

Private Sub ListGetDefault(lst As List,Value As Object,DefaultValue As Object) As Object
	If lst.IndexOf(Value) = -1 Then
		Return DefaultValue
	Else
		Return lst.Get(lst.IndexOf(Value))
	End If
End Sub

Private Sub AddInternProperty(xpnl_Background As B4XView,Property As AS_Settings_Property)
	
	xpnl_Background.Color = m_Settings.BackgroundColor
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
		Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
	End If
	
	Dim Gap As Float = 5dip
	
	Dim xpnl_Property As B4XView = xui.CreatePanel("")
	xpnl_Background.AddView(xpnl_Property,m_Settings.Padding,0,xpnl_Page.Width - (m_Settings.Padding*2),xpnl_Background.Height)
	#if b4j
	
	xpnl_Property.Width = xpnl_Property.Width - IIf(isMainPage,20dip,m_Settings.Padding/2)
	#End If
	xpnl_Property.Color = m_Settings.PropertyProperties.BackgroundColor
	Dim xlbl_PropertyName As B4XView = CreateLabel("")
	xlbl_PropertyName.Text = Property.DisplayName
	xlbl_PropertyName.Font = xui.CreateDefaultBoldFont(18)
	xlbl_PropertyName.TextColor = m_Settings.PropertyProperties.TextColor
	xlbl_PropertyName.SetTextAlignment("CENTER","LEFT")
	#If B4I
	xlbl_PropertyName.As(Label).Multiline = True
	#Else If B4J
	xlbl_PropertyName.As(Label).WrapText = True
	#Else B4A
	xlbl_PropertyName.As(Label).SingleLine = False
	#End If

	xpnl_Property.AddView(xlbl_PropertyName,m_Settings.Padding,0,xpnl_Property.Width/2 - Gap,xpnl_Background.Height)
	
	Dim xlbl_Description As B4XView = CreateLabel("")
	xlbl_Description.Text = Property.Description
	xlbl_Description.Font = xui.CreateDefaultFont(15)
	xlbl_Description.TextColor = m_Settings.PropertyProperties.DescriptionTextColor
	xlbl_Description.SetTextAlignment("TOP","LEFT")
	#If B4I
	xlbl_Description.As(Label).Multiline = True
	#Else If B4J
		xlbl_Description.As(Label).WrapText = True
	#Else B4A
	xlbl_Description.As(Label).SingleLine = False
	#End If
	
	If Property.Description <> "" Then
		
		xlbl_PropertyName.SetTextAlignment("TOP","LEFT")
		xlbl_PropertyName.Width = xlbl_PropertyName.Width + 5dip
		xlbl_PropertyName.Height = MeasureMultilineTextHeight(xlbl_PropertyName)
		
		xlbl_Description.Width = xpnl_Property.Width/2 - Gap
		xlbl_Description.Height = 10dip
		xpnl_Property.AddView(xlbl_Description,m_Settings.Padding,xlbl_PropertyName.Height,xpnl_Property.Width/2 - Gap,MeasureMultilineTextHeight(xlbl_Description) + 5dip)

	End If
		
	Dim xpnl_PropertyBackground As B4XView = xui.CreatePanel("")
	xpnl_PropertyBackground.Color = xui.Color_Transparent
	xpnl_Property.AddView(xpnl_PropertyBackground,xpnl_Property.Width/2,0,xpnl_Property.Width/2,xpnl_Property.Height)
		
	Dim xiv_Icon As B4XView = CreateImageView("")
	If Property.Icon.IsInitialized Then
		
		xpnl_Property.AddView(xiv_Icon,m_Settings.Padding,(xpnl_Background.Height)/2 - ((xpnl_Background.Height)/2)/2,(xpnl_Background.Height)/2,(xpnl_Background.Height)/2)
		xlbl_PropertyName.Left = xiv_Icon.Left + xiv_Icon.Width + 5dip
		xlbl_PropertyName.Width = xlbl_PropertyName.Width - xiv_Icon.Width - 5dip
		xiv_Icon.SetBitmap(Property.Icon)
	End If
		
	If m_Settings.PropertySeperator And Property.isLast = False Then
		
		Dim xpnl_PropertySeperator As B4XView = xui.CreatePanel("")
		xpnl_PropertySeperator.Color = m_Settings.PropertySeperatorColor
		xpnl_Property.AddView(xpnl_PropertySeperator,m_Settings.Padding,xpnl_Property.Height - 1dip,xpnl_Property.Width - m_Settings.Padding,1dip)
		
	End If
		
	If Property.Description <> "" Then
		xlbl_PropertyName.Top = xlbl_PropertyName.Top + Gap
		xlbl_Description.Top = xlbl_Description.Top + Gap
	End If
		
	Dim PropertySettingViews As AS_Settings_PropertySettingViews
	PropertySettingViews.Initialize
		
	Select True
		Case Property.PropertyType Is AS_Settings_Property_Boolean
			
			'Dim Property_Boolean As AS_Settings_Property_Boolean = Property.PropertyType
					
			If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
				Dim Value As Object = AS_Properties.GetProperty(Property.PropertyName)
				'Property.Value = IIf(Value = Null,Property.Value,IIf(0 = Value,False,True))
				Property.Value = IIf(Value = Null,Property.DefaultValue,Value)
			End If
			
			Dim SwitchWidth As Float = 55dip
			Dim SwitchHeight As Float = 31dip
			
			Dim Switch As B4XSwitch
			Switch.Initialize(Me,"SwitchBoolean")
			
			Dim mSwitchProperties As Map
			mSwitchProperties.Initialize
			mSwitchProperties.Put("Value",Property.Value)
			mSwitchProperties.Put("OnColor",m_Settings.SwitchProperties.TrueColor)
			mSwitchProperties.Put("OffColor",m_Settings.SwitchProperties.FalseColor)
			mSwitchProperties.Put("ThumbColor",m_Settings.SwitchProperties.ThumbColor)
			mSwitchProperties.Put("HapticFeedback",m_Settings.HapticFeedback)
			
			Dim xpnl_SwitchBase As B4XView = xui.CreatePanel("")
			xpnl_PropertyBackground.AddView(xpnl_SwitchBase,xpnl_PropertyBackground.Width - SwitchWidth - 10dip,xpnl_PropertyBackground.Height/2 - SwitchHeight/2,SwitchWidth,SwitchHeight)
			
			Switch.DesignerCreateView(xpnl_SwitchBase,CreateLabel(""),mSwitchProperties)
			Property.View = Switch
			
		Case Property.PropertyType Is AS_Settings_Property_Action, Property.PropertyType Is AS_Settings_Property_ActionClean
			
			Dim xpnl_ActionClickPanel As B4XView = xui.CreatePanel("xpnl_ActionClickPanel")
			xpnl_ActionClickPanel.Color = xui.Color_Transparent
			xpnl_PropertyBackground.AddView(xpnl_ActionClickPanel,0,0,xpnl_Property.Width,xpnl_Property.Height)
			
			If Property.PropertyType Is AS_Settings_Property_Action Then
				'Dim Property_Action As AS_Settings_Property_Action = Property.PropertyType
				Dim ActionIconWidth As Float = 30dip
				Dim ActionIconHeight As Float = xpnl_PropertyBackground.Height/2
				Dim xlbl_ActionIcon As B4XView = CreateLabel("")
				xlbl_ActionIcon.Text = Chr(0xE315)
				xlbl_ActionIcon.Font = xui.CreateMaterialIcons(24)
				xlbl_ActionIcon.TextColor = m_Settings.ArrowColor
				xpnl_PropertyBackground.AddView(xlbl_ActionIcon,xpnl_Property.Width - ActionIconWidth/2-ActionIconWidth/2,xpnl_Property.Height/2 - ActionIconHeight/2,ActionIconWidth,ActionIconHeight)
			
				Dim xlbl_ActionValue As B4XView = CreateLabel("")
				xlbl_ActionValue.Text = Property.Value
				xlbl_ActionValue.Font = xui.CreateDefaultFont(15)
				xlbl_ActionValue.TextColor = m_Settings.PropertyProperties.TextColor
				xlbl_ActionValue.SetTextAlignment("CENTER","RIGHT")
			#If B4I
				xlbl_ActionValue.As(Label).Multiline = True
				#Else If B4J
				xlbl_ActionValue.As(Label).WrapText = True
			#End If
				xpnl_PropertyBackground.AddView(xlbl_ActionValue,xpnl_Property.Width/2 + Gap,0,xlbl_ActionIcon.Left - xpnl_Property.Width/2 - Gap*2,xpnl_Property.Height)
			
			#If B4J
				xlbl_ActionIcon.As(JavaObject).RunMethod("setMouseTransparent",Array As Object(True))
				xlbl_ActionValue.As(JavaObject).RunMethod("setMouseTransparent",Array As Object(True))
			#End If
			
			End If
			xpnl_PropertyBackground.Left = 0
			xpnl_PropertyBackground.Width = xpnl_Property.Width
			
			PropertySettingViews.ActionButtonArrowLabel = xlbl_ActionIcon
			PropertySettingViews.ActionValueLabel = xlbl_ActionValue
			
		Case Property.PropertyType Is AS_Settings_Property_Chooser
			
			Dim xlbl_TextField As B4XView = CreateLabel("xlbl_TextField")
			xlbl_TextField.SetColorAndBorder(m_Settings.PropertyProperties.FieldBackgroundColor,0,0,m_Settings.PropertyProperties.CornerRadius)
			xlbl_TextField.Font = m_Settings.PropertyProperties.xFont
			xlbl_TextField.SetTextAlignment("CENTER","CENTER")
			If Property.DisplayValueText = "" Then
				xlbl_TextField.Text = Property.Value
			Else
				xlbl_TextField.Text = Property.DisplayValueText
			End If
			xlbl_TextField.Tag = m_Settings.PropertyProperties
			xlbl_TextField.TextColor = m_Settings.PropertyProperties.TextColor
			
			If m_Settings.PropertyProperties.Width = 0 Then
				m_Settings.PropertyProperties.Width = xpnl_Property.Width/2 - m_Settings.Padding
			End If
			
			xpnl_PropertyBackground.AddView(xlbl_TextField,xpnl_PropertyBackground.Width - m_Settings.PropertyProperties.Width - m_Settings.Padding,xpnl_PropertyBackground.Height/2 - m_Settings.PropertyProperties.FieldHeight/2,m_Settings.PropertyProperties.Width,m_Settings.PropertyProperties.FieldHeight)
		
		Case Property.PropertyType Is AS_Settings_Property_Text
			
			Dim Property_Text As AS_Settings_Property_Text = Property.PropertyType
			Dim xtf_TextBox As B4XView = CreateEditText("xtf_TextBox",Property_Text.InputType)
			xtf_TextBox.TextColor = m_Settings.PropertyProperties.TextColor
			xtf_TextBox.SetColorAndBorder(m_Settings.PropertyProperties.FieldBackgroundColor,0,0,m_Settings.PropertyProperties.CornerRadius)
			xtf_TextBox.Font = m_Settings.PropertyProperties.xFont
			xtf_TextBox.SetTextAlignment("CENTER","CENTER")
			xtf_TextBox.Text = Property.Value
			xtf_TextBox.Tag = m_Settings.PropertyProperties
	
			If Property_Text.Width > xpnl_PropertyBackground.Width Then
				xpnl_PropertyBackground.Left = xpnl_PropertyBackground.Left -(Property_Text.Width - xpnl_PropertyBackground.Width) - m_Settings.Padding*2
				xpnl_PropertyBackground.Width = Property_Text.Width + m_Settings.Padding
				xpnl_PropertyBackground.AddView(xtf_TextBox,m_Settings.Padding,xpnl_PropertyBackground.Height/2 - m_Settings.PropertyProperties.FieldHeight/2, Property_Text.Width,m_Settings.PropertyProperties.FieldHeight)
			Else
				xpnl_PropertyBackground.AddView(xtf_TextBox,xpnl_PropertyBackground.Width - m_Settings.PropertyProperties.Width - m_Settings.Padding,xpnl_PropertyBackground.Height/2 - m_Settings.PropertyProperties.FieldHeight/2, m_Settings.PropertyProperties.Width,m_Settings.PropertyProperties.FieldHeight)
			End If
	
			Property.View = xtf_TextBox
		
		#If SETTINGS_SegmentedTab
		Case Property.PropertyType Is AS_Settings_Property_SegmentedTab
			
			Dim SegmentedTabProperties As AS_Settings_Property_SegmentedTab = Property.PropertyType
			
			Dim xpnl_SegmentedTabBackground As B4XView = xui.CreatePanel("")
			xpnl_PropertyBackground.AddView(xpnl_SegmentedTabBackground,IIf(SegmentedTabProperties.Width = 0,Gap,xpnl_PropertyBackground.Width-SegmentedTabProperties.Width - Gap),xpnl_PropertyBackground.Height/2 - (xpnl_PropertyBackground.Height/2)/2,IIf(SegmentedTabProperties.Width = 0,xpnl_PropertyBackground.Width - Gap*2,SegmentedTabProperties.Width),xpnl_PropertyBackground.Height/2)
			
			Dim SegmentedTab As ASSegmentedTab
			SegmentedTab.Initialize(Me,"SegmentedTab")
			
			Dim mSegmentedTab As Map
			mSegmentedTab.Initialize
			mSegmentedTab.Put("CornerRadiusBackground",SegmentedTabProperties.CornerRadius)
			mSegmentedTab.Put("CornerRadiusSelectionPanel",SegmentedTabProperties.CornerRadius)
			mSegmentedTab.Put("PaddingSelectionPanel",0)
			mSegmentedTab.Put("ShowSeperators",SegmentedTabProperties.ShowSeperators)
			mSegmentedTab.Put("BackgroundColor",SegmentedTabProperties.BackgroundColor)
			mSegmentedTab.Put("SelectionColor",SegmentedTabProperties.SelectionColor)
			mSegmentedTab.Put("SeperatorColor",SegmentedTabProperties.SeperatorColor)
			mSegmentedTab.Put("TextColor",SegmentedTabProperties.TextColor)
			
			SegmentedTab.DesignerCreateView(xpnl_SegmentedTabBackground,CreateLabel(""),mSegmentedTab)
		
			SegmentedTab.ItemTextProperties.TextFont = SegmentedTabProperties.xFont
			
			SegmentedTab.CornerRadiusBackground = SegmentedTabProperties.CornerRadius
			SegmentedTab.CornerRadiusSelectionPanel = SegmentedTabProperties.CornerRadius
			SegmentedTab.AutoDecreaseTextSize = True
			
			For Each k As String In SegmentedTabProperties.ItemMap.Keys
				SegmentedTab.AddTab2(k,Null,SegmentedTabProperties.ItemMap.Get(k))
			Next
			
			For i = 0 To SegmentedTab.Size -1
				Dim SegTab As ASSegmentedTab_Tab = SegmentedTab.GetTab(i)
				If SegTab.Value = Property.Value Then
					SegmentedTab.Index = i
					Exit
				End If
			Next
			
			Property.View = SegmentedTab
			'SegmentedTab.RefreshTabs
			
		#End If
		#If SETTINGS_PlusMinus

		Case Property.PropertyType Is AS_Settings_Property_PlusMinus
			
			Dim Width As Float = 110dip
			
			Dim Property_PlusMinus As AS_Settings_Property_PlusMinus = Property.PropertyType

			Dim xpnl_PlusMinusBackground As B4XView = xui.CreatePanel("")
			xpnl_PropertyBackground.AddView(xpnl_PlusMinusBackground,IIf(Width = 0,Gap,xpnl_PropertyBackground.Width-Width - Gap),xpnl_PropertyBackground.Height/2-40dip/2,IIf(Width = 0,xpnl_PropertyBackground.Width - Gap*2,Width),40dip)
			
			Dim PlusMinus As AS_PlusMinus
			PlusMinus.Initialize(Me,"PlusMinus")
			
			Dim mPlusMinus As Map
			mPlusMinus.Initialize
			mPlusMinus.Put("MinusText","-")
			mPlusMinus.Put("PlusText","+")
			mPlusMinus.Put("Round",False)
			mPlusMinus.Put("CornerRadius",m_Settings.PlusMinusProperties.CornerRadius)
			mPlusMinus.Put("BackgroundColor",m_Settings.PlusMinusProperties.BackgroundColor)
			mPlusMinus.Put("MinusColor",m_Settings.PlusMinusProperties.BackgroundColor)
			mPlusMinus.Put("MinusTextColor",m_Settings.PlusMinusProperties.TextColor)
			mPlusMinus.Put("PlusColor",m_Settings.PlusMinusProperties.BackgroundColor)
			mPlusMinus.Put("PlusTextColor",m_Settings.PlusMinusProperties.TextColor)
			mPlusMinus.Put("Divider",m_Settings.PlusMinusProperties.ShowDivider)
			mPlusMinus.Put("DividerColor",m_Settings.PlusMinusProperties.DividerColor)
			mPlusMinus.Put("HaloEffect",m_Settings.PlusMinusProperties.ShowHaloEffect)
			mPlusMinus.Put("HaloColor",m_Settings.PlusMinusProperties.HaloColor)
			mPlusMinus.Put("HapticFeedback",m_Settings.HapticFeedback)
			
			PlusMinus.DesignerCreateView(xpnl_PlusMinusBackground,CreateLabel(""),mPlusMinus)
			
			PlusMinus.lblMinus.Font = m_Settings.PlusMinusProperties.xFont
			PlusMinus.lblPlus.Font = m_Settings.PlusMinusProperties.xFont
			
			PlusMinus.Tag = Property_PlusMinus
			
			Dim xlbl_Value As B4XView = CreateLabel("")
			xlbl_Value.TextColor = m_Settings.PropertyProperties.TextColor
			xlbl_Value.Font = m_Settings.PropertyProperties.xFont
			xlbl_Value.SetTextAlignment("CENTER","RIGHT")
			xlbl_Value.Text = Property_PlusMinus.Prefix &  Property.Value & Property_PlusMinus.Suffix

			
			Dim ValueWidth As Float = MeasureTextWidth(xlbl_Value.Text,xlbl_Value.Font) +2dip

			xpnl_PropertyBackground.AddView(xlbl_Value,xpnl_PlusMinusBackground.Left - ValueWidth - 10dip,0,ValueWidth,xpnl_PropertyBackground.Height)
			Property.View = PlusMinus

		#End If
		Case Property.PropertyType Is AS_Settings_Property_ComboBox
				
			Dim Property_ComboBox As AS_Settings_Property_ComboBox = Property.PropertyType
			Dim ActionIconWidth As Float = 30dip
			Dim ActionIconHeight As Float = xpnl_PropertyBackground.Height/2
			
			Dim xlbl_ComboBoxIcon_Up As B4XView = CreateLabel("")
			xlbl_ComboBoxIcon_Up.Text = Chr(0xE316)
			xlbl_ComboBoxIcon_Up.Font = xui.CreateMaterialIcons(24)
			xlbl_ComboBoxIcon_Up.TextColor = m_Settings.ArrowColor
			
			Dim IconHeight As Float = 20dip'MeasureTextHeight("T",xui.CreateDefaultBoldFont(15))
			
			xpnl_PropertyBackground.AddView(xlbl_ComboBoxIcon_Up,xpnl_PropertyBackground.Width - ActionIconWidth/2-ActionIconWidth/2,xpnl_PropertyBackground.Height/2-IconHeight,ActionIconWidth,IconHeight)
				
			Dim xlbl_ComboBoxIcon_Down As B4XView = CreateLabel("")
			xlbl_ComboBoxIcon_Down.Text = Chr(0xE313)
			xlbl_ComboBoxIcon_Down.Font = xui.CreateMaterialIcons(24)
			xlbl_ComboBoxIcon_Down.TextColor = m_Settings.ArrowColor
			xpnl_PropertyBackground.AddView(xlbl_ComboBoxIcon_Down,xpnl_PropertyBackground.Width - ActionIconWidth/2-ActionIconWidth/2,xpnl_PropertyBackground.Height/2,ActionIconWidth,IconHeight)
				
			Dim xpnl_ComboBoxBackground As B4XView = xui.CreatePanel("")
			xpnl_PropertyBackground.AddView(xpnl_ComboBoxBackground,Gap,0,xpnl_PropertyBackground.Width - Gap*2 - xlbl_ComboBoxIcon_Up.Width,xpnl_PropertyBackground.Height)
				
			Dim xComboBox As B4XComboBox
			xComboBox.Initialize(Me,"xComboBox")
				
			Dim mComboBox As Map
			mComboBox.Initialize
			
			xComboBox.DesignerCreateView(xpnl_ComboBoxBackground,CreateLabel(""),mComboBox)
			
			If Property_ComboBox.KeyValue.IsInitialized And Property_ComboBox.KeyValue.Size > 0 Then
				Property_ComboBox.ItemList.Initialize
				
				For Each k As Object In Property_ComboBox.KeyValue.Keys
					Property_ComboBox.ItemList.Add(Property_ComboBox.KeyValue.Get(k))
				Next
				
			End If
			
			xComboBox.SetItems(Property_ComboBox.ItemList)
				
			Dim xlbl_ComboBox As B4XView = CreateLabel("")
			xlbl_ComboBox.Color = m_Settings.PropertyProperties.BackgroundColor
			xlbl_ComboBox.Tag = Property
			xlbl_ComboBox.Font = xui.CreateDefaultBoldFont(15)
			xlbl_ComboBox.TextColor = m_Settings.PropertyProperties.TextColor
			xlbl_ComboBox.SetTextAlignment("CENTER","RIGHT")
			xComboBox.Tag = xlbl_ComboBox
			#If B4J
			xlbl_ComboBox.As(JavaObject).RunMethod("setMouseTransparent",Array As Object(True))
			xlbl_ComboBox.As(Label).WrapText = True
			#Else If B4I
			xlbl_ComboBox.As(Label).UserInteractionEnabled = False
			xlbl_ComboBox.As(Label).Multiline = True
			#Else If B4A
			xlbl_ComboBox.As(Label).SingleLine = False
			#End If
			
			xpnl_PropertyBackground.AddView(xlbl_ComboBox,Gap,0,xpnl_PropertyBackground.Width - Gap*2 - xlbl_ComboBoxIcon_Up.Width,xpnl_PropertyBackground.Height)
		
			Dim SelectedIndex As Int = 0
			
			If Property_ComboBox.KeyValue.IsInitialized And Property_ComboBox.KeyValue.Size > 0 Then
				For i = 0 To Property_ComboBox.KeyValue.Size -1
					If Property.Value = Property_ComboBox.KeyValue.Keys.Get(i) Then
						SelectedIndex = i
						Exit
					End If
				Next			
			Else
				For i = 0 To Property_ComboBox.ItemList.Size -1
					If Property.Value = Property_ComboBox.ItemList.Get(i) Then
						SelectedIndex = i
						Exit
					End If
				Next
			End If
				
			xComboBox.SelectedIndex = SelectedIndex
			
			xlbl_ComboBox.Text = Property_ComboBox.ItemList.Get(SelectedIndex)
			Property.View = xComboBox
		
	End Select
	
	Dim PropertyViews As AS_Settings_PropertyViews = CreateAS_Settings_PropertyViews(xpnl_Background,xpnl_Property,xpnl_PropertyBackground,xiv_Icon,xlbl_PropertyName,xlbl_Description)
	PropertySettingViews.BackgroundPanel = xpnl_PropertyBackground
	CallSubDelayed2(m_Settings,"CustomDrawProperty",CreateAS_Settings_CustomDrawProperty(Property.Group,Property,PropertyViews,PropertySettingViews))
	
End Sub

Private Sub AddGroupBorder2List(Top As Boolean)
	
	Dim xpnl_Background As B4XView = xui.CreatePanel("")
	xpnl_Background.Color = m_Settings.BackgroundColor
	xpnl_Background.SetLayoutAnimated(0,0,0,xpnl_Page.Width,m_Settings.CornerRadius)
	
	#if b4j
	xpnl_Background.Width = xpnl_Background.Width - IIf(isMainPage,20dip,0)
	#End If
	
	If Top Then
		xclv_Main.Add(xpnl_Background,"GroupBorderTop")
	Else
		xclv_Main.Add(xpnl_Background,"GroupBorderBottom")
	End If
	
End Sub

Private Sub AddInternGroupBorder(xpnl_Background As B4XView,Top As Boolean)
	
	xpnl_Background.Color = m_Settings.BackgroundColor
	
	Dim BorderItem As B4XView = xui.CreatePanel("")
	xpnl_Background.AddView(BorderItem,m_Settings.Padding,IIf(Top,0,-m_Settings.CornerRadius),xpnl_Background.Width - (m_Settings.Padding*2),m_Settings.CornerRadius*2)
	BorderItem.SetColorAndBorder(m_Settings.PropertyProperties.BackgroundColor,0,0,m_Settings.CornerRadius)
	
	Dim xpnl As B4XView = xui.CreatePanel("")
	xpnl_Background.AddView(xpnl,m_Settings.Padding,IIf(Top,m_Settings.CornerRadius,-(m_Settings.CornerRadius*2)),xpnl_Background.Width - (m_Settings.Padding*2),m_Settings.CornerRadius)
	xpnl.Color = m_Settings.PropertyProperties.BackgroundColor
	
	#if b4j 
	If isMainPage = False Then BorderItem.Width = BorderItem.Width - m_Settings.Padding/2
	#End If
	
End Sub

#End Region

#Region Properties

'Default: 500dip
Public Sub setHeight(Height As Float)
	m_Height = Height
	xpnl_Page.Height = m_Height
	xclv_Main.AsView.Height = xpnl_Page.Height - IIf(isMainPage,0,IIf(m_DisplayName <> "", m_Settings.HeaderHeight,0))
	xclv_Main.Base_Resize(xclv_Main.AsView.Width,xclv_Main.AsView.Height)
End Sub

Public Sub getHeight As Float
	Return m_Height
End Sub

Public Sub setBottomText(Text As String)
	m_BottomText = Text
End Sub

Public Sub getBottomText As String
	Return m_BottomText
End Sub

#End Region

#Region Methods

'You dont need to call .Create, this function does it for you
Public Sub ShowPage
	RefreshColors
	isVisible = True
	xpnl_SecondPageBackground.Left = 0
	xpnl_SecondPageBackground.SetVisibleAnimated(250,True)
	
	#If B4J	
	
	xpnl_Page.Left = m_Settings.mBase.Width/2 - xpnl_Page.Width/2
	xpnl_Page.Top = m_Settings.mBase.Height/2 - xpnl_Page.Height/2
	
	#Else
	
	xpnl_Page.SetColorAndBorder(m_Settings.BackgroundColor,0,0,20dip)
	xpnl_Page.Left = 0
	xpnl_Page.Top = m_Settings.mBase.Height
	xpnl_Page.SetLayoutAnimated(250,0,m_Settings.mBase.Height - m_Height,xpnl_Page.Width,m_Height)
	#If B4A
	SetCircleClip(xpnl_Page,20dip)
	#End If
	#End If
	
	If xclv_Main.Size = 0 Then
		Create
	End If
	m_Settings.GetVisiblePages.Add(Me)
	m_Settings.GetCreatedPages.Add(Me)

End Sub

Public Sub ClosePage(Page As AS_SettingsPage)
	If Page <> m_Settings.MainPage Then
		xpnl_SecondPageBackground.SetVisibleAnimated(250,False)
		#If B4J

		#Else
		xpnl_Page.SetLayoutAnimated(250,0,m_Settings.mBase.Height,xpnl_Page.Width,xpnl_Page.Height)
		#End If
		m_Settings.GetVisiblePages.RemoveAt(m_Settings.GetVisiblePages.Size -1)
		isVisible = False
	Else
		LogColor("The MainPage cannot be closed",xui.Color_Red)
	End If
End Sub

'Removes the groups and items, so that you can fill the view with new groups, without the groups that were previously visible
Public Sub ResetItems
	lst_Items.Clear
End Sub

'Creates the list
Public Sub Create

	xclv_Main.Clear
	
	For Each Item As Object In lst_Items
		
		Select True
			Case Item Is AS_Settings_Group
				AddGroup2List(Item)
			Case Item Is AS_Settings_SpaceItem
				AddSpaceItem2List(xui.CreatePanel(""),Item,False)
			Case Item Is AS_Settings_DescriptionItem
				AddDescriptionItem2List(xui.CreatePanel(""),Item,False)
			Case Item Is AS_Settings_Property And Item.As(AS_Settings_Property).PropertyType Is AS_Settings_Property_Custom
				AddCustomItem2List(xui.CreatePanel(""),Item.As(AS_Settings_Property).PropertyType,False)
		End Select
		
	Next
	
	If isMainPage And m_Settings.ShowMadeWithLove Then
		AddMadeWithLove
	End If
	
	If isMainPage And m_BottomText <> "" Then
		AddBottomText
	End If
	
	Dim xpnl_Placeholder As B4XView = xui.CreatePanel("")
	xpnl_Placeholder.Color = m_Settings.BackgroundColor
	xpnl_Placeholder.SetLayoutAnimated(0,0,0,xpnl_Page.Width,20dip)
	#If B4I
	xpnl_Placeholder.Height = xpnl_Placeholder.Height + 60dip
	#End If
	xclv_Main.Add(xpnl_Placeholder,"Placeholder")
	
	'XUIViewsUtils.AddStubToCLVIfNeeded(xclv_Main, m_Settings.BackgroundColor)
	
	Sleep(500)
	isReady = True
End Sub

Private Sub RefreshColors
	xpnl_Page.Color = m_Settings.BackgroundColor
	xclv_Main.AsView.Color = m_Settings.BackgroundColor
	xclv_Main.sv.ScrollViewInnerPanel.Color = m_Settings.BackgroundColor
	xclv_Main.GetBase.Color = m_Settings.BackgroundColor
	If xpnl_ExitIcon.IsInitialized Then xpnl_ExitIcon.SetColorAndBorder(m_Settings.ExitIconColor,0,0,xpnl_ExitIcon.Height/2)
	#IF B4A or B4I
	If xpnl_DragIndicator.IsInitialized Then xpnl_DragIndicator.SetColorAndBorder(m_Settings.DragIndicatorColor,0,0,3dip)
	#End If
	If xpnl_SecondPageBackground.IsInitialized Then 
		xpnl_SecondPageBackground.Color = m_Settings.SecondPageShadowColor
	End If
	If xpnl_Header.IsInitialized Then xpnl_Header.Color = m_Settings.BackgroundColor
	If xlbl_HeaderText.IsInitialized Then xlbl_HeaderText.TextColor = m_Settings.SecondPageHeaderTextColor
	
End Sub

'Refreshes the visible area
'All items are being rebuilt
Public Sub Refresh
	
	RefreshColors
	
	If isReady Then
		xiv_RefreshImage.SetBitmap(xpnl_Page.Snapshot)
		xiv_RefreshImage.Visible = True
	
'		For i = 0 To xclv_Main.Size -1
'			xclv_Main.GetPanel(i).RemoveAllViews
'		Next
'		xclv_Main.Refresh
		Dim LastY As Float = xclv_Main.sv.ScrollViewOffsetY
		Create
		xclv_Main.sv.ScrollViewOffsetY = LastY
		Sleep(250)
		xiv_RefreshImage.Visible = False
	End If
End Sub

'Sets the value of a property as if the user had clicked the switch
'The _ValueChanged event is triggered
Public Sub SetProperty_Boolean(PropertyName As String,Value As Boolean)
	For i = 0 To xclv_Main.Size -1
		If xclv_Main.GetValue(i) Is AS_Settings_Property Then
			Dim Property As AS_Settings_Property = xclv_Main.GetValue(i)
			If Property.PropertyName = PropertyName Then
				Dim Switch As B4XSwitch = Property.View
				Switch.Value = Value
				SwitchBooleanValueChanged(Switch,Value)
			End If
		End If
	Next
End Sub

'Gets the Property object
Public Sub GetProperty(PropertyName As String) As AS_Settings_Property
	For i = 0 To xclv_Main.Size -1
		If xclv_Main.GetValue(i) Is AS_Settings_Property Then
			Dim Property As AS_Settings_Property = xclv_Main.GetValue(i)
			If Property.PropertyName = PropertyName Then
				Return Property
			End If
		End If
	Next
	Return Null
End Sub

#End Region

#Region ViewEvents

#If B4J
Private Sub xlbl_GroupName_MouseClicked (EventData As MouseEvent)
#Else
Private Sub xlbl_GroupName_Click
#End If
	Dim xlbl_GroupName As B4XView = Sender
	GroupHeaderClicked(xlbl_GroupName.Tag)
End Sub

#IF B4J
Private Sub SelectionItem_MouseClicked (EventData As MouseEvent)
#Else
Private Sub SelectionItem_Click
#End If
	
	Dim xpnl_SelectionItem As B4XView = Sender 'Ignore
	
	Dim Property As AS_Settings_Property = xclv_Main.GetPanel(xclv_Main.GetItemFromView(xpnl_SelectionItem)).Tag
	Dim SelectionList As AS_Settings_Property_SelectionList = Property.PropertyType
	Dim SelectionListItem As AS_Settings_SelectionListItem = xclv_Main.GetValue(xclv_Main.GetItemFromView(xpnl_SelectionItem))
'	Log(GetType(Property.Value))
'	Dim lst As List
'	lst.Initialize
'	Log(GetType(lst))
	Dim lstSelectionItem As List = Property.Value
	
	Dim xlbl_CheckItem As B4XView = xpnl_SelectionItem.GetView(1)
	If xlbl_CheckItem.Text = "" Then
		xlbl_CheckItem.Text = Chr(0xE5CA)
	Else
		If SelectionList.CanDeselectAll = False And lstSelectionItem.Size = 1 Then Return
		
		xlbl_CheckItem.Text = ""
	End If
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		
		If lstSelectionItem.IndexOf(SelectionListItem.Value) >= 0 Then
			lstSelectionItem.RemoveAt(lstSelectionItem.IndexOf(SelectionListItem.Value))
		Else
			
			If SelectionList.MultiSelect = False Then
				lstSelectionItem.Clear
			End If
			
			'lstSelectionItem.Put(SelectionListItem.Value,"Placeholder")
			lstSelectionItem.Add(SelectionListItem.Value)
		End If
		
		AS_Properties.PutProperty(Property.PropertyName,lstSelectionItem)
		If SelectionList.MultiSelect = False Then RefreshSelectionListItems(Property,SelectionListItem)
		
	End If
	
	CallSubDelayed3(m_Settings,"ValueChanged",Property,lstSelectionItem)
	If m_Settings.HapticFeedback Then XUIViewsUtils.PerformHapticFeedback(xpnl_SelectionItem)
	
End Sub

Private Sub RefreshSelectionListItems(Property As AS_Settings_Property,SelectionListItem As AS_Settings_SelectionListItem)
	
	For i = 0 To xclv_Main.Size -1
				
		If  xclv_Main.GetValue(i) Is AS_Settings_SelectionListItem And xclv_Main.GetPanel(i).NumberOfViews > 0 Then
							
			Dim tmpProperty As AS_Settings_Property = xclv_Main.GetPanel(i).Tag
				
			If tmpProperty.PropertyName = Property.PropertyName Then
								
				Dim tmpSelectionListItem As AS_Settings_SelectionListItem = xclv_Main.GetValue(i)
				Dim xlbl_CheckItem As B4XView = xclv_Main.GetPanel(i).Getview(0).GetView(1)
				If tmpSelectionListItem.Value = SelectionListItem.Value Then
					xlbl_CheckItem.Text = Chr(0xE5CA)
				Else
					xlbl_CheckItem.Text = ""
				End If
					
			End If

		End If

	Next
	
End Sub

#If B4J
Private Sub xpnl_SecondPageBackground_MouseClicked (EventData As MouseEvent)
	ClosePage(Me)
End Sub

Private Sub xpnl_Page_MouseClicked (EventData As MouseEvent)
	EventData.Consume
End Sub

#Else

Private Sub xpnl_SecondPageBackground_Click
	ClosePage(Me)
End Sub

#End If

#If B4J

Private Sub xpnl_Header_MouseClicked (EventData As MouseEvent)
	EventData.Consume
	If (EventData.X >= xpnl_ExitIcon.Left And EventData.X <= xpnl_ExitIcon.Left + xpnl_ExitIcon.Width) And (EventData.y >= xpnl_ExitIcon.top And EventData.y <= xpnl_ExitIcon.top + xpnl_ExitIcon.Height) Then
		ClosePage(Me)
	End If
End Sub

#Else
Private Sub xpnl_ExitIcon_Click
	ClosePage(Me)
End Sub
#End If


Private Sub xclv_Main_VisibleRangeChanged (FirstIndex As Int, LastIndex As Int)

	Dim ExtraSize As Int = 10
	For i = 0 To xclv_Main.Size - 1
		Dim p As B4XView = xclv_Main.GetPanel(i)
		If i > FirstIndex - ExtraSize And i < LastIndex + ExtraSize Then
			'visible+
			If p.NumberOfViews = 0 Then
				
				If xclv_Main.GetValue(i) Is AS_Settings_Group Then
					AddInternGroup(p,xclv_Main.GetValue(i))
				else If xclv_Main.GetValue(i) Is AS_Settings_Property_Custom Then
					AddCustomItem2List(p,xclv_Main.GetValue(i),True)
				else If xclv_Main.GetValue(i) Is AS_Settings_Property Then
					AddInternProperty(p,xclv_Main.GetValue(i))
				else If xclv_Main.GetValue(i) Is AS_Settings_SelectionListItem Then
					AddInternSelectionItem(p,xclv_Main.GetValue(i))
				else If xclv_Main.GetValue(i) Is AS_Settings_SpaceItem Then
					AddSpaceItem2List(p,xclv_Main.GetValue(i),True)
				else If xclv_Main.GetValue(i) Is AS_Settings_DescriptionItem Then
					AddDescriptionItem2List(p,xclv_Main.GetValue(i),True)
				Else If xclv_Main.GetValue(i) = "GroupBorderTop" Then
					AddInternGroupBorder(p,True)
				Else If xclv_Main.GetValue(i) = "GroupBorderBottom" Then
					AddInternGroupBorder(p,False)
				Else If xclv_Main.GetValue(i) = "BottomText" Then
					AddInternBottomText(p)
				Else If xclv_Main.GetValue(i) = "Placeholder" Then
					p.Color = m_Settings.BackgroundColor
				Else If xclv_Main.GetValue(i) = "MadeWithLove" Then
					AdInternMadeWithLove(p)
				End If
				
			End If
		Else
			'not visible
			If p.NumberOfViews > 0 Then
				p.RemoveAllViews '<--- remove the layout
			End If
		End If
	Next

End Sub

#If B4J
Private Sub xlbl_TextField_MouseClicked (EventData As MouseEvent)
	Dim xlbl_TextField As B4XView = Sender 'Ignore
	If m_Settings.HapticFeedback Then XUIViewsUtils.PerformHapticFeedback(xlbl_TextField)
	CallSubDelayed2(m_Settings,"ChooserTextFieldClicked",xclv_Main.GetValue(xclv_Main.GetItemFromView(xlbl_TextField)))
End Sub
#Else
Private Sub xlbl_TextField_Click
	Dim xlbl_TextField As B4XView = Sender 'Ignore
	If  m_Settings.HapticFeedback Then XUIViewsUtils.PerformHapticFeedback(xlbl_TextField)
	CallSubDelayed2(m_Settings,"ChooserTextFieldClicked",xclv_Main.GetValue(xclv_Main.GetItemFromView(xlbl_TextField)))
End Sub
#End If

#If B4I

Private Sub xtf_TextBox_BeginEdit
	Dim xtf_TextBox As B4XView = Sender
	xtf_TextBox.SelectAll
End Sub

#Else If B4A

Private Sub xtf_TextBox_FocusChanged (HasFocus As Boolean)
	Dim xtf_TextBox As B4XView = Sender
	If HasFocus Then
		xtf_TextBox.SelectAll
	End If
End Sub

#End If

Private Sub xtf_TextBox_TextChanged (Old As String, New As String)
	Dim xtf_TextBox As B4XView = Sender
	If xtf_TextBox.IsInitialized = False Or xtf_TextBox.Tag = Null Then Return

	'Dim ValueTypeTextProperties As AS_Settings_ValueTypeTextProperties = xtf_TextBox.Tag
	
'	If ValueTypeTextProperties.InputType = getInputType_IPv4 Then
'		
	'
'		
	''		xtf_TextBox.Text = New
	''		xtf_TextBox.SelectionStart = xtf_TextBox.Text.Length
'		
'	else If ValueTypeTextProperties.InputType = getInputType_IPv6 Then
'		
'	End If

	Dim Property As AS_Settings_Property = xclv_Main.GetValue(xclv_Main.GetItemFromView(xtf_TextBox))
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		AS_Properties.PutProperty(Property.PropertyName,xtf_TextBox.Text)
	End If

	If isReady Then CallSubDelayed3(m_Settings,"ValueChanged",Property,xtf_TextBox.Text)
End Sub

Private Sub GroupHeaderClicked(Group As AS_Settings_Group)
	CallSubDelayed2(m_Settings,"GroupHeaderClicked",Group)
End Sub

#If B4J
Private Sub xpnl_ActionClickPanel_MouseClicked (EventData As MouseEvent)
#Else
Private Sub xpnl_ActionClickPanel_Click
#End If
	Dim xpnl_ActionClickPanel As B4XView = Sender 'Ignore
	If m_Settings.HapticFeedback Then XUIViewsUtils.PerformHapticFeedback(xpnl_ActionClickPanel)
	CallSubDelayed2(m_Settings,"ActionClicked",xclv_Main.GetValue(xclv_Main.GetItemFromView(xpnl_ActionClickPanel)))
End Sub

Private Sub xComboBox_SelectedIndexChanged (Index As Int)
	Dim xComboBox As B4XComboBox = Sender 'Ignore
	Dim xlbl_ComboBox As B4XView = xComboBox.Tag
	xlbl_ComboBox.Text = xComboBox.GetItem(Index)
	
	Dim Property As AS_Settings_Property = xclv_Main.GetValue(xclv_Main.GetItemFromView(xComboBox.mBase))
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		Dim Property_ComboBox As AS_Settings_Property_ComboBox = Property.PropertyType
		If Property_ComboBox.KeyValue.IsInitialized And Property_ComboBox.KeyValue.Size > 0 Then
			AS_Properties.PutProperty(Property.PropertyName,Property_ComboBox.KeyValue.Keys.Get(Index))
			CallSubDelayed3(m_Settings,"ValueChanged",Property,Property_ComboBox.KeyValue.Keys.Get(Index))
			Else
			AS_Properties.PutProperty(Property.PropertyName,xComboBox.GetItem(Index))
			CallSubDelayed3(m_Settings,"ValueChanged",Property,xComboBox.GetItem(Index))
		End If
	End If
	
End Sub

Private Sub SwitchBoolean_ValueChanged (Value As Boolean)
	SwitchBooleanValueChanged(Sender,Value)
End Sub

Private Sub SwitchBooleanValueChanged(SwitchBoolean As B4XSwitch,Value As Boolean)
	Dim Property As AS_Settings_Property = xclv_Main.GetValue(xclv_Main.GetItemFromView(SwitchBoolean.mBase))
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		AS_Properties.PutProperty(Property.PropertyName,Value)
	End If
	
	CallSubDelayed3(m_Settings,"ValueChanged",Property,Value)
End Sub

#IF SETTINGS_SegmentedTab
Private Sub SegmentedTab_TabChanged(index As Int)
	Dim SegmentedTab As ASSegmentedTab = Sender 'Ignore
		Dim Property As AS_Settings_Property = xclv_Main.GetValue(xclv_Main.GetItemFromView(SegmentedTab.mBase))
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		AS_Properties.PutProperty(Property.PropertyName,SegmentedTab.GetValue(index))
	End If
	
	CallSubDelayed3(m_Settings,"ValueChanged",Property,SegmentedTab.GetValue(index))
End Sub
#End If

#If SETTINGS_PlusMinus

Private Sub PlusMinus_LeftClick
	PlusMinusChangeValue(Sender,False)
End Sub

Private Sub PlusMinus_RightClick
	PlusMinusChangeValue(Sender,True)
End Sub

Private Sub PlusMinusChangeValue(PlusMinus As AS_PlusMinus,isAdding As Boolean)
	Dim Property_PlusMinus As AS_Settings_Property_PlusMinus = PlusMinus.Tag
	Dim Property As AS_Settings_Property = xclv_Main.GetValue(xclv_Main.GetItemFromView(PlusMinus.mBase))
	
	Dim FinalValue As Int = 0
	If isAdding Then
		FinalValue = Property.Value + Property_PlusMinus.Increment
	Else
		FinalValue = Property.Value - Property_PlusMinus.Increment
	End If
	
	If FinalValue <= Property_PlusMinus.MaxValue And FinalValue >= Property_PlusMinus.MinValue Then
	
		Property.Value = FinalValue

		Dim xlbl As B4XView = PlusMinus.mBase.Parent.GetView(1)
		xlbl.Text = Property_PlusMinus.Prefix &  FinalValue & Property_PlusMinus.Suffix
	
		Dim ValueWidth As Float = MeasureTextWidth(xlbl.Text,xlbl.Font) +2dip
		
		xlbl.Width = ValueWidth
		xlbl.Left = PlusMinus.mBase.Left - ValueWidth - 10dip
	
	End If
	
	If m_Settings.SaveMode = m_Settings.SaveMode_Automatic Then
		AS_Properties.PutProperty(Property.PropertyName,Property.Value)
	End If
	
	CallSubDelayed3(m_Settings,"ValueChanged",Property,Property.Value)
End Sub

#End If

#If B4I
Private Sub uigesture_pan(state As Int,x As Float, y As Float, obj As Object)

	Select state
		Case 1 'STATE_Begin
			HandleTouch(xpnl_Page.TOUCH_ACTION_DOWN,y)
		Case 2 'STATE_Changed
			HandleTouch(xpnl_Page.TOUCH_ACTION_MOVE,y)
		Case 3 'STATE_End
			HandleTouch(xpnl_Page.TOUCH_ACTION_UP,y)
	End Select
End Sub
#End If

#IF B4A or B4I
#If B4A
Private Sub xpnl_Header_Touch2 (o As Object, ACTION As Int, x As Float, y As Float, motion As Object) As Boolean
#Else
Private Sub HandleTouch(Action As Int, Y As Float) As Boolean
#End If
	Select Action
		Case xpnl_Page.TOUCH_ACTION_DOWN
			m_StartY = y
			m_LastY = y
			Return True
		Case xpnl_Page.TOUCH_ACTION_UP
			If y < m_LastY Then
				ClosePage(Me)
			Else
				xpnl_Page.SetLayoutAnimated(250,0,m_Settings.mBase.Height - xpnl_Page.Height,xpnl_Page.Width,xpnl_Page.Height)
			End If
			Return True
		Case xpnl_Page.TOUCH_ACTION_MOVE
			m_LastY = y
			
			#If B4I
			If isMainPage = False Then
				If y < m_StartY Then
					xclv_Main.sv.As(ScrollView).ScrollEnabled = True
				Else
					xclv_Main.sv.As(ScrollView).ScrollEnabled = False
				End If
			End If
			#End If
			
			xpnl_Page.Top = Max(m_Settings.mBase.Height - xpnl_Page.Height,xpnl_Page.Top + y - m_StartY)
			
			Return True
	End Select
	Return False
End Sub
#End If
#End Region

Private Sub xclv_Main_ScrollChanged (Offset As Int)
	If Offset = 0 Then
		#If B4I
		If isMainPage = False Then xclv_Main.sv.As(ScrollView).ScrollEnabled = False
		#Else

		#End If
	End If
End Sub

#Region CustomDrawProperty

Public Sub CustomDrawProperty_Add(Parent As B4XView,View As B4XView,Width As Float,Height As Float) As B4XView
	
	Parent.AddView(View,0,Parent.Height/2 - Height/2,Width,Height)
	
	For i = Parent.NumberOfViews -1 To 0 Step -1
		
		Parent.GetView(i).Left = IIf(i = (Parent.NumberOfViews-1),Parent.Width - m_Settings.Padding - Parent.GetView(i).Width,Parent.GetView(i+1).Left - m_Settings.Padding - Parent.GetView(i).Width)
		
	Next

	Return View
	
End Sub
'Creates a label view int he style of the textfield
'Event Example:
'Private Sub EventName_Clicked(Property As AS_Settings_Property,View As Object)
'	Log("CustomDrawProperty Chooser Clicked")
'End Sub
Public Sub CustomDrawProperty_AddChooser(Callback As Object, EventName As String) As B4XView
	
	Dim xlbl_TextField As B4XView = CreateLabel("xlbl_CustomDrawTextField")
	xlbl_TextField.SetColorAndBorder(m_Settings.PropertyProperties.FieldBackgroundColor,0,0,m_Settings.PropertyProperties.CornerRadius)
	xlbl_TextField.Font = m_Settings.PropertyProperties.xFont
	xlbl_TextField.SetTextAlignment("CENTER","CENTER")
	xlbl_TextField.Text = ""
'	If Property.DisplayValueText = "" Then
'		xlbl_TextField.Text = Property.Value
'	Else
'		xlbl_TextField.Text = Property.DisplayValueText
'	End If
	'xlbl_TextField.Tag = getValueTypeTextProperties
	xlbl_TextField.TextColor = m_Settings.PropertyProperties.TextColor
	xlbl_TextField.Tag = CreateMap("Callback":Callback,"EventName":EventName)
	Return xlbl_TextField
	
End Sub
'Creates a normal text label without a style
Public Sub CustomDrawProperty_AddText(Callback As Object, EventName As String, Text As String) As B4XView
	
	Dim xlbl_Separator As B4XView = CreateLabel("xlbl_CustomDrawText")
	xlbl_Separator.TextColor = m_Settings.PropertyProperties.TextColor
	xlbl_Separator.Text = Text
	xlbl_Separator.Font = m_Settings.PropertyProperties.xFont
	xlbl_Separator.SetTextAlignment("CENTER","CENTER")
	xlbl_Separator.Tag = CreateMap("Callback":Callback,"EventName":EventName)
	Return xlbl_Separator
	
End Sub
#If B4J
Private Sub xlbl_CustomDrawTextField_MouseClicked (EventData As MouseEvent)
#Else
Private Sub xlbl_CustomDrawTextField_Click
#End If
	Dim xlbl_TextField As B4XView = Sender
	Dim m_Map As Map = xlbl_TextField.Tag
	If xui.SubExists(m_Map.Get("Callback"), m_Map.Get("EventName") & "_Clicked",2) Then
		CallSub3(m_Map.Get("Callback"), m_Map.Get("EventName") & "_Clicked",xclv_Main.GetValue(xclv_Main.GetItemFromView(xlbl_TextField)),xlbl_TextField)
	End If
End Sub

#End Region

#Region Functions

Private Sub ini_xclv(EventName As String,Parent As B4XView,ShowScrollBar As Boolean) As CustomListView
	Dim tmplbl As Label
	tmplbl.Initialize("")
 
	Dim clv As CustomListView
 
	Dim tmpmap As Map
	tmpmap.Initialize
	tmpmap.Put("DividerColor",0x00FFFFFF)
	tmpmap.Put("DividerHeight",0)
	tmpmap.Put("PressedColor",0x00FFFFFF)
	tmpmap.Put("InsertAnimationDuration",0)
	tmpmap.Put("ListOrientation","Vertical")
	tmpmap.Put("ShowScrollBar",xui.IsB4J And isMainPage)
	clv.Initialize(Me,EventName)
	clv.DesignerCreateView(Parent,tmplbl,tmpmap)

	#If B4I
	Do While clv.sv.IsInitialized = False
		'Sleep(0)
	Loop
	Dim sv As ScrollView = clv.sv
	sv.Color = xui.Color_Transparent
	#Else IF B4J
	clv.sv.As(ScrollPane).Style = "-fx-background:transparent;-fx-background-color:transparent;"
	#End If
	
	Return clv
	
End Sub

Private Sub GetGroup(Key As String) As AS_Settings_Group
	For i = 0 To lst_Items.Size -1
		If lst_Items.Get(i) Is AS_Settings_Group Then
			If lst_Items.Get(i).As(AS_Settings_Group).Key = Key Then
				Return lst_Items.Get(i)
			End If
		End If
	Next
	Return Null
End Sub

Private Sub CreateLabel(EventName As String) As B4XView
	Dim lbl As Label
	lbl.Initialize(EventName)
	Return lbl
End Sub

Private Sub CreateImageView(EventName As String) As B4XView
	Dim iv As ImageView
	iv.Initialize(EventName)
	Return iv
End Sub

Private Sub CreateEditText(EventName As String,InputType As String) As B4XView'Ignore
	'Text|Numbers|Decimal
#if B4J
	Dim tf As TextField
	tf.Initialize(EventName)
	CSSUtils.SetStyleProperty(tf, "-fx-padding", "0 0 0 0")
	tf.As(JavaObject).RunMethod("setFocusTraversable", Array As Object(True))
	Return tf
#else if B4A
	Dim tf As EditText
	tf.Initialize(EventName)
	tf.SingleLine = True
	tf.Padding = Array As Int (0, 0, 0, 0)
		Select InputType
			Case m_Settings.InputType_Numeric
				tf.InputType = tf.INPUT_TYPE_NUMBERS
			Case m_Settings.InputType_Decimal
				tf.InputType = tf.INPUT_TYPE_DECIMAL_NUMBERS
		End Select
	Return tf

#else if B4i
	Dim tf As TextField
	tf.Initialize(EventName)
	tf.BorderStyle = tf.STYLE_NONE
	tf.ShowClearButton = False
	tf.Autocorrect = tf.AUTOCORRECT_NO
	Select InputType
		Case m_Settings.InputType_Numeric
			tf.KeyboardType = tf.TYPE_NUMBER_PAD
		Case m_Settings.InputType_Decimal
			tf.KeyboardType = tf.TYPE_NUMBERS_AND_PUNCTUATIONS
	End Select
	Return tf
#end if
End Sub

Private Sub MeasureTextHeight(Text As String, Font1 As B4XFont) As Int 'ignore
#If B4A    
    Private bmp As Bitmap
    bmp.InitializeMutable(2dip, 2dip)
    Private cvs As Canvas
    cvs.Initialize2(bmp)
    Return cvs.MeasureStringHeight(Text, Font1.ToNativeFont, Font1.Size)
#Else If B4i
	Return Text.MeasureHeight(Font1.ToNativeFont)
#Else If B4J
    Dim jo As JavaObject
    jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
    jo.RunMethod("setFont",Array(Font1.ToNativeFont))
    jo.RunMethod("setLineSpacing",Array(0.0))
    jo.RunMethod("setWrappingWidth",Array(0.0))
    Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
    Return Bounds.RunMethod("getHeight",Null)
#End If
End Sub

Private Sub MeasureMultilineTextHeight(xLabel As B4XView) As Double
	#If B4J
	'https://www.b4x.com/android/forum/threads/measure-multiline-text-height.84331/#content
	Dim jo As JavaObject = Me
	Return jo.RunMethod("MeasureMultilineTextHeight", Array(xLabel.Font, xLabel.Text, xLabel.Width))
	#Else if B4A
	Dim su As StringUtils
	Return su.MeasureMultilineTextHeight(xLabel,xLabel.Text)
	#Else if B4I
	Dim tmpLabel As Label
	tmpLabel.Initialize("")
	tmpLabel.Font = xLabel.Font
	tmpLabel.Width = xLabel.Width
	tmpLabel.Text = xLabel.Text
	tmpLabel.Multiline = True
	tmpLabel.SizeToFit
	Return tmpLabel.Height
	#End IF
End Sub

#If B4J
#if Java
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import javafx.scene.text.Font;
import javafx.scene.text.TextBoundsType;
public static double MeasureMultilineTextHeight(Font f, String text, double width) throws Exception {
  Method m = Class.forName("com.sun.javafx.scene.control.skin.Utils").getDeclaredMethod("computeTextHeight",
  Font.class, String.class, double.class, TextBoundsType.class);
  m.setAccessible(true);
  return (Double)m.invoke(null, f, text, width, TextBoundsType.LOGICAL_VERTICAL_CENTER);
  }
#End If
#End If

Private Sub MeasureTextWidth(Text As String, Font1 As B4XFont) As Int 'Ignore
#If B4A
    Private bmp As Bitmap
    bmp.InitializeMutable(2dip, 2dip)
    Private cvs As Canvas
    cvs.Initialize2(bmp)
    Return cvs.MeasureStringWidth(Text, Font1.ToNativeFont, Font1.Size)
#Else If B4i
	Return Text.MeasureWidth(Font1.ToNativeFont)
#Else If B4J
    Dim jo As JavaObject
    jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
    jo.RunMethod("setFont",Array(Font1.ToNativeFont))
    jo.RunMethod("setLineSpacing",Array(0.0))
    jo.RunMethod("setWrappingWidth",Array(0.0))
    Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
	Return Bounds.RunMethod("getWidth",Null)
#End If
End Sub

Private Sub SetCircleClip (pnl As B4XView,radius As Int)'ignore
#if B4J
	Dim jo As JavaObject = pnl
	Dim shape As JavaObject
	Dim cx As Double = pnl.Width
	Dim cy As Double = pnl.Height
	shape.InitializeNewInstance("javafx.scene.shape.Rectangle", Array(cx, cy))
	If radius > 0 Then
		Dim d As Double = radius
		shape.RunMethod("setArcHeight", Array(d))
		shape.RunMethod("setArcWidth", Array(d))
	End If
	jo.RunMethod("setClip", Array(shape))
#else if B4A
	Dim jo As JavaObject = pnl
	jo.RunMethod("setClipToOutline", Array(True))
	pnl.SetColorAndBorder(pnl.Color,0,0,radius)
	#Else If B4I
	Dim NaObj As NativeObject = pnl
	Dim BorderWidth As Float = NaObj.GetField("layer").GetField("borderWidth").AsNumber
	' *** Get border color ***
	Dim nome As NativeObject = Me
	Dim BorderUIColor As Int = nome.UIColorToColor (nome.RunMethod ("borderColor:", Array (pnl)))
	pnl.SetColorAndBorder(pnl.Color,BorderWidth,BorderUIColor,radius)
#end if
End Sub

#End Region

#Region Types

Private Sub CreateAS_Settings_Group (Key As String, Name As String, Properties As List) As AS_Settings_Group
	Dim t1 As AS_Settings_Group
	t1.Initialize
	t1.Key = Key
	t1.Name = Name
	t1.Properties = Properties
	Return t1
End Sub

Private Sub CreateAS_Settings_PropertyViews (RootBackgroundPanel As B4XView, LeftBackgroundPanel As B4XView, RightBackgroundPanel As B4XView, IconImageView As B4XView, NameLabel As B4XView,DescriptionLabel As B4XView) As AS_Settings_PropertyViews
	Dim t1 As AS_Settings_PropertyViews
	t1.Initialize
	t1.RootBackgroundPanel = RootBackgroundPanel
	t1.LeftBackgroundPanel = LeftBackgroundPanel
	t1.RightBackgroundPanel = RightBackgroundPanel
	t1.IconImageView = IconImageView
	t1.NameLabel = NameLabel
	t1.DescriptionLabel = DescriptionLabel
	Return t1
End Sub

Private Sub CreateAS_Settings_CustomDrawProperty (Group As AS_Settings_Group, Property As AS_Settings_Property, PropertyViews As AS_Settings_PropertyViews, PropertySettingViews As AS_Settings_PropertySettingViews) As AS_Settings_CustomDrawProperty
	Dim t1 As AS_Settings_CustomDrawProperty
	t1.Initialize
	t1.Group = Group
	t1.Property = Property
	t1.PropertyViews = PropertyViews
	t1.PropertySettingViews = PropertySettingViews
	Return t1
End Sub

#End Region

#IF B4I

Private Sub AddPanGesture(MinimumTouch As Int, MaximumTouch As Int)
	mView = xpnl_Header
	nome.RunMethod("grPan:::",Array(xpnl_Header,MinimumTouch,MaximumTouch))
	mView2 = xclv_Main.GetBase
	nome.RunMethod("grPan:::",Array(xclv_Main.GetBase,MinimumTouch,MaximumTouch))
End Sub

#End If

#If OBJC

/////////// PAN ///////////

-(void)grPan :(UIView*)v :(int)mintouch :(int)maxtouch
{
UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(handlePan:)];
 
 [pan setMaximumNumberOfTouches:maxtouch];
 [pan setMinimumNumberOfTouches:mintouch];
pan.delegate=self;
 [v addGestureRecognizer:pan];

}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {  

	int st =gestureRecognizer.state;
float x= [gestureRecognizer locationInView:(self._mview).object].x;
float y= [gestureRecognizer locationInView:(self._mview).object].y;

    [self.bi raiseEvent:nil event:@"uigesture_pan::::" params:@[@((int)st),@((float)x),@((float)y),(gestureRecognizer)]];

  }  

-(void)grPan2 :(UIView*)v :(int)mintouch :(int)maxtouch
{
UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(handlePan:)];
 
 [pan setMaximumNumberOfTouches:maxtouch];
 [pan setMinimumNumberOfTouches:mintouch];
pan.delegate=self;
 [v addGestureRecognizer:pan];

}

- (void)handlePan2:(UIPanGestureRecognizer *)gestureRecognizer {  

	int st =gestureRecognizer.state;
float x= [gestureRecognizer locationInView:(self._mview2).object].x;
float y= [gestureRecognizer locationInView:(self._mview2).object].y;

    [self.bi raiseEvent:nil event:@"uigesture_pan::::" params:@[@((int)st),@((float)x),@((float)y),(gestureRecognizer)]];

  }  

#End If