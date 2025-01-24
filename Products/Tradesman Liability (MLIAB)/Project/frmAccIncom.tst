<?xml version="1.0" encoding="utf-8"?>
<screen name="frmAccIncom.tst" type="NextPrevious">
    <backColor>
        <r>212</r>
        <g>208</g>
        <b>200</b>
    </backColor>
    <boundScreen />
    <caption>Personal Accident and Income Protection</caption>
    <description>Personal Accident and Income Protection</description>
    <screenType>0</screenType>
    <projectType>1</projectType>
    <postQuoteNavigationDuplicated>False</postQuoteNavigationDuplicated>
    <foreColor>
        <r>0</r>
        <g>0</g>
        <b>0</b>
    </foreColor>
    <height>588</height>
    <parentID />
    <text>Personal Accident and Income Protection</text>
    <width>810</width>
    <defaultFont>
        <bold>False</bold>
        <fontName>Tahoma</fontName>
        <formLoadCode />
        <formValidateCode />
        <italic>False</italic>
        <size>8.25</size>
        <strikeout>False</strikeout>
        <underline>False</underline>
    </defaultFont>
    <controls>
        <control name="txtPeopleNum" type="WisTextBox">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <TextChangedCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmPAPeople.tst</boundScreen>
                    <control>cboTitle</control>
                    <enable>True</enable>
                    <symbol>Greater</symbol>
                    <threshold>0</threshold>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmPAPeople.tst</boundScreen>
                    <control>mskDateOfBirth</control>
                    <enable>True</enable>
                    <symbol>Greater</symbol>
                    <threshold>0</threshold>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmPAPeople.tst</boundScreen>
                    <control>optUKResidentYN</control>
                    <enable>True</enable>
                    <symbol>Greater</symbol>
                    <threshold>0</threshold>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmPAPeople.tst</boundScreen>
                    <control>txtForenames</control>
                    <enable>True</enable>
                    <symbol>Greater</symbol>
                    <threshold>0</threshold>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmPAPeople.tst</boundScreen>
                    <control>txtSurname</control>
                    <enable>True</enable>
                    <symbol>Greater</symbol>
                    <threshold>0</threshold>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmAccIncom.tst</boundScreen>
                    <control>lvwPAPIPeopleList</control>
                    <enable>True</enable>
                    <symbol>Greater</symbol>
                    <threshold>0</threshold>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmAccIncom.tst</boundScreen>
                    <control>grpPAAndPI</control>
                    <enable>True</enable>
                    <symbol>Greater</symbol>
                    <threshold>0</threshold>
                </enableControl>
            </enableControls>
            <sumTotalControls />
            <acceptsTab>False</acceptsTab>
            <acceptsReturn>False</acceptsReturn>
            <backColor>
                <r>255</r>
                <g>255</g>
                <b>255</b>
            </backColor>
            <borderStyle>1</borderStyle>
            <boundScreen />
            <characterCasing>0</characterCasing>
            <columnName>PEOPLENUM</columnName>
            <description>PeopleNum</description>
            <decimalPlaces>0</decimalPlaces>
            <useDecimalPlaces>False</useDecimalPlaces>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>21</height>
            <left>367</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>32767</maxLength>
            <multiLine>False</multiLine>
            <numeric>True</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>4</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>226</top>
            <width>89</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Number of Employees Covered by Personal Accident and Income Protection</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>False</alwaysVisible>
            <startYear />
            <endYear />
            <controls />
        </control>
        <control name="cboIncomeCover" type="WisComboBox">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <TextChangedCode />
            <SelectedIndexChangedCode />
            <enableControls />
            <backColor>
                <r>255</r>
                <g>255</g>
                <b>255</b>
            </backColor>
            <boundScreen />
            <columnName>MH_PAINCOMEPROTECTIONLEVEL_ID</columnName>
            <description>Income Cover</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>21</height>
            <left>367</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <listTable>LIST_MH_PAIncomeProtectionLevel</listTable>
            <maxLength>0</maxLength>
            <numeric>False</numeric>
            <rightToLeft>0</rightToLeft>
            <tabIndex>3</tabIndex>
            <userFilled>False</userFilled>
            <filteredDropdown />
            <text />
            <top>164</top>
            <width>292</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Income Protection Cover Level</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>False</alwaysVisible>
            <controls />
        </control>
        <control name="grpPAAndPI" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>192</height>
            <left>70</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>5</tabIndex>
            <text>People Covered</text>
            <top>298</top>
            <width>619</width>
            <controls>
                <control name="cmdRemoveButton" type="WisButton">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <description>RemoveButton</description>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>30</height>
                    <left>227</left>
                    <listView>lvwPAPIPeopleList</listView>
                    <top>145</top>
                    <tabIndex>9</tabIndex>
                    <type>5</type>
                    <text>    &amp;Remove</text>
                    <width>100</width>
                </control>
                <control name="cmdEditButton" type="WisButton">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <description>EditButton</description>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>30</height>
                    <left>121</left>
                    <listView>lvwPAPIPeopleList</listView>
                    <top>145</top>
                    <tabIndex>8</tabIndex>
                    <type>4</type>
                    <text>  &amp;Edit</text>
                    <width>100</width>
                </control>
                <control name="cmdAddButton" type="WisButton">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <description>AddButton</description>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>30</height>
                    <left>15</left>
                    <listView>lvwPAPIPeopleList</listView>
                    <top>145</top>
                    <tabIndex>7</tabIndex>
                    <type>3</type>
                    <text>  &amp;Add</text>
                    <width>100</width>
                </control>
                <control name="lvwPAPIPeopleList" type="WisListView">
                    <columns>
                        <column>
                            <text>Title</text>
                            <Width>50</Width>
                            <bindControl>cboTitle</bindControl>
                        </column>
                        <column>
                            <text>Forenames</text>
                            <Width>150</Width>
                            <bindControl>txtForenames</bindControl>
                        </column>
                        <column>
                            <text>Surname</text>
                            <Width>200</Width>
                            <bindControl>txtSurname</bindControl>
                        </column>
                        <column>
                            <text>Date Of Birth</text>
                            <Width>100</Width>
                            <bindControl>mskDateOfBirth</bindControl>
                        </column>
                        <column>
                            <text>U.K. Resident</text>
                            <Width>105</Width>
                            <bindControl>optUKResidentYN</bindControl>
                        </column>
                    </columns>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen>MLIAB\frmPAPeople.tst</boundScreen>
                    <description>PAPIPeopleList</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>119</height>
                    <left>6</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>6</tabIndex>
                    <text />
                    <top>20</top>
                    <width>607</width>
                    <controls />
                </control>
            </controls>
        </control>
        <control name="WisLabel4" type="WisLabel">
            <sumTotalControls />
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <borderStyle>0</borderStyle>
            <boundScreen />
            <boundTransform />
            <description>txtPeopleNum</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>45</height>
            <left>68</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>0</tabIndex>
            <text>What is the total number of people you want to cover for Personal Accident and Income Protection?</text>
            <textAlign>1</textAlign>
            <top>226</top>
            <width>242</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="WisLabel3" type="WisLabel">
            <sumTotalControls />
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <borderStyle>0</borderStyle>
            <boundScreen />
            <boundTransform />
            <description>cboIncomeCover</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>37</height>
            <left>68</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>0</tabIndex>
            <text>What Level of Income protection would you like to add?</text>
            <textAlign>1</textAlign>
            <top>167</top>
            <width>242</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="cboAccidentCover" type="WisComboBox">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <TextChangedCode />
            <SelectedIndexChangedCode />
            <enableControls />
            <backColor>
                <r>255</r>
                <g>255</g>
                <b>255</b>
            </backColor>
            <boundScreen />
            <columnName>MH_PERSONALACCIDENTLEVEL_ID</columnName>
            <description>coverLevel</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>21</height>
            <left>368</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <listTable>LIST_MH_PersonalAccidentLevel</listTable>
            <maxLength>0</maxLength>
            <numeric>False</numeric>
            <rightToLeft>0</rightToLeft>
            <tabIndex>2</tabIndex>
            <userFilled>False</userFilled>
            <filteredDropdown />
            <text />
            <top>118</top>
            <width>291</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Personal Accident Cover Level</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>False</alwaysVisible>
            <controls />
        </control>
        <control name="WisLabel2" type="WisLabel">
            <sumTotalControls />
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <borderStyle>0</borderStyle>
            <boundScreen />
            <boundTransform />
            <description>cboAccidentCover</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>50</height>
            <left>68</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>0</tabIndex>
            <text>What level of Personal Accident would you like to add?</text>
            <textAlign>1</textAlign>
            <top>121</top>
            <width>267</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optCoverYN" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmAccIncom.tst</boundScreen>
                    <control>cboAccidentCover</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmAccIncom.tst</boundScreen>
                    <control>cboIncomeCover</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmAccIncom.tst</boundScreen>
                    <control>txtPeopleNum</control>
                    <enable>True</enable>
                </enableControl>
            </enableControls>
            <displayPages>
                <displayPage>
                    <pageName>frmPAPeople.tst</pageName>
                    <display>True</display>
                </displayPage>
            </displayPages>
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <borderStyle>0</borderStyle>
            <boundScreen />
            <columnName>COVERYN</columnName>
            <description>PersonalAccident</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>368</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <rightToLeft>0</rightToLeft>
            <tabIndex>1</tabIndex>
            <text />
            <top>56</top>
            <width>93</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Include Personal Accident and Income Protection Cover</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>True</alwaysVisible>
            <controls />
        </control>
        <control name="WisLabel1" type="WisLabel">
            <sumTotalControls />
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <borderStyle>0</borderStyle>
            <boundScreen />
            <boundTransform />
            <description>optCoverYN</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>38</height>
            <left>68</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>0</tabIndex>
            <text>Would you like to include Personal Accident and Income Protection Cover?</text>
            <textAlign>1</textAlign>
            <top>59</top>
            <width>273</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
    </controls>
    <generalSummary>
        <columns />
    </generalSummary>
    <formValidation>
        <validation>
            <controlToValidate>txtPeopleNum</controlToValidate>
            <operatorType>Not Equal To</operatorType>
            <comparisonType>ObjectCount</comparisonType>
            <validationValue>MLIAB\frmPAPeople.tst,Add,0</validationValue>
            <displayMessage>Please validate People Covered</displayMessage>
        </validation>
        <validation>
            <controlToValidate>txtPeopleNum</controlToValidate>
            <operatorType>Equal To</operatorType>
            <comparisonType>StaticValue</comparisonType>
            <validationValue>0</validationValue>
            <displayMessage>You have not entered any people covered.</displayMessage>
        </validation>
    </formValidation>
    <hideClaim />
</screen>